# Managed Token Project

This project implements a managed ERC20 token with additional features such as whitelisting and blacklisting of wallets. The project uses Hardhat for development, testing, and deployment.
The complete problem statement is available in [this file](Problem_Statement.pdf).

## Contracts

### `contracts/ManagedToken.sol`

The `ManagedToken` contract is an ERC20 token with additional features:

- Whitelisting and blacklisting of wallets.
- Only whitelisted wallets can transfer tokens.
- The owner can add or remove wallets from the whitelist.

## Scripts

### `scripts/deploy.ts`

The `scripts/deploy.ts` script deploys the `ManagedToken` contract to the specified network.

## Configuration

### `hardhat.config.ts`

The Hardhat configuration file specifies the settings for the Hardhat environment, including network configurations and compiler settings.

## Getting Started

### Prerequisites

- Node.js
- npm
- Hardhat

### Installation

1. Clone the repository:

   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Install dependencies:

   ```sh
   npm install
   ```

3. Create a [.env](http://_vscodecontentref_/4) file and add your environment variables:
   ```sh
   TESTNET_ENDPOINT='https://testnet.hashio.io/api'
   TESTNET_OPERATOR_PRIVATE_KEY='your-private-key'
   ```

### Compile Contracts

To compile the contracts, run:

```sh
npx hardhat compile
```

### Deploy Contracts

To deploy the contracts, run:

```sh
npx hardhat run scripts/deploy.ts --network testnet
```
