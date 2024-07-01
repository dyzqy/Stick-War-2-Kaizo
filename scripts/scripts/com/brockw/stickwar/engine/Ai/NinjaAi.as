package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class NinjaAi extends UnitAi
      {
             
            
            public function NinjaAi(param1:Ninja)
            {
                  super();
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(currentCommand.type == UnitCommand.STEALTH)
                  {
                        Ninja(unit).stealth();
                        restoreMove(param1);
                  }
                  baseUpdate(param1);
            }
      }
}
