package com.brockw.stickwar.engine.Team.Elementals
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class WaterBuilding extends Building
      {
             
            
            public function WaterBuilding(param1:StickWar, param2:ElementalTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_ELEMENTAL_WATER;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  if(!tech.isResearched(Tech.WATER_HEAL_UPGRADE))
                  {
                        param1.setAction(0,0,Tech.WATER_HEAL_UPGRADE);
                  }
            }
      }
}
