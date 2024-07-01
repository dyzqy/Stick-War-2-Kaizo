package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class MorphMinerCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new morphToMinerBitmap());
             
            
            public function MorphMinerCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.MORPH_MINER;
                  hotKey = 83;
                  buttonBitmap = actualButtonBitmap;
                  _intendedEntityType = Unit.U_EARTH_ELEMENT;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.miner.morph);
                  }
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
      }
}
