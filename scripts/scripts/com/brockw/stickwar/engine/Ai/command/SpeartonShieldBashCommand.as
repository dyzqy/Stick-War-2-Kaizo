package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class SpeartonShieldBashCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new shieldHitBitmap());
             
            
            public function SpeartonShieldBashCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.SHIELD_BASH;
                  hotKey = 87;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_SPEARTON;
                  buttonBitmap = actualButtonBitmap;
                  isActivatable = false;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Order.Units.spearton.shieldBash);
                  }
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return Spearton(param1).shieldBashCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
      }
}
