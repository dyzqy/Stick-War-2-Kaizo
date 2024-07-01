package com.brockw.stickwar.missions
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      
      public class ActionSpawn extends Action
      {
             
            
            private var num:int = 0;
            
            private var type:int = 0;
            
            private var isForPlayer:Boolean = false;
            
            public function ActionSpawn(param1:XML)
            {
                  super();
                  var _loc2_:String = param1;
                  var _loc3_:String = param1.attribute("number");
                  var _loc4_:String;
                  if((_loc4_ = param1.attribute("isForPlayer")) == "true")
                  {
                        this.isForPlayer = true;
                  }
                  this.num = _loc3_;
                  this.type = ItemMap.unitNameToType(_loc2_);
                  if(this.type == -1)
                  {
                        throw new Error("Unknown unit type!");
                  }
            }
            
            override public function execute(param1:GameScreen) : void
            {
                  if(this.isForPlayer)
                  {
                        param1.game.team.spawn(Unit(param1.game.unitFactory.getUnit(int(this.type))),param1.game,false);
                  }
                  else
                  {
                        param1.game.team.enemyTeam.spawn(Unit(param1.game.unitFactory.getUnit(int(this.type))),param1.game,false);
                  }
            }
      }
}
