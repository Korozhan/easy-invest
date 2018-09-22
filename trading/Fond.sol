pragma solidity ^0.4.0;

contract Fond is Ownable{

    Trader[] public traders;

    mapping(address => uint256) public traderId;

    function Fond(){

    }
}
