// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campagin {
        address payable owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    } 

    mapping(uint256 => Campagin) public campagins;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public return(uint256) {
        Campagin storage newCampaign = campagins[numberOfCampaigns];

        require(newCampaign.deadline < block.timestamp, unicode"截至时间不能早于创建时间!");

        newCampaign.owner = payable(msg.sender);
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.target = _target;
        newCampaign.deadline = block.timestamp + _deadline;
        newCampaign.image = _image;
        
        return numberOfCampaigns++;
    }

    function donateToCampaign(uint256 _id) public payable {
        Campagin storage campaign = campagins[_id];

        require(campaign.deadline > block.timestamp, unicode"截至时间已过!");
        require(msg.value > 0, unicode"捐赠金额必须大于0!");

        campaign.amountCollected += msg.value;
        campaign.donators.push(msg.sender);
        campaign.donations.push(msg.value);

        (bool sent) = payable(campaign.owner).call{value: msg.value}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + msg.value;
        }
    }

    function getDonators() {
        // return campagins[numberOfCampaigns].donators;
    }

    function getCampaigns() {
        // return campagins;
    }
}
