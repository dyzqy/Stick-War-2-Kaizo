package com.brockw.stickwar.engine.Ai
{
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   
   public class ChaosTowerAi extends RangedAi
   {
       
      
      public function ChaosTowerAi(param1:ChaosTower)
      {
         super(param1);
         unit = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         if(this.currentCommand.type == UnitCommand.REMOVE_TOWER_COMMAND)
         {
            this.unit.isDieing = true;
            this.unit.health = 0;
            this.unit.healthBar.health = 0;
         }
         checkNextMove(param1);
         mayAttack = true;
         super.update(param1);
      }
   }
}
