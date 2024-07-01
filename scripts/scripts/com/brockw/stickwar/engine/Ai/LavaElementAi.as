package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      
      public class LavaElementAi extends UnitAi
      {
             
            
            public function LavaElementAi(param1:LavaElement)
            {
                  super();
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(currentCommand.type == UnitCommand.RADIANT_HEAT)
                  {
                        LavaElement(unit).toggleRadiant();
                        restoreMove(param1);
                        baseUpdate(param1);
                  }
                  else if(currentCommand.type == UnitCommand.BURROW)
                  {
                        LavaElement(unit).burrow();
                        restoreMove(param1);
                  }
                  else if(currentCommand.type == UnitCommand.UNBURROW)
                  {
                        LavaElement(unit).unburrow();
                        restoreMove(param1);
                  }
                  baseUpdate(param1);
            }
      }
}
