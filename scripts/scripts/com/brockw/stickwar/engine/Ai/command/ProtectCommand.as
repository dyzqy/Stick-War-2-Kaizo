package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.*;
      
      public class ProtectCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new protectBitmap());
             
            
            private var range:Number;
            
            public function ProtectCommand(param1:StickWar)
            {
                  super();
                  this.game = param1;
                  type = UnitCommand.PROTECT;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_HURRICANE_ELEMENT;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new protectCursorMc();
                  if(param1 != null)
                  {
                        this.range = param1.xml.xml.Elemental.Units.hurricaneElement.protect.range;
                        this.loadXML(param1.xml.xml.Elemental.Units.hurricaneElement.protect);
                  }
                  hotKey = 81;
            }
            
            override public function cleanUpPreClick(param1:Sprite) : void
            {
                  super.cleanUpPreClick(param1);
                  if(param1.contains(cursor))
                  {
                        param1.removeChild(cursor);
                  }
            }
            
            override public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  if(param1.contains(cursor))
                  {
                        param1.removeChild(cursor);
                  }
                  param1.addChild(cursor);
                  cursor.x = param2.game.battlefield.mouseX;
                  cursor.y = param2.game.battlefield.mouseY;
                  cursor.scaleX = 1 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  cursor.scaleY = 1 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  this.drawRangeIndicators(param1,this.range,true,param2);
                  return true;
            }
            
            override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  super.drawCursorPostClick(param1,param2);
                  return true;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return HurricaneElement(param1).protectCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return HurricaneElement(param1).protectCooldown() != 0 || this.targetId == -1;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  var _loc2_:Unit = null;
                  if(targetId in game.units && game.units[targetId] is Unit)
                  {
                        _loc2_ = game.units[targetId];
                        return Math.pow(_loc2_.px - param1.px,2) + Math.pow(_loc2_.py - param1.py,2) < Math.pow(this.range,2);
                  }
                  return false;
            }
      }
}
