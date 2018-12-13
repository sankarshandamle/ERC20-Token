pragma solidity ^0.4.25;

interface ERC20 {
    // 6 events
    function totalSupply() external view returns (uint256 supply);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    
    // 2 events
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// inherit the interface
contract myToken is ERC20 {
    uint256 balance;
    uint256 totalTokens=0;
    uint256 totalEther=0;
    
    // defining the token
    string public tokenName = "myToken";
    string public tokenSymbol = "mT";
    uint256 public tokenUnits = 18;  // 1 Token = 1 Ether
    
    // to hold the balances for each account
    mapping (address => uint256) balances;
    
    // to only allow owners of the account to approve transfer of their balances
    mapping (address => mapping (address => uint256)) allowed;
    
    function totalSupply() public view returns (uint256) {
        return totalTokens;
    }
    
    function balanceOf(address _id) public view returns (uint256) {
        return balances[_id];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        balances[_to] = balances[_to] + _value;
        balances[msg.sender] = balances[msg.sender] - _value;
        totalTokens = totalTokens + _value;
        totalEther = totalEther + _value;
        // invoke the event
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
       balances[_to] = balances[_to] + _value;
       allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
       balances[_from] = balances[_from] - _value;
       totalTokens = totalTokens + _value;
       totalEther = totalEther + _value;
       // invoke the event
       emit Transfer(_from, _to, _value);
       return true;
   }
   
   function approve(address _spender, uint256 _value) public returns (bool) {
       allowed[_spender][msg.sender] = _value;
       // invoke the event
       emit Approval(msg.sender, _spender, _value);
       return true;
   }
   
   function allowance(address _owner, address _spender) public view returns (uint256) {
       return allowed[_spender][_owner];
   }
   
   // helpder function to display the total ether in circulation
   function totalMoney() public view returns(uint256) {
       return totalEther;
   }
   
   // fallback function to collect tokens(ether) 
   function () public payable {
       balances[msg.sender] = msg.value;
   }
}
