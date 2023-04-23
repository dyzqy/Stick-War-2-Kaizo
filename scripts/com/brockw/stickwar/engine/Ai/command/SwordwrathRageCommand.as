package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class SwordwrathRageCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new SwordwrathSacrifice());
       
      
      public function SwordwrathRageCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.SWORDWRATH_RAGE;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_SWORDWRATH;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Order.Units.swordwrath.rage);
         }
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Swordwrath(param1).rageCooldown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
