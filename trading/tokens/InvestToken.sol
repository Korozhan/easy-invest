pragma solidity ^0.4.0;

import "../common/SafeMath.sol";
import "./MintableToken.sol";
import "../Investor.sol";
import "../Trader.sol";
import "../Fond.sol";


/**
 * Global smart contract that release a new tokens
 * and keep token balans for actors in the system.
 */
contract InvestToken is MintableToken {

    using SafeMath for uint256;

    string public constant name = "Invest Token";
    string public constant symbol = "EasyInvest";
    uint8 public constant decimals = 18;

    Investor[] public investors;
    Trader[] public traders;
    Fond[] public fonds;
    
    mapping(address => uint8) investorsId;
    mapping(address => uint8) tradersId;
    mapping(address => uint8) fondsId;

    uint256 public rate;
    // true for finalised trading
    bool public isFinalized;
    // address where funds are collected
    address public wallet;

    constructor() public {
    }

    function invest(address _to, uint256 _value) public returns (bool) {
        if (investorsId[msg.sender] != 0) {
            require(!isFinalized);
            require(fondsId[_to] != 0);
            Fond fond = fonds[fondsId[_to]];
            require(fond.isRunning());
            require(_value <= balances[msg.sender]);
            super.transfer(_to, _value);
            Transfer(msg.sender, _to, _value);
        }
        return true;
    }
}
