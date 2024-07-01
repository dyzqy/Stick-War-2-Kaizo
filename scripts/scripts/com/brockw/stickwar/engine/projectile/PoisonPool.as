package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class PoisonPool extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            internal var explosionRadius:Number;
            
            internal var explosionDamage:Number;
            
            public var frames:int;
            
            internal var timeToLive:int;
            
            public function PoisonPool(param1:StickWar)
            {
                  super();
                  type = Projectile.POISON_POOL;
                  this.spellMc = new poisonMedusaSpell();
                  this.addChild(this.spellMc);
                  this.frames = 0;
                  this.explosionRadius = param1.xml.xml.Chaos.Units.medusa.poison.area;
                  this.timeToLive = param1.xml.xml.Chaos.Units.medusa.poison.time;
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
                  removeChild(this.spellMc);
                  this.spellMc = null;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc4_:Number = NaN;
                  this.scaleX = Util.sgn(scaleX) * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  this.scaleY = 1 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  this.spellMc.nextFrame();
                  Util.animateMovieClip(this.spellMc,0);
                  var _loc2_:Array = team.enemyTeam.units;
                  var _loc3_:int = int(_loc2_.length);
                  if(this.spellMc.currentFrame > 20)
                  {
                        _loc4_ = px + Util.sgn(scaleX) * 75;
                        param1.spatialHash.mapInArea(_loc4_ - this.explosionRadius / 2,py - this.explosionRadius / 2,_loc4_ + this.explosionRadius / 2,py + this.explosionRadius / 2,this.poisonUnit);
                  }
                  ++this.frames;
            }
            
            private function poisonUnit(param1:Unit) : void
            {
                  if(param1.team != this.team)
                  {
                        if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.explosionRadius,2))
                        {
                              dz = dx = dy = 0;
                              param1.poison(this.poisonDamage);
                        }
                  }
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.timeToLive <= this.frames;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this.timeToLive > this.frames;
            }
      }
}
