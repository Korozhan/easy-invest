pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/BasicToken.sol";
import "./tokens/Ownable.sol";
import "./Fond.sol";

/**
 * @title Trader
 * @dev Mimics a real trader behaviour.
 * He trades and take part in funds.
 */
contract Trader is BasicToken, Ownable {

    using SafeMath for uint256;

    /**
     * Trader's name
     */
    string public name;
    
    Fond public fond; 
    
    /**
     * Create a new Trader with a given name
     */
    constructor(string _name) public {
        name = _name;
    }

    /**
     * Founds a new fond. Allows to have only one fond at time.
     */
    function foundFond() public {
        require(
            fond == address(0x0) || !fond.isAlive(), 
            "You can manage only one fond at time");
        fond = new Fond();
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
    
}
