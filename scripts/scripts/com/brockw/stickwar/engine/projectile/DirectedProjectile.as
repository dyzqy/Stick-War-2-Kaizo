package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.units.Unit;
      
      public class DirectedProjectile extends Projectile
      {
             
            
            protected var targetUnit:Unit;
            
            private var _team:Team;
            
            private var _damageToDeal:Number;
            
            private var _stunTime:int;
            
            protected var timeOfFlight:int;
            
            protected var t:int;
            
            protected var _startX:Number;
            
            protected var _startY:Number;
            
            protected var _startZ:Number;
            
            protected var _inFlight:Boolean;
            
            public function DirectedProjectile(param1:StickWar)
            {
                  super();
                  this._inFlight = true;
                  framesDead = 0;
                  this.t = 0;
            }
            
            public function init(param1:Number, param2:Number, param3:Number, param4:Unit, param5:Number, param6:Team) : void
            {
                  x = px = this._startX = param1;
                  y = py = this._startY = param2;
                  this._startZ = param3;
                  this._team = param6;
                  this._inFlight = true;
                  this.t = 0;
                  framesDead = 0;
                  this._stunTime = 0;
                  this._damageToDeal = param5;
                  this.slowFrames = 0;
                  this.poisonDamage = 0;
                  this.timeOfFlight = 20;
                  this.targetUnit = param4;
                  this.scaleX = param6.game.backScale + py / param6.game.map.height * (param6.game.frontScale - param6.game.backScale);
                  this.scaleY = param6.game.backScale + py / param6.game.map.height * (param6.game.frontScale - param6.game.backScale);
                  var _loc7_:int;
                  if((_loc7_ = int(Util.sgn(param4.px - param1))) != Util.sgn(this.scaleX))
                  {
                        scaleX *= -1;
                  }
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc7_:Number = NaN;
                  var _loc8_:Number = NaN;
                  if(!this.targetUnit.isAlive())
                  {
                        this.visible = false;
                        this._inFlight = false;
                        return;
                  }
                  this.scaleX = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
                  this.scaleY = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
                  var _loc2_:Number = Number(this.targetUnit.px);
                  var _loc3_:Number = this.targetUnit.py - this.targetUnit.pheight / 2;
                  var _loc4_:Number = Number(this.targetUnit.pz);
                  var _loc5_:Number = Math.sqrt(Math.pow(_loc2_ - px,2) + Math.pow(_loc3_ - py,2) + Math.pow(_loc4_ - pz,2));
                  var _loc6_:Number = (_loc2_ - px) / _loc5_ * 25;
                  _loc7_ = (_loc3_ - py) / _loc5_ * 25;
                  _loc8_ = (_loc4_ - pz) / _loc5_ * 25;
                  this.visible = true;
                  px += _loc6_;
                  py += _loc7_;
                  pz += _loc8_;
                  this.x = px;
                  this.y = pz + py;
                  if(pz > 0 && _loc8_ > 0)
                  {
                        _loc8_ = _loc6_ = _loc7_ = 0;
                  }
                  else
                  {
                        rotation = 90 - Math.atan2(_loc6_,_loc8_ + _loc7_) * 180 / Math.PI;
                  }
                  if(_loc5_ < this.targetUnit.width / 2)
                  {
                        this.targetUnit.poison(this.poisonDamage);
                        this.targetUnit.damage(0,this.damageToDeal,null);
                        this.targetUnit.stun(this.stunTime);
                        this.targetUnit.slow(this.slowFrames);
                        this._inFlight = false;
                        visible = false;
                  }
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return !this._inFlight;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this._inFlight;
            }
            
            public function get startX() : Number
            {
                  return this._startX;
            }
            
            public function set startX(param1:Number) : void
            {
                  this._startX = param1;
            }
            
            public function get startY() : Number
            {
                  return this._startY;
            }
            
            public function set startY(param1:Number) : void
            {
                  this._startY = param1;
            }
            
            public function get startZ() : Number
            {
                  return this._startZ;
            }
            
            public function set startZ(param1:Number) : void
            {
                  this._startZ = param1;
            }
      }
}
