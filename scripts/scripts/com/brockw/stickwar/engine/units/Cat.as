package com.brockw.stickwar.engine.units
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      import flash.geom.*;
      
      public class Cat extends Unit
      {
            
            private static var WEAPON_REACH:int;
             
            
            private var hitsOnTarget:int;
            
            private var lastHitFrame:Number;
            
            private var packStacks:int;
            
            private var packDamagePerUnit:int;
            
            private var target:Unit;
            
            private var normalMaxVelocity:Number;
            
            private var upgradedMaxVelocity:Number;
            
            public function Cat(param1:StickWar)
            {
                  super(param1);
                  _mc = new _cat();
                  this.init(param1);
                  addChild(_mc);
                  ai = new CatAi(this);
                  initSync();
                  firstInit();
                  this.target = null;
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_cat = null;
                  if((_loc5_ = _cat(param1)).mc.crawlerHead)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.crawlerHead.gotoAndStop(param2);
                        }
                  }
            }
            
            override public function weaponReach() : Number
            {
                  return WEAPON_REACH;
            }
            
            override public function playDeathSound() : void
            {
                  team.game.soundManager.playSoundRandom("CrawlerDeath",3,px,py);
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  WEAPON_REACH = param1.xml.xml.Chaos.Units.cat.weaponReach;
                  population = param1.xml.xml.Chaos.Units.cat.population;
                  _mass = param1.xml.xml.Chaos.Units.cat.mass;
                  _maxForce = param1.xml.xml.Chaos.Units.cat.maxForce;
                  _dragForce = param1.xml.xml.Chaos.Units.cat.dragForce;
                  _scale = param1.xml.xml.Chaos.Units.cat.scale;
                  _maxVelocity = this.normalMaxVelocity = param1.xml.xml.Chaos.Units.cat.slowMaxVelocity;
                  this.upgradedMaxVelocity = param1.xml.xml.Chaos.Units.cat.maxVelocity;
                  damageToDeal = param1.xml.xml.Chaos.Units.cat.baseDamage;
                  this.createTime = param1.xml.xml.Chaos.Units.cat.cooldown;
                  maxHealth = health = param1.xml.xml.Chaos.Units.cat.health;
                  loadDamage(param1.xml.xml.Chaos.Units.cat);
                  this.packStacks = param1.xml.xml.Chaos.Units.cat.pack.stacks;
                  this.packDamagePerUnit = param1.xml.xml.Chaos.Units.cat.pack.damagePerUnit;
                  type = Unit.U_CAT;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  pheight = 150;
            }
            
            override protected function checkForHit() : Boolean
            {
                  var _loc4_:* = undefined;
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
                        _loc4_ = Math.min(team.numberOfCats,this.packStacks);
                        if(!techTeam.tech.isResearched(Tech.CAT_PACK))
                        {
                              _loc4_ = 0;
                        }
                        _loc1_.damage(0,_loc4_ * this.packDamagePerUnit + this._damageToArmour,null);
                        ++this.hitsOnTarget;
                        this.lastHitFrame = team.game.frame;
                        this.target = _loc1_;
                        return true;
                  }
                  return false;
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
                  updateCommon(param1);
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
                  if(!techTeam.tech.isResearched(Tech.CAT_SPEED))
                  {
                        _maxVelocity = this.normalMaxVelocity;
                  }
                  else
                  {
                        _maxVelocity = this.upgradedMaxVelocity;
                  }
                  if(mc.mc.sword != null)
                  {
                        mc.mc.sword.gotoAndStop(team.loadout.getItem(this.type,MarketItem.T_WEAPON));
                  }
                  if(!isDieing)
                  {
                        if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.attackLabel);
                              _dualPartner.px += (this.px + _currentDual.xDiff * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale * -Util.sgn(this.px - _dualPartner.px) - _dualPartner.px) * 0.1;
                              _dualPartner.py += (py - _dualPartner.py) * 0.2;
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
                              if(!hasHit)
                              {
                                    hasHit = this.checkForHit();
                                    if(hasHit)
                                    {
                                          param1.soundManager.playSound("sword1",px,py);
                                    }
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
                              _mc.gotoAndStop(getDeathLabel(param1));
                              this.team.removeUnit(this,param1);
                              isDead = true;
                        }
                  }
                  if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                  {
                        MovieClip(_mc.mc).gotoAndStop(1);
                  }
                  Util.animateMovieClip(_mc);
                  if(!hasDefaultLoadout)
                  {
                        Cat.setItem(_cat(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
                  }
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
                  if(techTeam.tech.isResearched(Tech.CAT_PACK))
                  {
                        param1.setAction(0,0,UnitCommand.CAT_PACK);
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
