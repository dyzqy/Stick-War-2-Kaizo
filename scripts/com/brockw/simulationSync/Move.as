package com.brockw.simulationSync
{
   import com.brockw.ds.Comparable;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class Move implements Comparable
   {
      
      public static const END_OF_TURN:int = 0;
       
      
      private var _type:int;
      
      private var _frame:int;
      
      private var _owner:int;
      
      private var _turn:int;
      
      public var position:int;
      
      public function Move()
      {
         super();
      }
      
      public function init(param1:int, param2:int, param3:int) : void
      {
         this._owner = param1;
         this._frame = param2;
         this._turn = param3;
      }
      
      public function compare(param1:Object) : int
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.type == Commands.REPLAY_SYNC_CHECK)
         {
            return -1;
         }
         if(param1.type == Commands.REPLAY_SYNC_CHECK)
         {
            return 1;
         }
         if(this.frame == param1.frame)
         {
            if(this.owner == param1.owner)
            {
               _loc2_ = this.toString();
               _loc3_ = String(param1.toString());
               if(_loc2_ < _loc3_)
               {
                  return -1;
               }
               if(_loc2_ == _loc3_)
               {
                  return 0;
               }
               return 1;
            }
            return this.owner - param1.owner;
         }
         return this.frame - param1.frame;
      }
      
      public function readFromSFSObject(param1:SFSObject) : void
      {
      }
      
      public function writeToSFSObject(param1:SFSObject) : void
      {
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += String(this._owner) + " ";
         _loc1_ += String(this._frame) + " ";
         _loc1_ += String(this._turn) + " ";
         return _loc1_ + (String(this.type) + " ");
      }
      
      public function fromString(param1:Array) : Boolean
      {
         this._owner = int(param1.shift());
         this._frame = int(param1.shift());
         this._turn = int(param1.shift());
         this.type = int(param1.shift());
         return true;
      }
      
      protected function writeBasicsSFSObject(param1:SFSObject) : void
      {
         param1.putInt("owner",this._owner);
         param1.putInt("frame",this._frame);
         param1.putInt("turn",this._turn);
         param1.putInt("type",this.type);
      }
      
      protected function readBasicsSFSObject(param1:SFSObject) : void
      {
         this._owner = param1.getInt("owner");
         this._frame = param1.getInt("frame");
         this._turn = param1.getInt("turn");
         this._type = param1.getInt("type");
      }
      
      public function execute(param1:Simulation) : void
      {
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get owner() : int
      {
         return this._owner;
      }
      
      public function set owner(param1:int) : void
      {
         this._owner = param1;
      }
      
      public function get turn() : int
      {
         return this._turn;
      }
      
      public function set turn(param1:int) : void
      {
         this._turn = param1;
      }
   }
}
