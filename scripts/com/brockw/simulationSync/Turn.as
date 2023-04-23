package com.brockw.simulationSync
{
   import com.brockw.ds.Heap;
   
   public class Turn
   {
       
      
      private var _frameRate:int;
      
      private var _turnSize:int;
      
      private var _ready:Boolean;
      
      private var _ping:Number;
      
      private var _moves:Heap;
      
      private var isEndOfTurn:Boolean;
      
      private var expectedNumberOfMoves:int;
      
      public function Turn()
      {
         super();
         this.moves = new Heap(10000);
         this.turnSize = 5;
         this.frameRate = 30;
         this.ping = 0;
      }
      
      public function init() : void
      {
         this._ready = false;
         this.moves.clear();
         this.isEndOfTurn = false;
      }
      
      public function processMove(param1:Move) : void
      {
         var _loc2_:EndOfTurnMove = null;
         if(param1.type == Move.END_OF_TURN)
         {
            _loc2_ = EndOfTurnMove(param1);
            this.isEndOfTurn = true;
            this.expectedNumberOfMoves = _loc2_.expectedNumberOfMoves;
            this.turnSize = _loc2_.turnSize;
            this.frameRate = _loc2_.frameRate;
            this.ping = _loc2_.ping;
         }
         else
         {
            this.moves.insert(param1);
         }
         if(Boolean(this.isEndOfTurn) && this.moves.size() == this.expectedNumberOfMoves)
         {
            this.ready = true;
         }
      }
      
      public function getNumberOfMoves() : int
      {
         return this.moves.size();
      }
      
      public function get frameRate() : int
      {
         return this._frameRate;
      }
      
      public function set frameRate(param1:int) : void
      {
         this._frameRate = param1;
      }
      
      public function get turnSize() : int
      {
         return this._turnSize;
      }
      
      public function set turnSize(param1:int) : void
      {
         this._turnSize = param1;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function set ready(param1:Boolean) : void
      {
         this._ready = param1;
      }
      
      public function get moves() : Heap
      {
         return this._moves;
      }
      
      public function set moves(param1:Heap) : void
      {
         this._moves = param1;
      }
      
      public function get ping() : Number
      {
         return this._ping;
      }
      
      public function set ping(param1:Number) : void
      {
         this._ping = param1;
      }
   }
}
