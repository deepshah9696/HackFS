
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO {
    struct Proposal {
        string description;
        uint256 deadline;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        mapping(address => bool) voters;
    }

    address public owner;
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public members;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only members can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addMember(address _member) public onlyOwner {
        members[_member] = true;
    }

    function removeMember(address _member) public onlyOwner {
        members[_member] = false;
    }

    function propose(string memory _description, uint256 _votingPeriod) public onlyMember {
        proposals[proposalCount] = Proposal({
            description: _description,
            deadline: block.timestamp + _votingPeriod,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        });
        proposalCount++;
    }

    function vote(uint256 _proposalId, bool _vote) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.deadline, "Voting period has ended.");
        require(!proposal.voters[msg.sender], "You have already voted.");

        proposal.voters[msg.sender] = true;

        if (_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }

    function executeProposal(uint256 _proposalId) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting period is still ongoing.");
        require(!proposal.executed, "Proposal has already been executed.");

        if (proposal.yesVotes > proposal.noVotes) {
            // Add proposal execution logic here
        }

        proposal.executed = true;
    }

    function getProposal(uint256 _proposalId) public view returns (string memory, uint256, uint256, uint256, bool) {
        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.description,
            proposal.deadline,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.executed
        );
    }
}
