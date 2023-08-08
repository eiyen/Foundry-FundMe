// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 导入 Foundry 脚本标准库
import "forge-std/Script.sol";
import "../test/mocks/MockV3Aggregator.sol";

// 合约目标：
// 1. 确认当前网络。
// 2. 获取当前网络下的喂价合约的地址。
contract HelperConfig is Script {
	// 定义一个实例，用来存储从喂价合约中读取到的信息
	NetworkConfig public networkConfig;
    uint8 public constant DECIMALS = 8;
	int256 public constant INITIAL_ANSWER = 2000e8;
	// 定义一个结构体，其中的成员变量用于存储喂价合约的地址
	struct NetworkConfig {
		address priceFeedContractAddress;
	}
	
	// 定义构造函数，它的作用有两点：
	// 1. 通过全局变量 block.chainid 确定当前网络。
	// 2. 根据当前网络，调用获取对应网络的喂价合约地址的函数。
	constructor() {
		if (block.chainid == 1) { // 主网
			networkConfig = getMainnetConfig();
		} else if (block.chainid == 5) { // Goerli 测试网
			networkConfig = getGoerliConfig();
		} else if (block.chainid == 11155111) { // Sepolia 测试网
			networkConfig = getSepoliaConfig();
		} else if (block.chainid == 31337) { // 本地网络
            networkConfig = createOrGetAnvilConfig();
        }
	}
	
	// 获取主网中喂价合约的数据
    function getMainnetConfig() public pure returns(NetworkConfig memory) {
    	// 结构体要点：
    	// 1. 在函数中创建结构体时，需要使用 memory 关键字
    	// 2. 结构体的赋值语法为：<结构体类型>({<成员名称>: <成员的值>})
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeedContractAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }
    
    // 获取 Goerli 测试网中喂价合约的数据
    function getGoerliConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory goerliConfig = NetworkConfig({
            priceFeedContractAddress: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        });
        return goerliConfig;
    }
	
	// 获取 Sepolia 测试网中喂价合约的数据
    function getSepoliaConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedContractAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    // 在本地网络部署模拟喂价合约，并获取其数据
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