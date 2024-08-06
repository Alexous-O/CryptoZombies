pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  

  uint levelUpFee = 0.001 ether;                                                                    // Prix en ETH pour faire monter de niveau notre zombie


  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {                                              // Fonction pour faire LevelUp notre zombie
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {   // Zombie de Niveau 2, les utilisateurts pourront changer de noms      
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {      // Zombie de Niveau 20 ou plud, les utilisateurts pourront changer leur ADN
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);                                    // Tableaux avec tous les zombies qu'un utilisateur possède
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {                                                     // Boucle qui va parcourir tous les zombies de l'APP
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }


}
