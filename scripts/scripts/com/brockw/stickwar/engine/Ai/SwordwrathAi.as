package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class SwordwrathAi extends UnitAi
      {
             
            
            public function SwordwrathAi(param1:Swordwrath)
            {
                  super();
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(currentCommand.type == UnitCommand.SWORDWRATH_RAGE)
                  {
                        Swordwrath(unit).rage();
                        restoreMove(param1);
                  }
                  baseUpdate(param1);
            }
      }
}
