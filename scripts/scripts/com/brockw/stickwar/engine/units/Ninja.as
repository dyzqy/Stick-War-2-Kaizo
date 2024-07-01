package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.NinjaAi;
      import com.brockw.stickwar.engine.Ai.command.UnitCommand;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Tech;
      import flash.display.MovieClip;
      import flash.filters.DropShadowFilter;
      import flash.geom.Point;
      
      public class Ninja extends Unit
      {
            
            private static var WEAPON_REACH:int;
             
            
            private var _stealthSpellTimer:SpellCooldown;
            
            private var stealthSpellGlow:DropShadowFilter;
            
            private var isDash:Boolean;
            
            private var ninjaCopyDistance:Number;
            
            private var dontStealth:Boolean;
            
            private var ninjaStealthVelocity:Number;
            
            private var normalVelocity:Number;
            
            private var currentStacks:int;
            
            private var maxStacks:int;
            
            private var currentTarget:Unit;
            
            private var stackDamage:int;
            
            private var furyEffect:int;
            
            private var lastHitFrame:int;
            
            public function Ninja(param1:StickWar)
            {
                  super(param1);
                  _mc = new _ninja();
                  this.init(param1);
                  addChild(_mc);
                  ai = new NinjaAi(this);
                  initSync();
                  firstInit();
                  this.dontStealth = true;
                  this.ninjaCopyDistance = 1;
            }
            
            public static function setItemForMc(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  if(param1.ninjahead)
                  {
                        if(param3 != "")
                        {
                              param1.ninjahead.gotoAndStop(param3);
                        }
                  }
                  if(param1.ninjastaff)
                  {
                        if(param2 != "")
                        {
                              param1.ninjastaff.gotoAndStop(param2);
                        }
                  }
                  if(param1.ninjasword)
                  {
                        if(param4 != "")
                        {
                              param1.ninjasword.gotoAndStop(param4);
                        }
                  }
                  if(param1.weaponGroup)
                  {
                        if(param1.weaponGroup.ninjastaff)
                        {
                              if(param2 != "")
                              {
                                    param1.weaponGroup.ninjastaff.gotoAndStop(param2);
                              }
                        }
                        if(param1.weaponGroup.ninjasword)
                        {
                              if(param4 != "")
                              {
                                    param1.weaponGroup.ninjasword.gotoAndStop(param4);
                              }
                        }
                  }
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_ninja = _ninja(param1);
                  setItemForMc(_loc5_.mc,param2,param3,param4);
                  if(_loc5_.shadow1)
                  {
                        setItemForMc(_loc5_.shadow1,param2,param3,param4);
                  }
                  if(_loc5_.shadow2)
                  {
                        setItemForMc(_loc5_.shadow2,param2,param3,param4);
                  }
            }
            
            override public function weaponReach() : Number
            {
                  return WEAPON_REACH;
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this._stealthSpellTimer = new SpellCooldown(param1.xml.xml.Order.Units.ninja.stealth.effect,param1.xml.xml.Order.Units.ninja.stealth.cooldown,param1.xml.xml.Order.Units.ninja.stealthMana);
                  WEAPON_REACH = param1.xml.xml.Order.Units.ninja.weaponReach;
                  population = param1.xml.xml.Order.Units.ninja.population;
                  _mass = param1.xml.xml.Order.Units.ninja.mass;
                  _maxForce = param1.xml.xml.Order.Units.ninja.maxForce;
                  _dragForce = param1.xml.xml.Order.Units.ninja.dragForce;
                  _scale = param1.xml.xml.Order.Units.ninja.scale;
                  _maxVelocity = this.normalVelocity = param1.xml.xml.Order.Units.ninja.maxVelocity;
                  this.createTime = param1.xml.xml.Order.Units.ninja.cooldown;
                  this.ninjaCopyDistance = param1.xml.xml.Order.Units.ninja.ninjaCopyDistance;
                  loadDamage(param1.xml.xml.Order.Units.ninja);
                  maxHealth = health = param1.xml.xml.Order.Units.ninja.health;
                  this.maxStacks = param1.xml.xml.Order.Units.ninja.fury.stacks;
                  this.stackDamage = param1.xml.xml.Order.Units.ninja.fury.bonus;
                  this.furyEffect = param1.xml.xml.Order.Units.ninja.fury.furyEffect;
                  this.currentStacks = 0;
                  this.currentTarget = null;
                  this.lastHitFrame = 0;
                  this.ninjaStealthVelocity = param1.xml.xml.Order.Units.ninja.stealth.maxVelocity;
                  this.stealthSpellGlow = new DropShadowFilter();
                  this.stealthSpellGlow.knockout = true;
                  this.stealthSpellGlow.angle = 0;
                  this.stealthSpellGlow.distance = 0;
                  this.stealthSpellGlow.color = 0;
                  type = Unit.U_NINJA;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.isDash = true;
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["BarracksBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            public function stealthCooldown() : Number
            {
                  return this._stealthSpellTimer.cooldown();
            }
            
            public function stealth() : void
            {
                  if(this._stealthSpellTimer.spellActivate(team))
                  {
                        this.dontStealth = false;
                        team.game.soundManager.playSound("ninjaCloakSound",px,py);
                  }
            }
            
            override protected function checkForHit() : Boolean
            {
                  var _loc4_:Number = NaN;
                  var _loc1_:Unit = ai.getClosestTarget();
                  if(_loc1_ == null)
                  {
                        return false;
                  }
                  var _loc2_:int = Util.sgn(_loc1_.px - px);
                  if(_mc.mc.tip == null)
                  {
                        return false;
                  }
                  var _loc3_:Point = MovieClip(_mc.mc.tip).localToGlobal(new Point(0,0));
                  if(_loc1_.checkForHitPoint(_loc3_,_loc1_))
                  {
                        if(this.currentTarget != _loc1_ || team.game.frame - this.lastHitFrame > this.furyEffect)
                        {
                              this.currentStacks = 0;
                        }
                        if(this.currentStacks > this.maxStacks)
                        {
                              this.currentStacks = this.maxStacks;
                        }
                        if(_loc1_ is Statue)
                        {
                              _loc1_.damage(0,this.stackDamage * this.currentStacks + _damageToArmour,null);
                        }
                        else if(_loc1_.isArmoured)
                        {
                              _loc1_.damage(0,this.stackDamage * this.currentStacks + this.damageToArmour,null);
                        }
                        else
                        {
                              _loc1_.damage(0,this.stackDamage * this.currentStacks + this.damageToNotArmour,null);
                        }
                        _loc4_ = 0;
                        if(techTeam.tech.isResearched(Tech.CLOAK_II))
                        {
                              _loc4_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.poison2);
                        }
                        else
                        {
                              _loc4_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.poison);
                        }
                        if(!this.dontStealth)
                        {
                              _loc1_.poison(_loc4_);
                        }
                        ++this.currentStacks;
                        this.lastHitFrame = team.game.frame;
                        this.currentTarget = _loc1_;
                        return true;
                  }
                  return false;
            }
            
            override public function update(param1:StickWar) : void
            {
                  this._stealthSpellTimer.update();
                  updateCommon(param1);
                  if(team.isEnemy && !enemyBuffed)
                  {
                        _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                        _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                        health = Number(param1.xml.xml.Order.Units.ninja.health) / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
                        maxHealth = health;
                        maxHealth = maxHealth;
                        healthBar.totalHealth = maxHealth;
                        _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
                        enemyBuffed = true;
                  }
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
                        else if(this.isDash && _state == S_RUN)
                        {
                              if(Math.abs(_dx) + Math.abs(_dy) > 1)
                              {
                                    if(!this.dontStealth)
                                    {
                                          _mc.gotoAndStop("stealth");
                                          this._maxVelocity = this.ninjaStealthVelocity;
                                    }
                                    else
                                    {
                                          _mc.gotoAndStop("run");
                                          if(_mc.shadow1 && _mc.shadow2)
                                          {
                                                _mc.shadow1.x = _mc.mc.x - Math.abs(dx) * 10 * this.ninjaCopyDistance;
                                                _mc.shadow2.x = _mc.mc.x - Math.abs(dx) * 20 * this.ninjaCopyDistance;
                                                _mc.shadow1.y = _mc.mc.y - dy * 5 * this.ninjaCopyDistance;
                                                _mc.shadow2.y = _mc.mc.y - dy * 10 * this.ninjaCopyDistance;
                                          }
                                          this._maxVelocity = this.normalVelocity;
                                    }
                              }
                              else
                              {
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(_state == S_RUN)
                        {
                              if(Math.abs(_dx) + Math.abs(_dy) > 0.1)
                              {
                                    if(this._stealthSpellTimer.inEffect())
                                    {
                                          _mc.gotoAndStop("stealth");
                                          this._maxVelocity = this.ninjaStealthVelocity;
                                    }
                                    else
                                    {
                                          _mc.gotoAndStop("run");
                                          this._maxVelocity = this.normalVelocity;
                                    }
                              }
                              else
                              {
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(mc.mc.swing != null)
                              {
                                    team.game.soundManager.playSoundRandom("ninjaSwipe",4,px,py);
                              }
                              if(!hasHit)
                              {
                                    hasHit = this.checkForHit();
                                    if(hasHit)
                                    {
                                          this.dontStealth = true;
                                          param1.soundManager.playSound("sword1",px,py);
                                    }
                              }
                              if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                              {
                                    _state = S_RUN;
                                    this.dontStealth = true;
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
                              _mc.gotoAndStop(getDeathLabel(param1));
                              this.team.removeUnit(this,param1);
                              isDead = true;
                        }
                  }
                  if(!(isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames))
                  {
                        Util.animateMovieClip(_mc);
                  }
                  if(!this._stealthSpellTimer.inEffect())
                  {
                        this.dontStealth = true;
                  }
                  if(!this.dontStealth)
                  {
                        mc.filters = [this.stealthSpellGlow];
                        mc.mc.alpha = 1;
                  }
                  else
                  {
                        mc.filters = [];
                        mc.mc.alpha = 1;
                  }
                  if(team.isEnemy)
                  {
                        Ninja.setItem(_ninja(mc),"Spike Staff","Tribal Ninja","Katana");
                  }
                  else if(!techTeam.tech.isResearched(Tech.CLOAK_II))
                  {
                        Ninja.setItem(_ninja(mc),"Default","Default","Default");
                  }
                  else
                  {
                        Ninja.setItem(_ninja(mc),"Double Edged Spear","Tribal Ninja","Ninja Claws");
                  }
            }
            
            override public function isTargetable() : Boolean
            {
                  return !isDead && !isDieing && !this._isDualing && this.dontStealth;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  param1.setAction(2,0,UnitCommand.NINJA_STACK);
                  param1.setAction(0,0,UnitCommand.STEALTH);
            }
            
            override public function get damageToArmour() : Number
            {
                  var _loc1_:Number = NaN;
                  if(!this.dontStealth)
                  {
                        _loc1_ = 0;
                        if(techTeam.tech.isResearched(Tech.CLOAK_II))
                        {
                              _loc1_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.damageToArmour2);
                        }
                        else
                        {
                              _loc1_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.damageToArmour);
                        }
                        return _damageToArmour + int(_loc1_);
                  }
                  return _damageToArmour;
            }
            
            override public function get damageToNotArmour() : Number
            {
                  var _loc1_:Number = NaN;
                  if(!this.dontStealth)
                  {
                        _loc1_ = 0;
                        if(techTeam.tech.isResearched(Tech.CLOAK_II))
                        {
                              _loc1_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.damageToNotArmour2);
                        }
                        else
                        {
                              _loc1_ = Number(team.game.xml.xml.Order.Units.ninja.stealth.damageToNotArmour);
                        }
                        return _damageToNotArmour + int(_loc1_);
                  }
                  return _damageToNotArmour;
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
