//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MYERC721{
    string public _name;
    string public _symbol;
    uint public total_Supply;

    // Mapping owner address to token count
    mapping(address=> uint) private _balances;
    
    // Mapping from token ID to owner address
    mapping(uint=>address) private _owners;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;


    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;

    }
    function mint(address _to, uint256 _tokenId) public {
        require(_to != address(0), "Invalid recipient address");
        require(!_exists(_tokenId), "Token ID already exists");

        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }


    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

     function ownerOf(uint256 tokenId) public view  returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Not approved to transfer");
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function _exists(uint256 _tokenId) internal view returns (bool) {
        return _owners[_tokenId] != address(0);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_exists(_tokenId), "Invalid token ID");
        return _tokenApprovals[_tokenId];
    }
     

    function setApprovalForAll(address _operator, bool _approved) public {
        require(_operator != msg.sender, "Cannot set approval for self");
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_from == owner || getApproved(_tokenId) == msg.sender || isApprovedForAll(owner, msg.sender), "Not approved to transfer");
        require(_to != address(0), "Invalid recipient address");

        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
        transferFrom(_from, _to, _tokenId);
        require(_checkOnERC721Received(_from, _to, _tokenId, _data), "Transfer to non-ERC721Receiver implementer");
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

function _checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if (!_isContract(_to)) {
            return true;
        }

        bytes4 onERC721Received = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return onERC721Received == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
function _isContract(address _addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}
    interface IERC721Receiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns (bytes4);
}