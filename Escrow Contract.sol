// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {

    address public buyer;
    address public seller;
    address public arbiter;

    bool public buyerApproved;
    bool public sellerApproved;

    constructor(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    function approve() external {
        require(msg.sender == buyer || msg.sender == seller, "Not authorized");

        if (msg.sender == buyer) {
            buyerApproved = true;
        } else {
            sellerApproved = true;
        }

        if (buyerApproved && sellerApproved) {
            releaseFunds();
        }
    }

    function releaseFunds() internal {
        payable(seller).transfer(address(this).balance);
    }

    function refundBuyer() external {
        require(msg.sender == arbiter, "Only arbiter");

        uint amount = address(this).balance;

       // payable(buyer).transfer(address(this).balance);

        (bool success,) = payable(buyer).call{value: amount}("");

        require(success,"Transaction Failed");
    }
}