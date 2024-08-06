pragma solidity ^0.4.19;

import "./zombiehelper.sol";


contract ZombieBattle is ZombieHelper {

    uint randNonce = 0;
    uint attackVictoryProbability = 70;                                                     // Zombie qui attaque à 70% de gagner 

  function randMod(uint _modulus) internal returns(uint) {                                  // Fonction de nombre aléatoire
    randNonce = randNonce.add(1);
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);

    if (rand <= attackVictoryProbability) {
    myZombie.winCount = myZombie.winCount.add(1);                                              // Le compteur de victoire prendre + 1 pour votre zombie
    myZombie.level = myZombie.level.add(1);                                                    // Le level de votre zombie prendre + 1
    enemyZombie.lossCount = enemyZombie.lossCount.add(1);                                      // Le compteur de défaite prendre + 1 pour le zombie ennemie                                                             
    feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
    myZombie.lossCount = myZombie.lossCount.add(1);                                            // Le compteur de défaite prendre + 1 pour votre zombie
    enemyZombie.winCount = enemyZombie.winCount.add(1);                                        // Le compteur de victoire prendre + 1 du zombie adverse                                                      
    }
    _triggerCooldown(myZombie);
  }
}
