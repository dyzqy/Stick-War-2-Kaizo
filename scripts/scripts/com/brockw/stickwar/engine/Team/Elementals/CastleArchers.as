package com.brockw.stickwar.engine.Team.Elementals
{
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      
      public class CastleArchers extends CastleDefence
      {
             
            
            public function CastleArchers(param1:StickWar, param2:Team)
            {
                  super(param1,param2);
                  units = [];
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  if(team.tech.isResearched(Tech.CASTLE_ARCHER_5))
                  {
                        _loc2_ = 5;
                  }
                  else if(team.tech.isResearched(Tech.CASTLE_ARCHER_4))
                  {
                        _loc2_ = 4;
                  }
                  else if(team.tech.isResearched(Tech.CASTLE_ARCHER_3))
                  {
                        _loc2_ = 3;
                  }
                  else if(team.tech.isResearched(Tech.CASTLE_ARCHER_2))
                  {
                        _loc2_ = 2;
                  }
                  else if(team.tech.isResearched(Tech.CASTLE_ARCHER_1))
                  {
                        _loc2_ = 1;
                  }
                  if(units.length < _loc2_)
                  {
                        this.addUnit();
                  }
                  var _loc3_:int = 0;
                  while(_loc3_ < units.length)
                  {
                        units[_loc3_].faceDirection(team.direction);
                        _loc3_++;
                  }
                  super.update(param1);
            }
            
            override public function addUnit() : void
            {
                  var _loc1_:AirElement = null;
                  _loc1_ = new AirElement(game);
                  _loc1_.ai = new AirElementAi(_loc1_);
                  _loc1_.team = team;
                  _loc1_.isCastleArcher = true;
                  _loc1_.init(game);
                  _loc1_.flyingHeight = 390;
                  _loc1_.pz = -_loc1_.flyingHeight;
                  _loc1_.ai.init();
                  _loc1_.py = game.map.height * 0.2 + game.map.height * 0.5 * units.length / game.xml.xml.Order.Tech.castleArchers.num;
                  _loc1_.y = _loc1_.py;
                  _loc1_.px = team.homeX + team.direction * 190 - team.direction * units.length * 8;
                  _loc1_.x = _loc1_.px;
                  var _loc2_:HoldCommand = new HoldCommand(game);
                  _loc1_.ai.setCommand(game,_loc2_);
                  units.push(_loc1_);
                  game.battlefield.addChild(_loc1_);
            }
      }
}
