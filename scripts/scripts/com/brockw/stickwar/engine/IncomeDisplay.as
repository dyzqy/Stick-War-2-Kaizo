package com.brockw.stickwar.engine
{
      public class IncomeDisplay
      {
            
            private static const NUM_DISPLAYS:int = 20;
             
            
            private var displayTime:int;
            
            private var displays:Array;
            
            private var pool:Array;
            
            public function IncomeDisplay(param1:StickWar)
            {
                  super();
                  this.displayTime = param1.xml.xml.incomeDisplay.time;
                  this.pool = [];
                  var _loc2_:int = 0;
                  while(_loc2_ < NUM_DISPLAYS)
                  {
                        this.pool.push(new DisplayClip());
                        _loc2_++;
                  }
                  this.displays = [];
            }
            
            public function addDisplay(param1:StickWar, param2:String, param3:int, param4:int, param5:int) : void
            {
                  var _loc6_:DisplayClip = null;
                  (_loc6_ = DisplayClip(this.pool.pop())).mc.textColor = param3;
                  _loc6_.mc.text.text = param2;
                  _loc6_.x = _loc6_.px = param4;
                  _loc6_.y = param5;
                  _loc6_.py = param1.map.height;
                  _loc6_.alpha = 1;
                  param1.battlefield.addChild(_loc6_);
                  this.displays.push([this.displayTime,_loc6_]);
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc2_:Array = null;
                  for each(_loc2_ in this.displays)
                  {
                        DisplayClip(_loc2_[1]).y = DisplayClip(_loc2_[1]).y - 0.5;
                        _loc2_[0] = _loc2_[0] - 1;
                        DisplayClip(_loc2_[1]).alpha = DisplayClip(_loc2_[1]).alpha - 0.005;
                  }
                  while(this.displays.length != 0)
                  {
                        if(this.displays[0][0] > 0)
                        {
                              break;
                        }
                        this.pool.push(this.displays.shift()[1]);
                  }
            }
      }
}
