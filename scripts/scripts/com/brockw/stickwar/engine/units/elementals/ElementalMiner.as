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
      
      public class ElementalMiner extends Miner
      {
            
            public static var WEAPON_REACH:int;
             
            
            private var oreInBag:int;
            
            private var bagSize:int;
            
            private var valueOfOre:Number;
            
            private var normalMaxVelocity:Number;
            
            private var crabGoldFrame:int;
            
            private var upgradedMaxVelocity:Number;
            
            private var _morphScale:Number;
            
            private var isMorphing:Boolean;
            
            public function ElementalMiner(param1:StickWar)
            {
                  super(param1);
                  removeChild(_mc);
                  _mc = new _minerElementMc();
                  ai = new ElementalMinerAi(this);
                  this.init(param1);
                  addChild(_mc);
                  initSync();
                  firstInit();
                  _interactsWith = Unit.I_MINE | Unit.I_STATUE | Unit.I_ENEMY;
                  attackState = 0;
                  this.crabGoldFrame = 1;
                  wallConstructing = null;
                  this.healthBar.scaleX = 1;
                  this.healthBar.scaleY = 0.9;
                  healthBar.y += 10;
                  this.isMorphing = false;
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_minerElementMc;
                  if((_loc5_ = _minerElementMc(param1)).mc.crabbody)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.crabbody.gotoAndStop(param3);
                        }
                  }
                  if(_loc5_.mc.head)
                  {
                        if(param4 != "")
                        {
                              _loc5_.mc.head.gotoAndStop(param4);
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
                  WEAPON_REACH = param1.xml.xml.Elemental.Units.miner.weaponReach;
                  this._morphScale = param1.xml.xml.Elemental.Units.miner.scale;
                  population = param1.xml.xml.Elemental.Units.miner.population;
                  _mass = param1.xml.xml.Order.Units.miner.mass;
                  _maxForce = param1.xml.xml.Order.Units.miner.maxForce;
                  _dragForce = param1.xml.xml.Order.Units.miner.dragForce;
                  _scale = param1.xml.xml.Elemental.Units.miner.scale;
                  _maxVelocity = this.normalMaxVelocity = param1.xml.xml.Order.Units.miner.maxVelocity;
                  this.createTime = param1.xml.xml.Elemental.Units.miner.cooldown;
                  maxHealth = health = param1.xml.xml.Elemental.Units.miner.health;
                  upgradedMaxHealth = param1.xml.xml.Order.Units.miner.upgradedHealth;
                  loadDamage(param1.xml.xml.Elemental.Units.miner);
                  type = Unit.U_MINER_ELEMENT;
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  this.bagSize = param1.xml.xml.Order.Units.miner.bagSize;
                  normalBagSize = param1.xml.xml.Order.Units.miner.bagSize;
                  this.oreInBag = 0;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
                  this.valueOfOre = 0;
                  this.isMorphing = false;
            }
            
            override public function isBusy() : Boolean
            {
                  return this.isMorphing;
            }
            
            override protected function isAbleToWalk() : Boolean
            {
                  return this._state == S_RUN && !this.isMorphing;
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["BarracksBuilding"];
            }
            
            private function mayBuildTower(param1:Team, param2:Number, param3:Number) : Boolean
            {
                  if(param1.direction * param2 < param1.direction * (param1.statue.px + param1.direction * 1.3 * param1.statue.width))
                  {
                        return false;
                  }
                  if(param1.direction * param2 > param1.direction * (param1.enemyTeam.statue.px + param1.direction * 1.3 * param1.enemyTeam.statue.width))
                  {
                        return false;
                  }
                  if(param1.direction * param2 > param1.direction * (param1.game.map.width / 2 - 400 * param1.direction))
                  {
                        return false;
                  }
                  if(param3 < 10 || param3 > param1.game.map.height - 10)
                  {
                        return false;
                  }
                  return true;
            }
            
            override public function stateFixForCutToWalk() : void
            {
                  this._state = S_RUN;
                  this.hasHit = true;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:Number = NaN;
                  var _loc3_:int = 0;
                  var _loc4_:* = undefined;
                  var _loc5_:Number = NaN;
                  var _loc6_:String = null;
                  var _loc7_:Number = NaN;
                  var _loc8_:int = 0;
                  var _loc9_:int = 0;
                  if(techTeam.tech.isResearched(Tech.MINER_SPEED))
                  {
                        if(this.maxHealth != this.upgradedMaxHealth)
                        {
                              health += upgradedMaxHealth - maxHealth;
                              maxHealth = upgradedMaxHealth;
                              healthBar.totalHealth = maxHealth;
                        }
                  }
                  updateCommon(param1);
                  if(!techTeam.tech.isResearched(Tech.MINER_SPEED))
                  {
                        _maxVelocity = this.normalMaxVelocity;
                  }
                  else
                  {
                        _maxVelocity = this.upgradedMaxVelocity;
                  }
                  if(Math.abs(team.homeX - x) < 220)
                  {
                        team.gold += this.valueOfOre;
                        this.valueOfOre = 0;
                        this.oreInBag = 0;
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
                                    px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                                    dx = 0;
                                    dy = 0;
                              }
                        }
                        else if(this.isMorphing)
                        {
                              _mc.gotoAndStop("transform");
                              _loc2_ = 1 * _mc.mc.currentFrame / _mc.mc.totalFrames;
                              _scale = this._morphScale * _loc2_ + _scale * (1 - _loc2_);
                              if(_mc.mc.currentFrame == _mc.mc.totalFrames - 1)
                              {
                                    this.isMorphing = false;
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
                              if(attackState == 0)
                              {
                                    if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                                    {
                                          attackState = 1;
                                          _loc3_ = team.game.random.nextInt() % this._attackLabels.length;
                                          _mc.gotoAndStop("attack_" + this._attackLabels[_loc3_]);
                                    }
                              }
                              else if(attackState == 1)
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
                                          attackState = 2;
                                          _mc.gotoAndStop("endAttack");
                                    }
                              }
                              else if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                              {
                                    _state = S_RUN;
                                    attackState = 0;
                              }
                        }
                        else if(_state == S_MINE)
                        {
                              if(MinerAi(ai).targetOre != null && MinerAi(ai).targetOre is Gold)
                              {
                                    if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames && !this.isBagFull())
                                    {
                                          if(MinerAi(ai).targetOre != null)
                                          {
                                                _loc4_ = MinerAi(ai).targetOre.mine(this.bagSize / 3,this);
                                                this.oreInBag += _loc4_;
                                                _loc5_ = Math.abs(MinerAi(ai).targetOre.x - px);
                                                this.valueOfOre += _loc4_;
                                                if(this.oreInBag > this.bagSize)
                                                {
                                                      this.oreInBag = this.bagSize;
                                                      this.valueOfOre = this.bagSize;
                                                }
                                                hasHit = true;
                                          }
                                    }
                                    if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                                    {
                                          _state = S_RUN;
                                    }
                              }
                              else
                              {
                                    _loc6_ = String(MovieClip(_mc).currentFrameLabel);
                                    Util.animateMovieClip(mc.mc);
                                    if(_loc6_ != "bendDownToPray" && _loc6_ != "pray")
                                    {
                                          MovieClip(_mc).gotoAndStop("bendDownToPray");
                                    }
                                    else if(_loc6_ == "bendDownToPray")
                                    {
                                          if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                                          {
                                                MovieClip(_mc).gotoAndStop("pray");
                                          }
                                    }
                                    else if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                                    {
                                          MovieClip(_mc.mc).gotoAndStop(1);
                                          if(MinerAi(ai).targetOre)
                                          {
                                                this.oreInBag += MinerAi(ai).targetOre.mine(param1.xml.xml.Order.Units.miner.miningRate,this);
                                          }
                                    }
                              }
                        }
                  }
                  else if(isDead == false)
                  {
                        isDead = true;
                        MinerAi(ai).targetOre = null;
                        if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.defendLabel);
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
                  Util.animateMovieClip(_mc,0);
                  if(_mc.mc.crabgold)
                  {
                        _mc.mc.crabgold.stop();
                        _loc7_ = this.oreInBag / this.bagSize;
                        _loc8_ = int(MovieClip(_mc.mc.crabgold).totalFrames);
                        _loc9_ = _loc7_ * _loc8_;
                        if(_mc.mc.crabgold.currentFrame < _loc9_)
                        {
                              this.crabGoldFrame += 1;
                        }
                        else
                        {
                              this.crabGoldFrame = _loc9_ + 1;
                        }
                        _mc.mc.crabgold.gotoAndStop(this.crabGoldFrame);
                  }
                  setItem(_mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
            }
            
            public function morph() : void
            {
                  this.isMorphing = true;
                  _scale = team.game.xml.xml.Elemental.Units.earthElement.scale * 1.05;
                  team.game.soundManager.playSound("minerTransformSound",px,py);
            }
            
            override public function isBagFull() : Boolean
            {
                  return this.oreInBag >= this.bagSize;
            }
            
            override public function mine() : void
            {
                  var _loc1_:int = 0;
                  if(_state != S_MINE)
                  {
                        _loc1_ = team.game.random.nextInt() % this._attackLabels.length;
                        _mc.gotoAndStop("mine");
                        MovieClip(_mc.mc).gotoAndStop(1);
                        _state = S_MINE;
                        hasHit = false;
                  }
            }
            
            override public function setActionInterface(param1:ActionInterface) : void
            {
                  setActionInterfaceBase(param1);
            }
      }
}
