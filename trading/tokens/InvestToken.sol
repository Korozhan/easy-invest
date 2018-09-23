pragma solidity ^0.4.0;

import "./common/SafeMath.sol";
import "./MintableToken.sol";

contract InvestToken is MintableToken {

    using SafeMath for uint256;

    string public constant name = "Invest Token";
    string public constant symbol = "EasyInvest";
    uint8 public constant decimals = 18;
    mapping(address => uint8) investors;
    mapping(address => uint8) traders;
    mapping(address => uint8) fonds;

    uint256 public rate;
    // true for finalised trading
    bool public isFinalized;
    // address where funds are collected
    address public wallet;

    function InvestToken() public {
    }


    function invest(address _to, uint256 _value) public returns (bool) {
        if (investors[msg.sender] != 0) {
            require(!isFinalized);
            require(fonds[_to] != 0);
            require(_value <= balances[msg.sender]);
            super.transfer(_to, _value);
            Transfer(msg.sender, _to, _value);
        }
        return true;
    }


}
