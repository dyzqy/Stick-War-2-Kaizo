package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      
      public class PoisonDart extends DirectedProjectile
      {
             
            
            public function PoisonDart(param1:StickWar)
            {
                  super(param1);
                  type = POISON_DART;
                  this.graphics.lineStyle(5,65280,1);
                  this.graphics.moveTo(-5,0);
                  this.graphics.lineTo(5,0);
            }
      }
}
