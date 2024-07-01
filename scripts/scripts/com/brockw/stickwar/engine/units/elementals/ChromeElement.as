package com.brockw.stickwar.engine.units.elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      import flash.filters.*;
      import flash.geom.ColorTransform;
      
      public class ChromeElement extends Unit
      {
            
            private static var WEAPON_REACH:int;
             
            
            private var timeSpawnDead:int;
            
            private var _teleportSpellTimer:SpellCooldown;
            
            private var _splitSpellTimer:SpellCooldown;
            
            private var _convertSpellTimer:SpellCooldown;
            
            private var outlineGlow:GlowFilter;
            
            private var normalVelocity:Number;
            
            private var currentTarget:Unit;
            
            public var isCopy:Boolean;
            
            private var convertedUnit:Unit;
            
            private var hasTeleportedOut:Boolean;
            
            private var hasTeleportedIn:Boolean;
            
            private var teleportX:Number;
            
            private var teleportY:Number;
            
            private var teleportFrames:int;
            
            private var teleportDirection:int;
            
            private var isSplitting:Boolean;
            
            private var children:Array;
            
            private var splitModifier1:Number;
            
            private var splitModifier2:Number;
            
            private var splitModifier3:Number;
            
            private var CLONE_SPAWN_WAIT:int;
            
            public function ChromeElement(param1:StickWar)
            {
                  super(param1);
                  this.convertedUnit = null;
                  _mc = new _chromeElement();
                  this.init(param1);
                  addChild(_mc);
                  ai = new ChromeAi(this);
                  initSync();
                  firstInit();
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_chromeElement;
                  if((_loc5_ = _chromeElement(param1)).mc.head)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.gotoAndStop(param3);
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
                  this.children = [];
                  this.convertedUnit = null;
                  this.isCopy = false;
                  this._teleportSpellTimer = new SpellCooldown(param1.xml.xml.Elemental.Units.chrome.teleport.effect,param1.xml.xml.Elemental.Units.chrome.teleport.cooldown,param1.xml.xml.Elemental.Units.chrome.teleport.mana);
                  this._splitSpellTimer = new SpellCooldown(param1.xml.xml.Elemental.Units.chrome.split.effect,param1.xml.xml.Elemental.Units.chrome.split.cooldown,param1.xml.xml.Elemental.Units.chrome.split.mana);
                  this._convertSpellTimer = new SpellCooldown(0,param1.xml.xml.Elemental.Units.chrome.convert.cooldown,param1.xml.xml.Elemental.Units.chrome.convert.mana);
                  WEAPON_REACH = param1.xml.xml.Elemental.Units.chrome.weaponReach;
                  this.teleportDirection = 1;
                  population = param1.xml.xml.Elemental.Units.chrome.population;
                  _mass = param1.xml.xml.Elemental.Units.chrome.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.chrome.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.chrome.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.chrome.scale;
                  _maxVelocity = this.normalVelocity = param1.xml.xml.Elemental.Units.chrome.maxVelocity;
                  this.createTime = param1.xml.xml.Elemental.Units.chrome.cooldown;
                  this.isSplitting = false;
                  loadDamage(param1.xml.xml.Elemental.Units.chrome);
                  maxHealth = health = param1.xml.xml.Elemental.Units.chrome.health;
                  this.splitModifier1 = param1.xml.xml.Elemental.Units.chrome.split.splitDamage1;
                  this.splitModifier2 = param1.xml.xml.Elemental.Units.chrome.split.splitDamage2;
                  this.splitModifier3 = param1.xml.xml.Elemental.Units.chrome.split.splitDamage3;
                  this.CLONE_SPAWN_WAIT = param1.xml.xml.Elemental.Units.chrome.split.cloneAfterDeadFrames;
                  this.timeSpawnDead = -this.CLONE_SPAWN_WAIT;
                  this.currentTarget = null;
                  this.teleportFrames = 0;
                  this.hasTeleportedOut = true;
                  this.hasTeleportedIn = true;
                  this.outlineGlow = new GlowFilter();
                  this.outlineGlow.blurX = 5;
                  this.outlineGlow.blurY = 5;
                  this.outlineGlow.quality = BitmapFilterQuality.MEDIUM;
                  this.outlineGlow.strength = 5;
                  this.outlineGlow.color = 0;
                  type = Unit.U_CHROME_ELEMENT;
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
                  building = team.buildings["BarracksBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  return damageToDeal;
            }
            
            public function splitCooldown() : Number
            {
                  if(this.isCopy || this.children.length != 0)
                  {
                        return 1;
                  }
                  return 1 - Math.min(1,Math.max(0,(team.game.frame - this.timeSpawnDead) / this.CLONE_SPAWN_WAIT));
            }
            
            public function split() : void
            {
                  if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_1) && !this.isCopy && this.children.length == 0 && team.game.frame - this.timeSpawnDead > this.CLONE_SPAWN_WAIT && Boolean(this._splitSpellTimer.spellActivate(team)))
                  {
                        this.isSplitting = true;
                        _state = S_ATTACK;
                        team.game.soundManager.playSound("chromeSplitSound",px,py);
                  }
            }
            
            private function doTheSplit() : void
            {
                  var _loc1_:ChromeElement = null;
                  var _loc2_:AttackMoveCommand = null;
                  if(this.children.length != 0)
                  {
                        return;
                  }
                  _loc1_ = team.game.unitFactory.getUnit(Unit.U_CHROME_ELEMENT);
                  team.spawn(_loc1_,team.game);
                  _loc1_.px = px;
                  _loc1_.py = py + -100;
                  if(_loc1_.py < 0)
                  {
                        _loc1_.py = 0;
                  }
                  if(_loc1_.py > team.game.map.height)
                  {
                        _loc1_.py = team.game.map.height;
                  }
                  _loc1_.isCopy = true;
                  _loc1_.population = 0;
                  _loc2_ = new AttackMoveCommand(team.game);
                  _loc2_.type = UnitCommand.ATTACK_MOVE;
                  _loc2_.goalX = team.enemyTeam.statue.px;
                  _loc2_.goalY = py + team.game.random.nextNumber() * 200 - 100;
                  _loc2_.realX = team.enemyTeam.statue.px;
                  _loc2_.realY = _loc2_.goalY;
                  _loc1_.ai.setCommand(team.game,_loc2_);
                  this.children = [_loc1_];
                  _loc1_ = team.game.unitFactory.getUnit(Unit.U_CHROME_ELEMENT);
                  team.spawn(_loc1_,team.game);
                  _loc1_.px = px;
                  _loc1_.py = py + 100;
                  _loc1_.population = 0;
                  _loc1_.isCopy = true;
                  if(_loc1_.py < 0)
                  {
                        _loc1_.py = 0;
                  }
                  if(_loc1_.py > team.game.map.height)
                  {
                        _loc1_.py = team.game.map.height;
                  }
                  _loc2_ = new AttackMoveCommand(team.game);
                  _loc2_.type = UnitCommand.ATTACK_MOVE;
                  _loc2_.goalX = team.enemyTeam.statue.px;
                  _loc2_.goalY = py + team.game.random.nextNumber() * 200 - 100;
                  _loc2_.realX = team.enemyTeam.statue.px;
                  _loc2_.realY = _loc2_.goalY;
                  _loc1_.ai.setCommand(team.game,_loc2_);
                  this.children.push(_loc1_);
            }
            
            public function convertCooldown() : Number
            {
                  if(this.isCopy)
                  {
                        return this._convertSpellTimer.cooldownTime;
                  }
                  if(this.convertedUnit != null)
                  {
                        return 1;
                  }
                  return this._convertSpellTimer.cooldown();
            }
            
            public function convertSpell(param1:Unit) : void
            {
                  if(Boolean(this._convertSpellTimer.spellActivate(team)) && param1.type != Unit.U_STATUE)
                  {
                        this.convertedUnit = param1;
                        team.enemyTeam.switchTeams(param1);
                        _state = S_ATTACK;
                  }
            }
            
            public function teleportCooldown() : Number
            {
                  if(this.isCopy)
                  {
                        return this._teleportSpellTimer.cooldownTime;
                  }
                  return this._teleportSpellTimer.cooldown();
            }
            
            public function teleportSpell(param1:Number, param2:Number) : void
            {
                  if(this._teleportSpellTimer.spellActivate(team))
                  {
                        this.teleportX = param1;
                        this.teleportY = param2;
                        this.teleportDirection = Util.sgn(this.teleportX - px);
                        team.game.projectileManager.initTeleportEffect(px,py,0,team,this.teleportDirection);
                        this.px = this.teleportX;
                        this.py = this.teleportY;
                        this.teleportFrames = 0;
                        this.hasTeleportedOut = true;
                        this.hasTeleportedIn = false;
                  }
            }
            
            override protected function checkForHit() : Boolean
            {
                  return super.checkForHit();
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc3_:Unit = null;
                  var _loc5_:ColorTransform = null;
                  this._teleportSpellTimer.update();
                  this._splitSpellTimer.update();
                  this._convertSpellTimer.update();
                  updateCommon(param1);
                  if(timeAlive > 15 || this.isCopy)
                  {
                        mc.visible = true;
                  }
                  else
                  {
                        mc.visible = false;
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
                        else if(this.isSplitting)
                        {
                              _mc.gotoAndStop("split");
                              if(_mc.mc.currentFrame == 20)
                              {
                                    this.doTheSplit();
                              }
                              else if(_mc.mc.currentFrame == _mc.mc.totalFrames)
                              {
                                    _state = S_RUN;
                                    this.isSplitting = false;
                              }
                        }
                        else if(!this.hasTeleportedIn)
                        {
                              ++this.teleportFrames;
                              if(this.teleportFrames == 25)
                              {
                                    this.hasTeleportedIn = true;
                                    _mc.visible = true;
                              }
                              else
                              {
                                    _mc.visible = false;
                              }
                              if(this.teleportFrames == 1)
                              {
                                    team.game.soundManager.playSound("teleport",px,py);
                                    team.game.projectileManager.initTeleportEffectIn(px,py,0,team,this.teleportDirection);
                              }
                        }
                        else if(this.convertedUnit != null)
                        {
                              if(!this.convertedUnit.isAlive())
                              {
                                    this.convertedUnit = null;
                                    this._convertSpellTimer.startCooldownNow();
                              }
                              this.outlineGlow.strength += (0 - this.outlineGlow.strength) * 0.1;
                              _mc.gotoAndStop("posses");
                              if(26 == MovieClip(_mc.mc).currentFrame)
                              {
                                    _mc.mc.mc1.gotoAndStop(3);
                                    _mc.mc.mc2.gotoAndStop(40);
                                    _mc.mc.mc3.gotoAndStop(20);
                                    _mc.mc.mc4.gotoAndStop(15);
                                    _mc.mc.mc5.gotoAndStop(1);
                                    _mc.mc.mc6.gotoAndStop(45);
                                    _mc.mc.mc7.gotoAndStop(30);
                              }
                              if(MovieClip(_mc.mc).currentFrame == 100)
                              {
                                    _mc.mc.gotoAndStop(27);
                              }
                        }
                        else if(_state == S_RUN)
                        {
                              if(Math.abs(_dx) + Math.abs(_dy) > 1.5)
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
                              if(MovieClip(_mc.mc).sound)
                              {
                                    param1.soundManager.playSoundRandom("chromeKickSound",2,px,py);
                              }
                              if(!hasHit)
                              {
                                    hasHit = this.checkForHit();
                                    if(hasHit)
                                    {
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
                        for each(_loc3_ in this.children)
                        {
                              _loc3_.damage(Unit.D_NO_BLOOD | Unit.D_NO_SOUND,1000,null);
                        }
                        this.children = [];
                        if(this.convertedUnit != null && Boolean(this.convertedUnit.isAlive()))
                        {
                              this.convertedUnit.team.switchTeams(this.convertedUnit);
                              this.convertedUnit = null;
                        }
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
                  if(this.convertedUnit == null)
                  {
                        this.outlineGlow.strength += (5 - this.outlineGlow.strength) * 0.1;
                  }
                  if(!(isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames))
                  {
                        Util.animateMovieClip(_mc);
                  }
                  if(this.isCopy)
                  {
                        _loc5_ = this.mc.transform.colorTransform;
                        if(team == param1.team)
                        {
                              _loc5_.redOffset = -80;
                              _loc5_.greenOffset = -80;
                        }
                        else
                        {
                              _loc5_.blueOffset = -120;
                              _loc5_.greenOffset = -120;
                        }
                        mc.transform.colorTransform = _loc5_;
                  }
                  if(this.isCopy && team.game.team == this.team)
                  {
                        mc.mc.alpha = 1;
                  }
                  else
                  {
                        mc.mc.alpha = 1;
                  }
                  if(mc.mc.filters.length == 0)
                  {
                        mc.mc.filters = [this.outlineGlow];
                  }
                  var _loc2_:int = 0;
                  for each(_loc3_ in this.children)
                  {
                        if(_loc3_.isAlive() == false)
                        {
                              _loc2_++;
                        }
                  }
                  if(_loc2_ == this.children.length)
                  {
                        if(this.children.length != 0)
                        {
                              this.timeSpawnDead = team.game.frame;
                        }
                        this.children = [];
                  }
                  var _loc4_:AttackMoveCommand;
                  (_loc4_ = new AttackMoveCommand(param1)).type = UnitCommand.ATTACK_MOVE;
                  _loc4_.goalX = px;
                  _loc4_.realX = _loc4_.goalX;
                  ChromeElement.setItem(mc,"",team.loadout.getItem(this.type,MarketItem.T_ARMOR),"");
            }
            
            override public function isBusy() : Boolean
            {
                  return Boolean(this.isSplitting) || this.isCopy || this.convertedUnit != null;
            }
            
            override public function isTargetable() : Boolean
            {
                  return !isDead && !isDieing && !this._isDualing;
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  if(!this.isCopy)
                  {
                        param1.setAction(0,0,UnitCommand.TELEPORT);
                        if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_1))
                        {
                              param1.setAction(1,0,UnitCommand.SPLIT);
                        }
                        param1.setAction(2,0,UnitCommand.CONVERT);
                  }
            }
            
            override public function get damageToArmour() : Number
            {
                  if(this.isCopy)
                  {
                        if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_2))
                        {
                              return this.splitModifier2 * _damageToArmour;
                        }
                        if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_1))
                        {
                              return this.splitModifier1 * _damageToArmour;
                        }
                        return 0;
                  }
                  return _damageToArmour;
            }
            
            override public function get damageToNotArmour() : Number
            {
                  if(this.isCopy)
                  {
                        if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_2))
                        {
                              return this.splitModifier2 * _damageToNotArmour;
                        }
                        if(techTeam.tech.isResearched(Tech.CHROME_SPLIT_1))
                        {
                              return this.splitModifier1 * _damageToNotArmour;
                        }
                        return 0;
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
            
            override public function stateFixForCutToWalk() : void
            {
                  if(this.isSplitting)
                  {
                        return;
                  }
                  if(this.convertedUnit != null && Boolean(this.convertedUnit.isAlive()))
                  {
                        this.convertedUnit.team.switchTeams(this.convertedUnit);
                        this.convertedUnit = null;
                        this._convertSpellTimer.startCooldownNow();
                  }
                  this._state = S_RUN;
                  this.hasHit = true;
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
