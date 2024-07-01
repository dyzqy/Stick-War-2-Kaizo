package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.*;
      
      public class SplitCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new splitBitmap());
             
            
            public function SplitCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.SPLIT;
                  hotKey = 87;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_CHROME_ELEMENT;
                  requiresMouseInput = false;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.chrome.split);
                  }
                  hotKey = 87;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return ChromeElement(param1).splitCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return ChromeElement(param1).splitCooldown() == 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return true;
            }
      }
}
