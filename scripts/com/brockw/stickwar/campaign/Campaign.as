package com.brockw.stickwar.campaign
{
   import com.brockw.stickwar.engine.Team.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class Campaign
   {
      
      public static const CampaignConstants:Class = Campaign_CampaignConstants;
      
      public static const D_NORMAL:int = 1;
      
      public static const D_HARD:int = 2;
      
      public static const D_INSANE:int = 3;
       
      
      public var xml:XML;
      
      private var _levels:Array;
      
      private var _currentLevel:int;
      
      public var upgradeMap:Dictionary;
      
      private var _justTutorial:Boolean;
      
      public var campaignPoints:int;
      
      public var techAllowed:Dictionary;
      
      public var difficultyLevel:int;
      
      public var isAutoSaveEnabled:Boolean;
      
      public function Campaign(param1:int, param2:int)
      {
         var _loc5_:* = undefined;
         super();
         this.levels = [];
         this.techAllowed = new Dictionary();
         this.campaignPoints = 0;
         var _loc3_:ByteArray = new Campaign.CampaignConstants();
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.length);
         this.xml = new XML(_loc4_);
         for each(_loc5_ in this.xml.level)
         {
            this.levels.push(new Level(_loc5_));
         }
         this.currentLevel = param1;
         this.campaignPoints = param1;
         this.initUpgradeTree();
         this.difficultyLevel = param2;
         this.justTutorial = false;
         this.isAutoSaveEnabled = false;
      }
      
      private function getDifficultyDescription() : String
      {
         if(this.difficultyLevel == Campaign.D_NORMAL)
         {
            return "normal";
         }
         if(this.difficultyLevel == Campaign.D_HARD)
         {
            return "hard";
         }
         if(this.difficultyLevel == Campaign.D_INSANE)
         {
            return "insane";
         }
         return "";
      }
      
      public function getLevelDescription() : String
      {
         return "level" + this.currentLevel + "_" + this.getDifficultyDescription();
      }
      
      public function isGameFinished() : Boolean
      {
         return this.currentLevel >= this.levels.length;
      }
      
      private function initUpgradeTree() : void
      {
         var _loc1_:CampaignUpgrade = null;
         this.upgradeMap = new Dictionary();
         _loc1_ = new CampaignUpgrade("Castle Archer I",[],["Rage"],Tech.CASTLE_ARCHER_1);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_.upgraded = true;
         this.techAllowed[_loc1_.tech] = 1;
         _loc1_ = new CampaignUpgrade("Rage",["Castle Archer I"],["Block","Passive Income I"],Tech.SWORDWRATH_RAGE);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Block",["Rage"],["Shield Bash"],Tech.BLOCK);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Shield Bash",["Block"],["Fire Arrow","Cloak"],Tech.SHIELD_BASH);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Fire Arrow",["Shield Bash"],["Giant Growth I"],Tech.ARCHIDON_FIRE);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Giant Growth I",["Fire Arrow"],["Giant Growth II"],Tech.GIANT_GROWTH_I);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Giant Growth II",["Giant Growth I"],[],Tech.GIANT_GROWTH_II);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Cloak_BASIC",["Shield Bash"],[],Tech.CLOAK);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_.upgraded = true;
         _loc1_ = new CampaignUpgrade("Cloak",["Shield Bash"],[],Tech.CLOAK_II);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Passive Income I",["Rage"],["Miner Speed","Castle Archer II"],Tech.BANK_PASSIVE_1);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Miner Speed",["Passive Income I"],["Passive Income II","Cure"],Tech.MINER_SPEED);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Passive Income II",["Miner Speed"],["Tower Spawn I"],Tech.BANK_PASSIVE_2);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Tower Spawn I",["Passive Income II"],["Tower Spawn II"],Tech.TOWER_SPAWN_I);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Tower Spawn II",["Tower Spawn I"],[],Tech.TOWER_SPAWN_II);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Castle Archer II",["Passive Income I"],["Castle Archer III"],Tech.CASTLE_ARCHER_2);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Castle Archer III",["Castle Archer II"],["Miner Wall"],Tech.CASTLE_ARCHER_3);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Miner Wall",["Castle Archer III"],["Statue Health"],Tech.MINER_WALL);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Statue Health",["Miner Wall"],["Castle Archer IV"],Tech.STATUE_HEALTH);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Cure",["Miner Speed"],["Electric Wall"],Tech.MONK_CURE);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Electric Wall",["Cure"],["Poison Spray"],Tech.MAGIKILL_WALL);
         this.upgradeMap[_loc1_.name] = _loc1_;
         _loc1_ = new CampaignUpgrade("Poison Spray",["Electric Wall"],[],Tech.MAGIKILL_POISON);
         this.upgradeMap[_loc1_.name] = _loc1_;
      }
      
      public function toString() : String
      {
         return "Camapign: " + this.currentLevel;
      }
      
      public function XMLLoader() : void
      {
      }
      
      public function getCurrentLevel() : Level
      {
         return this.levels[this._currentLevel];
      }
      
      public function get currentLevel() : int
      {
         return this._currentLevel;
      }
      
      public function set currentLevel(param1:int) : void
      {
         this._currentLevel = param1;
      }
      
      public function setDifficulty(param1:int) : void
      {
         this.difficultyLevel = param1;
      }
      
      public function save() : void
      {
         var _loc3_:CampaignUpgrade = null;
         var _loc4_:Array = null;
         var _loc5_:Level = null;
         var _loc6_:Object = null;
         var _loc1_:SharedObject = SharedObject.getLocal("stickempiresSave");
         _loc1_.data.currentLevel = this.currentLevel;
         _loc1_.data.campaignPoints = this.campaignPoints;
         _loc1_.data.difficultyLevel = this.difficultyLevel;
         var _loc2_:Array = new Array();
         trace("techs");
         for each(_loc3_ in this.upgradeMap)
         {
            if(_loc3_.upgraded)
            {
               _loc2_.push(_loc3_.name);
            }
         }
         _loc4_ = new Array();
         for each(_loc5_ in this.levels)
         {
            (_loc6_ = new Object())["bestTime"] = _loc5_.bestTime;
            _loc6_["totalTime"] = _loc5_.totalTime;
            _loc6_["retries"] = _loc5_.retries;
            _loc4_.push(_loc6_);
         }
         _loc1_.data.levels = _loc4_;
         _loc1_.data.techAllowed = _loc2_;
         _loc1_.flush();
         trace("Saved the game");
      }
      
      public function saveGameExists() : Boolean
      {
         var _loc1_:SharedObject = SharedObject.getLocal("stickempiresSave");
         return _loc1_.data.currentLevel > 0;
      }
      
      public function load() : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Level = null;
         var _loc1_:SharedObject = SharedObject.getLocal("stickempiresSave");
         if(_loc1_.data.currentLevel <= 0)
         {
            return;
         }
         this.currentLevel = _loc1_.data.currentLevel;
         this.campaignPoints = _loc1_.data.campaignPoints;
         this.difficultyLevel = _loc1_.data.difficultyLevel;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_.data.techAllowed)
         {
            this.upgradeMap[_loc3_].upgraded = 1;
            this.techAllowed[this.upgradeMap[_loc3_].tech] = 1;
         }
         _loc4_ = 0;
         for each(_loc5_ in _loc1_.data.levels)
         {
            (_loc6_ = Level(this.levels[_loc4_])).retries = _loc5_["retries"];
            _loc6_.totalTime = _loc5_["totalTime"];
            _loc6_.bestTime = _loc5_["bestTime"];
            _loc4_++;
         }
         _loc1_.data.levels = this.levels;
         trace("Loaded campaign at level ",this.currentLevel);
      }
      
      public function get justTutorial() : Boolean
      {
         return this._justTutorial;
      }
      
      public function set justTutorial(param1:Boolean) : void
      {
         this._justTutorial = param1;
      }
      
      public function get levels() : Array
      {
         return this._levels;
      }
      
      public function set levels(param1:Array) : void
      {
         this._levels = param1;
      }
   }
}
