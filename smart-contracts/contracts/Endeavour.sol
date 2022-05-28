//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Endeavour is AccessControl, VRFConsumerBaseV2 {
    enum FundingOptions {
        PARTIAL,
        FULL
    }
    enum EndeavourState {
        STARTED,
        DISTRIBUTING,
        RELEASING,
        ENDED,
        FAILED
    }

    //Endeavour Data
    string public ipfsStorage;
    uint256 minDonation;
    uint256 minimumFundingGoal;
    FundingOptions fundingOption;
    address[] ipfsNFTs;
    EndeavourState endeavourState = EndeavourState.STARTED;

    //Roles
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    //Raffle / Donation Data
    address[] public donors;
    mapping(address => uint256) public entries;
    mapping(address => address) public winners;

    //Chainlink VRF
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 keyHash =
        0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint256[] public randomWords;
    uint256 public requestId;

    //Price feeds
    AggregatorV3Interface internal priceFeed;
    address ethToUsdRinkeby = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;

    constructor(
        string memory _ipfsStorage,
        uint256 _minDonation,
        uint256 _minimumFundingGoal,
        FundingOptions _fundingOption,
        address _endeavourCreator,
        address[] memory _ipfsNFTs,
        address _owner,
        uint64 _subscriptionId
    ) VRFConsumerBaseV2(vrfCoordinator) {
        //Set Data
        ipfsStorage = _ipfsStorage;
        minDonation = _minDonation;
        minimumFundingGoal = _minimumFundingGoal;
        fundingOption = _fundingOption;
        ipfsNFTs = _ipfsNFTs;

        //Attach VRF Coodinator
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_subscriptionId = _subscriptionId;

        //Price feeds
        priceFeed = AggregatorV3Interface(ethToUsdRinkeby);

        //Setup access roles
        _setupRole(CREATOR_ROLE, _endeavourCreator);
        _setupRole(OWNER_ROLE, _owner);
    }

    function getMinimumDonationAmount() public view returns (uint256) {
        int256 latestPrice = getLatestPrice(); //decimal of 8
        uint256 newPrice = uint256(latestPrice) * 10**10;
        return (minDonation * 10**18) / newPrice;
    }

    function donate() public payable {
        require(
            msg.value >= getMinimumDonationAmount(),
            string(
                abi.encodePacked(
                    "The minimum donation amount is $",
                    Strings.toString(minDonation),
                    " USD, so ",
                    Strings.toString(getMinimumDonationAmount()),
                    " ETH"
                )
            )
        );

        //add to donors if nothing was sent yet
        if (entries[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        //track donation amounts
        entries[msg.sender] += msg.value;
    }

    function refundDonors() public {
        require(
            hasRole(OWNER_ROLE, msg.sender),
            "caller is not authorized to refund"
        );

        //make sure fees dont mess with us
        for (uint256 i = 0; i < donors.length; i++) {
            payable(donors[i]).transfer(entries[donors[i]]);
        }

        selfdestruct(payable(msg.sender)); //more info on what this does
    }

    function releaseFunds() public {
        require(
            hasRole(CREATOR_ROLE, msg.sender),
            "caller is not authorized to release funds"
        );
    }

    function selectWinner() public {
        require(
            hasRole(OWNER_ROLE, msg.sender) ||
                hasRole(CREATOR_ROLE, msg.sender),
            "caller is not authorized to select winner"
        );

        //make sure it works and account for failure
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            uint32(ipfsNFTs.length)
        );
    }

    function burn(address[] storage array, uint256 index) internal {
        require(index < array.length);
        array[index] = array[array.length - 1];
        array.pop();
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory _randomWords
    ) internal override {
        randomWords = _randomWords;

        address[] storage nonWinners = donors; //storage vs memory

        //find winner for each nft
        for (uint256 i = 0; i < ipfsNFTs.length; i++) {
            uint256 latestWinnerIndex = randomWords[i] % nonWinners.length;
            winners[payable(nonWinners[latestWinnerIndex])] = ipfsNFTs[i];
            burn(nonWinners, latestWinnerIndex);
        }
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }
}
