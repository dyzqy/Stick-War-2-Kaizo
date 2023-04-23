package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class FirestormElementAi extends UnitAi
   {
       
      
      public function FirestormElementAi(param1:FirestormElement)
      {
         super();
         unit = param1;
         isNonAttackingMage = true;
      }
      
      override public function update(param1:StickWar) : void
      {
         unit.isBusyForSpell = false;
         if(currentCommand.type == UnitCommand.FIRESTORM_NUKE || currentCommand.type == UnitCommand.FIRE_BREATH)
         {
            if(!this.currentCommand.inRange(unit))
            {
               unit.mayWalkThrough = true;
               unit.isBusyForSpell = true;
               unit.walk((currentCommand.realX - unit.px) / 100,(currentCommand.realY - unit.py) / 100,(currentCommand.realX - unit.px) / 100);
            }
            else if(currentCommand.type == UnitCommand.FIRESTORM_NUKE)
            {
               FirestormElement(unit).firestormNuke(FirestormCommand(currentCommand).realX,FirestormCommand(currentCommand).realY);
               nextMove(param1);
            }
            else if(currentCommand.type == UnitCommand.FIRE_BREATH)
            {
               FirestormElement(unit).firebreathNuke(FireBreathCommand(currentCommand).realX,FireBreathCommand(currentCommand).realY);
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
