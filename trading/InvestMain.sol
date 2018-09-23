pragma solidity ^0.4.0;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./Investor.sol";
import "./Trader.sol";
import "./Fond.sol";

contract InvestMain is Ownable {

    using SafeMath for uint256;

    Investor[] public investors;

    mapping(address => uint256) public investorId;

    Trader[] public traders;

    mapping(address => uint256) public traderId;

    Fond[] public fonds;

    mapping(address => uint256) public fondId;

    InvestToken public token;
    // amount of raised money in platform token
    uint256 public raised;
    // how many token units a buyer gets per wei
    uint256 public rate;

    /**
     * @dev On changed membership
     * @param member Account address
     * @param isMember Is account member now
     */
    event MembershipChanged(address indexed member, bool indexed isMember);

    function InvestMain() {
        rate = 1;
    }

    function addInvestor(address targetInvestor, string investorName) public onlyOwner {
        require(investorId[targetInvestor] == 0);

        investorId[targetInvestor] = investors.length;
        Investor investor = new Investor({investor : targetInvestor,
            investorSince : now,
            name : investorName});
        investors.push(investor);


        MembershipChanged(targetInvestor, true);
    }

    function removeInvestor(address targetInvestor) public onlyOwner {
        require(investorId[targetInvestor] != 0);

        uint256 targetId = investorId[targetInvestor];
        uint256 lastId = investors.length - 1;

        // Move last member to removed position
        Investor memory moved = investors[lastId];
        investors[targetId] = moved;
        investorId[moved.investor] = targetId;

        // Clean up
        investorId[targetInvestor] = 0;
        delete investors[lastId];
        --investors.length;

        MembershipChanged(targetInvestor, false);
    }

    function addFunds(address targetInvestor, uint256 amount) {
        require(investorId[targetInvestor] != 0);
        uint256 tokens = amount.mul(rate);
        token.mint(owner, tokens);
        raised = raised.add(amount);
        return true;
    }

    function addTrader(address targetTrader, string traderName) public onlyOwner {
        require(traderId[targetTrader] == 0);

        traderId[targetTrader] = traders.length;
        Trader trader = new Trader({trader : targetTrader,
            traderSince : now,
            name : traderName});
        traders.push(trader);


        MembershipChanged(targetTrader, true);
    }

    function removeTrader(address targetTrader) public onlyOwner {
        require(traderId[targetTrader] != 0);

        uint256 targetId = traderId[targetTrader];
        uint256 lastId = traders.length - 1;

        // Move last member to removed position
        Trader memory moved = traders[lastId];
        traders[targetId] = moved;
        traderId[moved.trader] = targetId;

        // Clean up
        traderId[targetTrader] = 0;
        delete traders[lastId];
        --traders.length;

        MembershipChanged(targetTrader, false);
    }

    function addFond(address targetFond, string fondName) public onlyOwner {
        require(fondId[targetFond] == 0);

        traderId[targetFond] = fonds.length;
        Fond fond = new Fond({fond : targetFond,
            fondSince : now,
            name : fondName});
        fonds.push(fond);


        MembershipChanged(targetFond, true);
    }

    function removeTrader(address targetFond) public onlyOwner {
        require(fondId[targetFond] != 0);

        uint256 targetId = fondId[targetTrader];
        uint256 lastId = fonds.length - 1;

        // Move last member to removed position
        Fond memory moved = fonds[lastId];
        fonds[targetId] = moved;
        fondId[moved.fond] = targetId;

        // Clean up
        fondId[targetFond] = 0;
        delete fonds[lastId];
        --fonds.length;

        MembershipChanged(targetFond, false);
    }

    // set new dates for pre-salev (emergency case)
    function setRate(uint256 _rate) public onlyOwner returns (bool) {
        rate = _rate;
        return true;
    }

}
