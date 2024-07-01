package com.brockw.stickwar.engine.units.elementals
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.projectile.Flower;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      
      public class TreeElement extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var _isFlowerSpell:Boolean;
            
            private var _inBlock:Boolean;
            
            private var flowerSpellCooldown:SpellCooldown;
            
            private var flowerSpellTarget:Unit;
            
            private var flowerSpellStartFrame:int;
            
            private var lastFlowerX:Number;
            
            private var lastFlowerY:Number;
            
            private var shouldRoot:Boolean;
            
            private var isRooting:Boolean;
            
            private var spawnlings:Array;
            
            private var spawnlingsToKill:Array;
            
            private var max_spawnlings:int;
            
            private var lastSpawnKill:int;
            
            private var flowers:Array;
            
            private var isReturnFlower:Boolean;
            
            private var rateOfReturn:int = 10;
            
            private var healAmount:int;
            
            private var healDuration:int;
            
            private var damageAmount:int;
            
            private var stunAmount:int;
            
            private var rootFrame:int;
            
            private var scorpionDeathTimes:Array;
            
            private var respawnTime:int;
            
            private var flowerVelocity:Number;
            
            private var flowerDirection:Number;
            
            private var skorpionManaSpawnCost:Number = 2;
            
            public function TreeElement(param1:StickWar)
            {
                  super(param1);
                  this.isReturnFlower = false;
                  _mc = new _tree();
                  this.lastSpawnKill = 0;
                  this.shouldRoot = false;
                  this.isRooting = false;
                  this.init(param1);
                  this.spawnlingsToKill = [];
                  addChild(_mc);
                  ai = new MudElementAi(this);
                  initSync();
                  firstInit();
                  this.max_spawnlings = 0;
                  this.flowers = [];
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_tree;
                  if((_loc5_ = _tree(param1)).mc.tree)
                  {
                        if(_loc5_.mc.tree.hat)
                        {
                              _loc5_.mc.tree.hat.gotoAndStop(param4);
                        }
                        else if(Boolean(_loc5_.mc.tree.top) && Boolean(_loc5_.mc.tree.top.hat))
                        {
                              _loc5_.mc.tree.top.hat.gotoAndStop(param4);
                        }
                  }
                  else if(_loc5_.mc.hat)
                  {
                        _loc5_.mc.hat.gotoAndStop(param4);
                  }
                  else if(Boolean(_loc5_.mc.top) && Boolean(_loc5_.mc.top.hat))
                  {
                        _loc5_.mc.top.hat.gotoAndStop(param4);
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.inBlock = false;
                  this.spawnlings = [];
                  this._isFlowerSpell = false;
                  this.isReturnFlower = false;
                  this.isBlocking = false;
                  this.rateOfReturn = 10;
                  WEAPON_REACH = 600;
                  population = param1.xml.xml.Elemental.Units.treeElement.population;
                  _mass = param1.xml.xml.Elemental.Units.treeElement.mass;
                  _maxForce = param1.xml.xml.Elemental.Units.treeElement.maxForce;
                  _dragForce = param1.xml.xml.Elemental.Units.treeElement.dragForce;
                  _scale = 1.5;
                  this.isRooting = false;
                  this.shouldRoot = false;
                  this.rootFrame = 1;
                  this.max_spawnlings = 3;
                  this.healAmount = param1.xml.xml.Elemental.Units.treeElement.healAmount;
                  this.healDuration = param1.xml.xml.Elemental.Units.treeElement.healDuration;
                  this.damageAmount = param1.xml.xml.Elemental.Units.treeElement.damageAmount;
                  this.stunAmount = param1.xml.xml.Elemental.Units.treeElement.stunAmount;
                  _maxVelocity = param1.xml.xml.Elemental.Units.treeElement.maxVelocity;
                  this.respawnTime = param1.xml.xml.Elemental.Units.treeElement.respawnTime;
                  damageToDeal = param1.xml.xml.Elemental.Units.treeElement.baseDamage;
                  this.createTime = param1.xml.xml.Elemental.Units.treeElement.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.treeElement.health;
                  this.skorpionManaSpawnCost = param1.xml.xml.Elemental.Units.treeElement.scorpionSpawnManaCost;
                  type = Unit.U_TREE_ELEMENT;
                  loadDamage(param1.xml.xml.Elemental.Units.treeElement);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  this.pheight = 150;
                  _state = S_RUN;
                  this.scorpionDeathTimes = [];
                  this.flowerSpellCooldown = new SpellCooldown(0,param1.xml.xml.Elemental.Units.treeElement.flower.cooldown,param1.xml.xml.Elemental.Units.treeElement.flower.mana);
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
            
            public function flowerSpell(param1:Unit) : void
            {
                  var _loc2_:int = 0;
                  if(param1.isFlying())
                  {
                        return;
                  }
                  if(Boolean(this.flowerSpellCooldown.spellActivate(team)) && !this._isFlowerSpell)
                  {
                        this._isFlowerSpell = true;
                        this.flowerSpellTarget = param1;
                        this.flowerSpellStartFrame = team.game.frame;
                        _loc2_ = team.game.random.nextInt() % this._attackLabels.length;
                        _mc.gotoAndStop("attack_" + this._attackLabels[_loc2_]);
                        MovieClip(_mc.mc).gotoAndStop(1);
                        this.lastFlowerY = py;
                        this.lastFlowerX = px;
                        this.isReturnFlower = false;
                        this.rateOfReturn = 10;
                        _state = S_ATTACK;
                        this.forceFaceDirection(Util.sgn(param1.px - px));
                        this.flowerVelocity = 1;
                        this.flowerDirection = Util.sgn(param1.px - px);
                  }
            }
            
            public function flowerCooldown() : Number
            {
                  return this.flowerSpellCooldown.cooldown();
            }
            
            public function toggleRoot() : void
            {
                  this.shouldRoot = !this.shouldRoot;
                  this.isRooting = true;
                  if(this.shouldRoot)
                  {
                        this.rootFrame = 1;
                  }
                  else
                  {
                        this.rootFrame = 53;
                  }
                  this.team.game.soundManager.playSound("treeRootSound",px,py);
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:ScorpionElement = null;
                  var _loc4_:Flower = null;
                  var _loc5_:Number = NaN;
                  var _loc6_:Number = NaN;
                  var _loc7_:Number = NaN;
                  var _loc8_:Number = NaN;
                  var _loc9_:Number = NaN;
                  var _loc10_:Boolean = false;
                  var _loc11_:ScorpionElement = null;
                  this.flowerSpellCooldown.update();
                  stunTimeLeft = 0;
                  updateCommon(param1);
                  if(Boolean(this.isRooted))
                  {
                        if(!isDead && this.scorpionDeathTimes.length != 0 && mc.currentFrameLabel != "attack_1")
                        {
                              mc.spawnBar.scaleX = Math.min(1,(param1.frame - this.scorpionDeathTimes[0]) / this.respawnTime);
                              mc.spawnBar.visible = true;
                        }
                        else
                        {
                              mc.spawnBar.visible = false;
                        }
                  }
                  else
                  {
                        mc.spawnBar.visible = false;
                  }
                  if(timeAlive > 15)
                  {
                        mc.visible = true;
                  }
                  else
                  {
                        mc.visible = false;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < this.spawnlings.length)
                  {
                        _loc3_ = this.spawnlings[_loc2_];
                        if(_loc3_ == null || !_loc3_.isAlive() || _loc3_.parentTree != this)
                        {
                              this.spawnlings.splice(_loc2_,1);
                              this.scorpionDeathTimes.push(param1.frame);
                        }
                        _loc2_++;
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
                        else if(Boolean(this._isFlowerSpell) && !isDead)
                        {
                              if(this.isReturnFlower)
                              {
                                    if(param1.frame % Math.floor(this.rateOfReturn) == 0)
                                    {
                                          this.rateOfReturn -= 0.5;
                                          if(this.rateOfReturn < 2)
                                          {
                                                this.rateOfReturn = 2;
                                          }
                                          (_loc4_ = this.flowers.pop()).hasBloomed = true;
                                    }
                                    if(this.flowers.length == 0)
                                    {
                                          this._isFlowerSpell = false;
                                          this.isReturnFlower = false;
                                          _state = S_RUN;
                                          this.heal(this.healAmount,this.healDuration);
                                    }
                              }
                              else if(this.flowerSpellTarget == null || !this.flowerSpellTarget.isAlive())
                              {
                                    this._isFlowerSpell = false;
                              }
                              else if((param1.frame - this.flowerSpellStartFrame) % 2 == 0)
                              {
                                    _loc5_ = Math.sqrt(Math.pow(this.flowerSpellTarget.px - this.lastFlowerX,2) + Math.pow(this.flowerSpellTarget.py - this.lastFlowerY,2));
                                    _loc6_ = (this.flowerSpellTarget.px - this.lastFlowerX) / _loc5_;
                                    _loc7_ = (this.flowerSpellTarget.py - this.lastFlowerY) / _loc5_;
                                    _loc8_ = Number(this.flowerVelocity);
                                    this.flowerVelocity += 5;
                                    if(this.flowerVelocity > 70)
                                    {
                                          this.flowerVelocity = 70;
                                    }
                                    this.lastFlowerX += _loc6_ * _loc8_;
                                    this.lastFlowerY += _loc7_ * _loc8_;
                                    if((_loc9_ = Math.sqrt(Math.pow(this.flowerSpellTarget.px - this.lastFlowerX,2) + Math.pow(this.flowerSpellTarget.py - this.lastFlowerY,2))) > _loc5_ || Util.sgn(this.flowerSpellTarget.px - this.lastFlowerX) != this.flowerDirection)
                                    {
                                          this.isReturnFlower = true;
                                          if(this.flowerSpellTarget != null)
                                          {
                                                team.game.projectileManager.initThorn(this.flowerSpellTarget.px,this.flowerSpellTarget.py,this,this.flowerSpellTarget,team,this.damageAmount,this.stunAmount);
                                                team.game.soundManager.playSound("thornSound",px,py);
                                          }
                                    }
                                    else
                                    {
                                          this.flowers.push(param1.projectileManager.initFlower(this.lastFlowerX,this.lastFlowerY,team));
                                          team.game.soundManager.playSoundRandom("flowerSpawnSound",3,this.lastFlowerX,this.lastFlowerY);
                                    }
                                    this.flowerDirection = Util.sgn(this.flowerSpellTarget.px - this.lastFlowerX);
                              }
                        }
                        else if(this.isRooted() && !isDead)
                        {
                              this.forceFaceDirection(team.direction);
                              _loc10_ = false;
                              if(this.scorpionDeathTimes.length > 0)
                              {
                                    if(param1.frame - this.scorpionDeathTimes[0] > this.respawnTime)
                                    {
                                          this.scorpionDeathTimes.shift();
                                    }
                              }
                              if(this.scorpionDeathTimes.length + this.spawnlings.length < this.max_spawnlings)
                              {
                                    _loc10_ = true;
                              }
                              if(this.spawnlings.length < this.max_spawnlings && _loc10_)
                              {
                                    mc.gotoAndStop("attack_1");
                                    if(Math.floor(MovieClip(_mc.mc).totalFrames * 0.2) == MovieClip(_mc.mc).currentFrame)
                                    {
                                          this.spawnSkorpion();
                                    }
                              }
                              else
                              {
                                    mc.gotoAndStop("stand");
                                    _state = S_RUN;
                              }
                              if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                              {
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
                  }
                  else if(isDead == false)
                  {
                        isDead = true;
                        if(this.spawnlings.length > 0 && this.spawnlingsToKill.length == 0)
                        {
                              for each(_loc11_ in this.spawnlings)
                              {
                                    if(_loc11_.isAlive())
                                    {
                                          this.spawnlingsToKill.push(_loc11_);
                                    }
                              }
                        }
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
                  TreeElement.setItem(_tree(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
                  if(this.spawnlingsToKill.length > 0 && team.game.frame - this.lastSpawnKill > 15)
                  {
                        _loc2_ = 0;
                        while(_loc2_ < this.spawnlingsToKill.length)
                        {
                              (_loc11_ = ScorpionElement(this.spawnlingsToKill[_loc2_])).terminate();
                              _loc11_.damage(0,1000,null);
                              this.spawnlingsToKill.splice(_loc2_,1);
                              this.scorpionDeathTimes.push(param1.frame);
                              this.lastSpawnKill = team.game.frame;
                              _loc2_++;
                        }
                  }
                  if(this.isDieing && this.flowers.length > 0)
                  {
                        for each(_loc4_ in this.flowers)
                        {
                              _loc4_.hasBloomed = true;
                              trace("FLOWER BACK");
                              team.game.soundManager.playSound("flowerConvertSound",_loc4_.px,_loc4_.py);
                        }
                        this.flowers = [];
                  }
                  if(Boolean(this.isRooting) && Boolean(this.shouldRoot))
                  {
                        if(_mc.mc.treedirt)
                        {
                              ++this.rootFrame;
                              _mc.mc.treedirt.gotoAndStop(this.rootFrame);
                              if(this.rootFrame == 51)
                              {
                                    this.isRooting = false;
                              }
                        }
                  }
                  if(Boolean(this.isRooting) && !this.shouldRoot)
                  {
                        if(_mc.mc.treedirt)
                        {
                              ++this.rootFrame;
                              _mc.mc.treedirt.gotoAndStop(this.rootFrame);
                              if(this.rootFrame == 97)
                              {
                                    this.isRooting = false;
                              }
                        }
                  }
                  if(Boolean(this.shouldRoot) && !this.isRooting)
                  {
                        if(_mc.mc.treedirt)
                        {
                              _mc.mc.treedirt.gotoAndStop(52);
                        }
                  }
                  if(!this.shouldRoot && !this.isRooting)
                  {
                        if(_mc.mc.treedirt)
                        {
                              _mc.mc.treedirt.gotoAndStop(98);
                        }
                  }
                  if(this.isRooted())
                  {
                        this.mayWalkThrough = true;
                  }
                  else
                  {
                        this.mayWalkThrough = false;
                        if(this.spawnlings.length > 0 && this.spawnlingsToKill.length == 0)
                        {
                              for each(_loc11_ in this.spawnlings)
                              {
                                    if(_loc11_.isAlive())
                                    {
                                          this.spawnlingsToKill.push(_loc11_);
                                    }
                              }
                        }
                  }
            }
            
            public function isRooted() : Boolean
            {
                  return Boolean(this.shouldRoot) && !this.isRooting || !this.shouldRoot && Boolean(this.isRooting);
            }
            
            override protected function isAbleToWalk() : Boolean
            {
                  return this._state == S_RUN && !this.isRooted() && !this.shouldRoot && !this._isFlowerSpell;
            }
            
            private function spawnSkorpion() : void
            {
                  var _loc1_:ScorpionElement = null;
                  var _loc2_:AttackMoveCommand = null;
                  if(team.mana >= this.skorpionManaSpawnCost)
                  {
                        team.mana -= this.skorpionManaSpawnCost;
                        _loc1_ = team.game.unitFactory.getUnit(Unit.U_SCORPION_ELEMENT);
                        team.spawn(_loc1_,team.game);
                        _loc1_.x = _loc1_.px = px + this.getDirection() * 30;
                        _loc1_.y = _loc1_.py = py + 1;
                        _loc1_.dx = this.getDirection() * 5;
                        _loc1_.forceFaceDirection(this.getDirection());
                        _loc1_.parentTree = this;
                        this.spawnlings.push(_loc1_);
                        if(techTeam.tech.isResearched(Tech.TREE_POISON))
                        {
                              _loc1_.makeLevel2();
                        }
                        _loc2_ = new AttackMoveCommand(team.game);
                        _loc2_.type = UnitCommand.ATTACK_MOVE;
                        _loc2_.goalX = team.direction * 200 + px;
                        _loc2_.goalY = py;
                        _loc2_.realX = team.direction * 200 + px;
                        _loc2_.realY = py;
                        _loc1_.ai.setCommand(team.game,_loc2_);
                        team.game.soundManager.playSound("scorplingSpawnSound",px,py);
                  }
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  super.setActionInterface(param1);
                  param1.setAction(0,0,UnitCommand.FLOWER);
                  param1.setAction(1,0,UnitCommand.TREE_ROOT);
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
                  return false;
            }
            
            public function get isBlocking() : Boolean
            {
                  return this._isFlowerSpell;
            }
            
            public function set isBlocking(param1:Boolean) : void
            {
                  this._isFlowerSpell = param1;
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
