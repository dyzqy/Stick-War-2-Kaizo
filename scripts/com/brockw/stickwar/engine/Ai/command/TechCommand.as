package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class TechCommand extends UnitCommand
   {
       
      
      public function TechCommand(param1:StickWar)
      {
         super();
         isCancel = 0;
         type = UnitCommand.TECH;
         _hasCoolDown = true;
         _intendedEntityType = Unit.B_ORDER_BANK;
      }
      
      override public function prepareNetworkedMove(param1:GameScreen) : *
      {
         var _loc3_:String = null;
         var _loc2_:UnitMove = new UnitMove();
         _loc2_.moveType = this.type;
         for(_loc3_ in param1.team.units)
         {
            if(Unit(param1.team.units[_loc3_]).selected)
            {
               if(this.intendedEntityType == -1 || this.intendedEntityType == param1.team.units[_loc3_].type)
               {
                  _loc2_.units.push(param1.team.units[_loc3_].id);
               }
            }
         }
         _loc2_.arg0 = goalX;
         _loc2_.arg1 = goalY;
         _loc2_.arg2 = isCancel;
         param1.doMove(_loc2_,team.id);
      }
   }
}
