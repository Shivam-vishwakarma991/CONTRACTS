
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MYToken {

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    uint total_Supply;
    string public TokenName;
    address public Owner;

    mapping(address=> uint)  balances;
    mapping(address=>mapping(address=> uint))  allowed;
        
    constructor(string memory _Tokenname, uint256 total) {
    total_Supply = total;
    TokenName= _Tokenname;
    Owner=msg.sender;

    balances[msg.sender] = total_Supply;
}

function totalSupply() public view returns (uint256 totalsupply) {
  return total_Supply;
}

function balanceOf(address tokenOwner) public view returns (uint) {
  return balances[tokenOwner];
}

function mint(address to, uint amount) external{
    require(msg.sender==Owner, "You are not the owner");
    require(amount>0, "amount should be greater than zero");
    balances[to]+=amount;
    total_Supply+=amount;
    emit Transfer(msg.sender,to,amount);
}



function transfer(address recepient, uint amount) public returns(bool success){
    require(balances[msg.sender]>= amount, "Sender does not have enough balance to transfer");
    balances[msg.sender]-= amount;
    balances[recepient]+= amount;
    emit Transfer(msg.sender, recepient, amount);
    return true;
}


function TransferFrom(address owner, address receiver, uint amount) public returns(bool){
    require(balances[owner]>= amount, "Insufficient balance");
    require(allowed[owner][msg.sender]>= amount);
    allowed[owner][msg.sender]-= amount;
    balances[owner]-= amount;
    balances[receiver]+=amount;
    emit Transfer(owner,receiver,amount);
    return true;
}

function approve(address _spender, uint256 _amount) public returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    emit Approval(msg.sender, _spender, _amount);
    return true;
  }

 function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  function burnTokens(uint token) public{
      require(token>0, "Amount should be greater than zero");
      require(balances[msg.sender]>token, "Insufficient tokens");
      balances[msg.sender]-=token;
      total_Supply-=token;
  }
}

// address 1-> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// address 2-> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// address 3-> 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB  approvew
// address 4-> 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
// address 5-> 0x17F6AD8Ef982297579C203069C1DbfFE4348c372
// address 6-> 0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7