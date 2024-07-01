package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class GiantAi extends UnitAi
      {
             
            
            public function GiantAi(param1:Giant)
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
