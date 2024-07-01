package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      
      public class SlowDartCommand extends DartCommand
      {
             
            
            public function SlowDartCommand(param1:StickWar)
            {
                  super(param1);
                  this.game = param1;
                  type = UnitCommand.SLOW_DART;
                  hotKey = 69;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_MONK;
                  requiresMouseInput = true;
                  isSingleSpell = true;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return Monk(param1).slowDartCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return Monk(param1).slowDartCooldown() != 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(Unit(param1).team.game.xml.xml.Order.Units.magikill.poisonRange,2);
            }
      }
}
