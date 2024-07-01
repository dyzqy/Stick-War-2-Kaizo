package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      import flash.display.*;
      import flash.events.*;
      import flash.text.*;
      
      public class ClanScreen extends Screen
      {
             
            
            internal var mc:viewClanScreenMc;
            
            internal var main:BaseMain;
            
            internal var memberCards:Array;
            
            private var membersContainer:MovieClip;
            
            private var clanId:int = -1;
            
            private var usernameRequest:String = "";
            
            private var confirmationFunction:Function = null;
            
            public function ClanScreen(param1:BaseMain)
            {
                  var _loc3_:Object = null;
                  super();
                  this.main = param1;
                  this.mc = new viewClanScreenMc();
                  addChild(this.mc);
                  this.memberCards = [];
                  this.membersContainer = new MovieClip();
                  this.mc.scrollPane.source = this.membersContainer;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
                  var _loc2_:StyleSheet = new StyleSheet();
                  _loc3_ = new Object();
                  _loc3_.color = "#FFB400";
                  _loc2_.setStyle(".myText",_loc3_);
                  _loc3_ = new Object();
                  _loc3_.color = "#FFFFFF";
                  _loc2_.setStyle(".theirText",_loc3_);
                  this.mc.chatOutput.styleSheet = _loc2_;
                  this.mc.chatOutput.htmlText = "";
                  this.mc.chatOutput.text = "";
                  this.mc.chatOutput.mouseWheelEnabled = false;
                  this.mc.scroll.source = this.mc.chatOutput;
                  this.mc.scroll.setSize(this.mc.scroll.width,this.mc.scroll.height);
                  this.mc.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
                  this.mc.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
                  this.mc.scroll.update();
            }
            
            public function addClanChat(param1:String, param2:String) : void
            {
                  param2 = String(BuddyChatTab.stripHTML(param2));
                  if(param1 == this.main.sfs.mySelf.name)
                  {
                        this.mc.chatOutput.htmlText += "<span class=\'myText\'>" + param1 + ": " + param2 + "</span><br>";
                  }
                  else
                  {
                        this.mc.chatOutput.htmlText += "<span class=\'theirText\'>" + param1 + ": " + param2 + "</span><br>";
                  }
                  this.updateChatScroll();
            }
            
            public function updateChatScroll() : void
            {
                  this.mc.chatOutput.height = this.mc.chatOutput.textHeight + 20;
                  this.mc.scroll.update();
                  if(this.main.currentScreen() == "viewClanScreen")
                  {
                        this.mc.scroll.verticalScrollPosition = this.mc.chatOutput.height;
                  }
            }
            
            public function viewClan(param1:String) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("clanName",param1);
                  this.main.sfs.send(new ExtensionRequest("viewClan",_loc2_));
            }
            
            public function loadClan(param1:SFSObject) : void
            {
                  var _loc5_:MemberCard = null;
                  var _loc6_:MemberCard = null;
                  var _loc7_:SFSArray = null;
                  var _loc8_:int = 0;
                  var _loc9_:SFSObject = null;
                  var _loc10_:SFSArray = null;
                  var _loc2_:* = param1.getUtfString("name") == Main(this.main).clanName;
                  var _loc3_:* = Main(this.main).clanId != -1;
                  var _loc4_:Boolean = param1.containsKey("requests");
                  this.clanId = param1.getInt("id");
                  this.mc.joinClan.visible = false;
                  this.mc.leaveClan.visible = false;
                  if(!_loc3_)
                  {
                        this.mc.joinClan.visible = true;
                  }
                  else if(_loc2_)
                  {
                        this.mc.leaveClan.visible = true;
                  }
                  trace("Is viewing own clan: ",_loc2_);
                  this.mc.clanName.text = param1.getUtfString("name");
                  for each(_loc5_ in this.memberCards)
                  {
                        if(this.membersContainer.contains(_loc5_))
                        {
                              this.membersContainer.removeChild(_loc5_);
                        }
                  }
                  this.memberCards = [];
                  _loc7_ = param1.getSFSArray("clanMembers");
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.size())
                  {
                        _loc9_ = SFSObject(_loc7_.getSFSObject(_loc8_));
                        this.memberCards.push(_loc6_ = new MemberCard(_loc9_,this.main,_loc4_,false,this.clanId));
                        _loc8_++;
                  }
                  if(param1.containsKey("requests"))
                  {
                        trace("contains requests",param1.getSFSArray("requests").size());
                        _loc10_ = param1.getSFSArray("requests");
                        _loc8_ = 0;
                        while(_loc8_ < _loc10_.size())
                        {
                              _loc9_ = SFSObject(_loc10_.getSFSObject(_loc8_));
                              this.memberCards.push(_loc6_ = new MemberCard(_loc9_,this.main,_loc4_,true,this.clanId));
                              _loc8_++;
                        }
                  }
                  this.updateClanCards();
            }
            
            private function updateClanCards() : void
            {
                  var _loc2_:MemberCard = null;
                  var _loc1_:int = 0;
                  for each(_loc2_ in this.memberCards)
                  {
                        if(!this.membersContainer.contains(_loc2_))
                        {
                              this.membersContainer.addChild(_loc2_);
                        }
                        _loc2_.y = _loc1_ * (_loc2_.height + 5);
                        _loc2_.x = 0;
                        _loc1_++;
                  }
            }
            
            private function findClans(param1:Event) : void
            {
                  this.main.showScreen("findClanScreen");
            }
            
            private function joinClan(param1:Event) : void
            {
                  Main(this.main).clanRequestScreen.setClanId(this.clanId);
                  this.main.showScreen("clanRequestScreen");
            }
            
            public function showRequestWindow(param1:String, param2:String) : void
            {
                  this.mc.clanRequestWindow.visible = true;
                  this.mc.clanRequestWindow.invitationText.text = param2;
                  this.usernameRequest = param1;
            }
            
            private function requestClose(param1:Event) : void
            {
                  this.mc.clanRequestWindow.visible = false;
            }
            
            private function requestDecline(param1:Event) : void
            {
                  this.requestResponse(false);
                  this.mc.clanRequestWindow.visible = false;
            }
            
            private function requestAccept(param1:Event) : void
            {
                  this.requestResponse(true);
                  this.mc.clanRequestWindow.visible = false;
            }
            
            private function requestResponse(param1:Boolean) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putInt("clanId",this.clanId);
                  _loc2_.putUtfString("username",this.usernameRequest);
                  _loc2_.putBool("response",param1);
                  this.main.sfs.send(new ExtensionRequest("respondToClanRequest",_loc2_));
            }
            
            public function showConfirmation(param1:String, param2:Function) : void
            {
                  this.confirmationFunction = param2;
                  this.mc.confirmationWindow.invitationText.text = param1;
                  this.mc.confirmationWindow.visible = true;
            }
            
            private function acceptConfirmation(param1:Event) : void
            {
                  if(this.confirmationFunction)
                  {
                        this.confirmationFunction();
                  }
                  this.mc.confirmationWindow.visible = false;
                  this.confirmationFunction = null;
            }
            
            private function rejectConfirmation(param1:Event) : void
            {
                  this.mc.confirmationWindow.visible = false;
                  this.confirmationFunction = null;
            }
            
            private function leaveClan(param1:Event) : void
            {
                  this.showConfirmation("Are you sure you want to leave this clan?",this.leaveClanFunction);
            }
            
            private function leaveClanFunction() : void
            {
                  var _loc1_:SFSObject = new SFSObject();
                  this.main.sfs.send(new ExtensionRequest("leaveClan",_loc1_));
            }
            
            private function sendChat(param1:Event) : void
            {
                  this.mc.chatInput.text += "\n";
                  this.sendChatMessage(param1);
            }
            
            private function sendChatMessage(param1:Event) : void
            {
                  var _loc3_:SFSObject = null;
                  var _loc2_:String = String(this.mc.chatInput.text);
                  if(_loc2_.charCodeAt(_loc2_.length - 1) == 13)
                  {
                        _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
                        if(_loc2_ == "" || _loc2_.charAt(0) == "\n" || _loc2_.charAt(0) == "\r")
                        {
                              this.mc.chatInput.text = "";
                              return;
                        }
                        _loc3_ = new SFSObject();
                        _loc3_.putUtfString("message",_loc2_);
                        this.main.sfs.send(new ExtensionRequest("clanMessage",_loc3_));
                        this.mc.chatInput.text = "";
                  }
            }
            
            override public function enter() : void
            {
                  this.updateChatScroll();
                  this.confirmationFunction = null;
                  this.mc.clanRequestWindow.visible = false;
                  this.mc.findButton.addEventListener(MouseEvent.CLICK,this.findClans);
                  this.mc.joinClan.addEventListener(MouseEvent.CLICK,this.joinClan);
                  this.mc.clanRequestWindow.closeButton.addEventListener(MouseEvent.CLICK,this.requestClose);
                  this.mc.clanRequestWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.requestDecline);
                  this.mc.clanRequestWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.requestAccept);
                  this.mc.confirmationWindow.visible = false;
                  this.mc.confirmationWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptConfirmation);
                  this.mc.leaveClan.addEventListener(MouseEvent.CLICK,this.leaveClan);
                  this.mc.confirmationWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.rejectConfirmation);
                  this.mc.chatInput.addEventListener(Event.CHANGE,this.sendChatMessage);
                  this.mc.chatInput.text = "";
                  this.mc.sendButton.addEventListener(MouseEvent.CLICK,this.sendChat,false,0,true);
            }
            
            override public function leave() : void
            {
                  this.mc.chatInput.removeEventListener(Event.CHANGE,this.sendChatMessage);
                  this.mc.findButton.removeEventListener(MouseEvent.CLICK,this.findClans);
                  this.mc.leaveClan.removeEventListener(MouseEvent.CLICK,this.leaveClan);
                  this.mc.joinClan.removeEventListener(MouseEvent.CLICK,this.joinClan);
                  this.mc.clanRequestWindow.closeButton.removeEventListener(MouseEvent.CLICK,this.requestClose);
                  this.mc.clanRequestWindow.rejectButton.removeEventListener(MouseEvent.CLICK,this.requestDecline);
                  this.mc.clanRequestWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.requestAccept);
                  this.mc.confirmationWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.acceptConfirmation);
                  this.mc.confirmationWindow.rejectButton.removeEventListener(MouseEvent.CLICK,this.rejectConfirmation);
                  this.mc.sendButton.removeEventListener(MouseEvent.CLICK,this.sendChat);
            }
      }
}
