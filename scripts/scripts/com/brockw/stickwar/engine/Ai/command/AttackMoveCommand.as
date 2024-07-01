package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      import flash.geom.*;
      
      public class AttackMoveCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandAttackMove());
             
            
            private var _distanceToGoal:Number;
            
            private var troubleDistanceToGoal:Number;
            
            private var isHavingTrouble:Boolean;
            
            private var havingTroubleTime:int;
            
            public function AttackMoveCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.ATTACK_MOVE;
                  this.havingTroubleTime = 0;
                  this.isHavingTrouble = false;
                  hotKey = 65;
                  requiresMouseInput = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1.team.type == Team.T_CHAOS)
                  {
                        cursor = new chaosAttackMoveMc();
                  }
                  else if(param1.team.type == Team.T_GOOD)
                  {
                        cursor = new orderAttackMoveMc();
                  }
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Commands.attackMove);
                  }
            }
            
            override public function playSound(param1:StickWar) : void
            {
                  param1.soundManager.playSoundFullVolumeRandom("CommandMove",3);
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
                  cursor.scaleX = 0.9;
                  cursor.scaleY = 0.9;
                  return true;
            }
            
            override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  var _loc3_:Cursor = null;
                  param2.game.postCursors.push(_loc3_ = new Cursor());
                  param1.addChild(_loc3_);
                  _loc3_.x = param2.game.battlefield.mouseX;
                  _loc3_.y = param2.game.battlefield.mouseY;
                  var _loc4_:Number = param2.userInterface.hud.hud.map.mouseX / param2.userInterface.hud.hud.map.width;
                  var _loc5_:Number = param2.userInterface.hud.hud.map.mouseY / param2.userInterface.hud.hud.map.height;
                  var _loc6_:Point;
                  var _loc7_:Number = (_loc6_ = param2.userInterface.hud.hud.map.globalToLocal(new Point(param2.userInterface.mouseState.mouseDownX,param2.userInterface.mouseState.mouseDownY))).x / param2.userInterface.hud.hud.map.width;
                  var _loc8_:Number = _loc6_.y / param2.userInterface.hud.hud.map.height;
                  if(_loc4_ >= 0 && _loc4_ <= 1 && _loc5_ >= 0 && _loc5_ <= 1 && _loc7_ >= 0 && _loc7_ <= 1 && _loc8_ >= 0 && _loc8_ <= 1)
                  {
                        _loc3_.x = _loc4_ * param2.game.map.width;
                        _loc3_.y = _loc5_ * param2.game.map.height;
                  }
                  return true;
            }
            
            public function init() : void
            {
                  this._distanceToGoal = 0;
            }
            
            override public function cleanUpPreClick(param1:Sprite) : void
            {
                  if(param1.contains(cursor))
                  {
                        param1.removeChild(cursor);
                  }
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  ++this.havingTroubleTime;
                  this._distanceToGoal = Math.sqrt(Math.pow(param1.x - goalX,2) + Math.pow(param1.y - goalY,2));
                  if(this.isHavingTrouble == false && this.havingTroubleTime > 30 * 3)
                  {
                        this.isHavingTrouble = true;
                        this.troubleDistanceToGoal = this._distanceToGoal;
                        ++this.havingTroubleTime;
                        return false;
                  }
                  this.havingTroubleTime %= 10;
                  if(this.havingTroubleTime == 0)
                  {
                        this.troubleDistanceToGoal = this._distanceToGoal;
                  }
                  return Math.abs(goalX - param1.x) < 5 && Math.abs(goalY - param1.y) < 5;
            }
      }
}
