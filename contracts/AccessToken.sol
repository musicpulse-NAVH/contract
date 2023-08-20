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

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        revert("Transfers are disabled");
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        revert("Transfers are disabled");
    }
}
}