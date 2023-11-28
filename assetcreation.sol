// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssetTokenization {

    struct Asset {
        uint id;
        string name; //name of the asset
        string location; // location of the asset
        uint value; // Monetary value of asset
        uint256 age; // Age of the asset
        uint256 squareFootage; // Total size of the asset
        uint bedroomNumber; // Number of bedrooms asset has
        string information; // Information about the asset
        address owner;   

    }

    Asset [] public assets; // Array to store the assets
    uint256 public nextAssetId; // ID for the next asset

    mapping(uint256 => address) public assetToOwner; // Mapping from asset ID to owner's address


    function addNewAsset(string memory _name, string memory _location, uint256 _value, uint256 _age, uint256 _squareFootage, uint256 _bedroomNumber, string information
}