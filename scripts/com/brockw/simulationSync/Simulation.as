package com.brockw.simulationSync
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.engine.Team.Team;
   import flash.display.Sprite;
   
   public class Simulation extends Sprite
   {
       
      
      private var _gameOver:Boolean;
      
      private var _winner:Team;
      
      private var _frame:int;
      
      private var _isReplay:Boolean;
      
      public function Simulation()
      {
         super();
         this._gameOver = false;
         this._isReplay = false;
         this.frame = 0;
      }
      
      public function executeTurn(param1:Turn) : void
      {
      }
      
      public function update(param1:Screen) : void
      {
         ++this.frame;
      }
      
      public function postInit() : void
      {
      }
      
      public function getCheckSum() : int
      {
         return 0;
      }
      
      public function init(param1:int) : void
      {
         this._gameOver = false;
         this.frame = 0;
      }
      
      public function get gameOver() : Boolean
      {
         return this._gameOver;
      }
      
      public function set gameOver(param1:Boolean) : void
      {
         this._gameOver = param1;
      }
      
      public function get winner() : Team
      {
         return this._winner;
      }
      
      public function set winner(param1:Team) : void
      {
         this._winner = param1;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
      }
      
      public function get isReplay() : Boolean
      {
         return this._isReplay;
      }
      
      public function set isReplay(param1:Boolean) : void
      {
         this._isReplay = param1;
      }
   }
}
