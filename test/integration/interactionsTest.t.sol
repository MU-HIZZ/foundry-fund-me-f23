// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract InteractionsTest is ZkSyncChainChecker, Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        (fundMe, ) = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public skipZkSync {
        // 1. User funds contract via interaction script
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        // 2. Owner withdraws balance via interaction script
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        // 3. Assert balances reset cleanly
        assert(address(fundMe).balance == 0);
    }
}