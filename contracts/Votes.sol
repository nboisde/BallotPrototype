// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract Votes {

    struct Voter {
        address voter;
        bool has_voted;
    }

    struct Candidate {
        address candidate;
        uint256 voices_nb;
    }

    struct Vote {
        string name;
        uint256 id;
        mapping (uint256 => Candidate) candidates;
        mapping (uint256 => Voter) voters;
    }

    mapping (uint256 => Vote) vote;
    uint scrutin_id = 0;

    function createVote(string memory _name, address[] memory _candidates, address[] memory _voters) public {
        vote[scrutin_id].name = _name;
        for (uint256 i = 0; i < _candidates.length; i++) {
            Candidate memory c;
            c.candidate = _candidates[i];
            vote[scrutin_id].candidates[i] = c;
        }
        for (uint i = 0; i < _voters.length; i++) {
            Voter memory voter;
            voter.voter = _voters[i];
            voter.has_voted = false;
            vote[scrutin_id].voters[i] = voter;
        }
        scrutin_id++;
    }

    

}