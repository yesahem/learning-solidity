// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// unlike a contract this is a library
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// a library is always started with library instead of contract keyword
library PriceConverter {
    // in a library all the functions must be internal instead of public

    function getEthPrice() internal view returns (uint256) {
        AggregatorV3Interface dataFeed;

        dataFeed = AggregatorV3Interface(
            // 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43       //--> btc/usd address
            0x694AA1769357215DE4FAC081bf1f309aDC325306 // --> eth/usd address
        );

        (
            ,
            /* uint80 roundId */
            int256 answer, /*uint256 startedAt*/ /*uint256 updatedAt*/
            ,
            ,

        ) = /*uint80 answeredInRound*/
            dataFeed.latestRoundData();
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmountinWei)
        internal
        view
        returns (uint256)
    {
        uint256 currentETHPriceInUSD = getEthPrice();
        uint256 finalizedPriceOfETH = (currentETHPriceInUSD * ethAmountinWei) /
            1e10;
        return uint256(finalizedPriceOfETH);
    }
}
