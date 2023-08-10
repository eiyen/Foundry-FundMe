// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../../src/FundMe.sol";
import "../../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("Corror");
    uint256 constant TRANSFER_AMOUNT = 10 ether;
    uint256 constant ZERO_BALANCE = 0 ether;

    modifier funded() {
        // hoax 是一个 CheetCode, 它相当于两个命令：
        // 1. vm.prank(USER); 假装下一个交易是 USER 发起的
        // 2. deal(USER, 2e128); 设置 USER 账户的余额为 2e128 wei
        hoax(USER);
        fundMe.fund{value: TRANSFER_AMOUNT}();
        _;
    }

    function setUp() public {
        FundMeScript fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run();
    }

    function testMINIMUM_USD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testI_owner() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    /* 测试 fund() 函数 */

    function testFundRevertWithBelowMinimumTransactionAmount() public {
        hoax(USER); // 创建一个地址为 USER 的账户，并赋予其 2e128 Wei 的余额
        vm.expectRevert();
        fundMe.fund{value: 0}();
    }

    function testFundUpdatesAmountFundedOnSuccess() public funded{
        assertEq(fundMe.getAddressToAmountFunded(USER), TRANSFER_AMOUNT);
    }

    function testFundPushFunderOnSuccess() funded public {
        assertEq(fundMe.getFunder(0), USER);
    }

    /* 测试 withdraw() 函数 */

    function testWithdrawRevertWhenCallerIsNotOwner() public funded {
        // 这里的 USER 是提供资金的人，合约所有人是 FundMeTest 合约。
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawSingerFund() public funded {
        // 为什么 getOwner() 的初始余额不为 2e128-1 wei 而不是0？
        hoax(fundMe.getOwner(), ZERO_BALANCE);
        fundMe.withdraw();

        assertEq(fundMe.getOwner().balance, TRANSFER_AMOUNT);
    }

    // Arrange, Act, Assert(AAA) 测试方法论
    // 被称为“准备-执行-断言”模式。
    function testWithdrawMultipulFunds() public {
        // 准备: Arrange
        uint160 fundersAmount = 10;
        uint160 initialFunderIndex = 1;
        for ( uint160 fundersIndex=initialFunderIndex; fundersIndex<=fundersAmount; fundersIndex++) {
            // uint160 包含 160 位，和地址的位数相同，可以被编译器进行类型转换。
            // funderIndex 初始值为 1 而非 0，防止处理 address(0) 时自动回滚。
            hoax(address(fundersIndex));
            fundMe.fund{value: TRANSFER_AMOUNT}();
        }

        // 执行: Act
        // vm.prank(fundMe.getOwner()); 为什么这句话是错的？为什么 owner 余额为 2e128-1？
        hoax(fundMe.getOwner(), 0);
        fundMe.withdraw();

        // 断言：Assert
        assertEq(fundMe.getOwner().balance, fundersAmount * TRANSFER_AMOUNT);
    }

    function testCheaperWithdrawMultipulFunds() public {
        uint160 fundersAmount = 10;
        uint160 initialFunderIndex = 1;
        for ( uint160 fundersIndex=initialFunderIndex; fundersIndex<=fundersAmount; fundersIndex++) {
            hoax(address(fundersIndex));
            fundMe.fund{value: TRANSFER_AMOUNT}();
        }

        hoax(fundMe.getOwner(), 0);
        fundMe.cheaperWithdraw();

        assertEq(fundMe.getOwner().balance, fundersAmount * TRANSFER_AMOUNT);
    }
}
