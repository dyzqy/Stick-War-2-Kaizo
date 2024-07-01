package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class NinjaStackCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new NinjaStack());
             
            
            public function NinjaStackCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.NINJA_STACK;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_NINJA;
                  requiresMouseInput = false;
                  isSingleSpell = false;
                  isActivatable = false;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Order.Units.ninja.fury);
                  }
            }
      }
}
