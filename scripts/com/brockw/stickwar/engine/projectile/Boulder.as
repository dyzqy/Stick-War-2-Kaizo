package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   import flash.geom.*;
   
   public class Boulder extends Projectile
   {
       
      
      private var spellMc:MovieClip;
      
      private var stunTimeBoulder:Number;
      
      protected var p4:Point;
      
      protected var p5:Point;
      
      protected var p6:Point;
      
      protected var p7:Point;
      
      protected var p8:Point;
      
      protected var p9:Point;
      
      public function Boulder(param1:StickWar)
      {
         super();
         type = BOULDER;
         this.spellMc = new boulderMc();
         this.addChild(this.spellMc);
         this.spellMc.x -= this.spellMc.width / 2;
         this.spellMc.y -= this.spellMc.height / 2;
         this.spellMc.scaleX = 1;
         this.spellMc.scaleY = 1;
         _drotation = 0;
         _rot = 0;
         this.stunTimeBoulder = param1.xml.xml.Order.Units.giant.stunTime;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override protected function arrowHit(param1:Unit) : void
      {
         if(hasHit)
         {
            return;
         }
         if(isDebris && param1 == unitNotToHit)
         {
            return;
         }
         if(Unit(param1).team != this.team)
         {
            if(Boolean(Unit(param1).checkForHitPointArrow(p1,py,intendedTarget)) || Boolean(Unit(param1).checkForHitPointArrow(p2,py,intendedTarget)) || Boolean(Unit(param1).checkForHitPointArrow(p3,py,intendedTarget)))
            {
               unitNotToHit = param1;
               hasHit = true;
               lastDistanceToCentre = Math.abs(x - param1.px);
            }
         }
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Wall = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc2_:Number = dx;
         var _loc3_:Number = dy;
         var _loc4_:Number = dz;
         this.stunTime = this.stunTimeBoulder;
         this.visible = true;
         this.scaleX = this._scale * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = this._scale * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.x = px;
         this.y = pz + py;
         if(py < 0)
         {
            visible = false;
         }
         _loc5_ = param1.projectileManager.airEffects;
         px += dx;
         py += dy;
         pz += dz;
         dz += StickWar.GRAVITY;
         for each(_loc6_ in _loc5_)
         {
            if(Math.abs(_loc6_[0] - px) < 100)
            {
               _loc7_ = int(Util.sgn(_loc6_[2]));
               if(Util.sgn(dx) != _loc7_ && _loc6_[3] != this.team)
               {
                  dx += _loc6_[2];
               }
            }
         }
         if(pz > 0 && dz > 0 && !hasHit)
         {
            dz = dx = dy = 0;
            if(!hasHit)
            {
               hasHit = true;
            }
         }
         else
         {
            rotation = 90 - Math.atan2(dx,dz + dy) * 180 / Math.PI;
         }
         if(isDebris)
         {
            return;
         }
         p1 = this.localToGlobal(new Point(-10,40));
         p2 = this.localToGlobal(new Point(40,40));
         p3 = this.localToGlobal(new Point(90,40));
         this.p4 = this.localToGlobal(new Point(-10,-10));
         this.p5 = this.localToGlobal(new Point(40,-10));
         this.p6 = this.localToGlobal(new Point(90,-10));
         this.p7 = this.localToGlobal(new Point(-10,90));
         this.p8 = this.localToGlobal(new Point(40,90));
         this.p9 = this.localToGlobal(new Point(90,90));
         if(!hasHit)
         {
            param1.spatialHash.mapInArea(px - 100,py - 100,px + 100,py + 100,this.arrowHit);
            for each(_loc8_ in team.enemyTeam.walls)
            {
               this.arrowHit(_loc8_);
            }
         }
         else if(unitNotToHit != null)
         {
            _loc9_ = Math.abs(x - unitNotToHit.px);
            if(!Unit(unitNotToHit).checkForHitPoint(p3,Unit(unitNotToHit)) || _loc9_ > lastDistanceToCentre)
            {
               _loc10_ = Number(Util.sgn(dx));
               dz = dx = dy = 0;
               this.visible = false;
               if(unitNotToHit is Unit)
               {
                  Unit(unitNotToHit).stun(this.stunTime);
                  Unit(unitNotToHit).poison(this.poisonDamage);
                  Unit(unitNotToHit).slow(slowFrames);
               }
               if(this is Boulder)
               {
                  Unit(unitNotToHit).applyVelocity(2 * Util.sgn(_loc10_));
               }
               Entity(unitNotToHit.damage(isFire ? 1 : 0,damageToDeal,_inflictor));
            }
            lastDistanceToCentre = _loc9_;
         }
         this.rotation = _rot;
         _rot += _drotation;
         visible = true;
         if(!this.isInFlight())
         {
            visible = false;
         }
         if(!this.isInFlight() && !isDebris)
         {
            team.game.soundManager.playSound("BoulderSmashSound",px,py);
            _loc11_ = 0;
            while(_loc11_ < 5)
            {
               _loc12_ = _loc2_ * 0.6 + param1.random.nextNumber() * 4 - 2;
               _loc13_ = _loc3_ * 0.6 + param1.random.nextNumber() * 10 - 5;
               _loc14_ = _loc4_ * 0.6 + param1.random.nextNumber() * 4 - 2;
               param1.projectileManager.initBoulderDebris(px,py,pz,_loc12_,_loc13_,_loc14_,0.2,param1,inflictor,unitNotToHit);
               _loc11_++;
            }
         }
      }
   }
}
