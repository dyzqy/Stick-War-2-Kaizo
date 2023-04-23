package com.brockw.stickwar.engine.units
{
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.Ai.MinerAi;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Gold;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.Team.Tech;
   import flash.display.MovieClip;
   
   public class Miner extends Unit
   {
      
      public static var WEAPON_REACH:int;
       
      
      private var oreInBag:int;
      
      private var bagSize:int;
      
      private var valueOfOre:Number;
      
      private var wallGoldCost:int;
      
      private var wallSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var isConstructing:Boolean;
      
      private var buildX:Number;
      
      private var buildY:Number;
      
      protected var normalBagSize:int;
      
      protected var upgradedBagSize:int;
      
      protected var wallConstructing:com.brockw.stickwar.engine.units.Wall;
      
      private var wallConstructionTime:int;
      
      private var wallConstructionFrame:int;
      
      protected var attackState:int;
      
      private var normalMaxVelocity:Number;
      
      private var upgradedMaxVelocity:Number;
      
      protected var upgradedMaxHealth:int;
      
      public function Miner(param1:StickWar)
      {
         super(param1);
         _mc = new _miner();
         ai = new MinerAi(this);
         this.init(param1);
         addChild(_mc);
         initSync();
         firstInit();
         _interactsWith = Unit.I_MINE | Unit.I_STATUE | Unit.I_ENEMY;
         this.buildX = 0;
         this.buildY = 0;
         this.isConstructing = false;
         this.attackState = 0;
         this.wallConstructing = null;
      }
      
      public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:_miner = null;
         if((_loc5_ = _miner(param1)).mc.minerbag)
         {
            if(param4 != "")
            {
               _loc5_.mc.minerbag.gotoAndStop(param4);
            }
         }
         if(_loc5_.mc.pick)
         {
            if(param2 != "")
            {
               _loc5_.mc.pick.gotoAndStop(param2);
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
         WEAPON_REACH = param1.xml.xml.Order.Units.miner.weaponReach;
         population = param1.xml.xml.Order.Units.miner.population;
         _mass = param1.xml.xml.Order.Units.miner.mass;
         _maxForce = param1.xml.xml.Order.Units.miner.maxForce;
         _dragForce = param1.xml.xml.Order.Units.miner.dragForce;
         _scale = param1.xml.xml.Order.Units.miner.scale;
         _maxVelocity = this.normalMaxVelocity = param1.xml.xml.Order.Units.miner.maxVelocity;
         this.upgradedMaxVelocity = param1.xml.xml.Order.Units.miner.upgradedMaxVelocity;
         this.createTime = param1.xml.xml.Order.Units.miner.cooldown;
         maxHealth = health = param1.xml.xml.Order.Units.miner.health;
         this.upgradedMaxHealth = param1.xml.xml.Order.Units.miner.upgradedHealth;
         this.wallConstructionTime = param1.xml.xml.Order.Units.miner.wall.constructionTime;
         loadDamage(param1.xml.xml.Order.Units.miner);
         type = Unit.U_MINER;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         this.bagSize = param1.xml.xml.Order.Units.miner.bagSize;
         this.normalBagSize = param1.xml.xml.Order.Units.miner.bagSize;
         this.oreInBag = 0;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.valueOfOre = 0;
         MinerAi(ai).isGoingForOre = true;
         MinerAi(ai).isUnassigned = true;
         this.wallGoldCost = param1.xml.xml.Order.Units.miner.wall.gold;
         this.wallSpell = new com.brockw.stickwar.engine.units.SpellCooldown(param1.xml.xml.Order.Units.miner.wall.effect,param1.xml.xml.Order.Units.miner.wall.cooldown,param1.xml.xml.Order.Units.miner.wall.mana);
         healthBar.totalHealth = maxHealth;
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.isConstructing)
         {
            this._state = S_RUN;
            this.hasHit = true;
         }
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BankBuilding"];
      }
      
      private function mayBuildWall(param1:Team, param2:Number, param3:Number) : Boolean
      {
         if(param1.direction * param2 < param1.direction * (param1.statue.px + param1.direction * 1.3 * param1.statue.width))
         {
            return false;
         }
         if(param1.direction * param2 > param1.direction * (param1.enemyTeam.statue.px + param1.direction * 1.3 * param1.enemyTeam.statue.width))
         {
            return false;
         }
         if(param1.direction * param2 > param1.direction * (param1.game.map.width / 2 - 600 * param1.direction))
         {
            return false;
         }
         return true;
      }
      
      public function buildWall(param1:Number, param2:Number) : void
      {
         if(!this.mayBuildWall(team,param1,param2))
         {
            return;
         }
         if(this.wallGoldCost <= team.gold && techTeam.tech.isResearched(Tech.MINER_WALL) && team.walls.length < team.game.xml.xml.Order.maxWalls)
         {
            if(this.wallSpell.spellActivate(team))
            {
               team.gold -= this.wallGoldCost;
               this.isConstructing = true;
               this.buildX = param1;
               this.buildY = param2;
               this.attackState = 0;
               _mc.gotoAndStop("startAttack");
            }
         }
      }
      
      public function constructCooldown() : Number
      {
         return this.wallSpell.cooldown();
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(team.isEnemy && !enemyBuffed)
         {
            _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
            _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
            health = Number(param1.xml.xml.Order.Units.miner.health) / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
            maxHealth = health;
            maxHealth = maxHealth;
            healthBar.totalHealth = maxHealth;
            _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
            enemyBuffed = true;
         }
         if(techTeam.tech.isResearched(Tech.MINER_SPEED))
         {
            if(this.maxHealth != this.upgradedMaxHealth)
            {
               health += this.upgradedMaxHealth - maxHealth;
               maxHealth = this.upgradedMaxHealth;
               healthBar.totalHealth = maxHealth;
            }
         }
         updateCommon(param1);
         this.wallSpell.update();
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
            else if(this.isConstructing)
            {
               if(this.attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     this.attackState = 1;
                     _mc.gotoAndStop("building");
                     param1.soundManager.playSound("BuildWall",px,py);
                  }
               }
               else if(this.attackState != 1)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     _state = S_RUN;
                     this.attackState = 0;
                  }
               }
               if(this.wallConstructing == null)
               {
                  this.wallConstructing = team.addWall(this.buildX);
                  this.wallConstructionFrame = 0;
                  this.wallConstructing.setConstructionAmount(0);
               }
               else if(!this.wallConstructing.isAlive())
               {
                  this.isConstructing = false;
                  this.wallConstructing = null;
               }
               else
               {
                  ++this.wallConstructionFrame;
                  this.wallConstructing.setConstructionAmount(this.wallConstructionFrame / this.wallConstructionTime);
                  if(this.wallConstructionFrame / this.wallConstructionTime >= 1)
                  {
                     this.isConstructing = false;
                     this.wallConstructing = null;
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
               if(this.attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     this.attackState = 1;
                     _loc2_ = team.game.random.nextInt() % this._attackLabels.length;
                     _mc.gotoAndStop("attack_" + this._attackLabels[_loc2_]);
                  }
               }
               else if(this.attackState == 1)
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
                     this.attackState = 2;
                     _mc.gotoAndStop("endAttack");
                  }
               }
               else if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
               {
                  _state = S_RUN;
                  this.attackState = 0;
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
                        _loc3_ = MinerAi(ai).targetOre.mine(param1.xml.xml.Order.Units.miner.miningRate,this);
                        this.oreInBag += _loc3_;
                        _loc4_ = Math.abs(MinerAi(ai).targetOre.x - px);
                        this.valueOfOre += _loc3_;
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
               else if((_loc5_ = MovieClip(_mc).currentFrameLabel) != "bendDownToPray" && _loc5_ != "pray")
               {
                  MovieClip(_mc).gotoAndStop("bendDownToPray");
               }
               else if(_loc5_ == "bendDownToPray")
               {
                  if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                  {
                     MovieClip(_mc).gotoAndStop("pray");
                  }
               }
               else
               {
                  if(param1.gameScreen.hasEffects)
                  {
                     Util.animateMovieClip(mc.mc);
                  }
                  if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                  {
                     MovieClip(_mc.mc).gotoAndStop(1);
                     this.oreInBag += MinerAi(ai).targetOre.mine(param1.xml.xml.Order.Units.miner.miningRate,this);
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
         if(isDead)
         {
            Util.animateMovieClip(_mc,0);
         }
         else
         {
            if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
            {
               MovieClip(_mc.mc).gotoAndStop(1);
            }
            MovieClip(_mc.mc).nextFrame();
         }
         if(team.isEnemy)
         {
            Miner.setItem(_mc,"Hammer","","Trolley");
         }
         else if(!techTeam.tech.isResearched(Tech.MINER_SPEED))
         {
            Miner.setItem(_mc,"Default","","Default");
         }
         else
         {
            Miner.setItem(_mc,"Ancient Pickaxe","","Wagon");
         }
      }
      
      public function isBagFull() : Boolean
      {
         return this.oreInBag >= this.bagSize;
      }
      
      public function mine() : void
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
      
      override public function attack() : void
      {
         var _loc1_:int = 0;
         if(_state != S_ATTACK || this.attackState == 2)
         {
            if(this.attackState == 0)
            {
               _mc.gotoAndStop("startAttack");
            }
            else
            {
               _loc1_ = team.game.random.nextInt() % this._attackLabels.length;
               _mc.gotoAndStop("attack_" + this._attackLabels[_loc1_]);
               attackStartFrame = team.game.frame;
               framesInAttack = MovieClip(_mc.mc).totalFrames;
               this.attackState = 1;
            }
            MovieClip(_mc.mc).gotoAndStop(1);
            _state = S_ATTACK;
            hasHit = false;
         }
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         super.setActionInterface(param1);
         if(techTeam.tech.isResearched(Tech.MINER_WALL) && this.team == this.techTeam)
         {
            param1.setAction(0,0,UnitCommand.CONSTRUCT_WALL);
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
         if(framesInAttack > team.game.frame - attackStartFrame)
         {
            return false;
         }
         if(_state == S_RUN || this.attackState == 2)
         {
            if(Math.abs(px - param1.px) < WEAPON_REACH && Math.abs(py - param1.py) < 40 && this.getDirection() == Util.sgn(param1.px - px))
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return !this.isConstructing && _state != S_ATTACK;
      }
   }
}
