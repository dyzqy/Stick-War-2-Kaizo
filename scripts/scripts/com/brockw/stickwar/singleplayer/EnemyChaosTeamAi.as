package com.brockw.stickwar.singleplayer
{
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.campaign.Campaign;
      import com.brockw.stickwar.engine.Ai.RangedAi;
      import com.brockw.stickwar.engine.Ai.command.FistAttackCommand;
      import com.brockw.stickwar.engine.Ai.command.PoisonPoolCommand;
      import com.brockw.stickwar.engine.Ai.command.ReaperCommand;
      import com.brockw.stickwar.engine.Ai.command.StoneCommand;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.Team.TechItem;
      import com.brockw.stickwar.engine.units.Dead;
      import com.brockw.stickwar.engine.units.Giant;
      import com.brockw.stickwar.engine.units.Knight;
      import com.brockw.stickwar.engine.units.Medusa;
      import com.brockw.stickwar.engine.units.Skelator;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.utils.Dictionary;
      
      public class EnemyChaosTeamAi extends EnemyTeamAi
      {
             
            
            private var buildOrder:Array;
            
            private var fistAttackSpell:FistAttackCommand;
            
            private var reaperSpell:ReaperCommand;
            
            private var poisonPoolSpell:PoisonPoolCommand;
            
            private var stoneSpell:StoneCommand;
            
            public function EnemyChaosTeamAi(param1:Team, param2:BaseMain, param3:StickWar, param4:* = true)
            {
                  var _loc6_:int = 0;
                  this.fistAttackSpell = new FistAttackCommand(param3);
                  this.reaperSpell = new ReaperCommand(param3);
                  this.poisonPoolSpell = new PoisonPoolCommand(param3);
                  this.stoneSpell = new StoneCommand(param3);
                  unitComposition = new Dictionary();
                  unitComposition[Unit.U_CHAOS_MINER] = param2.campaign.xml.Chaos.UnitComposition.ChaosMiner;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.ChaosMiner) != "")
                  {
                        unitComposition[Unit.U_CHAOS_MINER] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.ChaosMiner);
                  }
                  unitComposition[Unit.U_BOMBER] = param2.campaign.xml.Chaos.UnitComposition.Bomber;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Bomber) != "")
                  {
                        unitComposition[Unit.U_BOMBER] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Bomber);
                  }
                  unitComposition[Unit.U_WINGIDON] = param2.campaign.xml.Chaos.UnitComposition.Wingadon;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Wingadon) != "")
                  {
                        unitComposition[Unit.U_WINGIDON] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Wingadon);
                  }
                  unitComposition[Unit.U_SKELATOR] = param2.campaign.xml.Chaos.UnitComposition.SkelatalMage;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.SkelatalMage) != "")
                  {
                        unitComposition[Unit.U_SKELATOR] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.SkelatalMage);
                  }
                  unitComposition[Unit.U_DEAD] = param2.campaign.xml.Chaos.UnitComposition.Dead;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Dead) != "")
                  {
                        unitComposition[Unit.U_DEAD] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Dead);
                  }
                  unitComposition[Unit.U_CAT] = param2.campaign.xml.Chaos.UnitComposition.Cat;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Cat) != "")
                  {
                        unitComposition[Unit.U_CAT] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Cat);
                  }
                  unitComposition[Unit.U_KNIGHT] = param2.campaign.xml.Chaos.UnitComposition.Knight;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Knight) != "")
                  {
                        unitComposition[Unit.U_KNIGHT] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Knight);
                  }
                  unitComposition[Unit.U_MEDUSA] = param2.campaign.xml.Chaos.UnitComposition.Medusa;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Medusa) != "")
                  {
                        unitComposition[Unit.U_MEDUSA] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Medusa);
                  }
                  unitComposition[Unit.U_GIANT] = param2.campaign.xml.Chaos.UnitComposition.Giant;
                  if(String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Giant) != "")
                  {
                        unitComposition[Unit.U_GIANT] = String(param2.campaign.getCurrentLevel().levelXml.oponent.UnitComposition.Giant);
                  }
                  var _loc5_:* = [Unit.U_GIANT,Unit.U_MEDUSA,Unit.U_KNIGHT,Unit.U_CAT,Unit.U_DEAD,Unit.U_SKELATOR,Unit.U_WINGIDON,Unit.U_BOMBER];
                  this.buildOrder = [];
                  for each(_loc6_ in _loc5_)
                  {
                        if(param1.unitsAvailable == null || _loc6_ in param1.unitsAvailable)
                        {
                              this.buildOrder.push(_loc6_);
                        }
                  }
                  super(param1,param2,param3,param4);
            }
            
            override public function update(param1:StickWar) : void
            {
                  super.update(param1);
            }
            
            override protected function updateUnitCreation(param1:StickWar) : void
            {
                  var _loc3_:int = 0;
                  var _loc4_:int = 0;
                  var _loc5_:TechItem = null;
                  if(!enemyIsAttacking() && (team.population < 6 || this.enemyAtHome()))
                  {
                        if((_loc4_ = int(team.unitGroups[Unit.U_CHAOS_MINER].length)) < unitComposition[Unit.U_CHAOS_MINER] && team.unitProductionQueue[team.unitInfo[Unit.U_CHAOS_MINER][2]].length == 0)
                        {
                              param1.requestToSpawn(team.id,Unit.U_CHAOS_MINER);
                        }
                  }
                  var _loc2_:int = 0;
                  _loc3_ = 0;
                  while(_loc3_ < this.buildOrder.length)
                  {
                        _loc4_ = int(team.unitGroups[this.buildOrder[_loc3_]].length);
                        if(!(this.buildOrder[_loc3_] == Unit.U_BOMBER && team.attackingForcePopulation < 6))
                        {
                              if(_loc4_ >= unitComposition[this.buildOrder[_loc3_]])
                              {
                                    _loc2_++;
                              }
                              else if(team.unitProductionQueue[team.unitInfo[this.buildOrder[_loc3_]][2]].length == 0)
                              {
                                    param1.requestToSpawn(team.id,this.buildOrder[_loc3_]);
                              }
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
            
            override protected function updateSpellCasters(param1:StickWar) : void
            {
                  var _loc2_:* = team.mana;
                  team.mana = 1000;
                  this.updateKnights(param1);
                  this.updateDeads(param1);
                  this.updateSkelator(param1);
                  this.updateMedusa(param1);
                  if(param1.main.campaign.difficultyLevel == Campaign.D_INSANE)
                  {
                        team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_I] = true;
                        team.tech.isResearchedMap[Tech.CHAOS_GIANT_GROWTH_II] = true;
                        team.tech.isResearchedMap[Tech.CAT_SPEED] = true;
                        team.tech.isResearchedMap[Tech.CAT_PACK] = true;
                  }
                  team.mana = _loc2_;
            }
            
            private function updateDeads(param1:StickWar) : void
            {
                  var _loc2_:Dead = null;
                  team.tech.isResearchedMap[Tech.DEAD_POISON] = true;
                  for each(_loc2_ in team.unitGroups[Unit.U_DEAD])
                  {
                        if(!_loc2_.isPoisonedToggled)
                        {
                              _loc2_.togglePoison();
                        }
                        if(_loc2_.ai.currentTarget != null)
                        {
                              RangedAi(_loc2_.ai).mayKite = true;
                        }
                  }
            }
            
            private function updateGiants(param1:StickWar) : void
            {
                  var _loc2_:Giant = null;
                  for each(_loc2_ in team.unitGroups[Unit.U_GIANT])
                  {
                        if(_loc2_.ai.currentTarget != null)
                        {
                              if(Math.abs(team.enemyTeam.statue.px - _loc2_.px) < 200)
                              {
                                    _loc2_.ai.currentTarget = team.enemyTeam.statue;
                              }
                              else if(team.direction * _loc2_.ai.currentTarget.px < team.direction * (_loc2_.px + -team.direction * 150))
                              {
                                    _loc2_.ai.currentTarget = null;
                                    _loc2_.walk(team.direction,0,team.direction);
                              }
                        }
                  }
            }
            
            private function updateKnights(param1:StickWar) : void
            {
                  var _loc2_:Knight = null;
                  var _loc3_:Unit = null;
                  team.tech.isResearchedMap[Tech.KNIGHT_CHARGE] = true;
                  for each(_loc2_ in team.unitGroups[Unit.U_KNIGHT])
                  {
                        _loc3_ = _loc2_.ai.getClosestTarget();
                        if(_loc3_ != null && _loc3_.isAlive())
                        {
                              if(Math.abs(_loc3_.px - _loc2_.px) < 400)
                              {
                                    _loc2_.charge();
                              }
                        }
                  }
            }
            
            private function updateMedusa(param1:StickWar) : void
            {
                  var _loc2_:Medusa = null;
                  var _loc3_:Unit = null;
                  team.tech.isResearchedMap[Tech.MEDUSA_POISON] = true;
                  for each(_loc2_ in team.unitGroups[Unit.U_MEDUSA])
                  {
                        _loc3_ = _loc2_.ai.getClosestTarget();
                        if(_loc3_)
                        {
                              if(_loc2_.stoneCooldown() == 0)
                              {
                                    this.stoneSpell.realX = _loc3_.px;
                                    this.stoneSpell.realY = _loc3_.py;
                                    this.stoneSpell.targetId = _loc3_.id;
                                    if(this.stoneSpell.inRange(_loc2_))
                                    {
                                          _loc2_.stone(_loc3_);
                                    }
                              }
                              else if(_loc2_.poisonPoolCooldown() == 0)
                              {
                                    this.poisonPoolSpell.realX = _loc3_.px;
                                    this.poisonPoolSpell.realY = _loc3_.py;
                                    if(this.poisonPoolSpell.inRange(_loc2_))
                                    {
                                          _loc2_.poisonSpray();
                                    }
                              }
                        }
                  }
            }
            
            private function updateSkelator(param1:StickWar) : void
            {
                  var _loc2_:Skelator = null;
                  var _loc3_:Unit = null;
                  team.tech.isResearchedMap[Tech.SKELETON_FIST_ATTACK] = true;
                  for each(_loc2_ in team.unitGroups[Unit.U_SKELATOR])
                  {
                        _loc3_ = _loc2_.ai.getClosestTarget();
                        if(_loc3_)
                        {
                              if(_loc2_.fistAttackCooldown() == 0)
                              {
                                    this.fistAttackSpell.realX = _loc3_.px;
                                    this.fistAttackSpell.realY = _loc3_.py;
                                    if(this.fistAttackSpell.inRange(_loc2_))
                                    {
                                          _loc2_.fistAttack(_loc3_.px,_loc3_.py);
                                    }
                              }
                              else if(_loc2_.reaperCooldown() == 0)
                              {
                                    this.reaperSpell.targetId = _loc3_.id;
                                    this.reaperSpell.realX = _loc3_.px;
                                    this.reaperSpell.realY = _loc3_.py;
                                    if(this.reaperSpell.inRange(_loc2_))
                                    {
                                          _loc2_.reaperAttack(_loc3_);
                                    }
                              }
                        }
                  }
            }
      }
}
