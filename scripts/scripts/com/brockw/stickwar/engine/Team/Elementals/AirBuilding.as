package com.brockw.stickwar.engine.Team.Elementals
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class AirBuilding extends Building
      {
             
            
            public function AirBuilding(param1:StickWar, param2:ElementalTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_ELEMENTAL_AIR;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
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
                  if(!tech.isResearched(Tech.TORNADO))
                  {
                        param1.setAction(0,1,Tech.TORNADO);
                  }
            }
      }
}
