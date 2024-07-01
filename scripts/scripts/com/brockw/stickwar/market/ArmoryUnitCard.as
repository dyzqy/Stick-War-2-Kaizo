package com.brockw.stickwar.market
{
      import com.brockw.game.*;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.units.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.FrameLabel;
      import flash.display.MovieClip;
      import flash.events.*;
      import flash.utils.*;
      
      public class ArmoryUnitCard extends armoryCardMc
      {
            
            private static var hasChanged:Boolean = false;
             
            
            private var _unitMc:MovieClip;
            
            private var team:int;
            
            private var unitClass:Class;
            
            private var _unitType:int;
            
            private var _currentItemType:int;
            
            private var _main:Main;
            
            private var _isSelected:Boolean;
            
            private var _currentItems:Array;
            
            public var profileMc:MovieClip;
            
            private var itemPositionX:Number;
            
            private var itemPositionXReal:Number;
            
            private var hoverOverCard:Boolean;
            
            public var itemMap:Dictionary;
            
            private var _viewingIndex:int;
            
            private var lastSentCount:int;
            
            public function ArmoryUnitCard(param1:Main, param2:int, param3:int, param4:MovieClip, param5:Class, param6:MovieClip)
            {
                  super();
                  this.main = param1;
                  this.unitType = param3;
                  this.team = param2;
                  this._unitMc = param4;
                  this.itemPositionXReal = this.itemPositionX = 0;
                  this.unitClass = param5;
                  this.currentItemType = MarketItem.T_WEAPON;
                  x += width / 2;
                  y += height / 2;
                  this.isSelected = false;
                  this.currentItems = [];
                  this.setNotSelected();
                  this._unitMc.scaleX *= -1;
                  this.hoverOverCard = false;
                  this.changeItemList();
                  this.itemMap = new Dictionary();
                  this.itemMap[MarketItem.T_WEAPON] = "";
                  this.itemMap[MarketItem.T_ARMOR] = "";
                  this.itemMap[MarketItem.T_MISC] = "";
                  this.addEventListener(MouseEvent.CLICK,this.click);
                  this.viewingIndex = 0;
                  this.lastSentCount = 1000;
                  this.profileMc = param6;
            }
            
            public function leftArrowClick(param1:Event) : void
            {
                  this.viewingIndex -= 2;
                  this.viewingIndex = Math.max(this.viewingIndex,0);
            }
            
            public function rightArrowClick(param1:Event) : void
            {
                  this.viewingIndex += 2;
                  this.viewingIndex = Math.min(this.currentItems.length - 4,this.viewingIndex);
                  this.viewingIndex = Math.max(this.viewingIndex,0);
            }
            
            public function cleanUp() : void
            {
                  var _loc1_:MarketItem = null;
                  this.removeEventListener(MouseEvent.CLICK,this.click);
                  leftArrow.removeEventListener(MouseEvent.CLICK,this.leftArrowClick);
                  rightArrow.removeEventListener(MouseEvent.CLICK,this.rightArrowClick);
                  for each(_loc1_ in this.currentItems)
                  {
                        if(this.displayContainer.contains(_loc1_))
                        {
                              displayContainer.removeChild(_loc1_);
                        }
                        _loc1_.cleanUp();
                  }
            }
            
            public function click(param1:MouseEvent) : void
            {
            }
            
            public function unlockPrompt(param1:int, param2:int, param3:String) : void
            {
            }
            
            public function equip(param1:int, param2:int, param3:String) : void
            {
                  this.main.loadout.setItem(param1,param2,param3);
                  this.updateUnitProfile();
                  this.main.armourScreen.saveLoadout();
                  this.main.soundManager.playSoundFullVolume("ArmoryEquipSound");
            }
            
            public function setUnitProfile(param1:MovieClip) : void
            {
                  if(!param1.contains(this._unitMc))
                  {
                        param1.addChild(this._unitMc);
                  }
                  this._unitMc.x = 0;
                  this._unitMc.y = 0;
                  this.updateUnitProfile();
            }
            
            public function setUnitProfileNew(param1:MovieClip, param2:MovieClip) : void
            {
                  Util.animateMovieClip(param2,0);
                  ItemMap.setItemsForUnitType(this.unitType,param2,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
                  if(this.unitType == Unit.U_MINER_ELEMENT)
                  {
                        param2.mc.crabgold.gotoAndStop(100);
                  }
                  if(this.unitType == Unit.U_ARCHER)
                  {
                        param2.mc.bow.gotoAndStop(1);
                  }
            }
            
            public function updateUnitProfile() : void
            {
                  if(this._unitMc.parent != null)
                  {
                        Util.animateMovieClip(this._unitMc,0);
                        ItemMap.setItemsForUnitType(this.unitType,this._unitMc,this.itemMap[MarketItem.T_WEAPON],this.itemMap[MarketItem.T_ARMOR],this.itemMap[MarketItem.T_MISC]);
                        if(this.unitType == Unit.U_MINER_ELEMENT)
                        {
                              this._unitMc.mc.crabgold.gotoAndStop(100);
                        }
                  }
            }
            
            public function removeUnitProfile(param1:MovieClip) : void
            {
                  if(param1.contains(this._unitMc))
                  {
                        param1.removeChild(this._unitMc);
                  }
            }
            
            public function changeType(param1:int) : void
            {
                  this.viewingIndex = 0;
                  if(this.currentItemType != param1)
                  {
                        this.currentItemType = param1;
                  }
            }
            
            private function sortOnCost(param1:MarketItem, param2:MarketItem) : int
            {
                  return param1.price - param2.price;
            }
            
            private function includeMisc() : Boolean
            {
                  if(this.unitType == Unit.U_SPEARTON && this.currentItemType == MarketItem.T_ARMOR)
                  {
                        return true;
                  }
                  if(this.unitType == Unit.U_KNIGHT && this.currentItemType == MarketItem.T_ARMOR)
                  {
                        return true;
                  }
                  if(this.unitType == Unit.U_NINJA && this.currentItemType == MarketItem.T_WEAPON)
                  {
                        return true;
                  }
                  return false;
            }
            
            public function dontShowMisc() : Boolean
            {
                  if(this.unitType == Unit.U_SPEARTON)
                  {
                        return true;
                  }
                  if(this.unitType == Unit.U_KNIGHT)
                  {
                        return true;
                  }
                  if(this.unitType == Unit.U_NINJA)
                  {
                        return true;
                  }
                  return false;
            }
            
            private function changeItemList() : void
            {
                  var _loc1_:MarketItem = null;
                  var _loc2_:Array = null;
                  var _loc4_:MovieClip = null;
                  var _loc5_:FrameLabel = null;
                  var _loc6_:SFSObject = null;
                  this.viewingIndex = 0;
                  this.lastSentCount = 1000;
                  for each(_loc1_ in this.currentItems)
                  {
                        if(this.displayContainer.contains(_loc1_))
                        {
                              displayContainer.removeChild(_loc1_);
                        }
                  }
                  this.currentItems = [];
                  _loc2_ = [];
                  if(this.currentItemType != MarketItem.T_MISC || !this.dontShowMisc())
                  {
                        for each(_loc1_ in this.main.itemMap.getItems(this.unitType,this.currentItemType))
                        {
                              this.currentItems.push(_loc1_);
                              _loc2_.push(_loc1_.name);
                              _loc1_.setCard(this);
                        }
                  }
                  var _loc3_:Array = [];
                  if(this.includeMisc())
                  {
                        for each(_loc1_ in this.main.itemMap.getItems(this.unitType,MarketItem.T_MISC))
                        {
                              this.currentItems.push(_loc1_);
                              _loc3_.push(_loc1_.name);
                              _loc1_.setCard(this);
                        }
                  }
                  this.currentItems.sort(this.sortOnCost);
                  if(this.currentItemType != MarketItem.T_MISC || !this.dontShowMisc())
                  {
                        _loc4_ = ItemMap.getWeaponMcFromId(this._currentItemType,this.unitType);
                        trace(_loc4_);
                        if(_loc4_ != null && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.main.armourScreen.isEditMode)
                        {
                              for each(_loc5_ in _loc4_.currentLabels)
                              {
                                    if(_loc2_.indexOf(_loc5_.name) == -1)
                                    {
                                          (_loc6_ = new SFSObject()).putInt("id",-1);
                                          _loc6_.putUtfString("unit",ItemMap.unitTypeToName(this.unitType));
                                          _loc6_.putUtfString("name",_loc5_.name);
                                          _loc6_.putInt("type",this.currentItemType);
                                          _loc6_.putUtfString("description","");
                                          _loc6_.putUtfString("displayName",_loc5_.name);
                                          _loc6_.putInt("price",-1);
                                          _loc1_ = new MarketItem(_loc6_);
                                          this.currentItems.unshift(_loc1_);
                                          _loc1_.setCard(this);
                                    }
                              }
                        }
                  }
                  if(this.includeMisc())
                  {
                        if((_loc4_ = ItemMap.getWeaponMcFromId(MarketItem.T_MISC,this.unitType)) != null && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.main.armourScreen.isEditMode)
                        {
                              for each(_loc5_ in _loc4_.currentLabels)
                              {
                                    if(_loc3_.indexOf(_loc5_.name) == -1)
                                    {
                                          (_loc6_ = new SFSObject()).putInt("id",-1);
                                          _loc6_.putUtfString("unit",ItemMap.unitTypeToName(this.unitType));
                                          _loc6_.putUtfString("name",_loc5_.name);
                                          _loc6_.putInt("type",MarketItem.T_MISC);
                                          _loc6_.putUtfString("description","");
                                          _loc6_.putUtfString("displayName",_loc5_.name);
                                          _loc6_.putInt("price",-1);
                                          _loc1_ = new MarketItem(_loc6_);
                                          this.currentItems.unshift(_loc1_);
                                          _loc1_.setCard(this);
                                    }
                              }
                        }
                  }
                  this.itemPositionX = 0;
                  this.itemPositionXReal = 600;
            }
            
            public function update() : void
            {
                  var _loc4_:MarketItem = null;
                  var _loc5_:MarketItem = null;
                  var _loc6_:SFSObject = null;
                  if(this.main.armourScreen == null)
                  {
                        return;
                  }
                  if(this.main.hasReceivedPurchases && this.lastSentCount++ > 1000)
                  {
                        for each(_loc5_ in this.currentItems)
                        {
                              if(_loc5_.price == 0 && this.main.purchases.indexOf(_loc5_.id) == -1)
                              {
                                    (_loc6_ = new SFSObject()).putInt("itemId",_loc5_.id);
                                    this.main.sfs.send(new ExtensionRequest("buy",_loc6_));
                              }
                        }
                        this.lastSentCount = 0;
                  }
                  this.itemMap[MarketItem.T_WEAPON] = this.main.loadout.getItem(this.unitType,MarketItem.T_WEAPON);
                  this.itemMap[MarketItem.T_ARMOR] = this.main.loadout.getItem(this.unitType,MarketItem.T_ARMOR);
                  this.itemMap[MarketItem.T_MISC] = this.main.loadout.getItem(this.unitType,MarketItem.T_MISC);
                  this._unitMc.gotoAndStop(1);
                  var _loc1_:Number = 1.4;
                  this.itemPositionX = -this.viewingIndex * 100 * _loc1_;
                  this.itemPositionXReal += (this.itemPositionX - this.itemPositionXReal) * 0.3;
                  var _loc2_:int = 0;
                  var _loc3_:Boolean = false;
                  for each(_loc4_ in this.currentItems)
                  {
                        _loc4_.update(this.main);
                        if(!this.main.armourScreen.isUnlocking())
                        {
                              if(stage != null && _loc4_.hitTestPoint(stage.mouseX,stage.mouseY,false))
                              {
                                    if(this.visible)
                                    {
                                          this.itemMap[_loc4_.type] = _loc4_.name;
                                          _loc3_ = true;
                                    }
                              }
                        }
                        if(!this.displayContainer.contains(_loc4_))
                        {
                              displayContainer.addChild(_loc4_);
                              this.itemPositionXReal += (this.itemPositionX - this.itemPositionXReal) * 1;
                        }
                        _loc4_.scaleX = _loc1_;
                        _loc4_.scaleY = _loc1_;
                        _loc4_.x = this.itemPositionXReal + _loc2_ * 100 * _loc1_;
                        _loc4_.y = 0;
                        _loc2_++;
                  }
                  this.updateUnitProfile();
                  this.hoverOverCard = false;
            }
            
            public function select() : void
            {
                  var _loc2_:MarketItem = null;
                  this.isSelected = true;
                  var _loc1_:String = this.main.loadout.getItem(this.unitType,this._currentItemType);
                  for each(_loc2_ in this.currentItems)
                  {
                        if(_loc2_.name == _loc1_)
                        {
                              this.itemMap[this.currentItemType] = _loc2_.name;
                              this.updateUnitProfile();
                        }
                  }
            }
            
            public function setSelected() : void
            {
                  this.select();
            }
            
            public function setHover() : void
            {
                  this.hoverOverCard = true;
            }
            
            public function setNotSelected() : void
            {
                  this.isSelected = false;
            }
            
            public function get isSelected() : Boolean
            {
                  return this._isSelected;
            }
            
            public function set isSelected(param1:Boolean) : void
            {
                  this._isSelected = param1;
            }
            
            public function get currentItemType() : int
            {
                  return this._currentItemType;
            }
            
            public function set currentItemType(param1:int) : void
            {
                  this._currentItemType = param1;
                  this.changeItemList();
            }
            
            public function get unitType() : int
            {
                  return this._unitType;
            }
            
            public function set unitType(param1:int) : void
            {
                  this._unitType = param1;
            }
            
            public function get main() : Main
            {
                  return this._main;
            }
            
            public function set main(param1:Main) : void
            {
                  this._main = param1;
            }
            
            public function get currentItems() : Array
            {
                  return this._currentItems;
            }
            
            public function set currentItems(param1:Array) : void
            {
                  this._currentItems = param1;
            }
            
            public function get viewingIndex() : int
            {
                  return this._viewingIndex;
            }
            
            public function set viewingIndex(param1:int) : void
            {
                  this._viewingIndex = param1;
            }
      }
}
