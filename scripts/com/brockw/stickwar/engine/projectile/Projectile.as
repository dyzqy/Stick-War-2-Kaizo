package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.*;
   import flash.geom.*;
   
   public class Projectile extends Entity
   {
      
      public static const ARROW:int = 1;
      
      public static const BOLT:int = 2;
      
      public static const GUTS:int = 3;
      
      public static const HEAL:int = 4;
      
      public static const CURE:int = 5;
      
      public static const NUKE:int = 6;
      
      public static const ELECTRIC_WALL:int = 7;
      
      public static const POISON_DART:int = 8;
      
      public static const SLOW_DART:int = 9;
      
      public static const BOULDER:int = 10;
      
      public static const POISON_SPRAY:int = 11;
      
      public static const FIST_ATTACK:int = 12;
      
      public static const REAPER:int = 13;
      
      public static const POISON_POOL:int = 14;
      
      public static const TOWER_DART:int = 15;
      
      public static const WALL_EXPLOSION:int = 16;
      
      public static const TOWER_SPAWN:int = 17;
      
      public static const SPAWN_DRIP:int = 18;
      
      public static const HEAL_EFFECT:int = 19;
      
      public static const FIRE_BALL:int = 20;
      
      public static const SMOKE_PUFF:int = 21;
      
      public static const ICE_FREEZE_EFFECT:int = 22;
      
      public static const FIRE_BALL_EXPLOSION:int = 23;
      
      public static const FIRE_BALL_PROJECTILE:int = 24;
      
      public static const FIRE_WATER_EXPLOSION:int = 25;
      
      public static const FIRE:int = 26;
      
      public static const LIGHTNING:int = 27;
      
      public static const PROTECT_EFFECT:int = 28;
      
      public static const HURRICANE:int = 29;
      
      public static const FLOWER:int = 30;
      
      public static const THORN:int = 31;
      
      public static const FIREBREATH:int = 32;
      
      public static const LAVA_SPARK:int = 33;
      
      public static const TELEPORT_EFFECT:int = 34;
      
      public static const TELEPORT_EFFECT_IN:int = 35;
      
      public static const FIRE_ON_THE_GROUND:int = 36;
      
      public static const MOUND_OF_DIRT:int = 37;
      
      public static const SANDSTORM_TOWER:int = 38;
      
      public static const SANDSTORM_EYE:int = 39;
      
      public static const FIRESTORM_BACK:int = 40;
      
      public static const FIRESTORM_FRONT:int = 41;
      
      public static const LAVA_RAIN:int = 42;
      
      public static const LAVA_COMET:int = 43;
      
      public static const COMBINE_EFFECT:int = 44;
       
      
      protected var _scale:Number;
      
      protected var _dx:Number;
      
      protected var _dy:Number;
      
      protected var _dz:Number;
      
      protected var _targetY:Number;
      
      private var _team:Team;
      
      private var _damageToDeal:Number;
      
      private var _stunTime:int;
      
      private var _poisonDamage:int;
      
      private var _slowFrames:int;
      
      public var framesDead:int;
      
      protected var _drotation:Number;
      
      protected var _rot:Number;
      
      private var _isDebris:Boolean;
      
      protected var _inflictor:Unit;
      
      protected var p1:Point;
      
      protected var p2:Point;
      
      protected var p3:Point;
      
      protected var hasHit:Boolean;
      
      private var _unitNotToHit:Unit;
      
      protected var lastDistanceToCentre:int;
      
      public var isFire:Boolean;
      
      private var _area:Number;
      
      private var _areaDamage:Number;
      
      protected var hasArrowDeath:Boolean;
      
      protected var splashNumHit:int;
      
      public var intendedTarget:Unit;
      
      public var burnDamage:Number;
      
      public var burnFrames:int;
      
      public function Projectile()
      {
         super();
         this.dx = this.dy = this.dz = 0;
         px = py = pz = 0;
         this.damageToDeal = 5;
         this.framesDead = 0;
         this._stunTime = 0;
         this.area = 0;
         this.areaDamage = 0;
         this._scale = 1;
         this.isDebris = false;
         this.unitNotToHit = null;
         this.isFire = false;
         this.hasArrowDeath = false;
         this.splashNumHit = 0;
         this.intendedTarget = null;
         this.burnFrames = 0;
         this.burnDamage = 0;
      }
      
      override public function cleanUp() : void
      {
         this._team = null;
      }
      
      public function initProjectile() : void
      {
         this.hasHit = false;
         this.unitNotToHit = null;
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Wall = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = 0;
         this.visible = true;
         this.scaleX = this._scale * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = this._scale * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.x = px;
         this.y = pz + py;
         if(py < 0)
         {
            visible = false;
         }
         var _loc2_:Array = param1.projectileManager.airEffects;
         px += this.dx;
         py += this.dy;
         pz += this.dz;
         this.dz += StickWar.GRAVITY;
         for each(_loc3_ in _loc2_)
         {
            if(Math.abs(_loc3_[0] - px) < 100)
            {
               _loc4_ = int(Util.sgn(_loc3_[2]));
               if(Util.sgn(this.dx) != _loc4_ && _loc3_[3] != this.team)
               {
                  this.dx += _loc3_[2];
               }
            }
         }
         if(this.isDebris)
         {
            return;
         }
         this.p1 = this.localToGlobal(new Point(0,0));
         this.p2 = this.localToGlobal(new Point(-30,0));
         this.p3 = this.localToGlobal(new Point(30,0));
         if(!this.hasHit)
         {
            param1.spatialHash.mapInArea(px - 50,py - 100,px + 50,py + 100,this.arrowHit);
            for each(_loc5_ in this.team.enemyTeam.walls)
            {
               this.arrowHit(_loc5_);
            }
         }
         else if(this.unitNotToHit != null)
         {
            _loc6_ = Math.abs(x - this.unitNotToHit.px);
            if(!Unit(this.unitNotToHit).checkForHitPoint(this.p3,Unit(this.unitNotToHit)) || _loc6_ > this.lastDistanceToCentre)
            {
               _loc7_ = Number(Util.sgn(this.dx));
               this.dz = this.dx = this.dy = 0;
               this.visible = false;
               if(this.unitNotToHit is Unit)
               {
                  Unit(this.unitNotToHit).stun(this.stunTime);
                  if(this.inflictor is Dead && this.poisonDamage != 0)
                  {
                     if(Dead(this.inflictor).isCastleArcher == true && !Unit(this.unitNotToHit).isPoisoned())
                     {
                        Unit(this.unitNotToHit).poison(this.poisonDamage);
                     }
                     else if(this.inflictor.team.mana > Dead(this.inflictor).poisonMana && !Unit(this.unitNotToHit).isPoisoned())
                     {
                        if(Unit(this.unitNotToHit).poison(this.poisonDamage))
                        {
                           this.inflictor.team.mana -= Dead(this.inflictor).poisonMana;
                        }
                     }
                  }
                  Unit(this.unitNotToHit).slow(this.slowFrames);
               }
               if(this is Boulder)
               {
                  Unit(this.unitNotToHit).applyVelocity(2 * Util.sgn(_loc7_));
               }
               _loc8_ = (_loc8_ = (_loc8_ = 0) | Unit.D_ARROW * (!!this.hasArrowDeath ? 1 : 0)) | Unit.D_FIRE * (this.isFire ? 1 : 0);
               Entity(this.unitNotToHit.damage(_loc8_,this.damageToDeal,this._inflictor));
               this.unitNotToHit.setFire(this.burnFrames,this.burnDamage);
               this.splashNumHit = 0;
               if(this.area != 0)
               {
                  param1.spatialHash.mapInArea(px - this.area,py - this.area,px + this.area,py + this.area,this.projectileArea);
               }
            }
            this.lastDistanceToCentre = _loc6_;
         }
         if(pz > 0 && this.dz > 0 && !this.hasHit)
         {
            this.dz = this.dx = this.dy = 0;
            pz = 0;
            if(!this.hasHit)
            {
               this.hasHit = true;
               this.splashNumHit = 0;
               if(this.area != 0)
               {
                  param1.spatialHash.mapInArea(px - this.area,py - this.area,px + this.area,py + this.area,this.projectileArea);
               }
            }
         }
         else
         {
            rotation = 90 - Math.atan2(this.dx,this.dz + this.dy) * 180 / Math.PI;
         }
      }
      
      private function projectileArea(param1:Unit) : void
      {
         if(this.splashNumHit < 4)
         {
            if(Unit(param1).team != this.team)
            {
               if(Math.pow(px - param1.px,2) + Math.pow(py - param1.py,2) < this.area * this.area)
               {
                  ++this.splashNumHit;
                  param1.damage(0,this.areaDamage,null);
               }
            }
         }
      }
      
      protected function arrowHit(param1:Unit) : void
      {
         if(this.hasHit)
         {
            return;
         }
         if(this.isDebris && param1 == this.unitNotToHit)
         {
            return;
         }
         if(Unit(param1).team != this.team)
         {
            if(Boolean(Unit(param1).checkForHitPointArrow(this.p1,py,this.intendedTarget)) || Boolean(Unit(param1).checkForHitPointArrow(this.p2,py,this.intendedTarget)) || Boolean(Unit(param1).checkForHitPointArrow(this.p3,py,this.intendedTarget)))
            {
               this.unitNotToHit = param1;
               this.hasHit = true;
               this.lastDistanceToCentre = Math.abs(x - param1.px);
            }
         }
      }
      
      public function isReadyForCleanup() : Boolean
      {
         return this.framesDead > 1200;
      }
      
      public function isInFlight() : Boolean
      {
         return this.dx != 0 || this.dy != 0 || this.dz != 0;
      }
      
      public function get dx() : Number
      {
         return this._dx;
      }
      
      public function set dx(param1:Number) : void
      {
         this._dx = param1;
      }
      
      public function get dy() : Number
      {
         return this._dy;
      }
      
      public function set dy(param1:Number) : void
      {
         this._dy = param1;
      }
      
      public function get targetY() : Number
      {
         return this._targetY;
      }
      
      public function set targetY(param1:Number) : void
      {
         this._targetY = param1;
      }
      
      public function get dz() : Number
      {
         return this._dz;
      }
      
      public function set dz(param1:Number) : void
      {
         this._dz = param1;
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      public function set team(param1:Team) : void
      {
         this._team = param1;
      }
      
      public function get damageToDeal() : Number
      {
         return this._damageToDeal;
      }
      
      public function set damageToDeal(param1:Number) : void
      {
         this._damageToDeal = param1;
      }
      
      public function get stunTime() : int
      {
         return this._stunTime;
      }
      
      public function set stunTime(param1:int) : void
      {
         this._stunTime = param1;
      }
      
      public function get poisonDamage() : int
      {
         return this._poisonDamage;
      }
      
      public function set poisonDamage(param1:int) : void
      {
         this._poisonDamage = param1;
      }
      
      public function get slowFrames() : int
      {
         return this._slowFrames;
      }
      
      public function set slowFrames(param1:int) : void
      {
         this._slowFrames = param1;
      }
      
      public function get drotation() : Number
      {
         return this._drotation;
      }
      
      public function set drotation(param1:Number) : void
      {
         this._drotation = param1;
      }
      
      public function get rot() : Number
      {
         return this._rot;
      }
      
      public function set rot(param1:Number) : void
      {
         this._rot = param1;
      }
      
      public function get isDebris() : Boolean
      {
         return this._isDebris;
      }
      
      public function set isDebris(param1:Boolean) : void
      {
         this._isDebris = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      public function get inflictor() : Unit
      {
         return this._inflictor;
      }
      
      public function set inflictor(param1:Unit) : void
      {
         this._inflictor = param1;
      }
      
      public function get unitNotToHit() : Unit
      {
         return this._unitNotToHit;
      }
      
      public function set unitNotToHit(param1:Unit) : void
      {
         this._unitNotToHit = param1;
      }
      
      public function get area() : Number
      {
         return this._area;
      }
      
      public function set area(param1:Number) : void
      {
         this._area = param1;
      }
      
      public function get areaDamage() : Number
      {
         return this._areaDamage;
      }
      
      public function set areaDamage(param1:Number) : void
      {
         this._areaDamage = param1;
      }
   }
}
