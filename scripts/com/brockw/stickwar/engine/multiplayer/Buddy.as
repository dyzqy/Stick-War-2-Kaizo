package com.brockw.stickwar.engine.multiplayer
{
   import com.smartfoxserver.v2.entities.data.*;
   
   public class Buddy extends buddyDisplayBox
   {
      
      public static const S_ONLINE:int = 0;
      
      public static const S_OFFLINE:int = 1;
      
      public static const S_AWAY:int = 2;
      
      public static const S_IN_GAME:int = 3;
       
      
      private var _name:String;
      
      private var _id:int;
      
      private var _statusType:int;
      
      private var _isTemp:Boolean;
      
      private var _chatHistory:String;
      
      public function Buddy()
      {
         super();
         this.chatHistory = "";
         this._name = "";
         this._id = -1;
         this._statusType = -1;
         this._isTemp = true;
         this.displayName.mouseEnabled = false;
         this.displayName.selectable = false;
         this.displayName.mouseEnabled = false;
      }
      
      public static function getStatuses() : Array
      {
         var _loc1_:Array = [S_ONLINE,S_OFFLINE,S_AWAY];
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_.push(statusFromCode(_loc1_[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function codeFromStatus(param1:String) : int
      {
         switch(param1)
         {
            case "Online":
               return S_ONLINE;
            case "Offline":
               return S_OFFLINE;
            case "Away":
               return S_AWAY;
            case "In Game":
               return S_IN_GAME;
            default:
               return -1;
         }
      }
      
      public static function statusFromCode(param1:int) : String
      {
         switch(param1)
         {
            case S_ONLINE:
               return "Online";
            case S_OFFLINE:
               return "Offline";
            case S_AWAY:
               return "Away";
            case S_IN_GAME:
               return "In Game";
            default:
               return "";
         }
      }
      
      override public function toString() : String
      {
         return this._name;
      }
      
      public function fromSFSObject(param1:ISFSObject) : void
      {
         this._name = param1.getUtfString("n");
         this._id = param1.getInt("id");
         this._statusType = param1.getInt("s");
         this._isTemp = false;
         this.displayName.text = this._name;
         this.status.gotoAndStop(Buddy.statusFromCode(this._statusType));
      }
      
      override public function get name() : String
      {
         return this._name;
      }
      
      override public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get statusType() : int
      {
         return this._statusType;
      }
      
      public function set statusType(param1:int) : void
      {
         this._statusType = param1;
         this.status.gotoAndStop(Buddy.statusFromCode(this._statusType));
      }
      
      public function get isTemp() : Boolean
      {
         return this._isTemp;
      }
      
      public function set isTemp(param1:Boolean) : void
      {
         this._isTemp = param1;
      }
      
      public function get chatHistory() : String
      {
         return this._chatHistory;
      }
      
      public function set chatHistory(param1:String) : void
      {
         this._chatHistory = param1;
      }
   }
}
