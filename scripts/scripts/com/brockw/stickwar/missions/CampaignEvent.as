package com.brockw.stickwar.missions
{
      import com.brockw.stickwar.GameScreen;
      
      public class CampaignEvent
      {
            
            public static var T_TIME:int = 0;
            
            public static var T_WIN:int = 1;
            
            public static var T_LOSE:int = 2;
             
            
            public var hasTriggered:Boolean;
            
            private var type:Number;
            
            private var value:Number;
            
            private var actions:Array;
            
            public function CampaignEvent(param1:XML)
            {
                  var _loc3_:* = undefined;
                  var _loc4_:Action = null;
                  super();
                  var _loc2_:String = param1.attribute("type");
                  if(_loc2_ == "time")
                  {
                        this.type = T_TIME;
                  }
                  else if(_loc2_ == "aboutToWin")
                  {
                        this.type = T_WIN;
                  }
                  else if(_loc2_ == "aboutToLose")
                  {
                        this.type = T_LOSE;
                  }
                  this.value = param1.attribute("value");
                  this.actions = [];
                  for each(_loc3_ in param1.spawn)
                  {
                        _loc4_ = new ActionSpawn(_loc3_);
                        this.actions.push(_loc4_);
                  }
            }
            
            public function update(param1:GameScreen) : void
            {
                  var _loc2_:Action = null;
                  if(this.type == T_TIME)
                  {
                        if(param1.game.frame == this.value)
                        {
                              for each(_loc2_ in this.actions)
                              {
                                    _loc2_.execute(param1);
                              }
                        }
                  }
            }
      }
}
