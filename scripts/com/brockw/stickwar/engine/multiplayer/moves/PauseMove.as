package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class PauseMove extends Move
   {
       
      
      public function PauseMove()
      {
         type = Commands.PAUSE;
         super();
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc2_:StickWar = StickWar(param1);
         if(_loc2_.teamA.id == this.owner)
         {
            if(!_loc2_.gameScreen.isPaused)
            {
               ++_loc2_.teamA.pauseCount;
               if(_loc2_.teamA.pauseCount > 3)
               {
                  return;
               }
            }
         }
         else if(_loc2_.teamB.id == this.owner)
         {
            if(!_loc2_.gameScreen.isPaused)
            {
               ++_loc2_.teamB.pauseCount;
               if(_loc2_.teamB.pauseCount > 3)
               {
                  return;
               }
            }
         }
         _loc2_.gameScreen.isPaused = !_loc2_.gameScreen.isPaused;
      }
   }
}
