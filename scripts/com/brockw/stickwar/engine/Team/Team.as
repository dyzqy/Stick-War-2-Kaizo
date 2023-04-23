package com.brockw.stickwar.engine.Team
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Ai.MinerAi;
   import com.brockw.stickwar.engine.Ai.TeamAi;
   import com.brockw.stickwar.engine.Ai.command.AttackMoveCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Chaos.TeamChaos;
   import com.brockw.stickwar.engine.Team.Elementals.TeamElemental;
   import com.brockw.stickwar.engine.Team.Order.TeamGood;
   import com.brockw.stickwar.engine.UserInterface;
   import com.brockw.stickwar.engine.maps.Map;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitCreateMove;
   import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
   import com.brockw.stickwar.engine.units.Sandstorm;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.Wall;
   import com.brockw.stickwar.market.Loadout;
   import com.brockw.stickwar.singleplayer.SingleplayerGameScreen;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class Team
   {
      
      public static const POP_CAP:int = 50;
      
      public static const T_GOOD:int = 0;
      
      public static const T_CHAOS:int = 1;
      
      public static const T_ELEMENTAL:int = 2;
      
      public static const T_RANDOM:int = 3;
      
      public static const SPAWN_OFFSET_X:int = 100;
      
      public static const G_GARRISON:int = 0;
      
      public static const G_DEFEND:int = 1;
      
      public static const G_ATTACK:int = 2;
      
      public static const G_GARRISON_MINER:int = 3;
      
      public static const G_UNGARRISON_MINER:int = 4;
       
      
      public var averagePosition:Number;
      
      public var medianPosition:Number;
      
      public var attackingForcePopulation:int;
      
      private var _unitsAvailable:Dictionary;
      
      protected var _handicap:Number;
      
      protected var buildingHighlights:Array;
      
      private var _loadout:Loadout;
      
      private var _type:int;
      
      private var _isAi:Boolean;
      
      private var visionArray:Array;
      
      public var register:int;
      
      private var _name:int;
      
      private var _healthModifier:Number;
      
      private var _direction:int;
      
      private var _homeX:int;
      
      private var _gold:int;
      
      private var _mana:Number;
      
      private var _isEnemy:Boolean;
      
      private var _currentAttackState:int;
      
      private var _units:Array;
      
      private var _deadUnits:Array;
      
      private var _enemyTeam:com.brockw.stickwar.engine.Team.Team;
      
      private var _ai:TeamAi;
      
      private var _forwardUnit:Unit;
      
      private var _forwardUnitNotSpawn:Unit;
      
      private var _game:StickWar;
      
      protected var _castleBack:Entity;
      
      protected var _castleFront:Entity;
      
      protected var _statue:Statue;
      
      private var _id:int;
      
      protected var _population:int;
      
      protected var _unitProductionQueue:Dictionary;
      
      protected var buttonOver:MovieClip;
      
      protected var sameButtonCount:int;
      
      protected var _unitInfo:Dictionary;
      
      protected var _buttonInfoMap:Dictionary;
      
      protected var _base:Entity;
      
      protected var _buildings:Dictionary;
      
      protected var _tech:com.brockw.stickwar.engine.Team.Tech;
      
      private var _castleDefence:com.brockw.stickwar.engine.Team.CastleDefence;
      
      private var _hit:Boolean;
      
      private var _garrisonedUnits:Dictionary;
      
      private var _poisonedUnits:Dictionary;
      
      private var VISION_LENGTH:Number;
      
      private var _numberOfCats:int;
      
      private var _unitGroups:Dictionary;
      
      private var _walls:Array;
      
      private var passiveIncomeAmount:Number;
      
      private var passiveIncomeAmountUpgraded1:Number;
      
      private var passiveIncomeAmountUpgraded2:Number;
      
      private var passiveIncomeAmountUpgraded3:Number;
      
      public var techAllowed:Dictionary;
      
      private var passiveMana:Number;
      
      private var passiveManaUpgraded1:Number;
      
      private var passiveManaUpgraded2:Number;
      
      private var passiveManaUpgraded3:Number;
      
      private var _realName:String;
      
      private var _lastScreenLookPosition:int;
      
      protected var populationLimit:int;
      
      private var _isMember:Boolean;
      
      private var spawnedUnit:Unit;
      
      private var timeSinceSpawnedUnit:int;
      
      private var towerSpawnDelay:int;
      
      private var hasSpawnHill:Boolean;
      
      private var _pauseCount:int;
      
      private var _rating:int;
      
      private var _damageModifier:Number;
      
      private var _statueType:String;
      
      private var _originalType:int;
      
      private var _sandstorms:Array;
      
      public var respectForEnemy:int;
      
      public function Team(param1:StickWar)
      {
         this.visionArray = [];
         super();
         this.rating = 0;
         this._pauseCount = 0;
         this.spawnedUnit = null;
         this.timeSinceSpawnedUnit = 0;
         this.lastScreenLookPosition = 0;
         this._type = T_GOOD;
         this.techAllowed = null;
         this._units = new Array();
         this._deadUnits = new Array();
         this.game = param1;
         this.isEnemy = false;
         this.medianPosition = 0;
         this._unitProductionQueue = new Dictionary();
         this._buildings = new Dictionary();
         this.unitInfo = new Dictionary();
         this.hit = false;
         this._garrisonedUnits = new Dictionary();
         this.loadout = new Loadout();
         this._poisonedUnits = new Dictionary();
         this.numberOfCats = 0;
         this.VISION_LENGTH = param1.xml.xml.visionSize;
         this.unitGroups = new Dictionary();
         this._isAi = false;
         this._walls = [];
         this.buildingHighlights = [];
         this.passiveIncomeAmount = param1.xml.xml.passiveIncome;
         this.passiveIncomeAmountUpgraded1 = param1.xml.xml.passiveIncomeUpgraded1;
         this.passiveIncomeAmountUpgraded2 = param1.xml.xml.passiveIncomeUpgraded2;
         this.passiveIncomeAmountUpgraded3 = param1.xml.xml.passiveIncomeUpgraded3;
         this.passiveMana = param1.xml.xml.passiveMana;
         this.passiveManaUpgraded1 = param1.xml.xml.passiveManaUpgraded1;
         this.passiveManaUpgraded2 = param1.xml.xml.passiveManaUpgraded2;
         this.passiveManaUpgraded3 = param1.xml.xml.passiveManaUpgraded3;
         this.currentAttackState = com.brockw.stickwar.engine.Team.Team.G_DEFEND;
         this.populationLimit = param1.xml.xml.populationLimit;
         this.healthModifier = 1;
         this._isMember = true;
         this.towerSpawnDelay = param1.xml.xml.towerSpawnDelay;
         this._statueType = "default";
         this._damageModifier = 1;
         this._originalType = 0;
         this._sandstorms = [];
      }
      
      public static function getTeamFromId(param1:int, param2:StickWar, param3:int, param4:Dictionary, param5:* = 1, param6:Number = 1) : com.brockw.stickwar.engine.Team.Team
      {
         var _loc7_:* = param1;
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_RANDOM)
         {
            param1 = param2.random.nextInt() % 3;
         }
         var _loc8_:com.brockw.stickwar.engine.Team.Team = null;
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_GOOD)
         {
            _loc8_ = new TeamGood(param2,param3,param4,param5,param6);
         }
         else if(param1 == com.brockw.stickwar.engine.Team.Team.T_CHAOS)
         {
            _loc8_ = new TeamChaos(param2,param3,param4,param5,param6);
         }
         else if(param1 == com.brockw.stickwar.engine.Team.Team.T_ELEMENTAL)
         {
            _loc8_ = new TeamElemental(param2,param3,param4,param5,param6);
         }
         else
         {
            _loc8_ = new TeamGood(param2,param3,param4,param5,param6);
         }
         _loc8_.originalType = _loc7_;
         return _loc8_;
      }
      
      public static function getIdFromRaceName(param1:String) : int
      {
         if(param1 == "Order")
         {
            return com.brockw.stickwar.engine.Team.Team.T_GOOD;
         }
         if(param1 == "Chaos")
         {
            return com.brockw.stickwar.engine.Team.Team.T_CHAOS;
         }
         if(param1 == "Elemental")
         {
            return com.brockw.stickwar.engine.Team.Team.T_ELEMENTAL;
         }
         return -1;
      }
      
      public static function getRaceNameFromId(param1:int) : String
      {
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_GOOD)
         {
            return "Order";
         }
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_CHAOS)
         {
            return "Chaos";
         }
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_ELEMENTAL)
         {
            return "Elemental";
         }
         if(param1 == com.brockw.stickwar.engine.Team.Team.T_RANDOM)
         {
            return "Random";
         }
         return "";
      }
      
      public function get sandstorms() : Array
      {
         return this._sandstorms;
      }
      
      public function set sandstorms(param1:Array) : void
      {
         this._sandstorms = param1;
      }
      
      public function get damageModifier() : Number
      {
         return this._damageModifier;
      }
      
      public function set damageModifier(param1:Number) : void
      {
         this._damageModifier = param1;
      }
      
      public function addCombinersToCastle(param1:Map) : void
      {
      }
      
      public function addSandstorm(param1:Number) : Sandstorm
      {
         var _loc2_:Sandstorm = new Sandstorm(this.game,this);
         _loc2_.px = param1;
         _loc2_.x = param1;
         _loc2_.py = 0;
         this.game.battlefield.addChild(_loc2_);
         _loc2_.team = this;
         this.sandstorms.push(_loc2_);
         _loc2_.lifeFrames = this.game.xml.xml.Elemental.Units.sandstorm.lifeFrames;
         _loc2_.totalFrames = this.game.xml.xml.Elemental.Units.sandstorm.lifeFrames;
         this.game.projectileManager.initSandstormTower(param1 + this.direction * 50,0,0,this,this.direction,_loc2_.lifeFrames);
         this.game.projectileManager.initSandstormTower(param1 - this.direction * 52,this.game.map.height,0,this,this.direction,_loc2_.lifeFrames);
         return undefined;
      }
      
      public function addWall(param1:Number) : Wall
      {
         var _loc2_:Wall = new Wall(this.game,this);
         _loc2_.id = this.game.getNextUnitId();
         _loc2_.setLocation(param1);
         this._walls.push(_loc2_);
         _loc2_.addToScene(this.game.battlefield);
         this.game.units[_loc2_.id] = _loc2_;
         return _loc2_;
      }
      
      public function removeWall(param1:Wall) : void
      {
         param1.health = 0;
         this._walls.splice(this._walls.indexOf(param1),1);
         param1.removeFromScene(this.game.battlefield);
         delete this.game.units[param1.id];
         this.game.projectileManager.initWallExplosion(param1.px,this.game.map.height / 5,this);
         this.game.projectileManager.initWallExplosion(param1.px,2 * this.game.map.height / 5,this);
         this.game.projectileManager.initWallExplosion(param1.px,3 * this.game.map.height / 5,this);
         this.game.projectileManager.initWallExplosion(param1.px,4 * this.game.map.height / 5,this);
         this.game.projectileManager.initWallExplosion(param1.px,5 * this.game.map.height / 5,this);
      }
      
      public function garrisonMiner(param1:Boolean = false) : void
      {
         var _loc3_:* = null;
         var _loc2_:UnitMove = new UnitMove();
         _loc2_.moveType = UnitCommand.GARRISON;
         for(_loc3_ in this.units)
         {
            if(this.units[_loc3_].type == this.getMinerType())
            {
               _loc2_.units.push(this.units[_loc3_].id);
            }
         }
         _loc2_.arg0 = this.homeX;
         _loc2_.arg1 = this.game.gameScreen.game.map.height / 2;
         if(!param1)
         {
            this.game.gameScreen.doMove(_loc2_,this.id);
         }
         else
         {
            _loc2_.execute(this.game);
         }
      }
      
      public function unGarrisonMiner(param1:Boolean = false) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:UnitMove = null;
         for each(_loc2_ in this.units)
         {
            if(_loc2_.type == this.getMinerType())
            {
               if(MinerAi(_loc2_.ai).targetOre != null)
               {
                  _loc3_ = new UnitMove();
                  _loc3_.moveType = UnitCommand.MOVE;
                  _loc3_.units.push(_loc2_.id);
                  _loc3_.owner = this.id;
                  _loc3_.arg0 = MinerAi(_loc2_.ai).targetOre.x;
                  _loc3_.arg1 = MinerAi(_loc2_.ai).targetOre.y;
                  _loc3_.arg4 = MinerAi(_loc2_.ai).targetOre.id;
                  if(!param1)
                  {
                     this.game.gameScreen.doMove(_loc3_,this.id);
                  }
                  else
                  {
                     _loc3_.execute(this.game);
                  }
               }
               else
               {
                  _loc3_ = new UnitMove();
                  _loc3_.moveType = UnitCommand.ATTACK_MOVE;
                  _loc3_.units.push(_loc2_.id);
                  _loc3_.owner = this.id;
                  _loc3_.arg0 = this.homeX + this.direction * 900;
                  _loc3_.arg1 = this.game.gameScreen.game.map.height / 2;
                  if(!param1)
                  {
                     this.game.gameScreen.doMove(_loc3_,this.id);
                  }
                  else
                  {
                     _loc3_.execute(this.game);
                  }
               }
            }
         }
      }
      
      public function garrison(param1:Boolean = false, param2:Unit = null) : void
      {
         var _loc4_:* = null;
         var _loc3_:UnitMove = new UnitMove();
         _loc3_.moveType = UnitCommand.GARRISON;
         if(param2 == null)
         {
            for(_loc4_ in this.units)
            {
               _loc3_.units.push(this.units[_loc4_].id);
            }
         }
         else
         {
            _loc3_.units.push(param2.id);
         }
         _loc3_.arg0 = this.homeX;
         _loc3_.arg1 = this.game.gameScreen.game.map.height / 2;
         if(!param1)
         {
            this.game.gameScreen.doMove(_loc3_,this.id);
         }
         else
         {
            _loc3_.execute(this.game);
         }
         this.currentAttackState = com.brockw.stickwar.engine.Team.Team.G_GARRISON;
      }
      
      public function getMinerType() : int
      {
         return 0;
      }
      
      public function checkInputForSelect(param1:int, param2:*) : void
      {
      }
      
      public function defend(param1:Boolean = false) : void
      {
         var _loc4_:* = null;
         var _loc5_:Unit = null;
         var _loc6_:UnitMove = null;
         var _loc2_:* = new UnitMove();
         _loc2_.moveType = UnitCommand.ATTACK_MOVE;
         var _loc3_:* = new UnitMove();
         _loc3_.moveType = UnitCommand.MOVE;
         for(_loc4_ in this.units)
         {
            if((_loc5_ = this.units[_loc4_]).isMiner() && MinerAi(_loc5_.ai).targetOre != null)
            {
               (_loc6_ = new UnitMove()).moveType = UnitCommand.MOVE;
               _loc6_.units.push(_loc5_.id);
               _loc6_.owner = this.id;
               _loc6_.arg0 = MinerAi(_loc5_.ai).targetOre.x;
               _loc6_.arg1 = MinerAi(_loc5_.ai).targetOre.y;
               _loc6_.arg4 = MinerAi(_loc5_.ai).targetOre.id;
               if(!param1)
               {
                  this.game.gameScreen.doMove(_loc6_,this.id);
               }
               else
               {
                  _loc6_.execute(this.game);
               }
            }
            else if(this.direction * _loc5_.px > this.direction * (this.homeX + this.direction * 900))
            {
               _loc3_.units.push(_loc5_.id);
            }
            else
            {
               _loc2_.units.push(_loc5_.id);
            }
         }
         _loc3_.owner = this.id;
         _loc3_.arg0 = this.homeX + this.direction * 900;
         _loc3_.arg1 = this.game.gameScreen.game.map.height / 2;
         _loc2_.owner = this.id;
         _loc2_.arg0 = this.homeX + this.direction * 900;
         _loc2_.arg1 = this.game.gameScreen.game.map.height / 2;
         if(!param1)
         {
            this.game.gameScreen.doMove(_loc3_,this.id);
            this.game.gameScreen.doMove(_loc2_,this.id);
         }
         else
         {
            _loc3_.execute(this.game);
            _loc2_.execute(this.game);
         }
         this.currentAttackState = com.brockw.stickwar.engine.Team.Team.G_DEFEND;
      }
      
      public function attack(param1:Boolean = false, param2:Boolean = false, param3:Number = 0) : void
      {
         var _loc4_:UnitMove = null;
         var _loc5_:* = null;
         var _loc6_:Unit = null;
         var _loc7_:UnitMove = null;
         (_loc4_ = new UnitMove()).moveType = UnitCommand.ATTACK_MOVE;
         for(_loc5_ in this.units)
         {
            if((_loc6_ = this.units[_loc5_]).isMiner())
            {
               if(MinerAi(_loc6_.ai).targetOre != null)
               {
                  (_loc7_ = new UnitMove()).moveType = UnitCommand.MOVE;
                  _loc7_.units.push(_loc6_.id);
                  _loc7_.owner = this.id;
                  _loc7_.arg0 = MinerAi(_loc6_.ai).targetOre.x;
                  _loc7_.arg1 = MinerAi(_loc6_.ai).targetOre.y;
                  _loc7_.arg4 = MinerAi(_loc6_.ai).targetOre.id;
                  if(!param1)
                  {
                     this.game.gameScreen.doMove(_loc7_,this.id);
                  }
                  else
                  {
                     _loc7_.execute(this.game);
                  }
               }
               else if(this.direction * _loc6_.px < this.direction * (this.homeX + this.direction * 900))
               {
                  (_loc7_ = new UnitMove()).moveType = UnitCommand.MOVE;
                  _loc7_.units.push(_loc6_.id);
                  _loc7_.owner = this.id;
                  _loc7_.arg0 = this.homeX + this.direction * 900;
                  _loc7_.arg1 = 100;
                  if(!param1)
                  {
                     this.game.gameScreen.doMove(_loc7_,this.id);
                  }
                  else
                  {
                     _loc7_.execute(this.game);
                  }
               }
            }
            else
            {
               _loc4_.units.push(_loc6_.id);
            }
         }
         _loc4_.owner = this.id;
         if(param2)
         {
            _loc4_.arg0 = param3;
         }
         else if(this.enemyTeam.forwardUnit == null)
         {
            _loc4_.arg0 = this.enemyTeam.statue.px;
         }
         else
         {
            _loc4_.arg0 = this.enemyTeam.statue.px;
         }
         _loc4_.arg1 = this.game.gameScreen.game.map.height / 2;
         if(!param1)
         {
            this.game.gameScreen.doMove(_loc4_,this.id);
         }
         else
         {
            _loc4_.execute(this.game);
         }
         this.currentAttackState = com.brockw.stickwar.engine.Team.Team.G_ATTACK;
      }
      
      public function cleanUpUnits() : void
      {
         var _loc1_:* = null;
         var _loc2_:Unit = null;
         while(this._deadUnits.length != 0)
         {
            this.removeUnitCompletely(this._deadUnits.shift(),this.game);
         }
         this._deadUnits = [];
         for(_loc1_ in this._unitProductionQueue)
         {
            this._unitProductionQueue[_loc1_] = [];
         }
         this.population = 0;
         this.castleDefence.cleanUpUnits();
         delete this.tech.isResearchedMap[com.brockw.stickwar.engine.Team.Tech.CASTLE_ARCHER_1];
         for each(_loc2_ in this._units)
         {
            this.removeUnitCompletely(_loc2_,this.game);
         }
      }
      
      public function cleanUp() : void
      {
         var _loc1_:Unit = null;
         var _loc2_:int = 0;
         this._ai.cleanUp();
         this._ai = null;
         for each(_loc1_ in this._units)
         {
            if(this.game.battlefield.contains(_loc1_))
            {
               this.game.battlefield.removeChild(_loc1_);
            }
            this.game.unitFactory.returnUnit(_loc1_.type,_loc1_);
         }
         for each(_loc2_ in this.unitGroups)
         {
            this.unitGroups[_loc2_] = [];
         }
         this._units = null;
         this._deadUnits = null;
         this.game = null;
         this._unitProductionQueue = null;
         this._buildings = null;
         this.unitInfo = null;
         this._garrisonedUnits = null;
         this._loadout = null;
         this._enemyTeam = null;
         this._castleDefence.cleanUp();
         this._castleDefence = null;
         this._tech.cleanUp();
         this._tech = null;
         this._base.cleanUp();
         this._base = null;
         this.buttonInfoMap = null;
         this.buttonOver = null;
         this._forwardUnit = null;
         this._forwardUnitNotSpawn = null;
         this._castleBack = null;
         this._castleFront = null;
         this._statue = null;
      }
      
      public function getNumberOfMiners() : int
      {
         return 0;
      }
      
      public function getVisionRange() : Number
      {
         var _loc4_:Sandstorm = null;
         var _loc1_:* = this.game.team.homeX;
         var _loc2_:* = _loc1_;
         if(this.game.team.forwardUnit != null)
         {
            _loc2_ = this.game.team.forwardUnit.x;
         }
         if(_loc2_ * this.direction > _loc1_ * this.direction)
         {
            _loc1_ = _loc2_;
         }
         var _loc3_:* = _loc1_ + this.direction * this.VISION_LENGTH;
         if(this.visionArray.length != 0)
         {
            if(_loc3_ * this.direction <= this.visionArray[0] * this.direction)
            {
               _loc3_ = this.visionArray[0];
            }
         }
         for each(_loc4_ in this.enemyTeam.sandstorms)
         {
            if(this.game.team.forwardUnit && this.game.team.forwardUnit.px * this.direction < _loc4_.px * this.direction)
            {
               if(_loc3_ * this.direction > _loc4_.px * this.direction)
               {
                  _loc3_ = _loc4_.px;
               }
            }
         }
         return _loc3_;
      }
      
      public function createUnit(param1:int) : Boolean
      {
         return false;
      }
      
      public function queueUnit(param1:Unit) : void
      {
         if(this.buttonInfoMap != null)
         {
            if(String(param1.type) in this.buttonInfoMap)
            {
               ++this.buttonInfoMap[param1.type][3];
            }
         }
         this._unitProductionQueue[this.unitInfo[param1.type][2]].push([param1,0]);
      }
      
      public function dequeueUnit(param1:int, param2:Boolean) : Unit
      {
         var _loc5_:int = 0;
         var _loc6_:Unit = null;
         var _loc3_:int = int(this.unitInfo[param1][2]);
         var _loc4_:Unit = null;
         if(param2)
         {
            _loc5_ = this._unitProductionQueue[_loc3_].length - 1;
            while(_loc5_ >= 0)
            {
               if((_loc6_ = this._unitProductionQueue[_loc3_][_loc5_][0]).type == param1)
               {
                  _loc4_ = _loc6_;
                  this._unitProductionQueue[_loc3_].splice(_loc5_,1);
                  break;
               }
               _loc5_--;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < this._unitProductionQueue[_loc3_].length)
            {
               if((_loc6_ = this._unitProductionQueue[_loc3_][_loc5_][0]).type == param1)
               {
                  _loc4_ = _loc6_;
                  this._unitProductionQueue[_loc3_].splice(_loc5_,1);
                  break;
               }
               _loc5_++;
            }
         }
         if(_loc4_ == null)
         {
            return null;
         }
         if(this.buttonInfoMap != null)
         {
            if(String(_loc4_.type) in this.buttonInfoMap)
            {
               --this.buttonInfoMap[_loc4_.type][3];
            }
         }
         return _loc4_;
      }
      
      public function initTeamButtons(param1:GameScreen) : void
      {
      }
      
      public function spawnUnitGroup(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Unit = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(this.unitsAvailable == null || _loc3_ in this.unitsAvailable)
            {
               _loc4_ = this.game.unitFactory.getUnit(_loc3_);
               this.spawn(_loc4_,this.game);
               _loc4_.x = _loc4_.px = this.homeX + 100;
               _loc4_.y = _loc4_.py = _loc2_ * this.game.map.height / param1.length;
               this.population += _loc4_.population;
            }
            _loc2_++;
         }
      }
      
      public function checkUnitCreateMouseOver(param1:GameScreen) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:* = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:TextField = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:int = 0;
         var _loc14_:XMLList = null;
         var _loc15_:UnitCreateMove = null;
         var _loc2_:int = param1.stage.mouseX;
         var _loc3_:int = param1.stage.mouseY;
         var _loc4_:Boolean = false;
         for each(_loc5_ in this.buildingHighlights)
         {
            if(_loc5_ != null)
            {
               _loc5_.visible = false;
            }
         }
         for(_loc6_ in this.buttonInfoMap)
         {
            _loc7_ = this.buttonInfoMap[_loc6_][1];
            _loc8_ = this.buttonInfoMap[_loc6_][0];
            _loc9_ = this.buttonInfoMap[_loc6_][4];
            _loc10_ = TextField(MovieClip(this.buttonInfoMap[_loc6_][0]).getChildByName("number"));
            _loc11_ = MovieClip(this.buttonInfoMap[_loc6_][8]);
            _loc12_ = MovieClip(this.buttonInfoMap[_loc6_][7]);
            if(this.unitsAvailable && !(_loc6_ in this.unitsAvailable))
            {
               _loc8_.visible = false;
               _loc7_.visible = false;
               _loc9_.visible = false;
            }
            else
            {
               _loc8_.visible = true;
               _loc7_.visible = true;
               if(_loc11_ != null)
               {
                  _loc11_.visible = true;
               }
               _loc10_.text = "" + this.buttonInfoMap[_loc6_][3];
               if(this.buttonInfoMap[_loc6_][3] > 0)
               {
                  _loc9_.visible = true;
                  if(_loc9_.hitTestPoint(_loc2_,_loc3_,false) && param1.userInterface.mouseState.clicked)
                  {
                     (_loc15_ = new UnitCreateMove()).unitType = -int(_loc6_);
                     param1.doMove(_loc15_,this.id);
                     _loc4_ = true;
                  }
               }
               else
               {
                  _loc9_.visible = false;
               }
               _loc13_ = int(this.unitInfo[_loc6_][2]);
               if(this._unitProductionQueue[_loc13_].length != 0 && Unit(this._unitProductionQueue[_loc13_][0][0]).type == int(_loc6_))
               {
                  this.drawTimerOverlay(this.buttonInfoMap[_loc6_][6],_loc7_,this._unitProductionQueue[_loc13_][0][1] / Unit(this._unitProductionQueue[_loc13_][0][0]).createTime);
               }
               else
               {
                  this.buttonInfoMap[_loc6_][6].graphics.clear();
               }
               if(_loc10_.text == "0")
               {
                  _loc10_.text = "";
               }
               _loc14_ = this.buttonInfoMap[_loc6_][2];
               _loc7_.visible = true;
               if(_loc4_ == false && _loc8_.hitTestPoint(_loc2_,_loc3_,false))
               {
                  if(param1.userInterface.mouseState.clicked)
                  {
                     if(!this.canAfford(_loc6_))
                     {
                        if(this.gold < this.unitInfo[int(_loc6_)][0])
                        {
                           this.game.gameScreen.userInterface.helpMessage.showMessage("Not enough gold to construct unit");
                           this.game.soundManager.playSoundFullVolume("UnitMakeFail");
                        }
                        else if(this.mana < this.unitInfo[int(_loc6_)][1])
                        {
                           this.game.gameScreen.userInterface.helpMessage.showMessage("Not enough mana to construct unit");
                           this.game.soundManager.playSoundFullVolume("UnitMakeFail");
                        }
                     }
                     else
                     {
                        (_loc15_ = new UnitCreateMove()).unitType = int(_loc6_);
                        param1.doMove(_loc15_,this.id);
                        this.game.soundManager.playSoundFullVolume("UnitMake");
                     }
                  }
                  if(_loc12_)
                  {
                     _loc12_.visible = true;
                  }
                  _loc7_.visible = false;
                  this.updateButtonOverXML(this.game,_loc14_);
               }
            }
         }
      }
      
      public function init() : void
      {
         this._population = 0;
         this._castleBack.x = this.homeX;
         this._castleBack.py = this._castleBack.y = -this.game.battlefield.y;
         this._castleBack.scaleX *= this.direction;
         this._castleFront.x = this.homeX;
         this._castleFront.y = -this.game.battlefield.y;
         this._castleFront.py = this.game.map.height / 2 + 40;
         this._castleFront.scaleX *= this.direction;
         this.statue.x = this.homeX + this.direction * 500;
         this.statue.py = this.game.map.height / 2;
         this.statue.px = this.statue.x;
         this.statue.y = this.statue.py;
         this.statue.scaleX *= 0.8;
         this.statue.scaleY *= 0.8;
         this.statue.scaleX *= this.direction;
         this.base.x = this.homeX - this.direction * this.game.map.screenWidth;
         this.base.scaleX = this.direction;
         this.base.py = 0;
         this.base.px = this.base.x;
         this.base.y = -this.game.map.y;
         this.base.mouseEnabled = true;
         this.castleFront.cacheAsBitmap = true;
         this.castleBack.cacheAsBitmap = true;
         this.statue.cacheAsBitmap = true;
         this.statue.team = this;
      }
      
      public function get isEnemy() : Boolean
      {
         return this._isEnemy;
      }
      
      public function set isEnemy(param1:Boolean) : void
      {
         this._isEnemy = param1;
      }
      
      public function get game() : StickWar
      {
         return this._game;
      }
      
      public function set game(param1:StickWar) : void
      {
         this._game = param1;
      }
      
      public function switchTeams(param1:Unit) : void
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:int = 0;
         this._units.splice(this._units.indexOf(param1),1);
         if(param1.id in this.garrisonedUnits)
         {
            delete this.garrisonedUnits[param1.id];
         }
         if(!param1.isSwitched)
         {
            this.unitGroups[param1.type].splice(this.unitGroups[param1.type].indexOf(param1),1);
         }
         else
         {
            this.enemyTeam.unitGroups[param1.type].push(param1);
         }
         if(param1.isMiner())
         {
            MinerAi(param1.ai).targetOre = null;
         }
         this.enemyTeam._units.push(param1);
         param1.team = this.enemyTeam;
         param1.isSwitched = !param1.isSwitched;
         param1.ai.currentTarget = null;
         if(param1.isSwitched)
         {
            _loc2_ = param1.mc.transform.colorTransform;
            _loc3_ = this.game.random.nextInt();
            _loc2_.redMultiplier = 0;
            _loc2_.blueMultiplier = 0;
            _loc2_.greenMultiplier = 0;
            _loc2_.redOffset = 0;
            _loc2_.blueOffset = 0;
            _loc2_.greenOffset = 0;
            param1.mc.transform.colorTransform = _loc2_;
         }
         else
         {
            _loc2_ = param1.mc.transform.colorTransform;
            _loc3_ = this.game.random.nextInt();
            _loc2_.redMultiplier = 1;
            _loc2_.blueMultiplier = 1;
            _loc2_.greenMultiplier = 1;
            if(param1.team.isEnemy)
            {
               _loc2_.redOffset = 75;
            }
            else
            {
               _loc2_.redOffset = 0;
               _loc2_.blueOffset = 0;
               _loc2_.greenOffset = 0;
            }
            param1.mc.transform.colorTransform = _loc2_;
         }
      }
      
      protected function canAfford(param1:int) : Boolean
      {
         return this.gold >= this.unitInfo[param1][0] && this.mana >= this.unitInfo[param1][1];
      }
      
      public function spawnUnit(param1:int, param2:StickWar) : void
      {
         var _loc3_:Unit = null;
         if(param1 >= 0)
         {
            if(this.unitsAvailable != null && !(param1 in this.unitsAvailable))
            {
               return;
            }
            if(!(param1 in this.unitInfo))
            {
               return;
            }
            _loc3_ = null;
            if(this.canAfford(param1))
            {
               _loc3_ = Unit(param2.unitFactory.getUnit(int(param1)));
               if(_loc3_.population + this._population > this.populationLimit)
               {
                  param2.unitFactory.returnUnit(_loc3_.type,_loc3_);
                  _loc3_ = null;
               }
               else
               {
                  this.gold -= this.unitInfo[param1][0];
                  this.mana -= this.unitInfo[param1][1];
               }
            }
            else if(this == param2.team)
            {
               if(this.gold < this.unitInfo[param1][0])
               {
                  param2.gameScreen.userInterface.helpMessage.showMessage("Not enough gold to construct unit");
               }
               else if(this.mana < this.unitInfo[param1][1])
               {
                  param2.gameScreen.userInterface.helpMessage.showMessage("Not enough mana to construct unit");
               }
            }
            if(_loc3_ != null)
            {
               this.queueUnit(_loc3_);
               this._population += _loc3_.population;
            }
         }
         else if(this.dequeueUnit(-int(param1),true) != null)
         {
            this.gold += int(this.unitInfo[-param1][0]);
            this.mana += int(this.unitInfo[-param1][1]);
            _loc3_ = Unit(param2.unitFactory.getUnit(-int(param1)));
            this._population -= _loc3_.population;
         }
      }
      
      public function spawn(param1:Unit, param2:StickWar, param3:Boolean = true) : void
      {
         param1.isTowerSpawned = false;
         param1.isInteractable = true;
         param1.isDead = false;
         param1.isDieing = false;
         param1.team = this;
         param1.enemyBuffed = false;
         param1.setBuilding();
         var _loc4_:ColorTransform = param1.mc.transform.colorTransform;
         var _loc5_:int = param2.random.nextInt();
         if(this.isEnemy)
         {
            _loc4_.redOffset = 75;
         }
         else
         {
            _loc4_.redOffset = 0;
            _loc4_.blueOffset = 0;
            _loc4_.greenOffset = 0;
         }
         param1.isOnFire = false;
         param1.mc.transform.colorTransform = _loc4_;
         param1.id = param2.getNextUnitId();
         param2.units[param1.id] = param1;
         if(param1.building == null)
         {
            param1.x = param1.px = this.homeX + this.direction * SPAWN_OFFSET_X;
            param1.y = param1.py = param2.map.height / 2;
         }
         else if(param1.type == Unit.U_MINER || param1.type == Unit.U_CHAOS_MINER)
         {
            param1.x = param1.px = param1.team.homeX;
            param1.y = param1.py = 100;
         }
         else
         {
            param1.x = param1.px = param1.team.base.x + this.direction * Math.abs(param1.building.hitAreaMovieClip.x + param1.building.buildingWidth / 2);
            param1.y = param1.py = 100;
         }
         param1.x = -100;
         param1.y = -100;
         param1.init(param2);
         param1.healthBar.reset();
         this.units.push(param1);
         param2.battlefield.addChildAt(param1,0);
         param1.ai.init();
         var _loc6_:AttackMoveCommand = new AttackMoveCommand(param2);
         if(param1.type == Unit.U_MINER || param1.type == Unit.U_CHAOS_MINER)
         {
            _loc6_.goalX = this.homeX + this.direction * 850 + param2.random.nextNumber() * 40 - 20;
         }
         else
         {
            _loc6_.goalX = this.homeX + this.direction * 1000;
         }
         if(param1.type == Unit.U_CAT)
         {
            ++this.numberOfCats;
         }
         _loc6_.goalY = param2.map.height / 2 + param2.random.nextNumber() * 60 - 30;
         param1.ai.setCommand(param2,_loc6_);
         param1.cure();
         this.unitGroups[param1.type].push(param1);
         if(param2.main.isKongregate)
         {
            if(param1.type == Unit.U_SPEARTON)
            {
               if(this.unitGroups[param1.type].length == 10)
               {
                  param2.main.kongregateReportStatistic("speartons300",1);
               }
            }
            if(this.population == 80)
            {
               param2.main.kongregateReportStatistic("maxPopulation",1);
            }
         }
         if(this.currentAttackState == com.brockw.stickwar.engine.Team.Team.G_GARRISON)
         {
            this.garrison(true,param1);
         }
         if(param1.type == Unit.U_MINER || param1.type == Unit.U_CHAOS_MINER)
         {
            MinerAi(param1.ai).targetOre = null;
            MinerAi(param1.ai).isUnassigned = true;
         }
         if(this == param2.team && param3)
         {
            param2.soundManager.playSoundFullVolume("UnitReady");
         }
         param1.hasDefaultLoadout = this.loadout.unitHasDefaultLoadout(param1.type);
      }
      
      public function spawnMiners() : void
      {
      }
      
      public function removeUnit(param1:Unit, param2:StickWar) : void
      {
         if(param1.isSwitched)
         {
            this.switchTeams(param1);
            param1.team.removeUnit(param1,param2);
         }
         else
         {
            if(param1.type == Unit.U_CAT)
            {
               --this.numberOfCats;
            }
            param1.cure();
            this._deadUnits.push(param1);
            if(param1.isInteractable)
            {
               this._population -= param1.population;
            }
            this.unitGroups[param1.type].splice(this.unitGroups[param1.type].indexOf(param1),1);
            if(param1.id in this.garrisonedUnits)
            {
               delete this.garrisonedUnits[param1.id];
            }
         }
      }
      
      public function detectedUserInput(param1:UserInterface) : void
      {
      }
      
      public function removeUnitCompletely(param1:Unit, param2:StickWar) : void
      {
         var isNormalUnit:Boolean = true;
         var _loc3_:int = 0;
         if(param1.isSwitched)
         {
            this.switchTeams(param1);
            param1.team.removeUnitCompletely(param1,param2);
         }
         else
         {
            param1.isDead = true;
            this._units.splice(this._units.indexOf(param1),1);
            if(param2.units[param1.id].isCustomUnit)
            {
               isNormalUnit = false;
            }
            delete param2.units[param1.id];
            if(param2.battlefield.contains(param1))
            {
               param2.battlefield.removeChild(param1);
            }
            _loc3_ = int(this.unitGroups[param1.type].indexOf(param1));
            if(_loc3_ != -1)
            {
               this.unitGroups[param1.type].splice(_loc3_,1);
            }
            if(isNormalUnit)
            {
               param2.unitFactory.returnUnit(param1.type,param1);
            }
            else
            {
               trace("special unit died, not returning to unit factory");
            }
            if(param1.id in this.garrisonedUnits)
            {
               delete this.garrisonedUnits[param1.id];
            }
         }
      }
      
      protected function singlePlayerDebugInputSwitch(param1:UserInterface, param2:int, param3:int) : void
      {
         var _loc4_:UnitCreateMove = null;
         if(param1.keyBoardState.isPressed(param3))
         {
            _loc4_ = new UnitCreateMove();
            if(param1.gameScreen is SingleplayerGameScreen && param1.gameScreen.isDebug && param1.keyBoardState.isShift)
            {
               _loc4_.unitType = param2;
               param1.gameScreen.doMove(_loc4_,param1.gameScreen.team.enemyTeam.id);
            }
            else if(!this.canAfford(param2))
            {
               if(this.gold < this.unitInfo[int(param2)][0])
               {
                  this.game.gameScreen.userInterface.helpMessage.showMessage("Not enough gold to construct unit");
                  this.game.soundManager.playSoundFullVolume("UnitMakeFail");
               }
               else if(this.mana < this.unitInfo[int(param2)][1])
               {
                  this.game.gameScreen.userInterface.helpMessage.showMessage("Not enough mana to construct unit");
                  this.game.soundManager.playSoundFullVolume("UnitMakeFail");
               }
            }
            else
            {
               (_loc4_ = new UnitCreateMove()).unitType = int(param2);
               param1.gameScreen.doMove(_loc4_,this.id);
               this.game.soundManager.playSoundFullVolume("UnitMake");
            }
         }
      }
      
      public function updateButtonOverXML(param1:StickWar, param2:XMLList) : void
      {
         ++this.sameButtonCount;
         if(this.sameButtonCount > 3)
         {
            param1.tipBox.displayTip(param2.name,param2.info,param2.cooldown,param2.gold,param2.mana,param2.population);
         }
         this.hit = true;
      }
      
      public function updateButtonOver(param1:StickWar, param2:String, param3:String, param4:int, param5:int, param6:int, param7:int) : void
      {
         ++this.sameButtonCount;
         if(this.sameButtonCount > 3)
         {
            param1.tipBox.displayTip(param2,param3,param4,param5,param6,param7);
         }
         this.hit = true;
      }
      
      public function updateButtonOverPost(param1:StickWar) : void
      {
         if(!param1.gameScreen.isFastForwardFrame)
         {
            if(!this.hit)
            {
               this.buttonOver = null;
               this.sameButtonCount = 0;
            }
            this.hit = false;
         }
      }
      
      protected function getSpawnUnitType(param1:StickWar) : int
      {
         return -1;
      }
      
      private function spawnMiddleUnit(param1:StickWar) : Unit
      {
         var _loc4_:AttackMoveCommand = null;
         if(param1.map.hills.length == 0)
         {
            return null;
         }
         var _loc2_:int = this.getSpawnUnitType(param1);
         var _loc3_:Unit = param1.unitFactory.getUnit(_loc2_);
         this.spawn(_loc3_,param1);
         _loc3_.x = _loc3_.px = param1.map.hills[0].px;
         _loc3_.y = _loc3_.py = param1.map.height / 2;
         _loc3_.isTowerSpawned = true;
         _loc3_.isInteractable = false;
         param1.soundManager.playSoundFullVolumeRandom("GhostTower",2);
         (_loc4_ = new AttackMoveCommand(param1)).type = UnitCommand.ATTACK_MOVE;
         _loc4_.goalX = this.enemyTeam.statue.px;
         _loc4_.goalY = param1.map.height / 2;
         _loc4_.realX = this.enemyTeam.statue.px;
         _loc4_.realY = param1.map.height / 2;
         _loc3_.ai.setCommand(param1,_loc4_);
         var _loc5_:Number = 1;
         if(this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.TOWER_SPAWN_II))
         {
            _loc5_ = 1.5;
         }
         param1.projectileManager.initTowerSpawn(param1.map.hills[0].px,param1.map.height / 2,this,_loc5_);
         return _loc3_;
      }
      
      public function updateStatue() : void
      {
         if(this._statueType != "default")
         {
            this.statue.mc.statue.gotoAndStop(this._statueType);
         }
         else
         {
            this.statue.mc.statue.gotoAndStop("default");
         }
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc10_:UnitMove = null;
         var _loc4_:Sandstorm = null;
         var _loc5_:Wall = null;
         var _loc6_:Boolean = false;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:* = null;
         var _loc11_:com.brockw.stickwar.engine.Team.Team = null;
         var _loc12_:ColorTransform = null;
         var _loc2_:* = param1.team.homeX;
         var _loc3_:* = _loc2_;
         if(param1.team.forwardUnit != null)
         {
            _loc3_ = param1.team.forwardUnit.x;
         }
         if(_loc3_ * this.direction > _loc2_ * this.direction)
         {
            _loc2_ = _loc3_;
         }
         this.visionArray.push(_loc2_ + this.direction * this.VISION_LENGTH);
         if(this.visionArray.length > 30)
         {
            this.visionArray.shift();
         }
         if(this.spawnedUnit != null)
         {
            if(!this.spawnedUnit.isAlive())
            {
               this.spawnedUnit = null;
            }
            this.timeSinceSpawnedUnit = param1.frame;
         }
         if(param1.map.hills.length != 0)
         {
            if((_loc11_ = param1.map.hills[0].getControllingTeam(param1)) == this)
            {
               if(this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.TOWER_SPAWN_I) || this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.SPAWN_SHADOW) || this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.SPAWN_MAGE))
               {
                  if(param1.frame - this.timeSinceSpawnedUnit > this.towerSpawnDelay)
                  {
                     this.spawnedUnit = this.spawnMiddleUnit(param1);
                  }
               }
            }
         }
         if(param1.frame % (30 * 5) == 0)
         {
            if(this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.BANK_PASSIVE_3))
            {
               this.gold += this.passiveIncomeAmountUpgraded3;
               this.mana += this.passiveManaUpgraded3;
            }
            else if(this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.BANK_PASSIVE_2))
            {
               this.gold += this.passiveIncomeAmountUpgraded2;
               this.mana += this.passiveManaUpgraded2;
            }
            else if(this.tech.isResearched(com.brockw.stickwar.engine.Team.Tech.BANK_PASSIVE_1))
            {
               this.gold += this.passiveIncomeAmountUpgraded1;
               this.mana += this.passiveManaUpgraded1;
            }
            else
            {
               this.gold += this.passiveIncomeAmount;
               this.mana += this.passiveMana;
            }
         }
         for each(_loc4_ in this._sandstorms)
         {
            _loc4_.update(param1);
            if(_loc4_.lifeFrames == 0)
            {
               param1.battlefield.removeChild(_loc4_);
               this._sandstorms.splice(this._sandstorms.indexOf(_loc4_),1);
            }
         }
         for each(_loc5_ in this._walls)
         {
            _loc5_.update(param1);
         }
         this.tech.update(param1);
         _loc6_ = param1.gameScreen is SingleplayerGameScreen && param1.xml.xml.debug == 1;
         for each(_loc7_ in this._unitProductionQueue)
         {
            if(_loc7_.length != 0)
            {
               if(_loc7_[0][1] > Unit(_loc7_[0][0]).createTime || _loc6_)
               {
                  this.spawn(Unit(_loc7_[0][0]),param1);
                  this.dequeueUnit(Unit(_loc7_[0][0]).type,false);
               }
               else
               {
                  ++_loc7_[0][1];
               }
            }
         }
         _loc8_ = getTimer();
         this._castleDefence.update(param1);
         this._ai.update(param1);
         this.statue.update(param1);
         if(this._units.length != 0)
         {
            this._forwardUnit = null;
            this._forwardUnitNotSpawn = null;
            for(_loc9_ in this._units)
            {
               if(this._units[_loc9_].isAlive() && (this._forwardUnit == null || Unit(this._units[_loc9_]).px * this.direction > this._forwardUnit.px * this.direction))
               {
                  this._forwardUnit = this._units[_loc9_];
               }
               if(this._units[_loc9_].isAlive() && Unit(this._units[_loc9_]).isInteractable && (this._forwardUnitNotSpawn == null || Unit(this._units[_loc9_]).px * this.direction > this._forwardUnitNotSpawn.px * this.direction))
               {
                  this._forwardUnitNotSpawn = this._units[_loc9_];
               }
               if(!this._units[_loc9_].isDead)
               {
                  if(this._units[_loc9_].isFrozen())
                  {
                     --this._units[_loc9_].freezeCount;
                     Unit(this._units[_loc9_]).healthBar.health = Unit(this._units[_loc9_]).health;
                     Unit(this._units[_loc9_]).healthBar.update();
                     _loc12_ = this._units[_loc9_].mc.transform.colorTransform;
                     _loc12_.blueOffset += (255 - _loc12_.blueOffset) * 0.08;
                     _loc12_.redOffset += (150 - _loc12_.redOffset) * 0.08;
                     _loc12_.greenOffset += (150 - _loc12_.greenOffset) * 0.08;
                     this._units[_loc9_].mc.transform.colorTransform = _loc12_;
                     this._units[_loc9_].applyZMotionUpdates();
                  }
                  else if(!this._units[_loc9_].isSlow() || param1.frame % 2 == 0)
                  {
                     this._units[_loc9_].update(param1);
                  }
                  else if(!this._units[_loc9_].isRage() || param1.frame % 0.5 == 0)
                  {
                     this._units[_loc9_].update(param1);
                  }
               }
            }
         }
         else
         {
            this._forwardUnit = null;
         }
         for(_loc9_ in this._deadUnits)
         {
            this._deadUnits[_loc9_].update(param1);
         }
         if(this._deadUnits.length > 0 && Unit(this._deadUnits[0]).timeOfDeath > 30 * 20)
         {
            this.removeUnitCompletely(this._deadUnits.shift(),param1);
         }
         (_loc10_ = new UnitMove()).moveType = UnitCommand.MOVE;
         for(_loc9_ in this.garrisonedUnits)
         {
            _loc10_.units.push(this.garrisonedUnits[_loc9_].id);
         }
         _loc10_.owner = this.id;
         _loc10_.arg0 = this.homeX - this.direction * param1.map.screenWidth / 3;
         _loc10_.arg1 = param1.map.height / 2;
         _loc10_.execute(param1);
      }
      
      public function drawTimerOverlay(param1:MovieClip, param2:MovieClip, param3:Number) : void
      {
         param1.graphics.clear();
         param1.y = -1;
         var _loc4_:int = param2.width;
         var _loc5_:int = param2.height + 1;
         param1.graphics.beginFill(0,1);
         param1.graphics.moveTo(_loc4_ / 2,0);
         param1.graphics.lineTo(_loc4_ / 2,_loc5_ / 2);
         var _loc6_:Number = param3 * 2 * Math.PI;
         var _loc7_:Number = Math.atan2(_loc4_ / 2,_loc5_ / 2);
         var _loc8_:* = _loc6_;
         if(_loc6_ < _loc7_)
         {
            param1.graphics.lineTo(_loc4_ / 2 + Util.tan(_loc6_) * _loc5_ / 2,0);
         }
         else if(_loc6_ <= Math.PI / 2)
         {
            param1.graphics.lineTo(_loc4_,Util.tan(_loc6_ - _loc7_) * _loc5_ / 2);
         }
         else if(_loc6_ <= Math.PI - _loc7_)
         {
            param1.graphics.lineTo(_loc4_,_loc5_ / 2 + Util.tan(_loc6_ - Math.PI / 2) * _loc5_ / 2);
         }
         else if(_loc6_ <= Math.PI)
         {
            param1.graphics.lineTo(_loc4_ / 2 + Util.tan(Math.PI - _loc6_) * _loc5_ / 2,_loc5_);
         }
         else if(_loc6_ <= Math.PI + _loc7_)
         {
            param1.graphics.lineTo(0 + Util.tan(Math.PI + _loc7_ - _loc6_) * _loc5_ / 2,_loc5_);
         }
         else if(_loc6_ <= Math.PI / 2 + Math.PI)
         {
            param1.graphics.lineTo(0,_loc5_ - Util.tan(_loc6_ - Math.PI - _loc7_) * _loc5_ / 2);
         }
         else if(_loc6_ <= 2 * Math.PI - _loc7_)
         {
            param1.graphics.lineTo(0,_loc5_ / 2 - Util.tan(_loc6_ - 2 * Math.PI - Math.PI / 2) * _loc5_ / 2);
         }
         else
         {
            param1.graphics.lineTo(_loc4_ / 2 + Util.tan(_loc6_) * _loc5_ / 2,0);
         }
         if(_loc6_ <= _loc7_)
         {
            param1.graphics.lineTo(_loc4_,0);
         }
         if(_loc6_ <= Math.PI - _loc7_)
         {
            param1.graphics.lineTo(_loc4_,_loc5_);
         }
         if(_loc6_ <= _loc7_ + Math.PI)
         {
            param1.graphics.lineTo(0,_loc5_);
         }
         if(_loc6_ <= 2 * Math.PI - _loc7_)
         {
            param1.graphics.lineTo(0,0);
         }
         param1.graphics.lineTo(_loc4_ / 2,0);
      }
      
      private function sortOnX(param1:Unit, param2:Unit) : int
      {
         return param1.px - param2.px;
      }
      
      public function getGoldValue() : int
      {
         var _loc2_:Unit = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.units)
         {
            if(_loc2_.type in this.unitInfo)
            {
               if(_loc2_.isAlive())
               {
                  _loc1_ += this.unitInfo[_loc2_.type][0];
               }
            }
         }
         return _loc1_;
      }
      
      public function getManaValue() : int
      {
         var _loc2_:Unit = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.units)
         {
            if(_loc2_.type in this.unitInfo)
            {
               if(_loc2_.isAlive())
               {
                  _loc1_ += this.unitInfo[_loc2_.type][1];
               }
            }
         }
         return _loc1_;
      }
      
      private function isMilitaryFilter(param1:Unit, param2:int, param3:Array) : Boolean
      {
         return param1.type != Unit.U_MINER && param1.type != Unit.U_CHAOS_MINER && param1.isAlive();
      }
      
      public function calculateStatistics() : void
      {
         var _loc2_:Unit = null;
         var _loc3_:Array = null;
         this.averagePosition = 0;
         this.attackingForcePopulation = 0;
         var _loc1_:int = 0;
         for each(_loc2_ in this.units)
         {
            if(!_loc2_.isMiner() && _loc2_.isAlive())
            {
               _loc1_ += _loc2_.population;
               this.averagePosition += _loc2_.px * _loc2_.population;
               this.attackingForcePopulation += _loc2_.population;
            }
         }
         this.averagePosition /= _loc1_;
         _loc3_ = this.units.filter(this.isMilitaryFilter);
         _loc3_.sort(this.sortOnX);
         if(_loc3_.length > 0)
         {
            this.medianPosition = _loc3_[Math.floor(_loc3_.length / 2)].px;
         }
      }
      
      public function get enemyTeam() : com.brockw.stickwar.engine.Team.Team
      {
         return this._enemyTeam;
      }
      
      public function set enemyTeam(param1:com.brockw.stickwar.engine.Team.Team) : void
      {
         this._enemyTeam = param1;
      }
      
      public function get units() : Array
      {
         return this._units;
      }
      
      public function set units(param1:Array) : void
      {
         this._units = param1;
      }
      
      public function get ai() : TeamAi
      {
         return this._ai;
      }
      
      public function set ai(param1:TeamAi) : void
      {
         this._ai = param1;
      }
      
      public function get name() : int
      {
         return this._name;
      }
      
      public function set name(param1:int) : void
      {
         this._name = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(param1:int) : void
      {
         this._direction = param1;
      }
      
      public function get homeX() : int
      {
         return this._homeX;
      }
      
      public function set homeX(param1:int) : void
      {
         this._homeX = param1;
      }
      
      public function get forwardUnit() : Unit
      {
         return this._forwardUnit;
      }
      
      public function set forwardUnit(param1:Unit) : void
      {
         this._forwardUnit = param1;
      }
      
      public function get gold() : int
      {
         return this._gold;
      }
      
      public function set gold(param1:int) : void
      {
         this._gold = param1;
      }
      
      public function get statue() : Statue
      {
         return this._statue;
      }
      
      public function set statue(param1:Statue) : void
      {
         this._statue = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get population() : int
      {
         return this._population;
      }
      
      public function set population(param1:int) : void
      {
         this._population = param1;
      }
      
      public function get castleBack() : Entity
      {
         return this._castleBack;
      }
      
      public function set castleBack(param1:Entity) : void
      {
         this._castleBack = param1;
      }
      
      public function get castleFront() : Entity
      {
         return this._castleFront;
      }
      
      public function set castleFront(param1:Entity) : void
      {
         this._castleFront = param1;
      }
      
      public function get base() : Entity
      {
         return this._base;
      }
      
      public function set base(param1:Entity) : void
      {
         this._base = param1;
      }
      
      public function get buildings() : Dictionary
      {
         return this._buildings;
      }
      
      public function set buildings(param1:Dictionary) : void
      {
         this._buildings = param1;
      }
      
      public function get tech() : com.brockw.stickwar.engine.Team.Tech
      {
         return this._tech;
      }
      
      public function set tech(param1:com.brockw.stickwar.engine.Team.Tech) : void
      {
         this._tech = param1;
      }
      
      public function get castleDefence() : com.brockw.stickwar.engine.Team.CastleDefence
      {
         return this._castleDefence;
      }
      
      public function set castleDefence(param1:com.brockw.stickwar.engine.Team.CastleDefence) : void
      {
         this._castleDefence = param1;
      }
      
      public function get hit() : Boolean
      {
         return this._hit;
      }
      
      public function set hit(param1:Boolean) : void
      {
         this._hit = param1;
      }
      
      public function get mana() : Number
      {
         return this._mana;
      }
      
      public function set mana(param1:Number) : void
      {
         this._mana = param1;
      }
      
      public function get garrisonedUnits() : Dictionary
      {
         return this._garrisonedUnits;
      }
      
      public function set garrisonedUnits(param1:Dictionary) : void
      {
         this._garrisonedUnits = param1;
      }
      
      public function get loadout() : Loadout
      {
         return this._loadout;
      }
      
      public function set loadout(param1:Loadout) : void
      {
         this._loadout = param1;
      }
      
      public function get poisonedUnits() : Dictionary
      {
         return this._poisonedUnits;
      }
      
      public function set poisonedUnits(param1:Dictionary) : void
      {
         this._poisonedUnits = param1;
      }
      
      public function get numberOfCats() : int
      {
         return this._numberOfCats;
      }
      
      public function set numberOfCats(param1:int) : void
      {
         this._numberOfCats = param1;
      }
      
      public function get unitGroups() : Dictionary
      {
         return this._unitGroups;
      }
      
      public function set unitGroups(param1:Dictionary) : void
      {
         this._unitGroups = param1;
      }
      
      public function get unitInfo() : Dictionary
      {
         return this._unitInfo;
      }
      
      public function set unitInfo(param1:Dictionary) : void
      {
         this._unitInfo = param1;
      }
      
      public function get unitProductionQueue() : Dictionary
      {
         return this._unitProductionQueue;
      }
      
      public function set unitProductionQueue(param1:Dictionary) : void
      {
         this._unitProductionQueue = param1;
      }
      
      public function get isAi() : Boolean
      {
         return this._isAi;
      }
      
      public function set isAi(param1:Boolean) : void
      {
         this._isAi = param1;
      }
      
      public function get walls() : Array
      {
         return this._walls;
      }
      
      public function set walls(param1:Array) : void
      {
         this._walls = param1;
      }
      
      public function get unitsAvailable() : Dictionary
      {
         return this._unitsAvailable;
      }
      
      public function set unitsAvailable(param1:Dictionary) : void
      {
         this._unitsAvailable = param1;
      }
      
      public function get handicap() : Number
      {
         return this._handicap;
      }
      
      public function set handicap(param1:Number) : void
      {
         this._handicap = param1;
      }
      
      public function get realName() : String
      {
         return this._realName;
      }
      
      public function set realName(param1:String) : void
      {
         this._realName = param1;
      }
      
      public function get lastScreenLookPosition() : int
      {
         return this._lastScreenLookPosition;
      }
      
      public function set lastScreenLookPosition(param1:int) : void
      {
         this._lastScreenLookPosition = param1;
      }
      
      public function get currentAttackState() : int
      {
         return this._currentAttackState;
      }
      
      public function set currentAttackState(param1:int) : void
      {
         this._currentAttackState = param1;
      }
      
      public function get buttonInfoMap() : Dictionary
      {
         return this._buttonInfoMap;
      }
      
      public function set buttonInfoMap(param1:Dictionary) : void
      {
         this._buttonInfoMap = param1;
      }
      
      public function get healthModifier() : Number
      {
         return this._healthModifier;
      }
      
      public function set healthModifier(param1:Number) : void
      {
         this._healthModifier = param1;
      }
      
      public function get isMember() : Boolean
      {
         return this._isMember;
      }
      
      public function set isMember(param1:Boolean) : void
      {
         this._isMember = param1;
      }
      
      public function get forwardUnitNotSpawn() : Unit
      {
         return this._forwardUnitNotSpawn;
      }
      
      public function set forwardUnitNotSpawn(param1:Unit) : void
      {
         this._forwardUnitNotSpawn = param1;
      }
      
      public function get pauseCount() : int
      {
         return this._pauseCount;
      }
      
      public function set pauseCount(param1:int) : void
      {
         this._pauseCount = param1;
      }
      
      public function get rating() : int
      {
         return this._rating;
      }
      
      public function set rating(param1:int) : void
      {
         this._rating = param1;
      }
      
      public function get statueType() : String
      {
         return this._statueType;
      }
      
      public function set statueType(param1:String) : void
      {
         this._statueType = param1;
      }
      
      public function get originalType() : int
      {
         return this._originalType;
      }
      
      public function set originalType(param1:int) : void
      {
         this._originalType = param1;
      }
   }
}
