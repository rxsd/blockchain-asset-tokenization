// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./assetcreation.sol";
import "./erc20.sol";

contract AssetTokenization is AssetCreation, IERC20{


   function tokeniseAsset(uint256 assetId, uint256 tokenAmount) public {
        require(assetToOwner[assetId] == msg.sender, "Caller is not the asset owner");
        require(tokenAmount > 0, "Token amount must be greater than zero");

        _mint(msg.sender, tokenAmount);

    
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Minting to no address");

        totalSupply_ += amount; 
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
}





}