// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import OpenZeppelin's ERC-20 implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Create your ERC-20 token contract
contract MyToken is ERC20 {
    /**
     * @dev Constructor that mints an initial supply of tokens to the deployer.
     * @param initialSupply The initial supply of tokens to mint.
     */
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        // Mint the initial supply to the deployer's address
        _mint(msg.sender, initialSupply);
    }
}