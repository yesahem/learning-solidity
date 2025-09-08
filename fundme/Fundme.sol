// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// what we have to do
// 1. Get funds from user
// 2. Withdraw funds
// 3. Set a minimum funding value in USD

contract Fundme {
    // fund function will be responsible to fund eth

    uint256 constant minimumDonatedValueInUSD = 10 * 1e10; //minimum 10$ should be donated (like 10 to the 18 decimals, thats what 1e18 do)
    address[] private  senderAddress;
    mapping(address => uint256) public addressToAmountFunded;



    AggregatorV3Interface  dataFeed = AggregatorV3Interface(
            // 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43       //--> btc/usd address 
            0x694AA1769357215DE4FAC081bf1f309aDC325306          // --> eth/usd address
        );

    function getEthPrice() public   view returns (uint256) {
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
        senderAddress.push(msg.sender);         // this will add all the sender address to the senderAddress list
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;      // this will keep track of history of which person donated how much eth;
    }

    // withdraw function is responsible to take out the funded eth to the wallet address
    function withdraw() public {}


    function getConversionRate(uint256 ethAmountinWei) internal   view returns (uint256){
        uint256 currentETHPriceInUSD = getEthPrice();
        uint256 finalizedPriceOfETH = (currentETHPriceInUSD * ethAmountinWei)/1e10;
        return uint256(finalizedPriceOfETH);
    }
}
