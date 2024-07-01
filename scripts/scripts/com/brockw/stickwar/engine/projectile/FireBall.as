package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.MovieClip;
      
      public class FireBall extends DirectedProjectile
      {
             
            
            private var spellMc:MovieClip;
            
            public var target:Unit;
            
            private var flameVelocity:Number;
            
            private var offset:int;
            
            public function FireBall(param1:StickWar)
            {
                  super(param1);
                  type = FIRE_BALL;
                  this.spellMc = new fireballMc();
                  this.offset = param1.random.nextNumber() * 8;
                  addChild(this.spellMc);
                  this.spellMc.scaleX *= 1.5;
                  this.flameVelocity = param1.xml.xml.Elemental.Units.fireElement.velocity;
                  this.spellMc.scaleY *= 1.5;
            }
            
            override public function update(param1:StickWar) : void
            {
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
                  var _loc3_:Number = this.target.px - px;
                  var _loc4_:Number = this.target.py - this.target.pheight / 2 - py;
                  var _loc5_:Number = this.target.pz - pz;
                  var _loc6_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_;
                  var _loc7_:Number;
                  if((_loc7_ = Math.sqrt(_loc6_)) != 0)
                  {
                        _loc3_ /= _loc7_;
                        _loc4_ /= _loc7_;
                        _loc5_ /= _loc7_;
                  }
                  var _loc8_:Number = Number(this.flameVelocity);
                  px += _loc3_ * _loc8_;
                  py += _loc4_ * _loc8_;
                  pz += _loc5_ * _loc8_;
                  this.x = px;
                  this.y = pz + py;
                  if(pz > 0 && _loc5_ > 0)
                  {
                        _loc5_ = _loc3_ = _loc4_ = 0;
                  }
                  t += 1;
                  if(t > 1 && (t - 1) % 9 == this.offset && team != null)
                  {
                        team.game.projectileManager.initSmokePuff(x,y,z,team,Util.sgn(_loc3_));
                  }
                  var _loc9_:Number = this.target.px - px;
                  var _loc10_:Number = this.target.py - this.target.pheight / 2 - py;
                  var _loc11_:Number = this.target.pz - pz;
                  if(_loc9_ * _loc9_ + _loc10_ * _loc10_ + _loc11_ * _loc11_ > _loc6_)
                  {
                        this.target.damage(0,this.damageToDeal,this.inflictor);
                        _inFlight = false;
                        visible = false;
                        this.inflictor.team.game.projectileManager.initFireBallExplosion(px,py,pz,this.team,Util.sgn(_loc3_));
                  }
                  Util.animateMovieClip(this.spellMc);
            }
      }
}
