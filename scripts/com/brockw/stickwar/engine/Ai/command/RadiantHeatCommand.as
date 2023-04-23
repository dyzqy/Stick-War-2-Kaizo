package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   import flash.display.*;
   
   public class RadiantHeatCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new radiantBitmap());
       
      
      public function RadiantHeatCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.RADIANT_HEAT;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_LAVA_ELEMENT;
         requiresMouseInput = false;
         isSingleSpell = false;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Elemental.Units.lavaElement.radiant);
         }
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return LavaElement(param1).radiantCooldown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return LavaElement(param1).radiantCooldown() == 0;
      }
      
      override public function inRange(param1:Entity) : Boolean
      {
         return true;
      }
   }
}
