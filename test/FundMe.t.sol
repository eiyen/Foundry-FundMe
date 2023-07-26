// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe();
    }

    function testMINIMUM_USD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testI_owner() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    // 分叉测试
    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }
}
