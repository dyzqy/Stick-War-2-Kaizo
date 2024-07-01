package com.brockw.stickwar.missions
{
      import com.brockw.game.*;
      import com.brockw.simulationSync.*;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.campaign.*;
      import com.brockw.stickwar.campaign.controllers.CampaignController;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.singleplayer.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      
      public class MissionGameScreen extends GameScreen
      {
             
            
            private var enemyTeamAi:EnemyTeamAi;
            
            private var controller:CampaignController;
            
            private var level:Level;
            
            private var missionId:*;
            
            public function MissionGameScreen(param1:BaseMain)
            {
                  super(param1);
            }
            
            public function setMission(param1:int, param2:String) : void
            {
                  this.missionId = this.missionId;
                  var _loc3_:XML = new XML(param2);
                  this.level = new Level(_loc3_);
            }
            
            override public function enter() : void
            {
                  var _loc1_:int = 0;
                  var _loc2_:int = 0;
                  var _loc7_:CampaignUpgrade = null;
                  var _loc8_:Wall = null;
                  var _loc9_:ChaosTower = null;
                  this.controller = null;
                  if(!main.stickWar)
                  {
                        main.stickWar = new StickWar(main,this);
                  }
                  game = main.stickWar;
                  simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
                  simulation.init(0);
                  this.addChild(game);
                  game.initGame(main,this,this.level.mapName);
                  userInterface = new UserInterface(main,this);
                  addChild(userInterface);
                  _loc1_ = 0;
                  _loc2_ = 1;
                  var _loc3_:Number = Number(this.level.normalModifier);
                  if(main.campaign.difficultyLevel == Campaign.D_HARD)
                  {
                        _loc3_ = Number(this.level.hardModifier);
                  }
                  else if(main.campaign.difficultyLevel == Campaign.D_INSANE)
                  {
                        _loc3_ = Number(this.level.insaneModifier);
                  }
                  var _loc4_:Number = 1;
                  if(main.campaign.difficultyLevel == 1)
                  {
                        _loc4_ = Number(this.level.normalHealthScale);
                  }
                  var _loc5_:Number = 1;
                  if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                  {
                        _loc5_ = Number(this.level.normalDamageModifier);
                  }
                  if(this.level.player.unitsAvailable[Unit.U_NINJA])
                  {
                        (_loc7_ = CampaignUpgrade(main.campaign.upgradeMap["Cloak_BASIC"])).upgraded = true;
                        main.campaign.techAllowed[Tech.CLOAK] = 1;
                  }
                  game.initTeams(Team.getIdFromRaceName(this.level.player.race),Team.getIdFromRaceName(this.level.oponent.race),this.level.player.statueHealth,this.level.oponent.statueHealth,main.campaign.techAllowed,null,1,this.level.insaneModifier,1,_loc4_,1,_loc5_);
                  team = game.teamA;
                  game.team = team;
                  game.teamA.id = _loc1_;
                  game.teamB.id = _loc2_;
                  game.teamA.unitsAvailable = this.level.player.unitsAvailable;
                  game.teamB.unitsAvailable = this.level.oponent.unitsAvailable;
                  game.teamA.name = _loc1_;
                  game.teamB.name = _loc2_;
                  this.team.enemyTeam.isEnemy = true;
                  this.team.enemyTeam.isAi = true;
                  team.realName = "Player";
                  team.enemyTeam.realName = "Computer";
                  game.teamA.statueType = this.level.player.statue;
                  game.teamB.statueType = this.level.oponent.statue;
                  game.teamA.gold = this.level.player.gold;
                  game.teamA.mana = this.level.player.mana;
                  game.teamB.gold = this.level.oponent.gold;
                  game.teamB.mana = this.level.oponent.mana;
                  if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                  {
                        game.teamA.gold += 200;
                        game.teamA.mana += 200;
                  }
                  var _loc6_:Array = this.level.player.startingUnits.slice(0,this.level.player.startingUnits.length);
                  if(main.campaign.getCurrentLevel().hasInsaneWall && main.campaign.difficultyLevel == Campaign.D_INSANE)
                  {
                        if(game.teamB.type == Team.T_GOOD)
                        {
                              (_loc8_ = team.enemyTeam.addWall(team.enemyTeam.homeX - 900)).setConstructionAmount(1);
                        }
                        else
                        {
                              _loc9_ = ChaosTower(game.unitFactory.getUnit(int(Unit.U_CHAOS_TOWER)));
                              team.enemyTeam.spawn(_loc9_,game);
                              _loc9_.scaleX *= team.enemyTeam.direction * -1;
                              _loc9_.px = team.enemyTeam.homeX - 900;
                              _loc9_.py = game.map.height / 2;
                              _loc9_.setConstructionAmount(1);
                        }
                  }
                  if(main.campaign.currentLevel != 0)
                  {
                        if(main.campaign.difficultyLevel == Campaign.D_HARD)
                        {
                              _loc6_.push(game.team.getMinerType());
                        }
                        else if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                        {
                              _loc6_.push([game.team.getMinerType()]);
                              (_loc8_ = team.addWall(team.homeX + 1200)).setConstructionAmount(1);
                        }
                  }
                  else
                  {
                        game.teamB.gold = 0;
                  }
                  game.teamA.spawnUnitGroup(this.level.player.startingUnits);
                  game.teamB.spawnUnitGroup(this.level.oponent.startingUnits);
                  if(main.campaign.difficultyLevel > Campaign.D_NORMAL || Team.getIdFromRaceName(main.campaign.getCurrentLevel().oponent.race) == Team.T_CHAOS)
                  {
                        if(this.level.oponent.castleArcherLevel >= 1)
                        {
                              game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                        }
                        if(this.level.oponent.castleArcherLevel >= 2)
                        {
                              game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                        }
                        if(this.level.oponent.castleArcherLevel >= 3)
                        {
                              game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                        }
                        if(this.level.oponent.castleArcherLevel >= 4)
                        {
                              game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                        }
                  }
                  if(this.level.player.castleArcherLevel >= 1)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                  }
                  if(this.level.player.castleArcherLevel >= 2)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                  }
                  if(this.level.player.castleArcherLevel >= 3)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                  }
                  if(this.level.player.castleArcherLevel >= 4)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                  }
                  userInterface.init(game.team);
                  if(team.enemyTeam.type == Team.T_GOOD)
                  {
                        this.enemyTeamAi = new EnemyGoodTeamAi(team.enemyTeam,main,game);
                  }
                  else
                  {
                        this.enemyTeamAi = new EnemyChaosTeamAi(team.enemyTeam,main,game);
                  }
                  game.init(0);
                  game.postInit();
                  simulation.hasStarted = true;
                  super.enter();
                  if(game.teamB.type == Team.T_CHAOS)
                  {
                        game.soundManager.playSoundInBackground("chaosInGame");
                  }
                  if(Team.getIdFromRaceName(this.main.campaign.getCurrentLevel().oponent.race) == Team.T_GOOD)
                  {
                        game.soundManager.playSoundInBackground("orderInGame");
                  }
                  else
                  {
                        game.soundManager.playSoundInBackground("chaosInGame");
                  }
            }
            
            override public function update(param1:Event, param2:Number) : void
            {
                  var _loc3_:CampaignEvent = null;
                  if(!main.isKongregate && main.isCampaignDebug && userInterface.keyBoardState.isDown(78) && userInterface.keyBoardState.isShift)
                  {
                        game.teamB.statue.damage(0,100000000,null);
                  }
                  this.enemyTeamAi.update(game);
                  if(this.controller != null)
                  {
                        this.controller.update(this);
                  }
                  for each(_loc3_ in this.level.events)
                  {
                        _loc3_.update(this);
                  }
                  super.update(param1,param2);
            }
            
            override public function leave() : void
            {
                  this.cleanUp();
            }
            
            override public function endTurn() : void
            {
                  simulation.endOfTurnMove = new EndOfTurnMove();
                  simulation.endOfTurnMove.expectedNumberOfMoves = this.simulation.movesInTurn;
                  simulation.endOfTurnMove.frameRate = simulation.frameRate;
                  simulation.endOfTurnMove.turnSize = 5;
                  simulation.endOfTurnMove.turn = simulation.turn;
                  simulation.processMove(simulation.endOfTurnMove);
                  simulation.movesInTurn = 0;
            }
            
            override public function endGame() : void
            {
                  var _loc2_:int = 0;
                  gameTimer.removeEventListener(TimerEvent.TIMER,updateGameLoop);
                  gameTimer.stop();
                  var _loc1_:EndOfGameMove = new EndOfGameMove();
                  _loc1_.winner = game.winner.id;
                  _loc1_.turn = simulation.turn;
                  simulation.processMove(_loc1_);
                  trace("UPDATE TIME");
                  main.campaign.getCurrentLevel().updateTime(game.frame / 30);
                  if(main is stickwar2 && main.tracker != null)
                  {
                        if(_loc1_.winner == team.id)
                        {
                              main.tracker.trackEvent(main.campaign.getLevelDescription(),"finish","win",game.economyRecords.length);
                        }
                        else
                        {
                              main.tracker.trackEvent(main.campaign.getLevelDescription(),"finish","lose",game.economyRecords.length);
                        }
                  }
                  main.postGameScreen.setWinner(_loc1_.winner,team.type,main.campaign.getCurrentLevel().player.raceName,main.campaign.getCurrentLevel().oponent.raceName,team.id);
                  main.postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
                  if(_loc1_.winner == team.id)
                  {
                        main.campaign.campaignPoints += main.campaign.getCurrentLevel().points;
                        ++main.campaign.currentLevel;
                  }
                  if(!main.campaign.isGameFinished() && _loc1_.winner == team.id)
                  {
                        for each(_loc2_ in main.campaign.getCurrentLevel().unlocks)
                        {
                              main.postGameScreen.appendUnitUnlocked(_loc2_,game);
                        }
                  }
                  if(_loc1_.winner == team.id)
                  {
                        main.postGameScreen.showNextUnitUnlocked();
                  }
                  main.postGameScreen.setMode(PostGameScreen.M_CAMPAIGN);
                  if(_loc1_.winner == team.id)
                  {
                        main.postGameScreen.setTipText("");
                  }
                  else
                  {
                        main.postGameScreen.setTipText(main.campaign.getCurrentLevel().tip);
                  }
                  if(main.campaign.justTutorial)
                  {
                        if(_loc1_.winner == team.id)
                        {
                              main.sfs.send(new ExtensionRequest("SetDoneTutorialHandler",null));
                        }
                        main.showScreen("lobby");
                  }
                  else
                  {
                        main.showScreen("postGame",false,true);
                  }
            }
            
            override public function doMove(param1:Move, param2:int) : void
            {
                  param1.init(param2,simulation.frame,simulation.turn);
                  simulation.processMove(param1);
                  ++simulation.movesInTurn;
            }
            
            override public function cleanUp() : void
            {
                  trace("Do the cleanup");
                  super.cleanUp();
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
      }
}
