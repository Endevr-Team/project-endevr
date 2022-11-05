//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./EndeavourDeployer.sol";

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Endeavour is VRFConsumerBaseV2 {
    //Endeavour Data
    string public ipfsStorage;
    uint256 minDonation;
    uint256 public minimumFundingGoal;
    uint256 randomNFTAmount;
    uint256 biggestNFTAmount;
    bool public rewardsGiven = false;

    //Roles
    address owner;
    address creator;
    address controller;

    //Raffle / Donation Data
    address[] public donors;
    mapping(address => uint256) public entries;
    address[] public randomWinners;
    address[] public biggestWinners;

    //Chainlink VRF
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId = 4776;
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
        uint256 _minDonation,
        uint256 _minimumFundingGoal,
        uint256 _randomNftAmount,
        uint256 _biggestNFTAmount,
        address _endeavourCreator,
        address _owner,
        address _controller
    ) VRFConsumerBaseV2(vrfCoordinator) {
        //Set Data
        minDonation = _minDonation;
        minimumFundingGoal = _minimumFundingGoal;
        randomNFTAmount = _randomNftAmount;
        biggestNFTAmount = _biggestNFTAmount;

        //Attach VRF Coodinator
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);

        //Price feeds
        priceFeed = AggregatorV3Interface(ethToUsdRinkeby);

        //Setup access roles
        // _setupRole(CREATOR_ROLE, _endeavourCreator);
        // _setupRole(OWNER_ROLE, _owner);
        owner = _owner;
        creator = _endeavourCreator;
        controller = _controller;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

    modifier onlyController() {
        require(msg.sender == controller);
        _;
    }

    // function changeSubscriptionId(uint64 _subscriptionId) public {
    //     // require(
    //     //     hasRole(OWNER_ROLE, msg.sender),
    //     //     "caller is not authorized to change subscription id"
    //     // );
    //     s_subscriptionId = _subscriptionId;
    // }

    function getMinimumDonationAmount() public view returns (uint256) {
        (, int256 latestPrice, , , ) = priceFeed.latestRoundData(); //decimal of 8
        uint256 newPrice = uint256(latestPrice) * 10**10;
        return (minDonation * 10**18) / newPrice;
    }

    function donate() public payable {
        require(msg.value >= getMinimumDonationAmount());

        //add to donors if nothing was sent yet
        if (entries[msg.sender] == 0) {
            donors.push(msg.sender);
        }
        //track donation amounts
        entries[msg.sender] += msg.value;
    }

    function refundDonors() public onlyOwner {
        for (uint256 i = 0; i < donors.length; i++) {
            payable(donors[i]).transfer(entries[donors[i]]);
        }
        selfdestruct(payable(msg.sender));
    }

    function releaseFunds(uint256 _amount) public onlyCreator {
        require(address(this).balance >= minimumFundingGoal);
        require(_amount <= address(this).balance);

        payable(msg.sender).transfer(_amount);
    }

    function selectWinner() public onlyController {
        require(address(this).balance >= minimumFundingGoal);
        require(!rewardsGiven);

        //make sure it works and account for failure
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            uint32(randomNFTAmount)
        );

        rewardsGiven = true;
    }

    function burnAddress(address[] storage array, uint256 index) internal {
        require(index < array.length);
        array[index] = array[array.length - 1];
        array.pop();
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory _randomWords
    ) internal override {
        randomWords = _randomWords;
        address[] storage allDonors = donors;

        //get winners
        for (uint256 i = 0; i < biggestNFTAmount; i++) {
            uint256 largest = 0;
            address largestDonor;
            uint256 largestJ;

            for (uint256 j = 0; j < allDonors.length; j++) {
                if (entries[allDonors[j]] > largest) {
                    largest = entries[allDonors[j]];
                    largestDonor = allDonors[j];
                    largestJ = j;
                }
            }

            biggestWinners.push(payable(largestDonor));
            burnAddress(allDonors, largestJ);
        }

        //find random winner for each nft
        for (uint256 i = 0; i < randomNFTAmount; i++) {
            uint256 latestWinnerIndex = randomWords[i] % allDonors.length;
            randomWinners.push(payable(allDonors[latestWinnerIndex]));
            burnAddress(allDonors, latestWinnerIndex);
        }

        //distribute nft to winners
        EndeavourDeployer(owner).transferToWinners(
            randomWinners,
            biggestWinners
        );
    }
}
