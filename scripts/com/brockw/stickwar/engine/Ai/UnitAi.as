package com.brockw.stickwar.engine.Ai
{
   import com.brockw.ds.*;
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.Team.Elementals.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   
   public class UnitAi
   {
       
      
      protected var unit:Unit;
      
      private var _commandQueue:Queue;
      
      protected var _currentCommand:UnitCommand;
      
      private var defaultStandCommand:StandCommand;
      
      protected var _mayAttack:Boolean;
      
      protected var _mayMoveToAttack:Boolean;
      
      protected var _mayMove:Boolean;
      
      protected var isTargeted:Boolean;
      
      public var goalX:int;
      
      public var goalY:int;
      
      protected var intendedX:int;
      
      protected var _currentTarget:Unit;
      
      protected var lastCommand:UnitCommand;
      
      protected var isNonAttackingMage:Boolean;
      
      private var cachedTarget:Unit;
      
      private var lastCacheFrame:int;
      
      private var isSingleAttackCommand:Boolean;
      
      public function UnitAi()
      {
         super();
         this.currentCommand = this.defaultStandCommand = new StandCommand(null);
         this.commandQueue = new Queue(1000);
         this.isNonAttackingMage = false;
         this.lastCacheFrame = 0;
         this.init();
         this.isSingleAttackCommand = false;
         this.intendedX = 1;
      }
      
      public static function checkForMineAtCoordinate(param1:Team, param2:StickWar, param3:Number, param4:Number) : Ore
      {
         var _loc5_:String = null;
         var _loc6_:Ore = null;
         if(param1.statue.hitTest(param3,param4))
         {
            return param1.statue;
         }
         for(_loc5_ in param2.map.gold)
         {
            if((_loc6_ = param2.map.gold[_loc5_]).hitTest(param3,param4))
            {
               return param2.map.gold[_loc5_];
            }
         }
         return null;
      }
      
      public function init() : void
      {
         this.isTargeted = false;
         this.mayAttack = false;
         this.mayMoveToAttack = false;
         this.mayMove = false;
         this.currentTarget = null;
         this.lastCommand = null;
         this.goalX = 0;
         this.goalY = 0;
      }
      
      public function update(param1:StickWar) : void
      {
      }
      
      public function appendCommand(param1:StickWar, param2:UnitCommand) : void
      {
         this.commandQueue.push(param2);
      }
      
      public function setCommand(param1:StickWar, param2:UnitCommand) : void
      {
         this.commandQueue.clear();
         if(!this.unit.team.isAi == true)
         {
            if(!(this.currentCommand.type == UnitCommand.ATTACK_MOVE && param2.type == UnitCommand.ATTACK_MOVE) && (this.currentCommand.targetId != param2.targetId || param2.targetId == -1))
            {
               this.unit.stateFixForCutToWalk();
            }
         }
         this.lastCommand = this.currentCommand;
         this.currentCommand = param2;
         this.setParamatersFromCommand(param1);
      }
      
      public function elementalCombineMove() : Boolean
      {
         var _loc1_:Unit = null;
         var _loc2_:TeamElemental = null;
         var _loc3_:Unit = null;
         var _loc4_:Unit = null;
         var _loc5_:Unit = null;
         var _loc6_:Unit = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         if(this.unit.team.type == Team.T_ELEMENTAL && this._currentCommand.type == UnitCommand.COMBINE)
         {
            if(this.currentCommand.targetId in this.unit.team.game.units && this.unit.team.game.units[this.currentCommand.targetId] is Unit)
            {
               _loc1_ = this.unit.team.game.units[this.currentCommand.targetId];
               if(Boolean(this.unit.isAlive()) && _loc1_ != null && _loc1_.isAlive() && _loc1_.isTargetable() && _loc1_.ai.currentCommand.type == UnitCommand.COMBINE && _loc1_.ai.currentCommand.targetId == this.unit.id)
               {
                  this.unit.mayWalkThrough = false;
                  this.unit.walk((_loc1_.px - this.unit.px) / 100,(_loc1_.py - this.unit.py) / 100,Util.sgn(_loc1_.px - this.unit.px));
                  if(Math.abs(_loc1_.px - this.unit.px) < 50 && Math.abs(_loc1_.py - this.unit.py) < 50)
                  {
                     _loc2_ = TeamElemental(this.unit.team);
                     _loc2_.combine(this.unit,_loc1_);
                  }
               }
               else if(_loc1_ == null || _loc1_ != null && !_loc1_.isAlive())
               {
                  this.nextMove(this.unit.team.game);
               }
            }
            return true;
         }
         if(this.unit.team.type == Team.T_ELEMENTAL && this._currentCommand.type == UnitCommand.COMBINE_ALL)
         {
            _loc3_ = this.unit;
            _loc4_ = this.nextInCombineChain(_loc3_);
            _loc5_ = this.nextInCombineChain(_loc4_);
            _loc6_ = this.nextInCombineChain(_loc5_);
            if(_loc3_ == null || _loc4_ == null || _loc5_ == null || _loc6_ == null)
            {
               this.nextMove(this.unit.team.game);
               return false;
            }
            if(!_loc3_.isAlive() || !_loc4_.isAlive() || !_loc5_.isAlive() || !_loc6_.isAlive())
            {
               this.nextMove(this.unit.team.game);
               return false;
            }
            _loc7_ = (_loc3_.px + _loc4_.px + _loc5_.px + _loc6_.px) / 4;
            _loc8_ = (_loc3_.py + _loc4_.py + _loc5_.py + _loc6_.py) / 4;
            this.unit.walk((_loc7_ - this.unit.px) / 20,(_loc8_ - this.unit.py) / 20,Util.sgn(_loc7_ - this.unit.px));
            _loc9_ = 10000;
            if(_loc3_.sqrDistanceToTarget(_loc4_) < _loc9_ && _loc3_.sqrDistanceToTarget(_loc5_) < _loc9_ && _loc3_.sqrDistanceToTarget(_loc6_) < _loc9_)
            {
               _loc2_ = TeamElemental(this.unit.team);
               _loc2_.combineAll(_loc3_,_loc4_,_loc5_,_loc6_);
            }
            return true;
         }
         return false;
      }
      
      public function nextInCombineChain(param1:Unit) : Unit
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.ai._currentCommand.targetId in param1.team.game.units && this.unit.team.game.units[param1.ai._currentCommand.targetId] is Unit)
         {
            return this.unit.team.game.units[param1.ai._currentCommand.targetId];
         }
         return null;
      }
      
      protected function checkNextMove(param1:StickWar) : void
      {
         if(this.currentCommand.isFinished(this.unit))
         {
            if(this.currentCommand != this.defaultStandCommand)
            {
            }
            this.nextMove(param1);
         }
      }
      
      protected function restoreMove(param1:StickWar) : void
      {
         if(this.lastCommand == null)
         {
            this.currentCommand = this.defaultStandCommand;
         }
         else
         {
            this.currentCommand = this.lastCommand;
         }
         if(this.currentCommand.isToggle)
         {
            this.currentCommand = this.defaultStandCommand;
         }
         this.setParamatersFromCommand(param1,true);
      }
      
      protected function nextMove(param1:StickWar) : void
      {
         this.lastCommand = this.currentCommand;
         if(this.commandQueue.isEmpty())
         {
            this.currentCommand = this.defaultStandCommand;
            this.setParamatersFromCommand(param1);
         }
         else
         {
            this.currentCommand = UnitCommand(this.commandQueue.pop());
            this.setParamatersFromCommand(param1);
         }
      }
      
      public function baseUpdate(param1:StickWar) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this.checkNextMove(param1);
         var _loc2_:Unit = this.getClosestTarget();
         if(this.mayAttack && (Boolean(this.unit.mayAttack(_loc2_)) || _loc2_ is Wall && Math.abs(_loc2_.px - this.unit.px) < _loc2_.pwidth + this.unit.pwidth / 2))
         {
            if(_loc2_.damageWillKill(0,this.unit.getDamageToUnit(_loc2_)) && this.unit.getDirection() != _loc2_.getDirection() && this.unit.getDirection() == Util.sgn(_loc2_.px - this.unit.px))
            {
               if(!this.unit.startDual(_loc2_))
               {
                  this.unit.attack();
               }
            }
            else
            {
               this.unit.attack();
            }
         }
         else if(this.mayMoveToAttack && this.unit.sqrDistanceTo(_loc2_) < 640000 && !this.unit.isGarrisoned)
         {
            if(this.isNonAttackingMage)
            {
               if(Boolean(this.unit.team.isAi) || Boolean(this.isSingleAttackCommand))
               {
                  _loc3_ = 0;
                  if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                  {
                     _loc3_ = _loc2_.py - this.unit.py;
                  }
                  if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                  {
                     this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                  }
                  else
                  {
                     _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                     if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                     {
                        this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                     }
                     else
                     {
                        this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                     }
                  }
                  if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                  {
                     this.unit.faceDirection(_loc2_.px - this.unit.px);
                  }
               }
               else if(this.unit.sqrDistanceTo(_loc2_) > 50000)
               {
                  _loc3_ = 0;
                  if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
                  {
                     _loc3_ = _loc2_.py - this.unit.py;
                  }
                  _loc5_ = _loc2_.px;
                  if((this.unit.team.forwardUnitNotSpawn.px - 100 * this.unit.team.direction) * this.unit.team.direction < _loc5_ * this.unit.team.direction)
                  {
                     _loc5_ = this.unit.team.forwardUnitNotSpawn.px - 100 * this.unit.team.direction;
                  }
                  _loc6_ = _loc5_ - this.unit.px;
                  if(Util.sgn(_loc6_) != Util.sgn(_loc2_.px - this.unit.px))
                  {
                     _loc6_ = 0;
                  }
                  if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
                  {
                     this.unit.walk(_loc6_ / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                  }
                  else
                  {
                     _loc4_ = Util.sgn(_loc6_) * this.unit.weaponReach() * 0.5;
                     if(Math.abs(_loc6_) < this.unit.weaponReach() * 0.9)
                     {
                        this.unit.walk(0,_loc3_,Util.sgn(_loc6_));
                     }
                     else
                     {
                        this.unit.walk((_loc6_ - _loc4_) / 100,_loc3_,Util.sgn(_loc6_));
                     }
                  }
                  if(Math.abs(_loc6_ - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
                  {
                     this.unit.faceDirection(_loc6_);
                  }
               }
            }
            else
            {
               _loc3_ = 0;
               if(_loc2_.type != Unit.U_WALL && Math.abs(this.unit.px - _loc2_.px) < 200)
               {
                  if(Math.abs(this.unit.py - _loc2_.py) < 40)
                  {
                     _loc3_ = 0;
                  }
                  else
                  {
                     _loc3_ = _loc2_.py - this.unit.py;
                  }
               }
               if(Util.sgn(_loc2_.dx) == Util.sgn(this.unit.dx) && Math.abs(_loc2_.dx) > 1)
               {
                  this.unit.walk((_loc2_.px - this.unit.px) / 20,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
               }
               else
               {
                  _loc4_ = Util.sgn(_loc2_.px - this.unit.px) * this.unit.weaponReach() * 0.5;
                  if(Math.abs(_loc2_.px - this.unit.px) < this.unit.weaponReach() * 0.9)
                  {
                     this.unit.walk(0,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                  }
                  else
                  {
                     this.unit.walk((_loc2_.px - _loc4_ - this.unit.px) / 100,_loc3_,Util.sgn(_loc2_.px - this.unit.px));
                  }
               }
               if(Math.abs(_loc2_.px - this.unit.px - (this.unit.pwidth + _loc2_.pwidth) * 0.125 * this.unit.team.direction) < 10)
               {
                  this.unit.faceDirection(_loc2_.px - this.unit.px);
               }
            }
            this.unit.mayWalkThrough = false;
         }
         else if(this.mayMove)
         {
            this.unit.mayWalkThrough = false;
            this.unit.walk((this.goalX - this.unit.px) / 100,(this.goalY - this.unit.py) / 100,this.intendedX);
         }
         else if(_loc2_)
         {
            this.unit.faceDirection(_loc2_.px - this.unit.px);
         }
      }
      
      protected function checkForMines(param1:StickWar) : Ore
      {
         if(this.currentCommand is MoveCommand)
         {
            if(this.currentCommand.targetId in param1.units)
            {
               if(param1.units[this.currentCommand.targetId] is Gold || param1.units[this.currentCommand.targetId] is Statue)
               {
                  return param1.units[this.currentCommand.targetId];
               }
            }
         }
         return null;
      }
      
      protected function checkForUnitAttack(param1:StickWar) : Unit
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.currentCommand is MoveCommand)
         {
            _loc2_ = int(MoveCommand(this.currentCommand).realX);
            _loc3_ = int(MoveCommand(this.currentCommand).realY);
            if(_loc2_ * this.unit.team.direction < this.unit.team.direction * this.unit.team.homeX)
            {
               return null;
            }
            if(this.currentCommand.targetId in param1.units && param1.units[this.currentCommand.targetId] is Unit)
            {
               if(param1.units[this.currentCommand.targetId].team.id == this.unit.team.id)
               {
                  return null;
               }
               if(Boolean(param1.units[this.currentCommand.targetId].isFlying()) && !this.unit.canAttackAir())
               {
                  return null;
               }
               if(!param1.units[this.currentCommand.targetId].isFlying() && !this.unit.canAttackGround())
               {
                  return null;
               }
               if(!this.currentCommand.isGroup)
               {
                  this.isSingleAttackCommand = true;
               }
               else
               {
                  this.isSingleAttackCommand = false;
               }
               this.currentTarget = param1.units[this.currentCommand.targetId];
               this.intendedX = Util.sgn(this.currentTarget.x - this.unit.px);
               this.mayAttack = true;
               this.mayMoveToAttack = true;
               this.isTargeted = true;
               return param1.units[this.currentCommand.targetId];
            }
            this.isTargeted = false;
            return null;
         }
         return null;
      }
      
      private function setParamatersFromCommand(param1:StickWar, param2:Boolean = false) : void
      {
         this.isSingleAttackCommand = false;
         if(this.currentCommand.type == UnitCommand.STAND)
         {
            this.mayAttack = true;
            this.mayMoveToAttack = true;
            this.mayMove = false;
            this.unit.mayWalkThrough = false;
         }
         else if(this.currentCommand.type == UnitCommand.HOLD)
         {
            this.mayAttack = true;
            this.mayMoveToAttack = false;
            this.mayMove = false;
            this.unit.mayWalkThrough = false;
         }
         else if(this.currentCommand.type == UnitCommand.GARRISON)
         {
            this.mayAttack = false;
            this.mayMoveToAttack = false;
            this.mayMove = true;
            this.unit.mayWalkThrough = true;
            this.unit.garrison();
         }
         else if(this.currentCommand.type == UnitCommand.UNGARRISON)
         {
            this.unit.ungarrison();
            this.unit.mayWalkThrough = true;
            this.mayAttack = false;
            this.mayMoveToAttack = false;
            this.mayMove = true;
            this.goalX = this.unit.team.homeX + this.unit.team.direction * 200;
            this.intendedX = Util.sgn(this.goalX - this.unit.px);
         }
         else if(this.currentCommand.type == UnitCommand.MOVE)
         {
            this.unit.mayWalkThrough = false;
            this.mayAttack = false;
            this.mayMoveToAttack = false;
            this.mayMove = true;
            this.goalX = MoveCommand(this.currentCommand).goalX;
            this.intendedX = Util.sgn(this.goalX - this.unit.px);
            this.goalY = MoveCommand(this.currentCommand).goalY;
            if(this.goalX * this.unit.team.direction > this.unit.team.homeX * this.unit.team.direction)
            {
               this.unit.ungarrison();
            }
            this.currentTarget = this.checkForUnitAttack(param1);
            if(this.unit.type == Unit.U_MONK && this.currentTarget != null)
            {
               this.mayAttack = true;
               this.mayMoveToAttack = true;
               this.mayMove = true;
            }
            else if(this.unit.isMiner())
            {
               if(!this.unit.isGarrisoned)
               {
                  MinerAi(this).targetOre = this.checkForMines(param1);
                  if(MinerAi(this).targetOre is Statue)
                  {
                     MinerAi(this).isGoingForOre = false;
                  }
                  else
                  {
                     MinerAi(this).isGoingForOre = true;
                  }
               }
            }
         }
         else if(this.currentCommand.type == UnitCommand.ATTACK_MOVE)
         {
            this.unit.ungarrison();
            if(!this.unit.isMiner())
            {
               this.mayAttack = true;
               this.mayMoveToAttack = true;
               this.mayMove = true;
               this.goalX = AttackMoveCommand(this.currentCommand).goalX;
               this.intendedX = Util.sgn(this.goalX - this.unit.px);
               this.goalY = AttackMoveCommand(this.currentCommand).goalY;
               this.unit.mayWalkThrough = true;
            }
            else
            {
               if(this.unit.team.isAi == false && MinerAi(this).targetOre != null)
               {
                  MinerAi(this).targetOre = null;
               }
               this.mayAttack = true;
               this.mayMoveToAttack = true;
               this.mayMove = true;
               this.goalX = AttackMoveCommand(this.currentCommand).goalX;
               this.intendedX = Util.sgn(this.goalX - this.unit.px);
               this.goalY = AttackMoveCommand(this.currentCommand).goalY;
            }
         }
      }
      
      public function getClosestUnitTarget() : Unit
      {
         var _loc3_:* = undefined;
         var _loc4_:Unit = null;
         var _loc5_:Number = NaN;
         if(this.unit.team.enemyTeam.units.length == 0)
         {
            return this.unit.team.enemyTeam.statue;
         }
         var _loc1_:Number = Number.POSITIVE_INFINITY;
         if(this.currentTarget != null && (this.currentTarget.team == this.unit.team || !this.currentTarget.isAlive() || !Unit(this.currentTarget).isTargetable()))
         {
            _loc1_ = Number.POSITIVE_INFINITY;
            this.currentTarget = null;
         }
         if(this.currentTarget != null)
         {
            _loc1_ = Number(this.unit.sqrDistanceToTarget(this.currentTarget));
         }
         if(this.currentTarget != null && Boolean(this.isTargeted))
         {
            return this.currentTarget;
         }
         this.isTargeted = false;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = this.unit.team.game.random.nextInt() % this.unit.team.enemyTeam.units.length;
            if(!((_loc4_ = this.unit.team.enemyTeam.units[_loc3_]).pz != 0 && !this.unit.canAttackAir()))
            {
               if(!(!_loc4_.isFlying() && !this.unit.canAttackGround()))
               {
                  if((_loc5_ = Number(this.unit.sqrDistanceToTarget(_loc4_))) * 1.1 < _loc1_ && Boolean(Unit(this.unit.team.enemyTeam.units[_loc3_]).isTargetable()))
                  {
                     _loc1_ = _loc5_;
                     this.currentTarget = this.unit.team.enemyTeam.units[_loc3_];
                  }
               }
            }
            _loc2_++;
         }
         if(this.currentTarget == null)
         {
            return this.unit.team.enemyTeam.statue;
         }
         return this.currentTarget;
      }
      
      public function isFreezeable(param1:Unit) : Boolean
      {
         var _loc2_:LavaElement = null;
         if(param1.type == Unit.U_LAVA_ELEMENT)
         {
            _loc2_ = LavaElement(param1);
            return _loc2_.isFreezable();
         }
         return param1.type != Unit.U_GIANT && param1.type != Unit.U_ENSLAVED_GIANT;
      }
      
      public function getClosestUnitTargetToFreeze() : Unit
      {
         var _loc3_:* = undefined;
         var _loc4_:Unit = null;
         var _loc5_:Number = NaN;
         if(this.unit.team.enemyTeam.units.length == 0)
         {
            return null;
         }
         var _loc1_:Number = Number.POSITIVE_INFINITY;
         if(this.currentTarget != null && (!this.isFreezeable(this.currentTarget) || this.currentTarget.team == this.unit.team || !this.currentTarget.isAlive() || !Unit(this.currentTarget).isTargetable() || this.currentTarget.isFreezeLocked(this.unit)))
         {
            _loc1_ = Number.POSITIVE_INFINITY;
            this.currentTarget = null;
         }
         if(this.currentTarget != null)
         {
            _loc1_ = Number(this.unit.sqrDistanceToTarget(this.currentTarget));
         }
         if(this.currentTarget != null && Boolean(this.isTargeted))
         {
            return this.currentTarget;
         }
         this.isTargeted = false;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = this.unit.team.game.random.nextInt() % this.unit.team.enemyTeam.units.length;
            if(!((_loc4_ = this.unit.team.enemyTeam.units[_loc3_]).pz != 0 && !this.unit.canAttackAir()))
            {
               if(this.isFreezeable(_loc4_))
               {
                  if((_loc5_ = Number(this.unit.sqrDistanceToTarget(_loc4_))) * 1.3 < _loc1_ && Boolean(Unit(this.unit.team.enemyTeam.units[_loc3_]).isTargetable()) && !Unit(this.unit.team.enemyTeam.units[_loc3_]).isFreezeLocked(this.unit))
                  {
                     _loc1_ = _loc5_;
                     this.currentTarget = this.unit.team.enemyTeam.units[_loc3_];
                  }
               }
            }
            _loc2_++;
         }
         return this.currentTarget;
      }
      
      public function getClosestTarget() : Unit
      {
         var _loc2_:Wall = null;
         if(this.lastCacheFrame == this.unit.team.game.frame)
         {
            return this.cachedTarget;
         }
         var _loc1_:Unit = null;
         if(this.unit.type == Unit.U_WATER_ELEMENT)
         {
            _loc1_ = this.getClosestUnitTargetToFreeze();
         }
         else
         {
            _loc1_ = this.getClosestUnitTarget();
         }
         if(this.unit.type != Unit.U_WATER_ELEMENT)
         {
            for each(_loc2_ in this.unit.team.enemyTeam.walls)
            {
               if(this.unit.px < _loc2_.px && _loc2_.px < _loc1_.px)
               {
                  _loc1_ = _loc2_;
               }
               else if(this.unit.px > _loc2_.px && _loc2_.px > _loc1_.px)
               {
                  _loc1_ = _loc2_;
               }
            }
         }
         this.currentTarget = this.cachedTarget = _loc1_;
         this.lastCacheFrame = this.unit.team.game.frame;
         return _loc1_;
      }
      
      public function get commandQueue() : Queue
      {
         return this._commandQueue;
      }
      
      public function set commandQueue(param1:Queue) : void
      {
         this._commandQueue = param1;
      }
      
      public function cleanUp() : void
      {
         this.currentCommand = null;
         this.currentTarget = null;
      }
      
      public function get currentTarget() : Unit
      {
         return this._currentTarget;
      }
      
      public function set currentTarget(param1:Unit) : void
      {
         this._currentTarget = param1;
      }
      
      public function get mayAttack() : Boolean
      {
         return this._mayAttack;
      }
      
      public function set mayAttack(param1:Boolean) : void
      {
         this._mayAttack = param1;
      }
      
      public function get currentCommand() : UnitCommand
      {
         return this._currentCommand;
      }
      
      public function set currentCommand(param1:UnitCommand) : void
      {
         this._currentCommand = param1;
      }
      
      public function get mayMoveToAttack() : Boolean
      {
         return this._mayMoveToAttack;
      }
      
      public function set mayMoveToAttack(param1:Boolean) : void
      {
         this._mayMoveToAttack = param1;
      }
      
      public function get mayMove() : Boolean
      {
         return this._mayMove;
      }
      
      public function set mayMove(param1:Boolean) : void
      {
         this._mayMove = param1;
      }
   }
}
