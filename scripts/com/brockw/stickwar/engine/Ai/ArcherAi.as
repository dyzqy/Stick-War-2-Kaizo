package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class ArcherAi extends RangedAi
   {
       
      
      public function ArcherAi(param1:Archer)
      {
         super(param1);
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         checkNextMove(param1);
         if(currentCommand.type == UnitCommand.ARCHER_FIRE)
         {
            Archer(unit).archerFireArrow();
            restoreMove(param1);
         }
         super.update(param1);
      }
   }
}
