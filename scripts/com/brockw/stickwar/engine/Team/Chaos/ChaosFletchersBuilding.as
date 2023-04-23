package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   
   public class ChaosFletchersBuilding extends Building
   {
       
      
      public function ChaosFletchersBuilding(param1:StickWar, param2:ChaosTech, param3:MovieClip, param4:MovieClip)
      {
         super(param1);
         this.button = param3;
         _hitAreaMovieClip = param4;
         this.type = Unit.B_CHAOS_FLETCHER;
         this.tech = param2;
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
         if(!tech.isResearched(Tech.DEAD_POISON))
         {
            param1.setAction(0,1,Tech.DEAD_POISON);
         }
         if(!tech.isResearched(Tech.CASTLE_ARCHER_1))
         {
            param1.setAction(0,0,Tech.CASTLE_ARCHER_1);
         }
         else if(!tech.isResearched(Tech.CASTLE_ARCHER_2))
         {
            param1.setAction(0,0,Tech.CASTLE_ARCHER_2);
         }
         else if(!tech.isResearched(Tech.CASTLE_ARCHER_3))
         {
            param1.setAction(0,0,Tech.CASTLE_ARCHER_3);
         }
         else if(!tech.isResearched(Tech.CASTLE_ARCHER_4))
         {
            param1.setAction(0,0,Tech.CASTLE_ARCHER_4);
         }
         else if(!tech.isResearched(Tech.CASTLE_ARCHER_5))
         {
            param1.setAction(0,0,Tech.CASTLE_ARCHER_5);
         }
      }
   }
}
