pragma solidity 0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";


/// @title CryptoZombies
/// @author Briiiochee
/// @notice Programmation blockchain

contract ZombieOwnership is ZombieAttack, ERC721 {

    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerZombieCount[_owner];                                                // Renvoie le nomre de zombie que l'utilisateur a
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return zombieToOwner[_tokenId]; // Renvoie le nomre de                         // Renvoie l'utilisateur du token ici
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {        // Fonction de transfer de token avec l'adresse de destination et l'ID du token
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {          // Fonction où seulement le propriétaire du token puisse donner à quelqu'un l'autorisation de le prendre
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {                                       // Fonction qui vérifie que l'utilisateur a été approuvé à prendre ce token
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}