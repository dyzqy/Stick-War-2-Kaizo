package com.brockw.stickwar.engine.units
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.market.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class EnslavedGiant extends RangedUnit
   {
      
      private static const WEAPON_REACH:int = 90;
       
      
      private var target:com.brockw.stickwar.engine.units.Unit;
      
      private var scaleI:Number;
      
      private var scaleII:Number;
      
      private var hasGrowled:Boolean;
      
      public function EnslavedGiant(param1:StickWar)
      {
         super(param1);
         _mc = new _giantMc();
         this.init(param1);
         addChild(_mc);
         ai = new EnslavedGiantAi(this);
         initSync();
         firstInit();
      }
      
      public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:_giantMc = null;
         if((_loc5_ = _giantMc(param1)).mc.giantbag)
         {
            if(param2 != "")
            {
               _loc5_.mc.giantbag.gotoAndStop(param2);
            }
         }
      }
      
      override public function applyVelocity(param1:Number, param2:Number = 0, param3:Number = 0) : void
      {
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         this.hasGrowled = false;
         _maximumRange = param1.xml.xml.Order.Units.giant.maximumRange;
         population = param1.xml.xml.Chaos.Units.giant.population;
         maxHealth = health = param1.xml.xml.Order.Units.giant.health;
         this.createTime = param1.xml.xml.Order.Units.giant.cooldown;
         projectileVelocity = param1.xml.xml.Order.Units.giant.projectileVelocity;
         _mass = param1.xml.xml.Order.Units.giant.mass;
         _maxForce = param1.xml.xml.Order.Units.giant.maxForce;
         _dragForce = param1.xml.xml.Order.Units.giant.dragForce;
         _scale = param1.xml.xml.Order.Units.giant.scale;
         _maxVelocity = param1.xml.xml.Order.Units.giant.maxVelocity;
         this.scaleI = param1.xml.xml.Order.Units.giant.growthIScale;
         this.scaleII = param1.xml.xml.Order.Units.giant.growthIIScale;
         type = com.brockw.stickwar.engine.units.Unit.U_ENSLAVED_GIANT;
         loadDamage(param1.xml.xml.Order.Units.giant);
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.healthBar.y = -mc.mc.height * 1.1;
         aimXOffset = 50 * 2 - 35;
         aimYOffset = -90 * 2 + 102;
         healthBar.totalHealth = maxHealth;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["SiegeBuilding"];
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Number = NaN;
         if(team.isEnemy && !enemyBuffed)
         {
            _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
            _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
            health = health / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
            maxHealth = health;
            maxHealth = maxHealth;
            healthBar.totalHealth = maxHealth;
            _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
            enemyBuffed = true;
         }
         if(!this.hasGrowled)
         {
            this.hasGrowled = true;
            team.game.soundManager.playSoundRandom("GiantGrowl",6,px,py);
         }
         stunTimeLeft = 0;
         _dz = 0;
         if(team.tech.isResearched(Tech.GIANT_GROWTH_II))
         {
            if(_scale != this.scaleII)
            {
               health = param1.xml.xml.Order.Units.giant.healthII - (maxHealth - health);
               maxHealth = param1.xml.xml.Order.Units.giant.healthII;
               healthBar.totalHealth = maxHealth;
            }
            this.pheight *= this.scaleII / this.scaleI;
            _scale = this.scaleII;
         }
         else if(team.tech.isResearched(Tech.GIANT_GROWTH_I))
         {
            if(_scale != this.scaleI)
            {
               health = param1.xml.xml.Order.Units.giant.healthI - (maxHealth - health);
               maxHealth = param1.xml.xml.Order.Units.giant.healthI;
               healthBar.totalHealth = maxHealth;
            }
            this.pheight *= this.scaleI / _scale;
            _scale = this.scaleI;
         }
         _loc2_ = _mc.localToGlobal(new Point(50,-90));
         _loc2_ = this.globalToLocal(_loc2_);
         aimXOffset = _loc2_.x;
         aimYOffset = _loc2_.y + 25;
         super.update(param1);
         updateCommon(param1);
         if(!isDieing)
         {
            updateMotion(param1);
            if(_isDualing)
            {
               _mc.gotoAndStop(_currentDual.attackLabel);
               moveDualPartner(_dualPartner,_currentDual.xDiff);
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  _isDualing = false;
                  _state = S_RUN;
                  px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                  dx = 0;
                  dy = 0;
               }
            }
            else if(_state == S_RUN)
            {
               if(isFeetMoving())
               {
                  _mc.gotoAndStop("run");
               }
               else
               {
                  _mc.gotoAndStop("stand");
               }
            }
            else if(_state == S_ATTACK)
            {
               if(MovieClip(_mc.mc).currentFrame == 1)
               {
                  team.game.soundManager.playSound("BoulderThrowSound",px,py);
               }
               if(MovieClip(_mc.mc).currentFrame == 33)
               {
                  _loc2_ = _mc.localToGlobal(new Point(50,-90));
                  _loc2_ = param1.battlefield.globalToLocal(_loc2_);
                  _loc3_ = 0;
                  if(inRange(this.target))
                  {
                     _loc3_ = angleToTargetW(this.target,projectileVelocity,angleToTarget(this.target));
                  }
                  if(mc.scaleX < 0)
                  {
                     param1.projectileManager.initBoulder(_loc2_.x,_loc2_.y,180 - bowAngle,projectileVelocity,0,_loc3_,this,damageToDeal,false,this.target);
                  }
                  else
                  {
                     param1.projectileManager.initBoulder(_loc2_.x,_loc2_.y,bowAngle,projectileVelocity,0,_loc3_,this,damageToDeal,false,this.target);
                  }
               }
               if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
               }
            }
         }
         else if(isDead == false)
         {
            isDead = true;
            team.game.soundManager.playSoundRandom("GiantDeath",3,px,py);
            if(_isDualing)
            {
               _mc.gotoAndStop(_currentDual.defendLabel);
            }
            else
            {
               _mc.gotoAndStop(getDeathLabel(param1));
            }
            this.team.removeUnit(this,param1);
         }
         if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
         {
            MovieClip(_mc.mc).gotoAndStop(1);
         }
         MovieClip(_mc.mc).nextFrame();
         _mc.mc.stop();
         if(!hasDefaultLoadout)
         {
            EnslavedGiant.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
         }
      }
      
      override public function aim(param1:com.brockw.stickwar.engine.units.Unit) : void
      {
         var _loc2_:Number = angleToTarget(param1);
         if(param1 != null && this._state == com.brockw.stickwar.engine.units.Unit.S_ATTACK && !inRange(param1))
         {
            return;
         }
         if(Math.abs(normalise(angleToBowSpace(_loc2_) - bowAngle)) < 10)
         {
            bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 1;
         }
         else
         {
            bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 1;
         }
      }
      
      override public function shoot(param1:StickWar, param2:com.brockw.stickwar.engine.units.Unit) : void
      {
         var _loc3_:int = 0;
         if(_state != S_ATTACK)
         {
            _loc3_ = team.game.random.nextInt() % this._attackLabels.length;
            _mc.gotoAndStop("attack_" + this._attackLabels[_loc3_]);
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_ATTACK;
            this.target = param2;
            attackStartFrame = team.game.frame;
            framesInAttack = MovieClip(_mc.mc).totalFrames;
         }
      }
      
      override public function mayAttack(param1:com.brockw.stickwar.engine.units.Unit) : Boolean
      {
         if(framesInAttack > team.game.frame - attackStartFrame)
         {
            return false;
         }
         return super.mayAttack(param1);
      }
      
      override public function stateFixForCutToWalk() : void
      {
         super.stateFixForCutToWalk();
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return _state == S_RUN;
      }
   }
}
