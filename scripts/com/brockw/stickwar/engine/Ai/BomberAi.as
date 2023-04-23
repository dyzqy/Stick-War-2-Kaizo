package com.brockw.stickwar.engine.Ai
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class BomberAi extends UnitAi
   {
       
      
      public function BomberAi(param1:Bomber)
      {
         super();
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         checkNextMove(param1);
         var _loc2_:Unit = this.getClosestTarget();
         if(currentCommand.type == UnitCommand.BOMBER_DETONATE)
         {
            Bomber(unit).detonate();
         }
         if(mayAttack && unit.mayAttack(_loc2_))
         {
            if(_loc2_.damageWillKill(0,unit.damageToDeal) && unit.getDirection() != _loc2_.getDirection() && unit.getDirection() == Util.sgn(_loc2_.px - unit.px))
            {
               unit.attack();
            }
            else
            {
               unit.attack();
            }
         }
         else if(mayMoveToAttack && unit.sqrDistanceTo(_loc2_) < 150000 && !unit.isGarrisoned)
         {
            unit.walk((_loc2_.px - unit.px) / 30,_loc2_.py - unit.py,Util.sgn(_loc2_.px - unit.px));
            if(Math.abs(_loc2_.px - unit.px) < 10)
            {
               unit.faceDirection(_loc2_.px - unit.px);
            }
            unit.mayWalkThrough = false;
         }
         else if(mayMove)
         {
            unit.mayWalkThrough = true;
            unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
         }
         else if(_loc2_)
         {
            unit.faceDirection(_loc2_.px - unit.px);
         }
      }
   }
}
