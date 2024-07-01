package com.brockw.stickwar.engine
{
      import com.brockw.game.*;
      import flash.utils.*;
      
      public class OreFactory
      {
             
            
            private var pools:Dictionary;
            
            private var id:int;
            
            public function OreFactory(param1:int, param2:StickWar)
            {
                  super();
                  this.pools = new Dictionary();
                  this.pools[new Gold(param2).type] = new Pool(param1 * 2,Gold,param2);
                  this.id = 0;
            }
            
            public function getUnit(param1:int) : Ore
            {
                  var _loc2_:Ore = Ore(Pool(this.pools[param1]).getItem());
                  _loc2_.id = this.id++;
                  return _loc2_;
            }
            
            public function returnUnit(param1:int, param2:Ore) : void
            {
                  Pool(this.pools[param1]).returnItem(param2);
            }
      }
}
