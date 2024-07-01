package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class WaterHealCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new waterHealBitmap());
             
            
            public function WaterHealCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.WATER_HEAL;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_WATER_ELEMENT;
                  requiresMouseInput = false;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.waterElement.heal);
                  }
                  this.hotKey = 81;
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
