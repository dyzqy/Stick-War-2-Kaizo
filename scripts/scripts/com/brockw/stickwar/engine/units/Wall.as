package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.Team;
      import flash.display.*;
      import flash.geom.Point;
      
      public class Wall extends Unit
      {
             
            
            public var wallParts:Array;
            
            private var isConstructed:Boolean = false;
            
            private var healthLost:Number;
            
            public function Wall(param1:StickWar, param2:Team)
            {
                  var _loc4_:wallSpike = null;
                  var _loc5_:Unit = null;
                  super(param1);
                  this.wallParts = [];
                  var _loc3_:int = 0;
                  while(_loc3_ < 5)
                  {
                        _loc4_ = new wallSpike();
                        (_loc5_ = new Unit(param1)).addChild(_loc4_);
                        _loc5_.x = _loc5_.px = 0;
                        _loc5_.y = _loc5_.py = _loc3_ * param1.map.height / 5;
                        _loc5_.scaleX = param2.direction * param1.getPerspectiveScale(_loc5_.y);
                        _loc5_.scaleY = param1.getPerspectiveScale(_loc5_.y);
                        _loc5_.pz = 0;
                        _loc5_.team = param2;
                        this.wallParts.push(_loc5_);
                        _loc3_++;
                  }
                  this.team = param2;
                  ai = new WallAi(this);
                  ai.setCommand(param1,new StandCommand(param1));
                  _maxHealth = health = param1.xml.xml.Order.Units.wall.health;
                  healthBar = new HealthBar();
                  healthBar.totalHealth = _health;
                  healthBar.x = -param2.direction * 10;
                  healthBar.y = -100;
                  healthBar.scaleX *= 1.3;
                  healthBar.scaleY *= 1.2;
                  pwidth = 15;
                  pheight = 250;
                  addChild(healthBar);
                  pz = 0;
                  mc = new MovieClip();
                  this.isConstructed = false;
                  this.setConstructionAmount(0);
                  hitBoxWidth = 150;
                  this.type = Unit.U_WALL;
                  _interactsWith = Unit.I_IS_BUILDING;
                  flyingHeight = 0;
                  this.healthLost = 0;
                  isInteractable = true;
            }
            
            override public function poison(param1:Number) : Boolean
            {
                  return false;
            }
            
            override public function getDirection() : int
            {
                  return Util.sgn(1);
            }
            
            public function setConstructionAmount(param1:Number) : void
            {
                  var _loc2_:Unit = null;
                  var _loc3_:wallSpike = null;
                  if(param1 >= 0 && param1 <= 1)
                  {
                        _health = param1 * _maxHealth - this.healthLost;
                        healthBar.reset();
                        if(param1 >= 1)
                        {
                              this.isConstructed = true;
                        }
                        else
                        {
                              this.isConstructed = false;
                        }
                        for each(_loc2_ in this.wallParts)
                        {
                              _loc3_ = wallSpike(_loc2_.getChildAt(0));
                              _loc3_.gotoAndStop(Math.floor(_loc3_.totalFrames * param1));
                        }
                  }
            }
            
            override public function update(param1:StickWar) : void
            {
                  healthBar.health = health;
                  healthBar.update();
                  if(isDead == false && isDieing)
                  {
                        team.removeWall(this);
                  }
                  ai.update(param1);
            }
            
            override public function isAlive() : Boolean
            {
                  if(this.healthLost == 0)
                  {
                        return true;
                  }
                  return this.healthLost <= _health;
            }
            
            override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
            {
                  var _loc5_:* = _health;
                  super.damage(param1,param2,param3);
                  var _loc6_:* = _health;
                  this.healthLost += _loc5_ - _loc6_;
            }
            
            override public function checkForHitPoint(param1:Point, param2:Unit) : Boolean
            {
                  return this.checkForHitPoint2(param1);
            }
            
            public function checkForHitPoint2(param1:Point) : Boolean
            {
                  param1 = this.globalToLocal(param1);
                  if(param1.x > -100 && param1.x < 100 && param1.y > -300 && param1.y < 100)
                  {
                        return true;
                  }
                  return false;
            }
            
            public function checkForHitPoint3(param1:Point) : Boolean
            {
                  param1 = this.globalToLocal(param1);
                  if(param1.x > -50 && param1.x < 50 && param1.y > -200 && param1.y < 100)
                  {
                        return true;
                  }
                  return false;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  param1.clear();
                  param1.setAction(0,0,UnitCommand.REMOVE_WALL_COMMAND);
            }
            
            public function setLocation(param1:Number) : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:Entity = null;
                  _loc2_ = 0;
                  for each(_loc3_ in this.wallParts)
                  {
                        _loc3_.x = _loc3_.px = param1 - _loc2_ * 5 * team.direction;
                        _loc2_++;
                  }
                  this.x = px = param1;
                  this.y = py = team.game.map.height / 2;
            }
            
            public function addToScene(param1:Sprite) : void
            {
                  var _loc2_:Entity = null;
                  param1.addChild(this);
                  for each(_loc2_ in this.wallParts)
                  {
                        if(!param1.contains(_loc2_))
                        {
                              param1.addChild(_loc2_);
                        }
                  }
            }
            
            public function removeFromScene(param1:Sprite) : void
            {
                  var _loc2_:Entity = null;
                  if(param1.contains(this))
                  {
                        param1.removeChild(this);
                        for each(_loc2_ in this.wallParts)
                        {
                              if(param1.contains(_loc2_))
                              {
                                    param1.removeChild(_loc2_);
                              }
                        }
                  }
            }
      }
}
