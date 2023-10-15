/*
Complete the Dutch auction contract.

A NFT (non fungible token) is sold on a Dutch auction. 
A Dutch auction starts at the highest price set by the seller. 

The price of the NFT is lowered over time until someone buys it.

Tasks:
    - Write a function that will return the current price.

      function getPrice() public view returns (uint)
      
      The current price decrease linearly with time starting from the highest price.
      Here is the equation.

      current price = starting price - (discount rate * time elapsed since start of auction)
    
    - Complete function

      function buy() external payable {}
 
      Any user can buy the NFT with the following restrictions.

      Auction is not expired
      User sent ETH greater than or equal to the current price computed by getPrice()
      If all of the restrictions are met:

      transfer ownership of nft by calling nft.transferFrom(seller, msg.sender, nftId)
      refund excess ETH (msg.value - current price) to msg.sender
      send remaining ETH to seller and delete the contract with selfdestruct
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        require(
            _startingPrice >= _discountRate * DURATION,
            "starting price < min"
        );

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = (discountRate * timeElapsed);
        retrun startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "Expired");
        
        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        // transfer ownership of nft by calling nft.transferFrom(seller, msg.sender, nftId)
        nft.tranferFrom(seller, msg.sender, nftId);

        // refund excess ETH (msg.value - current price) to msg.sender
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        // delete the contract with selfdestruct
        selfdestruct(seller);
    }
}
