// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ManagedToken is ERC20, Ownable {
    mapping(address => bool) private whitelist;
    mapping(address => address[]) private interactions;

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

    function isWhitelisted(address wallet) public view returns (bool) {
        return whitelist[wallet];
    }

    function blacklistWallet(address wallet) external onlyOwner {
        require(whitelist[wallet], "Wallet is already blacklisted");
        _updateStateForInteractions(wallet, false);
    }

    function whitelistWallet(address wallet) external onlyOwner {
        require(!whitelist[wallet], "Wallet is already whitelisted");
        _updateStateForInteractions(wallet, true);
    }

    function _updateStateForInteractions(address wallet, bool state) private {
        // Directly update the state of all wallets that have interacted with wallet
        for (uint256 i = 0; i < interactions[wallet].length; i++) {
            address peer = interactions[wallet][i];
            whitelist[peer] = state;
            if (state) {
                emit WalletWhitelisted(peer);
            } else {
                emit WalletBlacklisted(peer);
            }
        }

        // Update the state of the wallet itself
        whitelist[wallet] = state;
        if (state) {
            emit WalletWhitelisted(wallet);
        } else {
            emit WalletBlacklisted(wallet);
        }
    }
}
