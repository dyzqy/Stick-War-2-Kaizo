package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class WingidonAi extends RangedAi
      {
             
            
            public function WingidonAi(param1:Wingidon)
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
