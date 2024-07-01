package com.brockw.stickwar.engine.units.elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      import flash.geom.*;
      
      public class ScorpionElement extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var shieldwallDamageReduction:Number;
            
            private var stunned:Unit;
            
            private var isInJump:Boolean;
            
            private var zVel:Number = 0;
            
            private var spawnFrame:int;
            
            public var parentTree:Unit = null;
            
            private var poisonDamageToInflict:Number;
            
            private var killAfterJump:Boolean = true;
            
            public function ScorpionElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _scorpion();
                  this.init(param1);
                  addChild(_mc);
                  ai = new ScorpionElementAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_scorpion;
                  if((_loc5_ = _scorpion(param1)).mc.sting)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.sting.gotoAndStop(param2);
                        }
                  }
                  if(Boolean(_loc5_.mc.body) && Boolean(_loc5_.mc.body.dress))
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.body.dress.gotoAndStop(param3);
                        }
                  }
                  else if(_loc5_.mc.dress)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.dress.gotoAndStop(param3);
                        }
                  }
            }
            
            public function terminate() : void
            {
                  this.killAfterJump = true;
            }
            
            override public function playDeathSound() : void
            {
                  team.game.soundManager.playSoundRandom("CrawlerDeath",3,px,py);
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.spawnFrame = 0;
                  WEAPON_REACH = param1.xml.xml.Elemental.Units.scorpionElement.weaponReach;
                  this.poisonDamageToInflict = param1.xml.xml.Elemental.Units.scorpionElement.poisonDamage;
                  population = param1.xml.xml.Elemental.Units.scorpionElement.population;
                  _mass = param1.xml.xml.Elemental.Units.scorpionElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.scorpionElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.scorpionElement.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.scorpionElement.scale;
                  _maxVelocity = param1.xml.xml.Elemental.Units.scorpionElement.maxVelocity;
                  damageToDeal = param1.xml.xml.Elemental.Units.scorpionElement.baseDamage;
                  this.createTime = param1.xml.xml.Elemental.Units.scorpionElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.scorpionElement.health;
                  type = Unit.U_SCORPION_ELEMENT;
                  loadDamage(param1.xml.xml.Elemental.Units.scorpionElement);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  this.killAfterJump = false;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.isInJump = true;
                  pz = flyingHeight = 50;
                  this.zVel = 8;
                  this.shadowSprite.alpha = 0.2;
                  this.healthBar.scaleX = 0.8;
                  this.healthBar.scaleY = 0.8;
                  healthBar.y = -60;
            }
            
            public function makeLevel2() : void
            {
                  maxHealth = health = team.game.xml.xml.Elemental.Units.scorpionElement.level2Health;
                  this.healthBar.totalHealth = maxHealth;
                  healthBar.reset();
                  _scale = team.game.xml.xml.Elemental.Units.scorpionElement.level2Scale;
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
            
            override public function isTargetable() : Boolean
            {
                  return !isDead && !isDieing && px * team.direction > team.homeX * team.direction && !this.isInJump;
            }
            
            override public function stun(param1:int, param2:Number = 1) : void
            {
                  if(!this.isInJump)
                  {
                        super.stun(param1,param2);
                  }
            }
            
            override public function freeze(param1:int) : void
            {
                  if(!this.isInJump)
                  {
                        super.freeze(param1);
                  }
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:ColorTransform = null;
                  var _loc3_:int = 0;
                  var _loc4_:Number = NaN;
                  if(this.isInJump == true)
                  {
                        ++this.spawnFrame;
                        _loc2_ = mc.transform.colorTransform;
                        _loc3_ = param1.random.nextInt();
                        _loc4_ = Math.min(1,Math.max(0,(5 - this.spawnFrame) / 5));
                        _loc2_.redMultiplier = 1 - _loc4_;
                        _loc2_.blueMultiplier = 1 - _loc4_;
                        _loc2_.greenMultiplier = 1 - _loc4_;
                        _loc2_.redOffset = -255 * _loc4_;
                        _loc2_.blueOffset = -255 * _loc4_;
                        _loc2_.greenOffset = -255 * _loc4_;
                        mc.transform.colorTransform = _loc2_;
                        this.zVel -= StickWar.GRAVITY * 1.5;
                        this.flyingHeight += this.zVel;
                        pz = flyingHeight;
                        if(pz < 0)
                        {
                              pz = 0;
                              this.isInJump = false;
                              if(this.killAfterJump)
                              {
                                    this.damage(0,1000,null);
                              }
                              flyingHeight = 0;
                        }
                  }
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
                                    px += Util.sgn(mc.scaleX) * team.game.getPerspectiveScale(py) * _currentDual.finalXOffset;
                                    x = px;
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
                  ScorpionElement.setItem(_scorpion(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
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
                        if(techTeam.tech.isResearched(Tech.TREE_POISON_2))
                        {
                              _loc1_.poison(this.poisonDamageToInflict);
                        }
                        return true;
                  }
                  return false;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
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
