pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./Investor.sol";
import "./Trader.sol";
import "./Fond.sol";

contract InvestMain is Ownable {

    using SafeMath for uint256;

    Investor[] public investors;
    Trader[] public traders;
    Fond[] public fonds;

    mapping(address => uint256) public investorId;
    mapping(address => uint256) public traderId;
    mapping(address => uint256) public fondId;
    // mintable token
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

    // /**
    //  * Will use after creating logic main app.
    //  */
    // function addInvestor(address targetInvestor, string investorName) public onlyOwner {
    //     require(investorId[targetInvestor] == 0);

    //     investorId[targetInvestor] = investors.length;
    //     investors.push(new Investor(targetInvestor, investorName));

    //     MembershipChanged(targetInvestor, true);
    // }

    // function removeInvestor(address targetInvestor) public onlyOwner {
    //     require(investorId[targetInvestor] != 0);

    //     uint256 targetId = investorId[targetInvestor];
    //     uint256 lastId = investors.length - 1;

    //     // Move last member to removed position
    //     Investor moved = investors[lastId];
    //     investors[targetId] = moved;
    //     investorId[moved] = targetId;

    //     // Clean up
    //     investorId[targetInvestor] = 0;
    //     delete investors[lastId];
    //     --investors.length;

    //     MembershipChanged(targetInvestor, false);
    // }

    function addFunds(address targetInvestor, uint256 amount) returns (bool) {
        // require(investorId[targetInvestor] != 0);
        uint256 tokens = amount.mul(rate);
        token.mint(targetInvestor, tokens);
        raised = raised.add(amount);
        return true;
    }
    
    // /**
    //  * Will use after creating logic main app.
    //  */
    // function addTrader(address targetTrader, string traderName) public onlyOwner {
    //     require(traderId[targetTrader] == 0);

    //     traderId[targetTrader] = traders.length;
    //     traders.push(new Trader(traderName));


    //     MembershipChanged(targetTrader, true);
    // }
    
    // /**
    //  * Will use after creating logic main app.
    //  */
    // function removeTrader(address targetTrader) public onlyOwner {
    //     require(traderId[targetTrader] != 0);

    //     uint256 targetId = traderId[targetTrader];
    //     uint256 lastId = traders.length - 1;

    //     // Move last member to removed position
    //     Trader moved = traders[lastId];
    //     traders[targetId] = moved;
    //     traderId[moved] = targetId;

    //     // Clean up
    //     traderId[targetTrader] = 0;
    //     delete traders[lastId];
    //     --traders.length;

    //     MembershipChanged(targetTrader, false);
    // }

    // set new dates for pre-salev (emergency case)
    function setRate(uint256 _rate) public onlyOwner returns (bool) {
        rate = _rate;
        return true;
    }

}
