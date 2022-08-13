// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract Votes {

    struct Vote {
        string name;
        uint256 id;
        // address owner -> close vote.
        address[] candidates;
        address[] voters;
        mapping (address => bool) is_candidate;
        mapping (address => uint256) candidate_vote_nb;
        mapping (address => bool) authorized_voter;
        mapping (address => bool) has_voted;
        mapping (uint256 => uint256) drawChecker;
    }

    struct voteResults {
        string name;
        uint256 id;
        address winner;
        bool draw;
    }

    Vote[] vote;
    uint256 scrutin_id = 0;

    function createVote(string memory _name, address[] memory _candidates, address[] memory _voters) public {
        vote[scrutin_id].name = _name;
        require (_candidates.length < 2 || _voters.length < 1, "Not enough participants.");
        for (uint256 i = 0; i < _candidates.length; i++) {
            vote[scrutin_id].is_candidate[_candidates[i]] = true;
            vote[scrutin_id].candidate_vote_nb[_candidates[i]] = 0;
            vote[scrutin_id].candidates[i] = _candidates[i];
        }
        for (uint256 i = 0; i < _voters.length; i++) {
            vote[scrutin_id].authorized_voter[_voters[i]] = true;
            vote[scrutin_id].has_voted[_voters[i]] = false;
            vote[scrutin_id].voters[i] = _voters[i];
        }
    }

    // next feature -> implements white vote.
    function submitVoteBulletin(uint256 _vote_id, address _candidate) public {
        if (_vote_id > 0 && _vote_id < scrutin_id)
            revert();
        if (vote[_vote_id].is_candidate[_candidate] == false)
            revert();
        if (vote[_vote_id].authorized_voter[msg.sender] == false)
            revert();
        if (vote[_vote_id].has_voted[msg.sender] == true)
            revert();
        vote[_vote_id].has_voted[msg.sender] == true;
        vote[_vote_id].candidate_vote_nb[_candidate] += 1;
    }

    function getVoteWinner(uint256 _vote_id) public returns (address){
        require (_vote_id > 0 && _vote_id < scrutin_id, "Vote does not exists");
        for (uint256 i = 0; i < vote[_vote_id].voters.length; i++) {
            vote[_vote_id].drawChecker[i] = 0;
        }
        uint256 winner_voices = vote[_vote_id].candidate_vote_nb[vote[_vote_id].candidates[0]];
        address winner = vote[_vote_id].candidates[0];
        vote[_vote_id].drawChecker[winner_voices] += 1;
        
        for (uint256 i = 1; i < vote[_vote_id].candidates.length; i++) {
            vote[_vote_id].drawChecker[vote[_vote_id].candidate_vote_nb[vote[_vote_id].candidates[i]]] += 1;
            if (vote[_vote_id].candidate_vote_nb[vote[_vote_id].candidates[i]] > winner_voices) {
                winner_voices = vote[_vote_id].candidate_vote_nb[vote[_vote_id].candidates[i]];
                winner = vote[_vote_id].candidates[i];
            }
        }
        if (vote[_vote_id].drawChecker[winner_voices] >= 2)
            return address(0);
        return winner;
    }
}