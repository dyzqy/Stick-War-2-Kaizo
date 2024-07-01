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
      
      public class HurricaneElement extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var _isBlocking:Boolean;
            
            private var _inBlock:Boolean;
            
            private var shieldwallDamageReduction:Number;
            
            private var protectSpellCooldown:SpellCooldown;
            
            private var hurricaneSpellCooldown:SpellCooldown;
            
            private var isShieldBashing:Boolean;
            
            private var stunForce:Number;
            
            private var stunTime:int;
            
            private var stunned:Unit;
            
            private var protectTime:int;
            
            private var isHurricane:Boolean;
            
            private var targetX:Number;
            
            private var targetY:Number;
            
            private var protectTarget:Unit;
            
            private var isProtect:Boolean = false;
            
            public function HurricaneElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _hurricaneMc();
                  this.init(param1);
                  addChild(_mc);
                  this.isHurricane = false;
                  ai = new HurricaneElementAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_hurricaneMc;
                  if((_loc5_ = _hurricaneMc(param1)).mc.head)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.gotoAndStop(param3);
                        }
                  }
                  if(Boolean(_loc5_.mc.frontHand) && Boolean(_loc5_.mc.backHand))
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.frontHand.gotoAndStop(param2);
                              _loc5_.mc.backHand.gotoAndStop(param2);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.inBlock = false;
                  this.isBlocking = false;
                  this.isHurricane = false;
                  this.protectTarget = null;
                  this.isProtect = false;
                  WEAPON_REACH = param1.xml.xml.Elemental.Units.hurricaneElement.weaponReach;
                  this.stunTime = param1.xml.xml.Elemental.Units.hurricaneElement.shieldBash.stunTime;
                  this.stunForce = param1.xml.xml.Elemental.Units.hurricaneElement.shieldBash.stunForce;
                  population = param1.xml.xml.Elemental.Units.hurricaneElement.population;
                  this.shieldwallDamageReduction = param1.xml.xml.Elemental.Units.hurricaneElement.shieldWall.damageReduction;
                  _mass = param1.xml.xml.Elemental.Units.hurricaneElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.hurricaneElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.hurricaneElement.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.hurricaneElement.scale;
                  _maxVelocity = param1.xml.xml.Elemental.Units.hurricaneElement.maxVelocity;
                  damageToDeal = param1.xml.xml.Elemental.Units.hurricaneElement.baseDamage;
                  this.createTime = param1.xml.xml.Elemental.Units.hurricaneElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.hurricaneElement.health;
                  this.protectTime = param1.xml.xml.Elemental.protectionTime;
                  type = Unit.U_HURRICANE_ELEMENT;
                  loadDamage(param1.xml.xml.Elemental.Units.hurricaneElement);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  this.isShieldBashing = false;
                  flyingHeight = 230 * 1;
                  pz = -flyingHeight * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  this.protectSpellCooldown = new SpellCooldown(0,param1.xml.xml.Elemental.Units.hurricaneElement.protect.cooldown,param1.xml.xml.Elemental.Units.hurricaneElement.protect.mana);
                  this.hurricaneSpellCooldown = new SpellCooldown(0,param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.cooldown,param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.mana);
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
            }
            
            override public function canAttackGround() : Boolean
            {
                  return false;
            }
            
            override public function canAttackAir() : Boolean
            {
                  return true;
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
            
            public function protectSpell(param1:Unit) : void
            {
                  if(this.protectSpellCooldown.spellActivate(team))
                  {
                        this.isProtect = true;
                        this.protectTarget = param1;
                  }
            }
            
            public function hurricaneCooldown() : Number
            {
                  return this.hurricaneSpellCooldown.cooldown();
            }
            
            override public function isBusy() : Boolean
            {
                  return !this.notInSpell() || isBusyForSpell;
            }
            
            private function notInSpell() : Boolean
            {
                  return !this.isHurricane && !this.isProtect;
            }
            
            override protected function isAbleToWalk() : Boolean
            {
                  if(!this.notInSpell)
                  {
                        return false;
                  }
                  return this._state == S_RUN;
            }
            
            public function hurricaneSpell(param1:Number, param2:Number) : void
            {
                  if(Boolean(this.hurricaneSpellCooldown.spellActivate(team)) && this.techTeam.tech.isResearched(Tech.TORNADO))
                  {
                        _state = S_ATTACK;
                        this.isHurricane = true;
                        this.targetX = param1;
                        this.targetY = param2;
                  }
            }
            
            public function protectCooldown() : Number
            {
                  return this.protectSpellCooldown.cooldown();
            }
            
            override public function update(param1:StickWar) : void
            {
                  this.protectSpellCooldown.update();
                  this.hurricaneSpellCooldown.update();
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
                        else if(this.isProtect)
                        {
                              _mc.gotoAndStop("spell_2");
                              if(_mc.mc.currentFrame == 9)
                              {
                                    this.protectTarget.protect(this.protectTime);
                                    team.game.soundManager.playSound("cycloidProtectSound",px,py);
                              }
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    this.isProtect = false;
                                    _state = S_RUN;
                              }
                        }
                        else if(this.isHurricane)
                        {
                              _mc.gotoAndStop("spell_1");
                              if(_mc.mc.currentFrame == 4)
                              {
                                    param1.soundManager.playSound("tornadoWindSound",px,py);
                              }
                              if(_mc.mc.currentFrame == 12)
                              {
                                    team.game.projectileManager.initHurricane(this.targetX,this.targetY,this,0);
                              }
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    this.isHurricane = false;
                                    _state = S_RUN;
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
                  HurricaneElement.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
            }
            
            private function shieldHit(param1:Unit) : *
            {
                  if(this.stunned == null && param1.team != this.team && param1.pz == 0)
                  {
                        if(Math.pow(param1.px + param1.dx - dx - px,2) + Math.pow(param1.py + param1.dy - dy - py,2) < Math.pow(5 * param1.hitBoxWidth * (this.perspectiveScale + param1.perspectiveScale) / 2,2))
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
                  team.game.spatialHash.mapInArea(px,py,px + 30,py + 30,this.shieldHit);
                  return true;
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
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  param1.setAction(0,0,UnitCommand.PROTECT);
                  if(this.techTeam.tech.isResearched(Tech.TORNADO))
                  {
                        param1.setAction(1,0,UnitCommand.HURRICANE);
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
            
            override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
            {
                  if(this.inBlock)
                  {
                        trace(this.shieldwallDamageReduction);
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
