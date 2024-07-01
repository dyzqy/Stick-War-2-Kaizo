package com.brockw.stickwar.engine.multiplayer.moves
{
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.Simulation;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Team.Team;
      import com.smartfoxserver.v2.entities.data.SFSObject;
      
      public class ForfeitMove extends Move
      {
             
            
            public function ForfeitMove()
            {
                  type = Commands.FORFEIT;
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
                  _loc2_.gameScreen.isPaused = false;
                  var _loc3_:Team = _loc2_.getTeamFromId(owner);
                  _loc3_.statue.health = 0;
            }
      }
}
