package com.brockw.stickwar
{
      import com.brockw.game.*;
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.SimulationSyncronizer;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.UserInterface;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.ui.*;
      import flash.utils.*;
      
      public class GameScreen extends Screen
      {
            
            public static const FRAME_RATE:int = 30;
            
            public static const DOUBLE_FRAME_RATE:int = 30;
            
            protected static const MAX_SKIPS:int = 3;
            
            public static const S_HIGH_QUALITY:int = 0;
            
            public static const S_MEDIUM_QUALITY:int = 1;
            
            public static const S_LOW_QUALITY:int = 2;
             
            
            protected var _game:StickWar;
            
            protected var _simulation:SimulationSyncronizer;
            
            protected var _main:BaseMain;
            
            protected var _team:Team;
            
            protected var _userInterface:UserInterface;
            
            protected var timeOfLastUpdate:Number;
            
            protected var _period:Number = 33.333333333333336;
            
            protected var _beforeTime:int = 0;
            
            protected var _afterTime:int = 0;
            
            protected var _timeDiff:int = 0;
            
            protected var _sleepTime:int = 0;
            
            protected var _overSleepTime:int = 0;
            
            protected var _excess:int = 0;
            
            protected var gameTimer:Timer;
            
            protected var consecutiveSkips:int;
            
            protected var overTime:Number;
            
            private var _isDebug:Boolean;
            
            private var lastPulse:int;
            
            private var _isPaused:Boolean;
            
            private var _quality:int;
            
            private var skipHeuristic:Number;
            
            private var messagePrompt:inGameMessagePromptMc;
            
            private var _hasMovingBackground:Boolean;
            
            private var _hasEffects:Boolean;
            
            private var _hasAlphaOnFogOfWar:Boolean;
            
            private var _hasScreenReduction:Boolean;
            
            private var lastSwitchInQuality:int;
            
            private var isFirstSwitch:Boolean;
            
            private var hasChanged:Boolean;
            
            private var showTimeoutCounter:int;
            
            private var nameLagging:String;
            
            private var _isFastForward:Boolean;
            
            public var strictPause:Boolean;
            
            private var _isFastForwardFrame:Boolean;
            
            private var isDoingDouble:Boolean;
            
            private var lastDoubleChange:Number;
            
            private var timeToStayDouble:Number;
            
            internal var t:int;
            
            private var showingTimeout:Boolean;
            
            private var showingSyncError:Boolean;
            
            public function GameScreen(param1:BaseMain)
            {
                  this._period = 33.333333333333336;
                  super();
                  this.nameLagging = "";
                  this.showTimeoutCounter = 0;
                  this._hasMovingBackground = true;
                  this._hasEffects = true;
                  this._hasAlphaOnFogOfWar = true;
                  this._hasScreenReduction = true;
                  this.main = param1;
                  this.isDebug = false;
                  this.quality = S_HIGH_QUALITY;
                  this.skipHeuristic = 0;
                  param1.loadingFraction = 0;
                  this.lastSwitchInQuality = getTimer();
                  this.isFastForward = false;
                  this._isFastForwardFrame = false;
                  this.messagePrompt = null;
            }
            
            public function judgementFrame() : void
            {
            }
            
            override public function enter() : void
            {
                  this.strictPause = false;
                  this.stage.frameRate = 0;
                  this.gameTimer = new Timer(this._period,0);
                  this.gameTimer.addEventListener(TimerEvent.TIMER,this.updateGameLoop);
                  this.gameTimer.start();
                  this.consecutiveSkips = 0;
                  this.overTime = 0;
                  this._beforeTime = getTimer();
                  this.isPaused = false;
                  this.lastPulse = 0;
                  this.main.setOverlayScreen("");
                  this.timeToStayDouble = 500;
                  this.messagePrompt = new inGameMessagePromptMc();
                  this.isDoingDouble = false;
                  this.lastDoubleChange = getTimer();
                  this.lastSwitchInQuality = getTimer();
                  this.isFirstSwitch = true;
                  this.hasChanged = true;
                  this._hasMovingBackground = true;
                  this._hasEffects = true;
                  this._hasAlphaOnFogOfWar = true;
                  this._hasScreenReduction = true;
                  this.isFastForward = false;
            }
            
            public function u(param1:Event) : void
            {
                  this.t = getTimer();
            }
            
            public function updateGameLoopFrame(param1:Event) : void
            {
                  this.update(param1,0);
            }
            
            public function updateGameLoop(param1:TimerEvent) : void
            {
                  if(!stage)
                  {
                        return;
                  }
                  if(!this.isDoingDouble && this.simulation.getQuickFPS() < 25 && getTimer() - this.lastDoubleChange > 1000)
                  {
                        this.isDoingDouble = true;
                        this.timeToStayDouble += 500;
                        this.lastDoubleChange = getTimer();
                  }
                  else if(this.isDoingDouble && getTimer() - this.lastDoubleChange > this.timeToStayDouble && this.simulation.getQuickFPS() >= 29.8)
                  {
                        this.isDoingDouble = false;
                        this.lastDoubleChange = getTimer();
                  }
                  if(this.isDoingDouble)
                  {
                        this._period = 1000 / (FRAME_RATE / 2);
                  }
                  else
                  {
                        this._period = 1000 / FRAME_RATE;
                  }
                  this.gameTimer.delay = this._period;
                  this.gameTimer.start();
                  var _loc2_:Number = getTimer() - this._beforeTime;
                  this._beforeTime = getTimer();
                  this._overSleepTime = this._beforeTime - this._afterTime - this._sleepTime;
                  if(this._overSleepTime < 0)
                  {
                        this._overSleepTime = 0;
                  }
                  if(stage != null)
                  {
                        if(this.isDoingDouble)
                        {
                              this.update(param1,(this._beforeTime - this._afterTime) / 2);
                              this.update(param1,(this._beforeTime - this._afterTime) / 2);
                        }
                        else
                        {
                              this.update(param1,this._beforeTime - this._afterTime);
                        }
                  }
                  this._afterTime = getTimer();
                  this._timeDiff = this._afterTime - this._beforeTime;
                  this._sleepTime = this._period - this._timeDiff;
                  if(this._sleepTime <= 0)
                  {
                        this._excess -= this._sleepTime;
                        this._sleepTime = 2;
                  }
                  this.overTime += _loc2_ - this._period;
                  if(this.overTime < 0)
                  {
                        this.overTime = 0;
                  }
                  if(this.game.frame == 30 * 60 * 5)
                  {
                        this.judgementFrame();
                  }
                  if(this.overTime < 35 || this.consecutiveSkips > 0)
                  {
                        param1.updateAfterEvent();
                        this.consecutiveSkips = 0;
                  }
                  else
                  {
                        this.overTime = 0;
                        ++this.consecutiveSkips;
                        if(this.gameTimer)
                        {
                              this.gameTimer.reset();
                              this.gameTimer.delay = 1;
                              this.gameTimer.start();
                        }
                  }
            }
            
            public function update(param1:Event, param2:Number) : void
            {
                  var _loc3_:ScreenPositionUpdateMove = null;
                  if(this.hasChanged)
                  {
                        this.hasChanged = false;
                        if(this.quality == S_HIGH_QUALITY)
                        {
                              this._hasMovingBackground = true;
                              this._hasEffects = true;
                              stage.quality = "HIGH";
                        }
                        else if(this.quality == S_MEDIUM_QUALITY)
                        {
                              this._hasMovingBackground = true;
                              stage.quality = "LOW";
                              this._hasEffects = false;
                        }
                        else if(this.quality == S_LOW_QUALITY)
                        {
                              stage.quality = "LOW";
                              this._hasEffects = false;
                              this._hasMovingBackground = false;
                        }
                        trace("QUALITY: ",this.quality);
                  }
                  if(this.simulation.hasStarted)
                  {
                        this.userInterface.update(param1,param2);
                  }
                  this.simulation.updateFPS();
                  if(this.strictPause)
                  {
                        if(this.game.showGameOverAnimation)
                        {
                              if(this.isPaused)
                              {
                                    this.isPaused = false;
                                    trace("FIX PAUSE");
                              }
                        }
                        this.game.updateVisibilityOfUnits();
                  }
                  else
                  {
                        this.simulation.update(this);
                        if(this.isFastForward)
                        {
                              this._isFastForwardFrame = true;
                              this.simulation.update(this);
                              this._isFastForwardFrame = false;
                        }
                  }
                  if(this.simulation)
                  {
                        if(this.simulation.isStalled || this.game.showGameOverAnimation)
                        {
                              this.game.updateMouseOverUnit(this,false);
                              if(this.lastPulse > 5)
                              {
                                    _loc3_ = new ScreenPositionUpdateMove();
                                    this.userInterface.lastSentScreenPosition = _loc3_.pos = this.game.screenX;
                                    this.doMove(_loc3_,this.team.id);
                                    this.lastPulse = 0;
                              }
                              ++this.lastPulse;
                        }
                        else if(this.showingTimeout == true)
                        {
                              this.hideTimeout();
                        }
                        if(this.showingTimeout || this.showingSyncError)
                        {
                              ++this.showTimeoutCounter;
                        }
                  }
            }
            
            public function showTimeout(param1:String, param2:int) : void
            {
                  var _loc3_:* = null;
                  if(!this.showingSyncError)
                  {
                        this.showingTimeout = true;
                        if(this.nameLagging != param1)
                        {
                              this.showTimeoutCounter = 0;
                        }
                        this.nameLagging = param1;
                        if(param1 == this.main.sfs.mySelf.name)
                        {
                              _loc3_ = "Your computer/internet is lagging and will cause you to forfeit in " + Math.floor(param2 / 1000) + " seconds";
                              this.showMessage(_loc3_,true);
                        }
                        else
                        {
                              this.showMessage(param1 + " is lagging and will forfeit in " + Math.floor(param2 / 1000) + " seconds",false);
                        }
                  }
            }
            
            public function hideTimeout() : void
            {
                  if(this.showTimeoutCounter > 30 * 3)
                  {
                        this.hideMessage();
                        this.showingTimeout = false;
                        this.nameLagging = "";
                  }
            }
            
            public function showSyncError() : void
            {
                  this.showingSyncError = true;
                  this.showMessage("Clients out of Sync. An error report has been submitted.");
            }
            
            public function showMessage(param1:String, param2:Boolean = false, param3:Number = 0) : void
            {
                  if(param2)
                  {
                        this.messagePrompt.gotoAndStop(2);
                  }
                  else
                  {
                        this.messagePrompt.gotoAndStop(1);
                  }
                  this.messagePrompt.message.text = param1;
                  this.messagePrompt.x = stage.stageWidth / 2;
                  this.messagePrompt.y = 40 + this.messagePrompt.height / 2 + param3;
                  if(!contains(this.messagePrompt))
                  {
                        addChild(this.messagePrompt);
                  }
            }
            
            public function initClassic() : void
            {
                  this.game.teamA.spawnMiners();
                  this.game.teamB.spawnMiners();
                  this.game.teamA.gold = 500;
                  this.game.teamB.gold = 500;
                  this.game.teamA.mana = 0;
                  this.game.teamB.mana = 0;
            }
            
            public function initDeathMatch() : void
            {
                  this.game.teamA.spawnMiners();
                  this.game.teamB.spawnMiners();
                  this.game.teamA.spawnMiners();
                  this.game.teamB.spawnMiners();
                  this.game.teamA.spawnMiners();
                  this.game.teamB.spawnMiners();
                  this.game.teamA.gold = 3000;
                  this.game.teamA.mana = 1500;
                  this.game.teamB.gold = 3000;
                  this.game.teamB.mana = 1500;
            }
            
            public function hideMessage() : void
            {
                  trace(this.messagePrompt);
                  if(this.messagePrompt != null)
                  {
                        if(contains(this.messagePrompt))
                        {
                              removeChild(this.messagePrompt);
                        }
                  }
            }
            
            public function endGame() : void
            {
            }
            
            public function endTurn() : void
            {
            }
            
            public function doMove(param1:Move, param2:int) : void
            {
            }
            
            public function cleanUp() : void
            {
                  this.hideMessage();
                  if(this.gameTimer)
                  {
                        this.gameTimer.removeEventListener(TimerEvent.TIMER,this.updateGameLoop);
                        this.gameTimer.stop();
                  }
                  trace("CLEAN UP THE GAMES CREEN");
                  if(this.userInterface)
                  {
                        this.userInterface.cleanUp();
                  }
                  this.userInterface = null;
                  this._simulation = null;
                  Mouse.show();
                  if(this.game)
                  {
                        this.game.cleanUp();
                  }
                  this.game = null;
                  this.gameTimer = null;
                  if(stage)
                  {
                        this.stage.quality = "HIGH";
                  }
            }
            
            public function get game() : StickWar
            {
                  return this._game;
            }
            
            public function set game(param1:StickWar) : void
            {
                  this._game = param1;
            }
            
            public function get simulation() : SimulationSyncronizer
            {
                  return this._simulation;
            }
            
            public function set simulation(param1:SimulationSyncronizer) : void
            {
                  this._simulation = param1;
            }
            
            public function get team() : Team
            {
                  return this._team;
            }
            
            public function set team(param1:Team) : void
            {
                  this._team = param1;
            }
            
            public function get main() : BaseMain
            {
                  return this._main;
            }
            
            public function set main(param1:BaseMain) : void
            {
                  this._main = param1;
            }
            
            public function get userInterface() : UserInterface
            {
                  return this._userInterface;
            }
            
            public function set userInterface(param1:UserInterface) : void
            {
                  this._userInterface = param1;
            }
            
            public function get isPaused() : Boolean
            {
                  return this._isPaused;
            }
            
            public function set isPaused(param1:Boolean) : void
            {
                  this.game.setPaused(param1);
                  this._isPaused = param1;
            }
            
            public function get isDebug() : Boolean
            {
                  return this._isDebug;
            }
            
            public function set isDebug(param1:Boolean) : void
            {
                  this._isDebug = param1;
            }
            
            public function get hasMovingBackground() : Boolean
            {
                  return this._hasMovingBackground;
            }
            
            public function set hasMovingBackground(param1:Boolean) : void
            {
                  this._hasMovingBackground = param1;
            }
            
            public function get hasEffects() : Boolean
            {
                  return this._hasEffects;
            }
            
            public function set hasEffects(param1:Boolean) : void
            {
                  this._hasEffects = param1;
            }
            
            public function get hasAlphaOnFogOfWar() : Boolean
            {
                  return this._hasAlphaOnFogOfWar;
            }
            
            public function set hasAlphaOnFogOfWar(param1:Boolean) : void
            {
                  this._hasAlphaOnFogOfWar = param1;
            }
            
            public function get hasScreenReduction() : Boolean
            {
                  return this._hasScreenReduction;
            }
            
            public function set hasScreenReduction(param1:Boolean) : void
            {
                  this._hasScreenReduction = param1;
            }
            
            public function get quality() : int
            {
                  return this._quality;
            }
            
            public function set quality(param1:int) : void
            {
                  this.hasChanged = true;
                  this._quality = param1;
            }
            
            public function get isFastForward() : Boolean
            {
                  return this._isFastForward;
            }
            
            public function set isFastForward(param1:Boolean) : void
            {
                  this._isFastForward = param1;
            }
            
            public function get isFastForwardFrame() : Boolean
            {
                  return this._isFastForwardFrame;
            }
            
            public function set isFastForwardFrame(param1:Boolean) : void
            {
                  this._isFastForwardFrame = param1;
            }
      }
}
