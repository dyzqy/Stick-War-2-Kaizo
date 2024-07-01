package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import flash.display.*;
      
      public class Flower extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public var hasBloomed:Boolean;
            
            public function Flower(param1:StickWar)
            {
                  super();
                  type = FLOWER;
                  this.spellMc = new _flowerTrail();
                  this.addChild(this.spellMc);
                  scale = 1;
                  this.hasBloomed = false;
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
                  removeChild(this.spellMc);
                  this.spellMc = null;
            }
            
            override public function update(param1:StickWar) : void
            {
                  if(!(!this.hasBloomed && MovieClip(this.spellMc.mc).currentFrame >= 10))
                  {
                        Util.animateMovieClip(this.spellMc,4);
                  }
                  this.scaleX = scale * team.direction;
                  this.scaleY = scale;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.spellMc.mc.currentFrame == this.spellMc.mc.totalFrames;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this.spellMc.mc.currentFrame != this.spellMc.mc.totalFrames;
            }
      }
}
