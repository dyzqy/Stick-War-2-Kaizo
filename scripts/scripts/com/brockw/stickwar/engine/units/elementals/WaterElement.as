package com.brockw.stickwar.engine.units.elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      
      public class WaterElement extends Unit
      {
             
            
            private var target:Unit;
            
            private var waterDamage:Number;
            
            private var lastShotFrame:int;
            
            private var WEAPON_REACH:int;
            
            private var currentFrameInTarget:int = 0;
            
            public var freezeTarget:Unit;
            
            private var _isHealExplosion:Boolean;
            
            private var healRadius:Number;
            
            private var healAmount:Number;
            
            private var healRadiusUpgrade:Number;
            
            private var healAmountUpgrade:Number;
            
            private var maxHealAmount:Number;
            
            private var maxHealAmountUpgrade:Number;
            
            private var hasExploded:Boolean;
            
            private var hasAGuyFrozen:Boolean;
            
            private var healAmountLeft:Number = 0;
            
            private var unitListToHeal:Array;
            
            public function WaterElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _waterElemental();
                  this.init(param1);
                  addChild(_mc);
                  ai = new WaterElementAi(this);
                  initSync();
                  firstInit();
                  this.freezeTarget = null;
                  this.unitListToHeal = [];
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_waterElemental;
                  if(Boolean((_loc5_ = _waterElemental(param1)).mc.head) && Boolean(_loc5_.mc.head.hat))
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.hat.gotoAndStop(param3);
                        }
                  }
            }
            
            override public function applyVelocity(param1:Number, param2:Number = 0, param3:Number = 0) : void
            {
                  if(!this.hasAGuyFrozen)
                  {
                        super.applyVelocity(param1,param2,param3);
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.lastShotFrame = 0;
                  this._isHealExplosion = false;
                  this.freezeTarget = null;
                  population = param1.xml.xml.Elemental.Units.waterElement.population;
                  this.healthBar.visible = true;
                  this.waterDamage = param1.xml.xml.Elemental.Units.waterElement.fireDamage;
                  _mass = param1.xml.xml.Elemental.Units.waterElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.waterElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.waterElement.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.waterElement.scale;
                  _maxVelocity = param1.xml.xml.Elemental.Units.waterElement.maxVelocity;
                  this.createTime = param1.xml.xml.Elemental.Units.waterElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.waterElement.health;
                  this.healRadius = param1.xml.xml.Elemental.Units.waterElement.healRadius;
                  this.healAmount = param1.xml.xml.Elemental.Units.waterElement.healAmount;
                  this.maxHealAmount = param1.xml.xml.Elemental.Units.waterElement.maxHealAmount;
                  this.maxHealAmountUpgrade = param1.xml.xml.Elemental.Units.waterElement.maxHealAmountUpgrade;
                  this.healRadiusUpgrade = param1.xml.xml.Elemental.Units.waterElement.healRadiusUpgrade;
                  this.healAmountUpgrade = param1.xml.xml.Elemental.Units.waterElement.healAmountUpgrade;
                  this.WEAPON_REACH = 60;
                  loadDamage(param1.xml.xml.Elemental.Units.waterElement);
                  combineColour = 39423;
                  type = Unit.U_WATER_ELEMENT;
                  mayWalkThrough = true;
                  this.hasExploded = false;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.hasAGuyFrozen = false;
            }
            
            override public function stun(param1:int, param2:Number = 1) : void
            {
                  if(!this.hasAGuyFrozen)
                  {
                        super.stun(param1,param2);
                  }
            }
            
            override public function isTargetable() : Boolean
            {
                  if(Boolean(this._isHealExplosion) || Boolean(this.hasExploded))
                  {
                        return false;
                  }
                  return super.isTargetable();
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["WaterBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            private function healUnit(param1:Unit) : void
            {
                  if(param1.team == this.team && this.healAmountLeft > 0)
                  {
                        if(this.techTeam.tech.isResearched(Tech.WATER_HEAL_UPGRADE))
                        {
                              if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.healRadiusUpgrade,2))
                              {
                                    dz = dx = dy = 0;
                                    this.unitListToHeal.push(param1);
                              }
                        }
                        else if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.healRadius,2))
                        {
                              dz = dx = dy = 0;
                              this.unitListToHeal.push(param1);
                        }
                  }
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:Number = NaN;
                  var _loc3_:Number = NaN;
                  var _loc4_:int = 0;
                  var _loc5_:Number = NaN;
                  var _loc6_:Unit = null;
                  var _loc7_:String = null;
                  updateCommon(param1);
                  updateElementalCombine();
                  this.hasAGuyFrozen = false;
                  if(!isDieing)
                  {
                        if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.attackLabel);
                              moveDualPartner(_dualPartner,_currentDual.xDiff);
                              if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                              {
                                    _mc.gotoAndStop("run");
                                    _isDualing = false;
                                    _state = S_RUN;
                                    px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                                    dx = 0;
                                    dy = 0;
                              }
                        }
                        else if(this._isHealExplosion)
                        {
                              _mc.gotoAndStop("healspell");
                              _mc.mc.nextFrame();
                              dx = dy = 0;
                              this.healthBar.visible = false;
                              if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames - 1)
                              {
                                    this._isHealExplosion = false;
                                    this.kill();
                                    this.hasExploded = true;
                              }
                              if(MovieClip(_mc.mc).currentFrame == 5)
                              {
                                    param1.soundManager.playSound("waterHealSound",px,py);
                              }
                              if(MovieClip(_mc.mc).currentFrame == 10)
                              {
                                    this.unitListToHeal = [];
                                    _loc2_ = 0;
                                    _loc3_ = 0;
                                    if(this.techTeam.tech.isResearched(Tech.WATER_HEAL_UPGRADE))
                                    {
                                          this.healAmountLeft = this.maxHealAmountUpgrade;
                                          param1.spatialHash.mapInArea(px - this.healRadiusUpgrade,py - this.healRadiusUpgrade,px + this.healRadiusUpgrade,py + this.healRadiusUpgrade,this.healUnit);
                                          _loc2_ = Number(this.healAmountUpgrade);
                                          _loc3_ = Number(this.maxHealAmount);
                                    }
                                    else
                                    {
                                          this.healAmountLeft = this.maxHealAmount;
                                          param1.spatialHash.mapInArea(px - this.healRadius,py - this.healRadius,px + this.healRadius,py + this.healRadius,this.healUnit);
                                          _loc2_ = Number(this.healAmount);
                                          _loc3_ = Number(this.maxHealAmountUpgrade);
                                    }
                                    _loc4_ = int(this.unitListToHeal.length);
                                    if((_loc5_ = _loc3_ / _loc4_) > _loc2_)
                                    {
                                          _loc5_ = _loc2_;
                                    }
                                    trace("Heal " + _loc4_ + " for " + _loc5_);
                                    for each(_loc6_ in this.unitListToHeal)
                                    {
                                          _loc6_.heal(_loc5_,1);
                                          _loc6_.cure();
                                    }
                              }
                        }
                        else if(_state == S_RUN)
                        {
                              if(isFeetMoving())
                              {
                                    _mc.gotoAndStop("run");
                              }
                              else if(!((_loc7_ = _mc.currentFrameLabel) == "stand" || _loc7_ == "stand_breath"))
                              {
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(this.freezeTarget != ai.currentTarget)
                              {
                                    ai.currentTarget = null;
                                    _state = S_RUN;
                              }
                              if(ai.currentTarget)
                              {
                                    if(!ai.currentTarget.aquireFreezeLock(this))
                                    {
                                          ai.currentTarget = null;
                                          _state = S_RUN;
                                    }
                                    else
                                    {
                                          if(!hasHit)
                                          {
                                                hasHit = true;
                                                _mc.gotoAndStop("attack");
                                                _mc.mc.gotoAndStop(1);
                                          }
                                          MovieClip(_mc.mc).nextFrame();
                                          if(MovieClip(_mc.mc).currentFrame == 45 - 20)
                                          {
                                                param1.soundManager.playSoundRandom("freezing",2,px,py);
                                          }
                                          if(MovieClip(_mc.mc).currentFrame > 95 - 20)
                                          {
                                                this.ai.currentTarget.freeze(2);
                                                this.hasAGuyFrozen = true;
                                                this._mc.mc.alpha = 0.5;
                                          }
                                          else
                                          {
                                                this.ai.currentTarget.slow(1);
                                                this._mc.mc.alpha = 1;
                                                this.px = this.ai.currentTarget.px;
                                                if(ai.currentTarget.type == Unit.U_WATER_ELEMENT)
                                                {
                                                      this.py = this.ai.currentTarget.py;
                                                }
                                                else
                                                {
                                                      this.py = this.ai.currentTarget.py;
                                                }
                                          }
                                          ai.currentTarget.isFreezing = true;
                                    }
                              }
                        }
                        updateMotion(param1);
                  }
                  else if(isDead == false)
                  {
                        if(ai.currentTarget)
                        {
                              ai.currentTarget.releaseFreezeLock(this);
                              ai.currentTarget = null;
                        }
                        if(!this.hasExploded)
                        {
                              this._isHealExplosion = true;
                              isDieing = false;
                              _mc.gotoAndStop("healspell");
                        }
                        else if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.defendLabel);
                              if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                              {
                                    isDualing = false;
                                    mc.filters = [];
                                    this.team.removeUnit(this,param1);
                                    isDead = true;
                              }
                        }
                        else
                        {
                              _mc.gotoAndStop(this.getDeathLabel(param1));
                              this.team.removeUnit(this,param1);
                              isDead = true;
                        }
                  }
                  if(!_state == S_ATTACK)
                  {
                        if(ai.currentTarget)
                        {
                              ai.currentTarget.releaseFreezeLock(this);
                        }
                  }
                  if(Boolean(_mc.mc) && Boolean(_mc.mc.head) && Boolean(_mc.mc.head.water))
                  {
                        Util.animateMovieClipBasic(_mc.mc.head.water);
                  }
                  if(isDead || _isDualing)
                  {
                        Util.animateMovieClip(_mc,0);
                  }
                  else if(!_state == S_ATTACK && !this._isHealExplosion)
                  {
                        if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                        {
                              MovieClip(_mc.mc).gotoAndStop(1);
                        }
                        MovieClip(_mc.mc).nextFrame();
                  }
                  WaterElement.setItem(mc,"",team.loadout.getItem(this.type,MarketItem.T_ARMOR),"");
            }
            
            override public function isBusy() : Boolean
            {
                  if(this._isHealExplosion)
                  {
                        return true;
                  }
                  return super.isBusy();
            }
            
            override protected function getDeathLabel(param1:StickWar) : String
            {
                  var _loc2_:int = team.game.random.nextInt() % this._deathLabels.length;
                  return "death_" + this._deathLabels[_loc2_];
            }
            
            override public function get damageToArmour() : Number
            {
                  return _damageToArmour;
            }
            
            override public function get damageToNotArmour() : Number
            {
                  return _damageToNotArmour;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  param1.setAction(0,0,UnitCommand.WATER_HEAL);
            }
            
            public function healExplosion() : void
            {
                  this._isHealExplosion = true;
            }
            
            override public function attack() : void
            {
                  if(_state != S_ATTACK)
                  {
                        _state = S_ATTACK;
                        hasHit = false;
                        attackStartFrame = team.game.frame;
                        this.freezeTarget = ai.currentTarget;
                        framesInAttack = MovieClip(_mc.mc).totalFrames;
                        team.game.projectileManager.initFreezeEffect(px,py,0,team,Util.sgn(mc.scaleX));
                  }
            }
            
            override public function stateFixForCutToWalk() : void
            {
                  this._state = S_RUN;
                  this.hasHit = true;
            }
            
            override public function mayAttack(param1:Unit) : Boolean
            {
                  if(param1 == null)
                  {
                        return false;
                  }
                  if(param1.type == Unit.U_STATUE || param1.type == Unit.U_WALL)
                  {
                        return false;
                  }
                  if(this.isDualing == true)
                  {
                        return false;
                  }
                  if(_state == S_RUN)
                  {
                        if(Math.abs(px - param1.px) < this.WEAPON_REACH && Math.abs(py - param1.py) < 40 && this.getDirection() == Util.sgn(param1.px - px))
                        {
                              return true;
                        }
                  }
                  return false;
            }
      }
}
