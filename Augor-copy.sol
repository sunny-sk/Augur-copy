pragma solidity ^0.5.12;

contract Final{
    
    struct User{
        string name;
        uint amountDeposit;
        int teamNo;
        bool amountRedeem;
    }
    
    uint public totalAmount;
    uint minAmountDeposite = 10 ether;
    uint public perUserAmount;
    
    string public eventTitle;
    uint public team_A_count;
    uint public team_B_count;
    
    int public winner = -1;
    
    mapping(address => User) public team_1;
    // mapping(address => User) public team_2;
    
 
    //create Event
    constructor(string memory _title) public {
        eventTitle = _title;
    }

    // show deposit balance
    function getBalance() external view returns(uint){
            return address(this).balance;
     }
     
   // show total user
   function totalUser() public view returns(uint){
       return (team_A_count + team_B_count);
   }
     
    //adding user
    function addUser(string memory  _name,int  _teamNo) public payable {
        if (msg.value < minAmountDeposite)
         revert("Not enough Ether provided.");
        else if(_teamNo == 1){
              totalAmount += msg.value;
              team_A_count += 1;
              team_1[msg.sender] = User(_name,msg.value,_teamNo,false);  
        }else{
             totalAmount += msg.value;
              team_B_count += 1;
              team_1[msg.sender] = User(_name,msg.value,_teamNo,false);  
        }
    }
    
    //finishing event
    function finishEvent(int winningTeam) external returns(int){
      winner = winningTeam;
      if(winner == 1){
          perUserAmount = totalAmount/team_A_count;
      }else{
          perUserAmount = totalAmount/team_B_count;
      }
      return winner;
    }
    
    //redeem winning amount
    function redeem() public payable{
        require(winner == -1);
        if(team_1[msg.sender].teamNo == winner && team_1[msg.sender].amountRedeem == false){
            (msg.sender).transfer(perUserAmount);
            team_1[msg.sender].amountRedeem = true;
        } 
   }
}