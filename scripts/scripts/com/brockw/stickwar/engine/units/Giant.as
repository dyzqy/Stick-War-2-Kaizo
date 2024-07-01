package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.GiantAi;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.market.MarketItem;
      import flash.display.MovieClip;
      
      public class Giant extends Unit
      {
            
            private static var WEAPON_REACH:int;
             
            
            private var scaleI:Number;
            
            private var scaleII:Number;
            
            private var maxTargetsToHit:int;
            
            private var targetsHit:int;
            
            private var stunTime:int;
            
            private var hasGrowled:Boolean;
            
            public function Giant(param1:StickWar)
            {
                  super(param1);
                  _mc = new _giant();
                  this.init(param1);
                  addChild(_mc);
                  ai = new GiantAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_giant = null;
                  if((_loc5_ = _giant(param1)).mc.giantclub)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.giantclub.gotoAndStop(param2);
                        }
                  }
            }
            
            override public function weaponReach() : Number
            {
                  return WEAPON_REACH;
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  WEAPON_REACH = param1.xml.xml.Chaos.Units.giant.weaponReach;
                  this.hasGrowled = false;
                  population = param1.xml.xml.Chaos.Units.giant.population;
                  _mass = param1.xml.xml.Chaos.Units.giant.mass;
                  _maxForce = param1.xml.xml.Chaos.Units.giant.maxForce;
                  _dragForce = param1.xml.xml.Chaos.Units.giant.dragForce;
                  _scale = param1.xml.xml.Chaos.Units.giant.scale;
                  _maxVelocity = param1.xml.xml.Chaos.Units.giant.maxVelocity;
                  damageToDeal = param1.xml.xml.Chaos.Units.giant.baseDamage;
                  this.createTime = param1.xml.xml.Chaos.Units.giant.cooldown;
                  maxHealth = health = param1.xml.xml.Chaos.Units.giant.health;
                  this.maxTargetsToHit = param1.xml.xml.Chaos.Units.giant.maxTargetsToHit;
                  this.stunTime = param1.xml.xml.Chaos.Units.giant.stunTime;
                  this.scaleI = param1.xml.xml.Chaos.Units.giant.growthIScale;
                  this.scaleII = param1.xml.xml.Chaos.Units.giant.growthIIScale;
                  loadDamage(param1.xml.xml.Chaos.Units.giant);
                  type = Unit.U_GIANT;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.healthBar.y = -mc.mc.height * 1.1;
                  healthBar.totalHealth = maxHealth;
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["GiantBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            private function giantHit(param1:Unit) : *
            {
                  if(this.targetsHit < this.maxTargetsToHit && param1.team != this.team)
                  {
                        if(param1.px * mc.scaleX > px * mc.scaleX)
                        {
                              if(param1 is Wall || param1 is Statue)
                              {
                                    ++this.targetsHit;
                                    this.TakeStructureDmg(param1);
                                    param1.dx = 10 * Util.sgn(mc.scaleX);
                              }
                              else if(Math.pow(param1.px + param1.dx - dx - px,2) + Math.pow(param1.py + param1.dy - dy - py,2) < Math.pow(5 * param1.hitBoxWidth * (this.perspectiveScale + param1.perspectiveScale) / 2,2))
                              {
                                    ++this.targetsHit;
                                    param1.damage(0,this.damageToDeal,this);
                                    param1.stun(this.stunTime);
                                    param1.applyVelocity(7 * Util.sgn(mc.scaleX));
                              }
                        }
                  }
            }
            
            override public function applyVelocity(param1:Number, param2:Number = 0, param3:Number = 0) : void
            {
            }
            
            override public function freeze(param1:int) : void
            {
            }
            
            override public function aquireFreezeLock(param1:Unit) : Boolean
            {
                  return false;
            }
            
            override public function update(param1:StickWar) : void
            {
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
                  if(team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_II))
                  {
                        if(_scale != this.scaleII)
                        {
                              health = param1.xml.xml.Chaos.Units.giant.healthII - (maxHealth - health);
                              maxHealth = param1.xml.xml.Chaos.Units.giant.healthII;
                              healthBar.totalHealth = maxHealth;
                        }
                        _scale = this.scaleII;
                  }
                  else if(team.tech.isResearched(Tech.CHAOS_GIANT_GROWTH_I))
                  {
                        if(_scale != this.scaleI)
                        {
                              health = param1.xml.xml.Chaos.Units.giant.healthI - (maxHealth - health);
                              maxHealth = param1.xml.xml.Chaos.Units.giant.healthI;
                              healthBar.totalHealth = maxHealth;
                        }
                        _scale = this.scaleI;
                  }
                  updateCommon(param1);
                  if(mc.mc.sword != null)
                  {
                        mc.mc.sword.gotoAndStop(team.loadout.getItem(this.type,MarketItem.T_WEAPON));
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
                              if(this.targetsHit < this.maxTargetsToHit && mc.mc.currentFrameLabel == "hit")
                              {
                                    team.game.spatialHash.mapInArea(px - 200,py - 50,px + 200,py + 50,this.giantHit);
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
                        team.game.soundManager.playSoundRandom("GiantDeath",3,px,py);
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
                  MovieClip(_mc.mc).nextFrame();
                  _mc.mc.stop();
                  if(!hasDefaultLoadout)
                  {
                        Giant.setItem(_giant(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
                  }
            }
            
            override public function canAttackAir() : Boolean
            {
                  return true;
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
            
            override public function faceDirection(param1:int) : void
            {
                  if(_state != S_ATTACK)
                  {
                        super.faceDirection(param1);
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
                        this.targetsHit = 0;
                        framesInAttack = MovieClip(_mc.mc).totalFrames;
                        attackStartFrame = team.game.frame;
                  }
            }
            
            public function TakeStructureDmg(param1:Unit) : void
            {
                  var i:* = 0;
                  while(i < 5)
                  {
                        param1.damage(0,this.damageToDeal,this);
                        i++;
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
