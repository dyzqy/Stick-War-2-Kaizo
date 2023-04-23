package com.brockw.stickwar.engine.units.elementals
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.market.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class FirestormElement extends Unit
   {
      
      private static var WEAPON_REACH:int;
      
      private static var RAGE_COOLDOWN:int;
      
      private static var RAGE_EFFECT:int;
       
      
      private var _isBlocking:Boolean;
      
      private var _inBlock:Boolean;
      
      private var shieldwallDamageReduction:Number;
      
      private var isShieldBashing:Boolean;
      
      private var stunForce:Number;
      
      private var stunTime:int;
      
      private var stunned:Unit;
      
      private var isNuking:Boolean;
      
      private var isFirebreath:Boolean;
      
      private var spellX:Number;
      
      private var spellY:Number;
      
      private var breathNumber:int;
      
      private var firestormSpellCooldown:SpellCooldown;
      
      private var firebreathSpellCooldown:SpellCooldown;
      
      private var firestormFireFrames:int;
      
      private var firebreathFireFrames:int;
      
      private var firestormFireDamage:Number;
      
      private var firebreathFireDamage:Number;
      
      private var firebreathDamage:Number;
      
      private var firestormDamage:Number;
      
      private var firestormStunForce:Number;
      
      private var firebreathArea:Number;
      
      private var fireBreathHasHit:Dictionary;
      
      public function FirestormElement(param1:StickWar)
      {
         super(param1);
         _mc = new _firestormElement();
         this.init(param1);
         addChild(_mc);
         ai = new FirestormElementAi(this);
         initSync();
         firstInit();
      }
      
      public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:_firestormElement;
         if(Boolean((_loc5_ = _firestormElement(param1)).mc.head) && Boolean(_loc5_.mc.head.head))
         {
            if(param3 != "")
            {
               _loc5_.mc.head.head.gotoAndStop(param3);
            }
         }
         if(_loc5_.mc.body)
         {
            if(param4 != "")
            {
               _loc5_.mc.body.gotoAndStop(param4);
            }
         }
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         this.inBlock = false;
         this.isBlocking = false;
         this.isNuking = false;
         this.breathNumber = 0;
         WEAPON_REACH = param1.xml.xml.Elemental.Units.firestormElement.weaponReach;
         this.stunTime = param1.xml.xml.Elemental.Units.firestormElement.shieldBash.stunTime;
         this.stunForce = param1.xml.xml.Elemental.Units.firestormElement.shieldBash.stunForce;
         population = param1.xml.xml.Elemental.Units.firestormElement.population;
         this.shieldwallDamageReduction = param1.xml.xml.Elemental.Units.firestormElement.shieldWall.damageReduction;
         _mass = param1.xml.xml.Elemental.Units.firestormElement.mass;
         _maxForce = param1.xml.xml.Elemental.Units.firestormElement.maxForce;
         _dragForce = param1.xml.xml.Elemental.Units.firestormElement.dragForce;
         _scale = param1.xml.xml.Elemental.Units.firestormElement.scale;
         _maxVelocity = param1.xml.xml.Elemental.Units.firestormElement.maxVelocity;
         damageToDeal = param1.xml.xml.Elemental.Units.firestormElement.baseDamage;
         this.createTime = param1.xml.xml.Elemental.Units.firestormElement.cooldown;
         maxHealth = health = param1.xml.xml.Elemental.Units.firestormElement.health;
         this.firestormStunForce = param1.xml.xml.Elemental.Units.firestormElement.firestorm.stunForce;
         this.firestormFireFrames = param1.xml.xml.Elemental.Units.firestormElement.firestorm.fireFrames;
         this.firebreathFireFrames = param1.xml.xml.Elemental.Units.firestormElement.firebreath.fireFrames;
         this.firestormDamage = param1.xml.xml.Elemental.Units.firestormElement.firestorm.damage;
         this.firestormFireDamage = param1.xml.xml.Elemental.Units.firestormElement.firestorm.fireDamage;
         this.firebreathFireDamage = param1.xml.xml.Elemental.Units.firestormElement.firebreath.fireDamage;
         this.firebreathDamage = param1.xml.xml.Elemental.Units.firestormElement.firebreath.damage;
         this.firebreathArea = param1.xml.xml.Elemental.Units.firestormElement.firebreath.area;
         this.firestormSpellCooldown = new SpellCooldown(param1.xml.xml.Elemental.Units.firestormElement.firestorm.effect,param1.xml.xml.Elemental.Units.firestormElement.firestorm.cooldown,param1.xml.xml.Elemental.Units.firestormElement.firestorm.mana);
         this.firebreathSpellCooldown = new SpellCooldown(param1.xml.xml.Elemental.Units.firestormElement.firebreath.effect,param1.xml.xml.Elemental.Units.firestormElement.firebreath.cooldown,param1.xml.xml.Elemental.Units.firestormElement.firebreath.mana);
         this.flyingHeight = 0;
         this.pz = flyingHeight;
         type = Unit.U_FIRESTORM_ELEMENT;
         loadDamage(param1.xml.xml.Elemental.Units.firestormElement);
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         this.isShieldBashing = false;
         this.isFirebreath = false;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
      }
      
      override public function isBusy() : Boolean
      {
         return !this.notInSpell() || isBusyForSpell;
      }
      
      private function notInSpell() : Boolean
      {
         return !this.isFirebreath && !this.isNuking;
      }
      
      override public function weaponReach() : Number
      {
         return WEAPON_REACH;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BarracksBuilding"];
      }
      
      override public function getDamageToDeal() : Number
      {
         return damageToDeal;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Boolean = false;
         this.firestormSpellCooldown.update();
         this.firebreathSpellCooldown.update();
         updateCommon(param1);
         if(timeAlive > 15)
         {
            mc.visible = true;
         }
         else
         {
            mc.visible = false;
         }
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
            else if(this.isFirebreath == true)
            {
               _mc.gotoAndStop("firerain_spell");
               forceFaceDirection(this.spellX - this.px);
               if(MovieClip(_mc.mc).currentFrame == 2)
               {
                  team.game.soundManager.playSound("meteorSound",px,py);
               }
               if(MovieClip(_mc.mc).currentFrame == 40)
               {
                  team.game.soundManager.playSound("lavaRainSound",px,py);
               }
               if(MovieClip(_mc.mc).currentFrame > 40 && MovieClip(_mc.mc).currentFrame < 90 && MovieClip(_mc.mc).currentFrame % 6 == 0)
               {
                  this.initFireBreathLine(this.breathNumber++);
               }
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  this.isFirebreath = false;
                  _state = S_RUN;
               }
            }
            else if(this.isNuking == true)
            {
               _mc.gotoAndStop("dragon_spell");
               if(MovieClip(_mc.mc).currentFrame == 4)
               {
                  param1.soundManager.playSound("smallDragonRoarSound",px,py);
               }
               if(MovieClip(_mc.mc).currentFrame == 14)
               {
                  param1.projectileManager.initFirestorm(this.spellX,this.spellY,0,team,getDirection(),this.firestormDamage,this.firestormFireDamage,this.firestormFireFrames,this.firestormStunForce);
               }
               if(MovieClip(_mc.mc).currentFrame == 80 && !hasHit)
               {
                  hasHit = true;
               }
               if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
               {
                  this.isNuking = false;
                  _state = S_RUN;
               }
            }
            else if(this.isShieldBashing)
            {
               if(MovieClip(mc.mc).currentFrameLabel == "swing")
               {
                  team.game.soundManager.playSound("swordwrathSwing1",px,py);
               }
               _mc.gotoAndStop("shieldBash");
               _mc.mc.nextFrame();
               if(_mc.mc.currentFrame == 12)
               {
                  _loc2_ = Boolean(checkForBlockHit());
               }
               if(_mc.mc.currentFrame == _mc.mc.totalFrames)
               {
                  this.isShieldBashing = false;
               }
            }
            else if(this.inBlock)
            {
               if(_mc.currentLabel == "shieldBash")
               {
                  _mc.gotoAndStop("block");
                  _mc.mc.gotoAndStop(15);
               }
               else
               {
                  _mc.gotoAndStop("block");
               }
               if(this.isBlocking)
               {
                  if(_mc.mc.currentFrame < 15)
                  {
                     _mc.mc.nextFrame();
                  }
               }
               else
               {
                  _mc.mc.nextFrame();
                  if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                  {
                     this.inBlock = false;
                  }
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
         if(_isDualing || !this.inBlock || isDead)
         {
            Util.animateMovieClip(_mc);
         }
         FirestormElement.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
      }
      
      private function initFireBreathLine(param1:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = this.spellX + (team.game.random.nextNumber() * this.firebreathArea - this.firebreathArea / 2) * this.getDirection();
            if(techTeam.tech.isResearched(Tech.LAVA_POOL) && _loc2_ == 0 && param1 % 2 == 0)
            {
               team.game.projectileManager.initLavaComet(_loc3_,team.game.random.nextNumber() * team.game.map.height,this,this.firebreathDamage,this.firebreathFireDamage,this.firebreathFireFrames);
            }
            else
            {
               team.game.projectileManager.initLavaRain(_loc3_,team.game.random.nextNumber() * team.game.map.height,this,this.firebreathDamage,this.firebreathFireDamage,this.firebreathFireFrames);
            }
            _loc2_++;
         }
      }
      
      private function firebreathHit(param1:Unit) : *
      {
         if(param1.team != this.team && !(param1.id in this.fireBreathHasHit))
         {
            param1.damage(Unit.D_FIRE,this.firebreathDamage,null);
            param1.setFire(this.firebreathFireFrames,this.firebreathFireDamage);
            this.fireBreathHasHit[param1.id] = 1;
         }
      }
      
      public function stopBlocking() : void
      {
         this.isBlocking = false;
      }
      
      public function startBlocking() : void
      {
         if(techTeam.tech.isResearched(Tech.BLOCK))
         {
            this.isBlocking = true;
            this.inBlock = true;
            team.game.soundManager.playSound("speartonHoghSound",px,py);
         }
      }
      
      public function firestormNukeCooldown() : Number
      {
         return this.firestormSpellCooldown.cooldown();
      }
      
      public function firestormNuke(param1:Number, param2:Number) : void
      {
         if(Boolean(this.notInSpell()) && Boolean(this.firestormSpellCooldown.spellActivate(this.team)))
         {
            this.spellX = param1;
            forceFaceDirection(this.spellX - this.px);
            this.spellY = param2;
            this.isNuking = true;
            hasHit = false;
            _state = S_ATTACK;
            _mc.gotoAndStop("attack_1");
            MovieClip(_mc.mc).gotoAndStop(1);
         }
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(this.notInSpell())
         {
            super.stateFixForCutToWalk();
         }
      }
      
      public function firebreathNukeCooldown() : Number
      {
         return this.firebreathSpellCooldown.cooldown();
      }
      
      public function firebreathNuke(param1:Number, param2:Number) : void
      {
         if(Boolean(this.notInSpell()) && Boolean(this.firebreathSpellCooldown.spellActivate(this.team)))
         {
            this.spellX = param1;
            forceFaceDirection(this.spellX - this.px);
            this.spellY = param2;
            this.isFirebreath = true;
            this.breathNumber = 0;
            hasHit = false;
            _state = S_ATTACK;
            _mc.gotoAndStop("attack_1");
            MovieClip(_mc.mc).gotoAndStop(1);
            this.fireBreathHasHit = new Dictionary();
         }
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         super.setActionInterface(param1);
         param1.setAction(0,0,UnitCommand.FIRESTORM_NUKE);
         param1.setAction(1,0,UnitCommand.FIRE_BREATH);
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
         if(this.inBlock)
         {
            super.damage(param1,param2 - param2 * this.shieldwallDamageReduction,param3,1 - this.shieldwallDamageReduction);
         }
         else
         {
            super.damage(param1,param2,param3);
         }
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
      
      public function get isBlocking() : Boolean
      {
         return this._isBlocking;
      }
      
      public function set isBlocking(param1:Boolean) : void
      {
         this._isBlocking = param1;
      }
      
      public function get inBlock() : Boolean
      {
         return this._inBlock;
      }
      
      public function set inBlock(param1:Boolean) : void
      {
         this._inBlock = param1;
      }
   }
}
