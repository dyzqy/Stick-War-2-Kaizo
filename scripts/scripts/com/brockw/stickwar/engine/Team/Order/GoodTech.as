package com.brockw.stickwar.engine.Team.Order
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.Team.TechItem;
      import flash.display.Bitmap;
      import flash.utils.Dictionary;
      
      public class GoodTech extends Tech
      {
             
            
            private var game:StickWar;
            
            public function GoodTech(param1:StickWar, param2:TeamGood)
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
            
            public function initUpgrades(param1:StickWar, param2:TeamGood) : void
            {
                  researchingMap = new Object();
                  upgrades = new Dictionary();
                  this.addNewUpgrade(SWORDWRATH_RAGE,param1.xml.xml.Order.Tech.rage,new Bitmap(new SwordwrathSacrifice()),69);
                  this.addNewUpgrade(BLOCK,param1.xml.xml.Order.Tech.block,new Bitmap(new SpeartanShieldWall()),65);
                  this.addNewUpgrade(CLOAK,param1.xml.xml.Order.Tech.cloak,new Bitmap(new NinjaCloak1()),90);
                  this.addNewUpgrade(CLOAK_II,param1.xml.xml.Order.Tech.cloak2,new Bitmap(new NinjaCloak2()),90);
                  this.addNewUpgrade(ARCHIDON_FIRE,param1.xml.xml.Order.Tech.archidonFire,new Bitmap(new ArchidonFire()),90);
                  this.addNewUpgrade(MAGIKILL_NUKE,param1.xml.xml.Order.Tech.magikillNuke,new Bitmap(new MagikillFireballs()),81);
                  this.addNewUpgrade(MAGIKILL_WALL,param1.xml.xml.Order.Tech.magikillWall,new Bitmap(new MagikillWall()),81);
                  this.addNewUpgrade(MAGIKILL_POISON,param1.xml.xml.Order.Tech.magikillPoison,new Bitmap(new poisonSprayBitmap()),81);
                  this.addNewUpgrade(MONK_CURE,param1.xml.xml.Order.Tech.cure,new Bitmap(new CureBitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_1,param1.xml.xml.Order.Tech.castleArchers1,new Bitmap(new castleArcherLevel1Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_2,param1.xml.xml.Order.Tech.castleArchers2,new Bitmap(new castleArcherLevel2Bitmap()),81);
                  this.addNewUpgrade(CASTLE_ARCHER_3,param1.xml.xml.Order.Tech.castleArchers3,new Bitmap(new castleArcherLevel3Bitmap()),81);
                  this.addNewUpgrade(SHIELD_BASH,param1.xml.xml.Order.Tech.speartonShieldBash,new Bitmap(new shieldHitBitmap()),81);
                  this.addNewUpgrade(STATUE_HEALTH,param1.xml.xml.Order.Tech.statueHealth,new Bitmap(new statueHealthBitmap()),81);
                  this.addNewUpgrade(MINER_SPEED,param1.xml.xml.Order.Tech.minerSpeed,new Bitmap(new minerBagBitmap()),81);
                  this.addNewUpgrade(BANK_PASSIVE_1,param1.xml.xml.Order.Tech.passiveIncomeGold1,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_2,param1.xml.xml.Order.Tech.passiveIncomeGold2,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(BANK_PASSIVE_3,param1.xml.xml.Order.Tech.passiveIncomeGold3,new Bitmap(new passiveIncomeBitmap()),89);
                  this.addNewUpgrade(GIANT_GROWTH_I,param1.xml.xml.Order.Tech.giantSize1,new Bitmap(new GiantGrowth1Bitmap()),81);
                  this.addNewUpgrade(GIANT_GROWTH_II,param1.xml.xml.Order.Tech.giantSize2,new Bitmap(new GiantGrowth2Bitmap()),87);
                  this.addNewUpgrade(MINER_WALL,param1.xml.xml.Order.Tech.minerWall,new Bitmap(new OrderTowerBitmap()),87);
                  this.addNewUpgrade(Tech.CROSSBOW_FIRE,param1.xml.xml.Order.Tech.crossbowFire,new Bitmap(new allbowtrossFireArrowUpgrade()),87);
                  this.addNewUpgrade(TOWER_SPAWN_I,param1.xml.xml.Chaos.Tech.towerSpawnI,new Bitmap(new towerUpgradeI()),89);
                  this.addNewUpgrade(TOWER_SPAWN_II,param1.xml.xml.Chaos.Tech.towerSpawnII,new Bitmap(new towerUpgradeII()),89);
                  this.addNewUpgrade(SPAWN_SHADOW,param1.xml.xml.Elemental.Tech.tornado,new Bitmap(new twisterBitmap()),87);
                  this.addNewUpgrade(SPAWN_MAGE,param1.xml.xml.Elemental.Tech.waterHealUpgrade,new Bitmap(new waterHealBitmap()),87);
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
