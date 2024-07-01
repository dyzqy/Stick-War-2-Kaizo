package com.brockw.stickwar.engine.Team.Order
{
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.MovieClip;
      
      public class BarracksBuilding extends Building
      {
             
            
            public function BarracksBuilding(param1:StickWar, param2:GoodTech, param3:MovieClip, param4:MovieClip)
            {
                  super(param1);
                  this.button = param3;
                  _hitAreaMovieClip = param4;
                  this.type = Unit.B_BARRACKS;
                  this.tech = param2;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  if(!tech.isResearched(Tech.SWORDWRATH_RAGE))
                  {
                        param1.setAction(0,0,Tech.SWORDWRATH_RAGE);
                  }
                  if(false && !tech.isResearched(Tech.SPEARTON))
                  {
                        param1.setAction(0,1,Tech.SPEARTON);
                  }
                  else
                  {
                        if(!tech.isResearched(Tech.BLOCK))
                        {
                              param1.setAction(0,1,Tech.BLOCK);
                        }
                        if(!tech.isResearched(Tech.SHIELD_BASH))
                        {
                              param1.setAction(1,1,Tech.SHIELD_BASH);
                        }
                  }
                  if(!tech.isResearched(Tech.CLOAK_II))
                  {
                        param1.setAction(0,2,Tech.CLOAK_II);
                  }
            }
      }
}
