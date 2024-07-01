package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class StunCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new MagikillWall());
             
            
            private var area:Number;
            
            private var range:Number;
            
            public function StunCommand(param1:StickWar)
            {
                  super();
                  this.game = param1;
                  type = UnitCommand.STUN;
                  hotKey = 87;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_MAGIKILL;
                  isSingleSpell = true;
                  requiresMouseInput = true;
                  this.buttonBitmap = actualButtonBitmap;
                  cursor = new electricWallCursor();
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Order.Units.magikill.electricWall);
                        this.area = param1.xml.xml.Order.Units.magikill.electricWall.area;
                        this.range = param1.xml.xml.Order.Units.magikill.electricWall.range;
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
                  cursor.x = param2.game.battlefield.mouseX - this.area / 2;
                  cursor.y = 0;
                  cursor.width = this.area;
                  cursor.height = param2.game.map.height;
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
            
            override public function prepareNetworkedMove(param1:GameScreen) : *
            {
                  var _loc3_:String = null;
                  var _loc2_:UnitMove = new UnitMove();
                  _loc2_.moveType = this.type;
                  for(_loc3_ in param1.team.units)
                  {
                        if(Boolean(Unit(param1.team.units[_loc3_]).selected) && param1.team.units[_loc3_] is Magikill && Magikill(param1.team.units[_loc3_]).stunCooldown() == 0)
                        {
                              if(this.intendedEntityType == -1 || this.intendedEntityType == param1.team.units[_loc3_].type)
                              {
                                    _loc2_.units.push(param1.team.units[_loc3_].id);
                              }
                              break;
                        }
                  }
                  _loc2_.arg0 = param1.game.battlefield.mouseX;
                  _loc2_.arg1 = Math.max(0,Math.min(param1.game.map.height,param1.game.battlefield.mouseY));
                  if(param1.userInterface.keyBoardState.isShift)
                  {
                        _loc2_.queued = true;
                  }
                  param1.doMove(_loc2_,team.id);
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return Magikill(param1).stunCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.range,2);
            }
      }
}
