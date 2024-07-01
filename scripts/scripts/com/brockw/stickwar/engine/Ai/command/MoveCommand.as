package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import fl.motion.*;
      import flash.display.*;
      import flash.geom.*;
      import flash.ui.*;
      
      public class MoveCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new CommandMove());
            
            public static const mineClip:MovieClip = new pickaxeAnimation();
            
            public static const prayClip:MovieClip = new prayCursor();
            
            public static const attackClipOrder:MovieClip = new orderAttackMoveMc();
            
            public static const attackClipChaos:MovieClip = new chaosAttackMoveMc();
             
            
            private var _distanceToGoal:Number;
            
            private var troubleDistanceToGoal:Number;
            
            private var isHavingTrouble:Boolean;
            
            private var havingTroubleTime:int;
            
            private var attackClip:MovieClip;
            
            public function MoveCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.MOVE;
                  this.havingTroubleTime = 0;
                  this.isHavingTrouble = false;
                  hotKey = 68;
                  requiresMouseInput = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Commands.move);
                  }
                  if(param1.team.type == Team.T_CHAOS)
                  {
                        this.attackClip = new chaosAttackMoveMc();
                  }
                  else if(param1.team.type == Team.T_GOOD)
                  {
                        this.attackClip = new orderAttackMoveMc();
                  }
                  else if(param1.team.type == Team.T_ELEMENTAL)
                  {
                        this.attackClip = new orderAttackMoveMc();
                  }
                  var _loc2_:Color = new Color();
                  _loc2_.setTint(16711680,0.4);
                  this.attackClip.transform.colorTransform = _loc2_;
                  this.attackClip.scaleX *= 0.25;
                  this.attackClip.scaleY *= 0.25;
            }
            
            override public function playSound(param1:StickWar) : void
            {
                  if(targetId in param1.units)
                  {
                        if(param1.units[targetId] is Gold && Boolean(param1.gameScreen.userInterface.selectedUnits.interactsWith & Unit.I_MINE))
                        {
                              param1.soundManager.playSoundFullVolume("ClickGold");
                        }
                        else if(param1.units[targetId] is Statue && Boolean(param1.gameScreen.userInterface.selectedUnits.interactsWith & Unit.I_STATUE))
                        {
                              param1.soundManager.playSoundFullVolume("ClickMana");
                        }
                        else
                        {
                              param1.soundManager.playSoundFullVolumeRandom("CommandMove",6);
                        }
                  }
                  else
                  {
                        param1.soundManager.playSoundFullVolumeRandom("CommandMove",6);
                  }
            }
            
            public function init() : void
            {
                  this._distanceToGoal = 0;
            }
            
            private function checkIfUnitUnderCursor(param1:Unit) : void
            {
                  if(param1.hitTestPoint(param1.team.game.stage.mouseX,param1.team.game.stage.mouseY,false))
                  {
                        param1.team.register = 1;
                  }
            }
            
            override public function cleanUpPreClick(param1:Sprite) : void
            {
                  if(param1.contains(cursor))
                  {
                        param1.removeChild(cursor);
                  }
                  if(param1.contains(this.attackClip))
                  {
                        param1.removeChild(this.attackClip);
                  }
                  if(param1.contains(mineClip))
                  {
                        param1.removeChild(mineClip);
                  }
                  if(param1.contains(prayClip))
                  {
                        param1.removeChild(prayClip);
                  }
            }
            
            override public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  if(param1.contains(cursor))
                  {
                        param1.removeChild(cursor);
                  }
                  if(param1.contains(this.attackClip))
                  {
                        param1.removeChild(this.attackClip);
                  }
                  if(param1.contains(mineClip))
                  {
                        param1.removeChild(mineClip);
                  }
                  if(param1.contains(prayClip))
                  {
                        param1.removeChild(prayClip);
                  }
                  Mouse.show();
                  var _loc3_:MovieClip = null;
                  var _loc4_:*;
                  if(Boolean((_loc4_ = param2.userInterface.selectedUnits.interactsWith) & (Unit.I_MINE | Unit.I_STATUE)) && param2.game.mouseOverUnit is Statue)
                  {
                        _loc3_ = prayClip;
                        Mouse.hide();
                  }
                  else if(Boolean(_loc4_ & (Unit.I_MINE | Unit.I_STATUE)) && param2.game.mouseOverUnit is Gold)
                  {
                        _loc3_ = mineClip;
                        Mouse.hide();
                  }
                  else if(_loc4_ & Unit.I_ENEMY)
                  {
                        if(param2.game.mouseOverUnit is Unit && Unit(param2.game.mouseOverUnit).team != param2.team)
                        {
                              _loc3_ = this.attackClip;
                              Mouse.hide();
                        }
                  }
                  if(_loc3_)
                  {
                        param1.addChild(_loc3_);
                        _loc3_.x = param2.game.battlefield.mouseX;
                        _loc3_.y = param2.game.battlefield.mouseY;
                        _loc3_.scaleX = 1.3 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                        _loc3_.scaleY = 1.3 * param2.game.getPerspectiveScale(param2.game.battlefield.mouseY);
                  }
                  if(param1.contains(prayClip))
                  {
                        if(prayClip.currentFrame == prayClip.totalFrames)
                        {
                              prayClip.gotoAndStop(1);
                        }
                        else
                        {
                              prayClip.nextFrame();
                        }
                        _loc3_.scaleX *= 1.5;
                        _loc3_.scaleY *= 1.5;
                  }
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
                  if(param1.contains(cursor))
                  {
                        cursor.nextFrame();
                        if(cursor.currentFrame == cursor.totalFrames)
                        {
                              param1.removeChild(cursor);
                              return true;
                        }
                        return false;
                  }
                  if(param1.contains(mineClip))
                  {
                        mineClip.nextFrame();
                        if(mineClip.currentFrame == mineClip.totalFrames)
                        {
                              param1.removeChild(mineClip);
                              return true;
                        }
                        return false;
                  }
                  if(param1.contains(prayClip))
                  {
                        prayClip.nextFrame();
                        if(prayClip.currentFrame == prayClip.totalFrames)
                        {
                              param1.removeChild(prayClip);
                              return true;
                        }
                        return false;
                  }
                  if(param1.contains(this.attackClip))
                  {
                        this.attackClip.nextFrame();
                        if(this.attackClip.currentFrame == this.attackClip.totalFrames)
                        {
                              param1.removeChild(this.attackClip);
                              return true;
                        }
                        return false;
                  }
                  return true;
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  ++this.havingTroubleTime;
                  this._distanceToGoal = Math.sqrt(Math.pow(param1.px - goalX,2) + Math.pow(param1.py - goalY,2));
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
                  return Math.abs(goalX - param1.px) < 5 && Math.abs(goalY - param1.py) < 5;
            }
      }
}
