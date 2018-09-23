pragma solidity ^0.4.15;

import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./Trader.sol";

contract Fond is BasicToken, Ownable {
    
    uint256 public constant TRADING_PERIOD = 1000000;
    uint8 public tradersCount;
    
    uint256 startTime;
    mapping(address => bool) traders;
    
    struct Quote {
        string symbol;
        uint256 price;
    }
    
    constructor(string _symbol, uint256 price) {
        require(_symbol != '', "Symbol is required");
        require(_price > 0, 'Price is required');
        addTrader(msg.sender);
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
