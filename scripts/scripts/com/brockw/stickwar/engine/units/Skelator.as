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
      
      public class Skelator extends Unit
      {
             
            
            private var WEAPON_REACH:Number;
            
            private var fistAttackSpell:SpellCooldown;
            
            private var reaperSpell:SpellCooldown;
            
            private var isFistAttacking:Boolean;
            
            private var isReaperSpell:Boolean;
            
            private var spellX:Number;
            
            private var spellY:Number;
            
            private var target:Unit;
            
            private var _fistDamage:Number;
            
            public function Skelator(param1:StickWar)
            {
                  super(param1);
                  _mc = new _skelator();
                  this.init(param1);
                  addChild(_mc);
                  ai = new SkelatorAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_skelator = null;
                  if((_loc5_ = _skelator(param1)).mc.skullhead)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.skullhead.gotoAndStop(param3);
                        }
                  }
                  if(_loc5_.mc.skullstaff)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.skullstaff.gotoAndStop(param2);
                        }
                  }
            }
            
            override public function weaponReach() : Number
            {
                  return this.WEAPON_REACH;
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.WEAPON_REACH = param1.xml.xml.Chaos.Units.skelator.weaponReach;
                  population = param1.xml.xml.Chaos.Units.skelator.population;
                  _mass = param1.xml.xml.Chaos.Units.skelator.mass;
                  _maxForce = param1.xml.xml.Chaos.Units.skelator.maxForce;
                  _dragForce = param1.xml.xml.Chaos.Units.skelator.dragForce;
                  _scale = param1.xml.xml.Chaos.Units.skelator.scale;
                  _maxVelocity = param1.xml.xml.Chaos.Units.skelator.maxVelocity;
                  damageToDeal = param1.xml.xml.Chaos.Units.skelator.baseDamage;
                  this.createTime = param1.xml.xml.Chaos.Units.skelator.cooldown;
                  maxHealth = health = param1.xml.xml.Chaos.Units.skelator.health;
                  this.fistDamage = param1.xml.xml.Chaos.Units.skelator.fist.damage;
                  loadDamage(param1.xml.xml.Chaos.Units.skelator);
                  type = Unit.U_SKELATOR;
                  this.isFistAttacking = false;
                  this.isReaperSpell = false;
                  this.spellX = this.spellY = 0;
                  this.fistAttackSpell = new SpellCooldown(param1.xml.xml.Chaos.Units.skelator.fist.effect,param1.xml.xml.Chaos.Units.skelator.fist.cooldown,param1.xml.xml.Chaos.Units.skelator.fist.mana);
                  this.reaperSpell = new SpellCooldown(param1.xml.xml.Chaos.Units.skelator.reaper.effect,param1.xml.xml.Chaos.Units.skelator.reaper.cooldown,param1.xml.xml.Chaos.Units.skelator.reaper.mana);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.healthBar.y = -mc.mc.height * 1.1;
                  this.target = null;
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["UndeadBuilding"];
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  this.fistAttackSpell.update();
                  this.reaperSpell.update();
                  updateCommon(param1);
                  if(team.isEnemy && !enemyBuffed)
                  {
                        _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                        _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                        this._fistDamage = this._fistDamage / 2 * team.game.main.campaign.difficultyLevel + 1;
                        health = health / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
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
                        else if(this.isFistAttacking)
                        {
                              _mc.gotoAndStop("fistAttack");
                              _loc2_ = (_mc.mc.currentFrame - 27) / 5;
                              if(_mc.mc.currentFrame >= 27 && (_mc.mc.currentFrame - 27) % 5 == 0 && _loc2_ < 6)
                              {
                                    param1.projectileManager.initFistAttack(this.spellX,this.spellY,this,_loc2_);
                              }
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    _state = S_RUN;
                                    this.isFistAttacking = false;
                              }
                        }
                        else if(this.isReaperSpell)
                        {
                              _mc.gotoAndStop("reaperAttack");
                              if(_mc.mc.currentFrame == 42)
                              {
                                    param1.projectileManager.initReaper(this,this.target);
                              }
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    _state = S_RUN;
                                    this.isReaperSpell = false;
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
                  Util.animateMovieClip(mc);
                  if(!hasDefaultLoadout)
                  {
                        Skelator.setItem(_skelator(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
                  }
            }
            
            override public function stateFixForCutToWalk() : void
            {
                  if(!this.isFistAttacking && !this.isReaperSpell)
                  {
                        super.stateFixForCutToWalk();
                        this.isFistAttacking = false;
                        this.isReaperSpell = false;
                  }
            }
            
            public function fistAttackCooldown() : Number
            {
                  return this.fistAttackSpell.cooldown();
            }
            
            public function reaperCooldown() : Number
            {
                  return this.reaperSpell.cooldown();
            }
            
            override public function isBusy() : Boolean
            {
                  return !this.notInSpell() || isBusyForSpell;
            }
            
            private function notInSpell() : Boolean
            {
                  return !this.isFistAttacking && !this.isReaperSpell;
            }
            
            public function fistAttack(param1:Number, param2:Number) : void
            {
                  if(!techTeam.tech.isResearched(Tech.SKELETON_FIST_ATTACK))
                  {
                        return;
                  }
                  if(this.notInSpell() && this.fistAttackSpell.spellActivate(this.team))
                  {
                        this.spellX = param1;
                        this.spellY = param2;
                        forceFaceDirection(this.spellX - this.px);
                        this.isFistAttacking = true;
                        hasHit = false;
                        _state = S_ATTACK;
                        team.game.soundManager.playSound("skeltalFistsSound",px,py);
                  }
            }
            
            public function reaperAttack(param1:Unit) : void
            {
                  if(param1 != null && param1.isAlive())
                  {
                        if(this.notInSpell() && this.reaperSpell.spellActivate(this.team))
                        {
                              this.target = param1;
                              forceFaceDirection(this.target.px - px);
                              this.isReaperSpell = true;
                              hasHit = false;
                              _state = S_ATTACK;
                              team.game.soundManager.playSound("skeletalReaperSound",px,py);
                        }
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
                  param1.setAction(0,0,UnitCommand.REAPER);
                  if(techTeam.tech.isResearched(Tech.SKELETON_FIST_ATTACK))
                  {
                        param1.setAction(1,0,UnitCommand.FIST_ATTACK);
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
                  if(_state == S_RUN)
                  {
                        if(Math.abs(px - param1.px) < this.WEAPON_REACH && Math.abs(py - param1.py) < 40 && this.getDirection() == Util.sgn(param1.px - px))
                        {
                              return true;
                        }
                  }
                  return false;
            }
            
            public function get fistDamage() : Number
            {
                  return this._fistDamage;
            }
            
            public function set fistDamage(param1:Number) : void
            {
                  this._fistDamage = param1;
            }
      }
}
