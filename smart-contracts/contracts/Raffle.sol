//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error NotImplemented();

contract Raffle is VRFConsumerBaseV2 {
    enum LotteryState {
        STARTED,
        COMPUTING,
        ENDED
    }

    address owner;
    address payable public latestWinner;
    LotteryState public lotteryState = LotteryState.ENDED;
    address[] public participants;
    mapping(address => uint256) public entries;

    //VRF
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 keyHash =
        0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;
    uint256[] public randomWords;
    uint256 public requestId;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        owner = msg.sender;
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_subscriptionId = subscriptionId;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this contract");
        _;
    }

    function joinLottery() public payable {
        require(
            lotteryState == LotteryState.STARTED,
            "You can only join when the lottery has started."
        );
        if (entries[msg.sender] == 0) {
            participants.push(msg.sender);
        }
        entries[msg.sender] += msg.value;
        console.log("%s now has %s etj", msg.sender, entries[msg.sender]);
    }

    function findAndRemove(address sender) internal {
        int256 index = find(sender);
        if (index >= 0) {
            burn(uint256(index));
        }
    }

    function find(address sender) internal view returns (int256) {
        int256 index = -1;
        for (uint256 i = 0; i < participants.length; i++) {
            if (participants[i] == sender) {
                index = int256(i);
            }
        }
        return index;
    }

    function burn(uint256 index) internal {
        require(index < participants.length);
        participants[index] = participants[participants.length - 1];
        participants.pop();
    }

    function leaveLottery(uint256 amount) public {
        require(
            lotteryState == LotteryState.STARTED,
            "You can only leave while the lottery is active."
        );
        require(
            entries[msg.sender] >= amount,
            string(
                abi.encodePacked(
                    "You can take out at most ",
                    Strings.toString(entries[msg.sender]),
                    " eth"
                )
            )
        );
        payable(msg.sender).transfer(amount); //what if it fails
        entries[msg.sender] -= amount;
        if (entries[msg.sender] == 0) {
            findAndRemove(msg.sender);
        }
    }

    function resetLottery() internal {
        for (uint256 i = 0; i < participants.length; i++) {
            entries[participants[i]] = 0;
        }
        delete participants;
    }

    function startLottery() public onlyOwner {
        require(
            lotteryState == LotteryState.ENDED,
            "You can only the start the lottery if it has ended."
        );
        resetLottery();
        lotteryState = LotteryState.STARTED;
        console.log("smart contract started");
    }

    function endLottery() public onlyOwner {
        require(
            lotteryState == LotteryState.STARTED,
            "Can only end a started lottery"
        );
        lotteryState = LotteryState.ENDED;

        uint256 randomNumber = block.difficulty +
            block.number +
            block.timestamp;
        uint256 hashedRandomNumber = uint256(
            keccak256(abi.encodePacked(randomNumber))
        );

        uint256 latestWinnerIndex = hashedRandomNumber % participants.length;
        latestWinner = payable(participants[latestWinnerIndex]);

        latestWinner.transfer(address(this).balance);
    }

    function endLotteryRandom() public onlyOwner {
        require(
            lotteryState == LotteryState.STARTED,
            "Can only end a started lottery"
        );
        lotteryState = LotteryState.COMPUTING;

        //make sure it works and account for failure
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory _randomWords
    ) internal override {
        randomWords = _randomWords;

        uint256 latestWinnerIndex = randomWords[0] % participants.length;
        latestWinner = payable(participants[latestWinnerIndex]);

        latestWinner.transfer(address(this).balance);

        lotteryState = LotteryState.ENDED;
    }
}

//Donate money in the smart contract
//Connect address to amount donated in the smart contract
//Only accept eth (reject other tokens) v1
//Accept all tokens v2
//Stop Lottery
//Open Lottery
//Pick Lottery winner v1
//Pick Lottery winner v2 (using chainlink)
//add only owner
//errors in solidity
