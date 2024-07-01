package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class PoisonPoolCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new poisonPoolBitmap());
             
            
            private var poisonPoolArea:Number;
            
            private var poisonPoolRange:Number;
            
            public function PoisonPoolCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.POISON_POOL;
                  hotKey = 87;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_MEDUSA;
                  requiresMouseInput = false;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Chaos.Units.medusa.poison);
                        this.poisonPoolArea = param1.xml.xml.Chaos.Units.medusa.poison.area;
                        this.poisonPoolRange = param1.xml.xml.Chaos.Units.medusa.poison.range;
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
                  cursor.width = this.poisonPoolArea;
                  cursor.height = 0.7 * this.poisonPoolArea * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
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
                  return Medusa(param1).poisonPoolCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return Medusa(param1).poisonPoolCooldown() == 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.poisonPoolRange,2);
            }
      }
}
