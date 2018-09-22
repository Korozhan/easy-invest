pragma solidity ^0.4.15;

import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./Trader.sol";

contract Fond is BasicToken, Ownable {

    constructor() {
    }

    function addTrader(Trader _trader) public {

    }

    function isAlive() public returns (bool) {
        return true;
    }

}
