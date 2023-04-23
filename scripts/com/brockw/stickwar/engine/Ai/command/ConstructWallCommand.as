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
   import flash.ui.*;
   
   public class ConstructWallCommand extends UnitCommand
   {
      
      public static const actualButtonBitmap:Bitmap = new Bitmap(new OrderTowerBitmap());
       
      
      private var constructRange:Number;
      
      private var wall:Wall;
      
      public function ConstructWallCommand(param1:StickWar)
      {
         super();
         type = UnitCommand.CONSTRUCT_WALL;
         hotKey = 81;
         _hasCoolDown = true;
         _intendedEntityType = Unit.U_MINER;
         requiresMouseInput = true;
         isSingleSpell = true;
         buttonBitmap = actualButtonBitmap;
         cursor = new nukeCursor();
         if(param1 != null)
         {
            this.wall = new Wall(param1,param1.team);
            this.loadXML(param1.xml.xml.Order.Units.miner.wall);
            this.constructRange = param1.xml.xml.Order.Units.miner.wall.constructRange;
         }
      }
      
      override public function cleanUpPreClick(param1:Sprite) : void
      {
         this.wall.removeFromScene(param1);
      }
      
      override public function mayCast(param1:GameScreen, param2:Team) : Boolean
      {
         var _loc3_:Number = param1.game.battlefield.mouseX;
         if(param2.direction * _loc3_ < param2.direction * (param2.statue.px + param2.direction * 1.3 * param2.statue.width))
         {
            return false;
         }
         if(param2.direction * _loc3_ > param2.direction * (param2.enemyTeam.statue.px + param2.direction * 1.3 * param2.enemyTeam.statue.width))
         {
            return false;
         }
         if(param2.direction * _loc3_ > param2.direction * (param2.game.map.width / 2 - 600 * param2.direction))
         {
            return false;
         }
         return true;
      }
      
      override public function unableToCastMessage() : String
      {
         return "Unable to construct in this region.";
      }
      
      override public function drawCursorPreClick(param1:Sprite, param2:GameScreen) : Boolean
      {
         var _loc3_:Unit = null;
         var _loc4_:ColorTransform = null;
         this.wall.removeFromScene(param1);
         this.wall.setLocation(param2.game.battlefield.mouseX);
         this.wall.setConstructionAmount(1);
         this.wall.healthBar.visible = false;
         this.wall.addToScene(param1);
         Mouse.show();
         for each(_loc3_ in this.wall.wallParts)
         {
            _loc4_ = _loc3_.transform.colorTransform;
            if(!this.mayCast(param2,param2.team))
            {
               _loc4_.redOffset = 50;
               _loc3_.alpha = 0.8;
            }
            else
            {
               _loc4_.redOffset = 0;
               _loc3_.alpha = 1;
            }
            _loc3_.transform.colorTransform = _loc4_;
         }
         return true;
      }
      
      override public function drawCursorPostClick(param1:Sprite, param2:GameScreen) : Boolean
      {
         super.drawCursorPostClick(param1,param2);
         return true;
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Miner(param1).constructCooldown();
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
