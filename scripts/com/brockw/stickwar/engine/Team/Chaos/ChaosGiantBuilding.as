package com.brockw.stickwar.engine.Team.Chaos
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   
   public class ChaosGiantBuilding extends Building
   {
       
      
      public function ChaosGiantBuilding(param1:StickWar, param2:ChaosTech, param3:MovieClip, param4:MovieClip)
      {
         super(param1);
         this.button = param3;
         _hitAreaMovieClip = param4;
         this.type = Unit.B_CHAOS_GIANT;
         this.tech = param2;
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
         if(!tech.isResearched(Tech.CHAOS_GIANT_GROWTH_I))
         {
            param1.setAction(0,0,Tech.CHAOS_GIANT_GROWTH_I);
         }
         else if(!tech.isResearched(Tech.CHAOS_GIANT_GROWTH_II))
         {
            param1.setAction(0,0,Tech.CHAOS_GIANT_GROWTH_II);
         }
      }
   }
}
