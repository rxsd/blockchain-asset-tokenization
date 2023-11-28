// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define the ERC-20 Token standard interface
interface IERC20 {
    // Returns the total token supply
    function totalSupply() external view returns (uint256);

    // Returns the account balance of another account with address tokenOwner
    function balanceOf(address account) external view returns (uint256);

    // Returns the amount which spender is still allowed to withdraw from owner
    function allowance(address owner, address spender) external view returns (uint256);

    // Transfers numTokens amount of tokens to address receiver
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Allows spender to withdraw from your account multiple times, up to the numTokens amount
    function approve(address spender, uint256 amount) external returns (bool);

    // Transfers numTokens from address owner to address buyer
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Triggered when tokens are transferred, including zero value transfers
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Triggered whenever approve(address spender, uint256 value) is called
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ERC20Basic contract implementing the IERC20 interface
contract ERC20Basic is IERC20 {
    
    string public constant name = "ERC20Basic";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;

    
    mapping(address => uint256) balances;

    
    mapping(address => mapping (address => uint256)) allowed;

    // Total supply of the token
    uint256 totalSupply_ = 10 ether;

    // Constructor sets the total supply and assigns it all to the contract creator
    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    // Returns the total token supply
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    // Returns the balance of a given account
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    // Transfer tokens to a specified address
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // Approve an address to spend a specific amount of tokens on your behalf
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    // Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner
    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    // Transfer tokens from one address to another
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}