// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {ISRToken} from "./ISRToken.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {AttestationAccessControl} from "verifications/abstracts/AttestationAccessControl.sol";
import {IAttestationIndexer} from "verifications/interfaces/IAttestationIndexer.sol";

contract SRToken is ISRToken, ERC20, AttestationAccessControl, Owned {

    string constant NAME = "SafeAirdrop";
    string constant SYMBOL = "SAFE";
    uint8 constant DECIMALS = 18;
    uint256 constant AIRDROP_AMT = 10**18;

    bytes32 schema;
    mapping (address => bool) claimed;

    constructor (
        address _owner, 
        uint256 _totalSupply, 
        bytes32 _schema
    ) 
    Owned(_owner) 
    ERC20(NAME, SYMBOL, DECIMALS) 
    {
        totalSupply = _totalSupply;
        schema = _schema;
    }

    modifier hasNotClaimed() {
        if(claimed[msg.sender]) revert AlreadyClaimed();
        _;
    }
    
    function claim() public hasNotClaimed onlyAttestation(schema) {
        claimed[msg.sender] = true;
        _mint(msg.sender, AIRDROP_AMT);
    }

    function setSchema(bytes32 _schema) external onlyOwner {
        schema = _schema;
    }

    function setIndexer(address _indexer) external onlyOwner {
        _setIndexer(IAttestationIndexer(_indexer));
    }
}
