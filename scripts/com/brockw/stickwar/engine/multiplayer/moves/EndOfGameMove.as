package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class EndOfGameMove extends Move
   {
       
      
      private var _winner:int;
      
      public function EndOfGameMove()
      {
         type = Commands.END_OF_GAME;
         this._winner = -1;
         super();
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         return _loc1_ + (String(this._winner) + " ");
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this._winner = int(param1.shift());
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this._winner = param1.getInt("winner");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         param1.putInt("winner",this._winner);
      }
      
      override public function execute(param1:Simulation) : void
      {
         trace("END OF GMAE MOVE");
         var _loc2_:StickWar = StickWar(param1);
         _loc2_.gameOver = true;
      }
      
      public function get winner() : int
      {
         return this._winner;
      }
      
      public function set winner(param1:int) : void
      {
         this._winner = param1;
      }
   }
}
