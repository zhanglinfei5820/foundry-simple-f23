//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "src/FundMe.sol";
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;
    function fundFundMe(address deplyAddress) public {
        vm.startBroadcast();
        // 0.1 ether = 100000000000000000 wei
        FundMe(payable(deplyAddress)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }
    function run() external {
        console.log("Chain ID:", block.chainid);
        address deplyAddress = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(deplyAddress);
    }
}

contract WithDrawFundMe is Script {}
