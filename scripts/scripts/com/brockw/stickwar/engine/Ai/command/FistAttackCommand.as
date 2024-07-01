package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class FistAttackCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new skeletalFistBitmap());
             
            
            private var range:Number;
            
            private var area:Number;
            
            public function FistAttackCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.FIST_ATTACK;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_SKELATOR;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(param1 != null)
                  {
                        this.game = param1;
                        this.loadXML(param1.xml.xml.Chaos.Units.skelator.fist);
                        this.range = param1.xml.xml.Chaos.Units.skelator.fist.range;
                        this.area = param1.xml.xml.Chaos.Units.skelator.fist.area;
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
                  cursor.width = this.range / 2;
                  cursor.height = this.area * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  if(cursor.y + cursor.height < 0)
                  {
                        cursor.alpha = 1 - Math.abs(cursor.y) / 200;
                  }
                  else
                  {
                        cursor.alpha = 1;
                  }
                  cursor.gotoAndStop(1);
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
                  return Skelator(param1).fistAttackCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return Skelator(param1).fistAttackCooldown() != 0;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.range,2);
            }
      }
}
