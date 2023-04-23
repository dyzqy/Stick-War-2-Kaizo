package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class GlobalMove extends Move
   {
       
      
      public var globalMoveType:int;
      
      public function GlobalMove()
      {
         type = Commands.GLOBAL_MOVE;
         this.globalMoveType = 0;
         super();
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         return _loc1_ + (String(this.globalMoveType) + " ");
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this.globalMoveType = int(param1.shift());
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this.globalMoveType = param1.getInt("pos");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         param1.putInt("pos",this.globalMoveType);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc2_:StickWar = StickWar(param1);
         var _loc3_:Team = null;
         if(_loc2_.teamA.id == owner)
         {
            _loc3_ = _loc2_.teamA;
         }
         else if(_loc2_.teamB.id == owner)
         {
            _loc3_ = _loc2_.teamB;
         }
         if(this.globalMoveType == Team.G_GARRISON)
         {
            _loc3_.garrison(true);
         }
         else if(this.globalMoveType == Team.G_DEFEND)
         {
            _loc3_.defend(true);
         }
         else if(this.globalMoveType == Team.G_GARRISON_MINER)
         {
            _loc3_.garrisonMiner(true);
         }
         else if(this.globalMoveType == Team.G_UNGARRISON_MINER)
         {
            _loc3_.unGarrisonMiner(true);
         }
         else
         {
            _loc3_.attack(true);
         }
      }
   }
}
