package com.brockw.stickwar.engine.units
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.StickWar;
   import flash.display.*;
   import flash.geom.*;
   
   public class ChaosTower extends RangedUnit
   {
       
      
      private var _isCastleArcher:Boolean;
      
      private var isPoison:Boolean;
      
      private var isFire:Boolean;
      
      private var arrowDamage:Number;
      
      private var bowFrame:int;
      
      private var target:com.brockw.stickwar.engine.units.Unit;
      
      private var _isPoisonedToggled:Boolean;
      
      private var lastShotCounter:int;
      
      private var shotRate:int;
      
      private var isConstructed:Boolean = false;
      
      public function ChaosTower(param1:StickWar)
      {
         super(param1);
         _mc = new chaosTowerMc();
         this.init(param1);
         addChild(_mc);
         ai = new ChaosTowerAi(this);
         initSync();
         firstInit();
         pwidth = this.width;
         pheight = this.height;
         this.isConstructed = false;
      }
      
      override public function poison(param1:Number) : Boolean
      {
         return false;
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         this.lastShotCounter = 99999;
         this.shotRate = param1.xml.xml.Chaos.Units.tower.shotRate;
         _maximumRange = param1.xml.xml.Chaos.Units.tower.maximumRange;
         population = param1.xml.xml.Chaos.Units.tower.population;
         maxHealth = health = param1.xml.xml.Chaos.Units.tower.health;
         this.createTime = param1.xml.xml.Chaos.Units.tower.cooldown;
         this.projectileVelocity = param1.xml.xml.Chaos.Units.tower.arrowVelocity;
         this.arrowDamage = param1.xml.xml.Chaos.Units.tower.damage;
         _mass = param1.xml.xml.Chaos.Units.tower.mass;
         _maxForce = param1.xml.xml.Chaos.Units.tower.maxForce;
         _dragForce = param1.xml.xml.Chaos.Units.tower.dragForce;
         _scale = param1.xml.xml.Chaos.Units.tower.scale;
         _maxVelocity = param1.xml.xml.Chaos.Units.tower.maxVelocity;
         loadDamage(param1.xml.xml.Chaos.Units.tower);
         type = Unit.U_CHAOS_TOWER;
         if(this.isCastleArcher)
         {
            this._maximumRange = param1.xml.xml.Chaos.Units.tower.castleRange;
         }
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _hitBoxWidth = 25;
         _state = S_RUN;
         isStationary = true;
         this.healthBar.y = -190;
         _interactsWith = Unit.I_IS_BUILDING;
         isDead = false;
         isDieing = false;
      }
      
      override public function faceDirection(param1:int) : void
      {
      }
      
      public function setConstructionAmount(param1:Number) : void
      {
         _health = param1 * _maxHealth;
         healthBar.reset();
         if(param1 >= 1)
         {
            this.isConstructed = true;
         }
         else
         {
            this.isConstructed = false;
         }
         if(!this.isConstructed)
         {
            _mc.mc.gotoAndStop(Math.floor(_mc.mc.totalFrames * param1));
         }
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["ArcheryBuilding"];
      }
      
      public function set isCastleArcher(param1:Boolean) : void
      {
         this._isCastleArcher = param1;
      }
      
      override public function update(param1:StickWar) : void
      {
         super.update(param1);
         ++this.lastShotCounter;
         updateCommon(param1);
         if(!isDieing)
         {
            updateMotion(param1);
            if(!this.isConstructed)
            {
               _mc.gotoAndStop("build");
            }
            else
            {
               _mc.gotoAndStop("attack");
            }
         }
         else if(isDead == false)
         {
            isDead = true;
            _mc.gotoAndStop(getDeathLabel(param1));
            this.team.removeUnit(this,param1);
            param1.projectileManager.initNuke(px,py,this,0);
         }
         if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
         {
            MovieClip(_mc.mc).gotoAndStop(1);
         }
         if(this.lastShotCounter < 15)
         {
            Util.animateMovieClip(_mc.mc,0);
         }
         if(isDead)
         {
            _mc.gotoAndStop(getDeathLabel(param1));
            _mc.alpha = 0;
         }
         else
         {
            _mc.alpha = 1;
         }
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
         param1.setAction(0,0,UnitCommand.REMOVE_TOWER_COMMAND);
      }
      
      override public function aim(param1:com.brockw.stickwar.engine.units.Unit) : void
      {
         var _loc2_:Number = angleToTarget(param1);
         if(Math.abs(normalise(angleToBowSpace(_loc2_) - bowAngle)) < 10)
         {
            bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 1;
         }
         else
         {
            bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 1;
         }
      }
      
      override public function aimedAtUnit(param1:com.brockw.stickwar.engine.units.Unit, param2:Number) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param2 == -1.35)
         {
            return false;
         }
         return normalise(Math.abs((bowAngle - angleToBowSpace(param2)) % 360)) < 0.5;
      }
      
      override public function shoot(param1:StickWar, param2:com.brockw.stickwar.engine.units.Unit) : void
      {
         var _loc3_:Point = null;
         if(this.lastShotCounter > this.shotRate && Boolean(this.isConstructed))
         {
            mc.gotoAndStop("attack");
            this.target = param2;
            _loc3_ = mc.mc.localToGlobal(new Point(0,0));
            _loc3_ = param1.battlefield.globalToLocal(_loc3_);
            hasHit = false;
            if(mc.scaleX < 0)
            {
            }
            param1.projectileManager.initTowerDart(_loc3_.x,_loc3_.y,0,this,param2);
            this.lastShotCounter = 0;
         }
      }
      
      public function get isCastleArcher() : Boolean
      {
         return this._isCastleArcher;
      }
   }
}
