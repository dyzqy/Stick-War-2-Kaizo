package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.*;
      
      public class BurrowCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new burrowBitmap());
             
            
            public function BurrowCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.BURROW;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_LAVA_ELEMENT;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.lavaElement.burrow);
                  }
                  hotKey = 87;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return LavaElement(param1).burrowCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
      }
}
