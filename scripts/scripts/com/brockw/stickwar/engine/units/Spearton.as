package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.SpeartonAi;
      import com.brockw.stickwar.engine.Ai.command.UnitCommand;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Tech;
      import flash.display.MovieClip;
      
      public class Spearton extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var _isBlocking:Boolean;
            
            private var _inBlock:Boolean;
            
            private var shieldwallDamageReduction:Number;
            
            private var upgradedShieldwallDamageReduction:Number;
            
            private var shieldBashSpell:SpellCooldown;
            
            private var isShieldBashing:Boolean;
            
            private var stunForce:Number;
            
            private var stunTime:int;
            
            private var stunned:Unit;
            
            private var shieldRange:Number;
            
            private var nah:Boolean;
            
            public var speartonType:String = "";
            
            public function Spearton(param1:StickWar)
            {
                  super(param1);
                  _mc = new _speartonMc();
                  this.init(param1);
                  addChild(_mc);
                  ai = new SpeartonAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_speartonMc = null;
                  if((_loc5_ = _speartonMc(param1)).mc.helm)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.helm.gotoAndStop(param3);
                        }
                  }
                  if(_loc5_.mc.spear)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.spear.gotoAndStop(param2);
                        }
                  }
                  if(_loc5_.mc.shield)
                  {
                        if(param4 != "")
                        {
                              _loc5_.mc.shield.gotoAndStop(param4);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.inBlock = false;
                  this.isBlocking = false;
                  WEAPON_REACH = param1.xml.xml.Order.Units.spearton.weaponReach;
                  this.stunTime = param1.xml.xml.Order.Units.spearton.shieldBash.stunTime;
                  this.stunForce = param1.xml.xml.Order.Units.spearton.shieldBash.stunForce;
                  this.shieldRange = param1.xml.xml.Order.Units.spearton.shieldBash.range;
                  population = param1.xml.xml.Order.Units.spearton.population;
                  this.upgradedShieldwallDamageReduction = param1.xml.xml.Order.Units.spearton.shieldWall.upgradedDamageReduction;
                  this.shieldwallDamageReduction = param1.xml.xml.Order.Units.spearton.shieldWall.damageReduction;
                  _mass = param1.xml.xml.Order.Units.spearton.mass;
                  _maxForce = param1.xml.xml.Order.Units.spearton.maxForce;
                  _dragForce = param1.xml.xml.Order.Units.spearton.dragForce;
                  _scale = param1.xml.xml.Order.Units.spearton.scale;
                  _maxVelocity = param1.xml.xml.Order.Units.spearton.maxVelocity;
                  damageToDeal = param1.xml.xml.Order.Units.spearton.baseDamage;
                  this.createTime = param1.xml.xml.Order.Units.spearton.cooldown;
                  maxHealth = health = param1.xml.xml.Order.Units.spearton.health;
                  type = Unit.U_SPEARTON;
                  loadDamage(param1.xml.xml.Order.Units.spearton);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  this.isShieldBashing = false;
                  this.shieldBashSpell = new SpellCooldown(0,param1.xml.xml.Order.Units.spearton.shieldBash.cooldown,param1.xml.xml.Order.Units.spearton.shieldBash.mana);
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
                  building = team.buildings["BarracksBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            public function shieldBash() : void
            {
                  if(this.shieldBashSpell.spellActivate(team) && this._isBlocking && techTeam.tech.isResearched(Tech.SHIELD_BASH))
                  {
                        this.protect(75);
                        this.ragee(75);
                        this.isShieldBashing = true;
                  }
            }
            
            public function shieldBashCooldown() : Number
            {
                  return this.shieldBashSpell.cooldown();
            }
            
            override protected function isAbleToWalk() : Boolean
            {
                  return this._state == S_RUN && !this.isBlocking && !this.isShieldBashing && !this.inBlock;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var weapon_skin:* = undefined;
                  var armor_skin:* = undefined;
                  var misc_skin:* = undefined;
                  var _loc2_:Boolean = false;
                  this.shieldBashSpell.update();
                  updateCommon(param1);
                  if(team.isEnemy && !enemyBuffed)
                  {
                        _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel;
                        _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel;
                        health = Number(param1.xml.xml.Order.Units.spearton.health) / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
                        maxHealth = health;
                        maxHealth = maxHealth;
                        healthBar.totalHealth = maxHealth;
                        _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
                        enemyBuffed = true;
                        if(this.speartonType == "Leader")
                        {
                              _damageToNotArmour *= 3;
                              _damageToArmour *= 3;
                              health *= 10;
                              maxHealth = health;
                              maxHealth = maxHealth;
                              healthBar.totalHealth = maxHealth;
                              _scale += 0.2;
                        }
                  }
                  else if(!this.nah && !team.isEnemy)
                  {
                        _damageToNotArmour = _damageToNotArmour;
                        _damageToArmour = _damageToArmour;
                        health = Number(param1.xml.xml.Order.Units.spearton.health);
                        maxHealth = health;
                        maxHealth = maxHealth;
                        healthBar.totalHealth = maxHealth;
                        _scale = _scale;
                        this.nah = true;
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
                                    _loc2_ = this.checkForBlockHit();
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
                                    if(_mc.mc.currentFrame < 62)
                                    {
                                          _mc.mc.nextFrame();
                                    }
                                    else
                                    {
                                          _mc.mc.gotoAndStop(16);
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
                  if(this.speartonType == "Leader")
                  {
                        Spearton.setItem(_speartonMc(mc),"Lava Spear","Lava Helmet","Lava Shield");
                        this.isCustomUnit = true;
                  }
                  else if(team.isEnemy)
                  {
                        Spearton.setItem(_speartonMc(mc),"British Spear","Gladiator Helmet","Greek Shield");
                  }
                  else
                  {
                        weapon_skin = "Default";
                        armor_skin = "Default";
                        misc_skin = "Default";
                        if(techTeam.tech.isResearched(Tech.SHIELD_BASH))
                        {
                              armor_skin = "Gladiator Helmet";
                        }
                        if(techTeam.tech.isResearched(Tech.BLOCK))
                        {
                              misc_skin = "Roman Shield";
                        }
                        if(techTeam.tech.isResearched(Tech.SHIELD_BASH) && techTeam.tech.isResearched(Tech.BLOCK))
                        {
                              weapon_skin = "British Spear";
                        }
                        Spearton.setItem(_speartonMc(mc),weapon_skin,armor_skin,misc_skin);
                  }
            }
            
            private function shieldHit(param1:Unit) : *
            {
                  if(this.stunned == null && param1.team != this.team && param1.pz == 0)
                  {
                        if(Math.pow(param1.px - px,2) + Math.pow(param1.py - py,2) < this.shieldRange * this.shieldRange)
                        {
                              this.stunned = param1;
                              param1.damage(0,this.damageToDeal,this);
                              param1.stun(this.stunTime);
                              param1.applyVelocity(this.stunForce * Util.sgn(mc.scaleX));
                        }
                  }
            }
            
            protected function checkForBlockHit() : Boolean
            {
                  this.stunned = null;
                  team.game.spatialHash.mapInArea(px - this.shieldRange,py - this.shieldRange,px + this.shieldRange,py + this.shieldRange,this.shieldHit);
                  return true;
            }
            
            public function stopBlocking() : void
            {
                  if(this.isBlocking)
                  {
                        _mc.mc.gotoAndStop(62);
                  }
                  this.isBlocking = false;
            }
            
            public function startBlocking() : void
            {
                  this.isBlocking = true;
                  this.inBlock = true;
                  _state = S_RUN;
                  team.game.soundManager.playSound("speartonHoghSound",px,py);
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  param1.setAction(0,0,UnitCommand.SPEARTON_BLOCK);
                  if(techTeam.tech.isResearched(Tech.SHIELD_BASH))
                  {
                        param1.setAction(1,0,UnitCommand.SHIELD_BASH);
                  }
            }
            
            override public function attack() : void
            {
                  var _loc1_:int = 0;
                  if(_state != S_ATTACK)
                  {
                        if(this.isBlocking)
                        {
                              this.shieldBash();
                        }
                        else
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
            }
            
            override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
            {
                  if(this.inBlock)
                  {
                        if(techTeam.tech.isResearched(Tech.BLOCK))
                        {
                              super.damage(param1,param2 - param2 * this.upgradedShieldwallDamageReduction,param3,1 - this.upgradedShieldwallDamageReduction);
                        }
                        else
                        {
                              super.damage(param1,param2 - param2 * this.shieldwallDamageReduction,param3,1 - this.shieldwallDamageReduction);
                        }
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
