package com.brockw.stickwar.engine.units
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.market.*;
      import flash.display.*;
      import flash.geom.*;
      
      public class FlyingCrossbowman extends RangedUnit
      {
            
            private static var WEAPON_REACH:int;
             
            
            private var bowFrame:int;
            
            private var fireDamage:Number;
            
            private var fireFrames:int;
            
            public function FlyingCrossbowman(param1:StickWar)
            {
                  super(param1);
                  _mc = new _flyingcrossbowmanMc();
                  this.init(param1);
                  addChild(_mc);
                  ai = new FlyingCrossbowmanAi(this);
                  initSync();
                  firstInit();
                  this.bowFrame = 1;
            }
            
            public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
            {
                  var _loc5_:_flyingcrossbowmanMc = null;
                  if((_loc5_ = _flyingcrossbowmanMc(param1)).mc.body)
                  {
                        if(_loc5_.mc.body.head)
                        {
                              if(param3 != "")
                              {
                                    _loc5_.mc.body.head.gotoAndStop(param3);
                              }
                        }
                        if(_loc5_.mc.body.quiver)
                        {
                              if(param2 != "")
                              {
                                    _loc5_.mc.body.quiver.gotoAndStop(param2);
                              }
                        }
                  }
                  if(_loc5_.mc.head)
                  {
                        if(param3 != "")
                        {
                              _loc5_.mc.head.gotoAndStop(param3);
                        }
                  }
                  if(_loc5_.mc.wings)
                  {
                        if(param4 != "")
                        {
                              _loc5_.mc.wings.avadonwing.gotoAndStop(param4);
                              _loc5_.mc.wings.avadonebackwing.gotoAndStop(param4);
                        }
                  }
            }
            
            override public function init(param1:StickWar) : void
            {
                  initBase();
                  this.projectileVelocity = param1.xml.xml.Order.Units.flyingCrossbowman.arrowVelocity;
                  population = param1.xml.xml.Order.Units.flyingCrossbowman.population;
                  _mass = param1.xml.xml.Order.Units.flyingCrossbowman.mass;
                  _maxForce = param1.xml.xml.Order.Units.flyingCrossbowman.maxForce;
                  _dragForce = param1.xml.xml.Order.Units.flyingCrossbowman.dragForce;
                  _scale = param1.xml.xml.Order.Units.flyingCrossbowman.scale;
                  this.createTime = param1.xml.xml.Order.Units.flyingCrossbowman.cooldown;
                  _maxVelocity = param1.xml.xml.Order.Units.flyingCrossbowman.maxVelocity;
                  _maximumRange = param1.xml.xml.Order.Units.flyingCrossbowman.maximumRange;
                  maxHealth = health = param1.xml.xml.Order.Units.flyingCrossbowman.health;
                  this.fireDamage = param1.xml.xml.Order.Units.flyingCrossbowman.fireDamage;
                  this.fireFrames = param1.xml.xml.Order.Units.flyingCrossbowman.fireFrames;
                  type = Unit.U_FLYING_CROSSBOWMAN;
                  flyingHeight = 250 * 1;
                  loadDamage(param1.xml.xml.Order.Units.flyingCrossbowman);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _hitBoxWidth = 25;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  py = 0;
                  pz = -flyingHeight * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
                  y = -100;
                  if(param1 != null)
                  {
                        MovieClip(mc.mc.wings).gotoAndPlay(Math.floor(MovieClip(mc.mc.wings).totalFrames * param1.random.nextNumber()));
                  }
                  drawShadow();
                  this.healthBar.y = -mc.mc.height * 1.1;
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["ArcheryBuilding"];
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:MovieClip = null;
                  super.update(param1);
                  if(team.isEnemy && !enemyBuffed)
                  {
                        _damageToNotArmour = _damageToNotArmour / 2.5 * team.game.main.campaign.difficultyLevel + 1;
                        _damageToArmour = _damageToArmour / 2.5 * team.game.main.campaign.difficultyLevel + 1;
                        health = Number(param1.xml.xml.Order.Units.flyingCrossbowman.health) / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
                        maxHealth = health;
                        maxHealth = maxHealth;
                        healthBar.totalHealth = maxHealth;
                        _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
                        enemyBuffed = true;
                  }
                  if(_mc.mc.bow != null)
                  {
                        _mc.mc.bow.rotation = bowAngle + 12;
                  }
                  else if(_mc.mc.body != null && _mc.mc.body.arms)
                  {
                        _mc.mc.body.arms.rotation = bowAngle + 12;
                  }
                  updateCommon(param1);
                  if(_mc.mc.body != null && _mc.mc.body.legs != null)
                  {
                        _mc.mc.body.legs.rotation = getDirection() * _dx / _maxVelocity * param1.xml.xml.Order.Units.flyingCrossbowman.legRotateAngleWhenFlying;
                        MovieClip(mc.mc.body.legs).nextFrame();
                        if(MovieClip(mc.mc.body.legs).currentFrame == MovieClip(mc.mc.body.legs).totalFrames)
                        {
                              MovieClip(mc.mc.body.legs).gotoAndStop(1);
                        }
                  }
                  if(mc.mc.wings != null)
                  {
                        MovieClip(mc.mc.wings).nextFrame();
                        if(MovieClip(mc.mc.wings).currentFrame == MovieClip(mc.mc.wings).totalFrames)
                        {
                              MovieClip(mc.mc.wings).gotoAndStop(1);
                        }
                  }
                  if(!isDieing)
                  {
                        updateMotion(param1);
                        _loc2_ = _mc.mc.body.arms;
                        if(_loc2_ != null)
                        {
                              _loc2_.gotoAndStop(this.bowFrame);
                              if(this.bowFrame != _loc2_.totalFrames)
                              {
                                    _loc2_.nextFrame();
                                    ++this.bowFrame;
                              }
                        }
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
                        else if(_state == S_RUN)
                        {
                              if(isFeetMoving())
                              {
                              }
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(MovieClip(_mc.mc).currentFrame > MovieClip(_mc.mc).totalFrames / 2 && !hasHit)
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
                  if(!isDead && _mc.mc.wings != null)
                  {
                        MovieClip(_mc.mc).gotoAndStop(_mc.mc.wings.currentFrame);
                  }
                  if(isDead)
                  {
                        Util.animateMovieClip(_mc,3);
                        MovieClip(_mc.mc.wings).gotoAndStop(1);
                        if(_mc.mc.body != null && _mc.mc.body.quiver != null)
                        {
                              MovieClip(_mc.mc.body.quiver).gotoAndStop(1);
                        }
                        else if(_mc.mc.quiver != null)
                        {
                              MovieClip(_mc.mc.quiver).gotoAndStop(1);
                        }
                        if(_mc.mc.arms != null)
                        {
                              _mc.mc.arms.gotoAndStop(1);
                        }
                  }
                  if(!hasDefaultLoadout)
                  {
                        FlyingCrossbowman.setItem(mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
                  }
            }
            
            override public function get damageToArmour() : Number
            {
                  if(team.tech.isResearchedMap[Tech.CROSSBOW_FIRE])
                  {
                        return _damageToArmour + int(team.game.xml.xml.Order.Units.flyingCrossbowman.fireDamageToArmour);
                  }
                  return _damageToArmour;
            }
            
            override public function get damageToNotArmour() : Number
            {
                  if(team.tech.isResearchedMap[Tech.CROSSBOW_FIRE])
                  {
                        return _damageToArmour + int(team.game.xml.xml.Order.Units.flyingCrossbowman.fireDamageToNotArmour);
                  }
                  return _damageToNotArmour;
            }
            
            override public function shoot(param1:StickWar, param2:Unit) : void
            {
                  var _loc3_:MovieClip = null;
                  var _loc4_:Point = null;
                  if(_state != S_ATTACK)
                  {
                        _loc3_ = _mc.mc.body.arms;
                        if(_loc3_.currentFrame != _loc3_.totalFrames)
                        {
                              return;
                        }
                        _loc3_.gotoAndStop(1);
                        this.bowFrame = 1;
                        _loc4_ = _loc3_.localToGlobal(new Point(0,0));
                        _loc4_ = param1.battlefield.globalToLocal(_loc4_);
                        param1.soundManager.playSoundRandom("launchArrow",4,px,py);
                        if(mc.scaleX < 0)
                        {
                              param1.projectileManager.initBolt(_loc4_.x,_loc4_.y,180 - bowAngle,projectileVelocity,param2.py,angleToTargetW(param2,projectileVelocity,angleToTarget(param2)),this,20,30 * 4,techTeam.tech.isResearched(Tech.CROSSBOW_FIRE),param2,this.fireDamage,this.fireFrames);
                        }
                        else
                        {
                              param1.projectileManager.initBolt(_loc4_.x,_loc4_.y,bowAngle,projectileVelocity,param2.py,angleToTargetW(param2,projectileVelocity,angleToTarget(param2)),this,20,30 * 4,techTeam.tech.isResearched(Tech.CROSSBOW_FIRE),param2,this.fireDamage,this.fireFrames);
                        }
                  }
            }
      }
}
