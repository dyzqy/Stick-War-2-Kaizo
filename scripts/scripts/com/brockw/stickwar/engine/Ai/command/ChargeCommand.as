package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class ChargeCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new knightChargeBitmap());
             
            
            public function ChargeCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.KNIGHT_CHARGE;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_KNIGHT;
                  requiresMouseInput = false;
                  isSingleSpell = false;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Chaos.Units.knight.charge);
                  }
            }
            
            override public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  while(param1.numChildren != 0)
                  {
                        param1.removeChildAt(0);
                  }
                  param1.addChild(cursor);
                  cursor.x = param2.game.battlefield.mouseX;
                  cursor.y = param2.game.battlefield.mouseY;
                  cursor.width = param2.game.xml.xml.Order.Units.magikill.poisonRange / 2;
                  cursor.height = param2.game.xml.xml.Order.Units.magikill.poisonArea * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  if(cursor.y + cursor.height < 0)
                  {
                        cursor.alpha = 1 - Math.abs(cursor.y) / 200;
                  }
                  else
                  {
                        cursor.alpha = 1;
                  }
                  cursor.gotoAndStop(1);
                  return true;
            }
            
            override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  super.drawCursorPostClick(param1,param2);
                  return true;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return Knight(param1).getChargeCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return Knight(param1).getChargeCooldown() != 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(Unit(param1).team.game.xml.xml.Chaos.Units.knight.chargeRange,2);
            }
      }
}
