// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ManagedToken is ERC20, Ownable {
    mapping(address => bool) private whitelist;

    event WalletWhitelisted(address indexed wallet);
    event WalletBlacklisted(address indexed wallet);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address[] memory initialWhitelist
    ) ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * (10 ** decimals()));

        for (uint256 i = 0; i < initialWhitelist.length; i++) {
            whitelist[initialWhitelist[i]] = true;
            emit WalletWhitelisted(initialWhitelist[i]);
        }
    }
}
