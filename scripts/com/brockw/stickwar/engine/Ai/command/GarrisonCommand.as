package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class GarrisonCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandGarrison());
       
      
      public function GarrisonCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.GARRISON;
         hotKey = 71;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Commands.garrison);
         }
      }
      
      override public function playSound(param1:StickWar) : void
      {
         param1.soundManager.playSoundFullVolume("GarrisonEnter");
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return true;
      }
   }
}
