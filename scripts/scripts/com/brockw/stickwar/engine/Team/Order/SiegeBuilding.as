package com.brockw.stickwar.engine.Team.Order
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class SiegeBuilding extends Building
      {
             
            
            public function SiegeBuilding(param1:StickWar, param2:GoodTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_SIEGE_WORKSHOP;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  if(!tech.isResearched(Tech.GIANT_GROWTH_I))
                  {
                        param1.setAction(0,0,Tech.GIANT_GROWTH_I);
                  }
                  else if(!tech.isResearched(Tech.GIANT_GROWTH_II))
                  {
                        param1.setAction(0,0,Tech.GIANT_GROWTH_II);
                  }
            }
      }
}
