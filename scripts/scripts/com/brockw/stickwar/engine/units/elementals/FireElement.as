package com.brockw.stickwar.engine.units.elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      import flash.geom.*;
      
      public class FireElement extends RangedUnit
      {
             
            
            private var target:Unit;
            
            private var fireDamage:Number;
            
            private var lastShotFrame:int;
            
            private var bowFrame:int;
            
            private var burnDamage:Number;
            
            private var burnFrames:int;
            
            public function FireElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _fireElemental();
                  this.init(param1);
                  addChild(_mc);
                  ai = new FireElementAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_fireElemental;
                  if(Boolean((_loc5_ = _fireElemental(param1)).mc.arms) && Boolean(_loc5_.mc.arms.head) && Boolean(_loc5_.mc.arms.head.hat))
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.arms.head.hat.gotoAndStop(param3);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.lastShotFrame = 0;
                  this.bowFrame = 1;
                  this.burnDamage = param1.xml.xml.Elemental.Units.fireElement.burnDamage;
                  this.burnFrames = param1.xml.xml.Elemental.Units.fireElement.burnFrames;
                  population = param1.xml.xml.Elemental.Units.fireElement.population;
                  this.fireDamage = param1.xml.xml.Elemental.Units.fireElement.fireDamage;
                  _mass = param1.xml.xml.Elemental.Units.fireElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.fireElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.fireElement.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.fireElement.scale;
                  this.projectileVelocity = param1.xml.xml.Elemental.Units.fireElement.velocity;
                  _maxVelocity = param1.xml.xml.Elemental.Units.fireElement.maxVelocity;
                  this.createTime = param1.xml.xml.Elemental.Units.fireElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.fireElement.health;
                  this._maximumRange = param1.xml.xml.Elemental.Units.fireElement.maximumRange;
                  loadDamage(param1.xml.xml.Elemental.Units.fireElement);
                  this.combineColour = 13369344;
                  type = Unit.U_FIRE_ELEMENT;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["FireBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc3_:MovieClip = null;
                  updateCommon(param1);
                  updateElementalCombine();
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
                        else if(_state == S_RUN || _state == S_ATTACK)
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
                        updateMotion(param1);
                  }
                  else if(isDead == false)
                  {
                        if(_isDualing)
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
                  var _loc2_:MovieClip = _mc.mc.arms;
                  if(_loc2_ != null)
                  {
                        _loc2_.gotoAndStop(this.bowFrame);
                        if(this.bowFrame > 10 && this.bowFrame <= 21)
                        {
                              _state = S_RUN;
                        }
                        if(this.bowFrame != 21)
                        {
                              _loc2_.nextFrame();
                              this.bowFrame += 1;
                              if(_loc2_.currentFrame == _loc2_.totalFrames)
                              {
                                    _loc2_.gotoAndStop(1);
                                    this.bowFrame = 1;
                              }
                        }
                        else
                        {
                              _loc3_ = _mc.mc.arms.hands;
                              Util.animateMovieClip(_loc2_);
                        }
                  }
                  if(isDead || _isDualing)
                  {
                        Util.animateMovieClip(_mc,0);
                  }
                  else
                  {
                        if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                        {
                              MovieClip(_mc.mc).gotoAndStop(1);
                        }
                        MovieClip(_mc.mc).nextFrame();
                  }
                  FireElement.setItem(_fireElemental(mc),"",team.loadout.getItem(this.type,MarketItem.T_ARMOR),"");
            }
            
            override public function isLoaded() : Boolean
            {
                  return this.bowFrame == 21;
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
            }
            
            override public function shoot(param1:StickWar, param2:Unit) : void
            {
                  var _loc3_:MovieClip = null;
                  var _loc4_:Point = null;
                  var _loc5_:int = 0;
                  if(this.bowFrame == 21)
                  {
                        _state = S_ATTACK;
                        this.bowFrame += 1;
                        _loc3_ = _mc.mc.arms;
                        _loc3_.nextFrame();
                        this.target = param2;
                        hasHit = false;
                        this.lastShotFrame = param1.frame;
                        _loc4_ = mc.mc.localToGlobal(new Point(0,0));
                        _loc4_ = param1.battlefield.globalToLocal(_loc4_);
                        _loc5_ = projectileVelocity;
                        if(mc.scaleX < 0)
                        {
                              param1.projectileManager.initFireBallProjectile(_loc4_.x,_loc4_.y,180 - bowAngle,_loc5_,param2.y,angleToTargetW(param2,_loc5_,angleToTarget(param2)),0,this,param2,this.burnDamage,this.burnFrames);
                        }
                        else
                        {
                              param1.projectileManager.initFireBallProjectile(_loc4_.x,_loc4_.y,bowAngle,_loc5_,param2.y,angleToTargetW(param2,_loc5_,angleToTarget(param2)),0,this,param2,this.burnDamage,this.burnFrames);
                        }
                  }
            }
            
            override public function aim(param1:Unit) : void
            {
                  var _loc2_:Number = angleToTarget(param1);
                  if(Math.abs(normalise(angleToBowSpace(_loc2_) - bowAngle)) < 10)
                  {
                        bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 0.99;
                  }
                  else
                  {
                        bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 0.99;
                  }
            }
            
            override public function mayAttack(param1:Unit) : Boolean
            {
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
                  if(aimedAtUnit(param1,angleToTarget(param1)) && this.inRange(param1))
                  {
                        return true;
                  }
                  return false;
            }
      }
}
