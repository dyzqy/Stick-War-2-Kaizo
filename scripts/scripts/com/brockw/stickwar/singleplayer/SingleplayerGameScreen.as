package com.brockw.stickwar.singleplayer
{
      import com.brockw.game.*;
      import com.brockw.simulationSync.*;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.events.*;
      import flash.text.*;
      
      public class SingleplayerGameScreen extends GameScreen
      {
             
            
            private var enemyTeamAi:EnemyTeamAi;
            
            public var gameType:int;
            
            public var map:int;
            
            public var handicap:Number;
            
            public var opponentName:String;
            
            public var opponentRace:int;
            
            private var debugTextA:TextField;
            
            private var debugTextB:TextField;
            
            public function SingleplayerGameScreen(param1:Main)
            {
                  this.gameType = 0;
                  this.map = -1;
                  this.handicap = 1;
                  this.opponentName = "Ai";
                  this.opponentRace = Team.T_GOOD;
                  this.debugTextA = new TextField();
                  this.debugTextB = new TextField();
                  super(param1);
            }
            
            override public function enter() : void
            {
                  var _loc1_:int = 0;
                  var _loc2_:int = 0;
                  main.seed = 0;
                  if(!main.stickWar)
                  {
                        main.stickWar = new StickWar(main,this);
                  }
                  game = main.stickWar;
                  game.seed = main.seed = int(Math.random() * 100);
                  simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
                  simulation.init(0);
                  this.addChild(game);
                  game.initGame(main,this,this.map);
                  userInterface = new UserInterface(main,this);
                  addChild(userInterface);
                  _loc1_ = 0;
                  _loc2_ = 1;
                  game.initTeams(main.raceSelected,this.opponentRace,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health,null,null,1,this.handicap);
                  team = game.teamA;
                  game.team = team;
                  game.teamA.id = _loc1_;
                  game.teamB.id = _loc2_;
                  game.team.realName = "Myself";
                  game.team.enemyTeam.realName = this.opponentName;
                  game.teamA.gold = 500;
                  game.teamB.gold = 500;
                  game.teamA.mana = 0;
                  game.teamB.mana = 0;
                  game.teamA.loadout.fromString(Main(main).loadout);
                  game.teamB.loadout.fromString(Main(main).loadout);
                  game.teamA.name = _loc1_;
                  game.teamB.name = _loc2_;
                  this.team.enemyTeam.isEnemy = true;
                  this.team.enemyTeam.isAi = true;
                  userInterface.init(game.team);
                  if(team.enemyTeam.type == Team.T_GOOD)
                  {
                        this.enemyTeamAi = new EnemyGoodTeamAi(team.enemyTeam,main,game,game.xml.xml.debug == 0);
                  }
                  else
                  {
                        this.enemyTeamAi = new EnemyChaosTeamAi(team.enemyTeam,main,game,game.xml.xml.debug == 0);
                  }
                  game.init(0);
                  game.postInit();
                  simulation.hasStarted = true;
                  if(this.gameType == StickWar.TYPE_CLASSIC)
                  {
                        this.initClassic();
                  }
                  else if(this.gameType == StickWar.TYPE_DEATHMATCH)
                  {
                        this.initDeathMatch();
                  }
                  if(game.xml.xml.debug == 1)
                  {
                        game.teamA.gold = 50000;
                        game.teamB.gold = 50000;
                        game.teamA.mana = 50000;
                        game.teamB.mana = 50000;
                  }
                  if(game.xml.xml.debug == 1)
                  {
                        this.debugTextA.multiline = true;
                        this.debugTextB.multiline = true;
                        this.debugTextA.height = 100;
                        this.debugTextB.height = 100;
                        this.debugTextA.width = 100;
                        this.debugTextB.width = 100;
                        this.game.gameScreen.userInterface.hud.addChild(this.debugTextA);
                        this.game.gameScreen.userInterface.hud.addChild(this.debugTextB);
                        this.debugTextA.x = 10;
                        this.debugTextA.y = 100;
                        this.debugTextB.x = game.map.screenWidth - this.debugTextB.width - 10;
                        this.debugTextB.y = 100;
                  }
                  super.enter();
            }
            
            override public function update(param1:Event, param2:Number) : void
            {
                  var _loc3_:Entity = null;
                  var _loc4_:Unit = null;
                  this.enemyTeamAi.update(game);
                  if(this.userInterface.keyBoardState.isPressed(82))
                  {
                        for each(_loc3_ in game.units)
                        {
                              if(_loc3_ is Unit && !(_loc3_ is Statue))
                              {
                                    (_loc4_ = Unit(_loc3_)).damage(0,_loc4_.maxHealth * 2,null);
                              }
                        }
                  }
                  if(this.userInterface.keyBoardState.isPressed(90))
                  {
                        team.enemyTeam.attack();
                  }
                  super.update(param1,param2);
                  if(game.xml.xml.debug == 1)
                  {
                        this.debugTextA.text = "Population: " + game.teamA.population;
                        this.debugTextB.text = "Population: " + game.teamB.population;
                        this.debugTextA.text += "\nGold: " + game.teamA.getGoldValue();
                        this.debugTextB.text += "\nGold: " + game.teamB.getGoldValue();
                        this.debugTextA.text += "\nMana: " + game.teamA.getManaValue();
                        this.debugTextB.text += "\nMana: " + game.teamB.getManaValue();
                  }
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
                  var _loc1_:EndOfGameMove = new EndOfGameMove();
                  _loc1_.winner = game.winner.id;
                  _loc1_.turn = simulation.turn;
                  simulation.processMove(_loc1_);
                  Main(main).postGameScreen.setReplayFile(simulation.gameReplay.toString(game));
                  Main(main).postGameScreen.setWinner(_loc1_.winner,team.type,team.realName,team.enemyTeam.realName,team.id);
                  Main(main).postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
                  Main(main).postGameScreen.setMode(PostGameScreen.M_SINGLEPLAYER);
                  Main(main).showScreen("postGame");
            }
            
            override public function doMove(param1:Move, param2:int) : void
            {
                  param1.init(param2,simulation.frame,simulation.turn);
                  simulation.processMove(param1);
                  ++simulation.movesInTurn;
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
      }
}
