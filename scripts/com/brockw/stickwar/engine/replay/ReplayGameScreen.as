package com.brockw.stickwar.engine.replay
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
   import flash.system.*;
   import flash.utils.*;
   
   public class ReplayGameScreen extends GameScreen
   {
       
      
      private var _replayString:String;
      
      public var hasFreeCamera:Boolean;
      
      public var someoneHasWon:Boolean;
      
      private var techOnHud:Array;
      
      private var hasShownEndGameMenu:Boolean;
      
      public function ReplayGameScreen(param1:Main)
      {
         super(param1);
         this.hasFreeCamera = false;
         this.hasShownEndGameMenu = false;
         this.techOnHud = [];
      }
      
      override public function enter() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         main.seed = 0;
         main.setOverlayScreen("");
         if(!main.stickWar)
         {
            main.stickWar = new StickWar(main,this);
         }
         game = main.stickWar;
         simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
         var _loc1_:Boolean = simulation.gameReplay.fromString(this._replayString);
         game.seed = main.seed = simulation.gameReplay.seed;
         trace("SEED",game.seed);
         simulation.gameReplay.isPlaying = true;
         this.addChild(game);
         game.initGame(main,this,simulation.gameReplay.mapId);
         trace("START GAME RANDOM:",1000 * game.random.lastRandom);
         game.isReplay = true;
         _loc2_ = simulation.gameReplay.teamAId;
         _loc3_ = simulation.gameReplay.teamBId;
         game.initTeams(simulation.gameReplay.teamAType,simulation.gameReplay.teamBType,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
         team = game.teamA;
         game.team = team;
         game.teamA.id = _loc2_;
         game.teamB.id = _loc3_;
         game.teamA.realName = simulation.gameReplay.teamAName;
         game.teamB.realName = simulation.gameReplay.teamBName;
         game.teamA.loadout.fromString(simulation.gameReplay.teamALoadout);
         game.teamB.loadout.fromString(simulation.gameReplay.teamBLoadout);
         game.teamA.isMember = simulation.gameReplay.teamAIsMember;
         game.teamB.isMember = simulation.gameReplay.teamBIsMember;
         trace(game.teamA.isMember,game.teamB.isMember);
         game.teamA.name = _loc2_;
         game.teamB.name = _loc3_;
         this.team.enemyTeam.isEnemy = true;
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         trace("BEFORE INIT:",1000 * game.random.lastRandom);
         game.init(0);
         game.postInit();
         if(simulation.gameReplay.gameType == StickWar.TYPE_CLASSIC)
         {
            this.initClassic();
         }
         else if(simulation.gameReplay.gameType == StickWar.TYPE_DEATHMATCH)
         {
            this.initDeathMatch();
         }
         game.fogOfWar.isFogOn = true;
         simulation.hasStarted = true;
         this.someoneHasWon = false;
         this.setUpHUD();
         this.hasShownEndGameMenu = false;
         super.enter();
         this.viewPlayer(game.teamB);
         this.viewPlayer(game.teamA);
      }
      
      private function viewPlayer1(param1:Event) : void
      {
         this.viewPlayer(game.teamB);
      }
      
      private function viewPlayer2(param1:Event) : void
      {
         this.viewPlayer(game.teamA);
      }
      
      private function viewPlayer(param1:Team) : void
      {
         game.team = param1;
         game.gameScreen.team = game.team;
         this.cleanUpHUD();
         removeChild(userInterface);
         userInterface = new UserInterface(main,this);
         addChild(userInterface);
         userInterface.init(game.team);
         this.setUpHUD();
         userInterface.setUpQualityButtons();
         userInterface.isSlowCamera = true;
         game.screenX = game.targetScreenX = game.team.lastScreenLookPosition;
         if(Math.abs(game.targetScreenX - game.screenX) > game.map.screenWidth)
         {
            game.gameScreen.userInterface.isSlowCamera = false;
         }
      }
      
      override public function maySwitchOnDisconnect() : Boolean
      {
         return false;
      }
      
      override public function update(param1:Event, param2:Number) : void
      {
         var _loc3_:Bitmap = null;
         userInterface.chat.y = 120;
         if(game.team == game.teamA)
         {
            this.userInterface.hud.hud.replayHud.player2Highlight.visible = true;
            this.userInterface.hud.hud.replayHud.player1Highlight.visible = false;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.player1Highlight.visible = true;
            this.userInterface.hud.hud.replayHud.player2Highlight.visible = false;
         }
         if(game.fogOfWar.isFogOn)
         {
            this.userInterface.hud.hud.replayHud.fogOfWar.gotoAndStop(2);
         }
         else
         {
            this.userInterface.hud.hud.replayHud.fogOfWar.gotoAndStop(1);
         }
         if(this.hasFreeCamera)
         {
            this.userInterface.hud.hud.replayHud.freeCamera.gotoAndStop(2);
         }
         else
         {
            this.userInterface.hud.hud.replayHud.freeCamera.gotoAndStop(1);
         }
         if(strictPause)
         {
            this.userInterface.hud.hud.replayHud.pauseButton.visible = false;
            this.userInterface.hud.hud.replayHud.playButton.visible = true;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.pauseButton.visible = true;
            this.userInterface.hud.hud.replayHud.playButton.visible = false;
         }
         if(this.isFastForward)
         {
            this.userInterface.hud.hud.replayHud.forwardOn.visible = true;
         }
         else
         {
            this.userInterface.hud.hud.replayHud.forwardOn.visible = false;
         }
         for each(_loc3_ in this.techOnHud)
         {
            if(userInterface.hud.contains(_loc3_))
            {
               this.userInterface.hud.removeChild(_loc3_);
            }
         }
         this.techOnHud = [];
         this.drawTechResearch(game.teamA);
         this.drawTechResearch(game.teamB);
         super.update(param1,param2);
      }
      
      private function drawTechResearch(param1:Team) : void
      {
         var _loc3_:String = null;
         var _loc4_:TechItem = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc2_:int = 0;
         for(_loc3_ in param1.tech.researchingMap)
         {
            _loc4_ = TechItem(param1.tech.upgrades[_loc3_]);
            _loc5_ = 55;
            userInterface.hud.addChild(_loc4_.replayMc);
            this.techOnHud.push(_loc4_.replayMc);
            _loc4_.replayMc.scaleX = 0.8;
            _loc4_.replayMc.scaleY = 0.8;
            _loc4_.replayMc.y = 100;
            _loc6_ = 0;
            _loc7_ = param1 == game.teamA ? 1 : -1;
            _loc8_ = param1 == game.teamA ? 10 : game.map.screenWidth - 10 - _loc5_;
            _loc4_.replayMc.x = _loc8_ + _loc2_ * _loc7_ * (_loc6_ + _loc5_);
            _loc2_++;
         }
      }
      
      override public function updateGameLoop(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!this.someoneHasWon && game.showGameOverAnimation)
         {
            this.someoneHasWon = true;
            strictPause = true;
         }
         if(this.someoneHasWon)
         {
            if(!this.hasShownEndGameMenu)
            {
               if(game.teamA.statue.mc.currentFrame == game.teamA.statue.mc.totalFrames || game.teamB.statue.mc.currentFrame == game.teamB.statue.mc.totalFrames)
               {
                  this.userInterface.pauseMenu.showMenu();
                  this.hasShownEndGameMenu = true;
               }
            }
            game.pausedGameMc.visible = false;
         }
         gameTimer.delay = _period;
         this.gameTimer.start();
         _loc2_ = getTimer() - _beforeTime;
         _beforeTime = getTimer();
         _overSleepTime = _beforeTime - _afterTime - _sleepTime;
         if(_overSleepTime < 0)
         {
            _overSleepTime = 0;
         }
         if(userInterface.keyBoardState.isDown(32))
         {
            this.update(param1,_beforeTime - _afterTime);
            this.update(param1,_beforeTime - _afterTime);
            this.update(param1,_beforeTime - _afterTime);
            this.update(param1,_beforeTime - _afterTime);
            this.update(param1,_beforeTime - _afterTime);
            this.update(param1,_beforeTime - _afterTime);
         }
         else
         {
            this.update(param1,_beforeTime - _afterTime);
         }
         _afterTime = getTimer();
         _timeDiff = _afterTime - _beforeTime;
         _sleepTime = _period - _timeDiff;
         if(_sleepTime <= 0)
         {
            _excess -= _sleepTime;
            _sleepTime = 2;
         }
         overTime += _loc2_ - 34;
         if(overTime < 0)
         {
            overTime = 0;
         }
         if(overTime < 35)
         {
            param1.updateAfterEvent();
            consecutiveSkips = 0;
         }
         else
         {
            ++consecutiveSkips;
            gameTimer.delay = 1;
            this.gameTimer.start();
            trace("Skip: ",_loc2_,consecutiveSkips,this.stage.stage.frameRate);
         }
      }
      
      private function restartButton(param1:Event) : void
      {
         main.showScreen(main.currentScreen(),true);
      }
      
      private function shareButton(param1:Event) : void
      {
         this.userInterface.hud.hud.replayHud.linkMc.link.text = main.currentReplayLink;
         this.userInterface.hud.hud.replayHud.linkMc.visible = true;
      }
      
      private function setUpHUD() : void
      {
         this.userInterface.hud.hud.replayHud.player1Name.buttonMode = true;
         this.userInterface.hud.hud.replayHud.player2Name.buttonMode = true;
         this.userInterface.hud.hud.replayHud.player2Name.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.player1Name.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.player1Name.addEventListener(MouseEvent.CLICK,this.viewPlayer1);
         this.userInterface.hud.hud.replayHud.player2Name.addEventListener(MouseEvent.CLICK,this.viewPlayer2);
         this.userInterface.hud.hud.replayHud.freeCamera.addEventListener(MouseEvent.CLICK,this.setFreeCamera);
         this.userInterface.hud.hud.replayHud.fogOfWar.addEventListener(MouseEvent.CLICK,this.setFogOfWar);
         this.userInterface.hud.hud.replayHud.fogOfWar.buttonMode = true;
         this.userInterface.hud.hud.replayHud.freeCamera.buttonMode = true;
         this.userInterface.hud.hud.replayHud.fogOfWar.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.freeCamera.mouseChildren = false;
         this.userInterface.hud.hud.replayHud.restartButton.addEventListener(MouseEvent.CLICK,this.restartButton);
         this.userInterface.hud.hud.replayHud.pauseButton.addEventListener(MouseEvent.CLICK,this.pauseButton);
         this.userInterface.hud.hud.replayHud.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
         this.userInterface.hud.hud.replayHud.forwardButton.addEventListener(MouseEvent.CLICK,this.forwardButton);
         this.userInterface.hud.hud.replayHud.linkMc.visible = false;
         this.userInterface.hud.hud.replayHud.linkMc.buttonMode = true;
         this.userInterface.hud.hud.replayHud.linkMc.okButton.addEventListener(MouseEvent.CLICK,this.closeLinkMc);
         this.userInterface.hud.hud.replayHud.linkMc.copyButton.addEventListener(MouseEvent.CLICK,this.copyLinkMc);
         this.userInterface.hud.hud.replayHud.shareButton.addEventListener(MouseEvent.CLICK,this.shareButton);
         if(userInterface.hud.hud.fastForward)
         {
            userInterface.hud.hud.fastForward.visible = false;
         }
         userInterface.setUpQualityButtons();
      }
      
      private function closeLinkMc(param1:Event) : void
      {
         this.userInterface.hud.hud.replayHud.linkMc.visible = false;
      }
      
      private function copyLinkMc(param1:Event) : void
      {
         System.setClipboard(this.userInterface.hud.hud.replayHud.linkMc.link.text);
         main.stage.focus = this.userInterface.hud.hud.replayHud.linkMc.link;
         this.userInterface.hud.hud.replayHud.linkMc.link.setSelection(0,this.userInterface.hud.hud.replayHud.linkMc.link.text.length);
      }
      
      private function cleanUpHUD() : void
      {
         this.userInterface.hud.hud.replayHud.shareButton.removeEventListener(MouseEvent.CLICK,this.shareButton);
         this.userInterface.hud.hud.replayHud.restartButton.removeEventListener(MouseEvent.CLICK,this.restartButton);
         this.userInterface.hud.hud.replayHud.player1Name.removeEventListener(MouseEvent.CLICK,this.viewPlayer1);
         this.userInterface.hud.hud.replayHud.player2Name.removeEventListener(MouseEvent.CLICK,this.viewPlayer2);
         this.userInterface.hud.hud.replayHud.freeCamera.removeEventListener(MouseEvent.CLICK,this.setFreeCamera);
         this.userInterface.hud.hud.replayHud.fogOfWar.removeEventListener(MouseEvent.CLICK,this.setFogOfWar);
         this.userInterface.hud.hud.replayHud.pauseButton.removeEventListener(MouseEvent.CLICK,this.pauseButton);
         this.userInterface.hud.hud.replayHud.playButton.removeEventListener(MouseEvent.CLICK,this.playButton);
         this.userInterface.hud.hud.replayHud.forwardButton.removeEventListener(MouseEvent.CLICK,this.forwardButton);
         userInterface.cleanUp();
      }
      
      private function forwardButton(param1:Event) : void
      {
         this.isFastForward = !this.isFastForward;
      }
      
      private function pauseButton(param1:Event) : void
      {
         this.strictPause = true;
      }
      
      private function playButton(param1:Event) : void
      {
         this.strictPause = false;
      }
      
      private function setFogOfWar(param1:Event) : void
      {
         this.game.fogOfWar.isFogOn = !this.game.fogOfWar.isFogOn;
      }
      
      private function setFreeCamera(param1:Event) : void
      {
         this.hasFreeCamera = !this.hasFreeCamera;
      }
      
      override public function leave() : void
      {
         this.cleanUp();
      }
      
      override public function endTurn() : void
      {
      }
      
      override public function endGame() : void
      {
         var _loc1_:EndOfGameMove = new EndOfGameMove();
         if(game.winner == null)
         {
            if(game.teamA.statue.health == 0)
            {
               game.winner = game.teamA;
            }
            else
            {
               game.winner = game.teamB;
            }
         }
         _loc1_.winner = game.winner.id;
         _loc1_.turn = simulation.turn;
         simulation.processMove(_loc1_);
         Main(main).postGameScreen.setReplayFile(simulation.gameReplay.toString(game));
         Main(main).postGameScreen.setWinner(_loc1_.winner,team.type,team.realName,team.enemyTeam.realName,team.id);
         Main(main).postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
         Main(main).postGameScreen.setMode(PostGameScreen.M_SINGLEPLAYER,true);
         main.showScreen("postGame");
      }
      
      override public function doMove(param1:Move, param2:int) : void
      {
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
      }
      
      public function get replayString() : String
      {
         return this._replayString;
      }
      
      public function set replayString(param1:String) : void
      {
         this._replayString = param1;
      }
   }
}
