package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      import flash.display.*;
      
      public class LavaSpark extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public function LavaSpark(param1:StickWar)
            {
                  super();
                  type = LAVA_SPARK;
                  this.spellMc = new lavaSpark();
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
                  this.spellMc.spark.nextFrame();
                  scaleX *= 1;
                  scaleY *= 1;
                  x = px;
                  y = py + pz;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.spellMc.spark.currentFrame == this.spellMc.spark.totalFrames;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this.spellMc.spark.currentFrame != this.spellMc.spark.totalFrames;
            }
      }
}
