package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class DeadAi extends RangedAi
      {
             
            
            public function DeadAi(param1:Dead)
            {
                  super(param1);
                  unit = param1;
            }
            
            override public function update(param1:StickWar) : void
            {
                  checkNextMove(param1);
                  if(currentCommand.type == UnitCommand.DEAD_POISON)
                  {
                        Dead(unit).isPoisonedToggled = !Dead(unit).isPoisonedToggled;
                        restoreMove(param1);
                        baseUpdate(param1);
                  }
                  super.update(param1);
            }
      }
}
