// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Staking {

    struct Reward {
        uint256 rewardRate; // % per year
        uint256 accumulated;
    }

    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
        Reward rewardData;
    }

    mapping(address => StakeInfo) public stakes;

    function stake() external payable {
        require(msg.value > 0, "Stake > 0");

        StakeInfo storage user = stakes[msg.sender];

        user.amount += msg.value;
        user.startTime = block.timestamp;
        user.rewardData.rewardRate = 10; // 10% APY
    }

    function calculateReward(address userAddr) public view returns (uint256) {
        StakeInfo memory user = stakes[userAddr];

        uint256 timeElapsed = block.timestamp - user.startTime;

        uint256 reward = 
            (user.amount * user.rewardData.rewardRate * timeElapsed)
            / (365 days * 100);

        return reward;
    }

    function claimReward() external {
        StakeInfo storage user = stakes[msg.sender];

        uint256 reward = calculateReward(msg.sender);

        user.rewardData.accumulated += reward;
        user.startTime = block.timestamp;

       // payable(msg.sender).transfer(reward);

        (bool success,) = payable(msg.sender).call{value:reward}("");

        require(success,"Transaction Failed");
    }
}