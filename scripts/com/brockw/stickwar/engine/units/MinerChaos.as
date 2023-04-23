package com.brockw.stickwar.engine.units
{
   import com.brockw.game.*;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.market.*;
   import flash.display.*;
   
   public class MinerChaos extends Miner
   {
      
      public static var WEAPON_REACH:int;
       
      
      private var oreInBag:int;
      
      private var bagSize:int;
      
      private var valueOfOre:Number;
      
      private var towerGoldCost:int;
      
      private var towerSpell:com.brockw.stickwar.engine.units.SpellCooldown;
      
      private var isConstructing:Boolean;
      
      private var buildX:Number;
      
      private var buildY:Number;
      
      private var towerConstructing:com.brockw.stickwar.engine.units.ChaosTower;
      
      private var wallConstructionTime:int;
      
      private var wallConstructionFrame:int;
      
      private var normalMaxVelocity:Number;
      
      private var upgradedMaxVelocity:Number;
      
      public function MinerChaos(param1:StickWar)
      {
         super(param1);
         removeChild(_mc);
         _mc = new _chaosminer();
         ai = new MinerAi(this);
         this.init(param1);
         addChild(_mc);
         initSync();
         firstInit();
         _interactsWith = Unit.I_MINE | Unit.I_STATUE | Unit.I_ENEMY;
         this.buildX = 0;
         this.buildY = 0;
         this.isConstructing = false;
         attackState = 0;
         wallConstructing = null;
      }
      
      public static function setItem(param1:MovieClip, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:_chaosminer = null;
         if((_loc5_ = _chaosminer(param1)).mc.minerbag)
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
         if(_loc5_.mc.head)
         {
            _loc5_.mc.head.gotoAndStop("Default");
         }
      }
      
      override public function weaponReach() : Number
      {
         return WEAPON_REACH;
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         this.isConstructing = false;
         WEAPON_REACH = param1.xml.xml.Chaos.miner.weaponReach;
         population = param1.xml.xml.Chaos.Units.miner.population;
         _mass = param1.xml.xml.Chaos.Units.miner.mass;
         _maxForce = param1.xml.xml.Chaos.Units.miner.maxForce;
         _dragForce = param1.xml.xml.Chaos.Units.miner.dragForce;
         _scale = param1.xml.xml.Chaos.Units.miner.scale;
         _maxVelocity = this.normalMaxVelocity = param1.xml.xml.Order.Units.miner.maxVelocity;
         this.upgradedMaxVelocity = param1.xml.xml.Order.Units.miner.upgradedMaxVelocity;
         this.createTime = param1.xml.xml.Chaos.Units.miner.cooldown;
         maxHealth = health = param1.xml.xml.Chaos.Units.miner.health;
         upgradedMaxHealth = param1.xml.xml.Order.Units.miner.upgradedHealth;
         loadDamage(param1.xml.xml.Chaos.Units.miner);
         type = Unit.U_CHAOS_MINER;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _state = S_RUN;
         this.bagSize = param1.xml.xml.Order.Units.miner.bagSize;
         normalBagSize = param1.xml.xml.Order.Units.miner.bagSize;
         upgradedBagSize = param1.xml.xml.Order.Units.miner.bagSizeUpgraded;
         this.oreInBag = 0;
         MovieClip(_mc.mc.gotoAndPlay(1));
         MovieClip(_mc.gotoAndStop(1));
         drawShadow();
         this.valueOfOre = 0;
         this.towerGoldCost = param1.xml.xml.Chaos.Units.miner.tower.gold;
         this.towerSpell = new com.brockw.stickwar.engine.units.SpellCooldown(param1.xml.xml.Chaos.Units.miner.tower.effect,param1.xml.xml.Chaos.Units.miner.tower.cooldown,param1.xml.xml.Chaos.Units.miner.tower.mana);
         this.towerConstructing = null;
         this.wallConstructionTime = param1.xml.xml.Chaos.Units.miner.tower.constructTime;
         this.wallConstructionFrame = 0;
      }
      
      override public function setBuilding() : void
      {
         building = team.buildings["BankBuilding"];
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
      
      public function buildTower(param1:Number, param2:Number) : void
      {
         if(!this.mayBuildTower(team,param1,param2))
         {
            return;
         }
         if(this.towerGoldCost < team.gold && techTeam.tech.isResearched(Tech.MINER_TOWER) && (!team.unitGroups.hasOwnProperty(Unit.U_CHAOS_TOWER) || team.unitGroups[Unit.U_CHAOS_TOWER].length < team.game.xml.xml.Chaos.maxTowers))
         {
            if(this.towerSpell.spellActivate(team))
            {
               team.gold -= this.towerGoldCost;
               this.isConstructing = true;
               this.buildX = param1;
               this.buildY = param2;
               this.attackState = 0;
               _mc.gotoAndStop("startAttack");
            }
         }
      }
      
      override public function stateFixForCutToWalk() : void
      {
         if(!this.isConstructing)
         {
            this._state = S_RUN;
            this.hasHit = true;
         }
      }
      
      override public function constructCooldown() : Number
      {
         return this.towerSpell.cooldown();
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
            health = health / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
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
               health += upgradedMaxHealth - maxHealth;
               maxHealth = upgradedMaxHealth;
               healthBar.totalHealth = maxHealth;
            }
         }
         updateCommon(param1);
         this.towerSpell.update();
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
               if(attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     attackState = 1;
                     _mc.gotoAndStop("building");
                     param1.soundManager.playSound("BuildChaosTower",px,py);
                  }
               }
               else if(attackState != 1)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     _state = S_RUN;
                     attackState = 0;
                  }
               }
               if(this.towerConstructing == null)
               {
                  this.towerConstructing = ChaosTower(param1.unitFactory.getUnit(int(Unit.U_CHAOS_TOWER)));
                  team.spawn(this.towerConstructing,param1);
                  this.towerConstructing.scaleX *= team.direction * -1;
                  this.towerConstructing.px = this.buildX;
                  this.towerConstructing.py = this.buildY;
                  trace("CREATED A WALL");
                  this.wallConstructionFrame = 0;
                  this.towerConstructing.setConstructionAmount(0);
               }
               else if(!this.towerConstructing.isAlive())
               {
                  this.isConstructing = false;
                  this.towerConstructing = null;
               }
               else
               {
                  ++this.wallConstructionFrame;
                  this.towerConstructing.setConstructionAmount(this.wallConstructionFrame / this.wallConstructionTime);
                  if(this.wallConstructionFrame / this.wallConstructionTime >= 1)
                  {
                     this.isConstructing = false;
                     this.towerConstructing = null;
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
               if(attackState == 0)
               {
                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                  {
                     attackState = 1;
                     _loc2_ = team.game.random.nextInt() % this._attackLabels.length;
                     _mc.gotoAndStop("attack_" + this._attackLabels[_loc2_]);
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
               else
               {
                  _loc5_ = MovieClip(_mc).currentFrameLabel;
                  Util.animateMovieClip(mc.mc);
                  if(_loc5_ != "bendDownToPray" && _loc5_ != "pray")
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
                  else if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
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
         if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
         {
            MovieClip(_mc.mc).gotoAndStop(1);
         }
         Util.animateMovieClip(_mc,0);
         if(param1.gameScreen is CampaignGameScreen)
         {
            setItem(_mc,"Default","Default","Bone Bag");
         }
         else if(!hasDefaultLoadout)
         {
            setItem(_mc,team.loadout.getItem(this.type,MarketItem.T_WEAPON),team.loadout.getItem(this.type,MarketItem.T_ARMOR),team.loadout.getItem(this.type,MarketItem.T_MISC));
         }
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
         if(techTeam.tech.isResearched(Tech.MINER_TOWER) && this.team == this.techTeam)
         {
            param1.setAction(0,0,UnitCommand.CONSTRUCT_TOWER);
         }
      }
      
      override protected function isAbleToWalk() : Boolean
      {
         return !this.isConstructing && _state != S_ATTACK;
      }
   }
}
