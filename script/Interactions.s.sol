// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
// import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 public constant TRADING_FUNDS = 0.01 ether;

    function run() public {
        address recentlyDeployedContractAddress = 0xF4276bFB3a2e711aE8E74754d6799E770BBAE211;
        fundFundMe(FundMe(recentlyDeployedContractAddress));
    }

    function fundFundMe(FundMe fundMe) public {
        vm.broadcast();
        fundMe.fund{value: TRADING_FUNDS}();
    }
}


contract WithdrawFundMe is Script {
    uint256 public constant TRADING_FUNDS = 0.01 ether;

    function run() public {
        address recentlyDeployedContractAddress = 0xF4276bFB3a2e711aE8E74754d6799E770BBAE211;
        withdrawFundMe(FundMe(recentlyDeployedContractAddress));
    }

    function withdrawFundMe(FundMe fundMe) public {
        vm.broadcast();
        fundMe.cheaperWithdraw();
    }
}