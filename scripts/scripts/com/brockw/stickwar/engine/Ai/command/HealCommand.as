package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class HealCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new HealBitmap());
             
            
            public function HealCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.HEAL;
                  hotKey = 81;
                  _hasCoolDown = false;
                  _intendedEntityType = Unit.U_MONK;
                  requiresMouseInput = false;
                  isSingleSpell = false;
                  isToggle = true;
                  this.buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Order.Units.monk.heal);
                  }
            }
            
            override public function isToggled(param1:Entity) : Boolean
            {
                  return Monk(param1).isHealToggled;
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
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(Unit(param1).team.game.xml.xml.Order.Units.monk.heal.range,2);
            }
      }
}
