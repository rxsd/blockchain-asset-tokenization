// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ownable.sol";

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
contract AssetCreation is IERC20, Ownable {
    
    string public name;
    string public constant symbol = "ERC";
    uint8 public constant decimals = 18;
    uint8 constant maxTokensPerAsset = 5;
    uint256 public totalSupply;
    uint256 public totalAllocated;
    uint256 constant maxAllocationFrac = 10000;
    

    struct Asset {
        uint id;
        string name; //name of the asset
        string location; // location of the asset
        uint256 value; // Monetary value of asset
        uint256 age; // Age of the asset
        uint256 squareFootage; // Total size of the asset
        uint256 bedroomNumber; // Number of bedrooms asset has
        string information; // Information about the asset
        address owner;   

    }

    Asset [] public assets; // Array to store the assets
    uint256 public nextAssetId; // ID for the next asset

    
    mapping(uint256 => address) public assetToOwner; // Mapping from asset ID to owner's address
    mapping(address => uint256) public balances; // Mapping of address balance 
    mapping(address => mapping (address => uint256)) allowed;

    event AssetCreated(string name, string location, uint value);

    // Constructor sets the total supply and assigns it all to the contract creator
    constructor(string memory _name, uint256 _initialSupply) {
         
        name = _name;
        
        totalSupply = _initialSupply;
        //balances[msg.sender] = _initialSupply;
        
    }

    // Function to add a new asset
    function addNewAsset(string memory _name, string memory _location, uint256 _value, uint256 _age, uint256 _squareFootage, uint256 _bedroomNumber, string memory _information) public {

        // Creates a new Asset struct and adds it to the assets array
        assets.push(Asset(nextAssetId, _name, _location, _value, _age, _squareFootage, _bedroomNumber, _information, msg.sender));

        // Allocate tokens for asset creation
        require(balances[msg.sender] + maxTokensPerAsset <= totalSupply, "Insufficient tokens available");
        balances[msg.sender] += maxTokensPerAsset;

        // Maps the newly created asset ID to the address of the owner (msg.sender)
        assetToOwner[nextAssetId] = msg.sender;



        // Increments the ID for the next asset to be added
        nextAssetId++;
        // emir new asset has been created
        emit AssetCreated(_name, _location, _value);
    }
    
    function getTotalAssets() public view returns (uint) {
        return assets.length;
    }

    function getCurrentSupply() public view returns (uint256){
        return totalAllocated;
    }

    // Returns the total token supply
    function _totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function allocateInitialTokens(address user, uint256 amount) public onlyOwner {
        require(balances[user] == 0, "User already has tokens");
        require(totalAllocated + amount <= totalSupply, "Exceeds total supply");
        require(amount <= totalSupply / maxAllocationFrac, "Allocation exceeds maximum number of tokens allowed");
        balances[user] = amount;
        totalAllocated += amount;
    }

    // Returns the balance of a given account
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function mint(address to, uint256 amount) public onlyOwner {
        //require(msg.sender == owner, "Only owner can mint");
        require(to != address(0), "Cannot mint to null address");
        totalSupply += amount;
        balances[to] += amount;


    }


    // Transfer tokens to a specified address
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender], "Insufficient balance");
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
    function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }








}