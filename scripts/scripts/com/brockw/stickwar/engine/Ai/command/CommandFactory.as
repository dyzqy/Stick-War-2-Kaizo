package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.StickWar;
      import flash.utils.*;
      
      public class CommandFactory
      {
             
            
            private var commandMap:Dictionary;
            
            public function CommandFactory(param1:StickWar)
            {
                  super();
                  this.commandMap = new Dictionary();
                  this.commandMap[UnitCommand.MOVE] = MoveCommand;
                  this.commandMap[UnitCommand.ATTACK_MOVE] = AttackMoveCommand;
                  this.commandMap[UnitCommand.STAND] = StandCommand;
                  this.commandMap[UnitCommand.HOLD] = HoldCommand;
                  this.commandMap[UnitCommand.GARRISON] = GarrisonCommand;
                  this.commandMap[UnitCommand.UNGARRISON] = UnGarrisonCommand;
                  this.commandMap[UnitCommand.SWORDWRATH_RAGE] = SwordwrathRageCommand;
                  this.commandMap[UnitCommand.STUN] = StunCommand;
                  this.commandMap[UnitCommand.NUKE] = NukeCommand;
                  this.commandMap[UnitCommand.STEALTH] = StealthCommand;
                  this.commandMap[UnitCommand.HEAL] = HealCommand;
                  this.commandMap[UnitCommand.CURE] = CureCommand;
                  this.commandMap[UnitCommand.POISON_DART] = PoisonDartCommand;
                  this.commandMap[UnitCommand.SLOW_DART] = SlowDartCommand;
                  this.commandMap[UnitCommand.TECH] = TechCommand;
                  this.commandMap[UnitCommand.SPEARTON_BLOCK] = BlockCommand;
                  this.commandMap[UnitCommand.ARCHER_FIRE] = ArcherFireCommand;
                  this.commandMap[UnitCommand.FIST_ATTACK] = FistAttackCommand;
                  this.commandMap[UnitCommand.REAPER] = ReaperCommand;
                  this.commandMap[UnitCommand.WINGIDON_SPEED] = WingidonSpeedCommand;
                  this.commandMap[UnitCommand.SHIELD_BASH] = SpeartonShieldBashCommand;
                  this.commandMap[UnitCommand.KNIGHT_CHARGE] = ChargeCommand;
                  this.commandMap[UnitCommand.CAT_FURY] = CatFuryCommand;
                  this.commandMap[UnitCommand.CAT_PACK] = CatPackCommand;
                  this.commandMap[UnitCommand.DEAD_POISON] = DeadPoisonCommand;
                  this.commandMap[UnitCommand.NINJA_STACK] = NinjaStackCommand;
                  this.commandMap[UnitCommand.STONE] = StoneCommand;
                  this.commandMap[UnitCommand.POISON_POOL] = PoisonPoolCommand;
                  this.commandMap[UnitCommand.CONSTRUCT_TOWER] = ConstructTowerCommand;
                  this.commandMap[UnitCommand.CONSTRUCT_WALL] = ConstructWallCommand;
                  this.commandMap[UnitCommand.BOMBER_DETONATE] = BomberDetonateCommand;
                  this.commandMap[UnitCommand.REMOVE_WALL_COMMAND] = RemoveWallCommand;
                  this.commandMap[UnitCommand.REMOVE_TOWER_COMMAND] = RemoveTowerCommand;
                  this.commandMap[UnitCommand.WATER_HEAL] = WaterHealCommand;
                  this.commandMap[UnitCommand.COMBINE] = CombineCommand;
                  this.commandMap[UnitCommand.COMBINE_ALL] = CombineAllCommand;
                  this.commandMap[UnitCommand.FIRESTORM_NUKE] = FirestormCommand;
                  this.commandMap[UnitCommand.TELEPORT] = TeleportCommand;
                  this.commandMap[UnitCommand.SPLIT] = SplitCommand;
                  this.commandMap[UnitCommand.PROTECT] = ProtectCommand;
                  this.commandMap[UnitCommand.FIRE_BREATH] = FireBreathCommand;
                  this.commandMap[UnitCommand.CONVERT] = ConvertCommand;
                  this.commandMap[UnitCommand.HURRICANE] = HurricaneCommand;
                  this.commandMap[UnitCommand.MORPH_MINER] = MorphMinerCommand;
                  this.commandMap[UnitCommand.FLOWER] = FlowerCommand;
                  this.commandMap[UnitCommand.TREE_ROOT] = TreeRootCommand;
                  this.commandMap[UnitCommand.RADIANT_HEAT] = RadiantHeatCommand;
                  this.commandMap[UnitCommand.BURROW] = BurrowCommand;
                  this.commandMap[UnitCommand.UNBURROW] = UnBurrowCommand;
            }
            
            public function createCommand(param1:StickWar, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:Boolean = true) : UnitCommand
            {
                  var _loc11_:UnitCommand = null;
                  if(!(param2 in this.commandMap))
                  {
                        return null;
                  }
                  var _loc12_:Class;
                  (_loc11_ = new (_loc12_ = this.commandMap[param2])(param1)).team = param1.team;
                  _loc11_.goalX = param3;
                  _loc11_.goalY = param4;
                  _loc11_.realX = param5;
                  _loc11_.realY = param6;
                  _loc11_.isCancel = param7;
                  _loc11_.targetId = param9;
                  _loc11_.isGroup = param10;
                  if(_loc11_ == null)
                  {
                        throw new Error("Null command error: " + param2);
                  }
                  return _loc11_;
            }
      }
}
