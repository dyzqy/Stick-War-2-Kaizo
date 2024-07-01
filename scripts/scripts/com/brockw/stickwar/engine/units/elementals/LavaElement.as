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
      import flash.filters.*;
      
      public class LavaElement extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var _isBlocking:Boolean;
            
            private var _inBlock:Boolean;
            
            private var shieldwallDamageReduction:Number;
            
            private var maxVelocityUnderground:Number;
            
            private var maxVelocityNormal:Number;
            
            private var burrowSpell:SpellCooldown;
            
            private var radiantSpell:SpellCooldown;
            
            private var stunForce:Number;
            
            private var stunTime:int;
            
            private var stunned:Unit;
            
            private var hasBurrowed:Boolean;
            
            private var needsToUnBurrow:Boolean;
            
            private var isBurrowed:Boolean;
            
            private var radiantSpellGlow:GlowFilter;
            
            private var stunRange:Number;
            
            private var burrowDamage:Number;
            
            private var burrowStun:Number;
            
            private var radiantRange:Number;
            
            private var radiantDamage:Number;
            
            private var radiantFrames:int;
            
            private var directionAtBurrow:int;
            
            private var isTowerSpawn2:Boolean;
            
            private var radiantMana:Number;
            
            public function LavaElement(param1:StickWar)
            {
                  super(param1);
                  _mc = new _lavaElement();
                  this.isTowerSpawn2 = false;
                  this.init(param1);
                  addChild(_mc);
                  ai = new LavaElementAi(this);
                  initSync();
                  firstInit();
                  this.radiantSpellGlow = new GlowFilter();
                  this.radiantSpellGlow.color = 16711680;
                  this.radiantSpellGlow.blurX = 10;
                  this.radiantSpellGlow.blurY = 10;
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_lavaElement;
                  if((_loc5_ = _lavaElement(param1)).mc.head)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.gotoAndStop(param3);
                        }
                  }
                  if(_loc5_.mc.fronthand)
                  {
                        if(param2 != "")
                        {
                              _loc5_.mc.fronthand.gotoAndStop(param2);
                              _loc5_.mc.backhand.gotoAndStop(param2);
                        }
                  }
                  if(_loc5_.mc.torso)
                  {
                        if(param4 != "")
                        {
                              _loc5_.mc.torso.gotoAndStop(param4);
                              _loc5_.mc.backarm.gotoAndStop(param4);
                              _loc5_.mc.frontarm.gotoAndStop(param4);
                              _loc5_.mc.backfoot.gotoAndStop(param4);
                              _loc5_.mc.frontfoot.gotoAndStop(param4);
                              _loc5_.mc.frontleg.gotoAndStop(param4);
                              _loc5_.mc.backleg.gotoAndStop(param4);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.isTowerSpawn2 = false;
                  this.inBlock = false;
                  this.isBlocking = false;
                  WEAPON_REACH = param1.xml.xml.Elemental.Units.lavaElement.weaponReach;
                  this.stunTime = param1.xml.xml.Elemental.Units.lavaElement.shieldBash.stunTime;
                  this.stunForce = param1.xml.xml.Elemental.Units.lavaElement.shieldBash.stunForce;
                  population = param1.xml.xml.Elemental.Units.lavaElement.population;
                  this.shieldwallDamageReduction = param1.xml.xml.Elemental.Units.lavaElement.shieldWall.damageReduction;
                  _mass = param1.xml.xml.Elemental.Units.lavaElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.lavaElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.lavaElement.dragForce;
                  _scale = 1.3;
                  _maxVelocity = param1.xml.xml.Elemental.Units.lavaElement.maxVelocity;
                  this.maxVelocityUnderground = param1.xml.xml.Elemental.Units.lavaElement.maxVelocityUnderground;
                  this.maxVelocityNormal = param1.xml.xml.Elemental.Units.lavaElement.maxVelocity;
                  damageToDeal = param1.xml.xml.Elemental.Units.lavaElement.baseDamage;
                  this.createTime = param1.xml.xml.Elemental.Units.lavaElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.lavaElement.health;
                  this.stunRange = param1.xml.xml.Elemental.Units.lavaElement.burrow.range;
                  this.burrowDamage = param1.xml.xml.Elemental.Units.lavaElement.burrow.damage;
                  this.burrowStun = param1.xml.xml.Elemental.Units.lavaElement.burrow.stun;
                  this.radiantDamage = param1.xml.xml.Elemental.Units.lavaElement.radiant.damage;
                  this.radiantRange = param1.xml.xml.Elemental.Units.lavaElement.radiant.range;
                  this.radiantFrames = param1.xml.xml.Elemental.Units.lavaElement.radiant.frames;
                  this.radiantMana = param1.xml.xml.Elemental.Units.lavaElement.radiant.manaPerFrame;
                  type = Unit.U_LAVA_ELEMENT;
                  loadDamage(param1.xml.xml.Elemental.Units.lavaElement);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  this.hasBurrowed = false;
                  this.needsToUnBurrow = false;
                  this.isBurrowed = false;
                  this.burrowSpell = new SpellCooldown(param1.xml.xml.Elemental.Units.lavaElement.burrow.effect,param1.xml.xml.Elemental.Units.lavaElement.burrow.cooldown,param1.xml.xml.Elemental.Units.lavaElement.burrow.mana);
                  this.radiantSpell = new SpellCooldown(param1.xml.xml.Elemental.Units.lavaElement.radiant.effect,param1.xml.xml.Elemental.Units.lavaElement.radiant.cooldown,param1.xml.xml.Elemental.Units.radiant.radiant.mana);
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
            }
            
            public function isFreezable() : Boolean
            {
                  return !this.isTowerSpawn2;
            }
            
            override public function set isTowerSpawned(param1:Boolean) : void
            {
                  if(param1 == true)
                  {
                        if(this.techTeam.tech.isResearched(Tech.TOWER_SPAWN_II))
                        {
                              this.isTowerSpawn2 = true;
                              maxHealth = health = team.game.xml.xml.Elemental.Units.lavaElement.towerSpawnIIHealth;
                              healthBar.totalHealth = maxHealth;
                              this.healthBar.reset();
                              this._damageToArmour = team.game.xml.xml.Elemental.Units.lavaElement.towerSpawnIIDamage;
                              this._damageToNotArmour = team.game.xml.xml.Elemental.Units.lavaElement.towerSpawnIIDamage;
                              this._scale = team.game.xml.xml.Elemental.Units.lavaElement.towerSpawnIIScale;
                        }
                  }
                  _isTowerSpawned = param1;
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
            
            public function burrow() : void
            {
                  if(Boolean(this.burrowSpell.spellActivate(team)) && this.isBurrowed == false)
                  {
                        this.hasBurrowed = false;
                        this.needsToUnBurrow = true;
                        this.isBurrowed = true;
                        this.directionAtBurrow = getDirection();
                        if(team.game.team == team)
                        {
                              team.game.gameScreen.userInterface.selectedUnits.refresh(true);
                        }
                  }
            }
            
            public function unburrow() : void
            {
                  if(this.isBurrowed)
                  {
                        this.isBurrowed = false;
                        this.needsToUnBurrow = true;
                        this.hasBurrowed = true;
                        if(team.game.team == team)
                        {
                              team.game.gameScreen.userInterface.selectedUnits.refresh(true);
                        }
                  }
            }
            
            override public function isTargetable() : Boolean
            {
                  if(Boolean(this.isBurrowed) && Boolean(this.hasBurrowed))
                  {
                        return false;
                  }
                  return super.isTargetable();
            }
            
            public function toggleRadiant() : Boolean
            {
                  if(this.isBurrowed)
                  {
                        return;
                  }
                  if(this.radiantSpell.spellActivate(team))
                  {
                        team.game.soundManager.playSound("lavaBurn",px,py);
                  }
            }
            
            public function burrowCooldown() : Number
            {
                  return this.burrowSpell.cooldown();
            }
            
            public function radiantCooldown() : Number
            {
                  return this.radiantSpell.cooldown();
            }
            
            override protected function isAbleToWalk() : Boolean
            {
                  if(this.isBurrowed == false && Boolean(this.needsToUnBurrow))
                  {
                        return false;
                  }
                  if(Boolean(this.burrowSpell.inEffect()) && !this.hasBurrowed)
                  {
                        return false;
                  }
                  return this._state == S_RUN;
            }
            
            private function burnInArea(param1:Unit) : *
            {
                  if(param1.team != this.team && param1.pz == 0)
                  {
                        if(Math.pow(param1.px - px,2) + Math.pow(param1.py - py,2) < this.radiantRange * this.radiantRange)
                        {
                              param1.setFire(this.radiantFrames,this.radiantDamage);
                        }
                  }
            }
            
            override public function stun(param1:int, param2:Number = 1) : void
            {
                  if(isTowerSpawned)
                  {
                        return;
                  }
                  super.stun(param1,param2);
            }
            
            override public function update(param1:StickWar) : void
            {
                  this.radiantSpell.update();
                  this.burrowSpell.update();
                  updateCommon(param1);
                  if(this.isTowerSpawned)
                  {
                        this.stunTime = 0;
                  }
                  if(timeAlive > 15)
                  {
                        mc.visible = true;
                  }
                  else
                  {
                        mc.visible = false;
                  }
                  if(this.burrowSpell.inEffect())
                  {
                        _maxVelocity = this.maxVelocityUnderground;
                  }
                  else
                  {
                        this.isBurrowed = false;
                  }
                  if(this.isBurrowed == false)
                  {
                        _maxVelocity = this.maxVelocityNormal;
                  }
                  if(this.radiantSpell.inEffect())
                  {
                        team.mana -= this.radiantMana;
                        this.radiantSpellGlow.blurX = 5;
                        this.radiantSpellGlow.blurY = 5;
                        this.mc.filters = [this.radiantSpellGlow];
                        team.game.spatialHash.mapInArea(px - this.radiantRange,py - this.radiantRange,px + this.radiantRange,py + this.radiantRange,this.burnInArea);
                  }
                  else
                  {
                        this.mc.filters = [];
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
                        else if(Boolean(this.needsToUnBurrow) && !this.isBurrowed)
                        {
                              _mc.gotoAndStop("unburrow");
                              if(_mc.mc.currentFrame == 1)
                              {
                                    this.burrowSpell.startCooldownNow();
                                    team.game.projectileManager.initMound(px,py,0,team,-this.directionAtBurrow);
                              }
                              if(_mc.mc.currentFrame == 28)
                              {
                                    team.game.spatialHash.mapInArea(px - this.stunRange / 2,py - this.stunRange / 2,px + this.stunRange,py + this.stunRange,this.burrowHit);
                              }
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    this.needsToUnBurrow = false;
                                    this.isBurrowed = false;
                                    this.hasBurrowed = true;
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(this.isBurrowed)
                        {
                              _mc.gotoAndStop("burrow");
                              if(_mc.mc.currentFrame != _mc.mc.totalFrames)
                              {
                                    this.hasBurrowed = false;
                                    if(_mc.mc.currentFrame == _mc.mc.totalFrames - 1)
                                    {
                                          team.game.projectileManager.initMound(px,py,0,team,-this.directionAtBurrow);
                                    }
                              }
                              else
                              {
                                    this.hasBurrowed = true;
                              }
                        }
                        else if(_state == S_RUN)
                        {
                              if(isFeetMoving())
                              {
                                    _mc.gotoAndStop("run");
                                    if(Boolean(this.radiantSpell.inEffect()) && (_mc.mc.currentFrame == 5 || _mc.mc.currentFrame == 15))
                                    {
                                          param1.projectileManager.initLavaSpark(px,py - 1,0,team,this.getDirection());
                                    }
                              }
                              else
                              {
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(MovieClip(mc.mc).swing)
                              {
                                    team.game.soundManager.playSoundRandom("lavaSound",5,px,py);
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
                  if(_isDualing || !this.inBlock || isDead)
                  {
                        Util.animateMovieClip(_mc);
                  }
                  LavaElement.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
            }
            
            private function burrowHit(param1:Unit) : *
            {
                  if(param1.team != this.team && param1.pz == 0)
                  {
                        if(Math.pow(param1.px - px,2) + Math.pow(param1.py - py,2) < this.stunRange * this.stunRange)
                        {
                              param1.damage(0,this.burrowDamage,this);
                              param1.stun(this.burrowStun,2);
                        }
                  }
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
                  if(!this.isTowerSpawned)
                  {
                        param1.setAction(0,0,UnitCommand.RADIANT_HEAT);
                        if(this.isBurrowed)
                        {
                              param1.setAction(1,0,UnitCommand.UNBURROW);
                        }
                        else
                        {
                              param1.setAction(1,0,UnitCommand.BURROW);
                        }
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
                        super.damage(param1,param2 - param2 * this.shieldwallDamageReduction,param3,1 - this.shieldwallDamageReduction);
                  }
                  else
                  {
                        super.damage(param1,param2,param3);
                  }
            }
            
            override public function mayAttack(param1:Unit) : Boolean
            {
                  if(this.isBurrowed)
                  {
                        return false;
                  }
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
