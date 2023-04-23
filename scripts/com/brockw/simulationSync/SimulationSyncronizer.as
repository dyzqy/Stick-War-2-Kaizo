package com.brockw.simulationSync
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.data.*;
   import flash.utils.*;
   
   public class SimulationSyncronizer
   {
       
      
      public var frame:int;
      
      public var turn:int;
      
      public var frameRate:int;
      
      public var turnSize:int;
      
      public var ping:Number;
      
      public var movesInTurn:int;
      
      public var framesLeftInTurn:int;
      
      private var currentTurn:com.brockw.simulationSync.Turn;
      
      private var nextTurn:com.brockw.simulationSync.Turn;
      
      private var nextnextTurn:com.brockw.simulationSync.Turn;
      
      private var temp:com.brockw.simulationSync.Turn;
      
      private var _game:com.brockw.simulationSync.Simulation;
      
      private var main:BaseMain;
      
      private var tempSFSObject:SFSObject;
      
      private var waitingForTurn:Boolean;
      
      private var _sentEndGame:Boolean;
      
      private var _hasStarted:Boolean;
      
      public var data:SFSObject;
      
      public var endOfTurnMove:com.brockw.simulationSync.EndOfTurnMove;
      
      private var endOfTurnFunction:Function;
      
      private var endGame:Function;
      
      private var _gameReplay:com.brockw.simulationSync.GameReplay;
      
      private var lastNFrames:Array;
      
      private var lastTime:Number;
      
      private var _fps:Number;
      
      private var _isStalled:Boolean;
      
      public function SimulationSyncronizer(param1:com.brockw.simulationSync.Simulation, param2:BaseMain, param3:Function, param4:Function)
      {
         super();
         this._sentEndGame = false;
         this.frame = 0;
         this.turn = 0;
         this.frameRate = 30;
         this.turnSize = 5;
         this.ping = 0;
         this.game = param1;
         this.main = param2;
         this.endOfTurnFunction = param3;
         this.framesLeftInTurn = this.turnSize;
         this.movesInTurn = 0;
         this._isStalled = false;
         this.tempSFSObject = new SFSObject();
         this.currentTurn = new Turn();
         this.currentTurn.ready = true;
         this.nextTurn = new Turn();
         this.nextnextTurn = new Turn();
         this.waitingForTurn = false;
         this._hasStarted = false;
         this.endOfTurnMove = new EndOfTurnMove();
         this.endGame = param4;
         this.data = new SFSObject();
         this.gameReplay = new GameReplay();
         this.lastNFrames = [];
      }
      
      public function init(param1:int) : void
      {
         this.game.init(param1);
         this.frame = 0;
         this.turn = 0;
         this.lastTime = getTimer();
      }
      
      public function update(param1:Screen) : void
      {
         if(!this._hasStarted)
         {
            return;
         }
         if(this.gameReplay.isPlaying)
         {
            this.gameReplay.play(this);
            if(this.gameReplay.isFinished())
            {
               this.game.gameOver = true;
            }
         }
         if(this.game.gameOver)
         {
            if(this._sentEndGame == false)
            {
               this.endGame();
               this._sentEndGame = true;
            }
            return;
         }
         if(this.framesLeftInTurn == 0)
         {
            if(!this.currentTurn.ready)
            {
               this._isStalled = true;
               return;
            }
            this._isStalled = false;
            this.endOfTurnFunction();
            if(!this.gameReplay.isPlaying)
            {
               this.gameReplay.addSyncCheck(this);
            }
            this.game.executeTurn(this.currentTurn);
            ++this.turn;
            this.temp = this.currentTurn;
            this.currentTurn = this.nextTurn;
            this.nextTurn = this.nextnextTurn;
            this.nextnextTurn = this.temp;
            this.nextnextTurn.init();
            this.framesLeftInTurn = this.turnSize = this.currentTurn.turnSize;
            this.frameRate = this.currentTurn.frameRate;
            this.ping = this.currentTurn.ping;
         }
         if(!GameScreen(param1).isPaused)
         {
            this.game.update(param1);
         }
         this.frame += 1;
         --this.framesLeftInTurn;
      }
      
      public function updateFPS() : void
      {
         this.lastNFrames.push(getTimer() - this.lastTime);
         if(this.lastNFrames.length > 60 * 10)
         {
            this.lastNFrames.shift();
         }
         this.lastTime = getTimer();
      }
      
      public function processMove(param1:Move) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!this.gameReplay.isPlaying)
         {
            this.gameReplay.addMove(param1,this);
         }
         if(param1.turn + 1 == this.turn)
         {
            this.currentTurn.processMove(param1);
         }
         else if(param1.turn == this.turn)
         {
            this.nextTurn.processMove(param1);
         }
         else
         {
            if(param1.turn != this.turn + 1)
            {
               throw new Error("Error with process move");
            }
            this.nextnextTurn.processMove(param1);
         }
      }
      
      public function get gameReplay() : com.brockw.simulationSync.GameReplay
      {
         return this._gameReplay;
      }
      
      public function set gameReplay(param1:com.brockw.simulationSync.GameReplay) : void
      {
         this._gameReplay = param1;
      }
      
      public function getQuickFPS() : Number
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:int = this.lastNFrames.length - 1;
         while(_loc3_ >= 0 && _loc2_ < 10)
         {
            _loc1_ += this.lastNFrames[_loc3_];
            _loc2_++;
            _loc3_--;
         }
         return 1000 / (_loc1_ / _loc2_);
      }
      
      public function get fps() : Number
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.lastNFrames.length)
         {
            _loc1_ += this.lastNFrames[_loc2_];
            _loc2_++;
         }
         this.fps = 1000 / (_loc1_ / this.lastNFrames.length);
         return this._fps;
      }
      
      public function set fps(param1:Number) : void
      {
         this._fps = param1;
      }
      
      public function get hasStarted() : Boolean
      {
         return this._hasStarted;
      }
      
      public function set hasStarted(param1:Boolean) : void
      {
         this._hasStarted = param1;
      }
      
      public function get isStalled() : Boolean
      {
         return this._isStalled;
      }
      
      public function set isStalled(param1:Boolean) : void
      {
         this._isStalled = param1;
      }
      
      public function get game() : com.brockw.simulationSync.Simulation
      {
         return this._game;
      }
      
      public function set game(param1:com.brockw.simulationSync.Simulation) : void
      {
         this._game = param1;
      }
   }
}
