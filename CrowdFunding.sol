/**
 *Submitted for verification at amoy.polygonscan.com on 2025-05-29
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 targetAmount;
        uint256 currentAmount;
        uint256 deadline;
        bool completed;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;
    uint256 public campaignCount;

    event CampaignCreated(uint256 campaignId, address creator, string title, uint256 targetAmount, uint256 deadline);
    event ContributionReceived(uint256 campaignId, address contributor, uint256 amount);
    event FundsWithdrawn(uint256 campaignId, address creator, uint256 amount);
    event RefundIssued(uint256 campaignId, address contributor, uint256 amount);

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _targetAmount,
        uint256 _duration
    ) public {
        require(_targetAmount > 0, "Target amount must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        uint256 deadline = block.timestamp + _duration;
        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            title: _title,
            description: _description,
            targetAmount: _targetAmount,
            currentAmount: 0,
            deadline: deadline,
            completed: false
        });

        campaignCount++;
        emit CampaignCreated(campaignCount - 1, msg.sender, _title, _targetAmount, deadline);
    }

    function contribute(uint256 _campaignId) public payable {
        require(_campaignId < campaignCount, "Campaign does not exist");
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(!campaign.completed, "Campaign is completed");
        require(msg.value > 0, "Contribution must be greater than 0");

        campaign.currentAmount += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        emit ContributionReceived(_campaignId, msg.sender, msg.value);
    }

    function withdrawFunds(uint256 _campaignId) public {
        require(_campaignId < campaignCount, "Campaign does not exist");
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.creator, "Only creator can withdraw");
        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(campaign.currentAmount >= campaign.targetAmount, "Target not met");
        require(!campaign.completed, "Funds already withdrawn");

        campaign.completed = true;
        uint256 amount = campaign.currentAmount;
        campaign.currentAmount = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsWithdrawn(_campaignId, msg.sender, amount);
    }

    function requestRefund(uint256 _campaignId) public {
        require(_campaignId < campaignCount, "Campaign does not exist");
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(campaign.currentAmount < campaign.targetAmount, "Target met, no refunds");
        require(!campaign.completed, "Campaign is completed");
        require(contributions[_campaignId][msg.sender] > 0, "No contributions to refund");

        uint256 amount = contributions[_campaignId][msg.sender];
        contributions[_campaignId][msg.sender] = 0;
        campaign.currentAmount -= amount;

        // Mark campaign as completed if no funds remain
        if (campaign.currentAmount == 0) {
            campaign.completed = true;
        }

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");

        emit RefundIssued(_campaignId, msg.sender, amount);
    }
}
