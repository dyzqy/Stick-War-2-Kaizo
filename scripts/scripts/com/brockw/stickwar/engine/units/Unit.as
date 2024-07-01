package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.UnitAi;
      import com.brockw.stickwar.engine.Ai.command.HoldCommand;
      import com.brockw.stickwar.engine.Ai.command.StandCommand;
      import com.brockw.stickwar.engine.Ai.command.UnitCommand;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.HealthBar;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Building;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.dual.Dual;
      import flash.display.FrameLabel;
      import flash.display.MovieClip;
      import flash.filters.BitmapFilterQuality;
      import flash.filters.GlowFilter;
      import flash.geom.ColorTransform;
      import flash.geom.Point;
      import flash.geom.Vector3D;
      import flash.utils.Dictionary;
      
      public class Unit extends Entity
      {
            
            public static const D_NONE:* = 0;
            
            public static const D_FIRE:* = 1;
            
            public static const D_NO_SOUND:* = 2;
            
            public static const D_NO_BLOOD:* = 4;
            
            public static const D_ARROW:* = 8;
            
            private static const COLLISION_DAMPNING:Number = 0.6;
            
            public static const U_MINER:int = 1;
            
            public static const U_MAGIKILL:int = 2;
            
            public static const U_MONK:int = 3;
            
            public static const U_ARCHER:int = 4;
            
            public static const U_FLYING_CROSSBOWMAN:int = 5;
            
            public static const U_NINJA:int = 6;
            
            public static const U_SWORDWRATH:int = 7;
            
            public static const U_SPEARTON:int = 8;
            
            public static const U_ENSLAVED_GIANT:int = 9;
            
            public static const U_STATUE:int = 1000;
            
            public static const U_DEAD:int = 10;
            
            public static const U_WINGIDON:int = 11;
            
            public static const U_DASHNITE:int = 12;
            
            public static const U_CHAOS_MINER:int = 13;
            
            public static const U_BOMBER:int = 14;
            
            public static const U_SKELATOR:int = 15;
            
            public static const U_CAT:int = 16;
            
            public static const U_KNIGHT:int = 17;
            
            public static const U_MEDUSA:int = 18;
            
            public static const U_GIANT:int = 19;
            
            public static const U_CHAOS_TOWER:int = 20;
            
            public static const U_WALL:int = 21;
            
            public static const U_MINER_ELEMENT:int = 22;
            
            public static const U_WATER_ELEMENT:int = 23;
            
            public static const U_AIR_ELEMENT:int = 24;
            
            public static const U_FIRE_ELEMENT:int = 25;
            
            public static const U_LAVA_ELEMENT:int = 26;
            
            public static const U_HURRICANE_ELEMENT:int = 27;
            
            public static const U_TREE_ELEMENT:int = 28;
            
            public static const U_FIRESTORM_ELEMENT:int = 29;
            
            public static const U_CHROME_ELEMENT:int = 30;
            
            public static const U_EARTH_ELEMENT:int = 31;
            
            public static const U_SCORPION_ELEMENT:int = 32;
            
            public static const U_STEAM_EXPLOSION:int = 33;
            
            public static const U_SANDSTORM:int = 34;
            
            public static const B_ORDER_BANK:int = 100;
            
            public static const B_BARRACKS:int = 101;
            
            public static const B_ARCHERY_RANGE:int = 102;
            
            public static const B_SIEGE_WORKSHOP:int = 103;
            
            public static const B_MAGIC_SHOP:int = 104;
            
            public static const B_TEMPLE:int = 105;
            
            public static const B_CHAOS_BARRACKS:int = 106;
            
            public static const B_CHAOS_FLETCHER:int = 107;
            
            public static const B_CHAOS_UNDEAD:int = 108;
            
            public static const B_CHAOS_GIANT:int = 109;
            
            public static const B_CHAOS_MEDUSA:int = 110;
            
            public static const B_CHAOS_BANK:int = 111;
            
            public static const B_ELEMENTAL_FIRE:int = 112;
            
            public static const B_ELEMENTAL_WATER:int = 113;
            
            public static const B_ELEMENTAL_AIR:int = 114;
            
            public static const B_ELEMENTAL_EARTH:int = 115;
            
            public static const B_ELEMENTAL_BANK:int = 116;
            
            public static const B_ELEMENTAL_TEMPLE:int = 117;
            
            protected static const S_RUN:int = 0;
            
            protected static const S_ATTACK:int = 1;
            
            protected static const S_DEATH:int = 2;
            
            protected static const S_MINE:int = 3;
            
            private static const stunUpForce:Number = 2;
            
            public static const I_MINE:int = 1;
            
            public static const I_STATUE:int = 1 << 2;
            
            public static const I_ENEMY:int = 1 << 3;
            
            public static const I_FRIENDS:int = 1 << 4;
            
            public static const I_IS_BUILDING:int = 1 << 5;
             
            
            protected var timeAlive:int;
            
            protected var nudgeFrame:int;
            
            protected var hasHit:Boolean;
            
            protected var _health:Number;
            
            protected var _armour:int;
            
            protected var _mass:int;
            
            protected var _maxForce:Number;
            
            protected var _dragForce:Number;
            
            protected var _maxVelocity:Number;
            
            protected var _scale:Number = 1;
            
            protected var _perspectiveScale:Number = 1;
            
            protected var combineColour:int;
            
            private var _population:int;
            
            protected const _worldScaleX:Number = 1;
            
            protected const _worldScaleY:Number = 0.8;
            
            protected var _dx:Number;
            
            protected var _dy:Number;
            
            protected var _dz:Number;
            
            protected var intendedWalkDirection:int;
            
            protected var _hitBoxWidth:int;
            
            protected var _hitBoxHeight:int;
            
            protected var _state:int;
            
            protected var _mc:MovieClip;
            
            protected var _ai:UnitAi;
            
            private var _team:Team;
            
            protected var _isDieing:Boolean;
            
            protected var _isDead:Boolean;
            
            private var _timeOfDeath:Number;
            
            public var isSwitched:Boolean;
            
            protected var _syncAttackLabels:Dictionary;
            
            protected var _syncDefendLabels:Dictionary;
            
            protected var _attackLabels:Array;
            
            protected var _deathLabels:Array;
            
            protected var _currentDual:Dual;
            
            protected var _isDualing:Boolean;
            
            protected var _dualPartner:Unit;
            
            protected var _flyingHeight:Number;
            
            protected var _lastTurnCount:int;
            
            protected var TURN_AGILITY:int;
            
            private var _healthBar:HealthBar;
            
            private var _damageToDeal:Number;
            
            private var _mayWalkThrough:Boolean;
            
            protected var _createTime:int;
            
            protected var _stunTimeLeft:int;
            
            private var _building:Building;
            
            private var _isStationary:Boolean;
            
            private var _poisonDamage:Number;
            
            private var framesPoisoned:int;
            
            private var _randomInterval:int;
            
            private var _healAmount:Number;
            
            private var _healTimeRemaining:int;
            
            protected var _maxHealth:int;
            
            protected var slowFramesRemaining:int;
            
            protected var rageFramesRemaining:int;
            
            private var _isBusyForSpell:Boolean;
            
            protected var _shadowSprite:MovieClip;
            
            public var iceUnit:Boolean = false;
            
            protected var framesInAttack:int;
            
            protected var attackStartFrame:int;
            
            protected var _interactsWith:int;
            
            private var _freezeCount:int = 0;
            
            private var dzOffset:Number;
            
            private var _freezeLock:Unit;
            
            public var isFreezing:Boolean = false;
            
            private var _reaperCurseFrames:int;
            
            private var reaperCurseFramesTotal:int;
            
            private var reaperAmplification:Number;
            
            private var reaperInflictor:Unit;
            
            private var chaosHealRate:Number;
            
            private var _stoned:Boolean;
            
            protected var isStoneable:Boolean;
            
            private var _isFirable:Boolean;
            
            private var chaosPoisonedFrames:int;
            
            private var _isOnFire:Boolean;
            
            public var isHome:Boolean;
            
            private var reaperMc:reaperEffectMc;
            
            private var poisonMc:poisonEffect;
            
            private var stunMc:dizzyMc;
            
            private var _isRejoiningFormation:Boolean;
            
            private var garrisonHealRate:Number;
            
            protected var _isTowerSpawned:Boolean;
            
            private var _isInteractable:Boolean;
            
            private var towerSpawnGlow:GlowFilter;
            
            private var towerSpawnGlowChaos:GlowFilter;
            
            private var enemyTowerSpawnGlow:GlowFilter;
            
            private var protectFilter:GlowFilter;
            
            private var lastHealthAnimation:int;
            
            private var _arrowDeath:Boolean;
            
            private var _hasDefaultLoadout:Boolean;
            
            private var _ddx:Number;
            
            private var _ddy:Number;
            
            private var lastWalkFrame:int;
            
            public var protectedFrames:int;
            
            private var protectionAmount:Number;
            
            private var fireDamageFrames:int;
            
            private var fireDamagePerFrame:Number;
            
            private var fireEffectMc:MovieClip;
            
            private var combineMc:MovieClip;
            
            private var rebelsAreEvil:Boolean;
            
            public var isNormal:Boolean = true;
            
            public var specialTimeOver:Boolean = false;
            
            public var enemyBuffed:Boolean = false;
            
            public var vampUnit:Boolean;
            
            public var deadRespawn:Dead;
            
            public var currentLevelTitle:String;
            
            public var isCustomUnit:Boolean = false;
            
            public function Unit(param1:StickWar)
            {
                  this.protectedFrames = 0;
                  this.hasDefaultLoadout = false;
                  this.isTowerSpawned = false;
                  this._isRejoiningFormation = false;
                  this.garrisonHealRate = 0;
                  this.framesPoisoned = 0;
                  this.TURN_AGILITY = 5;
                  this._lastTurnCount = 0;
                  this.combineMc = null;
                  this.combineColour = 0;
                  this.healthBar = new HealthBar();
                  this._building = null;
                  this.lastHealthAnimation = 0;
                  this.dzOffset = 0;
                  this._createTime = 30;
                  this._randomInterval = 90;
                  this._interactsWith = I_ENEMY;
                  this._healTimeRemaining = 0;
                  this.isSwitched = false;
                  this.reaperCurseFrames = 0;
                  this.chaosPoisonedFrames = param1.xml.xml.Chaos.poisonDuration;
                  this.reaperCurseFramesTotal = param1.xml.xml.Chaos.Units.skelator.reaper.frames;
                  this.reaperAmplification = param1.xml.xml.Chaos.Units.skelator.reaper.amplification;
                  this.chaosHealRate = param1.xml.xml.Chaos.healRate;
                  this.garrisonHealRate = param1.xml.xml.garrisonHealRate;
                  this.timeAlive = 0;
                  this.nudgeFrame = param1.frame;
                  this.freezeLock = null;
                  var _loc2_:Number = 65535;
                  var _loc7_:Number = BitmapFilterQuality.LOW;
                  this.towerSpawnGlow = new GlowFilter(_loc2_,1,36,18,2.64,_loc7_,false,false);
                  _loc2_ = 29440;
                  this.towerSpawnGlowChaos = new GlowFilter(_loc2_,1,36,18,2.64,_loc7_,false,false);
                  _loc2_ = 16711680;
                  this.enemyTowerSpawnGlow = new GlowFilter(_loc2_,1,36,18,2.64,_loc7_,false,false);
                  _loc2_ = 16711680;
                  this.protectFilter = new GlowFilter(_loc2_,1,36,18,2.64,_loc7_,false,false);
                  this.attackStartFrame = 0;
                  this.framesInAttack = 0;
                  this.arrowDeath = false;
                  this._ddy = 0;
                  this._ddx = 0;
                  this.lastWalkFrame = 0;
                  super();
            }
            
            protected function updateElementalCombine() : void
            {
                  var _loc1_:ColorTransform = null;
                  if(this.ai.currentCommand.isCombining() && this.isAlive())
                  {
                        if(this.combineMc == null)
                        {
                              this.combineMc = new combineEffectMc();
                              this.combineMc.scaleX = 0.3;
                              this.combineMc.scaleY = 0.3;
                              this.combineMc.y = this.healthBar.y - this.combineMc.height * 0.5;
                              this.mc.addChild(this.combineMc);
                              _loc1_ = this.combineMc.transform.colorTransform;
                              _loc1_.color = this.combineColour;
                              this.combineMc.transform.colorTransform = _loc1_;
                        }
                        else
                        {
                              Util.animateMovieClip(this.combineMc);
                              Util.animateMovieClipBasic(this.combineMc);
                        }
                  }
                  else
                  {
                        if(this.combineMc && this.mc.contains(this.combineMc))
                        {
                              this.mc.removeChild(this.combineMc);
                        }
                        this.combineMc = null;
                  }
            }
            
            public function get isInteractable() : Boolean
            {
                  return this._isInteractable;
            }
            
            public function set isInteractable(param1:Boolean) : void
            {
                  this._isInteractable = param1;
            }
            
            public function get freezeLock() : Unit
            {
                  return this._freezeLock;
            }
            
            public function set freezeLock(param1:Unit) : void
            {
                  this._freezeLock = param1;
            }
            
            public function get freezeCount() : int
            {
                  return this._freezeCount;
            }
            
            public function set freezeCount(param1:int) : void
            {
                  this._freezeCount = param1;
            }
            
            public function weaponReach() : Number
            {
                  return 0;
            }
            
            public function reaperCurse(param1:Unit) : void
            {
                  this.stateFixForCutToWalk();
                  if(this.reaperMc && this.mc.contains(this.reaperMc))
                  {
                        this.mc.removeChild(this.reaperMc);
                  }
                  this.reaperMc = new reaperEffectMc();
                  this.mc.addChild(this.reaperMc);
                  this.reaperMc.x = 0;
                  this.reaperMc.y = this.healthBar.y - 10;
                  this.reaperMc.scaleX = 0.8;
                  this.reaperMc.scaleY = 0.8;
                  this.reaperCurseFrames = this.reaperCurseFramesTotal;
                  this.reaperInflictor = param1;
            }
            
            public function canAttackAir() : Boolean
            {
                  return false;
            }
            
            public function canAttackGround() : Boolean
            {
                  return true;
            }
            
            override public function cleanUp() : void
            {
                  if(this._mc != null)
                  {
                        if(contains(this._mc))
                        {
                              this.removeChild(this._mc);
                        }
                  }
                  this._mc = null;
                  if(this._ai)
                  {
                        this._ai.cleanUp();
                  }
                  this._ai = null;
                  this._team = null;
                  selectedFilter = null;
                  nonSelectedFilter = null;
                  this._syncAttackLabels = null;
                  this._syncDefendLabels = null;
                  this._attackLabels = null;
                  this._deathLabels = null;
                  this._currentDual = null;
                  this._dualPartner = null;
                  this._healthBar = null;
            }
            
            public function isPoisoned() : Boolean
            {
                  return this._poisonDamage > 0;
            }
            
            protected function moveDualPartner(param1:Unit, param2:Number) : *
            {
                  var _loc3_:Number = Math.abs(param1.px - this.px);
                  var _loc4_:Number = this._currentDual.xDiff * this.team.game.getPerspectiveScale(py);
                  this.px += Util.sgn(this.px - param1.px) * (_loc4_ - _loc3_) * 0.1;
                  this.py += (param1.py - 0.001 - py) * 0.1;
                  this.y = this.py;
                  this.x = this.px;
                  if(param1.mc.mc.grunt != null)
                  {
                        param1.playDeathSound();
                  }
                  if(param1.mc.mc.fall != null)
                  {
                        this.team.game.soundManager.playSound("BodyfallSound",px,py);
                  }
                  if(param1.mc.mc.clash != null)
                  {
                        this.team.game.soundManager.playSoundRandom("hitOnArmour",7,px,py);
                  }
            }
            
            public function isIncapacitated() : Boolean
            {
                  return this.stunTimeLeft > 0;
            }
            
            override public function drawOnHud(param1:MovieClip, param2:StickWar) : void
            {
                  var _loc3_:Number = param1.width * px / param2.map.width;
                  var _loc4_:Number = param1.height * py / param2.map.height;
                  if(this.isDead)
                  {
                        return;
                  }
                  if(this.team.isEnemy)
                  {
                        MovieClip(param1).graphics.lineStyle(2,16711680,1);
                  }
                  else if(selected)
                  {
                        MovieClip(param1).graphics.lineStyle(2,65280,1);
                  }
                  else
                  {
                        MovieClip(param1).graphics.lineStyle(2,0,1);
                  }
                  MovieClip(param1).graphics.drawRect(_loc3_,_loc4_,1,1);
            }
            
            public function getDamageToDeal() : Number
            {
                  return this.damageToDeal;
            }
            
            public function setBuilding() : void
            {
                  this.building = null;
            }
            
            public function firstInit() : void
            {
                  var _loc1_:Number = Number(this.mc.mc.height);
                  this._mayWalkThrough = false;
                  pheight = this.mc.height;
                  pwidth = this.mc.width;
                  this.healthBar.totalHealth = this._health;
                  this.mc.addChild(this.healthBar);
                  this.healthBar.scaleX *= 1.3;
                  this.healthBar.scaleY *= 1.2;
                  this.healthBar.y = -_loc1_ * 1.2;
                  this.flyingHeight = 0;
                  this._dz = 0;
                  this.hasDefaultLoadout = false;
                  Util.animateToNeutral(this.mc);
            }
            
            public function initBase() : void
            {
                  var _loc2_:FrameLabel = null;
                  this.timeAlive = 0;
                  this.fireDamageFrames = 0;
                  this.fireDamagePerFrame = 0;
                  this.fireEffectMc = null;
                  _type = Unit.U_MINER;
                  this._maxForce = 1;
                  this._mass = 1;
                  this.protectedFrames = 0;
                  this._dragForce = 1;
                  this._scale = 1;
                  this._maxVelocity = 1;
                  this._poisonDamage = 0;
                  this._hitBoxWidth = 50;
                  this._hitBoxHeight = 40;
                  this.isSwitched = false;
                  this.maxHealth = 100;
                  this.isBusyForSpell = false;
                  this._health = 100;
                  this.stoned = false;
                  this._population = 1;
                  this.isDieing = false;
                  this.timeOfDeath = 0;
                  this.isDead = false;
                  this._isDualing = false;
                  this._currentDual = null;
                  this._dualPartner = null;
                  this.intendedWalkDirection = 1;
                  this._dx = this._dy = 0;
                  pz = 0;
                  this._healTimeRemaining = 0;
                  this.slowFramesRemaining = 0;
                  this.rageFramesRemaining = 0;
                  _mouseIsOver = false;
                  this.isHome = true;
                  this.freezeLock = null;
                  this.isOnFire = false;
                  this.isStoneable = false;
                  var _loc1_:Array = this._mc.currentLabels;
                  for each(_loc2_ in _loc1_)
                  {
                        if(_loc2_.name == "stone")
                        {
                              this.isStoneable = true;
                        }
                        if(_loc2_.name == "fireDeath")
                        {
                              this.isFirable = true;
                        }
                  }
            }
            
            public function isProtected() : Boolean
            {
                  return this.protectedFrames > 0;
            }
            
            public function protect(param1:int) : void
            {
                  this.protectedFrames = param1;
            }
            
            protected function loadDamage(param1:XMLList) : void
            {
                  var _loc2_:Number = Number(param1.damage);
                  this.isArmoured = param1.armoured == "1" ? true : false;
                  this._damageToArmour = _loc2_ + Number(param1.toArmour);
                  this._damageToNotArmour = _loc2_ + Number(param1.toNotArmour);
            }
            
            protected function drawShadow() : void
            {
                  if(this.shadowSprite == null)
                  {
                        this.shadowSprite = new MovieClip();
                        this.addChild(this.shadowSprite);
                        if(this.contains(this.mc))
                        {
                              this.removeChild(this.mc);
                              this.addChild(this.mc);
                        }
                        this.removedSelected();
                  }
            }
            
            public function get isDualing() : Boolean
            {
                  return this._isDualing;
            }
            
            public function set isDualing(param1:Boolean) : void
            {
                  this._isDualing = param1;
            }
            
            public function get syncAttackLabels() : Dictionary
            {
                  return this._syncAttackLabels;
            }
            
            public function set syncAttackLabels(param1:Dictionary) : void
            {
                  this._syncAttackLabels = param1;
            }
            
            public function get syncDefendLabels() : Dictionary
            {
                  return this._syncDefendLabels;
            }
            
            public function set syncDefendLabels(param1:Dictionary) : void
            {
                  this._syncDefendLabels = param1;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  this.setActionInterfaceBase(param1);
            }
            
            protected function setActionInterfaceBase(param1:ActionInterface) : void
            {
                  param1.clear();
                  param1.setAction(2,1,UnitCommand.ATTACK_MOVE);
                  param1.setAction(2,2,UnitCommand.HOLD);
                  param1.setAction(1,2,UnitCommand.STAND);
                  if(this.isGarrisoned)
                  {
                        param1.setAction(0,2,UnitCommand.UNGARRISON);
                  }
                  else
                  {
                        param1.setAction(0,2,UnitCommand.GARRISON);
                  }
            }
            
            protected function initSync() : void
            {
                  var _loc1_:* = null;
                  var _loc2_:String = null;
                  var _loc3_:Array = null;
                  var _loc4_:String = null;
                  this._attackLabels = [];
                  this._deathLabels = [];
                  this._syncDefendLabels = new Dictionary();
                  this._syncAttackLabels = new Dictionary();
                  for(_loc1_ in this.mc.currentLabels)
                  {
                        _loc2_ = FrameLabel(this.mc.currentLabels[_loc1_]).name;
                        _loc3_ = _loc2_.split("_",4);
                        _loc4_ = String(_loc3_[0]);
                        switch(_loc4_)
                        {
                              case "attack":
                                    this._attackLabels.push(_loc3_[1]);
                                    break;
                              case "death":
                                    this._deathLabels.push(_loc3_[1]);
                                    break;
                              case "syncAttack":
                                    this._syncAttackLabels[_loc3_[1]] = [_loc3_[1],_loc3_[2],_loc3_[3]];
                                    break;
                              case "syncDefend":
                                    this._syncDefendLabels[_loc3_[1]] = _loc3_[1];
                                    break;
                        }
                  }
                  this._attackLabels.sort();
                  this._deathLabels.sort();
            }
            
            override public function onMap(param1:StickWar) : Boolean
            {
                  return !param1.fogOfWar.isFogOn || this.team == param1.team || param1.team.getVisionRange() * param1.team.direction > px * param1.team.direction;
            }
            
            override public function onScreen(param1:StickWar) : Boolean
            {
                  if(!param1.fogOfWar.isFogOn)
                  {
                        return true;
                  }
                  if(this.team != param1.team && param1.team.getVisionRange() * param1.team.direction < px * param1.team.direction)
                  {
                        return false;
                  }
                  return px + pwidth / 2 - param1.screenX > 0 && px - pwidth / 2 - param1.screenX < param1.map.screenWidth;
            }
            
            public function isTargetable() : Boolean
            {
                  return !this.isDead && !this.isDieing && px * this.team.direction > this.team.homeX * this.team.direction;
            }
            
            public function isAlive() : Boolean
            {
                  return !this.isDieing && !this.isDead;
            }
            
            public function get mass() : int
            {
                  return this._mass;
            }
            
            public function set mass(param1:int) : void
            {
                  this._mass = param1;
            }
            
            public function init(param1:StickWar) : void
            {
            }
            
            public function attack() : void
            {
            }
            
            public function update(param1:StickWar) : void
            {
            }
            
            public function walk(param1:Number, param2:Number, param3:int) : void
            {
                  if(this.isAbleToWalk())
                  {
                        this.baseWalk(param1,param2,param3);
                  }
            }
            
            public function sqrDistanceToTarget(param1:Unit) : Number
            {
                  if(param1 == null)
                  {
                        return Number.MAX_VALUE;
                  }
                  if(this is RangedUnit)
                  {
                        return Math.pow(param1.px - px,2);
                  }
                  return Math.pow(param1.px - px,2) + Math.pow(param1.py - py,2) * 10;
            }
            
            public function sqrDistanceTo(param1:Unit) : Number
            {
                  if(param1 == null)
                  {
                        return Number.MAX_VALUE;
                  }
                  return Math.pow(param1.px - px,2) + Math.pow(param1.py - py,2);
            }
            
            public function mayAttack(param1:Unit) : Boolean
            {
                  return false;
            }
            
            public function forceFaceDirection(param1:int) : void
            {
                  if(!this.isDualing)
                  {
                        if(Util.sgn(this._mc.scaleX) != Util.sgn(param1))
                        {
                              this._mc.scaleX *= -1;
                              this._lastTurnCount = 0;
                        }
                  }
            }
            
            public function heal(param1:Number, param2:int) : void
            {
                  var _loc3_:Point = null;
                  this._healTimeRemaining = param2;
                  this._healAmount = param1;
                  if(this.health != this.maxHealth && this.team.game.frame - this.lastHealthAnimation > 30)
                  {
                        _loc3_ = this.healthBar.localToGlobal(new Point(0,40));
                        _loc3_ = this.team.game.battlefield.globalToLocal(_loc3_);
                        this.team.game.projectileManager.initHealEffect(x,_loc3_.y,py,this.team,this);
                        this.lastHealthAnimation = this.team.game.frame;
                  }
            }
            
            public function faceDirection(param1:int) : void
            {
                  if(!this.isDualing)
                  {
                        if(Util.sgn(this._mc.scaleX) != Util.sgn(param1))
                        {
                              if(this._lastTurnCount >= this.TURN_AGILITY)
                              {
                                    this._mc.scaleX *= -1;
                                    this._lastTurnCount = 0;
                              }
                        }
                  }
            }
            
            public function isRage() : Boolean
            {
                  return this.rageFramesRemaining > 0;
            }
            
            public function ragee(param1:int) : void
            {
                  if(param1 > this.rageFramesRemaining)
                  {
                        this.rageFramesRemaining = param1;
                  }
            }
            
            public function isSlow() : Boolean
            {
                  return this.slowFramesRemaining > 0;
            }
            
            public function slow(param1:int) : void
            {
                  if(param1 > this.slowFramesRemaining)
                  {
                        this.slowFramesRemaining = param1;
                  }
            }
            
            private function updateStatusPositions() : void
            {
                  var _loc1_:int = 0;
                  if(this.poisonMc)
                  {
                        _loc1_++;
                  }
                  if(this.fireEffectMc)
                  {
                        _loc1_++;
                  }
                  if(this.poisonMc)
                  {
                        this.poisonMc.x = -20 / 2 * (_loc1_ - 1);
                  }
                  if(this.fireEffectMc)
                  {
                        this.fireEffectMc.x = 20 / 2 * (_loc1_ - 1);
                  }
            }
            
            public function updateStatus() : void
            {
                  if(this.freezeCount == 0 && !this.isFreezing)
                  {
                        this.releaseFreezeLock(this.freezeLock);
                  }
                  this.isFreezing = false;
                  if(this.fireDamageFrames > 0)
                  {
                        --this.fireDamageFrames;
                        this.damage(Unit.D_NO_BLOOD | Unit.D_NO_SOUND | Unit.D_FIRE,this.fireDamagePerFrame,null);
                        if(this.fireDamageFrames == 0)
                        {
                              if(this.fireEffectMc != null && this.mc.contains(this.fireEffectMc))
                              {
                                    this.mc.removeChild(this.fireEffectMc);
                                    this.fireEffectMc = null;
                              }
                        }
                  }
                  --this.protectedFrames;
                  if(this.stunMc)
                  {
                        Util.animateMovieClipBasic(this.stunMc);
                        if(this.stunTimeLeft <= 0)
                        {
                              if(this.stunMc && this.mc.contains(this.stunMc))
                              {
                                    this.mc.removeChild(this.stunMc);
                              }
                        }
                  }
                  this.updateStatusPositions();
                  if(this.reaperCurseFrames > 0)
                  {
                        this.walk(this.team.direction,0,this.team.direction);
                        --this.reaperCurseFrames;
                        if(this.reaperMc.currentFrame == this.reaperMc.totalFrames)
                        {
                              this.reaperMc.gotoAndStop(1);
                        }
                        else
                        {
                              this.reaperMc.nextFrame();
                        }
                        if(this.reaperCurseFrames == 0)
                        {
                              if(this.reaperMc && this.mc.contains(this.reaperMc))
                              {
                                    this.mc.removeChild(this.reaperMc);
                              }
                              this.reaperMc = null;
                        }
                  }
                  if(this._healTimeRemaining > 0)
                  {
                        this.health += this._healAmount;
                        if(this.health > this.maxHealth)
                        {
                              this.health = this.maxHealth;
                        }
                        --this._healTimeRemaining;
                  }
                  if(this._health + this.chaosHealRate <= this.maxHealth && this.team.type == Team.T_CHAOS)
                  {
                        this._health += this.chaosHealRate;
                  }
                  if(this.slowFramesRemaining)
                  {
                        --this.slowFramesRemaining;
                  }
                  if(this.rageFramesRemaining)
                  {
                        --this.rageFramesRemaining;
                  }
                  ++this._timeOfDeath;
                  this.healthBar.health = this.health;
                  this.healthBar.update();
                  if((this.isDead || this.isDieing) && !this.isDualing)
                  {
                        selected = false;
                        if(this.mc.mc)
                        {
                              this.mc.mc.filters = [];
                        }
                        if(this.mc.contains(this.healthBar))
                        {
                              this.mc.removeChild(this.healthBar);
                              if(this.isPoisoned())
                              {
                                    if(this.team.enemyTeam.tech.isResearched(Tech.DEAD_POISON) && !this.team.isEnemy)
                                    {
                                          this.deadRespawn = Dead(this.team.game.unitFactory.getUnit(Unit.U_DEAD));
                                          this.team.enemyTeam.spawn(this.deadRespawn,this.team.game);
                                          this.deadRespawn.px = this.px;
                                          this.deadRespawn.py = this.py;
                                          this.deadRespawn.ai.setCommand(this.team.game,new StandCommand(this.team.game));
                                    }
                                    if(this.currentLevelTitle != "Magic in the Air: Wizards and monks Declare War" && this.currentLevelTitle != "Rebels United" && this.currentLevelTitle != "Silent Assassins: Ninjas Declare War")
                                    {
                                          if(this.team.type == Team.T_ORDER && this.team.enemyTeam.type == Team.T_CHAOS)
                                          {
                                          }
                                    }
                              }
                        }
                  }
                  else
                  {
                        if(this.isDualing)
                        {
                              if(this.mc.contains(this.healthBar))
                              {
                                    this.mc.removeChild(this.healthBar);
                              }
                        }
                        else if(!this.mc.contains(this.healthBar))
                        {
                              this.mc.addChild(this.healthBar);
                        }
                        this.updateSelected();
                  }
                  ++this.framesPoisoned;
                  if(this.team.type == Team.T_CHAOS && this.framesPoisoned > this.chaosPoisonedFrames)
                  {
                        this.cure();
                  }
            }
            
            protected function updateCommon(param1:StickWar) : void
            {
                  this.updateStatus();
                  var _loc2_:ColorTransform = this.mc.transform.colorTransform;
                  if(this.isTowerSpawned)
                  {
                        if(this.team.type == Team.T_GOOD)
                        {
                              if(this.team.isEnemy)
                              {
                                    _loc2_.blueOffset = 0;
                                    _loc2_.greenOffset = 0;
                                    _loc2_.redOffset = 140;
                                    this.mc.mc.filters = [this.enemyTowerSpawnGlow];
                              }
                              else
                              {
                                    _loc2_.blueOffset = 70;
                                    _loc2_.greenOffset = 40;
                                    _loc2_.redOffset = 0;
                                    this.mc.mc.filters = [this.towerSpawnGlow];
                              }
                        }
                        else if(this.team.type == Team.T_CHAOS)
                        {
                              _loc2_.blueOffset = 0;
                              _loc2_.greenOffset = 60;
                              _loc2_.redOffset = 0;
                              this.mc.mc.filters = [this.towerSpawnGlowChaos];
                        }
                        if(param1.frame % 60 == 0 && this.isAlive())
                        {
                              param1.projectileManager.initSpawnDrip(px,py,this.team);
                        }
                  }
                  else if(this.isSwitched)
                  {
                        _loc2_.redMultiplier = 0;
                        _loc2_.blueMultiplier = 0;
                        _loc2_.greenMultiplier = 0;
                        _loc2_.redOffset = 0;
                        _loc2_.blueOffset = 0;
                        _loc2_.greenOffset = 0;
                  }
                  else
                  {
                        _loc2_.greenOffset = 0;
                        _loc2_.blueOffset = 0;
                        if(this.team == param1.team.enemyTeam || this.rebelsAreEvil == true)
                        {
                              _loc2_.redOffset = 75;
                        }
                        else
                        {
                              _loc2_.redOffset = 0;
                        }
                        this.mc.mc.filters = [];
                  }
                  if(this.isAlive() && param1.frame % 90 == 0 && this._poisonDamage > 0)
                  {
                        this.damage(D_NO_SOUND,this._poisonDamage,null);
                        _loc2_.greenOffset = 55;
                  }
                  if(this.isAlive() && this.slowFramesRemaining > 0)
                  {
                        _loc2_.blueOffset = 255;
                        _loc2_.greenOffset = 255;
                  }
                  if(this.isAlive() && this.rageFramesRemaining > 0)
                  {
                        this.mc.mc.filters = [this.enemyTowerSpawnGlow];
                  }
                  else
                  {
                        this.mc.mc.filters = [];
                  }
                  if(this.iceUnit == true)
                  {
                        _loc2_.blueOffset = 255;
                        _loc2_.greenOffset = 255;
                  }
                  else if(this.isSwitched)
                  {
                  }
                  this.mc.transform.colorTransform = _loc2_;
                  if(this.isProtected())
                  {
                        this.protectFilter.strength = 2 + Math.sin(this.team.game.frame / 30 * Math.PI);
                        this.mc.mc.filters = [this.protectFilter];
                  }
                  if(this.isHome && this.team.direction * px > this.team.direction * (this.team.homeX + this.team.direction * 1200))
                  {
                        this.isHome = false;
                  }
                  else if(!this.isHome && this.team.direction * px < this.team.direction * (this.team.homeX + this.team.direction * 600))
                  {
                        this.isHome = true;
                  }
                  if(this.team.direction * px < this.team.direction * (this.team.homeX - this.team.direction * 25))
                  {
                        this.cure();
                        this.heal(this.garrisonHealRate,1);
                  }
                  if(this.poisonDamage == 0)
                  {
                        if(this.poisonMc && this.mc.contains(this.poisonMc))
                        {
                              this.mc.removeChild(this.poisonMc);
                        }
                  }
                  if(this.team.game.frame > this.lastWalkFrame + 1)
                  {
                        this._ddx = 0;
                        this._ddy = 0;
                  }
            }
            
            public function updateSelected() : void
            {
                  if(mouseIsOver && this.isAlive())
                  {
                        this.drawSelected(65280,this.isBusy() ? Number(3) : Number(1),this.isBusy() ? 255 : 65280);
                  }
                  else if(selected && this.isInteractable && this.isAlive())
                  {
                        this.drawSelected(16777215,this.isBusy() ? Number(3) : Number(1),this.isBusy() ? 255 : 16777215);
                  }
                  else
                  {
                        this.removedSelected();
                  }
                  if(this.shadowSprite != null)
                  {
                        this.shadowSprite.scaleX = this._mc.scaleX;
                        this.shadowSprite.scaleY = this._mc.scaleY;
                  }
            }
            
            protected function removedSelected() : void
            {
                  if(this.shadowSprite == null)
                  {
                        return;
                  }
                  this.shadowSprite.graphics.clear();
                  this.shadowSprite.graphics.lineStyle(this.isBusy() ? Number(3) : Number(1),this.isBusy() ? uint(255) : uint(0),this.isBusy() ? Number(1) : Number(0));
                  if(this.isAlive())
                  {
                        this.shadowSprite.graphics.beginFill(0,0.2);
                  }
                  else
                  {
                        this.shadowSprite.graphics.beginFill(0,0);
                  }
                  this.shadowSprite.graphics.drawEllipse(-40,this.flyingHeight - 4.5,80,15);
            }
            
            protected function drawSelected(param1:int, param2:Number, param3:int) : void
            {
                  if(this.shadowSprite == null)
                  {
                        return;
                  }
                  this.shadowSprite.graphics.clear();
                  this.shadowSprite.graphics.lineStyle(param2,param3,1);
                  this.shadowSprite.graphics.beginFill(param1,0.3);
                  this.shadowSprite.graphics.drawEllipse(-40,this.flyingHeight - 4.5,80,15);
            }
            
            public function setFire(param1:int, param2:Number) : void
            {
                  var _loc3_:ColorTransform = null;
                  if(!this.isAlive())
                  {
                        return;
                  }
                  if(param2 == 0)
                  {
                        return;
                  }
                  if(this.fireDamagePerFrame < param2 || this.fireDamageFrames < param1)
                  {
                        this.fireDamageFrames = param1;
                        this.fireDamagePerFrame = param2;
                        if(this.fireEffectMc && this.mc.contains(this.fireEffectMc))
                        {
                              this.mc.removeChild(this.fireEffectMc);
                        }
                        this.fireEffectMc = new flameStatusEffectMc();
                        _loc3_ = this.fireEffectMc.transform.colorTransform;
                        _loc3_.redOffset += 200;
                        this.fireEffectMc.transform.colorTransform = _loc3_;
                        this.mc.addChild(this.fireEffectMc);
                        this.fireEffectMc.x = 0;
                        this.fireEffectMc.y = this.healthBar.y - 20;
                  }
            }
            
            public function poison(param1:Number) : Boolean
            {
                  if(!this.isAlive())
                  {
                        return false;
                  }
                  this.framesPoisoned = 0;
                  if(param1 > this._poisonDamage)
                  {
                        if(this.poisonMc && this.mc.contains(this.poisonMc))
                        {
                              this.mc.removeChild(this.poisonMc);
                        }
                        this.poisonMc = new poisonEffect();
                        this.mc.addChild(this.poisonMc);
                        this.team.game.soundManager.playSound("PoisonedSound",px,py);
                        this.poisonMc.x = 0;
                        this.poisonMc.y = this.healthBar.y - 20;
                        this._poisonDamage = param1;
                        if(this._poisonDamage > 0)
                        {
                              this.team.poisonedUnits[this.id] = this;
                        }
                        return true;
                  }
                  return false;
            }
            
            public function cure() : void
            {
                  var _loc1_:Point = null;
                  if(this.poisonDamage != 0)
                  {
                        _loc1_ = this.healthBar.localToGlobal(new Point(0,-40));
                        _loc1_ = this.team.game.battlefield.globalToLocal(_loc1_);
                        this.team.game.projectileManager.initHealEffect(x,_loc1_.y,py,this.team,this,true);
                        this.lastHealthAnimation = this.team.game.frame;
                  }
                  this._poisonDamage = 0;
                  if(this.id in this.team.poisonedUnits)
                  {
                        delete this.team.poisonedUnits[this.id];
                  }
            }
            
            public function isFlying() : Boolean
            {
                  return this.flyingHeight != 0;
            }
            
            protected function updateMotion(param1:StickWar) : void
            {
                  var _loc4_:Wall = null;
                  ++this._lastTurnCount;
                  if(this._stunTimeLeft > 0)
                  {
                        --this._stunTimeLeft;
                  }
                  if(this.isDualing == true)
                  {
                        return;
                  }
                  this._perspectiveScale = this._scale * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  this._mc.scaleX = Util.sgn(this._mc.scaleX) * this._perspectiveScale;
                  this._mc.scaleY = this._perspectiveScale;
                  pz = (-this.flyingHeight + this.dzOffset) * this._perspectiveScale;
                  if(param1.random.nextNumber() > 0.4 && this.mayWalkThrough == false)
                  {
                        if(this.stunTimeLeft == 0)
                        {
                              param1.spatialHash.mapInArea(px - width / 2,py - height / 2,px + width / 2,py + height / 2,this.checkCollision,false);
                        }
                  }
                  if(this.stunTimeLeft != 0)
                  {
                        if(Math.abs(this._dz) < 0.1)
                        {
                              this._dx *= 0.7;
                              this._dy *= 0.7;
                        }
                  }
                  else
                  {
                        this._dx *= this._dragForce;
                        this._dy *= this._dragForce;
                  }
                  if(this.stunTimeLeft == 0)
                  {
                        if(Math.abs(this._dx) > this._maxVelocity)
                        {
                              this._dx = this._maxVelocity * Math.abs(this._dx) / this._dx;
                        }
                        if(Math.abs(this._dy) > this._maxVelocity / 2)
                        {
                              this._dy = this._maxVelocity / 2 * Math.abs(this._dy) / this._dy;
                        }
                  }
                  else
                  {
                        if(Math.abs(this._dx) > 8 * this._maxVelocity)
                        {
                              this._dx = 8 * this._maxVelocity * Math.abs(this._dx) / this._dx;
                        }
                        if(Math.abs(this._dy) > 8 * this._maxVelocity / 2)
                        {
                              this._dy = 8 * this._maxVelocity / 2 * Math.abs(this._dy) / this._dy;
                        }
                  }
                  var _loc2_:int = 200;
                  if(!this.isGarrisoned)
                  {
                        if(px + this._dx <= param1.map.screenWidth + _loc2_ && this._dx < 0)
                        {
                              this._dx = 0;
                        }
                        if(px + this._dx >= param1.background.mapLength - param1.map.screenWidth - _loc2_ && this._dx > 0)
                        {
                              this._dx = 0;
                        }
                        if(!(this.ai.currentCommand is HoldCommand))
                        {
                              if(px + this._dx <= param1.map.screenWidth + _loc2_)
                              {
                                    this.walk(1,0,1);
                              }
                              if(px + this._dx >= param1.background.mapLength - param1.map.screenWidth - _loc2_)
                              {
                                    this.walk(-1,0,-1);
                              }
                        }
                  }
                  else
                  {
                        if(px + this._dx < 0 && this._dx < 0)
                        {
                              this._dx = 0;
                        }
                        if(px + this._dx > param1.background.mapLength && this._dx > 0)
                        {
                              this._dx = 0;
                        }
                  }
                  if(py + this._dy < 0 || py + this._dy > param1.map.height)
                  {
                        this._dy = 0;
                  }
                  if(this.isStationary)
                  {
                        this._dx = this._dy = 0;
                  }
                  px += this._dx;
                  py += this._dy;
                  for each(_loc4_ in this.team.enemyTeam.walls)
                  {
                        if(px < _loc4_.px + 7.5 && px > _loc4_.px - 7.5)
                        {
                              px = _loc4_.px - 7.5 * this.team.direction;
                        }
                  }
                  if(px < 0 + 7.5)
                  {
                        px = 7.5;
                  }
                  else if(px > param1.map.width - 7.5)
                  {
                        px = param1.map.width - 7.5;
                  }
                  this.applyZMotionUpdates();
                  x = px;
                  y = py + pz;
            }
            
            public function applyZMotionUpdates() : void
            {
                  this._dz += StickWar.GRAVITY * 1.5;
                  this.dzOffset += this._dz;
                  if(this.dzOffset >= 0)
                  {
                        this.dzOffset = 0;
                        this._dz = 0;
                  }
                  ++this.timeAlive;
            }
            
            protected function checkCollision(param1:Unit) : void
            {
                  var _loc2_:Number = NaN;
                  var _loc3_:int = 0;
                  var _loc4_:int = 0;
                  var _loc5_:* = false;
                  var _loc6_:* = false;
                  var _loc7_:Number = NaN;
                  var _loc8_:Number = NaN;
                  if(param1 == this || param1.pz != 0 || this.type == Unit.U_WATER_ELEMENT)
                  {
                        return;
                  }
                  if(param1._isGarrisoned || this._isGarrisoned)
                  {
                        return;
                  }
                  if(param1 is Unit)
                  {
                        param1 = Unit(param1);
                        if((!param1.mayWalkThrough || param1.type == Unit.U_TREE_ELEMENT && type == Unit.U_TREE_ELEMENT) && param1.stunTimeLeft == 0 && param1.isCollision(this,this.dx,this.dy))
                        {
                              _loc2_ = 0.15;
                              _loc3_ = this.ai.currentCommand.type;
                              _loc4_ = param1.ai.currentCommand.type;
                              _loc5_ = _loc3_ == UnitCommand.STAND;
                              _loc6_ = _loc4_ == UnitCommand.STAND;
                              _loc7_ = (param1.hitBoxWidth * param1.perspectiveScale + this.hitBoxWidth * this.perspectiveScale) / 2;
                              if((_loc8_ = Math.abs(px - param1.px) / _loc7_) <= 1)
                              {
                                    if(px == param1.px)
                                    {
                                          px = param1.px + this.team.game.random.nextNumber() - 0.5;
                                    }
                                    if(px != param1.px)
                                    {
                                          if(Util.sgn(this._dx) != -Util.sgn(param1.dx) || this.team != param1.team)
                                          {
                                                if(Math.abs(this.dx) < 1 && Math.abs(param1.dx) < 1 || param1.isMiner() && this.isMiner())
                                                {
                                                      this.nudgeFrame = this.team.game.frame;
                                                      if(this.mass < param1.mass || _loc5_)
                                                      {
                                                            this._dx += (1 - _loc8_) * Util.sgn(px - param1.px) * 0.51;
                                                      }
                                                      if(this.mass >= param1.mass || _loc6_)
                                                      {
                                                            param1._dx += (1 - _loc8_) * Util.sgn(param1.px - px) * 0.51;
                                                      }
                                                }
                                          }
                                    }
                              }
                              _loc7_ = (param1.hitBoxWidth * param1.perspectiveScale + this.hitBoxWidth * this.perspectiveScale) / 2;
                              if((_loc8_ = Math.abs(py - param1.py) / _loc7_) <= 1)
                              {
                                    if(py == param1.py)
                                    {
                                          py = param1.py + this.team.game.random.nextNumber() - 0.5;
                                    }
                                    if(py != param1.py)
                                    {
                                          if(Util.sgn(this._dy) != -Util.sgn(param1.dy) && this.team == param1.team)
                                          {
                                                this.nudgeFrame = this.team.game.frame;
                                                if(Math.abs(this.dy) < 1 && Math.abs(param1.dy) < 1 || param1.isMiner() && this.isMiner())
                                                {
                                                      if(this.mass < param1.mass || _loc5_)
                                                      {
                                                            this._dy += (1 - _loc8_) * Util.sgn(py - param1.py) * 0.51;
                                                      }
                                                      if(this.mass >= param1.mass || _loc6_)
                                                      {
                                                            param1._dy += (1 - _loc8_) * Util.sgn(param1.py - py) * 0.51;
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
            
            public function isMiner() : Boolean
            {
                  return type == this.team.getMinerType();
            }
            
            public function isFeetMoving() : Boolean
            {
                  if(!isGarrisoned)
                  {
                        return Math.abs(this._ddy) > 0.03 || Math.abs(this._ddx) > 0.03;
                  }
                  return Math.abs(this._dx) + Math.abs(this._dy) > 1;
            }
            
            public function stun(param1:int, param2:Number = 1) : void
            {
                  if(!this.isAlive())
                  {
                        return;
                  }
                  if(param1 > 0)
                  {
                        if(this.dzOffset == 0)
                        {
                              this._dz = -Unit.stunUpForce * param2 * 2;
                        }
                        this.stunTimeLeft = param1;
                        if(this.stunMc && this.mc.contains(this.stunMc))
                        {
                              this.mc.removeChild(this.stunMc);
                        }
                        this.mc.addChild(this.stunMc = new dizzyMc());
                        this.stunMc.y = this.healthBar.y - 20;
                        this.stunMc.x = 0;
                        this.stunMc.scaleX = 0.4;
                        this.stunMc.scaleY = 0.4;
                  }
            }
            
            public function releaseFreezeLock(param1:Unit) : void
            {
                  if(this.freezeLock == param1)
                  {
                        this.freezeLock = null;
                  }
            }
            
            public function isStatue() : Boolean
            {
                  return type == Unit.U_STATUE || type == Unit.U_CHAOS_TOWER;
            }
            
            public function freeze(param1:int) : void
            {
                  this.freezeCount = param1;
            }
            
            public function aquireFreezeLock(param1:Unit) : Boolean
            {
                  if(this.freezeLock == param1)
                  {
                        return true;
                  }
                  if(this.freezeLock == null)
                  {
                        this.freezeLock = param1;
                        return true;
                  }
                  return false;
            }
            
            public function isFreezeLocked(param1:Unit) : Boolean
            {
                  return this.freezeLock != null && this.freezeLock != param1;
            }
            
            public function isFrozen() : Boolean
            {
                  return this.freezeCount > 0;
            }
            
            private function setVector(param1:Number, param2:Number, param3:Vector3D) : void
            {
                  param3.x = param1;
                  param3.y = param2;
                  param3.z = 0;
                  param3.w = 0;
            }
            
            protected function fractionOfCollision(param1:Unit, param2:int, param3:int) : Number
            {
                  return (Math.pow(param1.px + param1.dx - param2 - px,2) + Math.pow(param1.py + param1.dy - param3 - py,2)) / Math.pow(param1.hitBoxWidth * (this.perspectiveScale + param1.perspectiveScale) / 2,2);
            }
            
            protected function isCollision(param1:Unit, param2:int, param3:int) : Boolean
            {
                  if(Math.pow(param1.px + param1.dx - param2 - px,2) + Math.pow(param1.py + param1.dy - param3 - py,2) < Math.pow(param1.hitBoxWidth * (this.perspectiveScale + param1.perspectiveScale) / 2,2))
                  {
                        return true;
                  }
                  return false;
            }
            
            protected function checkForHit() : Boolean
            {
                  var _loc1_:Unit = this.ai.getClosestTarget();
                  if(_loc1_ == null)
                  {
                        return false;
                  }
                  var _loc2_:int = Util.sgn(_loc1_.px - px);
                  if(this._mc.mc.tip == null)
                  {
                        return false;
                  }
                  var _loc3_:Point = MovieClip(this._mc.mc.tip).localToGlobal(new Point(0,0));
                  if(_loc1_.checkForHitPoint(_loc3_,_loc1_))
                  {
                        _loc1_.damage(0,this.damageToDeal,this);
                        if(this.vampUnit)
                        {
                              this.heal(this.damageToDeal / 4,1);
                        }
                        return true;
                  }
                  return false;
            }
            
            public function checkForHitPoint(param1:Point, param2:Unit) : Boolean
            {
                  if(param2 == null)
                  {
                        return false;
                  }
                  var _loc3_:int = Util.sgn(param2.px - px);
                  param1 = this.globalToLocal(param1);
                  if(param1.x > -pwidth && param1.x < pwidth && param1.y > -pheight && param1.y < pheight)
                  {
                        return true;
                  }
                  return false;
            }
            
            public function checkForHitPointArrow(param1:Point, param2:Number, param3:Unit) : Boolean
            {
                  if(param3 == null)
                  {
                        return false;
                  }
                  param1 = this.globalToLocal(param1);
                  if(this == param3)
                  {
                        if(param1.x > -pwidth && param1.x < pwidth && param1.y > -pheight && param1.y < 0 && Math.abs(param2 - this.py) < 300)
                        {
                              return true;
                        }
                  }
                  else if(param1.x > -pwidth && param1.x < pwidth && param1.y > -pheight * 0.8 && param1.y < 0 && Math.abs(param2 - this.py) < 200 * 0.8)
                  {
                        return true;
                  }
                  return false;
            }
            
            override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
            {
                  var _loc5_:Number = NaN;
                  if(this.isTargetable() && !this.isDualing)
                  {
                        if(!(Unit.D_NO_SOUND & param1))
                        {
                              if(this.isArmoured)
                              {
                                    this.team.game.soundManager.playSoundRandom("hitOnArmour",7,px,py);
                              }
                              else
                              {
                                    this.team.game.soundManager.playSoundRandom("hitOnFlesh",12,px,py);
                              }
                        }
                        _loc5_ = 0;
                        if(param3 != null)
                        {
                              _loc5_ = param3.getDamageToUnit(this) * param4;
                        }
                        else
                        {
                              _loc5_ = param2 * param4;
                        }
                        if(this.isProtected())
                        {
                              trace("take reduced damage protected");
                              _loc5_ *= 0.35;
                        }
                        if(!(Unit.D_NO_BLOOD & param1))
                        {
                              this.team.game.bloodManager.addBlood(px,py,-this.team.direction,this.team.game);
                        }
                        if(this.reaperCurseFrames > 0)
                        {
                              _loc5_ *= 1 + this.reaperAmplification;
                        }
                        _loc5_ = (_loc5_ /= this.team.healthModifier) * this.team.enemyTeam.damageModifier;
                        this._health -= _loc5_;
                        if(this._health <= 0)
                        {
                              this.arrowDeath = false;
                              if(!(Unit.D_NO_SOUND & param1))
                              {
                                    this.playDeathSound();
                              }
                              if(param1 & D_FIRE && this.isFirable)
                              {
                                    this.isOnFire = true;
                              }
                              else if(param1 & Unit.D_ARROW)
                              {
                                    this.arrowDeath = true;
                                    if(param3)
                                    {
                                          this.forceFaceDirection(Util.sgn(param3.px - px));
                                    }
                              }
                              this.kill();
                        }
                  }
            }
            
            public function kill() : void
            {
                  this.isDieing = true;
                  this.cleanUpStats();
                  this._timeOfDeath = 0;
                  this._health = 0;
                  if(this.shadowSprite != null && this.contains(this.shadowSprite))
                  {
                        this.removeChild(this.shadowSprite);
                  }
                  this.shadowSprite = null;
                  this.healthBar.health = 0;
                  this.healthBar.update();
            }
            
            private function cleanUpStats() : void
            {
                  if(this.reaperMc && this.mc.contains(this.reaperMc))
                  {
                        this.mc.removeChild(this.reaperMc);
                  }
                  if(this.poisonMc && this.mc.contains(this.poisonMc))
                  {
                        this.mc.removeChild(this.poisonMc);
                  }
                  if(this.stunMc && this.mc.contains(this.stunMc))
                  {
                        this.mc.removeChild(this.stunMc);
                  }
                  if(this.fireEffectMc && this.mc.contains(this.fireEffectMc))
                  {
                        this.mc.removeChild(this.fireEffectMc);
                  }
            }
            
            public function playDeathSound() : void
            {
                  this.team.game.soundManager.playSoundRandom("Pain",8,px,py);
            }
            
            public function startDual(param1:Unit) : Boolean
            {
                  if(!this.team.isMember)
                  {
                        return false;
                  }
                  if(!this.isTargetable())
                  {
                        return false;
                  }
                  var _loc2_:Array = this.team.game.dualFactory.getDuals(this.type,param1.type);
                  if(_loc2_ == null)
                  {
                        return false;
                  }
                  var _loc3_:int = this.team.game.random.nextInt();
                  this._currentDual = _loc2_[_loc3_ % _loc2_.length];
                  param1._currentDual = _loc2_[_loc3_ % _loc2_.length];
                  this._isDualing = true;
                  param1._isDualing = true;
                  param1._health = 0;
                  param1.isDieing = true;
                  param1.timeOfDeath = 0;
                  this._dualPartner = param1;
                  param1._dualPartner = this;
                  param1.cleanUpStats();
                  return true;
            }
            
            protected function getDeathLabel(param1:StickWar) : String
            {
                  if(this.isOnFire)
                  {
                        return "fireDeath";
                  }
                  if(this.stoned)
                  {
                        return "stone";
                  }
                  var _loc2_:int = this.team.game.random.nextInt() % this._deathLabels.length;
                  return "death_" + this._deathLabels[_loc2_];
            }
            
            public function stoneAttack(param1:int) : void
            {
                  var _loc2_:Array = this._mc.currentLabels;
                  if(this.isStoneable)
                  {
                        this.damage(0,this._health * 2,null);
                        this.stoned = true;
                  }
                  else
                  {
                        this.damage(0,param1,null);
                  }
            }
            
            public function garrison() : void
            {
                  this.isGarrisoned = true;
                  this.team.garrisonedUnits[this.id] = this;
            }
            
            public function ungarrison() : void
            {
                  if(this.id in this.team.garrisonedUnits)
                  {
                        delete this.team.garrisonedUnits[this.id];
                  }
                  this.isGarrisoned = false;
            }
            
            public function damageWillKill(param1:int, param2:int) : Boolean
            {
                  if(this._health - param2 <= 0)
                  {
                        return true;
                  }
                  return false;
            }
            
            protected function isAbleToWalk() : Boolean
            {
                  return this._state == S_RUN;
            }
            
            public function isBusy() : Boolean
            {
                  return false;
            }
            
            public function stateFixForCutToWalk() : void
            {
                  this._state = S_RUN;
                  this.hasHit = true;
            }
            
            protected function baseWalk(param1:Number, param2:Number, param3:int) : void
            {
                  if(!this.isAbleToWalk() || this.stunTimeLeft != 0)
                  {
                        return;
                  }
                  this.lastWalkFrame = this.team.game.frame;
                  if(param1 > 1)
                  {
                        param1 = 1;
                  }
                  else if(param1 < -1)
                  {
                        param1 = -1;
                  }
                  if(param2 > 1)
                  {
                        param2 = 1;
                  }
                  else if(param2 < -1)
                  {
                        param2 = -1;
                  }
                  var _loc4_:Number = param1 * this._maxForce / this._mass * this._worldScaleX;
                  var _loc5_:Number = param2 * this._maxForce / this._mass * this._worldScaleY;
                  this._ddx = _loc4_;
                  this._ddy = _loc5_;
                  this._state = S_RUN;
                  if(Math.abs(this.dx) > 2 * this._maxVelocity / 5 && this.team.game.frame - this.nudgeFrame > 15)
                  {
                        this.faceDirection(Util.sgn(this.dx));
                  }
                  else
                  {
                        this.faceDirection(Util.sgn(param3));
                  }
                  this._dx += _loc4_;
                  this._dy += _loc5_;
            }
            
            public function applyVelocity(param1:Number, param2:Number = 0, param3:Number = 0) : void
            {
                  this.nudgeFrame = this.team.game.frame;
                  this._dx = param1;
                  this._dy = param2;
            }
            
            public function getDirection() : int
            {
                  return Util.sgn(this._mc.scaleX);
            }
            
            public function get mc() : MovieClip
            {
                  return this._mc;
            }
            
            public function set mc(param1:MovieClip) : void
            {
                  this._mc = param1;
            }
            
            public function get ai() : UnitAi
            {
                  return this._ai;
            }
            
            public function set ai(param1:UnitAi) : void
            {
                  this._ai = param1;
            }
            
            public function get team() : Team
            {
                  return this._team;
            }
            
            public function set team(param1:Team) : void
            {
                  this._team = param1;
            }
            
            public function get hitBoxWidth() : int
            {
                  return this._hitBoxWidth;
            }
            
            public function set hitBoxWidth(param1:int) : void
            {
                  this._hitBoxWidth = param1;
            }
            
            public function get timeOfDeath() : Number
            {
                  return this._timeOfDeath;
            }
            
            public function set timeOfDeath(param1:Number) : void
            {
                  this._timeOfDeath = param1;
            }
            
            public function get perspectiveScale() : Number
            {
                  return this._perspectiveScale;
            }
            
            public function set perspectiveScale(param1:Number) : void
            {
                  this._perspectiveScale = param1;
            }
            
            public function get dx() : Number
            {
                  return this._dx;
            }
            
            public function set dx(param1:Number) : void
            {
                  this._dx = param1;
            }
            
            public function get dy() : Number
            {
                  return this._dy;
            }
            
            public function set dy(param1:Number) : void
            {
                  this._dy = param1;
            }
            
            public function get health() : Number
            {
                  return this._health;
            }
            
            public function set health(param1:Number) : void
            {
                  this._health = param1;
            }
            
            public function get population() : int
            {
                  return this._population;
            }
            
            public function set population(param1:int) : void
            {
                  this._population = param1;
            }
            
            public function get damageToDeal() : Number
            {
                  return this._damageToDeal;
            }
            
            public function set damageToDeal(param1:Number) : void
            {
                  this._damageToDeal = param1;
            }
            
            public function get healthBar() : HealthBar
            {
                  return this._healthBar;
            }
            
            public function set healthBar(param1:HealthBar) : void
            {
                  this._healthBar = param1;
            }
            
            public function get mayWalkThrough() : Boolean
            {
                  return this._mayWalkThrough;
            }
            
            public function set mayWalkThrough(param1:Boolean) : void
            {
                  this._mayWalkThrough = param1;
            }
            
            public function get isDead() : Boolean
            {
                  return this._isDead;
            }
            
            public function set isDead(param1:Boolean) : void
            {
                  this._isDead = param1;
            }
            
            public function get stunTimeLeft() : int
            {
                  return this._stunTimeLeft;
            }
            
            public function set stunTimeLeft(param1:int) : void
            {
                  this._stunTimeLeft = param1;
            }
            
            public function get createTime() : int
            {
                  return this._createTime;
            }
            
            public function set createTime(param1:int) : void
            {
                  this._createTime = param1;
            }
            
            public function get building() : Building
            {
                  return this._building;
            }
            
            public function set building(param1:Building) : void
            {
                  this._building = param1;
            }
            
            public function get isStationary() : Boolean
            {
                  return this._isStationary;
            }
            
            public function set isStationary(param1:Boolean) : void
            {
                  this._isStationary = param1;
            }
            
            public function get isBusyForSpell() : Boolean
            {
                  return this._isBusyForSpell;
            }
            
            public function set isBusyForSpell(param1:Boolean) : void
            {
                  this._isBusyForSpell = param1;
            }
            
            public function get flyingHeight() : Number
            {
                  return this._flyingHeight;
            }
            
            public function set flyingHeight(param1:Number) : void
            {
                  this._flyingHeight = param1;
            }
            
            public function get interactsWith() : int
            {
                  return this._interactsWith;
            }
            
            public function set interactsWith(param1:int) : void
            {
                  this._interactsWith = param1;
            }
            
            public function get maxHealth() : int
            {
                  return this._maxHealth;
            }
            
            public function set maxHealth(param1:int) : void
            {
                  this._maxHealth = param1;
            }
            
            public function get reaperCurseFrames() : int
            {
                  return this._reaperCurseFrames;
            }
            
            public function set reaperCurseFrames(param1:int) : void
            {
                  this._reaperCurseFrames = param1;
            }
            
            public function get shadowSprite() : MovieClip
            {
                  return this._shadowSprite;
            }
            
            public function set shadowSprite(param1:MovieClip) : void
            {
                  this._shadowSprite = param1;
            }
            
            public function get poisonDamage() : Number
            {
                  return this._poisonDamage;
            }
            
            public function set poisonDamage(param1:Number) : void
            {
                  this._poisonDamage = param1;
            }
            
            public function get isDieing() : Boolean
            {
                  return this._isDieing;
            }
            
            public function set isDieing(param1:Boolean) : void
            {
                  this._isDieing = param1;
            }
            
            public function get dz() : Number
            {
                  return this._dz;
            }
            
            public function set dz(param1:Number) : void
            {
                  this._dz = param1;
            }
            
            public function get isFirable() : Boolean
            {
                  return this._isFirable;
            }
            
            public function set isFirable(param1:Boolean) : void
            {
                  this._isFirable = param1;
            }
            
            public function get isOnFire() : Boolean
            {
                  return this._isOnFire;
            }
            
            public function set isOnFire(param1:Boolean) : void
            {
                  this._isOnFire = param1;
            }
            
            public function get scale() : Number
            {
                  return this._scale;
            }
            
            public function set scale(param1:Number) : void
            {
                  this._scale = param1;
            }
            
            public function get isRejoiningFormation() : Boolean
            {
                  return this._isRejoiningFormation;
            }
            
            public function set isRejoiningFormation(param1:Boolean) : void
            {
                  this._isRejoiningFormation = param1;
            }
            
            public function get isTowerSpawned() : Boolean
            {
                  return this._isTowerSpawned;
            }
            
            public function set isTowerSpawned(param1:Boolean) : void
            {
                  this._isTowerSpawned = param1;
            }
            
            public function get arrowDeath() : Boolean
            {
                  return this._arrowDeath;
            }
            
            public function set arrowDeath(param1:Boolean) : void
            {
                  this._arrowDeath = param1;
            }
            
            public function get stoned() : Boolean
            {
                  return this._stoned;
            }
            
            public function set stoned(param1:Boolean) : void
            {
                  this._stoned = param1;
            }
            
            public function get hasDefaultLoadout() : Boolean
            {
                  return this._hasDefaultLoadout;
            }
            
            public function set hasDefaultLoadout(param1:Boolean) : void
            {
                  this._hasDefaultLoadout = param1;
            }
            
            public function get techTeam() : Team
            {
                  if(this.isSwitched)
                  {
                        return this.team.enemyTeam;
                  }
                  return this.team;
            }
      }
}
