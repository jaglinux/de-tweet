pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

abstract contract ERC721 is IERC721 {
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    function balanceOf(address owner) external view returns (uint256) {
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId) external view returns (address) {
        return _owners[tokenId];
    }
    function approve(address to, uint256 tokenId) external {
        require(_owners[tokenId] == msg.sender, "only owner can approve");
        _tokenApprovals[tokenId] = to;
    }
    function getApproved(uint256 tokenId) external view returns (address) {
        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool _approved) external {
        _operatorApprovals[msg.sender][operator] = _approved;
    }
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(_owners[tokenId] == msg.sender);
        _balances[from]--;
        _balances[to]++;
        _tokenApprovals[tokenId] = address(0);
        _owners[tokenId] = to;
    }
}