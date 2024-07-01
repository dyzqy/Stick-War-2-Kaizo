package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.geom.ColorTransform;
      
      public class ConstructTowerCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new ChaosTowerBitmap());
            
            public static const chaosTower:chaosTowerMc = new chaosTowerMc();
             
            
            private var constructRange:Number;
            
            private var scale:Number;
            
            public function ConstructTowerCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.CONSTRUCT_TOWER;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_CHAOS_MINER;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  chaosTower.gotoAndStop("attack");
                  cursor = chaosTower;
                  if(param1 != null)
                  {
                        this.scale = param1.xml.xml.Chaos.Units.tower.scale;
                        this.loadXML(param1.xml.xml.Chaos.Units.miner.tower);
                        this.constructRange = param1.xml.xml.Chaos.Units.miner.tower.constructRange;
                  }
            }
            
            override public function mayCast(param1:GameScreen, param2:Team) : Boolean
            {
                  var _loc3_:Number = param1.game.battlefield.mouseX;
                  var _loc4_:Number = param1.game.battlefield.mouseY;
                  if(param2.direction * _loc3_ < param2.direction * (param2.statue.px + param2.direction * 1.3 * param2.statue.width))
                  {
                        return false;
                  }
                  if(param2.direction * _loc3_ > param2.direction * (param2.enemyTeam.statue.px + param2.direction * 1.3 * param2.enemyTeam.statue.width))
                  {
                        return false;
                  }
                  if(param2.direction * _loc3_ > param2.direction * (param2.game.map.width / 2 - 400 * param2.direction))
                  {
                        return false;
                  }
                  if(_loc4_ < 10 || _loc4_ > param2.game.map.height - 10)
                  {
                        return false;
                  }
                  return true;
            }
            
            override public function unableToCastMessage() : String
            {
                  return "Unable to construct in this region.";
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
                  var _loc3_:ColorTransform = cursor.transform.colorTransform;
                  if(!this.mayCast(param2,param2.team))
                  {
                        _loc3_.redOffset = 50;
                        cursor.alpha = 0.8;
                  }
                  else
                  {
                        _loc3_.redOffset = 0;
                        cursor.alpha = 1;
                  }
                  cursor.transform.colorTransform = _loc3_;
                  param1.addChild(cursor);
                  cursor.x = param2.game.battlefield.mouseX;
                  cursor.y = param2.game.battlefield.mouseY;
                  var _loc4_:Number = this.scale * (param2.game.backScale + cursor.y / param2.game.map.height * (param2.game.frontScale - param2.game.backScale));
                  cursor.scaleX = -param2.team.direction * _loc4_;
                  cursor.scaleY = _loc4_;
                  return true;
            }
            
            override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
            {
                  super.drawCursorPostClick(param1,param2);
                  return true;
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return MinerChaos(param1).constructCooldown();
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(this.constructRange,2);
            }
      }
}
