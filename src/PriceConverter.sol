// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//@chainlink\contracts\src\v0.8\shared\interfaces
// Why is this a library and not abstract?
// Why not an interface?
library PriceConverter {
    function getPrice(
        address _priceFeedAddress
    ) internal view returns (uint256) {
        AggregatorV3Interface aggregatorV3Interface = AggregatorV3Interface(
            _priceFeedAddress
        );
        (
            ,
            /* uint80 roundID */ int answer /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/,
            ,
            ,

        ) = aggregatorV3Interface.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(
        uint ethAmount,
        address _priceFeedAddress
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(_priceFeedAddress);
        uint256 ethsInUsd = (ethPrice * ethAmount) / 1e18;
        return ethsInUsd;
    }
}
