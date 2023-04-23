package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class MonkAi extends UnitAi
   {
      
      private static var cureCommand:CureCommand = null;
      
      private static const healCommand:HealCommand = new HealCommand(null);
       
      
      private var inRange:Unit;
      
      public function MonkAi(param1:Monk)
      {
         super();
         unit = param1;
         isNonAttackingMage = true;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:Unit = null;
         var _loc4_:Number = NaN;
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.HEAL || currentCommand.type == UnitCommand.CURE || currentCommand.type == UnitCommand.SLOW_DART)
         {
            if(!this.currentCommand.inRange(unit))
            {
               unit.mayWalkThrough = true;
               unit.isBusyForSpell = true;
               if(currentCommand.type != UnitCommand.SLOW_DART)
               {
                  unit.walk((currentCommand.realX - unit.px) / 100,(currentCommand.realY - unit.py) / 100,intendedX);
               }
               else
               {
                  _loc2_ = null;
                  if(int(currentCommand.realX) in param1.units)
                  {
                     _loc2_ = param1.units[int(currentCommand.realX)];
                  }
                  if(_loc2_ != null)
                  {
                     unit.walk((_loc2_.px - unit.px) / 100,(_loc2_.py - unit.py) / 100,intendedX);
                  }
               }
            }
            else if(currentCommand.type == UnitCommand.CURE)
            {
               Monk(unit).isCureToggled = !Monk(unit).isCureToggled;
               restoreMove(param1);
               baseUpdate(param1);
            }
            else if(currentCommand.type == UnitCommand.HEAL)
            {
               Monk(unit).isHealToggled = !Monk(unit).isHealToggled;
               restoreMove(param1);
               baseUpdate(param1);
            }
            else if(currentCommand.type == UnitCommand.SLOW_DART)
            {
               Monk(unit).slowDartSpell(UnitCommand(currentCommand).realX);
               nextMove(param1);
            }
         }
         else
         {
            if(unit.techTeam.tech.isResearched(Tech.MONK_CURE) && Boolean(Monk(unit).isCureToggled) && !Monk(unit).isBusy() && Monk(unit).cureCooldown() == 0 && (currentCommand is AttackMoveCommand || currentCommand is StandCommand || currentCommand is HoldCommand))
            {
               this.inRange = null;
               if(cureCommand == null)
               {
                  cureCommand = new CureCommand(unit.team.game);
               }
               for each(_loc3_ in unit.team.poisonedUnits)
               {
                  cureCommand.realX = _loc3_.px;
                  cureCommand.realY = _loc3_.py;
                  if(cureCommand.inRange(unit))
                  {
                     this.inRange = _loc3_;
                     break;
                  }
               }
               if(this.inRange != null)
               {
                  Monk(unit).cureSpell(this.inRange);
                  return;
               }
            }
            if(Boolean(Monk(unit).isHealToggled) && !Monk(unit).isBusy() && Monk(unit).healCooldown() == 0 && mayAttack == true)
            {
               this.inRange = null;
               _loc4_ = 200;
               param1.spatialHash.mapInArea(unit.px - _loc4_,unit.py - _loc4_,unit.px + _loc4_,unit.py + _loc4_,this.lowestUnit,false);
               if(this.inRange != null && this.inRange.health != this.inRange.maxHealth)
               {
                  if(!Monk(unit).healSpell(this.inRange))
                  {
                  }
                  return;
               }
            }
            baseUpdate(param1);
         }
      }
      
      private function lowestUnit(param1:Unit) : void
      {
         if(param1.team != this.unit.team || param1.health == param1.maxHealth || param1 is Statue)
         {
            return;
         }
         if(this.inRange == null)
         {
            this.inRange = param1;
         }
         else if(param1.health < this.inRange.health)
         {
            this.inRange = param1;
         }
      }
   }
}
