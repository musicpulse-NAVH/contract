// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Create2.sol";
import "./interfaces/IERC6551Registry.sol";
import "./AccessToken.sol";

contract ERC6551Registry is IERC6551Registry {
    error InitializationFailed();

    AccessToken public token;
    mapping(address => address) public tba_to_erc20;
    mapping(address => string) private tba_to_url;

    event Purchased(uint256 indexed nftid, address from, uint date);
    event AccessTokenCreated(address nftcontract, address accesstokencontract);

    function createAccount(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt,
        bytes calldata initData
    ) external returns (address) {
        bytes memory code = _creationCode(
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );

        address _account = Create2.computeAddress(
            bytes32(salt),
            keccak256(code)
        );

        if (_account.code.length != 0) return _account;

        _account = Create2.deploy(0, bytes32(salt), code);

        if (initData.length != 0) {
            (bool success, ) = _account.call(initData);
            if (!success) revert InitializationFailed();
        }

        emit AccountCreated(
            _account,
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );

        return _account;
    }

    function account(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external view returns (address) {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
    }

    function _creationCode(
        address implementation_,
        uint256 chainId_,
        address tokenContract_,
        uint256 tokenId_,
        uint256 salt_
    ) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                hex"3d60ad80600a3d3981f3363d3d373d3d3d363d73",
                implementation_,
                hex"5af43d82803e903d91602b57fd5bf3",
                abi.encode(salt_, chainId_, tokenContract_, tokenId_)
            );
    }

    function createAccessToken(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external payable {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        address nftAccount = Create2.computeAddress(bytes32(salt), bytecodeHash);

        AccessToken accessContract = new AccessToken();
        tba_to_erc20[nftAccount] = address(accessContract);

        emit AccessTokenCreated(address(accessContract), nftAccount);
    }

    function setURL(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt,
        string calldata url
    ) external {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        address nftAccount = Create2.computeAddress(bytes32(salt), bytecodeHash);

        tba_to_url[nftAccount] = url;
    }

    function getURL(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external view returns (string memory) {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );
        
        address nftAccount = Create2.computeAddress(bytes32(salt), bytecodeHash);

        require(AccessToken(tba_to_erc20[nftAccount]).balanceOf(msg.sender) > 0, "You do not have the Access Token");

        return tba_to_url[nftAccount];
    }

    function purchaseAccessToken(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external payable {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        address nftAccount = Create2.computeAddress(bytes32(salt), bytecodeHash);

        (bool success, ) = nftAccount.call{value: msg.value}("");
        require(success, "Failed to send ETH");
        AccessToken(tba_to_erc20[nftAccount]).mint(msg.sender);

        emit Purchased(tokenId, msg.sender, block.timestamp);
    }
}