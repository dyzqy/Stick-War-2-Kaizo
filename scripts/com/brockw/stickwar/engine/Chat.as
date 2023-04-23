package com.brockw.stickwar.engine
{
   import com.brockw.game.*;
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.engine.multiplayer.*;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.smartfoxserver.v2.entities.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.text.*;
   
   public class Chat extends InGameChatMc
   {
       
      
      private var gameScreen:GameScreen;
      
      private var _isInput:Boolean;
      
      private var lastMessageCount:int;
      
      public function Chat(param1:GameScreen)
      {
         var _loc3_:Object = null;
         super();
         this.gameScreen = param1;
         this.lastMessageCount = 10000;
         this.isInput = false;
         chatInput.alpha = 0;
         this.backOfChat.alpha = 0;
         backBox.alpha = 0;
         alpha = 0;
         var _loc2_:StyleSheet = new StyleSheet();
         _loc3_ = new Object();
         _loc3_.color = "#FFFFFF";
         _loc2_.setStyle(".myText",_loc3_);
         _loc3_ = new Object();
         _loc3_.color = "#FF0000";
         _loc2_.setStyle(".theirText",_loc3_);
         chatOutput.styleSheet = _loc2_;
         chatOutput.htmlText = "";
      }
      
      public function messageReceived(param1:String, param2:String) : void
      {
         param1 = param1.replace(Main(this.gameScreen.main).badWorldRegex,"#!@$");
         var _loc3_:String = param2 + ": " + param1;
         _loc3_ = _loc3_.replace("\n","");
         _loc3_ = _loc3_.replace("\r","");
         _loc3_ = _loc3_.replace("<","");
         _loc3_ = _loc3_.replace(">","");
         if(param2 == this.gameScreen.team.realName)
         {
            chatOutput.htmlText += "<span class=\'myText\'>" + _loc3_ + "</span><br>";
         }
         else
         {
            chatOutput.htmlText += "<span class=\'theirText\'>" + _loc3_ + "</span><br>";
         }
         this.lastMessageCount = 0;
      }
      
      public function update() : void
      {
         chatOutput.scrollV = chatOutput.numLines;
         ++this.lastMessageCount;
         if(this.lastMessageCount > 30 * 6 && !this._isInput)
         {
            this.alpha = 0;
            if(chatInput.alpha == 1)
            {
               this.sendInput();
            }
            chatInput.alpha = 0;
            backBox.alpha = 0;
            this.backOfChat.alpha = 0;
         }
         else
         {
            this.alpha = 1;
         }
         if(this._isInput)
         {
            stage.focus = chatInput;
         }
         var _loc1_:Boolean = Boolean(this.gameScreen.userInterface.keyBoardState.isDisabled);
         this.gameScreen.userInterface.keyBoardState.isDisabled = false;
         if(Boolean(this.gameScreen.userInterface.keyBoardState.isPressed(13)) && this.gameScreen is MultiplayerGameScreen)
         {
            if(this.isInput)
            {
               this.sendInput();
            }
            else
            {
               this.activateInput();
            }
         }
         this.gameScreen.userInterface.keyBoardState.isDisabled = _loc1_;
      }
      
      private function activateInput() : void
      {
         if(this.isInput == false)
         {
            this.gameScreen.userInterface.actionInterface.clear();
            chatInput.selectable = false;
            stage.focus = chatInput;
            chatInput.text = "";
            addChild(chatInput);
            this.isInput = true;
            this.lastMessageCount = 0;
            chatInput.alpha = 1;
            backBox.alpha = 1;
            this.backOfChat.alpha = 1;
         }
      }
      
      private function sendInput() : void
      {
         var _loc1_:ChatMove = null;
         if(this.contains(chatInput))
         {
            if(chatInput.text != "" && chatInput.text.charAt(0) != "\n" && chatInput.text.charAt(0) != "\r")
            {
               _loc1_ = new ChatMove();
               _loc1_.message = chatInput.text;
               this.gameScreen.doMove(_loc1_,this.gameScreen.team.id);
            }
            stage.focus = stage;
            this.isInput = false;
         }
         chatInput.alpha = 0;
         backBox.alpha = 0;
         this.backOfChat.alpha = 0;
      }
      
      public function get isInput() : Boolean
      {
         return this._isInput;
      }
      
      public function set isInput(param1:Boolean) : void
      {
         this._isInput = param1;
      }
   }
}
