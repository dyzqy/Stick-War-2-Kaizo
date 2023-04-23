package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   
   public class ChaosBankBuilding extends Building
   {
       
      
      public function ChaosBankBuilding(param1:StickWar, param2:ChaosTech, param3:MovieClip, param4:MovieClip)
      {
         super(param1);
         this.button = param3;
         _hitAreaMovieClip = param4;
         this.type = Unit.B_CHAOS_BANK;
         this.tech = param2;
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
         if(!tech.isResearched(Tech.MINER_SPEED))
         {
            param1.setAction(0,0,Tech.MINER_SPEED);
         }
         if(!tech.isResearched(Tech.MINER_TOWER))
         {
            param1.setAction(1,0,Tech.MINER_TOWER);
         }
         if(!tech.isResearched(Tech.BANK_PASSIVE_1))
         {
            param1.setAction(0,1,Tech.BANK_PASSIVE_1);
         }
         else if(!tech.isResearched(Tech.BANK_PASSIVE_2))
         {
            param1.setAction(0,1,Tech.BANK_PASSIVE_2);
         }
         else if(!tech.isResearched(Tech.BANK_PASSIVE_3))
         {
            param1.setAction(0,1,Tech.BANK_PASSIVE_3);
         }
         if(!tech.isResearched(Tech.TOWER_SPAWN_I))
         {
            param1.setAction(0,2,Tech.TOWER_SPAWN_I);
         }
         else if(!tech.isResearched(Tech.TOWER_SPAWN_II))
         {
            param1.setAction(0,2,Tech.TOWER_SPAWN_II);
         }
      }
   }
}
