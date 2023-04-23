package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class SpeartonAi extends UnitAi
   {
       
      
      public function SpeartonAi(param1:Spearton)
      {
         super();
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         if(currentCommand.type == UnitCommand.SPEARTON_BLOCK)
         {
            if(Spearton(unit).inBlock)
            {
               Spearton(unit).stopBlocking();
            }
            else
            {
               Spearton(unit).startBlocking();
            }
            nextMove(param1);
         }
         else if(currentCommand.type != UnitCommand.STAND)
         {
            Spearton(unit).stopBlocking();
         }
         baseUpdate(param1);
      }
   }
}
