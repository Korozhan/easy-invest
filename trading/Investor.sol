pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./tokens/InvestToken.sol";

contract Investor is BasicToken, Ownable {

    using SafeMath for uint256;

    address public investor;
    string public name;

    InvestToken public token;

    function Investor() {
        token = new InvestToken();
    }
    
//   function Investor(address _investor, string _name) public {
//         investor = _investor;
//         name = _name;
//     }

    // low level token purchase function
    function transfer(address _fond, uint256 _tokens) public returns(bool) {
        require(_fond != 0x0);
        require(_tokens != 0);

        if (_tokens > 0) {
            token.invest(_fond, _tokens);
        }
        return true;
    }
}
