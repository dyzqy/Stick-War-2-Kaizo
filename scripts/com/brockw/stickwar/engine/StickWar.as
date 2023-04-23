package com.brockw.stickwar.engine
{
   import com.brockw.game.*;
   import com.brockw.random.*;
   import com.brockw.simulationSync.*;
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.Team.Chaos.*;
   import com.brockw.stickwar.engine.Team.Order.*;
   import com.brockw.stickwar.engine.dual.*;
   import com.brockw.stickwar.engine.maps.*;
   import com.brockw.stickwar.engine.multiplayer.*;
   import com.brockw.stickwar.engine.projectile.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class StickWar extends Simulation
   {
      
      public static const TYPE_CLASSIC:int = 0;
      
      public static const TYPE_DEATHMATCH:int = 1;
      
      public static var GRAVITY:Number;
      
      protected static var _frontScale:Number;
      
      protected static var _backScale:Number;
       
      
      private var _postCursors:Array;
      
      private var _cursorSprite:com.brockw.stickwar.engine.Entity;
      
      private var _battlefield:Sprite;
      
      private var _map:Map;
      
      private var _background:com.brockw.stickwar.engine.Background;
      
      private var _screenX:Number;
      
      private var _targetScreenX:Number;
      
      private var _gameType:int;
      
      private var _team:Team;
      
      private var _teamA:Team;
      
      private var _teamB:Team;
      
      private var _units:Dictionary;
      
      private var _currentId:int;
      
      private var shadowClip:com.brockw.stickwar.engine.Shadows;
      
      private var _random:Random;
      
      private var _dualFactory:DualFactory;
      
      private var _spatialHash:com.brockw.stickwar.engine.SpatialHash;
      
      private var _fogOfWar:com.brockw.stickwar.engine.FogOfWar;
      
      private var _unitFactory:UnitFactory;
      
      private var _oreFactory:com.brockw.stickwar.engine.OreFactory;
      
      private var _projectileManager:ProjectileManager;
      
      private var _xml:XMLLoader;
      
      private var soundLoader:com.brockw.stickwar.engine.SoundLoader;
      
      private var _soundManager:com.brockw.stickwar.engine.SoundManager;
      
      private var _rain:com.brockw.stickwar.engine.Rain;
      
      private var _inEconomy:Boolean;
      
      private var _util:Util;
      
      private var _mouseOverUnit:com.brockw.stickwar.engine.Entity;
      
      private var _tipBox:com.brockw.stickwar.engine.TipBox;
      
      private var _main:BaseMain;
      
      private var _gameScreen:GameScreen;
      
      private var _incomeDisplay:com.brockw.stickwar.engine.IncomeDisplay;
      
      private var _bloodManager:com.brockw.stickwar.engine.BloodManager;
      
      private var _commandFactory:CommandFactory;
      
      private var isDebug:Boolean;
      
      private var _mapId:int;
      
      private var _economyRecords:Array;
      
      private var _militaryRecords:Array;
      
      public var pausedGameMc:gamePausedDisplay;
      
      private var _showGameOverAnimation:Boolean;
      
      public var seed:int;
      
      public function StickWar(param1:BaseMain, param2:GameScreen)
      {
         super();
         this._main = param1;
         this._gameType = 0;
         this.seed = 0;
      }
      
      public function get gameType() : int
      {
         return this._gameType;
      }
      
      public function set gameType(param1:int) : void
      {
         this._gameType = param1;
      }
      
      public function initGame(param1:BaseMain, param2:GameScreen, param3:int = -1) : void
      {
         gameOver = this.showGameOverAnimation = false;
         super.init(param1.seed);
         ++param1.loadingFraction;
         this.economyRecords = [];
         this.militaryRecords = [];
         isReplay = false;
         this._gameScreen = param2;
         this.commandFactory = new CommandFactory(this);
         ++param1.loadingFraction;
         this.mapId = param3;
         this._random = new Random(param1.seed);
         ++param1.loadingFraction;
         if(!this._xml)
         {
            this._xml = new XMLLoader();
         }
         ++param1.loadingFraction;
         if(!this._incomeDisplay)
         {
            this._incomeDisplay = new IncomeDisplay(this);
         }
         ++param1.loadingFraction;
         param2.isDebug = this._xml.xml.debug;
         GRAVITY = this._xml.xml.gravity;
         _frontScale = this._xml.xml.frontScale;
         _backScale = this._xml.xml.backScale;
         winner = null;
         this._currentId = 0;
         this._postCursors = [];
         if(!this._oreFactory)
         {
            this._oreFactory = new OreFactory(20,this);
         }
         ++param1.loadingFraction;
         if(!this._dualFactory)
         {
            this._dualFactory = new DualFactory(this);
         }
         ++param1.loadingFraction;
         if(!this.projectileManager)
         {
            this.projectileManager = new ProjectileManager(this);
         }
         ++param1.loadingFraction;
         if(!this.tipBox)
         {
            this.tipBox = new TipBox(this);
         }
         ++param1.loadingFraction;
         if(!this._util)
         {
            this._util = new Util();
         }
         ++param1.loadingFraction;
         this.units = new Dictionary();
         this.targetScreenX = this._screenX = 0;
         this._map = Map.getMapFromId(param3,this);
         ++param1.loadingFraction;
         if(this._cursorSprite == null)
         {
            this._cursorSprite = new Entity();
            this._cursorSprite.py = this.map.height + 1;
            this._cursorSprite.graphics.beginFill(0,0);
            this._cursorSprite.graphics.drawRect(0,0,this.map.width,this.map.height);
            this._cursorSprite.x = 0;
            this._cursorSprite.y = this.map.y;
            this._cursorSprite.name = "cursorSprite";
         }
         ++param1.loadingFraction;
         if(!this._rain)
         {
            this._rain = new Rain(this,0);
         }
         ++param1.loadingFraction;
         this._battlefield = new Sprite();
         this._battlefield.x = 0;
         this._battlefield.y = this._map.y;
         ++param1.loadingFraction;
         this.shadowClip = new Shadows(this._map);
         this.shadowClip.x = 0;
         this.shadowClip.y = this.map.y;
         this.shadowClip.alpha = 0.5;
         var _loc4_:BlurFilter = new BlurFilter();
         _loc4_.blurX = _loc4_.blurY = 12;
         _loc4_.quality = 1;
         addChild(this.shadowClip);
         ++param1.loadingFraction;
         if(!this._bloodManager)
         {
            this._bloodManager = new BloodManager();
         }
         this._bloodManager.y = this.battlefield.y;
         addChild(this._bloodManager);
         addChild(this._battlefield);
         addChild(this._rain);
         ++param1.loadingFraction;
         this._rain.mouseEnabled = false;
         this._cursorSprite.mouseChildren = false;
         this._cursorSprite.mouseEnabled = false;
         addChild(this.tipBox);
         this.tipBox.mouseChildren = false;
         this.tipBox.mouseEnabled = false;
         this._rain.mouseChildren = false;
         ++param1.loadingFraction;
         this._spatialHash = new SpatialHash(this,this.map.width,this.map.height,50,this.map.height / 7,100);
         ++param1.loadingFraction;
         if(!this._unitFactory)
         {
            this._unitFactory = new UnitFactory(100,this);
         }
         ++param1.loadingFraction;
         this._inEconomy = false;
         this._map.addElementsToMap(this);
         this.isDebug = this.xml.xml.debug == 1;
         this.soundLoader = param1.soundLoader;
         this.soundManager = param1.soundManager;
         this.pausedGameMc = new gamePausedDisplay();
         this.pausedGameMc.x = stage.stageWidth / 2;
         this.pausedGameMc.y = stage.stageHeight / 2;
         this.pausedGameMc.visible = false;
         addChild(this.pausedGameMc);
         ++param1.loadingFraction;
      }
      
      override public function postInit() : void
      {
         this.fogOfWar = new FogOfWar(this);
         addChild(this.fogOfWar);
         this.fogOfWar.isFogOn = this.xml.xml.isFogOfWar == 1;
      }
      
      public function cleanUp() : void
      {
         if(Boolean(this._cursorSprite.parent) && Boolean(this._cursorSprite.parent.contains(this._cursorSprite)))
         {
            this._cursorSprite.parent.removeChild(this._cursorSprite);
         }
         this._cursorSprite = null;
         this._map = null;
         this._team = null;
         this._teamA.cleanUp();
         this._teamA = null;
         this._teamB.cleanUp();
         this._teamB = null;
         this._background.cleanUp();
         this._background = null;
         this._units = new Dictionary();
         this.shadowClip = null;
         this.random = null;
         this._dualFactory.cleanUp();
         this._dualFactory = null;
         this._spatialHash.cleanUp();
         this._spatialHash = null;
         this._projectileManager.cleanUp();
         this._battlefield = null;
         this._projectileManager = null;
         this._oreFactory = null;
         this.unitFactory.cleanUp();
         this.unitFactory = null;
         this._mouseOverUnit = null;
         this._tipBox = null;
         Util.recursiveRemoval(Sprite(this));
      }
      
      public function getNextUnitId() : int
      {
         return this._currentId++;
      }
      
      public function initTeams(param1:int, param2:int, param3:int, param4:int, param5:Dictionary = null, param6:Dictionary = null, param7:Number = 1, param8:Number = 1, param9:Number = 1, param10:Number = 1, param11:Number = 1, param12:Number = 1) : void
      {
         this._teamA = Team.getTeamFromId(param1,this,param3,param5,param7,param9);
         this._teamB = Team.getTeamFromId(param2,this,param4,param6,param8,param10);
         this._teamA.name = 0;
         this._teamB.name = 1;
         this._teamA.direction = 1;
         this._teamB.direction = -1;
         this._teamA.homeX = this._teamA.direction * this.map.screenWidth;
         this._teamB.homeX = this.map.width + this._teamB.direction * this.map.screenWidth;
         this._teamA.ai = new TeamGoodAi(this._teamA);
         this._teamB.ai = new TeamGoodAi(this._teamB);
         this._teamA.enemyTeam = this._teamB;
         this._teamB.enemyTeam = this._teamA;
         if(this.xml.xml.debug == 1)
         {
            this._teamA.gold = 100000;
            this._teamB.gold = 100000;
            this._teamA.mana = 100000;
            this._teamB.mana = 100000;
         }
         else
         {
            this._teamA.gold = this.xml.xml.startingGold;
            this._teamB.gold = this.xml.xml.startingGold;
            this._teamA.mana = this.xml.xml.startingMana;
            this._teamB.mana = this.xml.xml.startingMana;
         }
         this.battlefield.addChild(this._teamA.castleBack);
         this.battlefield.addChild(this._teamB.castleBack);
         this.battlefield.addChild(this._teamA.statue);
         this.battlefield.addChild(this._teamB.statue);
         this.battlefield.addChild(this._teamA.castleFront);
         this.battlefield.addChild(this._teamB.castleFront);
         this.battlefield.addChild(this._teamA.base);
         this.battlefield.addChild(this._teamB.base);
         this._teamA.init();
         this._teamB.init();
         this._teamA.damageModifier = param11;
         this._teamB.damageModifier = param12;
         this.map.addCombiners(this);
      }
      
      public function setPaused(param1:Boolean) : void
      {
         this.pausedGameMc.visible = param1;
      }
      
      private function determineIfBetterSelection(param1:com.brockw.stickwar.engine.Entity) : Boolean
      {
         if(param1 is Unit && Boolean(Unit(param1).isDead))
         {
            return false;
         }
         if(this.mouseOverUnit == null)
         {
            return true;
         }
         if(Math.abs(this.battlefield.mouseX - param1.px) < Math.abs(this.battlefield.mouseX - this.mouseOverUnit.px))
         {
            return true;
         }
         return false;
      }
      
      public function updateVisibilityOfUnits() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.teamA.units)
         {
            if(Entity(this.teamA.units[_loc1_]).onScreen(this))
            {
               this.teamA.units[_loc1_].visible = true;
            }
            else
            {
               this.teamA.units[_loc1_].visible = false;
            }
         }
         for(_loc1_ in this.teamB.units)
         {
            if(Entity(this.teamB.units[_loc1_]).onScreen(this))
            {
               this.teamB.units[_loc1_].visible = true;
            }
            else
            {
               this.teamB.units[_loc1_].visible = false;
            }
         }
      }
      
      public function updateMouseOverUnit(param1:Screen, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Wall = null;
         var _loc6_:Unit = null;
         this.mouseOverUnit = null;
         this.team.enemyTeam.statue.mouseIsOver = false;
         if(this.team.enemyTeam.statue.isMouseHitTest(stage.mouseX,stage.mouseY) && Boolean(this.determineIfBetterSelection(this.team.enemyTeam.statue)))
         {
            this.mouseOverUnit = this.team.enemyTeam.statue;
         }
         for(_loc3_ in this.teamA.castleDefence.units)
         {
            if(Entity(this.teamA.castleDefence.units[_loc3_]).onScreen(this))
            {
               this.teamA.castleDefence.units[_loc3_].visible = true;
            }
            else
            {
               this.teamA.castleDefence.units[_loc3_].visible = false;
            }
         }
         for(_loc3_ in this.teamB.castleDefence.units)
         {
            if(Entity(this.teamB.castleDefence.units[_loc3_]).onScreen(this))
            {
               this.teamB.castleDefence.units[_loc3_].visible = true;
            }
            else
            {
               this.teamB.castleDefence.units[_loc3_].visible = false;
            }
         }
         for(_loc3_ in this.teamA.units)
         {
            if(Boolean(Unit(this.teamA.units[_loc3_]).isTargetable()) && param2)
            {
               this._spatialHash.add(this.teamA.units[_loc3_]);
            }
            if(Entity(this.teamA.units[_loc3_]).onScreen(this))
            {
               this.teamA.units[_loc3_].visible = true;
               this.teamA.units[_loc3_].mouseIsOver = false;
               if(this.teamA.units[_loc3_].mc.mc.hitTestPoint(stage.mouseX,stage.mouseY,false))
               {
                  if(this.determineIfBetterSelection(this.teamA.units[_loc3_]))
                  {
                     this.mouseOverUnit = this.teamA.units[_loc3_];
                  }
               }
            }
            else
            {
               this.teamA.units[_loc3_].visible = false;
            }
         }
         for(_loc3_ in this.teamB.units)
         {
            if(Boolean(Unit(this.teamB.units[_loc3_]).isTargetable()) && param2)
            {
               this._spatialHash.add(this.teamB.units[_loc3_]);
            }
            if(Entity(this.teamB.units[_loc3_]).onScreen(this))
            {
               this.teamB.units[_loc3_].visible = true;
               this.teamB.units[_loc3_].mouseIsOver = false;
               if(this.teamB.units[_loc3_].mc.mc.hitTestPoint(stage.mouseX,stage.mouseY,false))
               {
                  if(this.determineIfBetterSelection(this.teamB.units[_loc3_]))
                  {
                     this.mouseOverUnit = this.teamB.units[_loc3_];
                  }
               }
            }
            else
            {
               this.teamB.units[_loc3_].visible = false;
            }
         }
         for(_loc4_ in this.map.gold)
         {
            Entity(this.map.gold[_loc4_]).mouseIsOver = false;
            if(Boolean(Gold(this.map.gold[_loc4_]).frontOre.hitTestPoint(stage.mouseX,stage.mouseY,true)) || Boolean(Gold(this.map.gold[_loc4_]).ore.hitTestPoint(stage.mouseX,stage.mouseY,true)))
            {
               if(this.determineIfBetterSelection(Entity(this.map.gold[_loc4_])))
               {
                  this.mouseOverUnit = Entity(this.map.gold[_loc4_]);
               }
            }
            if(param2)
            {
               Gold(this.map.gold[_loc4_]).update(this);
            }
         }
         this.team.statue.mouseIsOver = false;
         if(this.team.statue.isMouseHitTest(stage.mouseX,stage.mouseY) && Boolean(this.determineIfBetterSelection(this.team.statue)))
         {
            this.mouseOverUnit = this.team.statue;
         }
         if(this.mouseOverUnit == null)
         {
            for each(_loc5_ in this.team.enemyTeam.walls)
            {
               if(_loc5_.checkForHitPoint2(new Point(stage.mouseX,stage.mouseY)))
               {
                  this.mouseOverUnit = _loc5_;
               }
            }
         }
         if(this.mouseOverUnit != null)
         {
            this.mouseOverUnit.mouseIsOver = true;
         }
         if(!param2)
         {
            for each(_loc6_ in this.teamA.units)
            {
               Unit(_loc6_).updateSelected();
            }
            for each(_loc6_ in this.teamB.units)
            {
               Unit(_loc6_).updateSelected();
            }
         }
      }
      
      override public function update(param1:Screen) : void
      {
         var _loc3_:Hill = null;
         this.teamA.updateStatue();
         this.teamB.updateStatue();
         if(this.showGameOverAnimation)
         {
            return;
         }
         if(frame % 60 == 0)
         {
            this.militaryRecords.push(this.team.population);
            this.militaryRecords.push(this.team.enemyTeam.population);
            this.economyRecords.push(this.team.getNumberOfMiners());
            this.economyRecords.push(this.team.enemyTeam.getNumberOfMiners());
         }
         super.update(param1);
         this._incomeDisplay.update(this);
         var _loc2_:GameScreen = GameScreen(param1);
         this._rain.update(this);
         if(this.teamA.statue.health <= 0)
         {
            this.showGameOverAnimation = true;
            this.soundManager.playSoundFullVolume("StatueDestroyed");
            winner = this.teamB;
         }
         if(this.teamB.statue.health <= 0)
         {
            this.showGameOverAnimation = true;
            this.soundManager.playSoundFullVolume("StatueDestroyed");
            winner = this.teamA;
         }
         this.projectileManager.update(this);
         this.projectileManager.airEffects.splice(0,this.projectileManager.airEffects.length);
         for each(_loc3_ in this.map.hills)
         {
            _loc3_.update(this);
         }
         this._spatialHash.clear();
         this._spatialHash.add(this.teamA.statue);
         this._spatialHash.add(this.teamB.statue);
         this.updateMouseOverUnit(param1,true);
         this.sortZ(this.battlefield);
         this._teamA.update(this);
         this._teamB.update(this);
         this.team.updateButtonOverPost(this);
         this.tipBox.update(this);
      }
      
      public function getTeamFromId(param1:int) : *
      {
         if(this.team.id == param1)
         {
            return this.team;
         }
         if(this.team.enemyTeam.id == param1)
         {
            return this.team.enemyTeam;
         }
         return null;
      }
      
      private function sortZ(param1:DisplayObjectContainer, param2:int = 20) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         param2 = 1;
         if(param1.numChildren > 60)
         {
            param2 = 10 + (param1.numChildren - 60);
         }
         var _loc3_:int = this.random.nextInt() % param2;
         var _loc4_:int = param1.numChildren - 1 - _loc3_;
         while(_loc4_ > 0)
         {
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               if(param1.getChildAt(_loc6_) is Entity && param1.getChildAt(_loc6_ + 1) is Entity)
               {
                  if(Entity(param1.getChildAt(_loc6_)).py > Entity(param1.getChildAt(_loc6_ + 1)).py)
                  {
                     param1.swapChildrenAt(_loc6_,_loc6_ + 1);
                     _loc5_ = true;
                  }
               }
               _loc6_++;
            }
            if(!_loc5_)
            {
               return;
            }
            _loc4_ -= param2;
         }
      }
      
      public function getPerspectiveScale(param1:*) : Number
      {
         return this.backScale + param1 / this.map.height * (this.frontScale - this.backScale);
      }
      
      public function requestToSpawn(param1:int, param2:int) : void
      {
         if(this._teamA.name == param1)
         {
            this._teamA.spawnUnit(param2,this);
         }
         else if(this._teamB.name == param1)
         {
            this._teamB.spawnUnit(param2,this);
         }
      }
      
      public function get screenX() : Number
      {
         return this._screenX;
      }
      
      public function set screenX(param1:Number) : void
      {
         this._screenX = param1;
      }
      
      override public function executeTurn(param1:Turn) : void
      {
         var _loc2_:Move = null;
         while(!param1.moves.isEmpty())
         {
            _loc2_ = Move(param1.moves.pop());
            _loc2_.execute(this);
         }
      }
      
      override public function getCheckSum() : int
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Projectile = null;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         for(_loc2_ in this.units)
         {
            _loc1_ += Entity(this.units[_loc2_]).px + Entity(this.units[_loc2_]).py;
         }
         _loc3_ = 0;
         for each(_loc4_ in this._projectileManager.projectiles)
         {
            _loc3_ += _loc4_.px + _loc4_.py;
         }
         _loc5_ = int(Math.floor(1000 * this.random.lastRandom));
         return _loc1_ + _loc3_ + _loc5_;
      }
      
      public function get targetScreenX() : Number
      {
         return this._targetScreenX;
      }
      
      public function set targetScreenX(param1:Number) : void
      {
         this._targetScreenX = param1;
      }
      
      public function get battlefield() : Sprite
      {
         return this._battlefield;
      }
      
      public function set battlefield(param1:Sprite) : void
      {
         this._battlefield = param1;
      }
      
      public function get background() : com.brockw.stickwar.engine.Background
      {
         return this._background;
      }
      
      public function set background(param1:com.brockw.stickwar.engine.Background) : void
      {
         this._background = param1;
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function set map(param1:Map) : void
      {
         this._map = param1;
      }
      
      public function get teamA() : Team
      {
         return this._teamA;
      }
      
      public function set teamA(param1:Team) : void
      {
         this._teamA = param1;
      }
      
      public function get teamB() : Team
      {
         return this._teamB;
      }
      
      public function set teamB(param1:Team) : void
      {
         this._teamB = param1;
      }
      
      public function get spatialHash() : com.brockw.stickwar.engine.SpatialHash
      {
         return this._spatialHash;
      }
      
      public function set spatialHash(param1:com.brockw.stickwar.engine.SpatialHash) : void
      {
         this._spatialHash = param1;
      }
      
      public function get dualFactory() : DualFactory
      {
         return this._dualFactory;
      }
      
      public function set dualFactory(param1:DualFactory) : void
      {
         this._dualFactory = param1;
      }
      
      public function get random() : Random
      {
         return this._random;
      }
      
      public function set random(param1:Random) : void
      {
         this._random = param1;
      }
      
      public function get units() : Dictionary
      {
         return this._units;
      }
      
      public function set units(param1:Dictionary) : void
      {
         this._units = param1;
      }
      
      public function get unitFactory() : UnitFactory
      {
         return this._unitFactory;
      }
      
      public function set unitFactory(param1:UnitFactory) : void
      {
         this._unitFactory = param1;
      }
      
      public function get frontScale() : Number
      {
         return _frontScale;
      }
      
      public function set frontScale(param1:Number) : void
      {
         _frontScale = param1;
      }
      
      public function get backScale() : Number
      {
         return _backScale;
      }
      
      public function set backScale(param1:Number) : void
      {
         _backScale = param1;
      }
      
      public function get projectileManager() : ProjectileManager
      {
         return this._projectileManager;
      }
      
      public function set projectileManager(param1:ProjectileManager) : void
      {
         this._projectileManager = param1;
      }
      
      public function get cusorSprite() : com.brockw.stickwar.engine.Entity
      {
         return this._cursorSprite;
      }
      
      public function set cusorSprite(param1:com.brockw.stickwar.engine.Entity) : void
      {
         this._cursorSprite = param1;
      }
      
      public function get xml() : XMLLoader
      {
         return this._xml;
      }
      
      public function set xml(param1:XMLLoader) : void
      {
         this._xml = param1;
      }
      
      public function get inEconomy() : Boolean
      {
         return this._inEconomy;
      }
      
      public function set inEconomy(param1:Boolean) : void
      {
         this._inEconomy = param1;
      }
      
      public function get util() : Util
      {
         return this._util;
      }
      
      public function set util(param1:Util) : void
      {
         this._util = param1;
      }
      
      public function get tipBox() : com.brockw.stickwar.engine.TipBox
      {
         return this._tipBox;
      }
      
      public function set tipBox(param1:com.brockw.stickwar.engine.TipBox) : void
      {
         this._tipBox = param1;
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      public function set team(param1:Team) : void
      {
         this._team = param1;
      }
      
      public function get mouseOverUnit() : com.brockw.stickwar.engine.Entity
      {
         return this._mouseOverUnit;
      }
      
      public function set mouseOverUnit(param1:com.brockw.stickwar.engine.Entity) : void
      {
         this._mouseOverUnit = param1;
      }
      
      public function get main() : BaseMain
      {
         return this._main;
      }
      
      public function set main(param1:BaseMain) : void
      {
         this._main = param1;
      }
      
      public function get gameScreen() : GameScreen
      {
         return this._gameScreen;
      }
      
      public function set gameScreen(param1:GameScreen) : void
      {
         this._gameScreen = param1;
      }
      
      public function get incomeDisplay() : com.brockw.stickwar.engine.IncomeDisplay
      {
         return this._incomeDisplay;
      }
      
      public function set incomeDisplay(param1:com.brockw.stickwar.engine.IncomeDisplay) : void
      {
         this._incomeDisplay = param1;
      }
      
      public function get bloodManager() : com.brockw.stickwar.engine.BloodManager
      {
         return this._bloodManager;
      }
      
      public function set bloodManager(param1:com.brockw.stickwar.engine.BloodManager) : void
      {
         this._bloodManager = param1;
      }
      
      public function get postCursors() : Array
      {
         return this._postCursors;
      }
      
      public function set postCursors(param1:Array) : void
      {
         this._postCursors = param1;
      }
      
      public function get fogOfWar() : com.brockw.stickwar.engine.FogOfWar
      {
         return this._fogOfWar;
      }
      
      public function set fogOfWar(param1:com.brockw.stickwar.engine.FogOfWar) : void
      {
         this._fogOfWar = param1;
      }
      
      public function get commandFactory() : CommandFactory
      {
         return this._commandFactory;
      }
      
      public function set commandFactory(param1:CommandFactory) : void
      {
         this._commandFactory = param1;
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(param1:int) : void
      {
         this._mapId = param1;
      }
      
      public function get economyRecords() : Array
      {
         return this._economyRecords;
      }
      
      public function set economyRecords(param1:Array) : void
      {
         this._economyRecords = param1;
      }
      
      public function get militaryRecords() : Array
      {
         return this._militaryRecords;
      }
      
      public function set militaryRecords(param1:Array) : void
      {
         this._militaryRecords = param1;
      }
      
      public function get soundManager() : com.brockw.stickwar.engine.SoundManager
      {
         return this._soundManager;
      }
      
      public function set soundManager(param1:com.brockw.stickwar.engine.SoundManager) : void
      {
         this._soundManager = param1;
      }
      
      public function get cursorSprite() : com.brockw.stickwar.engine.Entity
      {
         return this._cursorSprite;
      }
      
      public function set cursorSprite(param1:com.brockw.stickwar.engine.Entity) : void
      {
         this._cursorSprite = param1;
      }
      
      public function get showGameOverAnimation() : Boolean
      {
         return this._showGameOverAnimation;
      }
      
      public function set showGameOverAnimation(param1:Boolean) : void
      {
         this._showGameOverAnimation = param1;
      }
   }
}
