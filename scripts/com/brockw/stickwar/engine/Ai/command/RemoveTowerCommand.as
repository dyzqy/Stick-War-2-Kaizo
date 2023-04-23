package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class RemoveTowerCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandStop());
       
      
      public function RemoveTowerCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.REMOVE_TOWER_COMMAND;
         hotKey = 83;
         buttonBitmap = actualButtonBitmap;
         _intendedEntityType = Unit.U_CHAOS_TOWER;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Chaos.Units.tower.remove);
         }
         this.isSingleSpell = true;
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
   }
}
