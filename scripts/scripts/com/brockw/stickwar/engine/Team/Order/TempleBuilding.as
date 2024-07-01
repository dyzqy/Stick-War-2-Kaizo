package com.brockw.stickwar.engine.Team.Order
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class TempleBuilding extends Building
      {
             
            
            public function TempleBuilding(param1:StickWar, param2:GoodTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_TEMPLE;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  if(!tech.isResearched(Tech.STATUE_HEALTH))
                  {
                        param1.setAction(0,0,Tech.STATUE_HEALTH);
                  }
                  if(!tech.isResearched(Tech.MONK_CURE))
                  {
                        param1.setAction(0,1,Tech.MONK_CURE);
                  }
            }
      }
}
