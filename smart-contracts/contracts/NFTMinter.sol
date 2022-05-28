//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

pragma solidity ^0.8.7;

contract NFTMinter is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    enum NFTTypes {
        RANDOM,
        GREATEST
    }

    mapping(address => mapping(NFTTypes => uint256[])) nftIds;

    constructor(address _newOwner) ERC721("Endevr", "ENDV") {
        transferOwnership(_newOwner);
    }

    function mintNFTs(
        string[] memory _topNFTURIs,
        string[] memory _randomNFTURIs
    ) public onlyOwner returns (uint256[] memory, uint256[] memory) {
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

    function transferToWinners(
        address[] memory _randomWinners,
        address[] memory _topWinners
    ) public {
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
