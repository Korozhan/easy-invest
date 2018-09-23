pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/BasicToken.sol";
import "./tokens/Ownable.sol";
import "./tokens/InvestToken.sol";
import "./Fond.sol";

/**
 * @title Trader
 * @dev Mimics a real trader behaviour.
 * He trades and take part in funds.
 */
contract Trader is Ownable {

    using SafeMath for uint256;

    address public trader;
    /**
     * Trader's name
     */
    string public name;
    uint256 public traderSince;

    Fond public fond;
    
    /**
     * Global smart contract that release a new tokens
     * and keep token balans for actors in the system,
     */
    InvestToken public investToken;

    /**
     * Create a new Trader with a given name
     */
    constructor(address _investToken, string _name) public {
        require(
            _investToken != address(0),
            "Invest token address is required");
        require(
            bytes(_name).length != 0,
            "Trader is required");
        investToken = InvestToken(_investToken);
        name = _name;
    }

    /**
     * Founds a new fond. Allows to have only one fond at time.
     */
    function foundFond() public {
        require(
            fond == address(0x0) || !fond.isAlive(),
            "You can manage only one fond at time");
        fond = new Fond(investToken);
    }

    /**
     * Invites another trader to fond. 
     */
    function inviteToFond(address _trader) public onlyOwner {
        require(
            fond != address(0x0) && fond.isAlive(), 
            "Fond doesn't exists");
        fond.addTrader(_trader);
    }
    
    function startTrading() {
        require(
            fond != address(0x0) && fond.isAlive(),
            "Fond should be active to start trading");
        fond.startTrading();
    }
    
}
