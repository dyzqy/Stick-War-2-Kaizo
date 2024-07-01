package com.brockw.stickwar.engine.units
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      
      public class RangedUnit extends Unit
      {
             
            
            protected var bowAngle:Number;
            
            private var _projectileVelocity:Number;
            
            protected var _maximumRange:Number;
            
            protected var aimXOffset:Number;
            
            protected var aimYOffset:Number;
            
            protected var takeBottomTrajectory:Boolean;
            
            public function RangedUnit(param1:StickWar)
            {
                  super(param1);
                  this._projectileVelocity = 15;
                  this.bowAngle = 0;
                  this._maximumRange = 600;
                  this.aimXOffset = 0;
                  this.aimYOffset = 0;
                  this.takeBottomTrajectory = true;
            }
            
            public function aimedAtUnit(param1:Unit, param2:Number) : Boolean
            {
                  if(param1 == null)
                  {
                        return false;
                  }
                  if(Util.sgn(param1.x - x) != Util.sgn(this.mc.scaleX))
                  {
                        return false;
                  }
                  if(param2 == -1.35)
                  {
                        return false;
                  }
                  return this.normalise(Math.abs((this.bowAngle - this.angleToBowSpace(param2)) % 360)) < 0.5;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(_mc.mc != null)
                  {
                        if(_mc.mc.bow != null)
                        {
                              _mc.mc.bow.rotation = this.bowAngle;
                        }
                        else if(_mc.mc.body != null && Boolean(_mc.mc.body.arms))
                        {
                              _mc.mc.body.arms.rotation = this.bowAngle;
                        }
                  }
            }
            
            protected function angleToBowSpace(param1:Number) : Number
            {
                  return -param1 * 180 / Math.PI;
            }
            
            public function aim(param1:Unit) : void
            {
                  var _loc2_:Number = this.angleToTarget(param1);
                  if(param1 != null && this._state == Unit.S_ATTACK && !this.inRange(param1))
                  {
                        return;
                  }
                  if(Math.abs(this.normalise(this.angleToBowSpace(_loc2_) - this.bowAngle)) < 10)
                  {
                        this.bowAngle += this.normalise(this.angleToBowSpace(_loc2_) - this.bowAngle) * 0.8;
                  }
                  else
                  {
                        this.bowAngle += this.normalise(this.angleToBowSpace(_loc2_) - this.bowAngle) * 0.1;
                  }
            }
            
            protected function normalise(param1:Number) : Number
            {
                  var _loc2_:Number = param1 % 360;
                  if(_loc2_ < 0)
                  {
                        _loc2_ += 360;
                  }
                  if(_loc2_ > 180)
                  {
                        _loc2_ -= 360;
                  }
                  return _loc2_;
            }
            
            public function inRange(param1:Unit) : Boolean
            {
                  if(param1 == null)
                  {
                        return false;
                  }
                  var _loc2_:Number = Number(this._projectileVelocity);
                  var _loc3_:Number = Number(StickWar.GRAVITY);
                  var _loc4_:Number;
                  var _loc5_:Number = _loc4_ = (_loc4_ = Math.sqrt((param1.px - this.px) * (param1.px - this.px))) + this.aimXOffset * Util.sgn(mc.scaleX);
                  var _loc6_:Number = 0;
                  var _loc7_:Number = -(param1.pz - pz) + _loc6_ + this.aimYOffset;
                  if(this._maximumRange < Math.abs(param1.px - px))
                  {
                        return false;
                  }
                  var _loc8_:Number;
                  if((_loc8_ = Math.pow(_loc2_,4) - _loc3_ * (_loc3_ * _loc5_ * _loc5_ + 2 * _loc7_ * _loc2_ * _loc2_)) <= 0)
                  {
                        return false;
                  }
                  return true;
            }
            
            public function isLoaded() : Boolean
            {
                  return true;
            }
            
            override public function mayAttack(param1:Unit) : Boolean
            {
                  var _loc2_:int = 200;
                  if(team.direction * px < team.direction * (this.team.homeX + team.direction * _loc2_))
                  {
                        return false;
                  }
                  if(isIncapacitated())
                  {
                        return false;
                  }
                  if(param1 == null)
                  {
                        return false;
                  }
                  if(this.isDualing == true)
                  {
                        return false;
                  }
                  if(this.aimedAtUnit(param1,this.angleToTarget(param1)) && this.inRange(param1))
                  {
                        return true;
                  }
                  return false;
            }
            
            override public function canAttackAir() : Boolean
            {
                  return true;
            }
            
            public function shoot(param1:StickWar, param2:Unit) : void
            {
            }
            
            public function angleToTarget(param1:Unit) : Number
            {
                  if(param1 == null)
                  {
                        return -1.2;
                  }
                  var _loc2_:Number = Number(this._projectileVelocity);
                  var _loc3_:Number = Number(StickWar.GRAVITY);
                  var _loc4_:Number;
                  var _loc5_:Number = (_loc4_ = Math.sqrt((param1.px - this.px) * (param1.px - this.px))) - this.aimXOffset * Util.sgn(mc.scaleX);
                  var _loc6_:Number = 0;
                  if(param1.mc != null)
                  {
                        _loc6_ = param1.pheight - this.pheight;
                  }
                  _loc6_ = 0;
                  var _loc7_:Number = -(param1.pz - pz) + _loc6_ + this.aimYOffset;
                  if(param1.isFlying())
                  {
                        if(Math.abs(param1.px - this.px) < 50)
                        {
                              _loc7_ = 0;
                        }
                  }
                  var _loc8_:Number;
                  if((_loc8_ = Math.pow(_loc2_,4) - _loc3_ * (_loc3_ * _loc5_ * _loc5_ + 2 * _loc7_ * _loc2_ * _loc2_)) <= 0 || _loc5_ > this._maximumRange)
                  {
                        return -1.35;
                  }
                  var _loc9_:* = Math.atan2(_loc2_ * _loc2_ - Math.sqrt(_loc8_),_loc3_ * _loc5_);
                  if(!this.takeBottomTrajectory && _loc4_ > 700)
                  {
                        _loc9_ = Math.atan2(_loc2_ * _loc2_ + Math.sqrt(_loc8_),_loc3_ * _loc5_);
                  }
                  return _loc9_;
            }
            
            public function angleToTargetW(param1:Unit, param2:Number, param3:Number) : Number
            {
                  if(param1 == null)
                  {
                        return 0;
                  }
                  param2 = Number(this._projectileVelocity);
                  var _loc4_:Number = Number(StickWar.GRAVITY);
                  var _loc5_:Number;
                  var _loc6_:Number = (_loc5_ = Math.sqrt((param1.px - this.px) * (param1.px - this.px))) - this.aimXOffset * Util.sgn(mc.scaleX);
                  var _loc7_:Number = param1.pheight - this.pheight;
                  _loc7_ = 0;
                  var _loc8_:Number = -(param1.pz - pz) + _loc7_ + this.aimYOffset;
                  param3 = -Math.PI / 180 * this.angleToBowSpace(param3);
                  var _loc9_:Number;
                  if((_loc9_ = param2 * param2 * Util.sin(param3) * Util.sin(param3) + 2 * _loc4_ * -_loc8_) < 0)
                  {
                        _loc9_ = 0;
                  }
                  var _loc10_:Number = (param2 * Util.sin(param3) + Math.sqrt(_loc9_)) / _loc4_;
                  if(param1 is AirElement || param1 is Wingidon)
                  {
                        if(Math.abs(_loc10_) < 1)
                        {
                              return (param1.py - py) / 3;
                        }
                        return (param1.py - py) / _loc10_;
                  }
                  if(Math.abs(_loc10_) < 0.001)
                  {
                        return (param1.py - py) / 1;
                  }
                  return (param1.py - py) / _loc10_;
            }
            
            public function get projectileVelocity() : Number
            {
                  return this._projectileVelocity;
            }
            
            public function set projectileVelocity(param1:Number) : void
            {
                  this._projectileVelocity = param1;
            }
      }
}
