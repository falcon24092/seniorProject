pragma solidity ^0.4.18;

contract Election {
    
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool voted;
        uint voteIndex;
        uint weight;
    }
    
    address public owner;
    string public name;
    mapping (address => Voter) public voters;
    Candidate[] public candidates;
    uint public auctionEnd;
    
    event ElectionResult(string name, uint voteCount);
    
    function setElection(string _name, uint durationMinutes, string candidate1, string candidate2) public{
        owner = msg.sender;
        name = _name;
        auctionEnd = now + (durationMinutes * 1 minutes);
        
        candidates.push(Candidate(candidate1,0));
        candidates.push(Candidate(candidate2,0));
    }
    
    function getElection() view public returns (string, string , uint, string, uint) {
            uint i = 0;
            return (
                    name , 
                    candidates[i].name , candidates[i].voteCount, 
                    candidates[i+1].name, candidates[i+1].voteCount
                    );
    }
    
    
    function authorize(address voter) public{
        require(msg.sender == owner);
        require(!voters[voter].voted);
        
        voters[voter].weight = 1;
    }
    
    function vote(uint voteIndex) public{
        require(now < auctionEnd);
        require(!voters[msg.sender].voted);
        
        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = voteIndex;
        
        candidates[voteIndex].voteCount += voters[msg.sender].weight;
    }
    
    function end() public{
        require(msg.sender == owner);
        require(now >= auctionEnd);
        
        for(uint i = 0; i < candidates.length; i++){
            ElectionResult(candidates[i].name, candidates[i].voteCount);
        }
    }
}