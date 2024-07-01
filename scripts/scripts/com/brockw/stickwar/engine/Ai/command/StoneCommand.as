package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class StoneCommand extends DartCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new medusaStoneBitmap());
             
            
            private var range:Number;
            
            public function StoneCommand(param1:StickWar)
            {
                  super(param1);
                  this.game = param1;
                  type = UnitCommand.STONE;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_MEDUSA;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new petrifyCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Chaos.Units.medusa.stone);
                        this.range = param1.xml.xml.Chaos.Units.medusa.stone.range;
                  }
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
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return Medusa(param1).stoneCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return Medusa(param1).stoneCooldown() != 0 || this.targetId == -1;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  var _loc2_:Unit = null;
                  if(targetId in game.units && game.units[targetId] is Unit)
                  {
                        _loc2_ = game.units[targetId];
                        return Math.pow(_loc2_.px - param1.px,2) + Math.pow(_loc2_.py - param1.py,2) < Math.pow(Unit(param1).team.game.xml.xml.Chaos.Units.medusa.stone.range,2);
                  }
                  return false;
            }
      }
}
