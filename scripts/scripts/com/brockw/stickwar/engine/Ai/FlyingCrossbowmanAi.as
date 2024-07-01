package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class FlyingCrossbowmanAi extends RangedAi
      {
             
            
            public function FlyingCrossbowmanAi(param1:FlyingCrossbowman)
            {
                  super(param1);
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  checkNextMove(param1);
                  super.update(param1);
            }
      }
}
