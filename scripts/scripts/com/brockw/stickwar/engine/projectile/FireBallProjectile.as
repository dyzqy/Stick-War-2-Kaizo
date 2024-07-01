package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.StickWar;
      import flash.display.MovieClip;
      
      public class FireBallProjectile extends Projectile
      {
             
            
            private var spellMc:MovieClip;
            
            private var offset:int;
            
            public var t:int;
            
            public function FireBallProjectile(param1:StickWar)
            {
                  super();
                  type = FIRE_BALL_PROJECTILE;
                  this.spellMc = new fireballMc();
                  this.addChild(this.spellMc);
                  damageToDeal = 50;
                  _drotation = 0;
                  rot = 0;
                  this.offset = param1.random.nextNumber() * 8;
                  this.t = 0;
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
                  removeChild(this.spellMc);
                  this.spellMc = null;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return !this.isInFlight();
            }
            
            override public function update(param1:StickWar) : void
            {
                  super.update(param1);
                  Util.animateMovieClip(this.spellMc);
                  if(!this.isInFlight())
                  {
                        this.inflictor.team.game.projectileManager.initFireBallExplosion(px,py,pz,this.team,Util.sgn(dx));
                        visible = false;
                  }
                  ++this.t;
            }
      }
}
