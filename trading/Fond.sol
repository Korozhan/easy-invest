pragma solidity ^0.4.15;

import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./Trader.sol";

contract Fond is BasicToken, Ownable {
    
    uint8 tradersCount;
    mapping(address => bool) traders;
    
    constructor() {
        addTrader(msg.sender);
    }
    
    function addTrader(address _trader) onlyOwner public {
        require(
            !traders[_trader],
            "Such traders already in fond");
        traders[_trader] = true;
        tradersCount++;
    }
    
    /**
     * Checks if fond is still alive, i.e. 
     * number of active trades is not zero
     */
    function isAlive() public view returns (bool) {
        return size() > 0;
    }
    
    /**
     * Returns number of active traders in fond.
     */
    function size() public view returns (uint8) {
        return tradersCount;
    } 
    
    function getName(address _trader) public view returns (string) {
        require(
                traders[_trader],
                "Such trader doesn't exist");
        return Trader(_trader).name();
    }
    
}
