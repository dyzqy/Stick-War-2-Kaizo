package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.*;
      
      public class TeleportCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new teleportBitmap());
             
            
            private var nukeArea:Number;
            
            private var nukeRange:Number;
            
            public function TeleportCommand(param1:StickWar)
            {
                  super();
                  this.game = param1;
                  type = UnitCommand.TELEPORT;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_CHROME_ELEMENT;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.chrome.teleport);
                        this.nukeArea = 50;
                        this.nukeRange = param1.xml.xml.Elemental.Units.chrome.teleport.range;
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
                  while(param1.numChildren != 0)
                  {
                        param1.removeChildAt(0);
                  }
                  param1.addChild(cursor);
                  cursor.x = param2.game.battlefield.mouseX;
                  cursor.y = param2.game.battlefield.mouseY;
                  cursor.width = this.nukeArea;
                  cursor.height = 0.7 * this.nukeArea * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  if(cursor.y + cursor.height < 0)
                  {
                        cursor.alpha = 1 - Math.abs(cursor.y) / 200;
                  }
                  else
                  {
                        cursor.alpha = 1;
                  }
                  cursor.gotoAndStop(1);
                  this.drawRangeIndicators(param1,this.nukeRange,true,param2);
                  return true;
            }
            
            override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  super.drawCursorPostClick(param1,param2);
                  return true;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return ChromeElement(param1).teleportCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return ChromeElement(param1).teleportCooldown() == 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.nukeRange,2);
            }
      }
}
