package com.brockw.stickwar.engine.Team.Chaos
{
      import com.brockw.game.*;
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.Team.Order.*;
      import com.brockw.stickwar.engine.maps.Map;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.text.*;
      import flash.utils.*;
      
      public class TeamChaos extends Team
      {
             
            
            public function TeamChaos(param1:StickWar, param2:int, param3:Dictionary = null, param4:* = 1, param5:Number = 1)
            {
                  var _loc9_:Building = null;
                  var _loc10_:String = null;
                  var _loc11_:Unit = null;
                  var _loc6_:Entity;
                  (_loc6_ = new Entity()).addChild(new chaosCastle());
                  castleFront = _loc6_;
                  (_loc6_ = new Entity()).addChild(new chaosCastleBack());
                  castleBack = _loc6_;
                  var _loc7_:Statue = new Statue(new _statueMc(),param1,param2);
                  param1.units[_loc7_.id] = _loc7_;
                  statue = _loc7_;
                  super(param1);
                  this.handicap = param4;
                  this.techAllowed = param3;
                  type = T_CHAOS;
                  buttonOver = null;
                  sameButtonCount = 0;
                  _loc6_ = new Entity();
                  var _loc8_:chaosBase = new chaosBase();
                  Util.animateToNeutral(_loc8_,4);
                  _loc6_.addChild(_loc8_);
                  base = _loc6_;
                  _loc8_.baseBacking.cacheAsBitmap = true;
                  tech = new ChaosTech(param1,this);
                  buildings["BarracksBuilding"] = new ChaosBarracksBuilding(param1,ChaosTech(tech),_loc8_.chaosBarrackButton,_loc8_.chaosBarracksHitArea);
                  buildings["ArcheryBuilding"] = new ChaosFletchersBuilding(param1,ChaosTech(tech),_loc8_.chaosFletcherButton,_loc8_.chaosFletcherHitArea);
                  buildings["UndeadBuilding"] = new ChaosUndeadBuilding(param1,ChaosTech(tech),_loc8_.chaosUndeadButton,_loc8_.chaosUndeadHitArea);
                  buildings["GiantBuilding"] = new ChaosGiantBuilding(param1,ChaosTech(tech),_loc8_.chaosGiantButton,_loc8_.chaosGiantHitArea);
                  buildings["MedusaBuilding"] = new ChaosMedusaBuilding(param1,ChaosTech(tech),_loc8_.chaosMedusaButton,_loc8_.chaosMedusaHitArea);
                  buildings["BankBuilding"] = new ChaosBankBuilding(param1,ChaosTech(tech),_loc8_.chaosBankButton,_loc8_.chaosBankHitArea);
                  for each(_loc9_ in buildings)
                  {
                        this._unitProductionQueue[_loc9_.type] = [];
                  }
                  castleDefence = new CastleDeads(param1,this);
                  unitInfo[Unit.U_BOMBER] = [param1.xml.xml.Chaos.Units.bomber.gold * param4,param1.xml.xml.Chaos.Units.bomber.mana * param4];
                  unitInfo[Unit.U_WINGIDON] = [param1.xml.xml.Chaos.Units.wingidon.gold * param4,param1.xml.xml.Chaos.Units.wingidon.mana * param4];
                  unitInfo[Unit.U_SKELATOR] = [param1.xml.xml.Chaos.Units.skelator.gold * param4,param1.xml.xml.Chaos.Units.skelator.mana * param4];
                  unitInfo[Unit.U_DEAD] = [param1.xml.xml.Chaos.Units.dead.gold * param4,param1.xml.xml.Chaos.Units.dead.mana * param4];
                  unitInfo[Unit.U_CAT] = [param1.xml.xml.Chaos.Units.cat.gold * param4,param1.xml.xml.Chaos.Units.cat.mana * param4];
                  unitInfo[Unit.U_KNIGHT] = [param1.xml.xml.Chaos.Units.knight.gold * param4,param1.xml.xml.Chaos.Units.knight.mana * param4];
                  unitInfo[Unit.U_MEDUSA] = [param1.xml.xml.Chaos.Units.medusa.gold * param4,param1.xml.xml.Chaos.Units.medusa.mana * param4];
                  unitInfo[Unit.U_GIANT] = [param1.xml.xml.Chaos.Units.giant.gold * param4,param1.xml.xml.Chaos.Units.giant.mana * param4];
                  unitInfo[Unit.U_CHAOS_MINER] = [param1.xml.xml.Chaos.Units.miner.gold * param4,param1.xml.xml.Chaos.Units.miner.mana * param4];
                  unitInfo[Unit.U_CHAOS_TOWER] = [param1.xml.xml.Order.Units.tower.gold * param4,param1.xml.xml.Order.Units.tower.mana * param4];
                  buildingHighlights = [];
                  for(_loc10_ in unitInfo)
                  {
                        (_loc11_ = param1.unitFactory.getUnit(int(_loc10_))).team = this;
                        _loc11_.setBuilding();
                        unitInfo[_loc10_].push(_loc11_.building.type);
                        unitGroups[_loc11_.type] = [];
                        param1.unitFactory.returnUnit(_loc11_.type,_loc11_);
                  }
                  this.healthModifier = param5;
            }
            
            override protected function getSpawnUnitType(param1:StickWar) : int
            {
                  if(tech.isResearched(Tech.TOWER_SPAWN_II))
                  {
                        return Unit.U_GIANT;
                  }
                  return Unit.U_KNIGHT;
            }
            
            override public function addCombinersToCastle(param1:Map) : void
            {
                  var _loc9_:MovieClip = null;
                  trace("DO CASTLE");
                  var _loc2_:Number = 864;
                  var _loc3_:Number = 622;
                  var _loc4_:Number = 1034;
                  var _loc5_:Number = 500;
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
                  _loc2_ = 1030;
                  _loc3_ = 500;
                  _loc4_ = 1220;
                  _loc5_ = 500;
                  _loc6_ = _loc2_;
                  _loc7_ = _loc3_;
                  _loc8_ = 0;
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
            }
            
            override public function getNumberOfMiners() : int
            {
                  return unitGroups[Unit.U_CHAOS_MINER].length;
            }
            
            override public function getMinerType() : int
            {
                  return Unit.U_CHAOS_MINER;
            }
            
            override public function updateStatue() : void
            {
                  if(statueType != "default")
                  {
                        statue.mc.statue.gotoAndStop(statueType);
                  }
                  else
                  {
                        statue.mc.statue.gotoAndStop("chaos");
                  }
            }
            
            override public function init() : void
            {
                  _population = 0;
                  _castleBack.x = this.homeX - this.direction * game.map.screenWidth;
                  _castleBack.y = -game.battlefield.y;
                  _castleBack.py = _castleBack.y = -game.battlefield.y;
                  _castleBack.scaleX *= this.direction;
                  _castleFront.x = this.homeX - this.direction * game.map.screenWidth;
                  _castleFront.y = -game.battlefield.y;
                  _castleFront.py = game.map.height / 2 + 40;
                  _castleFront.scaleX *= this.direction;
                  statue.x = this.homeX + direction * 500;
                  statue.py = game.map.height / 2;
                  statue.px = statue.x;
                  statue.y = statue.py;
                  statue.scaleX *= 0.8;
                  statue.scaleY *= 0.8;
                  statue.scaleX *= this.direction;
                  base.x = this.homeX - direction * game.map.screenWidth;
                  base.scaleX = direction;
                  base.py = 0;
                  base.px = base.x;
                  base.y = -game.map.y;
                  base.mouseEnabled = true;
                  castleFront.cacheAsBitmap = true;
                  castleBack.cacheAsBitmap = true;
                  statue.cacheAsBitmap = true;
                  statue.team = this;
            }
            
            override public function checkInputForSelect(param1:int, param2:*) : void
            {
                  if(param1 == 0)
                  {
                        param2(Unit.U_CHAOS_MINER);
                  }
                  else if(param1 == 1)
                  {
                        param2(Unit.U_CAT);
                  }
                  else if(param1 == 2)
                  {
                        param2(Unit.U_DEAD);
                  }
                  else if(param1 == 3)
                  {
                        param2(Unit.U_SKELATOR);
                  }
                  else if(param1 == 4)
                  {
                        param2(Unit.U_MEDUSA);
                  }
                  else if(param1 == 5)
                  {
                        param2(Unit.U_BOMBER);
                  }
                  else if(param1 == 6)
                  {
                        param2(Unit.U_KNIGHT);
                  }
                  else if(param1 == 7)
                  {
                        param2(Unit.U_WINGIDON);
                  }
                  else if(param1 == 8)
                  {
                        param2(Unit.U_GIANT);
                  }
            }
            
            override public function detectedUserInput(param1:UserInterface) : void
            {
                  singlePlayerDebugInputSwitch(param1,Unit.U_CHAOS_MINER,49);
                  singlePlayerDebugInputSwitch(param1,Unit.U_CAT,50);
                  singlePlayerDebugInputSwitch(param1,Unit.U_DEAD,51);
                  singlePlayerDebugInputSwitch(param1,Unit.U_SKELATOR,52);
                  singlePlayerDebugInputSwitch(param1,Unit.U_MEDUSA,53);
                  singlePlayerDebugInputSwitch(param1,Unit.U_BOMBER,54);
                  singlePlayerDebugInputSwitch(param1,Unit.U_KNIGHT,55);
                  singlePlayerDebugInputSwitch(param1,Unit.U_WINGIDON,56);
                  singlePlayerDebugInputSwitch(param1,Unit.U_GIANT,57);
            }
            
            override public function spawnMiners() : void
            {
                  var _loc1_:Unit = game.unitFactory.getUnit(Unit.U_CHAOS_MINER);
                  var _loc2_:Unit = game.unitFactory.getUnit(Unit.U_CHAOS_MINER);
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
                  var _loc3_:String = null;
                  var _loc4_:MovieClip = null;
                  var _loc5_:MovieClip = null;
                  var _loc6_:MovieClip = null;
                  var _loc7_:TextField = null;
                  var _loc8_:TextFormat = null;
                  var _loc2_:Dictionary = buttonInfoMap;
                  buttonInfoMap = new Dictionary();
                  buttonInfoMap[Unit.U_CHAOS_MINER] = [param1.userInterface.hud.hud.minerButton,param1.userInterface.hud.hud.minerOverlay,param1.game.xml.xml.Chaos.Units.miner,0,new cancelButton(),game.xml.xml.Chaos.Units.miner.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.bankHighlight,null];
                  buttonInfoMap[Unit.U_BOMBER] = [param1.userInterface.hud.hud.bomberButton,param1.userInterface.hud.hud.bomberOverlay,param1.game.xml.xml.Chaos.Units.bomber,0,new cancelButton(),game.xml.xml.Chaos.Units.bomber.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.barracksHighlight,param1.userInterface.hud.hud.barracksUnderlay];
                  buttonInfoMap[Unit.U_WINGIDON] = [param1.userInterface.hud.hud.wingidonButton,param1.userInterface.hud.hud.wingidonOverlay,param1.game.xml.xml.Chaos.Units.wingidon,0,new cancelButton(),game.xml.xml.Chaos.Units.wingidon.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.fletcherBuilding,param1.userInterface.hud.hud.archerUnderlay];
                  buttonInfoMap[Unit.U_SKELATOR] = [param1.userInterface.hud.hud.skeletalButton,param1.userInterface.hud.hud.skeletonOverlay,param1.game.xml.xml.Chaos.Units.skelator,0,new cancelButton(),game.xml.xml.Chaos.Units.skelator.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.skeletalHighlight,null];
                  buttonInfoMap[Unit.U_DEAD] = [param1.userInterface.hud.hud.deadButton,param1.userInterface.hud.hud.deadOverlay,param1.game.xml.xml.Chaos.Units.dead,0,new cancelButton(),game.xml.xml.Chaos.Units.dead.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.fletcherBuilding,param1.userInterface.hud.hud.archerUnderlay];
                  buttonInfoMap[Unit.U_CAT] = [param1.userInterface.hud.hud.catButton,param1.userInterface.hud.hud.catOverlay,param1.game.xml.xml.Chaos.Units.cat,0,new cancelButton(),game.xml.xml.Chaos.Units.cat.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.barracksHighlight,param1.userInterface.hud.hud.barracksUnderlay];
                  buttonInfoMap[Unit.U_KNIGHT] = [param1.userInterface.hud.hud.knightButton,param1.userInterface.hud.hud.knightOverlay,param1.game.xml.xml.Chaos.Units.knight,0,new cancelButton(),game.xml.xml.Chaos.Units.knight.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.barracksHighlight,param1.userInterface.hud.hud.barracksUnderlay];
                  buttonInfoMap[Unit.U_MEDUSA] = [param1.userInterface.hud.hud.medusaButton,param1.userInterface.hud.hud.medusaOverlay,param1.game.xml.xml.Chaos.Units.medusa,0,new cancelButton(),game.xml.xml.Chaos.Units.medusa.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.medusaHighlight,null];
                  buttonInfoMap[Unit.U_GIANT] = [param1.userInterface.hud.hud.giantButton,param1.userInterface.hud.hud.giantOverlay,param1.game.xml.xml.Chaos.Units.giant,0,new cancelButton(),game.xml.xml.Chaos.Units.giant.cost * handicap,new MovieClip(),param1.userInterface.hud.hud.giantHighlight,null];
                  buildingHighlights = [param1.userInterface.hud.hud.bankHighlight,param1.userInterface.hud.hud.barracksHighlight,param1.userInterface.hud.hud.giantHighlight,param1.userInterface.hud.hud.fletcherBuilding,param1.userInterface.hud.hud.skeletalHighlight,param1.userInterface.hud.hud.medusaHighlight,param1.userInterface.hud.hud.barracksUnderlay,param1.userInterface.hud.hud.archerUnderlay];
                  for(_loc3_ in buttonInfoMap)
                  {
                        _loc4_ = buttonInfoMap[_loc3_][1];
                        (_loc5_ = buttonInfoMap[_loc3_][0]).addChild(buttonInfoMap[_loc3_][6]);
                        if(Boolean(_loc2_) && _loc3_ in _loc2_)
                        {
                              buttonInfoMap[_loc3_][3] = _loc2_[_loc3_][3];
                        }
                        (_loc6_ = buttonInfoMap[_loc3_][4]).x = _loc5_.x + _loc5_.width - _loc6_.width;
                        _loc6_.y = _loc5_.y;
                        param1.userInterface.hud.hud.addChild(_loc6_);
                        _loc6_.visible = false;
                        (_loc7_ = new TextField()).name = "number";
                        _loc8_ = new TextFormat(null,20,16777215);
                        _loc7_.defaultTextFormat = _loc8_;
                        _loc7_.width = 25;
                        _loc7_.height = 25;
                        _loc7_.x = 25;
                        _loc7_.y = 15;
                        _loc7_.selectable = false;
                        _loc7_.text = "0";
                        _loc5_.addChild(_loc7_);
                  }
            }
      }
}
