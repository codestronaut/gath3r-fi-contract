// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

import "./Gath3rGroup.sol";

/**
 * @title Gath3rGroup
 * @dev Contract for managing groups.
 */
contract Gath3r {
    address[] public allGroups;
    mapping(address => address[]) public userGroups;

    event GroupCreated(
        address indexed creator,
        address groupAddress,
        string groupName
    );

    constructor() {}

    /**
     * @dev createGroup(string) function.
     * Use case: Create new group for split bill activities.
     */
    function createGroup(string memory _groupName) external {
        Gath3rGroup newGroup = new Gath3rGroup(msg.sender, _groupName);
        allGroups.push(address(newGroup));
        userGroups[msg.sender].push(address(newGroup));

        emit GroupCreated(msg.sender, address(newGroup), _groupName);
    }

    /**
     * @dev getMyGroups() function.
     * Use case: Get user-specific groups.
     */
    function getMyGroups() external view returns (address[] memory) {
        return userGroups[msg.sender];
    }

    /**
     * @dev getMyGroups() function.
     * Use case: Get all groups within Gath3r.
     */
    function getAllGroups() external view returns (address[] memory) {
        return allGroups;
    }
}
