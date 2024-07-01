package com.brockw.stickwar.engine.multiplayer.moves
{
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.Simulation;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.replay.*;
      import com.smartfoxserver.v2.entities.data.SFSObject;
      
      public class ScreenPositionUpdateMove extends Move
      {
             
            
            public var pos:int;
            
            public function ScreenPositionUpdateMove()
            {
                  type = Commands.SCREEN_POSITION_UPDATE;
                  this.pos = 0;
                  super();
            }
            
            override public function toString() : String
            {
                  var _loc1_:String = super.toString();
                  return _loc1_ + (String(this.pos) + " ");
            }
            
            override public function fromString(param1:Array) : Boolean
            {
                  super.fromString(param1);
                  this.pos = int(param1.shift());
                  return true;
            }
            
            override public function readFromSFSObject(param1:SFSObject) : void
            {
                  readBasicsSFSObject(param1);
                  this.pos = param1.getInt("pos");
            }
            
            override public function writeToSFSObject(param1:SFSObject) : void
            {
                  writeBasicsSFSObject(param1);
                  param1.putInt("pos",this.pos);
            }
            
            override public function execute(param1:Simulation) : void
            {
                  if(!param1.isReplay)
                  {
                        return;
                  }
                  var _loc2_:StickWar = StickWar(param1);
                  if(_loc2_.gameScreen is ReplayGameScreen)
                  {
                        if(ReplayGameScreen(_loc2_.gameScreen).hasFreeCamera)
                        {
                              return;
                        }
                  }
                  if(_loc2_.teamA.id == owner)
                  {
                        _loc2_.teamA.lastScreenLookPosition = this.pos;
                  }
                  else if(_loc2_.teamB.id == owner)
                  {
                        _loc2_.teamB.lastScreenLookPosition = this.pos;
                  }
                  if(this.owner == _loc2_.team.id)
                  {
                        _loc2_.gameScreen.userInterface.isSlowCamera = true;
                        _loc2_.targetScreenX = this.pos;
                        if(Math.abs(_loc2_.targetScreenX - _loc2_.screenX) > _loc2_.map.screenWidth)
                        {
                              _loc2_.gameScreen.userInterface.isSlowCamera = false;
                        }
                  }
            }
      }
}
