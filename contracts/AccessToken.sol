// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessToken is ERC20, Ownable {
    mapping(address => bool) private _soulbound;

    constructor() payable ERC20("Access Token", "AT") {}

    function mint(address account) public {
        _mint(account, 1 * 10 ** 18);
    }

    function setSoulbound(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        _soulbound[account] = true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (_soulbound[from]) {
            require(to == address(0), "Access Tokens are non-transferable");
        }
        super._beforeTokenTransfer(from, to, amount);
    }
}