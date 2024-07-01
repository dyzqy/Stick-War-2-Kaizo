package com.brockw.stickwar.engine.Team.Elementals
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import flash.display.*;
      import flash.utils.*;
      
      public class ElementalTech extends Tech
      {
             
            
            private var game:StickWar;
            
            public function ElementalTech(param1:StickWar, param2:TeamElemental)
            {
                  this.game = param1;
                  this.team = param2;
                  this.initTech(param1);
                  this.initUpgrades(param1,param2);
                  super(param1,param2);
            }
            
            public function initTech(param1:StickWar) : void
            {
            }
            
            private function addNewUpgrade(param1:int, param2:XMLList, param3:Bitmap, param4:int) : void
            {
                  upgrades[param1] = new TechItem(param2,param3);
            }
            
            public function initUpgrades(param1:StickWar, param2:TeamElemental) : void
            {
                  researchingMap = new Object();
                  upgrades = new Dictionary();
                  this.addNewUpgrade(CASTLE_ARCHER_1,param1.xml.xml.Elemental.Tech.castleArchers1,new Bitmap(new castleArcherLevel1Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_2,param1.xml.xml.Elemental.Tech.castleArchers2,new Bitmap(new castleArcherLevel2Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_3,param1.xml.xml.Elemental.Tech.castleArchers3,new Bitmap(new castleArcherLevel3Bitmap()),81);
                  this.addNewUpgrade(STATUE_HEALTH,param1.xml.xml.Order.Tech.statueHealth,new Bitmap(new statueHealthBitmap()),81);
                  this.addNewUpgrade(MINER_SPEED,param1.xml.xml.Order.Tech.minerSpeed,new Bitmap(new minerBagBitmap()),81);
                  this.addNewUpgrade(BANK_PASSIVE_1,param1.xml.xml.Order.Tech.passiveIncomeGold1,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_2,param1.xml.xml.Order.Tech.passiveIncomeGold2,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_3,param1.xml.xml.Order.Tech.passiveIncomeGold3,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(TOWER_SPAWN_I,param1.xml.xml.Chaos.Tech.towerSpawnI,new Bitmap(new towerUpgradeI()),89);
                  this.addNewUpgrade(TOWER_SPAWN_II,param1.xml.xml.Chaos.Tech.towerSpawnII,new Bitmap(new towerUpgradeII()),89);
                  this.addNewUpgrade(CHROME_SPLIT_1,param1.xml.xml.Elemental.Tech.split1,new Bitmap(new splitBitmap()),87);
                  this.addNewUpgrade(CHROME_SPLIT_2,param1.xml.xml.Elemental.Tech.split2,new Bitmap(new deadlyBitmap()),87);
                  this.addNewUpgrade(TREE_POISON,param1.xml.xml.Elemental.Tech.treePoison,new Bitmap(new scorplingHealthBitmap()),87);
                  this.addNewUpgrade(TREE_POISON_2,param1.xml.xml.Elemental.Tech.treePoison2,new Bitmap(new scorplingPoisonBitmap()),87);
                  this.addNewUpgrade(LAVA_POOL,param1.xml.xml.Elemental.Tech.lavaPool,new Bitmap(new meteorBitmap()),87);
                  this.addNewUpgrade(TORNADO,param1.xml.xml.Elemental.Tech.tornado,new Bitmap(new twisterBitmap()),87);
                  this.addNewUpgrade(WATER_HEAL_UPGRADE,param1.xml.xml.Elemental.Tech.waterHealUpgrade,new Bitmap(new waterHealBitmap()),87);
            }
            
            override public function update(param1:StickWar) : void
            {
                  super.update(param1);
            }
            
            override public function isResearching(param1:int) : Boolean
            {
                  return param1 in researchingMap;
            }
            
            override public function getResearchCooldown(param1:int) : Number
            {
                  return researchingMap[param1] / upgrades[param1].researchTime;
            }
      }
}
