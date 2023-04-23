package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class StealthCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new NinjaCloak());
       
      
      public function StealthCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.STEALTH;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_NINJA;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Order.Units.ninja.stealth);
         }
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Ninja(param1).stealthCooldown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
