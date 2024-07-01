package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.FireElement;
      
      public class FireElementAi extends RangedAi
      {
             
            
            public function FireElementAi(param1:FireElement)
            {
                  super(param1);
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  checkNextMove(param1);
                  if(!elementalCombineMove())
                  {
                        super.update(param1);
                  }
            }
      }
}
