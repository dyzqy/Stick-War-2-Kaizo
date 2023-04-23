package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class ElementalMinerAi extends MinerAi
   {
       
      
      public function ElementalMinerAi(param1:ElementalMiner)
      {
         super(param1);
      }
      
      override public function update(param1:StickWar) : void
      {
         if(currentCommand.type == UnitCommand.MORPH_MINER)
         {
            ElementalMiner(unit).morph();
            nextMove(param1);
         }
         super.update(param1);
      }
   }
}
