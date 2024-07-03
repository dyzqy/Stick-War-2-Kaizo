package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.CampaignGameScreen;
      import com.brockw.stickwar.campaign.InGameMessage;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.units.Archer;
      import com.brockw.stickwar.engine.units.Miner;
      import com.brockw.stickwar.engine.units.Ninja;
      import com.brockw.stickwar.engine.units.Spearton;
      import com.brockw.stickwar.engine.units.Statue;
      import com.brockw.stickwar.engine.units.Unit;
      
      public class CampaignArcher extends CampaignController
      {
             
            
            private var message:InGameMessage;
            
            private var frames:int;
            
            internal var state:int = 0;
            
            internal var S_BEFORE:int = 0;
            
            internal var S_SELECT:int = 1;
            
            internal var S_HILL:int = 2;
            
            internal var S_DONE:int = 2;
            
            internal var flag:* = false;
            
            public function CampaignArcher(param1:GameScreen)
            {
                  super(param1);
                  this.twoMinTimer = 60 * 30 * 3;
                  this.twoMinConstant = this.twoMinTimer;
                  this.frames = 0;
                  this.state = this.S_BEFORE;
                  this.respect - 0.6;
                  this.twoMinTimer = 60 * 30 * 3;
            }
            
            override public function update(param1:GameScreen) : void
            {
                  if(this.currentLevelNumber == 3)
                  {
                        this.updateNinja(param1);
                  }
                  else if(this.currentLevelNumber == 2)
                  {
                        this.updateArcher(param1);
                  }
            }
            
            public function updateNinja(param1:GameScreen) : void
            {
                  var _loc2_:Unit = null;
                  var spear:Spearton = null;
                  var shadow:Ninja = null;
                  var archer:Archer = null;
                  var miner:Miner = null;
                  var enemyStatue:Statue = null;
                  param1.isFastForward = false;
                  param1.userInterface.hud.hud.fastForward.visible = false;
                  enemyStatue = param1.team.enemyTeam.statue;
                  if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
                  {
                        enemyStatue.protect(600);
                        enemyStatue.health += 1300;
                        enemyStatue.maxHealth = 2000;
                        enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                        this.SummonSpearton(spear,param1,1,param1.team.enemyTeam,true,"");
                        this.SummonArcher(archer,param1,3,param1.team.enemyTeam,true,"");
                        this.SummonNinja(shadow,param1,8,param1.team.enemyTeam,true);
                        this.SummonMiner(miner,param1,6,param1.team.enemyTeam,true);
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
                        this.message.setMessage("Peek-a-Boo!","");
                        this.frames = 0;
                  }
                  CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
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
                  if(param1.game.frame % (30 * 90) == 0 && this.flag)
                  {
                        this.SummonSpearton(spear,param1,1,param1.team.enemyTeam,true,"");
                  }
                  else if(this.twoMinTimer != -5)
                  {
                        param1.game.team.enemyTeam.tech.isResearchedMap[Tech.SPAWN_SHADOW] = true;
                        this.twoMinTimer = -5;
                  }
                  this.flag = true;
            }
            
            public function updateArcher(param1:GameScreen) : void
            {
                  var spear:Spearton = null;
                  var archer:Archer = null;
                  var miner:Miner = null;
                  var enemyStatue:Statue = null;
                  param1.isFastForward = false;
                  param1.userInterface.hud.hud.fastForward.visible = false;
                  enemyStatue = param1.team.enemyTeam.statue;
                  if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
                  {
                        enemyStatue.protect(600);
                        enemyStatue.health += 1300;
                        enemyStatue.maxHealth = 2000;
                        enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
                        this.SummonSpearton(spear,param1,1,param1.team.enemyTeam,true,"");
                        this.SummonArcher(archer,param1,12,param1.team.enemyTeam,true,"");
                        this.SummonMiner(miner,param1,1,param1.team.enemyTeam,true);
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
                        this.message.setMessage("There\'s a chill in the air","");
                        this.frames = 0;
                  }
                  CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
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
      }
}
