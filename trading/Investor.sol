pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./tokens/InvestToken.sol";

contract Investor is BasicToken, Ownable {

    using SafeMath for uint256;

    address public investor;
    string public name;
    uint256 public investorSince;

    InvestToken public token;

    constructor() {
        token = new InvestToken();
    }

    // fallback function can be used to buy tokens
    function() payable {
        transfer(msg.sender);
    }

    function investTokens(address _fond, uint256 ) {
        
    }

    // low level token purchase function
    function transfer(address fond) payable {
        require(fond != 0x0);
        require(msg.value != 0);
        uint256 amount = msg.value;

        if (amount > 0) {
            token.invest(fond, amount);
        }
    }
}
