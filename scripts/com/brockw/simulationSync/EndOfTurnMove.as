package com.brockw.simulationSync
{
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class EndOfTurnMove extends Move
   {
       
      
      private var _expectedNumberOfMoves:int;
      
      private var _frameRate:int;
      
      private var _turnSize:int;
      
      private var _ping:Number;
      
      public function EndOfTurnMove()
      {
         type = Commands.END_OF_TURN;
         super();
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this._expectedNumberOfMoves = param1.getInt("n");
         this._frameRate = param1.getInt("f");
         this._turnSize = param1.getInt("t");
         this._ping = param1.getFloat("p");
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         _loc1_ += String(this._expectedNumberOfMoves) + " ";
         _loc1_ += String(this._frameRate) + " ";
         return _loc1_ + String(this._turnSize);
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this._expectedNumberOfMoves = int(param1.shift());
         this._frameRate = int(param1.shift());
         this._turnSize = int(param1.shift());
         return true;
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         param1.putInt("f",this._frameRate);
         param1.putInt("t",this._turnSize);
         param1.putInt("n",this._expectedNumberOfMoves);
      }
      
      override public function execute(param1:Simulation) : void
      {
      }
      
      public function get expectedNumberOfMoves() : int
      {
         return this._expectedNumberOfMoves;
      }
      
      public function set expectedNumberOfMoves(param1:int) : void
      {
         this._expectedNumberOfMoves = param1;
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
