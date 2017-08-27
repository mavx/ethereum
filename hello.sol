pragma solidity ^0.4.13;

contract HelloWorld {
    event Print(string out);
    function() { Print("Hello, World!"); }
}
