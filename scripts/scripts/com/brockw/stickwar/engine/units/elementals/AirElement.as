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
      
      public class AirElement extends RangedUnit
      {
             
            
            public var isCastleArcher:Boolean;
            
            private var target:Unit;
            
            private var airDamage:Number;
            
            private var lastShotFrame:int;
            
            private var attackFrames:int;
            
            private var castleRange:Number;
            
            private var legFrame:int;
            
            public var burnFrames:int;
            
            public var burnDamage:Number;
            
            public var burnRadius:Number;
            
            public function AirElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _airElemental();
                  this.init(param1);
                  addChild(_mc);
                  ai = new AirElementAi(this);
                  initSync();
                  firstInit();
                  this.isCastleArcher = false;
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_airElemental;
                  if(Boolean((_loc5_ = _airElemental(param1)).mc.head) && Boolean(_loc5_.mc.head.head) && Boolean(_loc5_.mc.head.head.hat))
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.head.hat.gotoAndStop(param3);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.attackFrames = 0;
                  this.lastShotFrame = 0;
                  population = param1.xml.xml.Elemental.Units.airElement.population;
                  this.airDamage = param1.xml.xml.Elemental.Units.airElement.fireDamage;
                  _mass = param1.xml.xml.Elemental.Units.airElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.airElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.airElement.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.airElement.scale;
                  _maxVelocity = param1.xml.xml.Elemental.Units.airElement.maxVelocity;
                  this.createTime = param1.xml.xml.Elemental.Units.airElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.airElement.health;
                  loadDamage(param1.xml.xml.Elemental.Units.airElement);
                  this._maximumRange = param1.xml.xml.Elemental.Units.airElement.maximumRange;
                  this.burnRadius = 0;
                  this.burnFrames = 0;
                  this.burnDamage = 0;
                  this.projectileVelocity = param1.xml.xml.Elemental.Units.airElement.arrowVelocity;
                  this.legFrame = 1;
                  type = Unit.U_AIR_ELEMENT;
                  flyingHeight = 250;
                  combineColour = 52326;
                  if(this.isCastleArcher)
                  {
                        this._maximumRange = param1.xml.xml.Order.Units.archer.castleRange;
                        _scale *= 1.4;
                        this._damageToArmour = param1.xml.xml.Elemental.Units.airElement.castleDamage;
                        this._damageToNotArmour = param1.xml.xml.Elemental.Units.airElement.castleDamage;
                        this.burnRadius = param1.xml.xml.Elemental.Units.airElement.castleArea;
                        this.burnFrames = param1.xml.xml.Elemental.Units.airElement.castleBurnFrames;
                        this.burnDamage = param1.xml.xml.Elemental.Units.airElement.castleBurnDamage;
                  }
                  pz = -flyingHeight * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  y = -100;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  if(this.isCastleArcher)
                  {
                        this.healthBar.visible = false;
                  }
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["AirBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            override public function checkForHitPointArrow(param1:Point, param2:Number, param3:Unit) : Boolean
            {
                  if(param3 == null)
                  {
                        return false;
                  }
                  param1 = this.globalToLocal(param1);
                  if(this == param3)
                  {
                        if(param1.x > -2 * pwidth && param1.x < 2 * pwidth && param1.y > -pheight && param1.y < pheight && Math.abs(param2 - this.py) < 300)
                        {
                              return true;
                        }
                  }
                  else if(param1.x > -pwidth && param1.x < pwidth && param1.y > -pheight * 0.8 && param1.y < 0 && Math.abs(param2 - this.py) < 200 * 0.8)
                  {
                        return true;
                  }
                  return false;
            }
            
            override public function update(param1:StickWar) : void
            {
                  updateCommon(param1);
                  updateElementalCombine();
                  if(!isDieing)
                  {
                        if(_mc.mc.legs != null)
                        {
                              _mc.mc.legs.rotation = getDirection() * _dx / _maxVelocity * param1.xml.xml.Elemental.Units.airElement.legRotateAngleWhenFlying;
                              _mc.mc.legs.gotoAndStop(this.legFrame);
                              ++this.legFrame;
                              if(this.legFrame > MovieClip(_mc.mc.legs).totalFrames)
                              {
                                    this.legFrame = 1;
                              }
                        }
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
                        else if(_state == S_RUN)
                        {
                              _mc.gotoAndStop("run");
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(MovieClip(mc.mc).currentFrameLabel == "hit")
                              {
                                    param1.projectileManager.initLightning(this,this.target,this);
                              }
                              if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                              {
                                    _state = S_RUN;
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
                  Util.animateMovieClip(_mc.mc);
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
                  AirElement.setItem(mc,"",team.loadout.getItem(this.type,MarketItem.T_ARMOR),"");
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
            
            override public function isLoaded() : Boolean
            {
                  return true;
            }
            
            override public function shoot(param1:StickWar, param2:Unit) : void
            {
                  var _loc3_:Point = null;
                  var _loc4_:int = 0;
                  var _loc5_:int = 0;
                  if(param1.frame - this.lastShotFrame > this.attackFrames)
                  {
                        _state = S_ATTACK;
                        mc.gotoAndStop("attack");
                        mc.mc.gotoAndStop(1);
                        this.attackFrames = MovieClip(mc.mc).totalFrames - 1;
                        this.target = param2;
                        hasHit = false;
                        this.lastShotFrame = param1.frame;
                        _loc3_ = mc.mc.localToGlobal(new Point(0,0));
                        _loc3_ = param1.battlefield.globalToLocal(_loc3_);
                        _loc4_ = projectileVelocity;
                        _loc5_ = int(this.airDamage);
                  }
            }
            
            override public function aim(param1:Unit) : void
            {
                  var _loc2_:Number = angleToTarget(param1);
                  if(Math.abs(normalise(angleToBowSpace(_loc2_) - bowAngle)) < 10)
                  {
                        bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 0.8;
                  }
                  else
                  {
                        bowAngle += normalise(angleToBowSpace(_loc2_) - bowAngle) * 0.1;
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
            
            override public function inRange(param1:Unit) : Boolean
            {
                  if(param1 == null)
                  {
                        return false;
                  }
                  if(Math.abs(param1.px - px) < this._maximumRange)
                  {
                        return true;
                  }
                  return false;
            }
      }
}
