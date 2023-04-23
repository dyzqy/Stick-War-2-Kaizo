package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.AirElement;
   
   public class AirElementAi extends RangedAi
   {
       
      
      public function AirElementAi(param1:AirElement)
      {
         super(param1);
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         checkNextMove(param1);
         if(!elementalCombineMove())
         {
            super.update(param1);
         }
      }
   }
}
