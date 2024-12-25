// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ManagedToken is ERC20, Ownable {
    mapping(address => bool) private whitelist;
    mapping(address => address[]) private interactions;
    mapping(address => mapping(address => bool)) private hasInteracted;

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

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(whitelist[msg.sender], "Sender is not whitelisted");
        require(whitelist[recipient], "Recipient is not whitelisted");

        // Record the interaction between sender and recipient
        _recordInteraction(msg.sender, recipient);

        return super.transfer(recipient, amount);
    }

    function blacklistWallet(address wallet) external onlyOwner {
        require(whitelist[wallet], "Wallet is already blacklisted");
        _updateStateForInteractions(wallet, false);
    }

    function whitelistWallet(address wallet) external onlyOwner {
        require(!whitelist[wallet], "Wallet is already whitelisted");
        _updateStateForInteractions(wallet, true);
    }

    function _recordInteraction(address wallet1, address wallet2) private {
        if (!hasInteracted[wallet1][wallet2]) {
            hasInteracted[wallet1][wallet2] = true;
            hasInteracted[wallet2][wallet1] = true;

            interactions[wallet1].push(wallet2);
            interactions[wallet2].push(wallet1);
        }
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
