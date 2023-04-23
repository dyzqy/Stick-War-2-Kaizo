package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.*;
   import com.brockw.simulationSync.*;
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import com.smartfoxserver.v2.core.*;
   import com.smartfoxserver.v2.entities.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class MultiplayerGameScreen extends GameScreen
   {
       
      
      private var isOutOfSync:Boolean;
      
      private var replayString:String;
      
      public function MultiplayerGameScreen(param1:Main)
      {
         this.replayString = "";
         super(param1);
      }
      
      public function init(param1:SFSObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         main.seed = 0;
         this.replayString = "";
         if(!main.stickWar)
         {
            main.stickWar = new StickWar(main,this);
         }
         game = main.stickWar;
         simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
         game.seed = main.seed = Main(main).gameRoom.getVariable("seed").getIntValue();
         trace("SEED",game.seed);
         this.addChild(game);
         game.initGame(main,this,Main(main).gameRoom.getVariable("map").getIntValue());
         this.isOutOfSync = false;
         trace("START GAME RANDOM:",1000 * game.random.lastRandom);
         _loc2_ = int(Main(main).gameRoom.playerList[0].id);
         _loc3_ = int(Main(main).gameRoom.playerList[1].id);
         var _loc4_:String = "race_" + User(Main(main).gameRoom.playerList[0]).name;
         var _loc5_:String = "race_" + User(Main(main).gameRoom.playerList[1]).name;
         var _loc6_:String = "member_" + User(Main(main).gameRoom.playerList[0]).name;
         var _loc7_:String = "member_" + User(Main(main).gameRoom.playerList[1]).name;
         var _loc8_:int = param1.getInt(User(Main(main).gameRoom.playerList[0]).name);
         var _loc9_:int = param1.getInt(User(Main(main).gameRoom.playerList[1]).name);
         var _loc10_:String = String(User(Main(main).gameRoom.playerList[0]).name);
         var _loc11_:String = String(User(Main(main).gameRoom.playerList[1]).name);
         var _loc12_:int = int(Main(main).gameRoom.getVariable("gameType").getIntValue());
         var _loc13_:Number = Number(User(Main(main).gameRoom.playerList[0]).getVariable("rating").getDoubleValue());
         var _loc14_:Number = Number(User(Main(main).gameRoom.playerList[1]).getVariable("rating").getDoubleValue());
         if(_loc12_ == StickWar.TYPE_DEATHMATCH)
         {
            _loc13_ = Number(User(Main(main).gameRoom.playerList[0]).getVariable("ratingDeathmatch").getDoubleValue());
            _loc14_ = Number(User(Main(main).gameRoom.playerList[1]).getVariable("ratingDeathmatch").getDoubleValue());
         }
         this.game.gameType = _loc12_;
         trace(_loc8_,_loc9_,param1,Main(main).gameRoom.getVariable(_loc6_).getBoolValue(),Main(main).gameRoom.getVariable(_loc7_).getBoolValue());
         if(_loc2_ > _loc3_)
         {
            _loc2_ = int(Main(main).gameRoom.playerList[1].id);
            _loc3_ = int(Main(main).gameRoom.playerList[0].id);
            game.initTeams(_loc9_,_loc8_,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
            game.teamA.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[1]).name).getStringValue());
            game.teamB.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[0]).name).getStringValue());
            game.teamA.realName = _loc11_;
            game.teamB.realName = _loc10_;
            game.teamA.isMember = Main(main).gameRoom.getVariable(_loc7_).getBoolValue();
            game.teamB.isMember = Main(main).gameRoom.getVariable(_loc6_).getBoolValue();
            game.teamA.rating = _loc14_;
            game.teamB.rating = _loc13_;
         }
         else
         {
            game.initTeams(_loc8_,_loc9_,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
            game.teamB.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[1]).name).getStringValue());
            game.teamA.loadout.fromString(Main(main).gameRoom.getVariable(User(Main(main).gameRoom.playerList[0]).name).getStringValue());
            game.teamA.realName = _loc10_;
            game.teamB.realName = _loc11_;
            game.teamB.isMember = Main(main).gameRoom.getVariable(_loc7_).getBoolValue();
            game.teamA.isMember = Main(main).gameRoom.getVariable(_loc6_).getBoolValue();
            game.teamA.rating = _loc13_;
            game.teamB.rating = _loc14_;
         }
         if(_loc2_ == Main(main).gameServer.mySelf.id)
         {
            team = game.teamA;
         }
         if(_loc3_ == Main(main).gameServer.mySelf.id)
         {
            team = game.teamB;
         }
         game.team = team;
         game.teamA.id = _loc2_;
         game.teamB.id = _loc3_;
         game.teamA.name = _loc2_;
         game.teamB.name = _loc3_;
         this.team.enemyTeam.isEnemy = true;
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         trace("BEFORE INIT:",1000 * game.random.lastRandom);
         game.init(0);
         Main(main).gameServer.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         game.postInit();
         if(_loc12_ == StickWar.TYPE_DEATHMATCH)
         {
            initDeathMatch();
         }
         else if(_loc12_ == StickWar.TYPE_CLASSIC)
         {
            initClassic();
         }
      }
      
      override public function judgementFrame() : void
      {
         trace("SEND THE JUDGEMENT OF",simulation.fps);
         var _loc1_:SFSObject = new SFSObject();
         _loc1_.putInt("fps",simulation.fps);
         Main(main).sfs.send(new ExtensionRequest("setFPS",_loc1_));
      }
      
      override public function enter() : void
      {
         super.enter();
         trace("Finished loading up the Multiplayer Engine");
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
         Util.clearSFSObject(simulation.data);
         simulation.endOfTurnMove.writeToSFSObject(simulation.data);
         simulation.data.putInt("c",game.getCheckSum());
         Main(main).gameServer.send(new ExtensionRequest("m",simulation.data,Main(main).gameRoom));
         simulation.movesInTurn = 0;
      }
      
      override public function endGame() : void
      {
         var _loc1_:EndOfGameMove = new EndOfGameMove();
         _loc1_.winner = game.winner.id;
         var _loc2_:SFSObject = new SFSObject();
         _loc1_.writeToSFSObject(_loc2_);
         Main(main).gameServer.send(new ExtensionRequest("o",_loc2_,Main(main).gameRoom));
      }
      
      override public function doMove(param1:Move, param2:int) : void
      {
         var _loc3_:SFSObject = new SFSObject();
         param1.init(param2,simulation.frame,simulation.turn);
         param1.writeToSFSObject(_loc3_);
         Main(main).gameServer.send(new ExtensionRequest("m",_loc3_,Main(main).gameRoom));
         ++simulation.movesInTurn;
      }
      
      public function extensionResponse(param1:SFSEvent) : void
      {
         var _loc3_:SFSObject = null;
         var _loc4_:ByteArray = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:ForfeitMove = null;
         var _loc9_:EndOfGameMove = null;
         var _loc10_:Entity = null;
         var _loc2_:SFSObject = param1.params.params;
         switch(param1.params.cmd)
         {
            case "s":
               this.simulation.init(0);
               this.simulation.hasStarted = true;
               main.showScreen("game");
               trace("Start game");
               break;
            case "m":
               simulation.processMove(MoveFactory.createMove(_loc2_));
               break;
            case "f":
               trace("Game finalised");
               _loc3_ = new SFSObject();
               main.gameServer.send(new ExtensionRequest("z",_loc3_,Main(main).gameRoom));
               if(main.gameServer != main.sfs)
               {
                  main.gameServer.send(new LogoutRequest());
               }
               if(main.currentScreen() == "game")
               {
                  main.showScreen("postGame");
               }
               break;
            case "e":
               trace("End the game and send a game report. The winner is player with id: ",_loc2_.getInt("winner"));
               _loc3_ = new SFSObject();
               (_loc4_ = new ByteArray()).writeMultiByte("","iso-8859-1");
               _loc3_.putByteArray("replay",_loc4_);
               _loc3_.putInt("isOutOfSync",0);
               main.gameServer.send(new ExtensionRequest("g",_loc3_,Main(main).gameRoom));
               if(this.replayString == "")
               {
                  if(game.winner == null)
                  {
                     (_loc8_ = new ForfeitMove()).owner = game.team.enemyTeam.id;
                     _loc8_.execute(this.game);
                     _loc9_ = new EndOfGameMove();
                     game.winner = game.team;
                     _loc9_.winner = game.team.id;
                     _loc9_.execute(this.game);
                     trace("Artificially end the game");
                  }
                  this.replayString = simulation.gameReplay.toString(game);
               }
               Main(main).postGameScreen.setGameType(this.game.gameType);
               Main(main).postGameScreen.setReplayFile(this.replayString);
               Main(main).postGameScreen.setMode(PostGameScreen.M_MULTIPLAYER);
               Main(main).postGameScreen.setWinner(_loc2_.getInt("winner"),team.type,team.realName,team.enemyTeam.realName,team.id);
               Main(main).postGameScreen.setRatings(team.rating,team.enemyTeam.rating);
               Main(main).postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
               break;
            case "replayRequest":
               _loc3_ = new SFSObject();
               _loc4_ = new ByteArray();
               _loc5_ = Number(getTimer());
               if(this.replayString == "")
               {
                  if(game.winner == null)
                  {
                     (_loc8_ = new ForfeitMove()).owner = game.team.enemyTeam.id;
                     _loc8_.execute(this.game);
                     _loc9_ = new EndOfGameMove();
                     game.winner = game.team;
                     _loc9_.winner = game.team.id;
                     _loc9_.execute(this.game);
                     trace("Artificially end the game");
                  }
                  this.replayString = simulation.gameReplay.toString(game);
               }
               _loc4_.writeMultiByte(this.replayString,"UTF-8");
               Main(main).postGameScreen.setReplayFile(this.replayString);
               trace("Time to send encryp: ",getTimer() - _loc5_);
               _loc3_.putByteArray("replay",_loc4_);
               _loc3_.putInt("saveId",_loc2_.getInt("saveId"));
               trace("Save id: ",_loc2_.getInt("saveId"));
               _loc6_ = Number(getTimer());
               main.sfs.send(new ExtensionRequest("saveReplay",_loc3_));
               trace("Time to send replay: ",getTimer() - _loc6_);
               break;
            case "c":
               break;
            case "r":
               trace("client is reconnecting");
               break;
            case "u":
               trace("client is reconnected");
               break;
            case "userTimeout":
               showTimeout(_loc2_.getUtfString("user"),_loc2_.getLong("timeLeft"));
               trace("Timeout: " + _loc2_.getUtfString("user"),_loc2_.getLong("timeLeft"));
               break;
            case "outOfSync":
               _loc7_ = "";
               _loc3_ = new SFSObject();
               Main(main).postGameScreen.setMode(PostGameScreen.M_MULTIPLAYER);
               (_loc4_ = new ByteArray()).writeMultiByte("","iso-8859-1");
               _loc3_.putByteArray("replay",_loc4_);
               _loc3_.putInt("isOutOfSync",1);
               main.gameServer.send(new ExtensionRequest("g",_loc3_,Main(main).gameRoom));
               trace("Out of Sync");
               for each(_loc10_ in game.units)
               {
                  trace("Unit: ",_loc10_.type,_loc10_.x,_loc10_.y,_loc10_.px,_loc10_.py);
               }
               this.isOutOfSync = false;
               showSyncError();
               Main(main).postGameScreen.setGameType(this.game.gameType);
               Main(main).postGameScreen.setMode(PostGameScreen.M_SYNC_ERROR);
         }
      }
      
      override public function cleanUp() : void
      {
         Main(main).gameServer.removeEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         super.cleanUp();
      }
   }
}
