//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Endeavour.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract EndeavourController is KeeperCompatibleInterface, AccessControl {
    address[] public endeavours;
    mapping(address => uint256) public endeavoursDelay;
    mapping(address => uint256) public endeavoursStart;

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    constructor(address _owner) {
        //Setup access role
        _setupRole(OWNER_ROLE, _owner);
        _setupRole(CREATOR_ROLE, _owner);
        _setRoleAdmin(CREATOR_ROLE, OWNER_ROLE);
    }

    function addToCreators() public {
        require(
            hasRole(OWNER_ROLE, msg.sender),
            "caller is not authorized to add creators"
        );

        grantRole(CREATOR_ROLE, msg.sender);
    }

    function addToDistributors(uint256 _timeInMinutes) public {
        require(
            hasRole(OWNER_ROLE, msg.sender) ||
                hasRole(CREATOR_ROLE, msg.sender),
            "caller is not authorized to add to distributors"
        );

        endeavours.push(msg.sender);
        endeavoursDelay[msg.sender] = _timeInMinutes;
        endeavoursStart[msg.sender] = block.timestamp;
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        upkeepNeeded = false;

        for (uint256 i = 0; i < endeavours.length; i++) {
            if (
                (block.timestamp - endeavoursStart[endeavours[i]]) >=
                endeavoursDelay[endeavours[i]]
            ) {
                //rewards not distributed
                if (!Endeavour(endeavours[i]).rewardsGiven()) {
                    //rewards should be distributed
                    if (
                        endeavours[i].balance >=
                        Endeavour(endeavours[i]).minimumFundingGoal()
                    ) {
                        upkeepNeeded = true;
                        break;
                    }
                }
            }
        }
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function

        for (uint256 i = 0; i < endeavours.length; i++) {
            if (
                (block.timestamp - endeavoursStart[endeavours[i]]) >=
                endeavoursDelay[endeavours[i]]
            ) {
                //rewards not distributed
                if (!Endeavour(endeavours[i]).rewardsGiven()) {
                    //rewards should be distributed
                    if (
                        endeavours[i].balance >=
                        Endeavour(endeavours[i]).minimumFundingGoal()
                    ) {
                        // perform upkeep
                        Endeavour(endeavours[i]).selectWinner();

                        //remove from tracking
                        endeavoursStart[endeavours[i]] = 0;
                        endeavoursDelay[endeavours[i]] = 0;
                        burn(endeavours, i);
                    }
                }
            }
        }
    }

    function burn(address[] storage array, uint256 index) internal {
        require(index < array.length);
        array[index] = array[array.length - 1];
        array.pop();
    }
}
