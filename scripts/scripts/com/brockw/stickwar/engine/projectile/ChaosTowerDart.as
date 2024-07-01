package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      
      public class ChaosTowerDart extends DirectedProjectile
      {
             
            
            public function ChaosTowerDart(param1:StickWar)
            {
                  super(param1);
                  type = TOWER_DART;
                  this.graphics.lineStyle(5,65280,1);
                  this.graphics.drawCircle(0,0,3);
                  if(param1)
                  {
                        this.damageToDeal = param1.xml.xml.Chaos.Units.tower.damage;
                  }
            }
      }
}
