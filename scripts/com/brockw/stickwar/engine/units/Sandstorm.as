package com.brockw.stickwar.engine.units
{
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import flash.display.*;
   
   public class Sandstorm extends Unit
   {
       
      
      public var lifeFrames:int;
      
      public var totalFrames:int;
      
      public function Sandstorm(param1:StickWar, param2:Team)
      {
         super(param1);
         this.team = param2;
      }
      
      override public function isTargetable() : Boolean
      {
         return false;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:AttackMoveCommand = null;
         if(this.totalFrames - this.lifeFrames == 30 * 1)
         {
            param1.projectileManager.initSandstormEye(px,0,-10,param1.team,team.direction,this.lifeFrames);
         }
         --this.lifeFrames;
         if(this.lifeFrames == 1)
         {
            _loc2_ = null;
            _loc2_ = team.game.unitFactory.getUnit(Unit.U_EARTH_ELEMENT);
            team.spawn(_loc2_,team.game,false);
            _loc2_.x = _loc2_.px = px;
            _loc2_.y = _loc2_.py = team.game.map.height / 2;
            team.population += _loc2_.population;
            _loc3_ = new AttackMoveCommand(param1);
            _loc3_.type = UnitCommand.ATTACK_MOVE;
            if(team.direction == 1)
            {
               _loc3_.goalX = Math.max(team.homeX + team.direction * 1000,_loc2_.x);
            }
            else
            {
               _loc3_.goalX = Math.min(team.homeX + team.direction * 1000,_loc2_.x);
            }
            _loc3_.goalY = _loc2_.y;
            _loc3_.realX = _loc3_.goalX;
            _loc3_.realY = _loc3_.goalY;
            _loc2_.ai.setCommand(param1,_loc3_);
            team.game.projectileManager.initCombineEffect(_loc2_.x,_loc2_.y,0,team,team.direction);
            team.game.soundManager.playSound("combineSound",_loc2_.x,_loc2_.y);
         }
      }
      
      override public function isAlive() : Boolean
      {
         return true;
      }
   }
}
