//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Endeavour.sol";
import "./NFTMinter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract EndeavourDeployer is Ownable {
    Endeavour[] private _endeavours;

    uint256 public deployCost = 0.1 ether;
    uint256 public NFTCost = 0.01 ether;

    function createEndeavour(
        string memory _ipfsStorage,
        uint256 _minimumFundingGoal,
        Endeavour.FundingOptions _fundingOption,
        string[] memory _topNFTURIs,
        string[] memory _randomNFTURIs
    ) public {
        //make sure that only valid endeavours can be created
        //Deploy NFT
        //mintNFTs();
        //CREATE NDVER
        // Endeavour endeavour = new Endeavour(
        //     _ipfsStorage,
        //     _minimumFundingGoal,
        //     _fundingOption,
        //     msg.sender,
        //     owner()
        // );
        // _endeavours.push(endeavour);
    }

    //possible fix needed with safeMath
    function setDeployCost(uint256 _deployCost) public onlyOwner {
        require(_deployCost >= 0, "deploy cost cannot be negative");
        deployCost = _deployCost;
    }

    function setNFT(uint256 _NFTCost) public onlyOwner {
        require(_NFTCost >= 0, "nft cost cannot be negative");
        NFTCost = _NFTCost;
    }

    function allEndeavours() public view returns (Endeavour[] memory) {
        return _endeavours;
    }

    function getFee(uint256 _contractsToDeploy, uint256 _nftsToDeploy)
        public
        view
        returns (uint256)
    {
        return deployCost * _contractsToDeploy + NFTCost * _nftsToDeploy;
    }
}

//nft reward types
//updagradable
