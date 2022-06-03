//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract ReentrancyGuardBank {
    bool locked = false;

    mapping (address => uint) private userBalances;

    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw() external reentrancyGuard {
        uint userBalance = userBalances[msg.sender];

        require(userBalance > 0, "User balance insufficient for withdrawal");

        // calls msg.sender's receive() or fallback() function
        (bool success, bytes memory payload) = msg.sender.call{value: userBalance}("");
        require(success, string(payload));
        
        userBalances[msg.sender] = 0;
    }

    modifier reentrancyGuard() {
        require(!locked);
        locked = true;

        _;

        locked = false;
    }
}
