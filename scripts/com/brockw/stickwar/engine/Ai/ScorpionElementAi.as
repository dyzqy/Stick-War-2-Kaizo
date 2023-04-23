package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class ScorpionElementAi extends UnitAi
   {
       
      
      public function ScorpionElementAi(param1:ScorpionElement)
      {
         super();
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         baseUpdate(param1);
      }
   }
}
