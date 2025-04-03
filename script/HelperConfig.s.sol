//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
        uint256 blockConfirmations;
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8; // 2000.00

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
                blockConfirmations: 4
            });
        } else if (block.chainid == 1) {
            activeNetworkConfig = NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,
                blockConfirmations: 6
            });
        } else {
            if (activeNetworkConfig.priceFeed == address(0)) {
                vm.startBroadcast();
                MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
                    DECIMALS,
                    INITIAL_PRICE
                );
                vm.stopBroadcast();
                activeNetworkConfig = NetworkConfig({
                    priceFeed: address(mockV3Aggregator),
                    blockConfirmations: 1
                });
            }
        }
    }
}
