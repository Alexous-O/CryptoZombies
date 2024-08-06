pragma solidity 0.4.19;

import "./zombiefactory.sol";


contract KittyInterface {                                                                  // Lecture du code source des CryptoKitties qui retourne toutes les données des chatons pourcréer de nouveaux zombies
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {                                                   // ZombieFeeding hérite de toutes les méthodes de ZombieFactory

  KittyInterface kittyContract;

  modifier ownerOf(uint _zombieId) {                                                        // Vérifier que le zombie attaquant appartient bien à l'utilisateur
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {                                // Fonction qui active un compte a rebour 
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {                    // Fonction qui vérifie si un zombie peut manger ou non
      return (_zombie.readyTime <= now);
  }


  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
      Zombie storage myZombie = zombies[_zombieId];                                           // Permet de déclarer le zombie localement pour le stockage
      require(_isReady(myZombie));                                                            // Vérifier si le zombie est prêt à manger ou non
      _targetDna = _targetDna % dnaModulus;                                                   // Vérifier la longeur de 16 chiffres
      uint newDna = (myZombie.dna + _targetDna) / 2;                                          // Nouveau zombie sera égal à la moyenne de l'ADN de myZombie et de _targetDna
      if (keccak256(_species) == keccak256("kitty")) {                                        // compare le hachage keccak256 de _species et la chaîne de caractère "kitty"
      newDna = newDna - newDna % 100 + 99;                                                    // Remplace les 2 derniers chiffres de l'ADN par 99
    }
      _createZombie("NoName", newDna);                                                        // Création du nouveau zombie
      _triggerCooldown(myZombie);                                                             // Déclenche le compte à rebour quand l'action de manger est lancer
    }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {                                // Fonction pour récupérer les gènes des chattons
      uint kittyDna;                                                                          // "kittyDna" permet de stocker les valeurs des "genes" du "getKitty"
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);                                 // "getKitty" retourne une tonne de variables (10), nous voulons que la "genes" d'où les virgules 
      feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}