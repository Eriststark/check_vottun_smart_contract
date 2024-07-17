pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SendMeATip is ReentrancyGuard {
    // State variable to store the owner of the contract
    address payable public owner;

    // Events to log important actions
    event TipReceived(address from, uint256 amount);
    event OwnerWithdrawal(address to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifier to restrict access to owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the initial owner of the contract
    constructor() {
        owner = payable(msg.sender);
        emit OwnershipTransferred(address(0), owner);
    }

    // Function to send a tip to the contract
    function sendTip() public payable {
        require(msg.value > 0, "Tip must be greater than 0");
        emit TipReceived(msg.sender, msg.value); // Emit event to log the tip received
    }

    // Function for the owner to withdraw all tips from the contract
    function withdrawTips() public onlyOwner nonReentrant {
        uint256 balance = address(this).balance; // Get the contract balance
        require(balance > 0, "No tips to withdraw");
        owner.transfer(balance); // Transfer the balance to the owner
        emit OwnerWithdrawal(owner, balance); // Emit event to log the withdrawal
    }

    // Function to transfer ownership to a new owner
    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner); // Emit event to log the ownership transfer
        owner = newOwner; // Update the owner state variable
    }

    // Receive function to handle plain Ether transfers
    receive() external payable {
        emit TipReceived(msg.sender, msg.value); // Emit event to log the tip received
    }
}

