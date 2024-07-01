package com.brockw.stickwar.engine.Team.Chaos
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import flash.display.*;
      import flash.utils.*;
      
      public class ChaosTech extends Tech
      {
             
            
            private var game:StickWar;
            
            public function ChaosTech(param1:StickWar, param2:TeamChaos)
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
            
            public function initUpgrades(param1:StickWar, param2:TeamChaos) : void
            {
                  researchingMap = new Object();
                  upgrades = new Dictionary();
                  this.addNewUpgrade(CASTLE_ARCHER_1,param1.xml.xml.Chaos.Tech.castleArchers1,new Bitmap(new castleArcherLevel1Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_2,param1.xml.xml.Chaos.Tech.castleArchers2,new Bitmap(new castleArcherLevel2Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_3,param1.xml.xml.Chaos.Tech.castleArchers3,new Bitmap(new castleArcherLevel3Bitmap()),81);
                  this.addNewUpgrade(DEAD_POISON,param1.xml.xml.Chaos.Tech.deadPoison,new Bitmap(new poisonGutsBitmap()),81);
                  this.addNewUpgrade(CAT_PACK,param1.xml.xml.Chaos.Tech.catPack,new Bitmap(new packMentalityBitmap()),81);
                  this.addNewUpgrade(MEDUSA_POISON,param1.xml.xml.Chaos.Tech.medusaPoison,new Bitmap(new poisonPoolBitmap()),81);
                  this.addNewUpgrade(KNIGHT_CHARGE,param1.xml.xml.Chaos.Tech.knightCharge,new Bitmap(new knightChargeBitmap()),81);
                  this.addNewUpgrade(SKELETON_FIST_ATTACK,param1.xml.xml.Chaos.Tech.skeletonFistAttack,new Bitmap(new skeletalFistBitmap()),81);
                  this.addNewUpgrade(STATUE_HEALTH,param1.xml.xml.Chaos.Tech.statueHealth,new Bitmap(new statueHealthBitmap()),81);
                  this.addNewUpgrade(BANK_PASSIVE_1,param1.xml.xml.Order.Tech.passiveIncomeGold1,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_2,param1.xml.xml.Order.Tech.passiveIncomeGold2,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_3,param1.xml.xml.Order.Tech.passiveIncomeGold3,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(MINER_SPEED,param1.xml.xml.Order.Tech.minerSpeed,new Bitmap(new minerBagBitmap()),81);
                  this.addNewUpgrade(CHAOS_GIANT_GROWTH_I,param1.xml.xml.Chaos.Tech.giantSize1,new Bitmap(new giantLevel1Bitmap()),81);
                  this.addNewUpgrade(CHAOS_GIANT_GROWTH_II,param1.xml.xml.Chaos.Tech.giantSize2,new Bitmap(new giantLevel2Bitmap()),81);
                  this.addNewUpgrade(MINER_TOWER,param1.xml.xml.Chaos.Tech.minerTower,new Bitmap(new ChaosTowerBitmap()),87);
                  this.addNewUpgrade(CAT_SPEED,param1.xml.xml.Chaos.Tech.catSpeed,new Bitmap(new CrawlerSpeedBitmap()),87);
                  this.addNewUpgrade(TOWER_SPAWN_I,param1.xml.xml.Chaos.Tech.towerSpawnI,new Bitmap(new towerUpgradeI()),89);
                  this.addNewUpgrade(TOWER_SPAWN_II,param1.xml.xml.Chaos.Tech.towerSpawnII,new Bitmap(new towerUpgradeII()),89);
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
