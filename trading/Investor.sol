pragma solidity ^0.4.15;

import "./common/SafeMath.sol";
import "./tokens/Ownable.sol";
import "./tokens/BasicToken.sol";
import "./tokens/InvestToken.sol";

contract Investor is BasicToken, Ownable {

    using SafeMath for uint256;

    address public investor;
    string public name;

    /**
     * Global smart contract that release a new tokens
     * and keep token balans for actors in the system,
     */
    InvestToken public investToken;

    function Investor(address _investToken, string _name) public {
        require(
            _investToken != address(0),
            "Invest token address is required");
        require(
            bytes(_name).length != 0,
            "Trader is required");
        investToken = InvestToken(_investToken);
        name = _name;
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
            investToken.invest(_fond, _tokens);
        }
        return true;
    }
}
