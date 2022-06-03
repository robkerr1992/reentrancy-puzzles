//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract PullPaymentAuction {
    address highestBidder;
    uint highestBid;
    mapping (address => uint) previousBids;

    //
    // CHALLENGE: FIX THE CODE BELOW EMPLOYING THE PULL-PAYMENT PATTERN. NEW CONTRACT
    // VARIABLES MAY NEED TO BE ADDED TO IMPLEMENT THE FIX
    //
    function bid() payable external {
        require(msg.value >= highestBid);

        if (highestBidder != address(0)) {
            previousBids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    //
    // CHALLENGE: IMPLEMENT THE CODE BELOW AS PART OF THE PULL-PAYMENT PATTERN
    //
    function withdrawRefund() external {
        require(previousBids[msg.sender] > 0);

        uint amount = previousBids[msg.sender];
        previousBids[msg.sender] = 0;
        
        payable(msg.sender).transfer(amount);
    }
}
