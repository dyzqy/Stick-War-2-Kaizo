package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class CombineCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
             
            
            public function CombineCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.COMBINE;
                  hotKey = 83;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Commands.stand);
                  }
            }
            
            override public function playSound(param1:StickWar) : void
            {
                  param1.soundManager.playSoundFullVolume("CommandStopSound");
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
      }
}
