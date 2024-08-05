pragma solidity 0.4.19;

contract ZombieFactory {
  

    event NewZombie(uint zombieId, string name, uint dna);
    /* 
    Dans cet exemple de contrat, nous avons créé un uint appelé myUnsignedInteger qui a pour valeur 100.
    Le type de données uint est un entier non signé, cela veut dire que sa valeur doit être non négative. 
    */

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;                                                      //Pour être sûr que notre ADN Zombie est seulement de 16 chiffres, définissons un autre uint égal à 10^16

    struct Zombie {                                                                         // Creation des attributs des zombies
        string name ;
        uint  dna ;
    }

    Zombie[] public zombies;                                                                // creation du tableaux qui permetttra de stocker tous les zombies

    mapping (uint => address) public zombieToOwner;                                         // 1dresse associée à un zombie
    mapping (address => uint) ownerZombieCount;                                             // Combien de zombies un utilisateur possède

    function _createZombie(string _name, uint _dna) private {                               // Fonction pour créer des zombies
        uint id = zombies.push(Zombie(_name, _dna)) - 1;                                    // Crreation d'un zombie avec les arguments de la fonction + ajout dans le tableau "zombies"
        zombieToOwner[id] = msg.sender;                                                     // Mettons à jour notre mappage
        ownerZombieCount[msg.sender]++;
        
        NewZombie(id, _name, _dna);                         
    }

    function _generateRandomDna(string _str) private view returns (uint) {                  // Fonction d'aide pour générer un nombre ADN aléatoire à partir d'une chaîne de caractères
        uint rand = uint(keccak256(_str));                                                  // Générer un nombre pseudo-aléatoire hexadécimal
        return rand % dnaModulus;                                                           // ADN fasse seulement 16 chiffres
    }

    function createRandomZombie(string _name) internal {
        require(ownerZombieCount[msg.sender] == 0);                                         // Fonction pour qu'elle s'execute une seule fois par utilisateur
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}