package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      
      public class EarthElementAi extends UnitAi
      {
             
            
            public function EarthElementAi(param1:EarthElement)
            {
                  super();
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(elementalCombineMove())
                  {
                        return;
                  }
                  if(currentCommand.type == UnitCommand.MORPH_MINER)
                  {
                        EarthElement(unit).morph();
                        nextMove(param1);
                  }
                  baseUpdate(param1);
            }
      }
}
