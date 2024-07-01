package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.MovieClip;
      
      public class Reaper extends DirectedProjectile
      {
             
            
            private var spellMc:MovieClip;
            
            public var target:Unit;
            
            public function Reaper(param1:StickWar)
            {
                  super(param1);
                  type = REAPER;
                  this.spellMc = new grimreaper();
                  addChild(this.spellMc);
                  this.spellMc.scaleX *= 1.5;
                  this.spellMc.scaleY *= 1.5;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc8_:Number = NaN;
                  visible = true;
                  if(!this.target.isAlive())
                  {
                        this.visible = false;
                        _inFlight = false;
                        return;
                  }
                  this.scaleX = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
                  this.scaleY = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
                  var _loc2_:int = int(Util.sgn(this.target.px - startX));
                  if(_loc2_ != Util.sgn(this.scaleX))
                  {
                        scaleX *= -1;
                  }
                  var _loc3_:Number = _startX + t / timeOfFlight * (this.target.px - _startX);
                  var _loc4_:Number = _startY + t / timeOfFlight * (this.target.py - _startY);
                  var _loc5_:Number = _startZ + t / timeOfFlight * (this.target.pz - _startZ);
                  var _loc6_:Number = _loc3_ - px;
                  var _loc7_:Number = _loc4_ - py;
                  _loc8_ = _loc5_ - pz;
                  px = _loc3_;
                  py = _loc4_;
                  pz = _loc5_;
                  this.x = px;
                  this.y = pz + py;
                  if(pz > 0 && _loc8_ > 0)
                  {
                        _loc8_ = _loc6_ = _loc7_ = 0;
                  }
                  t += 1;
                  if(t >= timeOfFlight)
                  {
                        this.target.reaperCurse(inflictor);
                        this.target.poison(this.poisonDamage);
                        this.target.damage(0,this.damageToDeal,null);
                        this.target.stun(this.stunTime);
                        this.target.slow(this.slowFrames);
                        _inFlight = false;
                        visible = false;
                  }
            }
      }
}
