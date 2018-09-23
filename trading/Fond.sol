pragma solidity ^0.4.15;

import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./Trader.sol";

/**
 * Represents a fond that trader can found
 * for fund-rising. Denotes a quotes portfolio
 * that trader undertakes to buy.
 * 
 */
contract Fond is BasicToken, Ownable {

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
    uint256 public constant TRADING_PERIOD = 1000000;
    /**
     * Number of traders in fond
     */
    uint8 public tradersCount;
    
    /**
     * Time when fond started trading.
     */
    uint256 startTime;
    
    /**
     * Total tokens already fund rised.
     */
    uint256 public fundRisedTokensAmount;
    
    /**
     * Total quotes count to buy
     */
    uint256 public desiredQuotesCount;
    
    /**
     * Mapping of traders, used to check if such trader is already in fond. 
     */
    mapping(address => bool) traders;
    
    /**
     * Mapping to check if such quote symbol already present in portfolio.
     */
    mapping(string => bool) quotesPortfolion;
    /**
     * Mapping of quote symbol to quote parameters, used for trading.
     */
    mapping(string => Quote) quotes;
    
    constructor() {
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
        quotes[_symbol] = Quote({
            symbol: _symbol,
            percent: _percent,
            price: 0
        });
    }
    
    function addTrader(address _trader) onlyOwner public {
        require(
            !isRunning(),
            "You cannot add traders while fond is running");
        require(
            !traders[_trader],
            "Such traders already in fond");
        traders[_trader] = true;
        tradersCount++;
    }
    
    /**
     * Starts tranding. Stop acceptance of new funds from investors.
     * Traders cannot be added until tranding is stopped.
     */
    function startTrading() {
        require(
            !isRunning(), 
            "Fond already is running");
        startTime = now;
        
    }
    
    /**
     * Checks if fond is still alive, i.e. 
     * number of active trades is not zero
     */
    function isAlive() public view returns (bool) {
        return tradersCount > 0;
    }
    
    /**
     * Checks if fond is running or not.
     */
    function isRunning() public view returns(bool) {
        return now - startTime < TRADING_PERIOD;
    }
    
    function getName(address _trader) public view returns (string) {
        require(
                traders[_trader],
                "Such trader doesn't exist");
        return Trader(_trader).name();
    }

}
