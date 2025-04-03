//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // Import the FundMe contract
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    // Set up the test environment
    function setUp() external {
        // fundMe = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // Give this contract 10 ether
    }

    function testMininubDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundIsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundDataStructure() public {
        vm.prank(USER); // Simulate a transaction from USER
        fundMe.fund{value: SEND_VALUE}();
        uint amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    modifier funded() {
        vm.prank(USER); // Simulate a transaction from USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testWithdrawNotOwner() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithOwner() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // Check the balance of the owner
        uint256 startingFundMeBalance = address(fundMe).balance; // Check the balance of the FundMe contract
        uint256 gasStart = gasleft(); // Get the current gas left

        vm.startPrank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.withdraw();

        uint256 endOwnerBalance = fundMe.getOwner().balance;
        uint256 endFundMeBalance = address(fundMe).balance;
        assertEq(endFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endOwnerBalance);
    }

    function testWithdrawWithOwnerCheaper() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // Check the balance of the owner
        uint256 startingFundMeBalance = address(fundMe).balance; // Check the balance of the FundMe contract
        uint256 gasStart = gasleft(); // Get the current gas left

        vm.startPrank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.cheaperWithdraw();

        uint256 endOwnerBalance = fundMe.getOwner().balance;
        uint256 endFundMeBalance = address(fundMe).balance;
        assertEq(endFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded {
        uint160 i_startFunderIndex = 1;
        uint160 i_endFunderIndex = 10;
        for (uint160 i = i_startFunderIndex; i < i_endFunderIndex; i++) {
            hoax(address(uint160(i)), SEND_VALUE); // Simulate a transaction from the funder
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // Check the balance of the owner
        uint256 startingFundMeBalance = address(fundMe).balance; // Check the balance of the FundMe contract
        vm.startPrank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.withdraw();
        vm.stopPrank(); // Stop simulating the transaction from the owner
        uint256 endOwnerBalance = fundMe.getOwner().balance;
        assertEq(address(fundMe).balance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endOwnerBalance);
    }

    // // Test the constructor
    // function testConstructor() public {
    //     assertEq(fundMe.i_owner(), address(this));
    // }

    // // Test the fund function
    // function testFund() public payable {
    //     fundMe.fund{value: 1 ether}();
    //     assertEq(fundMe.addressToAmountFunded(address(this)), 1 ether);
    // }

    // // Test the withdraw function
    // function testWithdraw() public {
    //     fundMe.withdraw();
    //     assertEq(fundMe.addressToAmountFunded(address(this)), 0);
    // }
}
