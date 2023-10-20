/*

Implement a crowd funding contract.

    - User creates a campaign to raise funds, setting start time, end time and goal (amount to raise).

    - Other users can pledge to the campaign. This will transfer tokens into the contract.

    - If the goal is reached before the campaign ends, the campaign is successful. Campaign creator can claim the funds.

    - Otherwise, the goal was not reached in time, users can withdraw their pledge.


Tasks: 

Complete launch:

    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        // code
    }

    This function will create a new campaign.

    Check that _startAt is greater than or equal to block.timestamp

    Check that _startAt is less tnan or equal to _endAt

    Check that _endAt is less than or equal to 90 days from block.timestamp

    Increment count and use this as an id for the new campaign

    Store the new campaign in the mapping campaigns

    Set creator to msg.sender

    Set pledged to 0

    Set claimed to false

    Emit the event Launch

Complete cancel:
    function cancel(uint _id) external {
        // code
    }

    Campaign creator can delete an campaign if

    msg.sender is the campaign creator

    Campaign has not yet started

    Delete campaign having the id _id

    Emit Cancel


Complete pledge:
    function pledge(uint _id, uint _amount) external {
        // code
    }

    Users can pledge to a campaign

    Check that campaign has started
    Check that campaign has not ended
    Transfer token from msg.sender to this contract for the amount _amount
    Increment pledged for campaign having the id _id
    Update pledgedAmount so that msg.sender can later withdraw if the campaign is not successful
    Emit the event Pledge


Complete unpledge:
    function unpledge(uint _id, uint _amount) external {
        // code
    }

    User can withdraw up to the amount that they pledged while the campaign is active.

    Check campaign has not ended
    Transfer _amount amount of tokens back to the user
    Decrement the amount pledged for campaign with id _id
    Decrement pledgedAmount
    Emit the event Unpledge



Complete claim:
    function claim(uint _id) external {
        // code
    }

    Campaign creator can claim funds if the campaign succesfully raise the funds.

    Only campaign creator can call this function
    Cannot call if campaign has not ended
    Total amount pledged must be greater than or equal to goal
    Cannot call claim more than once
    Transfer pledged amount to campaign creator
    Emit the event Claim

Complete refund:
    function refund(uint _id) external {
        // code
    }

    Users can withdraw all of their pledge amount from an unsuccessful campaign.

    Campaign must have ended
    Total amount pledged must be less than campaign goal.
    Refund token to msg.sender
    Emit the event Refund


*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract CrowdFund {
    uint private constant HODL_DURATION = 90 days;

    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint public count;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        // code
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        Campaign memory camp = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        campaigns[count] = camp;
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        // code
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp < campaign.startAt, "started");
    
        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");
    
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);
    
        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");
    
        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
    
        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");
    
        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);
    
        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");
    
        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);
    
        emit Refund(_id, msg.sender, bal);
    }
}
