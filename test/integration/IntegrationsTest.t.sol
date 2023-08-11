// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMeScript} from "../../script/FundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    uint256 public constant TRADING_FUNDS = 0.01 ether;
    FundMe fundMe;

    function setUp() public {
        FundMeScript fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run();
        console.log(fundMe.getOwner().balance);
        console.log(address(fundMe).balance);
    }
    
    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(fundMe);

        assertEq(address(fundMe).balance, TRADING_FUNDS);
    }

    function testUsersCanFundAndOwnerCanWithdraw() public {
        uint160 fundersAmount = 10;
        uint160 initialFunderIndex = 1;
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        for (
            uint160 funderIndex = initialFunderIndex; 
            funderIndex <= fundersAmount; 
            funderIndex++
        ) {
            hoax(address(funderIndex));
            fundMe.fund{value: TRADING_FUNDS}();
        }
        
        withdrawFundMe.withdrawFundMe(fundMe);

        assertEq(fundMe.getOwner().balance - startingOwnerBalance, fundersAmount * TRADING_FUNDS - startingContractBalance);
    }
}