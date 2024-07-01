package com.brockw.stickwar.singleplayer
{
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.campaign.Campaign;
      import com.brockw.stickwar.campaign.CampaignGameScreen;
      import com.brockw.stickwar.engine.Ai.RangedAi;
      import com.brockw.stickwar.engine.Ai.command.NukeCommand;
      import com.brockw.stickwar.engine.Ai.command.PoisonDartCommand;
      import com.brockw.stickwar.engine.Ai.command.StunCommand;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.Team.TechItem;
      import com.brockw.stickwar.engine.units.Archer;
      import com.brockw.stickwar.engine.units.Magikill;
      import com.brockw.stickwar.engine.units.Ninja;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.utils.Dictionary;
      
      public class EnemyGoodTeamAi extends EnemyTeamAi
      {
             
            
            private var buildOrder:Array;
            
            private var nukeSpell:NukeCommand;
            
            private var electricWallSpell:StunCommand;
            
            private var poisonSpell:PoisonDartCommand;
            
            public function EnemyGoodTeamAi(param1:Team, param2:BaseMain, param3:StickWar, param4:* = true)
            {
                  var _loc6_:int = 0;
                  unitComposition = new Dictionary();
                  unitComposition[Unit.U_MINER] = param2.campaign.xml.Order.UnitComposition.Miner;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Miner) != "")
                  {
                        unitComposition[Unit.U_MINER] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Miner);
                  }
                  unitComposition[Unit.U_SWORDWRATH] = param2.campaign.xml.Order.UnitComposition.Swordwrath;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Swordwrath) != "")
                  {
                        unitComposition[Unit.U_SWORDWRATH] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Swordwrath);
                  }
                  unitComposition[Unit.U_ARCHER] = param2.campaign.xml.Order.UnitComposition.Archidon;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Archidon) != "")
                  {
                        unitComposition[Unit.U_ARCHER] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Archidon);
                  }
                  unitComposition[Unit.U_SPEARTON] = param2.campaign.xml.Order.UnitComposition.Spearton;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Spearton) != "")
                  {
                        unitComposition[Unit.U_SPEARTON] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Spearton);
                  }
                  unitComposition[Unit.U_NINJA] = param2.campaign.xml.Order.UnitComposition.Ninja;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Ninja) != "")
                  {
                        unitComposition[Unit.U_NINJA] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Ninja);
                  }
                  unitComposition[Unit.U_FLYING_CROSSBOWMAN] = param2.campaign.xml.Order.UnitComposition.FlyingCrossbowman;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.FlyingCrossbowman) != "")
                  {
                        unitComposition[Unit.U_FLYING_CROSSBOWMAN] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.FlyingCrossbowman);
                  }
                  unitComposition[Unit.U_MONK] = param2.campaign.xml.Order.UnitComposition.Monk;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Monk) != "")
                  {
                        unitComposition[Unit.U_MONK] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Monk);
                  }
                  unitComposition[Unit.U_MAGIKILL] = param2.campaign.xml.Order.UnitComposition.Magikill;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Magikill) != "")
                  {
                        unitComposition[Unit.U_MAGIKILL] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Magikill);
                  }
                  unitComposition[Unit.U_ENSLAVED_GIANT] = param2.campaign.xml.Order.UnitComposition.EnslavedGiant;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.EnslavedGiant) != "")
                  {
                        unitComposition[Unit.U_ENSLAVED_GIANT] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.EnslavedGiant);
                  }
                  var _loc5_:* = [Unit.U_ENSLAVED_GIANT,Unit.U_MAGIKILL,Unit.U_FLYING_CROSSBOWMAN,Unit.U_SPEARTON,Unit.U_SWORDWRATH,Unit.U_ARCHER,Unit.U_MONK,Unit.U_NINJA];
                  this.buildOrder = [];
                  for each(_loc6_ in _loc5_)
                  {
                        if(param1.unitsAvailable == null || _loc6_ in param1.unitsAvailable)
                        {
                              this.buildOrder.push(_loc6_);
                        }
                  }
                  this.nukeSpell = new NukeCommand(param3);
                  this.electricWallSpell = new StunCommand(param3);
                  this.poisonSpell = new PoisonDartCommand(param3);
                  super(param1,param2,param3,param4);
            }
            
            override public function update(param1:StickWar) : void
            {
                  super.update(param1);
            }
            
            override protected function isArmyHealers() : Boolean
            {
                  var _loc1_:int = 0;
                  if(Unit.U_MONK in unitComposition)
                  {
                        _loc1_ = int(unitComposition[Unit.U_MONK]);
                  }
                  if(_loc1_ * team.game.xml.xml.Order.Units.monk.population == team.attackingForcePopulation)
                  {
                        return true;
                  }
                  return false;
            }
            
            override protected function updateUnitCreation(param1:StickWar) : void
            {
                  var _loc3_:int = 0;
                  var _loc4_:int = 0;
                  var _loc5_:TechItem = null;
                  if(!enemyIsAttacking() && (team.population < 6 || enemyIsWeak()))
                  {
                        if((_loc4_ = int(team.unitGroups[Unit.U_MINER].length)) < unitComposition[Unit.U_MINER] && team.unitProductionQueue[team.unitInfo[Unit.U_MINER][2]].length == 0)
                        {
                              param1.requestToSpawn(team.id,Unit.U_MINER);
                        }
                  }
                  var _loc2_:int = 0;
                  _loc3_ = 0;
                  while(_loc3_ < this.buildOrder.length)
                  {
                        if((_loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length)) >= unitComposition[this.buildOrder[_loc3_]])
                        {
                              _loc2_++;
                        }
                        else if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
                        {
                              param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
                        }
                        _loc3_++;
                  }
                  if(_loc2_ >= this.buildOrder.length)
                  {
                        _loc3_ = 0;
                        while(_loc3_ < this.buildOrder.length)
                        {
                              _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
                              if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
                              {
                                    param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
                              }
                              _loc3_++;
                        }
                  }
                  if(!(this.team.game.gameScreen is CampaignGameScreen) || team.game.main.campaign.currentLevel != 0)
                  {
                        if(!team.tech.isResearched(Tech.CASTLE_ARCHER_1))
                        {
                              if((_loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_1]) == null)
                              {
                                    return;
                              }
                              if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
                              {
                                    team.tech.startResearching(Tech.CASTLE_ARCHER_1);
                              }
                        }
                        else if(!team.tech.isResearched(Tech.CASTLE_ARCHER_2) && team.game.main.campaign.difficultyLevel > Campaign.D_NORMAL)
                        {
                              if((_loc5_ = team.tech.upgrades[Tech.CASTLE_ARCHER_2]) == null)
                              {
                                    return;
                              }
                              if(_loc5_.cost < team.gold && _loc5_.mana < team.mana)
                              {
                                    team.tech.startResearching(Tech.CASTLE_ARCHER_2);
                              }
                        }
                  }
            }
            
            override protected function updateSpellCasters(param1:StickWar) : void
            {
                  var _loc2_:* = team.mana;
                  team.mana = 1000;
                  this.updateMagikill(param1);
                  this.updateArchers(param1);
                  this.updateNinjas(param1);
                  team.tech.isResearchedMap[Tech.CLOAK] = true;
                  team.tech.isResearchedMap[Tech.CLOAK_II] = true;
                  team.tech.isResearchedMap[Tech.MINER_SPEED] = true;
                  team.tech.isResearchedMap[Tech.MONK_CURE] = true;
                  team.tech.isResearchedMap[Tech.BANK_PASSIVE_1] = true;
                  team.tech.isResearchedMap[Tech.BANK_PASSIVE_2] = true;
                  team.mana = _loc2_;
            }
            
            private function updateArchers(param1:StickWar) : void
            {
                  var _loc2_:Archer = null;
                  for each(_loc2_ in team.unitGroups[Unit.U_ARCHER])
                  {
                        if(_loc2_.ai.currentTarget != null)
                        {
                              RangedAi(_loc2_.ai).mayKite = true;
                        }
                  }
            }
            
            private function updateNinjas(param1:StickWar) : void
            {
                  var _loc2_:Ninja = null;
                  var _loc3_:Unit = null;
                  team.tech.isResearchedMap[Tech.CLOAK] = true;
                  team.mana = 500;
                  for each(_loc2_ in team.unitGroups[Unit.U_NINJA])
                  {
                        _loc3_ = _loc2_.ai.getClosestTarget();
                        if(_loc3_ != null && _loc3_.isAlive())
                        {
                              if(Math.abs(_loc3_.px - _loc2_.px) < 100)
                              {
                                    _loc2_.stealth();
                              }
                        }
                  }
            }
            
            private function updateMagikill(param1:StickWar) : void
            {
                  var _loc2_:Magikill = null;
                  var _loc3_:Unit = null;
                  for each(_loc2_ in team.unitGroups[Unit.U_MAGIKILL])
                  {
                        _loc3_ = _loc2_.ai.getClosestTarget();
                        if(_loc3_)
                        {
                              if(_loc2_.poisonDartCooldown() == 0)
                              {
                                    this.poisonSpell.realX = _loc3_.px;
                                    this.poisonSpell.realY = _loc3_.py;
                                    if(this.poisonSpell.inRange(_loc2_))
                                    {
                                          _loc2_.poisonDartSpell(_loc3_.px,_loc3_.py);
                                    }
                              }
                              else if(_loc2_.stunCooldown() == 0)
                              {
                                    this.electricWallSpell.realX = _loc3_.px;
                                    this.electricWallSpell.realY = _loc3_.py;
                                    if(this.electricWallSpell.inRange(_loc2_))
                                    {
                                          _loc2_.stunSpell(_loc3_.px,_loc3_.py);
                                    }
                              }
                              else if(_loc2_.nukeCooldown() == 0)
                              {
                                    this.nukeSpell.realX = _loc3_.px;
                                    this.nukeSpell.realY = _loc3_.py;
                                    if(this.nukeSpell.inRange(_loc2_))
                                    {
                                          _loc2_.nukeSpell(_loc3_.px,_loc3_.py);
                                    }
                              }
                        }
                  }
            }
      }
}
