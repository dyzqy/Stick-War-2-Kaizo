package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class KnightAi extends UnitAi
      {
             
            
            public function KnightAi(param1:Knight)
            {
                  super();
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(currentCommand.type == UnitCommand.KNIGHT_CHARGE)
                  {
                        Knight(unit).charge();
                        nextMove(param1);
                  }
                  baseUpdate(param1);
            }
      }
}
