/*

Users earn reward by staking their token.

The amount they earn is reward rate * amount staked by the user / total staked for every second.

reward rate is set by the contract owner.


Video: https://www.youtube.com/watch?v=rXuDelwHLoo


Tasks:
    - Complete the function
        function setRewardsDuration(uint _duration) external {}

        This function sets the duration of the rewards.

        - Only the owner can call
        - Previous reward period must be expired (block.timestamp > finishAt).


    - Complete the function
        function notifyRewardAmount(uint _amount) external {}

        This function sets the rewardRate and time when the rewards end finishAt.

        - Only the owner can call
        - If previous reward period is expired (block.timestamp >= finishAt) then rewardRate is set to _amount / duration. Otherwise, the current reward period is not expired so the new reward rate must be set to (_amount + remaining rewards) / duration.
        - Check rewardRate is greater than 0
        - Check balance of rewards locked in this contract is greater than or equal to the total reward to be given out.
        - Set updatedAt to the current timestamp
        - Set finishAt to current timestamp + duration

    - Complete the function
        function stake(uint _amount) external {}

        Users call this function to stake their token.

        - Check _amount to stake is greater than 0
        - Transfer _amount of staking token from caller to this contract
        - Update balanceOf for msg.sender. This mapping stores the amount of tokens staked by msg.sender
        - Update totalSupply, total amount of staking tokens in this contract.


    - Complete the function
        function withdraw(uint _amount) external {}

        Users call this function to withdraw their staked token.

        - Check _amount to withdraw is greater than 0
        - Update balanceOf for msg.sender
        - Update totalSupply
        - Transfer _amount of staking token from the contract back to the caller


    - Complete the function
        function lastTimeRewardApplicable() public view returns (uint) {}

        This function returns the last time that the stakers can earn rewards.

        - Return the current timestamp if it is less than or equal to finishAt. Otherwise return finishAt.


    - Complete the function
        function rewardPerToken() public view returns (uint) {}

        This function computes the current "reward per token", sum of reward rate / total staked for each second.

        Previous "reward per token" is stored in the state variable rewardPerTokenStored.

        Current "reward per token" is calculated by adding rewardPerTokenStored with current reward rate * duration since last update / total supply, scaled up by 1e18 to prevent numbers rounding down to 0.

        If totalSupply is 0, return rewardPerTokenStored.

        Otherwise, reward per token is calculated by the code below.
            // Duration since last updated
            uint _duration = lastTimeRewardApplicable() - updatedAt;

            // Current reward per token
            rewardPerTokenStored + rewardRate * _duration * 1e18 / totalSupply


    - Complete the function

        function earned(address _account) public view returns (uint) {}

        This function calculates the amount of rewards earned by _account.


    - Create a modifier
        modifier updateReward(address _account) {}

        This modifier updates rewards and timestamp state variables that are necessary to correctly calculate the rewards earned by users.

        - Update rewardPerTokenStored to the latest value by calling rewardPerToken()
        - Update updatedAt to the output of lastTimeRewardApplicable()
        - If _account is not zero address, update rewards[_account] by calling earned(_account) 
          and update userRewardPerTokenPaid[_account] to the latest rewardPerTokenStored.


    - Attach the modifier updateReward(msg.sender) to the functions stakeand withdraw.


    - Attach the modifier updateReward(address(0)) to the function notifyRewardAmount(uint _amount)

    - Complete the function
        function getReward() external {}

        This function transfer the rewards earned by msg.sender.

        - Attach the modifier updateReward(msg.sender). This updates the rewards earned by msg.sender before the rewards are claimed.
        - Reset rewards[msg.sender] to 0
        - Transfer the rewards earned to msg.sender.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract StakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    // Duration of rewards to be paid out (in seconds)
    uint public duration;
    // Timestamp of when the rewards finish
    uint public finishAt;
    // Minimum of last updated time and reward finish time
    uint public updatedAt;
    // Reward to be paid out per second
    uint public rewardRate;
    // Sum of (reward rate * dt * 1e18 / total supply)
    uint public rewardPerTokenStored;
    // User address => rewardPerTokenStored
    mapping(address => uint) public userRewardPerTokenPaid;
    // User address => rewards to be claimed
    mapping(address => uint) public rewards;

    // Total staked
    uint public totalSupply;
    // User address => staked amount
    mapping(address => uint) public balanceOf;

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    modifier updateReward(address _account) {
        // Code
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint) {
        // Code
    }

    function rewardPerToken() public view returns (uint) {
        // Code
    }

    function stake(uint _amount) external {
        // Code
    }

    function withdraw(uint _amount) external {
        // Code
    }

    function earned(address _account) public view returns (uint) {
        // Code
    }

    function getReward() external {
        // Code
    }

    function setRewardsDuration(uint _duration) external {
        // Code
    }

    function notifyRewardAmount(uint _amount) external {
        // Code
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
}
