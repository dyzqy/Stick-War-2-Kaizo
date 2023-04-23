package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class HoldCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandHold());
       
      
      public function HoldCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.HOLD;
         hotKey = 72;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Commands.hold);
         }
      }
      
      override public function playSound(param1:StickWar) : void
      {
         param1.soundManager.playSoundFullVolume("CommandHoldSound");
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
