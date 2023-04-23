package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.*;
   import com.smartfoxserver.v2.entities.data.*;
   
   public class UnitMove extends Move
   {
      
      private static const MAX_PER_COLUMN = 6;
       
      
      private var _type:int;
      
      private var _units:Array;
      
      private var _moveType:int;
      
      public var arg0:int;
      
      public var arg1:int;
      
      public var arg2:int;
      
      public var arg3:int;
      
      public var arg4:int;
      
      public var queued:Boolean;
      
      private var game:StickWar;
      
      public function UnitMove()
      {
         type = Commands.UNIT_MOVE;
         this.units = new Array();
         this.moveType = 0;
         this.queued = false;
         super();
         this.arg0 = 0;
         this.arg1 = 0;
         this.arg2 = 0;
         this.arg3 = -1;
         this.arg4 = -1;
      }
      
      public function get moveType() : int
      {
         return this._moveType;
      }
      
      public function set moveType(param1:int) : void
      {
         this._moveType = param1;
      }
      
      public function get units() : Array
      {
         return this._units;
      }
      
      public function set units(param1:Array) : void
      {
         this._units = param1;
      }
      
      override public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = super.toString();
         _loc1_ += String(this.units.length) + " ";
         for(_loc2_ in this._units)
         {
            _loc1_ += String(this._units[_loc2_]) + " ";
         }
         _loc1_ += String(this.moveType) + " ";
         _loc1_ += String(this.arg0) + " ";
         _loc1_ += String(this.arg1) + " ";
         _loc1_ += String(this.arg2) + " ";
         _loc1_ += String(this.arg3) + " ";
         _loc1_ += String(this.arg4) + " ";
         if(this.queued)
         {
            _loc1_ += String(1) + " ";
         }
         else
         {
            _loc1_ += String(0) + " ";
         }
         return _loc1_;
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         var _loc2_:int = int(param1.shift());
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            this.units.push(int(param1.shift()));
            _loc3_++;
         }
         this.moveType = int(param1.shift());
         this.arg0 = Number(param1.shift());
         this.arg1 = Number(param1.shift());
         this.arg2 = Number(param1.shift());
         this.arg3 = Number(param1.shift());
         this.arg4 = Number(param1.shift());
         this.queued = Boolean(int(param1.shift()));
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this.moveType = param1.getInt("m");
         var _loc2_:ISFSArray = param1.getSFSArray("u");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.size())
         {
            this.units.push(_loc2_.getElementAt(_loc3_));
            _loc3_++;
         }
         this.arg0 = param1.getInt("0");
         this.arg1 = param1.getInt("1");
         this.arg2 = param1.getInt("2");
         this.arg3 = param1.getInt("3");
         this.arg4 = param1.getInt("4");
         this.queued = param1.getBool("q");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         var _loc3_:String = null;
         writeBasicsSFSObject(param1);
         var _loc2_:SFSArray = new SFSArray();
         for(_loc3_ in this._units)
         {
            _loc2_.addInt(this._units[_loc3_]);
         }
         param1.putSFSArray("u",_loc2_);
         param1.putInt("m",this.moveType);
         param1.putInt("0",this.arg0);
         param1.putInt("1",this.arg1);
         param1.putInt("2",this.arg2);
         param1.putInt("3",this.arg3);
         param1.putInt("4",this.arg4);
         param1.putBool("q",this.queued);
      }
      
      private function formationOrder(param1:int, param2:int) : Number
      {
         if(Unit(this.game.units[param1]) == null)
         {
            return -1;
         }
         if(Unit(this.game.units[param2]) == null)
         {
            return 1;
         }
         if(Unit(this.game.units[param1]).type != Unit(this.game.units[param2]).type)
         {
            return Unit(this.game.units[param2]).type - Unit(this.game.units[param1]).type;
         }
         return Unit(this.game.units[param1]).id - Unit(this.game.units[param2]).id;
      }
      
      private function mapRowsToInside(param1:int, param2:int) : int
      {
         return Math.floor((param2 - 1) / 2) + (param1 % 2 * 2 - 1) * Math.ceil(param1 / 2);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc3_:Team = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:StickWar = null;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:String = null;
         var _loc2_:StickWar = StickWar(param1);
         if(this.moveType == UnitCommand.TECH)
         {
            _loc3_ = StickWar(param1).teamA;
            if(_loc3_.id != this.arg1)
            {
               _loc3_ = _loc3_.enemyTeam;
            }
            if(!_loc3_.tech.isResearching(this.arg0))
            {
               _loc3_.tech.startResearching(this.arg0);
            }
            else if(this.arg2 == 1)
            {
               _loc3_.tech.cancelResearching(this.arg0);
            }
         }
         else if(this.moveType == UnitCommand.MOVE || this.moveType == UnitCommand.ATTACK_MOVE)
         {
            this.game = StickWar(param1);
            this._units.sort(this.formationOrder);
            _loc4_ = int(this._units.length);
            _loc5_ = 50;
            _loc6_ = this.arg0;
            _loc7_ = 0;
            while(_loc7_ < this._units.length)
            {
               if(this._units[_loc7_] in _loc2_.units)
               {
                  _loc8_ = _loc7_ / MAX_PER_COLUMN;
                  _loc9_ = _loc7_ % MAX_PER_COLUMN;
                  _loc10_ = Math.min(StickWar(param1).map.height,Math.max(0,this.arg1));
                  _loc11_ = Math.min(MAX_PER_COLUMN,this._units.length - Math.floor(_loc7_ / MAX_PER_COLUMN) * MAX_PER_COLUMN);
                  _loc9_ = int(this.mapRowsToInside(_loc9_,_loc11_));
                  _loc12_ = Math.round(_loc10_ / (StickWar(param1).map.height / MAX_PER_COLUMN));
                  _loc13_ = Math.floor((_loc11_ + 1) / 2);
                  if((_loc14_ = _loc12_ - _loc13_) < 0)
                  {
                     _loc14_ = 0;
                  }
                  if(_loc14_ + _loc11_ > MAX_PER_COLUMN)
                  {
                     _loc14_ = MAX_PER_COLUMN - _loc11_;
                  }
                  _loc9_ += _loc14_;
                  _loc16_ = _loc15_ = int(StickWar(param1).map.height);
                  _loc17_ = StickWar(param1);
                  if((_loc18_ = -Unit(_loc2_.units[this._units[_loc7_]]).team.direction * _loc9_ * 8 + -_loc8_ * _loc5_ * Unit(_loc2_.units[this._units[_loc7_]]).team.direction + _loc6_) < _loc17_.teamA.homeX || _loc18_ > _loc17_.teamB.homeX || _loc2_.units[this._units[_loc7_]].px < _loc17_.teamA.homeX || _loc2_.units[this._units[_loc7_]].px > _loc17_.teamB.homeX)
                  {
                     _loc16_ /= 3;
                  }
                  _loc19_ = (_loc15_ - _loc16_) / 2 + _loc16_ / (2 * MAX_PER_COLUMN) + _loc9_ * _loc16_ / MAX_PER_COLUMN;
                  if(this._units.length == 1)
                  {
                     _loc19_ = _loc10_;
                  }
                  _loc19_ = Math.min((_loc15_ - _loc16_) / 2 + _loc16_,Math.max((_loc15_ - _loc16_) / 2,_loc19_));
                  if(!(_loc2_.units[this._units[_loc7_]] is Unit && !Unit(_loc2_.units[this._units[_loc7_]]).isInteractable))
                  {
                     if(this.queued)
                     {
                        Unit(_loc2_.units[this._units[_loc7_]]).ai.appendCommand(StickWar(param1),StickWar(param1).commandFactory.createCommand(_loc2_,this.moveType,_loc18_,_loc19_,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4,this._units.length > 1 ? true : false));
                     }
                     else
                     {
                        Unit(_loc2_.units[this._units[_loc7_]]).ai.setCommand(StickWar(param1),StickWar(param1).commandFactory.createCommand(_loc2_,this.moveType,_loc18_,_loc19_,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4,this._units.length > 1 ? true : false));
                     }
                  }
               }
               _loc7_++;
            }
         }
         else
         {
            for(_loc20_ in this._units)
            {
               if(this._units[_loc20_] in _loc2_.units)
               {
                  if(!(_loc2_.units[this._units[_loc20_]] is Unit && !Unit(_loc2_.units[this._units[_loc20_]]).isInteractable))
                  {
                     if(this.queued)
                     {
                        Unit(_loc2_.units[this._units[_loc20_]]).ai.appendCommand(StickWar(param1),StickWar(param1).commandFactory.createCommand(_loc2_,this.moveType,_loc18_,_loc19_,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4));
                     }
                     else
                     {
                        Unit(_loc2_.units[this._units[_loc20_]]).ai.setCommand(StickWar(param1),StickWar(param1).commandFactory.createCommand(_loc2_,this.moveType,_loc18_,_loc19_,this.arg0,this.arg1,this.arg2,this.arg3,this.arg4));
                     }
                  }
               }
            }
         }
      }
   }
}
