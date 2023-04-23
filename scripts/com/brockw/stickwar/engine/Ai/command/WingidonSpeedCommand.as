package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class WingidonSpeedCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new SwordwrathSacrifice());
       
      
      public function WingidonSpeedCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.WINGIDON_SPEED;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_WINGIDON;
         buttonBitmap = actualButtonBitmap;
         isSingleSpell = true;
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Wingidon(param1).speedSpellCooldown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
