package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.game.Pool;
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.geom.*;
      
      public class UnitCommand
      {
            
            public static const NO_COMMAND:int = 0;
            
            public static const ATTACK:int = 1;
            
            public static const ATTACK_MOVE:int = 2;
            
            public static const MOVE:int = 3;
            
            public static const STAND:int = 4;
            
            public static const SPELL:int = 5;
            
            public static const MINE:int = 6;
            
            public static const HOLD:int = 7;
            
            public static const GARRISON:int = 8;
            
            public static const UNGARRISON:int = 9;
            
            public static const TECH:int = 10;
            
            public static const COMBINE:int = 11;
            
            public static const COMBINE_ALL:int = 12;
            
            public static const ARCHER_HARD_SHOT:int = 20;
            
            public static const SWORDWRATH_RAGE:int = 21;
            
            public static const NUKE:int = 22;
            
            public static const STUN:int = 23;
            
            public static const STEALTH:int = 24;
            
            public static const HEAL:int = 25;
            
            public static const CURE:int = 26;
            
            public static const POISON_DART:int = 27;
            
            public static const SLOW_DART:int = 28;
            
            public static const ARCHER_POISON:int = 29;
            
            public static const ARCHER_FIRE:int = 30;
            
            public static const SPEARTON_BLOCK:int = 31;
            
            public static const FIST_ATTACK:int = 32;
            
            public static const REAPER:int = 33;
            
            public static const WINGIDON_SPEED:int = 34;
            
            public static const SHIELD_BASH:int = 35;
            
            public static const KNIGHT_CHARGE:int = 36;
            
            public static const CAT_FURY:int = 37;
            
            public static const CAT_PACK:int = 38;
            
            public static const DEAD_POISON:int = 39;
            
            public static const STONE:int = 41;
            
            public static const POISON_POOL:int = 42;
            
            public static const CONSTRUCT_TOWER:int = 43;
            
            public static const CONSTRUCT_WALL:int = 44;
            
            public static const BOMBER_DETONATE:int = 45;
            
            public static const NINJA_STACK:int = 46;
            
            public static const REMOVE_WALL_COMMAND:int = 47;
            
            public static const REMOVE_TOWER_COMMAND:int = 48;
            
            public static const WATER_HEAL:int = 49;
            
            public static const FIRESTORM_NUKE:int = 50;
            
            public static const TELEPORT:int = 51;
            
            public static const SPLIT:int = 52;
            
            public static const PROTECT:int = 53;
            
            public static const FIRE_BREATH:int = 54;
            
            public static const CONVERT:int = 55;
            
            public static const HURRICANE:int = 56;
            
            public static const MORPH_MINER:int = 57;
            
            public static const FLOWER:int = 58;
            
            public static const TREE_ROOT:int = 59;
            
            public static const RADIANT_HEAT:int = 60;
            
            public static const BURROW:int = 61;
            
            public static const UNBURROW:int = 62;
            
            public static const actualButtonBitmap:* = new Bitmap(new CommandMove());
             
            
            protected var game:StickWar;
            
            protected var _intendedEntityType:int;
            
            private var _goalX:int;
            
            private var _goalY:int;
            
            private var _realX:int;
            
            private var _realY:int;
            
            private var _isGroup:Boolean;
            
            private var _isCancel:int;
            
            private var _requiresMouseInput:Boolean;
            
            private var _queued:Boolean;
            
            private var _pool:Pool;
            
            private var _type:int;
            
            protected var _hotKey:int;
            
            private var _isToggle:Boolean;
            
            private var _cursor:MovieClip;
            
            protected var _hasCoolDown:Boolean;
            
            private var _isSingleSpell:Boolean;
            
            protected var _buttonBitmap:Bitmap;
            
            private var _toolTip:String;
            
            protected var _team:Team;
            
            protected var _targetId:int;
            
            private var _unit:Unit;
            
            private var _isActivatable:Boolean;
            
            private var _xmlInfo:XMLList;
            
            protected var circleSprite:Sprite;
            
            private var mana:int;
            
            private var gold:int;
            
            public function UnitCommand()
            {
                  super();
                  this._isCancel = 0;
                  this._queued = false;
                  this.hotKey = 0;
                  this._intendedEntityType = -1;
                  this._isSingleSpell = false;
                  this._cursor = new Cursor();
                  this._requiresMouseInput = false;
                  this._hasCoolDown = false;
                  this._isToggle = false;
                  this._buttonBitmap = actualButtonBitmap;
                  this._isActivatable = true;
                  this.circleSprite = new Sprite();
            }
            
            public function get isCancel() : int
            {
                  return this._isCancel;
            }
            
            public function set isCancel(param1:int) : void
            {
                  this._isCancel = param1;
            }
            
            public function isCombining() : Boolean
            {
                  return this.type == COMBINE || this.type == COMBINE_ALL;
            }
            
            protected function loadXML(param1:XMLList) : void
            {
                  this._xmlInfo = param1;
                  this.hotKey = int(param1.hotkey);
                  this.mana = int(param1.mana);
                  this.gold = int(param1.gold);
            }
            
            public function playSound(param1:StickWar) : void
            {
            }
            
            public function getGoldRequired() : int
            {
                  return this.gold;
            }
            
            public function getManaRequired() : int
            {
                  return this.mana;
            }
            
            public function mayCast(param1:GameScreen, param2:Team) : Boolean
            {
                  return true;
            }
            
            public function unableToCastMessage() : String
            {
                  return "Unable to cast";
            }
            
            public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  while(param1.numChildren != 0)
                  {
                        param1.removeChildAt(0);
                  }
                  param1.addChild(this.cursor);
                  this.cursor.x = param2.game.battlefield.mouseX;
                  this.cursor.y = param2.game.battlefield.mouseY;
                  this.cursor.scaleX = 2 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  this.cursor.scaleY = 2 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  this.cursor.gotoAndStop(1);
                  return true;
            }
            
            public function isToggled(param1:Entity) : Boolean
            {
                  return false;
            }
            
            protected function drawRangeIndicators(param1:Sprite, param2:Number, param3:Boolean, param4:GameScreen) : void
            {
                  var _loc5_:Unit = null;
                  var _loc6_:Number = NaN;
                  var _loc7_:Number = NaN;
                  param1.addChild(this.circleSprite);
                  this.circleSprite.graphics.clear();
                  this.circleSprite.graphics.lineStyle(1,16777215,1);
                  for each(_loc5_ in param4.userInterface.selectedUnits.selected)
                  {
                        if(_loc5_.type == param4.userInterface.selectedUnits.getSelectedType())
                        {
                              _loc6_ = Math.sqrt(Math.pow(param2,2) - Math.pow(_loc5_.py,2));
                              _loc7_ = Math.sqrt(Math.pow(param2,2) - Math.pow(param4.game.map.height - _loc5_.py,2));
                              this.circleSprite.graphics.moveTo(_loc5_.px + _loc6_ * _loc5_.team.direction,0);
                              this.circleSprite.graphics.curveTo(_loc5_.px + param2 * _loc5_.team.direction,_loc5_.py,_loc5_.px + _loc7_ * _loc5_.team.direction,param4.game.map.height);
                              this.circleSprite.graphics.moveTo(_loc5_.px + _loc6_ * -_loc5_.team.direction,0);
                              this.circleSprite.graphics.curveTo(_loc5_.px - param2 * _loc5_.team.direction,_loc5_.py,_loc5_.px - _loc7_ * _loc5_.team.direction,param4.game.map.height);
                        }
                  }
            }
            
            public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  if(param1.contains(this.cursor))
                  {
                        this.cursor.nextFrame();
                        if(this.cursor.currentFrame == this.cursor.totalFrames)
                        {
                              param1.removeChild(this.cursor);
                              return true;
                        }
                        return false;
                  }
                  return true;
            }
            
            public function cleanUp() : void
            {
                  this._team = null;
                  if(this.buttonBitmap != null)
                  {
                        this.buttonBitmap.bitmapData = null;
                  }
                  this._cursor = null;
                  this._pool = null;
            }
            
            public function isEnabled(param1:Entity) : Boolean
            {
                  return false;
            }
            
            public function coolDownTime(param1:Entity) : Number
            {
                  return 0;
            }
            
            public function get goalY() : Number
            {
                  return this._goalY;
            }
            
            public function set goalY(param1:Number) : void
            {
                  this._goalY = param1;
            }
            
            public function get goalX() : Number
            {
                  return this._goalX;
            }
            
            public function set goalX(param1:Number) : void
            {
                  this._goalX = param1;
            }
            
            public function get realX() : Number
            {
                  return this._realX;
            }
            
            public function set realX(param1:Number) : void
            {
                  this._realX = param1;
            }
            
            public function get realY() : Number
            {
                  return this._realY;
            }
            
            public function set realY(param1:Number) : void
            {
                  this._realY = param1;
            }
            
            public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
            
            public function get type() : int
            {
                  return this._type;
            }
            
            public function set type(param1:int) : void
            {
                  this._type = param1;
            }
            
            public function get queued() : Boolean
            {
                  return this._queued;
            }
            
            public function set queued(param1:Boolean) : void
            {
                  this._queued = param1;
            }
            
            public function inRange(param1:Entity) : Boolean
            {
                  return true;
            }
            
            public function cleanUpPreClick(param1:Sprite) : void
            {
                  if(param1.contains(this.circleSprite))
                  {
                        param1.removeChild(this.circleSprite);
                  }
            }
            
            public function prepareNetworkedMove(param1:GameScreen) : *
            {
                  var _loc5_:String = null;
                  var _loc6_:Number = NaN;
                  var _loc7_:Number = NaN;
                  var _loc8_:Point = null;
                  var _loc9_:Number = NaN;
                  var _loc10_:Number = NaN;
                  var _loc11_:UnitCommand = null;
                  var _loc12_:Number = NaN;
                  this.playSound(param1.game);
                  var _loc2_:UnitMove = new UnitMove();
                  _loc2_.moveType = this.type;
                  var _loc3_:Unit = null;
                  var _loc4_:Number = 0;
                  for(_loc5_ in param1.team.units)
                  {
                        if(this._isSingleSpell)
                        {
                              _loc11_ = UnitCommand(param1.game.commandFactory.createCommand(param1.game,this.type,0,0,0,0,0,0,0));
                              if((this.intendedEntityType == -1 || this.intendedEntityType == param1.team.units[_loc5_].type) && Boolean(Unit(param1.team.units[_loc5_]).selected) && (!_loc11_.hasCoolDown || _loc11_.hasCoolDown && _loc11_.coolDownTime(param1.team.units[_loc5_]) == 0) && !Unit(param1.team.units[_loc5_]).isBusy())
                              {
                                    _loc12_ = (Unit(param1.team.units[_loc5_]).px - this.realX) * (Unit(param1.team.units[_loc5_]).px - this.realX) + (Unit(param1.team.units[_loc5_]).py - this.realY) * (Unit(param1.team.units[_loc5_]).py - this.realY);
                                    if(_loc3_ == null)
                                    {
                                          _loc3_ = param1.team.units[_loc5_];
                                          _loc4_ = _loc12_;
                                    }
                                    else if(_loc12_ < _loc4_)
                                    {
                                          _loc3_ = param1.team.units[_loc5_];
                                    }
                              }
                        }
                        else if(Unit(param1.team.units[_loc5_]).selected)
                        {
                              if(this.intendedEntityType == -1 || this.intendedEntityType == param1.team.units[_loc5_].type)
                              {
                                    _loc2_.units.push(param1.team.units[_loc5_].id);
                              }
                        }
                  }
                  if(_loc3_ != null)
                  {
                        _loc2_.units.push(_loc3_.id);
                  }
                  for(_loc5_ in param1.team.walls)
                  {
                        if(this._isSingleSpell)
                        {
                              if(Unit(param1.team.walls[_loc5_]).selected)
                              {
                                    if(this.intendedEntityType == -1 || this.intendedEntityType == param1.team.walls[_loc5_].type)
                                    {
                                          _loc2_.units.push(param1.team.walls[_loc5_].id);
                                    }
                              }
                        }
                  }
                  _loc2_.arg0 = param1.game.battlefield.mouseX;
                  _loc2_.arg1 = Math.max(0,Math.min(param1.game.map.height,param1.game.battlefield.mouseY));
                  _loc6_ = param1.userInterface.hud.hud.map.mouseX / param1.userInterface.hud.hud.map.width;
                  _loc7_ = param1.userInterface.hud.hud.map.mouseY / param1.userInterface.hud.hud.map.height;
                  _loc9_ = (_loc8_ = param1.userInterface.hud.hud.map.globalToLocal(new Point(param1.userInterface.mouseState.mouseDownX,param1.userInterface.mouseState.mouseDownY))).x / param1.userInterface.hud.hud.map.width;
                  _loc10_ = _loc8_.y / param1.userInterface.hud.hud.map.height;
                  if(_loc6_ >= 0 && _loc6_ <= 1 && _loc7_ >= 0 && _loc7_ <= 1 && _loc9_ >= 0 && _loc9_ <= 1 && _loc10_ >= 0 && _loc10_ <= 1)
                  {
                        _loc2_.arg0 = _loc6_ * param1.game.map.width;
                        _loc2_.arg1 = _loc7_ * param1.game.map.height;
                  }
                  _loc2_.arg4 = this.targetId;
                  if(param1.userInterface.keyBoardState.isShift)
                  {
                        _loc2_.queued = true;
                  }
                  param1.doMove(_loc2_,param1.team.id);
            }
            
            public function get hotKey() : int
            {
                  return this._hotKey;
            }
            
            public function set hotKey(param1:int) : void
            {
                  this._hotKey = param1;
            }
            
            public function get requiresMouseInput() : Boolean
            {
                  return this._requiresMouseInput;
            }
            
            public function set requiresMouseInput(param1:Boolean) : void
            {
                  this._requiresMouseInput = param1;
            }
            
            public function get cursor() : MovieClip
            {
                  return this._cursor;
            }
            
            public function set cursor(param1:MovieClip) : void
            {
                  this._cursor = param1;
            }
            
            public function get hasCoolDown() : Boolean
            {
                  return this._hasCoolDown;
            }
            
            public function set hasCoolDown(param1:Boolean) : void
            {
                  this._hasCoolDown = param1;
            }
            
            public function get intendedEntityType() : int
            {
                  return this._intendedEntityType;
            }
            
            public function set intendedEntityType(param1:int) : void
            {
                  this._intendedEntityType = param1;
            }
            
            public function get isSingleSpell() : Boolean
            {
                  return this._isSingleSpell;
            }
            
            public function set isSingleSpell(param1:Boolean) : void
            {
                  this._isSingleSpell = param1;
            }
            
            public function get toolTip() : String
            {
                  return this._toolTip;
            }
            
            public function set toolTip(param1:String) : void
            {
                  this._toolTip = param1;
            }
            
            public function get team() : Team
            {
                  return this._team;
            }
            
            public function set team(param1:Team) : void
            {
                  this._team = param1;
            }
            
            public function get isToggle() : Boolean
            {
                  return this._isToggle;
            }
            
            public function set isToggle(param1:Boolean) : void
            {
                  this._isToggle = param1;
            }
            
            public function get buttonBitmap() : Bitmap
            {
                  return this._buttonBitmap;
            }
            
            public function set buttonBitmap(param1:Bitmap) : void
            {
                  this._buttonBitmap = param1;
            }
            
            public function get unit() : Unit
            {
                  return this._unit;
            }
            
            public function set unit(param1:Unit) : void
            {
                  this._unit = param1;
            }
            
            public function get targetId() : int
            {
                  return this._targetId;
            }
            
            public function set targetId(param1:int) : void
            {
                  this._targetId = param1;
            }
            
            public function get isActivatable() : Boolean
            {
                  return this._isActivatable;
            }
            
            public function set isActivatable(param1:Boolean) : void
            {
                  this._isActivatable = param1;
            }
            
            public function get xmlInfo() : XMLList
            {
                  return this._xmlInfo;
            }
            
            public function set xmlInfo(param1:XMLList) : void
            {
                  this._xmlInfo = param1;
            }
            
            public function get isGroup() : Boolean
            {
                  return this._isGroup;
            }
            
            public function set isGroup(param1:Boolean) : void
            {
                  this._isGroup = param1;
            }
      }
}
