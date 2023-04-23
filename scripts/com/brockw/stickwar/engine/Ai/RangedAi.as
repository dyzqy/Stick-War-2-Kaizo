package com.brockw.stickwar.engine.Ai
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class RangedAi extends UnitAi
   {
       
      
      public var mayKite:Boolean;
      
      public function RangedAi(param1:RangedUnit)
      {
         super();
         unit = param1;
         this.mayKite = false;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Number = NaN;
         if(!this.mayKite && currentTarget != null && currentTarget.isAlive() && Boolean(RangedUnit(unit).inRange(currentTarget)))
         {
            currentTarget = currentTarget;
         }
         else if(mayAttack || !this.mayKite)
         {
            currentTarget = this.getClosestTarget();
         }
         RangedUnit(unit).aim(currentTarget);
         if(Boolean(RangedUnit(unit).mayAttack(currentTarget)) && currentCommand.type != UnitCommand.MOVE)
         {
            unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
         }
         else if(!this.mayKite && currentCommand.type != UnitCommand.MOVE && Boolean(RangedUnit(unit).inRange(currentTarget)))
         {
            unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
         }
         if(mayAttack && unit.mayAttack(currentTarget) && (Boolean(RangedUnit(unit).isLoaded()) || !this.mayKite))
         {
            unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
            RangedUnit(unit).shoot(param1,currentTarget);
         }
         else if(mayMoveToAttack && currentTarget != null && unit.sqrDistanceTo(currentTarget) < 150000 && !unit.isGarrisoned)
         {
            _loc2_ = currentTarget.px - unit.px - 100 * unit.team.direction;
            if(this.mayKite && Math.abs(currentTarget.px - unit.px) < 350 && !RangedUnit(unit).isLoaded())
            {
               unit.walk(Util.sgn(unit.px - currentTarget.px),0,Util.sgn(unit.px - currentTarget.px));
            }
            else if(Boolean(RangedUnit(unit).inRange(currentTarget)) || Util.sgn(_loc2_) != Util.sgn(currentTarget.px - unit.px))
            {
               _loc2_ = 0;
               unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
            }
            else
            {
               unit.walk(_loc2_ / 100,(goalY - unit.py) / 100,Util.sgn(currentTarget.px - unit.px));
            }
         }
         else if(mayMove)
         {
            unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
         }
         else if(currentTarget != null)
         {
            unit.faceDirection(Util.sgn(currentTarget.px - unit.px));
         }
      }
   }
}
