package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class BomberDetonateCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new DetonateBitmap());
       
      
      public function BomberDetonateCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.BOMBER_DETONATE;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_BOMBER;
         requiresMouseInput = false;
         isSingleSpell = false;
         buttonBitmap = actualButtonBitmap;
         if(param1 != null)
         {
            this.loadXML(param1.xml.xml.Chaos.Units.bomber.detonate);
         }
      }
      
      override public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
      {
         return true;
      }
      
      override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
      {
         return true;
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
         return true;
      }
   }
}
