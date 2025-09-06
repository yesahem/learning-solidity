// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// what we have to do
// 1. Get funds from user
// 2. Withdraw funds
// 3. Set a minimum funding value in USD

contract Fundme {
    // fund function will be responsible to fund eth

    AggregatorV3Interface internal dataFeed;

    uint256 constant minimumDonatedValueInUSD = 10 * 1e18; //minimum 10$ should be donated (like 10 to the 18 decimals, thats what 1e18 do)

    constructor() {
        dataFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (uint256) {
        (
            ,
            /* uint80 roundId */
            int256 answer,
            ,
            ,

        ) = /*uint256 startedAt*/
            /*uint256 updatedAt*/
            /*uint80 answeredInRound*/
            dataFeed.latestRoundData();
        return uint256(answer);
    }

    function fund() public payable {
        // payable keyword --> enables eth transfer b/w accounts

        require(getConversionRate(msg.value)>= minimumDonatedValueInUSD, "Not enough fund is provided"); // 1e18 is equals to 1000000000000000000 wei  = 1000000000 Gwei
        // wei is the smallest ether unit
    }

    // withdraw function is responsible to take out the funded eth to the wallet address
    function withdraw() public {}


    function getConversionRate(uint256 ethAmountinWei) internal view returns (uint256){
        uint256 currentETHPriceInUSD = getChainlinkDataFeedLatestAnswer();
        uint256 finalizedPriceOfETH = (currentETHPriceInUSD * ethAmountinWei)/1e10;
        return uint256(finalizedPriceOfETH);
    }
}
