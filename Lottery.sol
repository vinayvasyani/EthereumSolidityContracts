pragma solidity ^0.4.17;


contract Lottery{
    address public manager;
    address[] public players;

    constructor() public {
        manager = msg.sender;        
    }

    function enter() public payable { 
        require(msg.value > 0.01 ether);
        players.push(msg.sender);          
    }

    function random() private restricted view returns(uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance); //Ethereum contract total balance that is referred by this.balance. 
        players = new address[](0); 
    }

    modifier restricted() { 
        require(msg.sender == manager);
        _; // This is hook for replacing _ with function code that uses this modifier. 
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}