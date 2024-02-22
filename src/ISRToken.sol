// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface ISRToken {
    error AlreadyClaimed();
    event Claimed(address indexed claimant, uint256 amount);
}