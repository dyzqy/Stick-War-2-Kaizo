package com.brockw.stickwar.engine.Team
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.Unit;
      
      public class CastleDefence
      {
             
            
            private var _units:Array;
            
            protected var game:StickWar;
            
            protected var team:Team;
            
            public function CastleDefence(param1:StickWar, param2:Team)
            {
                  super();
                  this.game = param1;
                  this.team = param2;
                  this._units = [];
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  while(_loc2_ < this.units.length)
                  {
                        this.units[_loc2_].ai.update(param1);
                        this.units[_loc2_].update(param1);
                        _loc2_++;
                  }
            }
            
            public function cleanUpUnits() : void
            {
                  var _loc1_:Unit = null;
                  for each(_loc1_ in this._units)
                  {
                        if(this.game.battlefield.contains(_loc1_))
                        {
                              this.game.battlefield.removeChild(_loc1_);
                        }
                  }
                  this._units = [];
            }
            
            public function cleanUp() : void
            {
                  this._units = null;
                  this.game = null;
                  this.team = null;
            }
            
            public function addUnit() : void
            {
            }
            
            public function get units() : Array
            {
                  return this._units;
            }
            
            public function set units(param1:Array) : void
            {
                  this._units = param1;
            }
      }
}
