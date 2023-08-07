// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
	NetworkConfig public networkConfig;
	uint8 public constant DECIMALS = 8;
	int256 public constant INITIAL_ANSWER = 2000e8;
	
	struct NetworkConfig {
		address priceFeedContractAddress;
	}
	
	constructor() {
		if (block.chainid == 31337) {
			networkConfig = createOrGetAnvilConfig();
		}
	}
	
	function createOrGetAnvilConfig() public returns(NetworkConfig memory) {
		if (networkConfig.priceFeedContractAddress != address(0)) {
			return networkConfig;
		}
		
		vm.broadcast();
		MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
		
		NetworkConfig memory anvilConfig = NetworkConfig({
			priceFeedContractAddress: address(mockPriceFeed)
		});
		
		return anvilConfig;
	}
}