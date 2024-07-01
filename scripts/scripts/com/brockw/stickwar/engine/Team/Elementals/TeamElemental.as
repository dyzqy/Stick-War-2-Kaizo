package com.brockw.stickwar.engine.Team.Elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.maps.Map;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.text.*;
      import flash.utils.*;
      
      public class TeamElemental extends Team
      {
            
            public static var protectionAmount:Number;
             
            
            private var baseMc:elementalBaseMc;
            
            private var castleBacking:MovieClip;
            
            internal var fireWaterDamage:Number;
            
            internal var fireWaterBurnDamage:Number;
            
            internal var fireWaterBurnFrames:Number;
            
            internal var fireWaterStunFrames:Number;
            
            internal var fireWaterStunForce:Number;
            
            public function TeamElemental(param1:StickWar, param2:int, param3:Dictionary = null, param4:* = 1, param5:Number = 1)
            {
                  var _loc6_:Entity = null;
                  var _loc9_:Building = null;
                  var _loc10_:Number = NaN;
                  var _loc11_:Number = NaN;
                  var _loc12_:Number = NaN;
                  var _loc13_:Number = NaN;
                  var _loc14_:Number = NaN;
                  var _loc15_:Number = NaN;
                  var _loc16_:Number = NaN;
                  var _loc17_:Number = NaN;
                  var _loc18_:Number = NaN;
                  var _loc19_:Number = NaN;
                  var _loc20_:Number = NaN;
                  var _loc21_:Number = NaN;
                  var _loc22_:Number = NaN;
                  var _loc23_:String = null;
                  var _loc24_:Unit = null;
                  protectionAmount = param1.xml.xml.Elemental.protectionAmount;
                  (_loc6_ = new Entity()).addChild(new elementalCastleFront());
                  _loc6_.cacheAsBitmap = true;
                  _loc6_.scaleX = -1;
                  castleFront = _loc6_;
                  (_loc6_ = new Entity()).addChild(this.castleBacking = new elementalCastleBacking());
                  _loc6_.scaleX = -1;
                  castleBack = _loc6_;
                  var _loc7_:Statue = new Statue(new _statueMc(),param1,param2);
                  param1.units[_loc7_.id] = _loc7_;
                  statue = _loc7_;
                  super(param1);
                  this.handicap = param4;
                  this.techAllowed = param3;
                  type = T_ELEMENTAL;
                  buttonOver = null;
                  sameButtonCount = 0;
                  _loc6_ = new Entity();
                  var _loc8_:elementalBaseMc = new elementalBaseMc();
                  this.baseMc = _loc8_;
                  _loc8_.scaleX = -1;
                  if(_loc8_.baseBacking)
                  {
                        _loc8_.baseBacking.cacheAsBitmap = true;
                  }
                  if(_loc8_.baseFront)
                  {
                        _loc8_.baseFront.cacheAsBitmap = true;
                  }
                  Util.animateToNeutral(_loc8_,4);
                  _loc6_.addChild(_loc8_);
                  base = _loc6_;
                  this.fireWaterDamage = param1.xml.xml.Elemental.Units.fireWater.damage;
                  this.fireWaterBurnDamage = param1.xml.xml.Elemental.Units.fireWater.burnDamage;
                  this.fireWaterBurnFrames = param1.xml.xml.Elemental.Units.fireWater.burnFrames;
                  this.fireWaterStunFrames = param1.xml.xml.Elemental.Units.fireWater.stunFrames;
                  this.fireWaterStunForce = param1.xml.xml.Elemental.Units.fireWater.stunForce;
                  tech = new ElementalTech(param1,this);
                  buildings["EarthBuilding"] = new EarthBuilding(param1,ElementalTech(tech),_loc8_.rockMc,_loc8_.rockHitAreaMc);
                  buildings["WaterBuilding"] = new WaterBuilding(param1,ElementalTech(tech),_loc8_.waterMc,_loc8_.waterHitArea);
                  buildings["FireBuilding"] = new FireBuilding(param1,ElementalTech(tech),_loc8_.fireMc,_loc8_.lavaHitAreaMc);
                  buildings["AirBuilding"] = new AirBuilding(param1,ElementalTech(tech),_loc8_.airMc,_loc8_.airHitAreaMc);
                  buildings["TempleBuilding"] = new TempleBuilding(param1,ElementalTech(tech),_loc8_.templeMc,_loc8_.templeHitArea);
                  buildings["BankBuilding"] = new BankBuilding(param1,ElementalTech(tech),_loc8_.bankMc,_loc8_.bankHitArea);
                  for each(_loc9_ in buildings)
                  {
                        this._unitProductionQueue[_loc9_.type] = [];
                  }
                  castleDefence = new CastleArchers(param1,this);
                  _loc10_ = Number(param1.xml.xml.Elemental.Units.earthElement.gold);
                  _loc11_ = Number(param1.xml.xml.Elemental.Units.waterElement.gold);
                  _loc12_ = Number(param1.xml.xml.Elemental.Units.airElement.gold);
                  _loc13_ = Number(param1.xml.xml.Elemental.Units.fireElement.gold);
                  _loc14_ = Number(param1.xml.xml.Elemental.Units.earthElement.mana);
                  _loc15_ = Number(param1.xml.xml.Elemental.Units.waterElement.mana);
                  _loc16_ = Number(param1.xml.xml.Elemental.Units.airElement.mana);
                  _loc17_ = Number(param1.xml.xml.Elemental.Units.fireElement.mana);
                  _loc18_ = Number(param1.xml.xml.Elemental.Units.lavaElement.mana);
                  _loc19_ = Number(param1.xml.xml.Elemental.Units.hurricaneElement.mana);
                  _loc20_ = Number(param1.xml.xml.Elemental.Units.treeElement.mana);
                  _loc21_ = Number(param1.xml.xml.Elemental.Units.firestormElement.mana);
                  _loc22_ = Number(param1.xml.xml.Elemental.Units.chrome.mana);
                  unitInfo[Unit.U_MINER_ELEMENT] = [param1.xml.xml.Elemental.Units.earthElement.gold * param4,param1.xml.xml.Elemental.Units.earthElement.mana * param4];
                  unitInfo[Unit.U_FIRE_ELEMENT] = [param1.xml.xml.Elemental.Units.fireElement.gold * param4,param1.xml.xml.Elemental.Units.fireElement.mana * param4];
                  unitInfo[Unit.U_WATER_ELEMENT] = [param1.xml.xml.Elemental.Units.waterElement.gold * param4,param1.xml.xml.Elemental.Units.waterElement.mana * param4];
                  unitInfo[Unit.U_AIR_ELEMENT] = [param1.xml.xml.Elemental.Units.airElement.gold * param4,param1.xml.xml.Elemental.Units.airElement.mana * param4];
                  unitInfo[Unit.U_LAVA_ELEMENT] = [(_loc10_ + _loc13_) * param4,(_loc14_ + _loc17_ + _loc18_) * param4,_loc18_ * param4,param1.xml.xml.Elemental.Units.lavaElement.population];
                  unitInfo[Unit.U_HURRICANE_ELEMENT] = [(_loc12_ + _loc11_) * param4,(_loc16_ + _loc15_ + _loc19_) * param4,_loc19_ * param4,param1.xml.xml.Elemental.Units.hurricaneElement.population];
                  unitInfo[Unit.U_TREE_ELEMENT] = [(_loc10_ + _loc11_) * param4,(_loc14_ + _loc15_ + _loc20_) * param4,_loc20_ * param4,param1.xml.xml.Elemental.Units.treeElement.population];
                  unitInfo[Unit.U_FIRESTORM_ELEMENT] = [(_loc12_ + _loc13_) * param4,(_loc16_ + _loc17_ + _loc21_) * param4,_loc21_ * param4,param1.xml.xml.Elemental.Units.firestormElement.population];
                  unitInfo[Unit.U_CHROME_ELEMENT] = [(_loc10_ + _loc11_ + _loc12_ + _loc13_) * param4,(_loc14_ + _loc15_ + _loc16_ + _loc17_ + _loc22_) * param4,_loc22_ * param4,param1.xml.xml.Elemental.Units.chrome.population];
                  unitInfo[Unit.U_EARTH_ELEMENT] = [_loc10_ * param4,_loc14_ * param4];
                  unitInfo[Unit.U_SCORPION_ELEMENT] = [0,0];
                  if(param1.unitFactory)
                  {
                        for(_loc23_ in unitInfo)
                        {
                              (_loc24_ = param1.unitFactory.getUnit(int(_loc23_))).team = this;
                              _loc24_.setBuilding();
                              if(_loc24_.building)
                              {
                                    unitInfo[_loc23_].push(_loc24_.building.type);
                              }
                              unitGroups[_loc24_.type] = [];
                              param1.unitFactory.returnUnit(_loc24_.type,_loc24_);
                        }
                  }
                  unitInfo[Unit.U_STEAM_EXPLOSION] = [(_loc11_ + _loc13_) * param4,(_loc15_ + _loc17_) * param4];
                  unitInfo[Unit.U_SANDSTORM] = [(_loc10_ + _loc12_) * param4,(_loc14_ + _loc16_) * param4];
                  this.healthModifier = param5;
            }
            
            override protected function canAfford(param1:int) : Boolean
            {
                  if(param1 == Unit.U_EARTH_ELEMENT || param1 == Unit.U_AIR_ELEMENT || param1 == Unit.U_FIRE_ELEMENT || param1 == Unit.U_WATER_ELEMENT)
                  {
                        return this.gold >= unitInfo[param1][0] && this.mana >= unitInfo[param1][1];
                  }
                  return true;
            }
            
            override protected function getSpawnUnitType(param1:StickWar) : int
            {
                  if(tech.isResearched(Tech.TOWER_SPAWN_II))
                  {
                        return Unit.U_LAVA_ELEMENT;
                  }
                  return Unit.U_LAVA_ELEMENT;
            }
            
            override public function updateStatue() : void
            {
                  if(statueType != "default")
                  {
                        statue.mc.statue.gotoAndStop(statueType);
                  }
                  else
                  {
                        statue.mc.statue.gotoAndStop("elemental");
                  }
            }
            
            override public function addCombinersToCastle(param1:Map) : void
            {
                  var _loc9_:MovieClip = null;
                  var _loc2_:Number = -42;
                  var _loc3_:Number = 702;
                  var _loc4_:Number = 116;
                  var _loc5_:Number = 538;
                  var _loc6_:Number = _loc2_;
                  var _loc7_:Number = _loc3_;
                  var _loc8_:Number = 0;
                  while(_loc6_ < _loc4_)
                  {
                        _loc8_ += game.random.nextNumber() * 0.01;
                        _loc6_ += (_loc4_ - _loc2_) * _loc8_;
                        _loc7_ += (_loc5_ - _loc3_) * _loc8_;
                        _loc9_ = param1.getARandomCombiner(game);
                        castleFront.addChild(_loc9_);
                        _loc9_.y = _loc7_;
                        _loc9_.x = _loc6_;
                  }
                  _loc2_ = 116;
                  _loc3_ = 538;
                  _loc4_ = 194;
                  _loc5_ = 498;
                  _loc6_ = _loc2_;
                  _loc7_ = _loc3_;
                  _loc8_ = 0;
                  while(_loc6_ < _loc4_)
                  {
                        _loc8_ += game.random.nextNumber() * 0.06;
                        _loc6_ += (_loc4_ - _loc2_) * _loc8_;
                        _loc7_ += (_loc5_ - _loc3_) * _loc8_;
                        _loc9_ = param1.getARandomCombiner(game);
                        castleFront.addChild(_loc9_);
                        _loc9_.y = _loc7_;
                        _loc9_.x = _loc6_;
                  }
                  _loc2_ = 200;
                  _loc3_ = 500;
                  _loc4_ = 400;
                  _loc5_ = 500;
                  _loc6_ = _loc2_;
                  _loc7_ = _loc3_;
                  _loc8_ = 0;
                  while(_loc6_ < _loc4_)
                  {
                        _loc8_ += game.random.nextNumber() * 0.02;
                        _loc6_ += (_loc4_ - _loc2_) * _loc8_;
                        _loc7_ += (_loc5_ - _loc3_) * _loc8_;
                        _loc9_ = param1.getARandomCombiner(game);
                        castleFront.addChild(_loc9_);
                        _loc9_.y = _loc7_;
                        _loc9_.x = _loc6_;
                  }
            }
            
            protected function combineTwo(param1:int, param2:int) : Boolean
            {
                  var _loc6_:Unit = null;
                  var _loc7_:UnitMove = null;
                  var _loc3_:Boolean = false;
                  var _loc4_:Unit = null;
                  var _loc5_:Unit = null;
                  for each(_loc6_ in game.gameScreen.userInterface.selectedUnits.selected)
                  {
                        if(!_loc6_.ai.currentCommand.isCombining())
                        {
                              if(_loc6_.type == param1)
                              {
                                    if(_loc4_ == null || _loc6_.px * this.direction > _loc4_.px * this.direction)
                                    {
                                          _loc4_ = _loc6_;
                                    }
                              }
                              if(_loc6_.type == param2)
                              {
                                    if(_loc5_ == null || _loc6_.px * this.direction > _loc5_.px * this.direction)
                                    {
                                          _loc5_ = _loc6_;
                                    }
                              }
                        }
                  }
                  if(_loc4_ != null && _loc5_ != null)
                  {
                        (_loc7_ = new UnitMove()).moveType = UnitCommand.COMBINE;
                        _loc7_.units.push(_loc4_.id);
                        _loc7_.owner = this.id;
                        _loc7_.arg0 = 0;
                        _loc7_.arg1 = 0;
                        _loc7_.arg2 = 0;
                        _loc7_.arg3 = 0;
                        _loc7_.arg4 = _loc5_.id;
                        game.gameScreen.doMove(_loc7_,id);
                        (_loc7_ = new UnitMove()).moveType = UnitCommand.COMBINE;
                        _loc7_.units.push(_loc5_.id);
                        _loc7_.owner = this.id;
                        _loc7_.arg0 = 0;
                        _loc7_.arg1 = 0;
                        _loc7_.arg2 = 0;
                        _loc7_.arg3 = 0;
                        _loc7_.arg4 = _loc4_.id;
                        game.gameScreen.doMove(_loc7_,id);
                        _loc3_ = true;
                  }
                  return _loc3_;
            }
            
            protected function combineInputSwitch(param1:UserInterface, param2:int, param3:int, param4:int) : void
            {
                  if(param1.keyBoardState.isPressed(param4))
                  {
                        this.combineTwo(param2,param3);
                  }
            }
            
            override public function getNumberOfMiners() : int
            {
                  return unitGroups[Unit.U_MINER_ELEMENT].length;
            }
            
            protected function combineAllUnits(param1:int, param2:int, param3:int, param4:int) : void
            {
                  var _loc9_:Unit = null;
                  var _loc10_:UnitMove = null;
                  var _loc5_:Unit = null;
                  var _loc6_:Unit = null;
                  var _loc7_:Unit = null;
                  var _loc8_:Unit = null;
                  for each(_loc9_ in game.gameScreen.userInterface.selectedUnits.selected)
                  {
                        if(!_loc9_.ai.currentCommand.isCombining())
                        {
                              if(_loc9_.type == param1)
                              {
                                    if(_loc5_ == null || _loc9_.px * this.direction > _loc5_.px * this.direction)
                                    {
                                          _loc5_ = _loc9_;
                                    }
                              }
                              if(_loc9_.type == param2)
                              {
                                    if(_loc6_ == null || _loc9_.px * this.direction > _loc6_.px * this.direction)
                                    {
                                          _loc6_ = _loc9_;
                                    }
                              }
                              if(_loc9_.type == param3)
                              {
                                    if(_loc7_ == null || _loc9_.px * this.direction > _loc7_.px * this.direction)
                                    {
                                          _loc7_ = _loc9_;
                                    }
                              }
                              if(_loc9_.type == param4)
                              {
                                    if(_loc8_ == null || _loc9_.px * this.direction > _loc8_.px * this.direction)
                                    {
                                          _loc8_ = _loc9_;
                                    }
                              }
                        }
                  }
                  if(_loc5_ != null && _loc6_ != null && _loc7_ != null && _loc8_ != null)
                  {
                        (_loc10_ = new UnitMove()).moveType = UnitCommand.COMBINE_ALL;
                        _loc10_.units.push(_loc5_.id);
                        _loc10_.owner = this.id;
                        _loc10_.arg0 = 0;
                        _loc10_.arg1 = 0;
                        _loc10_.arg2 = 0;
                        _loc10_.arg3 = 0;
                        _loc10_.arg4 = _loc6_.id;
                        game.gameScreen.doMove(_loc10_,id);
                        (_loc10_ = new UnitMove()).moveType = UnitCommand.COMBINE_ALL;
                        _loc10_.units.push(_loc6_.id);
                        _loc10_.owner = this.id;
                        _loc10_.arg0 = 0;
                        _loc10_.arg1 = 0;
                        _loc10_.arg2 = 0;
                        _loc10_.arg3 = 0;
                        _loc10_.arg4 = _loc7_.id;
                        game.gameScreen.doMove(_loc10_,id);
                        (_loc10_ = new UnitMove()).moveType = UnitCommand.COMBINE_ALL;
                        _loc10_.units.push(_loc7_.id);
                        _loc10_.owner = this.id;
                        _loc10_.arg0 = 0;
                        _loc10_.arg1 = 0;
                        _loc10_.arg2 = 0;
                        _loc10_.arg3 = 0;
                        _loc10_.arg4 = _loc8_.id;
                        game.gameScreen.doMove(_loc10_,id);
                        (_loc10_ = new UnitMove()).moveType = UnitCommand.COMBINE_ALL;
                        _loc10_.units.push(_loc8_.id);
                        _loc10_.owner = this.id;
                        _loc10_.arg0 = 0;
                        _loc10_.arg1 = 0;
                        _loc10_.arg2 = 0;
                        _loc10_.arg3 = 0;
                        _loc10_.arg4 = _loc5_.id;
                        game.gameScreen.doMove(_loc10_,id);
                  }
            }
            
            protected function combineAllInputSwitch(param1:UserInterface, param2:int, param3:int, param4:int, param5:int, param6:int) : void
            {
                  if(param1.keyBoardState.isPressed(param6))
                  {
                        this.combineAllUnits(param2,param3,param4,param5);
                  }
            }
            
            public function combine(param1:Unit, param2:Unit) : void
            {
                  var _loc6_:int = 0;
                  var _loc7_:Number = NaN;
                  var _loc8_:Number = NaN;
                  var _loc9_:Number = NaN;
                  var _loc10_:Number = NaN;
                  var _loc11_:StandCommand = null;
                  var _loc12_:AttackMoveCommand = null;
                  var _loc3_:int = -1;
                  if(param1.type == Unit.U_EARTH_ELEMENT && param2.type == Unit.U_FIRE_ELEMENT || param2.type == Unit.U_EARTH_ELEMENT && param1.type == Unit.U_FIRE_ELEMENT)
                  {
                        _loc3_ = int(Unit.U_LAVA_ELEMENT);
                  }
                  else if(param1.type == Unit.U_AIR_ELEMENT && param2.type == Unit.U_WATER_ELEMENT || param2.type == Unit.U_AIR_ELEMENT && param1.type == Unit.U_WATER_ELEMENT)
                  {
                        _loc3_ = int(Unit.U_HURRICANE_ELEMENT);
                  }
                  else if(param1.type == Unit.U_WATER_ELEMENT && param2.type == Unit.U_EARTH_ELEMENT || param2.type == Unit.U_WATER_ELEMENT && param1.type == Unit.U_EARTH_ELEMENT)
                  {
                        _loc3_ = int(Unit.U_TREE_ELEMENT);
                  }
                  else if(param1.type == Unit.U_AIR_ELEMENT && param2.type == Unit.U_FIRE_ELEMENT || param2.type == Unit.U_AIR_ELEMENT && param1.type == Unit.U_FIRE_ELEMENT)
                  {
                        _loc3_ = int(Unit.U_FIRESTORM_ELEMENT);
                  }
                  else if(param1.type == Unit.U_FIRE_ELEMENT && param2.type == Unit.U_WATER_ELEMENT || param2.type == Unit.U_FIRE_ELEMENT && param1.type == Unit.U_WATER_ELEMENT)
                  {
                        this.removeUnitCompletely(param1,game);
                        this.removeUnitCompletely(param2,game);
                        this.population -= param1.population;
                        this.population -= param2.population;
                        game.projectileManager.initFireWaterExplosion(param1.px,param1.py,param1,this.fireWaterDamage,this.fireWaterBurnDamage,this.fireWaterBurnFrames,this.fireWaterStunFrames,this.fireWaterStunForce);
                        _loc6_ = 0;
                        while(_loc6_ < 10)
                        {
                              _loc7_ = param1.px + game.random.nextNumber() * 200 - 100;
                              _loc8_ = game.random.nextNumber() * game.map.height;
                              _loc9_ = game.random.nextNumber() < 0.5 ? 1 : -1;
                              _loc10_ = 1 + game.random.nextNumber() * 1;
                              game.projectileManager.initFireOnTheGround(_loc7_,_loc8_,0,this,_loc9_,_loc10_);
                              _loc6_++;
                        }
                  }
                  else if(param1.type == Unit.U_EARTH_ELEMENT && param2.type == Unit.U_AIR_ELEMENT || param2.type == Unit.U_EARTH_ELEMENT && param1.type == Unit.U_AIR_ELEMENT)
                  {
                        this.removeUnitCompletely(param1,game);
                        this.removeUnitCompletely(param2,game);
                        this.population -= param1.population;
                        this.population -= param2.population;
                        this.addSandstorm(param1.px);
                  }
                  if(_loc3_ == -1)
                  {
                        return;
                  }
                  if(population - param1.population - param2.population + int(unitInfo[_loc3_][3]) > populationLimit)
                  {
                        (_loc11_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param1.ai.setCommand(game,_loc11_);
                        (_loc11_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param2.ai.setCommand(game,_loc11_);
                        if(this == game.team)
                        {
                              game.gameScreen.userInterface.helpMessage.showMessage("You are at your max population of 80!");
                        }
                        return;
                  }
                  if(this.mana < unitInfo[_loc3_][2])
                  {
                        (_loc11_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param1.ai.setCommand(game,_loc11_);
                        (_loc11_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param2.ai.setCommand(game,_loc11_);
                        if(this == game.team)
                        {
                              game.gameScreen.userInterface.helpMessage.showMessage("More Mana required to combine these units");
                        }
                        return;
                  }
                  var _loc4_:Number = (param1.health + param2.health) / (param1.maxHealth + param2.maxHealth);
                  this.removeUnitCompletely(param1,game);
                  this.removeUnitCompletely(param2,game);
                  this.population -= param1.population;
                  this.population -= param2.population;
                  var _loc5_:Unit = null;
                  _loc5_ = game.unitFactory.getUnit(_loc3_);
                  spawn(_loc5_,game,false);
                  _loc5_.x = _loc5_.px = param1.px;
                  _loc5_.y = _loc5_.py = param1.py;
                  if(_loc5_ != null)
                  {
                  }
                  if(_loc5_ != null && game.team == this)
                  {
                        _loc5_.selected = true;
                        game.gameScreen.userInterface.selectedUnits.add(_loc5_);
                  }
                  if(_loc5_)
                  {
                        population += _loc5_.population;
                        (_loc12_ = new AttackMoveCommand(game)).type = UnitCommand.ATTACK_MOVE;
                        if(direction == 1)
                        {
                              _loc12_.goalX = Math.max(homeX + this.direction * 1000,param1.px);
                        }
                        else
                        {
                              _loc12_.goalX = Math.min(homeX + this.direction * 1000,param1.px);
                        }
                        _loc12_.goalY = param1.py;
                        _loc12_.realX = _loc12_.goalX;
                        _loc12_.realY = _loc12_.goalY;
                        _loc5_.ai.setCommand(game,_loc12_);
                        this.mana -= unitInfo[_loc5_.type][2];
                        game.projectileManager.initCombineEffect(param1.px,param1.py,0,this,direction);
                        game.soundManager.playSound("combineSound",param1.px,param1.py);
                        _loc5_.health = _loc4_ * _loc5_.maxHealth;
                        _loc5_.healthBar.reset();
                  }
            }
            
            public function combineAll(param1:Unit, param2:Unit, param3:Unit, param4:Unit) : void
            {
                  var _loc7_:StandCommand = null;
                  var _loc8_:AttackMoveCommand = null;
                  if(population - param1.population - param2.population - param3.population - param4.population + int(unitInfo[Unit.U_CHROME_ELEMENT][3]) > populationLimit)
                  {
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param1.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param2.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param3.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param4.ai.setCommand(game,_loc7_);
                        if(this == game.team)
                        {
                              game.gameScreen.userInterface.helpMessage.showMessage("You are at your max population of 80!");
                        }
                        return;
                  }
                  if(this.mana < unitInfo[Unit.U_CHROME_ELEMENT][2])
                  {
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param1.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param2.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param3.ai.setCommand(game,_loc7_);
                        (_loc7_ = new StandCommand(game)).type = UnitCommand.STAND;
                        param4.ai.setCommand(game,_loc7_);
                        if(this == game.team)
                        {
                              game.gameScreen.userInterface.helpMessage.showMessage("More Mana required to combine these units");
                        }
                  }
                  var _loc5_:Number = (param1.health + param2.health + param3.health + param4.health) / (param1.maxHealth + param2.maxHealth + param3.maxHealth + param4.maxHealth);
                  this.removeUnitCompletely(param1,game);
                  this.removeUnitCompletely(param2,game);
                  this.removeUnitCompletely(param3,game);
                  this.removeUnitCompletely(param4,game);
                  this.population -= param1.population;
                  this.population -= param2.population;
                  this.population -= param3.population;
                  this.population -= param4.population;
                  var _loc6_:Unit = game.unitFactory.getUnit(Unit.U_CHROME_ELEMENT);
                  spawn(_loc6_,game,false);
                  _loc6_.x = _loc6_.px = param1.px;
                  _loc6_.y = _loc6_.py = param1.py;
                  if(_loc6_ != null && game.team == this)
                  {
                        _loc6_.selected = true;
                        game.gameScreen.userInterface.selectedUnits.add(_loc6_);
                  }
                  if(_loc6_)
                  {
                        population += _loc6_.population;
                        (_loc8_ = new AttackMoveCommand(game)).type = UnitCommand.ATTACK_MOVE;
                        if(direction == 1)
                        {
                              _loc8_.goalX = Math.max(homeX + this.direction * 1000,param1.px);
                        }
                        else
                        {
                              _loc8_.goalX = Math.min(homeX + this.direction * 1000,param1.px);
                        }
                        _loc8_.goalY = param1.py;
                        _loc8_.realX = _loc8_.goalX;
                        _loc8_.realY = _loc8_.goalY;
                        _loc6_.ai.setCommand(game,_loc8_);
                        this.mana -= unitInfo[_loc6_.type][2];
                        game.projectileManager.initCombineEffect(param1.px,param1.py,0,this,direction);
                        game.soundManager.playSound("combineSound",param1.px,param1.py);
                        _loc6_.health = _loc5_ * _loc6_.maxHealth;
                        _loc6_.healthBar.reset();
                  }
            }
            
            private function tryElementalCombineMove(param1:int) : Boolean
            {
                  var _loc2_:Boolean = false;
                  if(param1 == Unit.U_LAVA_ELEMENT)
                  {
                        this.combineTwo(Unit.U_EARTH_ELEMENT,Unit.U_FIRE_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_TREE_ELEMENT)
                  {
                        this.combineTwo(Unit.U_EARTH_ELEMENT,Unit.U_WATER_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_HURRICANE_ELEMENT)
                  {
                        this.combineTwo(Unit.U_WATER_ELEMENT,Unit.U_AIR_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_FIRESTORM_ELEMENT)
                  {
                        this.combineTwo(Unit.U_AIR_ELEMENT,Unit.U_FIRE_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_STEAM_EXPLOSION)
                  {
                        this.combineTwo(Unit.U_WATER_ELEMENT,Unit.U_FIRE_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_SANDSTORM)
                  {
                        this.combineTwo(Unit.U_AIR_ELEMENT,Unit.U_EARTH_ELEMENT);
                        _loc2_ = true;
                  }
                  else if(param1 == Unit.U_CHROME_ELEMENT)
                  {
                        this.combineAllUnits(Unit.U_AIR_ELEMENT,Unit.U_FIRE_ELEMENT,Unit.U_WATER_ELEMENT,Unit.U_EARTH_ELEMENT);
                        _loc2_ = true;
                  }
                  if(_loc2_)
                  {
                        game.soundManager.playSoundFullVolume("UnitMake");
                  }
                  return _loc2_;
            }
            
            private function updateCombineHighlight(param1:int, param2:MovieClip, param3:Dictionary) : void
            {
                  if(!param2)
                  {
                        return;
                  }
                  param2.visible = false;
                  if(param1 == Unit.U_LAVA_ELEMENT && this.mana >= unitInfo[Unit.U_LAVA_ELEMENT][2])
                  {
                        if(Unit.U_FIRE_ELEMENT in param3 && Unit.U_EARTH_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_TREE_ELEMENT && this.mana >= unitInfo[Unit.U_TREE_ELEMENT][2])
                  {
                        if(Unit.U_WATER_ELEMENT in param3 && Unit.U_EARTH_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_HURRICANE_ELEMENT && this.mana >= unitInfo[Unit.U_HURRICANE_ELEMENT][2])
                  {
                        if(Unit.U_WATER_ELEMENT in param3 && Unit.U_AIR_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_FIRESTORM_ELEMENT && this.mana >= unitInfo[Unit.U_FIRESTORM_ELEMENT][2])
                  {
                        if(Unit.U_FIRE_ELEMENT in param3 && Unit.U_AIR_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_CHROME_ELEMENT && this.mana >= unitInfo[Unit.U_CHROME_ELEMENT][2])
                  {
                        if(Unit.U_FIRE_ELEMENT in param3 && Unit.U_EARTH_ELEMENT in param3 && Unit.U_WATER_ELEMENT in param3 && Unit.U_AIR_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_STEAM_EXPLOSION)
                  {
                        if(Unit.U_FIRE_ELEMENT in param3 && Unit.U_WATER_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
                  else if(param1 == Unit.U_SANDSTORM)
                  {
                        if(Unit.U_AIR_ELEMENT in param3 && Unit.U_EARTH_ELEMENT in param3)
                        {
                              param2.visible = true;
                        }
                  }
            }
            
            override public function detectedUserInput(param1:UserInterface) : void
            {
                  singlePlayerDebugInputSwitch(param1,Unit.U_EARTH_ELEMENT,49);
                  singlePlayerDebugInputSwitch(param1,Unit.U_WATER_ELEMENT,50);
                  singlePlayerDebugInputSwitch(param1,Unit.U_AIR_ELEMENT,51);
                  singlePlayerDebugInputSwitch(param1,Unit.U_FIRE_ELEMENT,52);
                  this.combineInputSwitch(param1,Unit.U_EARTH_ELEMENT,Unit.U_FIRE_ELEMENT,53);
                  this.combineInputSwitch(param1,Unit.U_AIR_ELEMENT,Unit.U_WATER_ELEMENT,54);
                  this.combineInputSwitch(param1,Unit.U_EARTH_ELEMENT,Unit.U_WATER_ELEMENT,55);
                  this.combineInputSwitch(param1,Unit.U_AIR_ELEMENT,Unit.U_FIRE_ELEMENT,56);
                  this.combineAllInputSwitch(param1,Unit.U_EARTH_ELEMENT,Unit.U_WATER_ELEMENT,Unit.U_FIRE_ELEMENT,Unit.U_AIR_ELEMENT,57);
                  this.combineInputSwitch(param1,Unit.U_FIRE_ELEMENT,Unit.U_WATER_ELEMENT,58);
                  this.combineInputSwitch(param1,Unit.U_AIR_ELEMENT,Unit.U_EARTH_ELEMENT,59);
            }
            
            override public function checkInputForSelect(param1:int, param2:*) : void
            {
                  param1++;
                  if(param1 == 0)
                  {
                        param2(Unit.U_MINER_ELEMENT);
                  }
                  else if(param1 == 1)
                  {
                        param2(Unit.U_EARTH_ELEMENT);
                  }
                  else if(param1 == 2)
                  {
                        param2(Unit.U_WATER_ELEMENT);
                  }
                  else if(param1 == 3)
                  {
                        param2(Unit.U_AIR_ELEMENT);
                  }
                  else if(param1 == 4)
                  {
                        param2(Unit.U_FIRE_ELEMENT);
                  }
                  else if(param1 == 5)
                  {
                        param2(Unit.U_LAVA_ELEMENT);
                  }
                  else if(param1 == 6)
                  {
                        param2(Unit.U_HURRICANE_ELEMENT);
                  }
                  else if(param1 == 7)
                  {
                        param2(Unit.U_TREE_ELEMENT);
                  }
                  else if(param1 == 8)
                  {
                        param2(Unit.U_FIRESTORM_ELEMENT);
                  }
                  else if(param1 == 9)
                  {
                        param2(Unit.U_CHROME_ELEMENT);
                  }
            }
            
            override public function spawnMiners() : void
            {
                  var _loc1_:Unit = game.unitFactory.getUnit(Unit.U_MINER_ELEMENT);
                  var _loc2_:Unit = game.unitFactory.getUnit(Unit.U_MINER_ELEMENT);
                  spawn(_loc1_,game);
                  spawn(_loc2_,game);
                  _loc1_.px = homeX + 650 * direction;
                  _loc2_.px = homeX + 650 * direction;
                  _loc1_.py = game.map.height / 3;
                  _loc2_.py = game.map.height / 3 * 2;
                  _loc1_.ai.setCommand(game,new StandCommand(game));
                  _loc2_.ai.setCommand(game,new StandCommand(game));
                  this.population += 4;
            }
            
            override public function initTeamButtons(param1:GameScreen) : void
            {
                  var _loc2_:String = null;
                  var _loc3_:MovieClip = null;
                  var _loc4_:MovieClip = null;
                  var _loc5_:MovieClip = null;
                  var _loc6_:TextField = null;
                  var _loc7_:TextFormat = null;
                  buttonInfoMap = new Dictionary();
                  buttonInfoMap[Unit.U_EARTH_ELEMENT] = [param1.userInterface.hud.hud.earthButton,param1.userInterface.hud.hud.earthOverlay,param1.game.xml.xml.Elemental.Units.earthElement,0,new cancelButton(),game.xml.xml.Elemental.Units.earthElement.gold * handicap,new MovieClip(),null,null];
                  buttonInfoMap[Unit.U_WATER_ELEMENT] = [param1.userInterface.hud.hud.waterButton,param1.userInterface.hud.hud.waterOverlay,param1.game.xml.xml.Elemental.Units.waterElement,0,new cancelButton(),game.xml.xml.Elemental.Units.waterElement.gold * handicap,new MovieClip(),null,null];
                  buttonInfoMap[Unit.U_AIR_ELEMENT] = [param1.userInterface.hud.hud.airButton,param1.userInterface.hud.hud.airOverlay,param1.game.xml.xml.Elemental.Units.airElement,0,new cancelButton(),game.xml.xml.Elemental.Units.airElement.gold * handicap,new MovieClip(),null,null];
                  buttonInfoMap[Unit.U_FIRE_ELEMENT] = [param1.userInterface.hud.hud.fireButton,param1.userInterface.hud.hud.fireOverlay,param1.game.xml.xml.Elemental.Units.fireElement,0,new cancelButton(),game.xml.xml.Elemental.Units.fireElement.gold * handicap,new MovieClip(),null,null];
                  param1.userInterface.hud.hud.earthHighlight.visible = false;
                  param1.userInterface.hud.hud.waterHighlight.visible = false;
                  param1.userInterface.hud.hud.airHighlight.visible = false;
                  param1.userInterface.hud.hud.fireHighlight.visible = false;
                  buttonInfoMap[Unit.U_LAVA_ELEMENT] = [param1.userInterface.hud.hud.lavaButton,param1.userInterface.hud.hud.lavaOverlay,param1.game.xml.xml.Elemental.Units.lavaElement,0,new cancelButton(),game.xml.xml.Elemental.Units.lavaElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.lavaHighlight,null];
                  buttonInfoMap[Unit.U_HURRICANE_ELEMENT] = [param1.userInterface.hud.hud.hurricaneButton,param1.userInterface.hud.hud.hurricaneOverlay,param1.game.xml.xml.Elemental.Units.hurricaneElement,0,new cancelButton(),game.xml.xml.Elemental.Units.hurricaneElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.hurricaneHighlight,null];
                  buttonInfoMap[Unit.U_TREE_ELEMENT] = [param1.userInterface.hud.hud.treeButton,param1.userInterface.hud.hud.treeOverlay,param1.game.xml.xml.Elemental.Units.treeElement,0,new cancelButton(),game.xml.xml.Elemental.Units.treeElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.treeHighlight,null];
                  buttonInfoMap[Unit.U_FIRESTORM_ELEMENT] = [param1.userInterface.hud.hud.firestormButton,param1.userInterface.hud.hud.firestormOverlay,param1.game.xml.xml.Elemental.Units.firestormElement,0,new cancelButton(),game.xml.xml.Elemental.Units.firestormElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.firestormHighlight,null];
                  buttonInfoMap[Unit.U_STEAM_EXPLOSION] = [param1.userInterface.hud.hud.explosionButton,param1.userInterface.hud.hud.explosionOverlay,param1.game.xml.xml.Elemental.Units.fireWater,0,new cancelButton(),game.xml.xml.Elemental.Units.explosionElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.explosionHighlight,null];
                  buttonInfoMap[Unit.U_CHROME_ELEMENT] = [param1.userInterface.hud.hud.chromeButton,param1.userInterface.hud.hud.chromeOverlay,param1.game.xml.xml.Elemental.Units.chrome,0,new cancelButton(),game.xml.xml.Elemental.Units.chromeElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.chromeHighlight,null];
                  buttonInfoMap[Unit.U_SANDSTORM] = [param1.userInterface.hud.hud.sandstormButton,param1.userInterface.hud.hud.sandstormOverlay,param1.game.xml.xml.Elemental.Units.sandstorm,0,new cancelButton(),game.xml.xml.Elemental.Units.explosionElement.gold * handicap,new MovieClip(),param1.userInterface.hud.hud.sandstormHighlight,null];
                  for(_loc2_ in buttonInfoMap)
                  {
                        _loc3_ = buttonInfoMap[_loc2_][1];
                        if((_loc4_ = buttonInfoMap[_loc2_][0]).progressContainer)
                        {
                              _loc4_.progressContainer.addChild(buttonInfoMap[_loc2_][6]);
                        }
                        else
                        {
                              _loc4_.addChild(buttonInfoMap[_loc2_][6]);
                        }
                        (_loc5_ = buttonInfoMap[_loc2_][4]).x = _loc4_.x + _loc4_.width - _loc5_.width * 1.5;
                        _loc5_.y = _loc4_.y;
                        param1.userInterface.hud.hud.addChild(_loc5_);
                        _loc5_.visible = false;
                        (_loc6_ = new TextField()).name = "number";
                        _loc7_ = new TextFormat(null,20,16777215);
                        _loc6_.defaultTextFormat = _loc7_;
                        _loc6_.width = 25;
                        _loc6_.height = 25;
                        _loc6_.x = 12;
                        _loc6_.y = 10;
                        _loc6_.selectable = false;
                        _loc6_.text = "0";
                        _loc4_.addChild(_loc6_);
                  }
            }
            
            override public function drawTimerOverlay(param1:MovieClip, param2:MovieClip, param3:Number) : void
            {
                  param1.graphics.clear();
                  param1.y = -1;
                  var _loc4_:int = param2.width;
                  var _loc5_:int = param2.width;
                  param1.scaleX = (param2.width + 5) * 1 / param2.width;
                  param1.scaleY = (param2.height + 5) * 1 / param2.width;
                  param1.graphics.beginFill(0,1);
                  param1.graphics.moveTo(_loc4_ / 2,0);
                  param1.graphics.lineTo(_loc4_ / 2,_loc5_ / 2);
                  var _loc6_:Number = param3 * 2 * Math.PI;
                  var _loc7_:Number = Math.atan2(_loc4_ / 2,_loc5_ / 2);
                  var _loc8_:Number = _loc6_;
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
            
            override public function checkUnitCreateMouseOver(param1:GameScreen) : void
            {
                  var _loc5_:MovieClip = null;
                  var _loc6_:String = null;
                  var _loc7_:MovieClip = null;
                  var _loc8_:MovieClip = null;
                  var _loc9_:MovieClip = null;
                  var _loc10_:TextField = null;
                  var _loc11_:MovieClip = null;
                  var _loc12_:MovieClip = null;
                  var _loc13_:XMLList = null;
                  var _loc14_:int = 0;
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
                  for(_loc6_ in buttonInfoMap)
                  {
                        _loc7_ = buttonInfoMap[_loc6_][1];
                        _loc8_ = buttonInfoMap[_loc6_][0];
                        _loc9_ = buttonInfoMap[_loc6_][4];
                        _loc10_ = TextField(MovieClip(buttonInfoMap[_loc6_][0]).getChildByName("number"));
                        _loc11_ = MovieClip(buttonInfoMap[_loc6_][8]);
                        _loc12_ = MovieClip(buttonInfoMap[_loc6_][7]);
                        this.updateCombineHighlight(_loc6_,_loc12_,game.gameScreen.userInterface.selectedUnits.unitTypes);
                        if(Boolean(this.unitsAvailable) && !(_loc6_ in unitsAvailable))
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
                              if(_loc6_ != Unit.U_STEAM_EXPLOSION && _loc6_ != Unit.U_SANDSTORM)
                              {
                                    _loc10_.text = "" + buttonInfoMap[_loc6_][3];
                                    if(buttonInfoMap[_loc6_][3] > 0)
                                    {
                                          _loc9_.visible = true;
                                          if(_loc9_.hitTestPoint(_loc2_,_loc3_,false) && param1.userInterface.mouseState.clicked)
                                          {
                                                param1.userInterface.mouseState.clicked = false;
                                                (_loc15_ = new UnitCreateMove()).unitType = -int(_loc6_);
                                                param1.doMove(_loc15_,id);
                                                _loc4_ = true;
                                          }
                                    }
                                    else
                                    {
                                          _loc9_.visible = false;
                                    }
                                    if((_loc14_ = int(unitInfo[_loc6_][2])) in _unitProductionQueue)
                                    {
                                          if(_unitProductionQueue[_loc14_].length != 0 && Unit(_unitProductionQueue[_loc14_][0][0]).type == int(_loc6_))
                                          {
                                                this.drawTimerOverlay(buttonInfoMap[_loc6_][6],_loc7_,_unitProductionQueue[_loc14_][0][1] / Unit(_unitProductionQueue[_loc14_][0][0]).createTime);
                                          }
                                          else
                                          {
                                                buttonInfoMap[_loc6_][6].graphics.clear();
                                          }
                                          if(_loc10_.text == "0")
                                          {
                                                _loc10_.text = "";
                                          }
                                    }
                                    else
                                    {
                                          _loc10_.text = "";
                                    }
                              }
                              else
                              {
                                    _loc10_.visible = false;
                              }
                              _loc13_ = buttonInfoMap[_loc6_][2];
                              _loc7_.visible = true;
                              if(_loc4_ == false && _loc8_.hitTestPoint(_loc2_,_loc3_,false))
                              {
                                    if(param1.userInterface.mouseState.clicked)
                                    {
                                          if(!this.canAfford(_loc6_))
                                          {
                                                if(this.gold < unitInfo[int(_loc6_)][0])
                                                {
                                                      game.gameScreen.userInterface.helpMessage.showMessage("Not enough gold to construct unit");
                                                      game.soundManager.playSoundFullVolume("UnitMakeFail");
                                                }
                                                else if(this.mana < unitInfo[int(_loc6_)][1])
                                                {
                                                      game.gameScreen.userInterface.helpMessage.showMessage("Not enough mana to construct unit");
                                                      game.soundManager.playSoundFullVolume("UnitMakeFail");
                                                }
                                          }
                                          else if(!this.tryElementalCombineMove(_loc6_))
                                          {
                                                param1.userInterface.mouseState.clicked = false;
                                                (_loc15_ = new UnitCreateMove()).unitType = int(_loc6_);
                                                param1.doMove(_loc15_,id);
                                                game.soundManager.playSoundFullVolume("UnitMake");
                                          }
                                    }
                                    _loc7_.visible = false;
                                    this.updateButtonOverXMLElementalUnit(game,_loc13_,_loc6_,unitInfo[_loc6_][0],unitInfo[_loc6_][1]);
                              }
                        }
                  }
            }
            
            override public function getMinerType() : int
            {
                  return Unit.U_MINER_ELEMENT;
            }
            
            public function updateButtonOverXMLElementalUnit(param1:StickWar, param2:XMLList, param3:int, param4:Number, param5:Number) : void
            {
                  ++sameButtonCount;
                  if(sameButtonCount > 3)
                  {
                        if(param3 == Unit.U_AIR_ELEMENT || param3 == Unit.U_EARTH_ELEMENT || param3 == Unit.U_WATER_ELEMENT || param3 == Unit.U_FIRE_ELEMENT)
                        {
                              param1.tipBox.displayTip(param2.name,param2.info,param2.cooldown,param4,param5,param2.population);
                        }
                        else if(param3 == Unit.U_LAVA_ELEMENT)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["fire","earth"],param2.mana);
                        }
                        else if(param3 == Unit.U_TREE_ELEMENT)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["water","earth"],param2.mana);
                        }
                        else if(param3 == Unit.U_HURRICANE_ELEMENT)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["water","air"],param2.mana);
                        }
                        else if(param3 == Unit.U_FIRESTORM_ELEMENT)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["fire","air"],param2.mana);
                        }
                        else if(param3 == Unit.U_CHROME_ELEMENT)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["fire","earth","air","water"],param2.mana);
                        }
                        else if(param3 == Unit.U_STEAM_EXPLOSION)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["fire","water"],param2.mana);
                        }
                        else if(param3 == Unit.U_SANDSTORM)
                        {
                              param1.tipBox.displayElementalTip(param2.name,param2.info,0,["earth","air"],param2.mana);
                        }
                  }
                  hit = true;
            }
      }
}
