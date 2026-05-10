//SPDX-License-Identifier:MIT

pragma solidity ^0.8.30;


contract Votingproject{
    address public Owner;
    constructor(){
        Owner = msg.sender;
    }

    struct Candidate{
        string name;
        string symbol;
        uint votes;

    }

    Candidate[] candidates;

    mapping(address=>bool) private voters;

    modifier onlyowner(){
        require(msg.sender == Owner,"your not admin");
        _;
    }

    function addCandidate(string memory _name,string memory _symbol)public onlyowner{
        candidates.push(Candidate({
            name:_name,
            symbol:_symbol,
            votes:0
        }));
            
    }

    function vote(uint _candidateIndex) public {
        require(_candidateIndex < candidates.length,"Invalid candidate");
        require(!voters[msg.sender],"Already voted");
        voters[msg.sender]=true;
        candidates[_candidateIndex].votes++;

    } 

    function getwinner() public view returns(string memory, string memory, uint){
        uint maximumvotes;
        uint winnerindex;
        for(uint i=0;i<candidates.length;i++){
            if(candidates[i].votes > maximumvotes){
                maximumvotes=candidates[i].votes;
                winnerindex=i;   
            }
        }

        Candidate memory winner=candidates[winnerindex];
        return(winner.name,winner.symbol,winner.votes);
       
    }

    function getcandidatevotes(uint _index) public view returns(uint){
        require(_index <= candidates.length,"Invalid candidate");
        return candidates[_index].votes;
    }

    

    

}


//contract address - 0x96c5d2e36181663B9c96B5bF38A4cCB6e94b09aA