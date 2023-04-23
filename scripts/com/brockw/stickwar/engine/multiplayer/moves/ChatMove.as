package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.Team;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.utils.*;
   
   public class ChatMove extends Move
   {
       
      
      private var _message:String;
      
      public function ChatMove()
      {
         type = Commands.CHAT_MOVE;
         this.message = "";
         super();
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(param1:String) : void
      {
         if(param1.length > 200)
         {
            param1 = param1.slice(0,200);
         }
         this._message = param1;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         var _loc2_:* = "[";
         _loc2_ += "" + GameReplay.del2;
         _loc2_ += "" + GameReplay.del3;
         _loc2_ += "" + GameReplay.del4;
         _loc2_ += "" + GameReplay.del5;
         _loc2_ += "" + GameReplay.del6;
         _loc2_ += "]";
         trace("REGEXP: " + _loc2_);
         this.message = this.message.replace(new RegExp(_loc2_,"g"),"g");
         _loc1_ += String(this.message) + " ";
         trace("SEND",this.message);
         return _loc1_;
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this.message = String(param1.join(" "));
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_ = param1.getByteArray("message");
         this.message = _loc2_.readMultiByte(_loc2_.length,"iso-8859-1");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeMultiByte(this.message,"iso-8859-1");
         param1.putByteArray("message",_loc2_);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc2_:StickWar = StickWar(param1);
         var _loc3_:Team = _loc2_.teamA;
         if(owner != _loc3_.name)
         {
            _loc3_ = _loc2_.teamB;
         }
         _loc2_.gameScreen.userInterface.chat.messageReceived(this.message,_loc3_.realName);
      }
   }
}
