// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MockV3Aggregator {
    uint8 public decimals;
    int256 public latestAnswer;
    uint256 public timestamp;
    uint256 public latestRound;

    mapping(uint80 => int256) public getAnswer;
    mapping(uint80 => uint256) public getTimestamp;
    mapping(uint80 => uint256) private getStartedAt;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        decimals = _decimals;
        updateAnswer(_initialAnswer);
    }

    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer;
        timestamp = block.timestamp;
        latestRound++;
        getAnswer[uint80(latestRound)] = _answer;
        getTimestamp[uint80(latestRound)] = block.timestamp;
        getStartedAt[uint80(latestRound)] = block.timestamp;
    }

    function updateRoundData(uint80 _roundId, int256 _answer, uint256 _timestamp, uint256 _startedAt) public {
        latestRound = _roundId;
        latestAnswer = _answer;
        timestamp = _timestamp;
        getAnswer[_roundId] = _answer;
        getTimestamp[_roundId] = _timestamp;
        getStartedAt[_roundId] = _startedAt;
    }

    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (_roundId, getAnswer[_roundId], getStartedAt[_roundId], getTimestamp[_roundId], _roundId);
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (
            uint80(latestRound),
            getAnswer[uint80(latestRound)],
            getStartedAt[uint80(latestRound)],
            getTimestamp[uint80(latestRound)],
            uint80(latestRound)
        );
    }

    function version() external pure returns (uint256) {
        return 4;
    }
}
