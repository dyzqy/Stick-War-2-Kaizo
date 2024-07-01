package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import com.smartfoxserver.v2.requests.buddylist.*;
      import fl.controls.*;
      import flash.events.*;
      import flash.text.*;
      
      public class LobbyChat
      {
             
            
            internal var main:Main;
            
            internal var lobbyChatMc:LobbyChatMc;
            
            internal var isScrollChat:Boolean = true;
            
            private var usernames:Array;
            
            public function LobbyChat(param1:Main, param2:LobbyChatMc)
            {
                  var _loc4_:Object = null;
                  this.usernames = [];
                  super();
                  this.lobbyChatMc = param2;
                  this.main = param1;
                  this.lobbyChatMc.visible = true;
                  this.lobbyChatMc.chatInput.addEventListener(Event.CHANGE,this.sendChatMessage);
                  this.lobbyChatMc.chatInput.text = "";
                  var _loc3_:StyleSheet = new StyleSheet();
                  (_loc4_ = new Object()).color = "#AAAAAA";
                  _loc3_.setStyle(".nonMemberName",_loc4_);
                  (_loc4_ = new Object()).color = "#00FFFF";
                  _loc4_.fontWeight = "bold";
                  _loc3_.setStyle(".chatAdmin",_loc4_);
                  (_loc4_ = new Object()).fontWeight = "bold";
                  _loc3_.setStyle(".memberName",_loc4_);
                  (_loc4_ = new Object()).color = "#FF0000";
                  _loc3_.setStyle(".serverName",_loc4_);
                  (_loc4_ = new Object()).color = "#FFFFFF";
                  _loc3_.setStyle(".chatText",_loc4_);
                  (_loc4_ = new Object()).color = "#00BB00";
                  _loc3_.setStyle(".myChatText",_loc4_);
                  this.lobbyChatMc.chatOutput.styleSheet = _loc3_;
                  this.lobbyChatMc.chatOutput.htmlText = "";
                  this.lobbyChatMc.chatOutput.text = "";
                  this.lobbyChatMc.chatOutput.addEventListener(MouseEvent.CLICK,this.clickedInChat);
                  this.lobbyChatMc.chatOutput.addEventListener(MouseEvent.ROLL_OUT,this.mouseLeaveChat);
                  this.lobbyChatMc.chatOutput.mouseWheelEnabled = false;
                  this.lobbyChatMc.scroll.source = this.lobbyChatMc.chatOutput;
                  this.lobbyChatMc.scroll.setSize(this.lobbyChatMc.scroll.width,this.lobbyChatMc.scroll.height);
                  this.lobbyChatMc.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
                  this.lobbyChatMc.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
                  this.lobbyChatMc.scroll.update();
                  param2.sendButton.addEventListener(MouseEvent.CLICK,this.sendChat,false,0,true);
                  param2.chatOutput.text = "Welcome to Stick Empires!<br>";
            }
            
            public static function stripHTML(param1:String) : String
            {
                  return param1.replace(/</g,"&lt;").replace(/>/g,"&gt;");
            }
            
            private function isNameChar(param1:String) : Boolean
            {
                  return param1.toLowerCase().charCodeAt(0) <= "z".charCodeAt(0) && param1.toLowerCase().charCodeAt(0) >= "a".charCodeAt(0) || param1.toLowerCase().charCodeAt(0) <= "9".charCodeAt(0) && param1.toLowerCase().charCodeAt(0) >= "0".charCodeAt(0);
            }
            
            private function clickedInChat(param1:Event) : *
            {
                  var _loc3_:String = null;
                  var _loc4_:int = 0;
                  var _loc5_:int = 0;
                  var _loc6_:String = null;
                  this.isScrollChat = false;
                  if(this.lobbyChatMc.chatOutput.selectionBeginIndex == this.lobbyChatMc.chatOutput.selectionEndIndex)
                  {
                        _loc4_ = 0;
                        _loc5_ = 0;
                        _loc4_ = _loc5_ = int(this.lobbyChatMc.chatOutput.caretIndex);
                        _loc6_ = String(this.lobbyChatMc.chatOutput.text);
                        while(_loc4_ > 0 && Boolean(this.isNameChar(_loc6_.charAt(_loc4_))))
                        {
                              _loc4_--;
                        }
                        while(_loc5_ < _loc6_.length && Boolean(this.isNameChar(_loc6_.charAt(_loc5_))))
                        {
                              _loc5_++;
                        }
                        this.lobbyChatMc.chatOutput.setSelection(_loc4_ + 1,_loc5_);
                  }
                  var _loc2_:String = String(this.lobbyChatMc.chatOutput.selectedText);
                  for each(_loc3_ in this.usernames)
                  {
                        if(_loc2_ == _loc3_)
                        {
                              this.main.profileScreen.setProfileToLoad(_loc2_,false);
                              this.main.showScreen("profile");
                        }
                  }
            }
            
            private function mouseLeaveChat(param1:Event) : *
            {
                  this.isScrollChat = true;
                  this.updateChatScroll();
            }
            
            public function receiveChat(param1:String, param2:String, param3:int, param4:int) : void
            {
                  var _loc5_:Array = null;
                  this.usernames.push(param1);
                  if(this.usernames.length > 50)
                  {
                        this.usernames.shift();
                  }
                  if(this.lobbyChatMc.chatOutput.htmlText.length > 10000)
                  {
                        _loc5_ = this.lobbyChatMc.chatOutput.htmlText.split("<br>");
                        _loc5_ = _loc5_.slice(_loc5_.length / 2,_loc5_.length);
                        this.lobbyChatMc.chatOutput.htmlText = _loc5_.join("<br>");
                  }
                  param2 = stripHTML(param2);
                  param2 = param2.replace(Main(this.main).badWorldRegex,"#!@$");
                  if(param4 == 1)
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'chatAdmin\'>" + param1 + ": </span>";
                  }
                  else if(param3 == 1)
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'memberName\'>" + param1 + ": </span>";
                  }
                  else if(param3 == 2)
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'serverName\'>" + param1 + ": </span>";
                  }
                  else
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'nonMemberName\'>" + param1 + ": </span>";
                  }
                  if(param3 == 2)
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'nonMemberName\'>" + param2 + "</span><br>";
                  }
                  else if(param1 == this.main.sfs.mySelf.name)
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'myChatText\'>" + param2 + "</span><br>";
                  }
                  else
                  {
                        this.lobbyChatMc.chatOutput.htmlText += "<span class=\'chatText\'>" + param2 + "</span><br>";
                  }
                  if(this.isScrollChat)
                  {
                        this.updateChatScroll();
                  }
            }
            
            public function updateChatScroll() : void
            {
                  this.lobbyChatMc.chatOutput.autoSize = "left";
                  this.lobbyChatMc.chatOutput.multiline = true;
                  this.lobbyChatMc.chatOutput.wordWrap = true;
                  this.lobbyChatMc.scroll.update();
                  if(this.main.getOverlayScreen() == "chatOverlay")
                  {
                        this.lobbyChatMc.scroll.verticalScrollPosition = this.lobbyChatMc.chatOutput.height;
                  }
            }
            
            private function sendChat(param1:Event) : void
            {
                  this.lobbyChatMc.chatInput.text += "\n";
                  this.sendChatMessage(param1);
            }
            
            private function sendChatMessage(param1:Event) : void
            {
                  var _loc3_:SFSObject = null;
                  var _loc2_:String = String(this.lobbyChatMc.chatInput.text);
                  if(_loc2_.charCodeAt(_loc2_.length - 1) == 13)
                  {
                        _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
                        if(_loc2_ == "" || _loc2_.charAt(0) == "\n" || _loc2_.charAt(0) == "\r")
                        {
                              this.lobbyChatMc.chatInput.text = "";
                              return;
                        }
                        _loc3_ = new SFSObject();
                        _loc3_.putUtfString("message",_loc2_);
                        this.main.sfs.send(new ExtensionRequest("lobbyChatSend",_loc3_));
                        this.lobbyChatMc.chatInput.text = "";
                  }
            }
      }
}
