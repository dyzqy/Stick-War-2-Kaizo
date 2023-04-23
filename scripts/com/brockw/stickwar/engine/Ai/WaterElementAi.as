package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class WaterElementAi extends UnitAi
   {
       
      
      public function WaterElementAi(param1:WaterElement)
      {
         super();
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         if(currentCommand.type == UnitCommand.WATER_HEAL)
         {
            WaterElement(unit).healExplosion();
            restoreMove(param1);
         }
         if(!elementalCombineMove())
         {
            super.baseUpdate(param1);
         }
      }
   }
}
