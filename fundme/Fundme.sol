// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

// what we have to do
// 1. Get funds from user
// 2. Withdraw funds
// 3. Set a minimum funding value in USD

contract Fundme {
    // fund function will be responsible to fund eth

    using PriceConverter for uint256;

    // The line using PriceConverter for uint256; in Solidity enables all public and internal functions from the PriceConverter library to be called on any uint256 variable.

    uint256 constant minimumDonatedValueInUSD = 10 * 1e10; //minimum 10$ should be donated (like 10 to the 18 decimals, thats what 1e18 do)
    address[] private senderAddress;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // payable keyword --> enables eth transfer b/w accounts

        // require(getConversionRate(msg.value)>= minimumDonatedValueInUSD, "Not enough fund is provided"); // 1e18 is equals to 1000000000000000000 wei  = 1000000000 Gwei
        // wei is the smallest ether unit

        // instead of doing "getConversionRate(msg.value)" to pass the first argument in the function getConversionRate()
        // we will do msg.value.getConversionRate() and boom "msg.value" is autometically passed as first parameter in the function

        require(
            msg.value.getConversionRate() >= minimumDonatedValueInUSD,
            "Not enough fund is provided"
        );

        senderAddress.push(msg.sender); // this will add all the sender address to the senderAddress list
        addressToAmountFunded[msg.sender] =
            addressToAmountFunded[msg.sender] +
            msg.value; // this will keep track of history of which person donated how much eth;
    }

    // withdraw function is responsible to take out the funded eth to the wallet address
    function withdraw() public {}
}
