import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const config: HardhatUserConfig = {
	defaultNetwork: "testnet",
	networks: {
    testnet: {
      url: process.env.TESTNET_ENDPOINT,

      accounts: [process.env.TESTNET_OPERATOR_PRIVATE_KEY? process.env.TESTNET_OPERATOR_PRIVATE_KEY : ""],
    },
	},
	solidity: {
		compilers: [
			{
				version: "0.8.26",
			},
		],
		settings: {
			optimizer: {
				enabled: true,
				runs: 200,
			},
		},
	},
	paths: {
		sources: "./contracts",
		tests: "./test",
		cache: "./build/cache",
		artifacts: "./build/artifacts",
	},
	mocha: {
		timeout: 180000, // 3 mins max for running tests
	},
};

export default config;