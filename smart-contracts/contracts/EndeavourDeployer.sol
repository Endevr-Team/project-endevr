//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Endeavour.sol";
import "./EndeavourController.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract EndeavourDeployer is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    enum NFTTypes {
        RANDOM,
        GREATEST
    }

    address owner;
    address controller;
    mapping(address => bool) creators;

    Endeavour[] private _endeavours;

    uint256 public deployCost = 0.1 ether;
    uint256 public NFTCost = 0.01 ether;

    mapping(address => mapping(NFTTypes => uint256[])) nftIds;

    constructor(address _owner) ERC721("Endevr", "ENDV") {
        //Setup access role
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setEndeavourController(address _controller) public onlyOwner {
        controller = _controller;
    }

    function createEndeavour(
        uint256 _minDonation,
        uint256 _minimumFundingGoal,
        string[] memory _topNFTURIs,
        string[] memory _randomNFTURIs,
        uint256 _distributionDelayInMinutes
    ) public payable {
        require(
            msg.value >= getFee(1, _topNFTURIs.length + _randomNFTURIs.length)
        );

        //Deploy NFT
        mintNFTs(_topNFTURIs, _randomNFTURIs);

        //Create Ndver
        _endeavours.push(
            new Endeavour(
                _minDonation,
                _minimumFundingGoal,
                _randomNFTURIs.length,
                _topNFTURIs.length,
                msg.sender,
                owner,
                controller
            )
        );

        creators[msg.sender] = true;

        EndeavourController(controller).addToDistributors(
            _distributionDelayInMinutes
        );
    }

    //possible fix needed with safeMath
    function setDeployCost(uint256 _deployCost) public onlyOwner {
        deployCost = _deployCost;
    }

    function setNFT(uint256 _NFTCost) public onlyOwner {
        NFTCost = _NFTCost;
    }

    function getFee(uint256 _contractsToDeploy, uint256 _nftsToDeploy)
        public
        view
        returns (uint256)
    {
        return deployCost * _contractsToDeploy + NFTCost * _nftsToDeploy;
    }

    function mintNFTs(
        string[] memory _topNFTURIs,
        string[] memory _randomNFTURIs
    ) internal returns (uint256[] memory, uint256[] memory) {
        for (uint256 i = 0; i < _topNFTURIs.length; i++) {
            uint256 id = mintNFT(_topNFTURIs[i]);
            nftIds[address(this)][NFTTypes.GREATEST].push(id);
        }

        for (uint256 i = 0; i < _randomNFTURIs.length; i++) {
            uint256 id = mintNFT(_randomNFTURIs[i]);
            nftIds[address(this)][NFTTypes.RANDOM].push(id);
        }

        return (
            nftIds[address(this)][NFTTypes.RANDOM],
            nftIds[address(this)][NFTTypes.GREATEST]
        );
    }

    function mintNFT(string memory _nftURI) internal returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(address(this), newItemId);
        _setTokenURI(newItemId, _nftURI);
        return newItemId;
    }

    //onlyowner, endeaver, or controller can transfer to winners
    function transferToWinners(
        address[] memory _randomWinners,
        address[] memory _topWinners
    ) public {
        //add check if creator
        require(
            msg.sender == owner ||
                msg.sender == controller ||
                creators[msg.sender]
        );

        for (uint256 i = 0; i < _randomWinners.length; i++) {
            safeTransferFrom(
                address(this),
                _randomWinners[i],
                nftIds[msg.sender][NFTTypes.RANDOM][i]
            );
        }

        for (uint256 i = 0; i < _topWinners.length; i++) {
            safeTransferFrom(
                address(this),
                _topWinners[i],
                nftIds[msg.sender][NFTTypes.GREATEST][i]
            );
        }
    }
}
