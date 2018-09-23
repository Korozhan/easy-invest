pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./tokens/InvestToken.sol";
import "./Trader.sol";

/**
 * Represents a fond that trader can found
 * for fund-rising. Denotes a quotes portfolio
 * that trader undertakes to buy.
 * 
 */
contract Fond is Ownable {

    using SafeMath for uint256;

    /**
     * Quote parameters.
     */
    struct Quote {
        string symbol;
        uint256 price;
        uint256 percent;
    }
    
    /**
     * Time period for trading. During that period
     * fond blocks any fund operations.
     */
    uint256 constant DURATION = 1000000;
    /**
     * Time when fond started trading.
     */
    uint256 start;
    /**
     * Total tokens already fund rised.
     */
    uint256 public fundRisedTokensAmount;
    /**
     * Total bought quotes count.
     */
    uint256 public totalQuotesCount;
    /**
     * Mapping of traders, used to check if such trader is already in fond. 
     */
    mapping(address => bool) tradersMapping;

    Trader[] traders;
    /**
     * Mapping to check if such quote symbol already present in portfolio.
     */
    mapping(string => bool) quotesPortfolion;
    /**
     * Mapping of quote symbol to quote parameters, used for trading.
     */
    mapping(string => Quote) quotesMapping;

    /**
     * Quotes to be interate thru.
     */
    Quote[] quotes;

    /**
     * Mapping quote to amount.
     */
    mapping(string => uint256) quoteAmountMapping;

    /**
     * Controls tokens emission. Allow transfering
     * and distributing tokens accross traders.
     */
    InvestToken investToken;

    event StartTrading();
    event StopTrading();

    constructor(address _investToken) {
        require(
            _investToken != address(0),
            "Invest token address is required");
        investToken = InvestToken(_investToken);
        addTrader(msg.sender);
    }
    
    /**
     * Adds a new quote to fond. Not allow add the same quote several times. 
     */
    function addQuote(string _symbol, uint256 _percent) {
        require(
            bytes(_symbol).length != 0, 
            "Symbol is required");
        require(
            _percent > 0,
            "Quote percent part should be greater");
        require(
            !quotesPortfolion[_symbol], 
            "Such quote already in portfolio");
        quotesPortfolion[_symbol] = true;
        Quote memory quote = Quote({
            symbol: _symbol,
            percent: _percent,
            price: 1/*should be oraclized*/});
        quotes.push(quote);
        quotesMapping[_symbol] = quote;
    }
    
    function addTrader(address _trader) onlyOwner public {
        require(
            !isRunning(),
            "You cannot add traders while fond is running");
        require(
            !tradersMapping[_trader],
            "Such traders already in fond");
        tradersMapping[_trader] = true;
        traders.push(Trader(_trader));
    }
    
    /**
     * Starts tranding. Stop acceptance of new funds from investors.
     * Traders cannot be added until tranding is stopped.
     */
    function startTrading() onlyOwner public {
        require(
            !isRunning(),
            "Fond already is running");
        start = now; // start tranding

        fundRisedTokensAmount = investToken.balanceOf(this);
        uint256 tokensPerPercent = fundRisedTokensAmount.div(100);
        for (uint i = 0; i < quotes.length; ++i) {
            uint256 quoteFund = tokensPerPercent.mul(quotes[i].percent);
            uint256 quoteAmount = quoteFund.div(quotes[i].price);
            quoteAmountMapping[quotes[i].symbol] = quoteAmount;
            totalQuotesCount = totalQuotesCount.add(quoteAmount);
        }
        
        //notify system to convert tokens to cash
        //and redestribute between traders to get started.
        StartTrading();
    }

    /**
     * Stops trading. Calculate profit after trading,
     * redestribute profit between traders.
     */
    function stopTrading() public {
        require(
            start > 0,
            "Trading is not started");
        start = 0;//reset start
        uint256 fund = investToken.balanceOf(this);
        uint256 fundAfterTrading = fund.add(100);
        uint256 profit = fundAfterTrading.add(fund);
        uint256 payout = fund.div(traders.length);

        // redestribute equivalent of profit in tokens among traders
        for(uint i = 0; i < traders.length; ++i) {
            Trader trader = traders[i];
            if(tradersMapping[address(trader)]) {
                investToken.transfer(address(trader), payout);
            }
        }
    }
    
    /**
     * Checks if fond is still alive, i.e. 
     * number of active trades is not zero
     */
    function isAlive() public view returns (bool) {
        return traders.length > 0;
    }
    
    /**
     * Checks if fond is running or not.
     */
    function isRunning() public view returns(bool) {
        return now - start < DURATION;
    }

    function getQuotes(string symbol) public view returns (uint256) {
        require(
            quotesPortfolion[symbol],
            "There is not such qoute in portfolio");
        return quoteAmountMapping[symbol];
    }
    
    function getName(address _trader) public view returns (string) {
        require(
                tradersMapping[_trader],
                "Such trader doesn't exist");
        return Trader(_trader).name();
    }

}
