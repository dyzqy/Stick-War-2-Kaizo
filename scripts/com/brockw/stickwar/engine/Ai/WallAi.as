package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class WallAi extends UnitAi
   {
       
      
      public function WallAi(param1:Wall)
      {
         super();
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         checkNextMove(param1);
         if(this.currentCommand.type == UnitCommand.REMOVE_WALL_COMMAND)
         {
            this.unit.team.removeWall(Wall(unit));
         }
      }
   }
}
