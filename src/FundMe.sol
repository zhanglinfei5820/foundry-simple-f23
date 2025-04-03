// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FoundMe_NotOwner();
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    address private priceFeedAddress;

    address private immutable i_owner;

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        priceFeedAddress = _priceFeedAddress;
    }

    modifier onlyOwner() {
        // require(i_owner == msg.sender, "sender is not owner");
        if (i_owner != msg.sender) {
            revert FoundMe_NotOwner();
        }
        _;
    }

    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(priceFeedAddress).version();
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeedAddress) > MINIMUM_USD,
            "You need to spend more ETH!"
        );
        address sender = msg.sender;
        s_funders.push(sender);
        s_addressToAmountFunded[sender] = msg.value;
    }

    function cheaperWithdraw() public payable onlyOwner {
        uint256 fundersCount = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersCount;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(
        address funder
    ) external view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
