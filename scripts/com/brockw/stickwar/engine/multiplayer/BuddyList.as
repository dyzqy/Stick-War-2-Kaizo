package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import fl.controls.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.utils.*;
   
   public class BuddyList
   {
      
      private static const GAME_INVITE_TIME_LIMIT:int = 30 + 1;
       
      
      private var _buddyMap:Dictionary;
      
      private var _buddyList:Array;
      
      private var canvas:Sprite;
      
      private var _chatTabs:Array;
      
      private var chatOverlay:chatOverlayMc;
      
      private var main:Main;
      
      private var currentInviteId:int;
      
      private var currentInviteName:String;
      
      private var currentInviteTime:int;
      
      private var inviteWindowTimer:Timer;
      
      private var chatContainerX:int;
      
      private var chatContainerXReal:Number;
      
      public function BuddyList(param1:chatOverlayMc, param2:Main)
      {
         super();
         this.main = param2;
         this.chatOverlay = param1;
         param1.chatBoxMc.scroll.source = this.canvas = param1.chatBoxMc.userDisplayListMc;
         param1.chatBoxMc.scroll.setSize(param1.chatBoxMc.scroll.width,param1.chatBoxMc.scroll.height);
         param1.chatBoxMc.scroll.horizontalScrollPolicy = ScrollPolicy.OFF;
         param1.chatBoxMc.scroll.verticalScrollPolicy = ScrollPolicy.AUTO;
         param1.chatBoxMc.scroll.update();
         this.canvas = param1.chatBoxMc.userDisplayListMc;
         this._buddyList = [];
         this._buddyMap = new Dictionary();
         this._chatTabs = [];
         this.canvas = this.canvas;
         param1.gameInviteWindow.visible = false;
         this.currentInviteId = -1;
         this.currentInviteTime = 0;
         this.currentInviteName = "";
         this.chatContainerX = 0;
         this.chatContainerXReal = 0;
         this.inviteWindowTimer = new Timer(1000,0);
         param1.addEventListener(Event.ENTER_FRAME,this.showArrows);
         param1.leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrow);
         param1.rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrow);
         param1.chatBoxMc.userCodeBox.addEventListener(FocusEvent.FOCUS_IN,this.enterCodeBox);
      }
      
      public function updateChatScrolls() : void
      {
         var _loc1_:buddyChatMc = null;
         for each(_loc1_ in this._chatTabs)
         {
            _loc1_.updateChatScroll();
         }
      }
      
      private function enterCodeBox(param1:FocusEvent) : void
      {
         this.chatOverlay.chatBoxMc.userCodeBox.text = "";
      }
      
      private function showArrows(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.chatContainerXReal += (this.chatContainerX - this.chatContainerXReal) * 0.2;
         this.chatOverlay.leftArrow.visible = false;
         this.chatOverlay.rightArrow.visible = false;
         if(this.chatContainerX > 0)
         {
            this.chatOverlay.rightArrow.visible = true;
         }
         if(this._chatTabs.length > 0)
         {
            _loc2_ = Number(this._chatTabs[0].width);
            _loc3_ = _loc2_ * this._chatTabs.length - 655;
            if(_loc3_ - this.chatContainerX > 0)
            {
               this.chatOverlay.leftArrow.visible = true;
            }
         }
         this.updateChatContainer();
      }
      
      private function updateChatContainer() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.chatContainerX < 0)
         {
            this.chatContainerX = 0;
         }
         if(this._chatTabs.length > 0)
         {
            _loc1_ = Number(this._chatTabs[0].width);
            _loc2_ = _loc1_ * this._chatTabs.length - 655;
            if(this.chatContainerX > _loc2_)
            {
               this.chatContainerX = _loc2_;
            }
         }
         if(this._chatTabs.length <= 3)
         {
            this.chatContainerX = 0;
         }
         this.updateChatTabs();
      }
      
      private function leftArrow(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._chatTabs.length > 0)
         {
            _loc2_ = Number(this._chatTabs[0].width);
            this.chatContainerX += _loc2_;
         }
         this.updateChatContainer();
      }
      
      private function rightArrow(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._chatTabs.length > 0)
         {
            _loc2_ = Number(this._chatTabs[0].width);
            this.chatContainerX -= _loc2_;
         }
         this.updateChatContainer();
      }
      
      public function cleanUp() : void
      {
         var _loc1_:BuddyChatTab = null;
         for each(_loc1_ in this._chatTabs)
         {
            _loc1_.chatWindow.closeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
            _loc1_.maximizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
            _loc1_.chatWindow.minimizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
            if(this._chatTabs.indexOf(_loc1_) >= 0)
            {
               this.chatOverlay.chatContainer.removeChild(_loc1_);
            }
         }
         this._chatTabs = [];
         this.updateChatTabs();
      }
      
      private function closeChat(param1:MouseEvent) : void
      {
         var _loc2_:BuddyChatTab = BuddyChatTab(param1.currentTarget.parent.parent);
         _loc2_.chatWindow.closeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
         _loc2_.maximizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
         _loc2_.chatWindow.minimizeButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
         if(this._chatTabs.indexOf(_loc2_) >= 0)
         {
            this._chatTabs.splice(this._chatTabs.indexOf(_loc2_),1);
            this.chatOverlay.chatContainer.removeChild(_loc2_);
         }
         this.updateChatTabs();
      }
      
      private function toggleChat2(param1:MouseEvent) : void
      {
         var _loc2_:BuddyChatTab = BuddyChatTab(param1.currentTarget.parent.parent);
         _loc2_.toggleChat();
      }
      
      private function toggleChat(param1:MouseEvent) : void
      {
         var _loc2_:BuddyChatTab = BuddyChatTab(param1.currentTarget.parent);
         _loc2_.toggleChat();
      }
      
      public function startGameInvite(param1:int, param2:String) : void
      {
         var _loc3_:int = 0;
         if(this.main.status == Buddy.S_ONLINE && this.main.getOverlayScreen() == "chatOverlay")
         {
            this.currentInviteTime = getTimer();
            _loc3_ = GAME_INVITE_TIME_LIMIT - 1;
            this.chatOverlay.gameInviteWindow.visible = true;
            this.chatOverlay.gameInviteWindow.invitationText.text = param2 + " has invited you to play a game. (" + _loc3_ + ")";
            this.chatOverlay.gameInviteWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptGameInvite);
            this.chatOverlay.gameInviteWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.rejectGameInvite);
            this.chatOverlay.gameInviteWindow.okButton.visible = false;
            this.chatOverlay.gameInviteWindow.rejectButton.visible = true;
            this.chatOverlay.gameInviteWindow.acceptButton.visible = true;
            this.inviteWindowTimer.addEventListener(TimerEvent.TIMER,this.updateInviteTimer);
            this.inviteWindowTimer.start();
            this.currentInviteId = param1;
            this.currentInviteName = param2;
         }
      }
      
      private function updateInviteTimer(param1:Event) : void
      {
         var _loc3_:SFSObject = null;
         var _loc2_:int = GAME_INVITE_TIME_LIMIT - (getTimer() - this.currentInviteTime) / 1000;
         this.chatOverlay.gameInviteWindow.invitationText.text = this.currentInviteName + " has invited you to play a game. (" + _loc2_ + ")";
         if(_loc2_ <= 0)
         {
            _loc3_ = new SFSObject();
            _loc3_.putInt("inviter",this.currentInviteId);
            _loc3_.putInt("response",0);
            this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",_loc3_));
            this.cleanUpGameInviteWindow();
         }
      }
      
      private function acceptGameInvite(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("inviter",this.currentInviteId);
         _loc2_.putInt("response",1);
         this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",_loc2_));
         this.cleanUpGameInviteWindow();
      }
      
      private function rejectGameInvite(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("inviter",this.currentInviteId);
         _loc2_.putInt("response",0);
         this.main.sfs.send(new ExtensionRequest("buddyGameInviteResponse",_loc2_));
         this.cleanUpGameInviteWindow();
      }
      
      private function cleanUpGameInviteWindow() : void
      {
         this.chatOverlay.gameInviteWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.acceptGameInvite);
         this.chatOverlay.gameInviteWindow.rejectButton.removeEventListener(MouseEvent.CLICK,this.rejectGameInvite);
         this.chatOverlay.gameInviteWindow.visible = false;
         this.inviteWindowTimer.stop();
         this.inviteWindowTimer.removeEventListener(TimerEvent.TIMER,this.updateInviteTimer);
      }
      
      public function receiveChat(param1:int, param2:String, param3:String) : void
      {
         var _loc5_:int = 0;
         var _loc7_:Buddy = null;
         var _loc4_:Buddy = null;
         _loc5_ = 0;
         while(_loc5_ < this._buddyList.length)
         {
            if((_loc7_ = this._buddyMap[this._buddyList[_loc5_]]).id == param1)
            {
               _loc4_ = _loc7_;
               break;
            }
            _loc5_++;
         }
         if(_loc4_ == null)
         {
            (_loc4_ = new Buddy()).id = param1;
            _loc4_.name = param2;
            _loc4_.statusType = 0;
            _loc4_.isTemp = true;
            this.addBuddy(_loc4_);
         }
         var _loc6_:Boolean = false;
         _loc5_ = 0;
         while(_loc5_ < this._chatTabs.length)
         {
            if(BuddyChatTab(this._chatTabs[_loc5_]).id == _loc4_.id)
            {
               _loc6_ = true;
            }
            _loc5_++;
         }
         if(!_loc6_)
         {
            this.createChatWindow(_loc4_);
         }
         _loc5_ = 0;
         while(_loc5_ < this._chatTabs.length)
         {
            if(BuddyChatTab(this._chatTabs[_loc5_]).id == _loc4_.id && BuddyChatTab(this._chatTabs[_loc5_]).chatWindow != null)
            {
               BuddyChatTab(this._chatTabs[_loc5_]).receiveChat(param2,param3);
               _loc4_.chatHistory = BuddyChatTab(this._chatTabs[_loc5_]).chatWindow.chatOutput.htmlText;
            }
            _loc5_++;
         }
      }
      
      private function createChatWindow(param1:Buddy) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._chatTabs.length)
         {
            if(BuddyChatTab(this._chatTabs[_loc2_]).id == param1.id)
            {
               return;
            }
            _loc2_++;
         }
         var _loc3_:BuddyChatTab = new BuddyChatTab(param1.id,this.main);
         _loc3_.chatWindow.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.closeChat);
         _loc3_.maximizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat);
         _loc3_.chatWindow.chatInput.tabEnabled = false;
         _loc3_.chatWindow.minimizeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleChat2);
         this._chatTabs.unshift(_loc3_);
         _loc3_.chatWindow.chatOutput.htmlText = param1.chatHistory;
         _loc3_.buddyText.text = param1.name;
         _loc3_.status.gotoAndStop(Buddy.statusFromCode(param1.statusType));
         _loc3_.buddy = param1;
         this.updateChatTabs();
         this.main.stage.focus = _loc3_.chatWindow.chatInput;
      }
      
      private function startChat(param1:MouseEvent) : void
      {
         var _loc2_:Buddy = Buddy(param1.currentTarget.parent);
         this.createChatWindow(_loc2_);
      }
      
      public function updateChatTabs() : void
      {
         var _loc2_:BuddyChatTab = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._chatTabs.length)
         {
            _loc2_ = this._chatTabs[_loc1_];
            if(!this.chatOverlay.chatContainer.contains(_loc2_))
            {
               this.chatOverlay.chatContainer.addChild(_loc2_);
            }
            _loc2_.x = this.chatContainerXReal + 655 - _loc2_.width * (_loc1_ + 1);
            _loc2_.y = 15;
            _loc2_.status.gotoAndStop(Buddy.statusFromCode(_loc2_.buddy.statusType));
            if(_loc2_.x + _loc2_.width / 2 > 655)
            {
               _loc2_.minimize();
            }
            _loc1_++;
         }
      }
      
      public function updateScrollOnTabs() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._chatTabs.length)
         {
            BuddyChatTab(this._chatTabs[_loc1_]).chatWindow.chatOutput.height = BuddyChatTab(this._chatTabs[_loc1_]).chatWindow.chatOutput.textHeight;
            BuddyChatTab(this._chatTabs[_loc1_]).chatWindow.scroll.update();
            if(this.main.getOverlayScreen() == "chatOverlay")
            {
               BuddyChatTab(this._chatTabs[_loc1_]).chatWindow.scroll.verticalScrollPosition = BuddyChatTab(this._chatTabs[_loc1_]).chatWindow.chatOutput.height;
            }
            _loc1_++;
         }
      }
      
      public function addBuddy(param1:Buddy) : void
      {
         var _loc2_:* = undefined;
         if(!(param1.id in this._buddyMap))
         {
            this._buddyList.push(param1.id);
            this._buddyMap[param1.id] = param1;
            param1.startChat.addEventListener(MouseEvent.CLICK,this.startChat);
            param1.removeUser.addEventListener(MouseEvent.CLICK,this.removeBuddyFromFriendsList);
            param1.startGame.addEventListener(MouseEvent.CLICK,this.inviteToGame);
         }
         else
         {
            _loc2_ = param1;
            param1 = this._buddyMap[param1.id];
            param1.name = _loc2_.name;
            param1.statusType = _loc2_.statusType;
            if(!param1.isTemp || !_loc2_.isTemp)
            {
               param1.isTemp = false;
            }
            else
            {
               param1.isTemp = true;
            }
         }
         this.updateChatTabs();
         this.update();
      }
      
      private function inviteToGame(param1:Event) : void
      {
         var _loc2_:Buddy = Buddy(param1.currentTarget.parent);
         var _loc3_:SFSObject = new SFSObject();
         _loc3_.putInt("invitee",_loc2_.id);
         this.main.sfs.send(new ExtensionRequest("buddyGameInvite",_loc3_));
      }
      
      private function removeBuddyFromFriendsList(param1:Event) : void
      {
         var _loc2_:Buddy = Buddy(param1.currentTarget.parent);
         var _loc3_:SFSObject = new SFSObject();
         _loc3_.putUtfString("buddy",_loc2_.name);
         this.main.sfs.send(new ExtensionRequest("buddyRemove",_loc3_));
      }
      
      public function removeBuddy(param1:Buddy) : void
      {
         if(param1.id in this._buddyMap)
         {
            delete this._buddyMap[param1.id];
            param1.startChat.removeEventListener(MouseEvent.CLICK,this.startChat);
            param1.removeUser.removeEventListener(MouseEvent.CLICK,this.removeBuddyFromFriendsList);
            param1.startGame.removeEventListener(MouseEvent.CLICK,this.inviteToGame);
            if(this.canvas.contains(param1))
            {
               this.canvas.removeChild(param1);
            }
            this._buddyList.splice(this._buddyList.indexOf(param1.id),1);
         }
         this.update();
      }
      
      private function sortOnNames(param1:int, param2:int) : int
      {
         if(this._buddyMap[param1].isTemp)
         {
            return 1;
         }
         if(this._buddyMap[param2].isTemp)
         {
            return -1;
         }
         var _loc3_:Buddy = this._buddyMap[param1];
         var _loc4_:Buddy = this._buddyMap[param2];
         if(_loc3_.name.toLowerCase() < _loc4_.name.toLowerCase())
         {
            return -1;
         }
         return 1;
      }
      
      public function update() : void
      {
         var _loc2_:Buddy = null;
         this._buddyList.sort(this.sortOnNames);
         this.canvas.scaleX = 1;
         this.canvas.scaleY = 1;
         var _loc1_:int = 0;
         while(_loc1_ < this._buddyList.length)
         {
            _loc2_ = this._buddyMap[this._buddyList[_loc1_]];
            if(!this.canvas.contains(_loc2_))
            {
               this.canvas.addChild(_loc2_);
            }
            _loc2_.displayName.text = _loc2_.toString();
            if(_loc2_.isTemp)
            {
               _loc2_.alpha = 0.3;
            }
            else
            {
               _loc2_.alpha = 1;
            }
            _loc2_.y = _loc2_.height * _loc1_;
            _loc1_++;
         }
         this.chatOverlay.chatBoxMc.scroll.update();
      }
      
      public function receiveBuddyList(param1:SFSObject) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Buddy = null;
         var _loc2_:ISFSArray = param1.getSFSArray("buddys");
         var _loc3_:Array = [];
         trace("\nLoading the buddy list");
         _loc4_ = 0;
         while(_loc4_ < this._buddyList.length)
         {
            if((_loc5_ = this._buddyMap[this._buddyList[_loc4_]]).isTemp)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         while(this._buddyList.length != 0)
         {
            this.removeBuddy(this._buddyMap[this._buddyList[0]]);
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.addBuddy(_loc3_[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.size())
         {
            (_loc5_ = new Buddy()).fromSFSObject(_loc2_.getSFSObject(_loc4_));
            this.addBuddy(_loc5_);
            _loc4_++;
         }
      }
      
      public function receiveUpdate(param1:SFSObject) : void
      {
         var _loc2_:ISFSObject = param1;
         var _loc3_:Buddy = new Buddy();
         _loc3_.fromSFSObject(_loc2_);
         this.addBuddy(_loc3_);
         trace("\nUpdating buddy: " + _loc3_);
      }
      
      public function get buddyMap() : Dictionary
      {
         return this._buddyMap;
      }
      
      public function set buddyMap(param1:Dictionary) : void
      {
         this._buddyMap = param1;
      }
   }
}
