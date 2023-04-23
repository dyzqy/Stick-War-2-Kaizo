package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class CureCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CureBitmap());
       
      
      private var cureRange:Number;
      
      public function CureCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.CURE;
         hotKey = 87;
         _hasCoolDown = false;
         _intendedEntityType = Unit.U_MONK;
         requiresMouseInput = false;
         isSingleSpell = false;
         isToggle = true;
         this.buttonBitmap = actualButtonBitmap;
         this.cureRange = 0;
         if(param1 != null)
         {
            this.cureRange = param1.xml.xml.Order.Units.monk.cure.range;
            this.loadXML(param1.xml.xml.Order.Units.monk.cure);
         }
      }
      
      override public function isToggled(param1:Entity) : Boolean
      {
         return Monk(param1).isCureToggled;
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
         return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.cureRange,2);
      }
   }
}
