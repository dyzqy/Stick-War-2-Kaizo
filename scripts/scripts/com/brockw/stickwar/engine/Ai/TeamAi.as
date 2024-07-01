package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.units.*;
      
      public class TeamAi
      {
             
            
            protected var team:Team;
            
            public function TeamAi(param1:Team)
            {
                  super();
                  this.team = param1;
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc2_:String = null;
                  for(_loc2_ in this.team.units)
                  {
                        if(Unit(this.team.units[_loc2_]).isAlive())
                        {
                              if(Unit(this.team.units[_loc2_]).reaperCurseFrames == 0)
                              {
                                    this.team.units[_loc2_].ai.update(param1);
                              }
                        }
                  }
            }
            
            public function cleanUp() : void
            {
                  var _loc1_:String = null;
                  for(_loc1_ in this.team.units)
                  {
                        this.team.units[_loc1_].ai.cleanUp();
                  }
                  this.team = null;
            }
      }
}
