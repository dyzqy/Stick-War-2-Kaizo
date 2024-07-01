package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class DeadPoisonCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new poisonGutsBitmap());
             
            
            public function DeadPoisonCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.DEAD_POISON;
                  hotKey = 81;
                  _hasCoolDown = false;
                  _intendedEntityType = Unit.U_DEAD;
                  requiresMouseInput = false;
                  isSingleSpell = false;
                  isToggle = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Chaos.Units.dead.poison);
                  }
            }
            
            override public function isToggled(param1:Entity) : Boolean
            {
                  return Dead(param1).isPoisonedToggled;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return 0;
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return true;
            }
      }
}
