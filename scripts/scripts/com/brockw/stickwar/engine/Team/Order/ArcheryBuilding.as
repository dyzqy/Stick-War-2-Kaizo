package com.brockw.stickwar.engine.Team.Order
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class ArcheryBuilding extends Building
      {
             
            
            public function ArcheryBuilding(param1:StickWar, param2:GoodTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_ARCHERY_RANGE;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  if(false && !tech.isResearched(Tech.ARCHIDON))
                  {
                        param1.setAction(0,1,Tech.ARCHIDON);
                  }
                  else if(!tech.isResearched(Tech.ARCHIDON_FIRE))
                  {
                        param1.setAction(0,1,Tech.ARCHIDON_FIRE);
                  }
                  if(!tech.isResearched(Tech.CROSSBOW_FIRE))
                  {
                        param1.setAction(0,2,Tech.CROSSBOW_FIRE);
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
            }
      }
}
