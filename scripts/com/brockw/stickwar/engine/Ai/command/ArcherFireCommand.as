package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class ArcherFireCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new ArchidonFire());
       
      
      public function ArcherFireCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.ARCHER_FIRE;
         hotKey = 87;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_ARCHER;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Order.Units.archer.fire);
         }
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Archer(param1).getFireCoolDown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
