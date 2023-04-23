package com.brockw.simulationSync
{
   import calista.util.*;
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.data.*;
   
   public class GameReplay
   {
      
      public static const checkSumFrequency:int = 1;
      
      public static const del2:String = "¢";
      
      public static const del3:String = "£";
      
      public static const del4:String = "¥";
      
      public static const del5:String = "¡";
      
      public static const del6:String = "¹";
       
      
      private var moves:Array;
      
      private var index:int;
      
      private var _isPlaying:Boolean;
      
      private var tempSFSObject:SFSObject;
      
      private var _teamAId:int;
      
      private var _teamBId:int;
      
      private var _teamAType:int;
      
      private var _teamBType:int;
      
      private var _teamAName:String;
      
      private var _teamBName:String;
      
      private var _teamAIsMember:Boolean;
      
      private var _teamBIsMember:Boolean;
      
      private var _teamALoadout:String;
      
      private var _teamBLoadout:String;
      
      private var _mapId:int;
      
      private var _gameType:int;
      
      private var _version:String;
      
      private var _seed:int;
      
      public function GameReplay()
      {
         super();
         this.moves = [];
         this.index = 0;
         this.seed = 0;
         this.isPlaying = false;
         this.tempSFSObject = new SFSObject();
         this._teamBLoadout = this._teamALoadout = "";
      }
      
      public function get seed() : int
      {
         return this._seed;
      }
      
      public function set seed(param1:int) : void
      {
         this._seed = param1;
      }
      
      public function get gameType() : int
      {
         return this._gameType;
      }
      
      public function set gameType(param1:int) : void
      {
         this._gameType = param1;
      }
      
      public function isFinished() : Boolean
      {
         return this.moves.length == 0;
      }
      
      public function play(param1:SimulationSyncronizer) : void
      {
         var _loc2_:Move = null;
         while(this.moves.length != 0)
         {
            _loc2_ = this.moves[0];
            if(_loc2_.turn != param1.turn - 1)
            {
               break;
            }
            param1.processMove(_loc2_);
            this.moves.shift();
            if(_loc2_.type == Move.END_OF_TURN)
            {
               _loc2_ = this.moves[0];
               if(_loc2_ != null && _loc2_.type == Commands.REPLAY_SYNC_CHECK)
               {
                  trace("replay check");
                  param1.processMove(_loc2_);
                  this.moves.shift();
               }
               break;
            }
         }
      }
      
      public function addSyncCheck(param1:SimulationSyncronizer) : void
      {
         var _loc3_:ReplaySyncCheckMove = null;
         var _loc2_:Simulation = param1.game;
         if(param1.turn % checkSumFrequency == 0)
         {
            _loc3_ = new ReplaySyncCheckMove();
            _loc3_.checkSum = _loc2_.getCheckSum();
            _loc3_.turn = param1.turn - 1;
            _loc3_.frame = param1.frame;
            Util.clearSFSObject(this.tempSFSObject);
            _loc3_.writeToSFSObject(this.tempSFSObject);
            this.moves.push(_loc3_);
         }
      }
      
      public function addMove(param1:Move, param2:SimulationSyncronizer) : void
      {
         if(param1 != null)
         {
            Util.clearSFSObject(this.tempSFSObject);
            param1.writeToSFSObject(this.tempSFSObject);
            this.moves.push(param1);
         }
      }
      
      public function toString(param1:StickWar) : String
      {
         var _loc7_:Move = null;
         var _loc2_:String = "";
         _loc2_ += int(param1.seed) + del2 + String(param1.gameType) + del2 + String(param1.mapId) + del2 + String(param1.teamA.id) + del2 + String(param1.teamA.originalType) + del2 + String(param1.teamA.realName) + del2 + (param1.teamA.isMember == true ? "1" : "0") + del2 + param1.teamA.loadout.toString() + del2 + String(param1.teamB.id) + del2 + String(param1.teamB.originalType) + del2 + String(param1.teamB.realName) + del2 + (param1.teamB.isMember == true ? "1" : "0") + del2 + param1.teamB.loadout.toString() + del3;
         var _loc3_:int = 0;
         var _loc4_:int;
         if((_loc4_ = this.moves.length - 1) >= 0)
         {
            while(Move(this.moves[_loc4_]).type == Commands.SCREEN_POSITION_UPDATE)
            {
               _loc3_++;
               _loc4_--;
            }
         }
         trace("Don\'t include ",_loc3_);
         var _loc5_:* = 0;
         while(_loc5_ < this.moves.length - _loc3_)
         {
            _loc7_ = this.moves[_loc5_];
            _loc2_ += String(_loc7_.type) + del4 + _loc7_.toString() + del5;
            _loc5_++;
         }
         _loc2_ = String(this.trim(_loc2_));
         _loc2_ = param1.main.xml.xml.version + del2 + _loc2_.length + del6 + _loc2_;
         var _loc6_:int = _loc2_.length;
         _loc2_ = String(LZW.compress(_loc2_));
         trace("Compressed to: " + _loc2_.length + " from " + _loc6_);
         return _loc2_;
      }
      
      private function trim(param1:String) : String
      {
         return param1.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm,"$2");
      }
      
      public function fromString(param1:String) : Boolean
      {
         var _loc12_:Move = null;
         var _loc13_:Array = null;
         param1 = String(this.trim(param1));
         var _loc2_:String = String(LZW.decompress(param1));
         var _loc3_:* = _loc2_.split(del6);
         var _loc5_:*;
         var _loc4_:String;
         if((_loc5_ = (_loc4_ = String(_loc3_[0])).split(del2)).length != 2)
         {
            return false;
         }
         var _loc6_:String = String(_loc5_[0]);
         this.version = _loc6_;
         var _loc7_:int = int(_loc5_[1]);
         if(_loc3_.length != 2)
         {
            return false;
         }
         if(_loc7_ != _loc3_[1].length)
         {
            trace("Replay broken",_loc7_,_loc3_[1].length);
            return false;
         }
         var _loc8_:Array;
         var _loc9_:Array = (_loc8_ = _loc3_[1].split(del3))[0].split(del2);
         this.seed = _loc9_.shift();
         this.gameType = _loc9_.shift();
         this.mapId = _loc9_.shift();
         this.teamAId = _loc9_.shift();
         this._teamAType = _loc9_.shift();
         this._teamAName = _loc9_.shift();
         this._teamAIsMember = int(_loc9_.shift()) == 1 ? true : false;
         this._teamALoadout = _loc9_.shift();
         this.teamBId = _loc9_.shift();
         this._teamBType = _loc9_.shift();
         this._teamBName = _loc9_.shift();
         this._teamBIsMember = int(_loc9_.shift()) == 1 ? true : false;
         this._teamBLoadout = _loc9_.shift();
         if(_loc8_.length != 2)
         {
            return false;
         }
         var _loc10_:Array = _loc8_[1].split(del5);
         var _loc11_:* = 0;
         while(_loc11_ < _loc10_.length - 1)
         {
            _loc13_ = _loc10_[_loc11_].split(del4);
            _loc12_ = MoveFactory.createMoveFromString(_loc13_[0],_loc13_[1].split(" "));
            this.moves.push(_loc12_);
            _loc11_++;
         }
         this.moves.sort(this.turnOrder);
         for each(_loc12_ in this.moves)
         {
         }
         return true;
      }
      
      private function turnOrder(param1:Move, param2:Move) : int
      {
         if(param1.turn == param2.turn)
         {
            if(param1.type == Commands.END_OF_TURN)
            {
               return -1;
            }
            if(param2.type == Commands.END_OF_TURN)
            {
               return 1;
            }
            if(param1.type == Commands.REPLAY_SYNC_CHECK)
            {
               return 1;
            }
            if(param2.type == Commands.REPLAY_SYNC_CHECK)
            {
               return -1;
            }
         }
         return param1.turn - param2.turn;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function set isPlaying(param1:Boolean) : void
      {
         this._isPlaying = param1;
      }
      
      public function get teamAId() : int
      {
         return this._teamAId;
      }
      
      public function set teamAId(param1:int) : void
      {
         this._teamAId = param1;
      }
      
      public function get teamBId() : int
      {
         return this._teamBId;
      }
      
      public function set teamBId(param1:int) : void
      {
         this._teamBId = param1;
      }
      
      public function get teamAType() : int
      {
         return this._teamAType;
      }
      
      public function set teamAType(param1:int) : void
      {
         this._teamAType = param1;
      }
      
      public function get teamBType() : int
      {
         return this._teamBType;
      }
      
      public function set teamBType(param1:int) : void
      {
         this._teamBType = param1;
      }
      
      public function get teamAName() : String
      {
         return this._teamAName;
      }
      
      public function set teamAName(param1:String) : void
      {
         this._teamAName = param1;
      }
      
      public function get teamBName() : String
      {
         return this._teamBName;
      }
      
      public function set teamBName(param1:String) : void
      {
         this._teamBName = param1;
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(param1:int) : void
      {
         this._mapId = param1;
      }
      
      public function get teamBLoadout() : String
      {
         return this._teamBLoadout;
      }
      
      public function set teamBLoadout(param1:String) : void
      {
         this._teamBLoadout = param1;
      }
      
      public function get teamALoadout() : String
      {
         return this._teamALoadout;
      }
      
      public function set teamALoadout(param1:String) : void
      {
         this._teamALoadout = param1;
      }
      
      public function get version() : String
      {
         return this._version;
      }
      
      public function set version(param1:String) : void
      {
         this._version = param1;
      }
      
      public function get teamAIsMember() : Boolean
      {
         return this._teamAIsMember;
      }
      
      public function set teamAIsMember(param1:Boolean) : void
      {
         this._teamAIsMember = param1;
      }
      
      public function get teamBIsMember() : Boolean
      {
         return this._teamBIsMember;
      }
      
      public function set teamBIsMember(param1:Boolean) : void
      {
         this._teamBIsMember = param1;
      }
   }
}
