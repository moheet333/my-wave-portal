// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 private totalWaves;
    mapping (address => uint256) private addressToWaves;
    mapping (address => uint256) public lastWavedAt;
    
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    address[] private wavers;
    Wave[] private waves;

    constructor() payable {
        console.log("My first solidity project!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait 1m"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
        addressToWaves[msg.sender] += 1;
        wavers.push(msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        seed = (block.timestamp + block.difficulty) % 100;

        console.log("Random # generated: %d", seed);

        if(seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money! from contract");
        }
        
        emit NewWave(msg.sender, block.timestamp, _message);
    
    }

    function getAllWaves() public view returns(Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAddressToWaves(address waver) public view returns (uint256) {
        console.log("Total waves for given address is: ", addressToWaves[waver]);
        return addressToWaves[waver];
    }

    function getWavers() public view returns (address[] memory) {
        return wavers;
    }
}