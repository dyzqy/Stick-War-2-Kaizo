package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import com.smartfoxserver.v2.requests.buddylist.*;
   import fl.controls.*;
   import flash.events.*;
   import flash.text.*;
   
   public class BuddyChatTab extends buddyChatMc
   {
       
      
      public var id:int;
      
      private var _isMinimized:Boolean;
      
      internal var main:Main;
      
      private var _buddy:com.brockw.stickwar.engine.multiplayer.Buddy;
      
      public function BuddyChatTab(param1:int, param2:Main)
      {
         var _loc4_:Object = null;
         super();
         this.main = param2;
         this._isMinimized = false;
         this.id = param1;
         this.chatWindow.visible = true;
         this.chatWindow.chatInput.addEventListener(Event.CHANGE,this.sendChatMessage);
         this.chatWindow.chatInput.text = "";
         var _loc3_:StyleSheet = new StyleSheet();
         (_loc4_ = new Object()).color = "#FFB400";
         _loc3_.setStyle(".myText",_loc4_);
         (_loc4_ = new Object()).color = "#FFFFFF";
         _loc3_.setStyle(".theirText",_loc4_);
         this.chatWindow.chatOutput.styleSheet = _loc3_;
         this.chatWindow.chatOutput.htmlText = "";
         this.chatWindow.chatOutput.text = "";
         this.buddyText.mouseEnabled = false;
         this.buddy = null;
         this.chatWindow.chatOutput.mouseWheelEnabled = false;
         this.chatWindow.scroll.source = this.chatWindow.chatOutput;
         this.chatWindow.scroll.setSize(this.chatWindow.scroll.width,this.chatWindow.scroll.height);
         this.chatWindow.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
         this.chatWindow.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.chatWindow.scroll.update();
         chatWindow.blockingFrame.mouseEnabled = false;
         chatWindow.blockingFrame.mouseChildren = false;
         chatWindow.sendButton.addEventListener(MouseEvent.CLICK,this.sendChat,false,0,true);
      }
      
      public static function stripHTML(param1:String) : String
      {
         return param1.replace(/</g,"&lt;").replace(/>/g,"&gt;");
      }
      
      public function receiveChat(param1:String, param2:String) : void
      {
         param2 = stripHTML(param2);
         param2 = param2.replace(Main(this.main).badWorldRegex,"#!@$");
         if(param1 == this.main.sfs.mySelf.name)
         {
            chatWindow.chatOutput.htmlText += "<span class=\'myText\'>" + param1 + ": " + param2 + "</span><br>";
         }
         else
         {
            chatWindow.chatOutput.htmlText += "<span class=\'theirText\'>" + param1 + ": " + param2 + "</span><br>";
         }
         this.updateChatScroll();
      }
      
      public function updateChatScroll() : void
      {
         chatWindow.chatOutput.height = chatWindow.chatOutput.textHeight + 20;
         chatWindow.autoSize = "left";
         chatWindow.wordWrap = true;
         chatWindow.scroll.update();
         if(this.main.getOverlayScreen() == "chatOverlay")
         {
            chatWindow.scroll.verticalScrollPosition = chatWindow.chatOutput.height;
         }
      }
      
      public function minimize() : void
      {
         this.chatWindow.visible = false;
         this._isMinimized = true;
      }
      
      public function toggleChat() : void
      {
         if(this._isMinimized)
         {
            this.chatWindow.visible = true;
         }
         else
         {
            this.chatWindow.visible = false;
         }
         this._isMinimized = !this._isMinimized;
         if(!this._isMinimized)
         {
            stage.focus = chatWindow.chatInput;
         }
      }
      
      private function sendChat(param1:Event) : void
      {
         chatWindow.chatInput.text += "\n";
         this.sendChatMessage(param1);
      }
      
      private function sendChatMessage(param1:Event) : void
      {
         var _loc3_:SFSObject = null;
         var _loc2_:String = this.chatWindow.chatInput.text;
         if(_loc2_.charCodeAt(_loc2_.length - 1) == 13)
         {
            _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
            if(_loc2_ == "" || _loc2_.charAt(0) == "\n" || _loc2_.charAt(0) == "\r")
            {
               chatWindow.chatInput.text = "";
               return;
            }
            _loc3_ = new SFSObject();
            _loc3_.putInt("id",this.id);
            _loc3_.putUtfString("m",_loc2_);
            _loc3_.putUtfString("n",this.main.sfs.mySelf.name);
            this.main.sfs.send(new ExtensionRequest("buddyChat",_loc3_));
            this.chatWindow.chatInput.text = "";
         }
      }
      
      public function get buddy() : com.brockw.stickwar.engine.multiplayer.Buddy
      {
         return this._buddy;
      }
      
      public function set buddy(param1:com.brockw.stickwar.engine.multiplayer.Buddy) : void
      {
         this._buddy = param1;
      }
   }
}
