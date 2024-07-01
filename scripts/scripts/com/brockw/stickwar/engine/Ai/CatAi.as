package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class CatAi extends UnitAi
      {
             
            
            public function CatAi(param1:Cat)
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
