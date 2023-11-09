/*

Complete the English auction contract.

A NFT (non fungible token) is sold on an English auction. 

An English auction starts at a minimum price set by the seller. 

Bidders compete for the ownership of NFT by bidding higher than the previous bidder. 

Auction ends in 7 days, at which point the highest bidder is the winner.

Task:
    - Complete function start().

      This function is called by the seller to start the auction.

      Only the seller can call.
      It can only be called once.
      Transfer the ownership of nft from the seller to this contract. Assume that the seller has approved this contract to call transferFrom.
      Set started to true
      Set expiration date, endAt to 7 days in the future from the current timestamp.
      Emit the event Start

    - Complete the function bid().

      This function is called by bidders to bid higher than the previous bidder.

      Cannot call this function if the auction has not yet started.
      Cannot call if auction has expired.
      Amount of ETH sent to this function must be greater than the previous highestBid.
      The mapping bids stores the amount of ETH each bidder can withdraw. 
      Use this mapping to update the amount of ETH the previous highest bidder can withdraw.
      Set highestBidder to caller.
      Set highestBid to the amount of ETH that was sent.
      Emit the event Bid logging the parameters caller and amount of ETH that was sent.

    - Complete function withdraw().

      This function refunds ETH to caller. 
      The amount of ETH the caller can withdraw is the sum of all bids the caller has sent 
      which are no longer the current highest bid. This sum is stored in the mapping bids.

      Reset bids of caller to 0.
      Send appropriate amount of ETH to caller.
      emit the event Withdraw with the parameters caller and amount of ETH that was withdrawn.


    - Complete the function end().

      This function ends the auction, transferring ownership of NFT to the highest bidder and paying the seller.
  
      This function cannot be called if the auction has not started or the auction is not expired.
      Use the state variable ended to check that this function can only be called once.
      Set ended to true.
      Transfer the ownership of NFT to highestBidder and pay the seller.
      Emit the event End with highestBidder and highestBid.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    // mapping from bidder to amount of ETH the bidder can withdraw
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlySeller() {
        require(isSeller());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isSeller() public view returns (bool) {
        return msg.sender == seller;
    }

    function start() external onlySeller {
        require(!started);
        // Transfer the ownership of nft from the seller to this contract
        nft.transferFrom(seller, address(this), nftId);
        started = true;
        endAt = block.timestamp + DURATION;
        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        // Cannot call if auction has expired
        require(endAt > block.timestamp, "ended");
        // Amount of ETH sent to this function must be greater than the previous highestBid
        require(msg.value > highestBid, "value < highest");

        // The mapping bids stores the amount of ETH each bidder can withdraw
        // update the amount of ETH the previous highest bidder can withdraw
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started);
        require(endAt < block.timestamp, "expired");
        require(!ended, "ended already");
        ended = true;

        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
