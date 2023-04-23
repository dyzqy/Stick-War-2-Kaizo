package com.brockw.stickwar.engine.units.elementals
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.market.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class EarthElement extends Unit
   {
      
      private static var WEAPON_REACH:int;
      
      private static var RAGE_COOLDOWN:int;
      
      private static var RAGE_EFFECT:int;
       
      
      private var stunXForce:Number;
      
      private var stunYForce:Number;
      
      private var stunFrames:Number;
      
      private var _morphScale:Number;
      
      private var isMorphing:Boolean;
      
      public function EarthElement(param1:StickWar)
      {
         super(param1);
         _mc = new _earthElemental();
         this.isMorphing = false;
         this.init(param1);
         addChild(_mc);
         ai = new EarthElementAi(this);
         initSync();
         firstInit();
      }
      
      public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:_earthElemental;
         if(Boolean((_loc5_ = _earthElemental(param1)).mc.head) && Boolean(_loc5_.mc.head.hat))
         {
            if(param3 != "")
            {
               _loc5_.mc.head.hat.gotoAndStop(param3);
            }
         }
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         WEAPON_REACH = param1.xml.xml.Elemental.Units.earthElement.weaponReach;
         population = param1.xml.xml.Elemental.Units.earthElement.population;
         _mass = param1.xml.xml.Elemental.Units.earthElement.mass;
         _maxForce = param1.xml.xml.Elemental.Units.earthElement.maxForce;
         _dragForce = param1.xml.xml.Elemental.Units.earthElement.dragForce;
         _scale = param1.xml.xml.Elemental.Units.earthElement.scale;
         this._morphScale = param1.xml.xml.Elemental.Units.miner.scale * 0.95;
         _maxVelocity = param1.xml.xml.Elemental.Units.earthElement.maxVelocity;
         damageToDeal = param1.xml.xml.Elemental.Units.earthElement.baseDamage;
         this.createTime = param1.xml.xml.Elemental.Units.earthElement.cooldown;
         maxHealth = health = param1.xml.xml.Elemental.Units.earthElement.health;
         this.stunXForce = param1.xml.xml.Elemental.Units.earthElement.stunXForce;
         this.stunYForce = param1.xml.xml.Elemental.Units.earthElement.stunYForce;
         this.stunFrames = param1.xml.xml.Elemental.Units.earthElement.stunFrames;
         combineColour = 10040064;
         type = Unit.U_EARTH_ELEMENT;
         this.isMorphing = false;
         loadDamage(param1.xml.xml.Elemental.Units.earthElement);
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
      }
      
      override public function weaponReach() : Number
      {
         return WEAPON_REACH;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["EarthBuilding"];
      }
      
      override public function getDamageToDeal() : Number
      {
         return damageToDeal;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Number = NaN;
         updateCommon(param1);
         updateElementalCombine();
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
                  px += Util.sgn(mc.scaleX) * team.game.getPerspectiveScale(py) * _currentDual.finalXOffset;
                  x = px;
                  dx = 0;
                  dy = 0;
               }
            }
            else if(this.isMorphing)
            {
               _mc.gotoAndStop("transform");
               _loc2_ = 1 * _mc.mc.currentFrame / _mc.mc.totalFrames;
               _scale = this._morphScale * _loc2_ + _scale * (1 - _loc2_);
               if(_mc.mc.currentFrame == _mc.mc.totalFrames)
               {
                  this.transformIntoMiner();
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
               if(MovieClip(mc.mc).currentFrameLabel == "swing")
               {
                  team.game.soundManager.playSound("swordwrathSwing1",px,py);
               }
               if(!hasHit)
               {
                  hasHit = this.checkForHit();
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
            if(_isDualing)
            {
               _mc.gotoAndStop(_currentDual.defendLabel);
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  isDualing = false;
                  mc.filters = [];
               }
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
         Util.animateMovieClip(_mc);
         EarthElement.setItem(mc,"",team.loadout.getItem(this.type,MarketItem.T_ARMOR),"");
      }
      
      override protected function checkForHit() : Boolean
      {
         var _loc1_:Unit = ai.getClosestTarget();
         if(_loc1_ == null)
         {
            return false;
         }
         var _loc2_:int = int(Util.sgn(_loc1_.px - px));
         if(_mc.mc.tip == null)
         {
            return false;
         }
         var _loc3_:Point = MovieClip(_mc.mc.tip).localToGlobal(new Point(0,0));
         if(_loc1_.checkForHitPoint(_loc3_,_loc1_))
         {
            _loc1_.damage(0,this.damageToDeal,this);
            _loc1_.stun(this.stunFrames,this.stunYForce);
            _loc1_.applyVelocity(this.stunXForce * Util.sgn(mc.scaleX));
            return true;
         }
         return false;
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         super.setActionInterface(param1);
         param1.setAction(0,0,UnitCommand.MORPH_MINER);
      }
      
      public function morph() : void
      {
         this.isMorphing = true;
         this.transformIntoMiner();
      }
      
      override public function isBusy() : Boolean
      {
         return this.isMorphing;
      }
      
      private function transformIntoMiner() : void
      {
         team.removeUnitCompletely(this,team.game);
         var _loc1_:Unit = team.game.unitFactory.getUnit(Unit.U_MINER_ELEMENT);
         team.spawn(_loc1_,team.game);
         _loc1_.x = _loc1_.px = px - getDirection() * 10;
         _loc1_.y = _loc1_.py = py;
         _loc1_.visible = true;
         _loc1_.update(team.game);
         _loc1_.health = _loc1_.maxHealth * (health / maxHealth);
         MinerAi(_loc1_.ai).startAutoMiningNow();
         var _loc2_:StandCommand = new StandCommand(team.game);
         _loc2_.type = UnitCommand.STAND;
         _loc1_.ai.setCommand(team.game,_loc2_);
         ElementalMiner(_loc1_).morph();
         if(team == team.game.team)
         {
            _loc1_.selected = true;
            team.game.gameScreen.userInterface.selectedUnits.add(_loc1_);
         }
      }
      
      override public function attack() : void
      {
         var _loc1_:int = 0;
         if(_state != S_ATTACK)
         {
            _loc1_ = team.game.random.nextInt() % this._attackLabels.length;
            _mc.gotoAndStop("attack_" + this._attackLabels[_loc1_]);
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_ATTACK;
            hasHit = false;
            attackStartFrame = team.game.frame;
            framesInAttack = MovieClip(_mc.mc).totalFrames;
         }
      }
      
      override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
      {
         super.damage(param1,param2,param3);
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return this._state == S_RUN && !this.isMorphing;
      }
      
      override public function mayAttack(param1:Unit) : Boolean
      {
         if(framesInAttack > team.game.frame - attackStartFrame)
         {
            return false;
         }
         if(isIncapacitated())
         {
            return false;
         }
         if(param1 == null)
         {
            return false;
         }
         if(this.isDualing == true)
         {
            return false;
         }
         if(_state == S_RUN)
         {
            if(Math.abs(px - param1.px) < WEAPON_REACH && Math.abs(py - param1.py) < 40 && this.getDirection() == Util.sgn(param1.px - px))
            {
               return true;
            }
         }
         return false;
      }
   }
}
