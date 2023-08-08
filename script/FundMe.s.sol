// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/FundMe.sol";
import "./HelperConfig.s.sol";

contract FundMeScript is Script{
    function run() external returns(FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        
        (address ethUsdPriceFeedAddress) = helperConfig.networkConfig();

        vm.broadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeedAddress);

        return fundMe;
    }
}