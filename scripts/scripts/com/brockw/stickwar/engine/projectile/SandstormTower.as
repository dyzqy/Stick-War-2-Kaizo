package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class SandstormTower extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public var unit:Unit;
            
            private var _isCure:Boolean;
            
            public var lifeFrames:int;
            
            public var isReversing:Boolean = false;
            
            public function SandstormTower(param1:StickWar)
            {
                  super();
                  type = SANDSTORM_TOWER;
                  this.lifeFrames = 0;
                  this.spellMc = new sandstormTowerMc();
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
                  if(!this.isReversing)
                  {
                        this.spellMc.nextFrame();
                        Util.animateMovieClip(this.spellMc);
                        --this.lifeFrames;
                  }
                  else
                  {
                        this.spellMc.mc.prevFrame();
                        if(this.spellMc.mc.currentFrame == 1)
                        {
                        }
                  }
                  if(this.lifeFrames == 0)
                  {
                        this.isReversing = true;
                  }
                  scaleX *= 1;
                  scaleY *= 1;
                  x = px;
                  y = py + pz;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.isReversing && this.spellMc.mc.currentFrame == 1;
            }
            
            override public function isInFlight() : Boolean
            {
                  return !this.isReadyForCleanup();
            }
      }
}
