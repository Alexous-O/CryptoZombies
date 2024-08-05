pragma solidity 0.4.19;

import "./zombiefactory.sol";


contract KittyInterface {                                                                       // Lecture du code source des CryptoKitties qui retourne toutes les données des chatons pourcréer de nouveaux zombies
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

contract ZombieFeeding is ZombieFactory {                                                       // ZombieFeeding hérite de toutes les méthodes de ZombieFactory

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;                             // Adresse du contrat CryptoKitties
    KittyInterface kittyContract = KittyInterface(ckAddress);                                   // Création d'une KittyInterface initialisez à l'adresse du contrat de ck (CryptoKitties)


    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);                                        // Vérifier si nous sommes le propriétaire du Zombie
        Zombie storage myZombie = zombies[_zombieId];                                           // Permet de déclarer le zombie localement pour le stockage
        _targetDna = _targetDna % dnaModulus;                                                   // Vérifier la longeur de 16 chiffres
        uint newDna = (myZombie.dna + _targetDna) / 2;                                          // Nouveau zombie sera égal à la moyenne de l'ADN de myZombie et de _targetDna
        if (keccak256(_species) == keccak256("kitty")) {                                        // compare le hachage keccak256 de _species et la chaîne de caractère "kitty"
        newDna = newDna - newDna % 100 + 99;                                                    // Remplace les 2 derniers chiffres de l'ADN par 99
    }
        _createZombie("NoName", newDna);                                                        // Création du nouveau zombie
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {                                // Fonction pour récupérer les gènes des chattons
        uint kittyDna;                                                                          // "kittyDna" permet de stocker les valeurs des "genes" du "getKitty"
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);                                 // "getKitty" retourne une tonne de variables (10), nous voulons que la "genes" d'où les virgules 
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}