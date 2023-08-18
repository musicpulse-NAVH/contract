// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AccessToken is ERC20 {
    constructor() payable ERC20("Access Token", "AT") {}

    function mint(address account) public {
        _mint(account, 1 * 10 ** 18);
    }
}