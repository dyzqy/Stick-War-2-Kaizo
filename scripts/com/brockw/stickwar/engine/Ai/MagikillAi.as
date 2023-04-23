package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class MagikillAi extends UnitAi
   {
       
      
      public function MagikillAi(param1:Magikill)
      {
         super();
         unit = param1;
         isNonAttackingMage = true;
      }
      
      override public function update(param1:StickWar) : void
      {
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.NUKE || currentCommand.type == UnitCommand.STUN || currentCommand.type == UnitCommand.POISON_DART)
         {
            if(!this.currentCommand.inRange(unit))
            {
               unit.mayWalkThrough = true;
               unit.isBusyForSpell = true;
               unit.walk((currentCommand.realX - unit.px) / 100,(currentCommand.realY - unit.py) / 100,(currentCommand.realX - unit.px) / 100);
            }
            else if(currentCommand.type == UnitCommand.NUKE)
            {
               Magikill(unit).nukeSpell(NukeCommand(currentCommand).realX,NukeCommand(currentCommand).realY);
               nextMove(param1);
            }
            else if(currentCommand.type == UnitCommand.STUN)
            {
               Magikill(unit).stunSpell(StunCommand(currentCommand).realX,StunCommand(currentCommand).realY);
               nextMove(param1);
            }
            else if(currentCommand.type == UnitCommand.POISON_DART)
            {
               Magikill(unit).poisonDartSpell(PoisonDartCommand(currentCommand).realX,PoisonDartCommand(currentCommand).realY);
               nextMove(param1);
            }
         }
         else
         {
            baseUpdate(param1);
         }
      }
   }
}
