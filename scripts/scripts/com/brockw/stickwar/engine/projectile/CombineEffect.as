package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class CombineEffect extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public var unit:Unit;
            
            public function CombineEffect(param1:StickWar)
            {
                  super();
                  type = COMBINE_EFFECT;
                  this.spellMc = new combineAnimationMc();
                  this.addChild(this.spellMc);
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
                  removeChild(this.spellMc);
                  this.spellMc = null;
            }
            
            override public function update(param1:StickWar) : void
            {
                  this.spellMc.nextFrame();
                  Util.animateMovieClip(this.spellMc);
                  scaleX *= 1;
                  scaleY *= 1;
                  x = px;
                  y = py + pz;
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
