package com.brockw.stickwar.engine
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.utils.*;
      
      public class SelectedUnits
      {
             
            
            private var _selected:Array;
            
            private var gameScreen:GameScreen;
            
            private var profilePic:MovieClip;
            
            private var _unitTypes:Dictionary;
            
            private var unitTypeKeys:Array;
            
            private var currentUnitType:Number;
            
            private var _interactsWith:int;
            
            private var _hasFinishedSelecting:Boolean;
            
            private var _hasChanged:Boolean;
            
            public function SelectedUnits(param1:GameScreen)
            {
                  super();
                  this.gameScreen = param1;
                  this.selected = new Array();
                  this.profilePic = null;
                  this.unitTypes = new Dictionary();
                  this.unitTypeKeys = [];
                  this.currentUnitType = -1;
                  this._hasFinishedSelecting = true;
                  this._hasChanged = false;
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:DisplayObject = null;
                  var _loc4_:MovieClip = null;
                  if(this.profilePic != null)
                  {
                        if(param1.gameScreen.hasEffects)
                        {
                              _loc2_ = 0;
                              while(_loc2_ < this.profilePic.numChildren)
                              {
                                    _loc3_ = this.profilePic.getChildAt(_loc2_);
                                    if(_loc3_ is MovieClip)
                                    {
                                          if((_loc4_ = MovieClip(_loc3_)).currentFrame == _loc4_.totalFrames)
                                          {
                                                _loc4_.gotoAndStop(1);
                                          }
                                          _loc4_.nextFrame();
                                    }
                                    _loc2_++;
                              }
                        }
                  }
            }
            
            public function nextSelectedUnitType() : void
            {
                  if(this.currentUnitType == -1)
                  {
                        return;
                  }
                  var _loc1_:int = int(this.unitTypeKeys.indexOf(this.currentUnitType));
                  _loc1_ = (_loc1_ + 1) % this.unitTypeKeys.length;
                  this.currentUnitType = this.unitTypeKeys[_loc1_];
                  this.gameScreen.userInterface.actionInterface.setEntity(this._unitTypes[this.currentUnitType][0]);
                  this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(this.currentUnitType));
            }
            
            public function refresh(param1:Boolean = false) : void
            {
                  if(this.currentUnitType == -1)
                  {
                        return;
                  }
                  if(Boolean(this._hasChanged) || param1)
                  {
                        this.gameScreen.userInterface.actionInterface.setEntity(this._unitTypes[this.currentUnitType][0]);
                        this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(this.currentUnitType));
                  }
            }
            
            public function add(param1:Unit) : void
            {
                  if(this.selected.indexOf(param1) != -1)
                  {
                        return;
                  }
                  this._hasChanged = true;
                  if(Boolean(this._interactsWith & Unit.I_IS_BUILDING) || Boolean(param1.interactsWith & Unit.I_IS_BUILDING))
                  {
                        this.clear();
                  }
                  if(param1.interactsWith & Unit.I_IS_BUILDING)
                  {
                        this.gameScreen.game.soundManager.playSoundFullVolume("MouseoverStructure");
                  }
                  this.selected.push(param1);
                  if(!(param1.type in this.unitTypes))
                  {
                        this.unitTypes[param1.type] = [];
                        this.currentUnitType = param1.type;
                        this.unitTypeKeys.push(param1.type);
                        this.unitTypeKeys.sort();
                        this._interactsWith |= param1.interactsWith;
                  }
                  this.unitTypes[param1.type].push(param1);
                  this.gameScreen.userInterface.actionInterface.setEntity(param1);
                  this.setProfilePic(this.gameScreen.game.unitFactory.getProfile(param1.type));
            }
            
            public function getSelectedType() : Number
            {
                  return this.currentUnitType;
            }
            
            public function setProfilePic(param1:MovieClip) : void
            {
                  if(this.profilePic != null)
                  {
                        MovieClip(this.gameScreen.userInterface.hud.hud.profile).removeChild(this.profilePic);
                  }
                  if(param1 != null)
                  {
                        MovieClip(this.gameScreen.userInterface.hud.hud.profile).addChild(param1);
                  }
                  this.profilePic = param1;
            }
            
            public function clear() : void
            {
                  var _loc1_:* = undefined;
                  var _loc2_:Unit = null;
                  this._hasChanged = true;
                  this._interactsWith = 0;
                  this.currentUnitType = -1;
                  this.gameScreen.userInterface.actionInterface.setEntity(null);
                  for(_loc1_ in this.unitTypes)
                  {
                        delete this.unitTypes[_loc1_];
                  }
                  for each(_loc2_ in this.selected)
                  {
                        _loc2_.selected = false;
                  }
                  this.selected.splice(0,this.selected.length);
                  this.unitTypeKeys.splice(0,this.unitTypeKeys.length);
                  this.setProfilePic(null);
            }
            
            public function get unitTypes() : Dictionary
            {
                  return this._unitTypes;
            }
            
            public function set unitTypes(param1:Dictionary) : void
            {
                  this._unitTypes = param1;
            }
            
            public function get interactsWith() : int
            {
                  return this._interactsWith;
            }
            
            public function set interactsWith(param1:int) : void
            {
                  this._interactsWith = param1;
            }
            
            public function get hasFinishedSelecting() : Boolean
            {
                  return this._hasFinishedSelecting;
            }
            
            public function set hasFinishedSelecting(param1:Boolean) : void
            {
                  this._hasFinishedSelecting = param1;
            }
            
            public function get hasChanged() : Boolean
            {
                  return this._hasChanged;
            }
            
            public function set hasChanged(param1:Boolean) : void
            {
                  this._hasChanged = param1;
            }
            
            public function get selected() : Array
            {
                  return this._selected;
            }
            
            public function set selected(param1:Array) : void
            {
                  this._selected = param1;
            }
      }
}
