package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class MudElementAi extends UnitAi
   {
       
      
      public function MudElementAi(param1:TreeElement)
      {
         super();
         unit = param1;
         isNonAttackingMage = true;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Entity = null;
         if(Boolean(TreeElement(unit).isRooted()) && (currentCommand.type == UnitCommand.MOVE || currentCommand.type == UnitCommand.ATTACK_MOVE))
         {
            if(unit.team == param1.team)
            {
               param1.gameScreen.userInterface.helpMessage.showMessage("Must unroot tree to move.");
            }
            nextMove(param1);
         }
         if(currentCommand.type == UnitCommand.TREE_ROOT)
         {
            TreeElement(unit).toggleRoot();
            nextMove(param1);
         }
         else if(currentCommand.type == UnitCommand.FLOWER)
         {
            _loc2_ = int(FlowerCommand(currentCommand).targetId);
            if(_loc2_ in param1.units)
            {
               _loc3_ = param1.units[_loc2_];
               if(!(_loc3_ is Unit) || Unit(_loc3_).team == unit.team)
               {
                  nextMove(param1);
               }
               else if(!this.currentCommand.inRange(unit))
               {
                  unit.mayWalkThrough = true;
                  unit.isBusyForSpell = true;
                  unit.walk((_loc3_.px - unit.px) / 100,(_loc3_.py - unit.py) / 100,(_loc3_.px - unit.px) / 100);
               }
               else if(currentCommand.type == UnitCommand.FLOWER)
               {
                  _loc3_ = param1.units[_loc2_];
                  if(_loc3_ is Unit && Unit(_loc3_).team != unit.team)
                  {
                     TreeElement(unit).flowerSpell(Unit(_loc3_));
                     nextMove(param1);
                  }
                  else
                  {
                     baseUpdate(param1);
                  }
               }
            }
            else
            {
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
