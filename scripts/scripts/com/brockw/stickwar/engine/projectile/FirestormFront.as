package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      import flash.display.*;
      
      public class FirestormFront extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public function FirestormFront(param1:StickWar)
            {
                  super();
                  type = FIRESTORM_FRONT;
                  this.spellMc = new fireCircleFrontMc();
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
                  scaleX *= 1;
                  scaleY *= 1;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.spellMc.currentFrame == this.spellMc.totalFrames;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this.spellMc.currentFrame != this.spellMc.totalFrames;
            }
      }
}
