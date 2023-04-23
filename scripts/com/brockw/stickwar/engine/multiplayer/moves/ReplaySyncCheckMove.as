package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class ReplaySyncCheckMove extends Move
   {
       
      
      public var checkSum:int;
      
      public function ReplaySyncCheckMove()
      {
         type = Commands.REPLAY_SYNC_CHECK;
         this.checkSum = 0;
         super();
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         return _loc1_ + (String(this.checkSum) + " ");
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this.checkSum = int(param1.shift());
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this.checkSum = param1.getInt("checkSum");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         param1.putInt("checkSum",this.checkSum);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc2_:StickWar = null;
         trace(this.frame,this.turn,param1.getCheckSum(),this.checkSum);
         if(param1.getCheckSum() != this.checkSum)
         {
            _loc2_ = StickWar(param1);
            _loc2_.gameScreen.showMessage("Replay is out of sync");
         }
      }
   }
}
