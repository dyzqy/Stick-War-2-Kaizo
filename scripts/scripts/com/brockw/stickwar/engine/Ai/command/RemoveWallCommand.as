package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class RemoveWallCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
             
            
            public function RemoveWallCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.REMOVE_WALL_COMMAND;
                  hotKey = 83;
                  buttonBitmap = actualButtonBitmap;
                  _intendedEntityType = Unit.U_WALL;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Order.Units.wall.remove);
                  }
                  this.isSingleSpell = true;
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
      }
}
