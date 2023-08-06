// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../src/FundMe.sol";
import "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        // Before: fundMe = new FundMe(<Price_Feed_Address>)
        FundMeScript fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run();
    }

    function testMINIMUM_USD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testI_owner() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // 分叉测试
    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }
}
