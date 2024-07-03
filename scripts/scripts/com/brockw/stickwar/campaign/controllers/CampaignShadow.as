package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.CampaignGameScreen;
      import com.brockw.stickwar.campaign.InGameMessage;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.units.Archer;
      import com.brockw.stickwar.engine.units.Magikill;
      import com.brockw.stickwar.engine.units.Miner;
      import com.brockw.stickwar.engine.units.Monk;
      import com.brockw.stickwar.engine.units.Ninja;
      import com.brockw.stickwar.engine.units.Spearton;
      import com.brockw.stickwar.engine.units.Statue;
      import com.brockw.stickwar.engine.units.Swordwrath;
      import com.brockw.stickwar.engine.units.Unit;
      
      public class CampaignShadow extends CampaignController
      {
             
            
            private var message:InGameMessage;
            
            private var frames:int;
            
            private var twoMinTimer:int;
            
            private var threeMinTimer:int;
            
            private var twoMinConstant:int;
            
            private var threeMinConstant:int;
            
            internal var flag:* = false;
            
            public function CampaignShadow(param1:GameScreen)
            {
                  this.twoMinTimer = 60 * 30 * 2;
                  this.threeMinTimer = 60 * 30 * 3;
                  this.twoMinConstant = this.twoMinTimer;
                  this.threeMinConstant = this.threeMinTimer;
                  super(param1);
                  this.frames = 0;
                  this.respect = 0.6;
            }
            
            override public function update(param1:GameScreen) : void
            {
                  if(this.currentLevelNumber == 4)
                  {
                        this.updateMagikill(param1);
                  }
                  else if(this.currentLevelNumber == 5)
                  {
                        this.updateWestwind(param1);
                  }
            }
            
            public function updateMagikill(param1:GameScreen) : void
            {
                  var _loc2_:Unit = null;
                  var spear:Spearton = null;
                  var shadow:Ninja = null;
                  var archer:Archer = null;
                  var miner:Miner = null;
                  var magikill:Magikill = null;
                  var monk:Monk = null;
                  var enemyStatue:Statue = param1.team.enemyTeam.statue;
                  param1.isFastForward = false;
                  param1.userInterface.hud.hud.fastForward.visible = false;
                  if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
                  {
                        enemyStatue.protect(600);
                        enemyStatue.health += 1300;
                        enemyStatue.maxHealth = 2000;
                        enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                        this.SummonSpearton(spear,param1,1,param1.team.enemyTeam,true,"");
                        this.SummonArcher(archer,param1,3,param1.team.enemyTeam,true,"");
                        this.SummonNinja(shadow,param1,1,param1.team.enemyTeam,true);
                        this.SummonMagikill(magikill,param1,5,param1.team.enemyTeam,true);
                        this.SummonMonk(monk,param1,3,param1.team.enemyTeam,true);
                        this.SummonMiner(miner,param1,6,param1.team.enemyTeam,true);
                        this.reinforcements = true;
                        this.respect = 0.001;
                  }
                  if(this.message && param1.contains(this.message))
                  {
                        this.message.update();
                        if(this.frames++ > 30 * 5)
                        {
                              param1.removeChild(this.message);
                        }
                  }
                  else if(!this.message)
                  {
                        this.message = new InGameMessage("",param1.game);
                        this.message.x = param1.game.stage.stageWidth / 2;
                        this.message.y = param1.game.stage.stageHeight / 4 - 75;
                        this.message.scaleX *= 1.3;
                        this.message.scaleY *= 1;
                        param1.addChild(this.message);
                        this.message.setMessage("The true source of power...","");
                        this.frames = 0;
                  }
                  CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
                  if(param1.game.frame % (30 * 90) == 0 && this.flag)
                  {
                        this.SummonNinja(ninja,param1,1,param1.team.enemyTeam,true);
                  }
                  this.flag = true;
                  if(this.threeMinTimer > 0)
                  {
                        if(!param1.isPaused)
                        {
                              if(param1.isFastForward)
                              {
                                    --this.threeMinTimer;
                              }
                              --this.threeMinTimer;
                        }
                  }
                  else if(this.threeMinTimer != -5)
                  {
                        param1.game.team.enemyTeam.tech.isResearchedMap[Tech.SPAWN_MAGE] = true;
                        this.threeMinTimer = -5;
                  }
            }
            
            public function updateWestwind(param1:GameScreen) : void
            {
                  var _loc2_:Unit = null;
                  var sword:Swordwrath = null;
                  var spear:Spearton = null;
                  var shadow:Ninja = null;
                  var archer:Archer = null;
                  var miner:Miner = null;
                  var magikill:Magikill = null;
                  var monk:Monk = null;
                  param1.game.team.enemyTeam.tech.isResearchedMap[Tech.MAGIKILL_POISON] = true;
                  param1.game.team.enemyTeam.tech.isResearchedMap[Tech.MAGIKILL_WALL] = true;
                  param1.isFastForward = false;
                  param1.userInterface.hud.hud.fastForward.visible = false;
                  var enemyStatue:Statue = param1.team.enemyTeam.statue;
                  if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
                  {
                        enemyStatue.protect(600);
                        enemyStatue.health += 1300;
                        enemyStatue.maxHealth = 2000;
                        enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                        this.SummonSwordwrath(sword,param1,1,param1.team.enemyTeam,true,"Leader");
                        this.SummonSpearton(spear,param1,1,param1.team.enemyTeam,true,"Leader");
                        this.SummonArcher(archer,param1,1,param1.team.enemyTeam,true,"Leader");
                        this.SummonArcher(archer,param1,5,param1.team.enemyTeam,true,"");
                        this.SummonSpearton(spear,param1,4,param1.team.enemyTeam,true,"");
                        this.SummonNinja(shadow,param1,2,param1.team.enemyTeam,true);
                        this.SummonMagikill(magikill,param1,3,param1.team.enemyTeam,true);
                        this.SummonMonk(monk,param1,2,param1.team.enemyTeam,true);
                        this.SummonMiner(miner,param1,6,param1.team.enemyTeam,true);
                        this.respect = 0.001;
                        this.reinforcements = true;
                  }
                  if(this.message && param1.contains(this.message))
                  {
                        this.message.update();
                        if(this.frames++ > 30 * 5)
                        {
                              param1.removeChild(this.message);
                        }
                  }
                  else if(!this.message)
                  {
                        this.message = new InGameMessage("",param1.game);
                        this.message.x = param1.game.stage.stageWidth / 2;
                        this.message.y = param1.game.stage.stageHeight / 4 - 75;
                        this.message.scaleX *= 1.3;
                        this.message.scaleY *= 1;
                        param1.addChild(this.message);
                        this.message.setMessage("Their last stand... or is it yours?","");
                        this.frames = 0;
                  }
                  CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
                  param1.game.team.enemyTeam.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
                  if(param1.game.frame % (30 * 60) == 0 && this.flag)
                  {
                        this.SummonNinja(ninja,param1,1,param1.team.enemyTeam,true);
                  }
                  this.flag = true;
                  if(this.twoMinTimer > 0)
                  {
                        if(!param1.isPaused)
                        {
                              if(param1.isFastForward)
                              {
                                    --this.twoMinTimer;
                              }
                              --this.twoMinTimer;
                        }
                  }
                  else if(this.twoMinTimer != -5)
                  {
                        param1.game.team.enemyTeam.tech.isResearchedMap[Tech.SPAWN_MAGE] = true;
                        this.twoMinTimer = -5;
                  }
            }
            
            public function SummonSwordwrath(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean, name:String) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.population <= 78 || ignorePop)
                        {
                              u1 = Swordwrath(param1.game.unitFactory.getUnit(Unit.U_SWORDWRATH));
                              u1.swordwrathType = name;
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 2;
                              i++;
                        }
                  }
            }
            
            public function SummonSpearton(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean, name:String) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.population <= 77 || ignorePop)
                        {
                              u1 = Spearton(param1.game.unitFactory.getUnit(Unit.U_SPEARTON));
                              u1.speartonType = name;
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 3;
                              i++;
                        }
                  }
            }
            
            public function SummonArcher(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean, name:String) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.population <= 78 || ignorePop)
                        {
                              u1 = Archer(param1.game.unitFactory.getUnit(Unit.U_ARCHER));
                              u1.archerType = name;
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 2;
                              i++;
                        }
                  }
            }
            
            public function SummonNinja(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.population <= 76 || ignorePop)
                        {
                              u1 = Ninja(param1.game.unitFactory.getUnit(Unit.U_NINJA));
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 4;
                              i++;
                        }
                  }
            }
            
            public function SummonMiner(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.enemyTeam.population <= 79 || ignorePop)
                        {
                              u1 = Miner(param1.game.unitFactory.getUnit(Unit.U_MINER));
                              teamSpawn.spawn(u1,param1.game);
                              ++teamSpawn.population;
                              i++;
                        }
                  }
            }
            
            public function SummonMonk(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.enemyTeam.population <= 77 || ignorePop)
                        {
                              u1 = Monk(param1.game.unitFactory.getUnit(Unit.U_MONK));
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 3;
                              i++;
                        }
                  }
            }
            
            public function SummonMagikill(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
            {
                  var i:int = 0;
                  while(i < copies)
                  {
                        if(teamSpawn.enemyTeam.population <= 75 || ignorePop)
                        {
                              u1 = Magikill(param1.game.unitFactory.getUnit(Unit.U_MAGIKILL));
                              teamSpawn.spawn(u1,param1.game);
                              teamSpawn.population += 5;
                              i++;
                        }
                  }
            }
      }
}
