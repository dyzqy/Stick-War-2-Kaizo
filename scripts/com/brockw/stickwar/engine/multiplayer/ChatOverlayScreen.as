package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.multiplayer.adds.*;
   import com.liamr.ui.dropDown.*;
   import com.liamr.ui.dropDown.Events.DropDownEvent;
   import com.smartfoxserver.v2.core.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import fl.controls.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class ChatOverlayScreen extends Screen
   {
       
      
      internal var main:Main;
      
      internal var chatOverlay:chatOverlayMc;
      
      internal var timer:Timer;
      
      private var population:int;
      
      private var _buddyList:com.brockw.stickwar.engine.multiplayer.BuddyList;
      
      private var isUserListDisplayed:Boolean;
      
      private var _isBuddyListInited:Boolean;
      
      private var statusSelect:DropDown;
      
      private var frame:int;
      
      private var queueStartTimer:int;
      
      private var queueTimer:Timer;
      
      private var currentTerms:int;
      
      private var _queueType:int;
      
      private var _addManager:AddManager;
      
      private var bonusReward:int = 0;
      
      private var bonusShowTime:Number = 0;
      
      private var playedBonusSound:Boolean = true;
      
      public function ChatOverlayScreen(param1:Main)
      {
         super();
         this.queueType = 0;
         this.currentTerms = 0;
         this.frame = 0;
         this.population = 0;
         this.chatOverlay = new chatOverlayMc();
         addChild(this.chatOverlay);
         this.main = param1;
         this._isBuddyListInited = false;
         this._buddyList = new BuddyList(this.chatOverlay,param1);
         var _loc2_:Array = Buddy.getStatuses();
         this.statusSelect = new DropDown(_loc2_,"Select status",true,100);
         this.statusSelect.x = 12;
         this.statusSelect.y = 10;
         this.statusSelect.scaleX *= 0.7;
         this.statusSelect.scaleY *= 0.7;
         this.chatOverlay.chatBoxMc.addChild(this.statusSelect);
         this.isUserListDisplayed = false;
         this.chatOverlay.chatBoxMc.visible = false;
         this.timer = new Timer(1000 / 30,0);
         this.queueStartTimer = 0;
         this.queueTimer = new Timer(500,0);
         this.updateQueueTimer(null);
         this.chatOverlay.termsScreen.visible = false;
         this.chatOverlay.termsScreen.scrollPane.source = this.chatOverlay.termsScreen.terms;
         this.chatOverlay.termsScreen.scrollPane.setSize(this.chatOverlay.termsScreen.scrollPane.width,this.chatOverlay.termsScreen.scrollPane.height);
         this.chatOverlay.termsScreen.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.addManager = new AddManager(param1);
         addChild(this.addManager);
         this.chatOverlay.returningReward.visible = false;
      }
      
      public function get queueType() : int
      {
         return this._queueType;
      }
      
      public function set queueType(param1:int) : void
      {
         this._queueType = param1;
      }
      
      public function showTerms(param1:SFSObject) : void
      {
         trace("SHOW TERMS");
         this.chatOverlay.termsScreen.visible = true;
         this.chatOverlay.termsScreen.terms.htmlText = param1.getUtfString("terms");
         this.chatOverlay.termsScreen.terms.mouseWheelEnabled = false;
         this.chatOverlay.termsScreen.terms.height = this.chatOverlay.termsScreen.terms.textHeight + 100;
         this.currentTerms = param1.getInt("id");
      }
      
      private function updateQueueTimer(param1:Event) : void
      {
         if(this.main.inQueue)
         {
            this.chatOverlay.cancelButton.visible = true;
            this.chatOverlay.matchTimerText.visible = true;
            if(this.queueType == StickWar.TYPE_CLASSIC)
            {
               this.chatOverlay.matchTimerText.text.text = "Finding Match: " + int((getTimer() - this.queueStartTimer) / 1000);
            }
            else
            {
               this.chatOverlay.matchTimerText.text.text = "Finding DM Match: " + int((getTimer() - this.queueStartTimer) / 1000);
            }
         }
         else
         {
            this.chatOverlay.cancelButton.visible = false;
            this.chatOverlay.matchTimerText.text.text = this.population + " users online";
         }
      }
      
      public function setQueueType(param1:int) : *
      {
         this.queueType = param1;
      }
      
      public function startQueueCount() : void
      {
         this.queueStartTimer = getTimer();
      }
      
      public function stopQueueCount() : void
      {
      }
      
      public function addUserResponse(param1:String, param2:Boolean = false, param3:int = 15) : void
      {
         this.chatOverlay.gameInviteWindow.visible = true;
         this.chatOverlay.gameInviteWindow.invitationText.text = param1;
         var _loc4_:TextFormat;
         (_loc4_ = new TextFormat()).size = param3;
         this.chatOverlay.gameInviteWindow.invitationText.setTextFormat(_loc4_);
         this.chatOverlay.gameInviteWindow.acceptButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.rejectButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.okButton.addEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.rejectButton.visible = false;
         this.chatOverlay.gameInviteWindow.acceptButton.visible = false;
         this.chatOverlay.gameInviteWindow.okButton.visible = true;
      }
      
      private function closeAddUserResponse(param1:Event) : void
      {
         this.chatOverlay.gameInviteWindow.acceptButton.removeEventListener(MouseEvent.CLICK,this.closeAddUserResponse);
         this.chatOverlay.gameInviteWindow.visible = false;
      }
      
      private function statusChange(param1:DropDownEvent) : void
      {
         var _loc2_:int = int(Buddy.codeFromStatus(param1.selectedLabel));
         trace("STATUS CHANGED");
         var _loc3_:SFSObject = new SFSObject();
         _loc3_.putInt("s",_loc2_);
         this.main.sfs.send(new ExtensionRequest("buddyStatus",_loc3_));
         this.main.status = _loc2_;
      }
      
      public function cleanUp() : void
      {
         this._buddyList.cleanUp();
      }
      
      private function leaderboardButton(param1:Event) : void
      {
      }
      
      private function profileButton(param1:Event) : void
      {
      }
      
      private function acceptTerms(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("id",this.currentTerms);
         this.main.sfs.send(new ExtensionRequest("setTermsOfServiceRead",_loc2_));
         this.chatOverlay.termsScreen.visible = false;
      }
      
      private function rejectTerms(param1:Event) : void
      {
         this.main.sfs.send(new LogoutRequest());
      }
      
      override public function leave() : void
      {
         this.chatOverlay.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
         this.chatOverlay.termsScreen.acceptButton.removeEventListener(MouseEvent.CLICK,this.acceptTerms);
         this.statusSelect.removeEventListener(DropDown.ITEM_SELECTED,this.statusChange);
         this.timer.removeEventListener(TimerEvent.TIMER,this.update);
         this.timer.stop();
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.chatOverlay.friendOnlineButton.removeEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.minimizeButton.removeEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.userAddBox.removeEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.userCodeBox.removeEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.addUserButton.removeEventListener(MouseEvent.CLICK,this.addUser);
         this.chatOverlay.chatBoxMc.userAddBox.removeEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.chatBoxMc.userCodeBox.removeEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.queueTimer.removeEventListener(TimerEvent.TIMER,this.updateQueueTimer);
         this.chatOverlay.cancelButton.removeEventListener(MouseEvent.CLICK,this.cancelMatch);
         this.chatOverlay.logOff.removeEventListener(MouseEvent.CLICK,this.logout);
         this.chatOverlay.returningReward.acceptButton.removeEventListener(MouseEvent.CLICK,this.closeReturningReward);
      }
      
      override public function enter() : void
      {
         if(Main(this.main).isOnFacebook)
         {
            this.chatOverlay.logOff.visible = false;
         }
         this.timer.start();
         stage.frameRate = 30;
         this.statusSelect.addEventListener(DropDown.ITEM_SELECTED,this.statusChange);
         this.chatOverlay.chatOverlayHeader.mouseEnabled = false;
         this.chatOverlay.chatOverlayHeader.mouseChildren = false;
         this.chatOverlay.mouseEnabled = false;
         this.mouseEnabled = false;
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.chatOverlay.chatBoxMc.userAddBox.text = "Add User";
         this.chatOverlay.chatBoxMc.userCodeBox.text = "###";
         this.buddyList.updateScrollOnTabs();
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.chatOverlay.friendOnlineButton.addEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.minimizeButton.addEventListener(MouseEvent.CLICK,this.revealUserList);
         this.chatOverlay.chatBoxMc.userAddBox.addEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.userCodeBox.addEventListener(Event.CHANGE,this.addUser);
         this.chatOverlay.chatBoxMc.addUserButton.addEventListener(MouseEvent.CLICK,this.addUser);
         this.chatOverlay.chatBoxMc.userAddBox.addEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.chatBoxMc.userCodeBox.addEventListener(MouseEvent.CLICK,this.clearFieldOnClick);
         this.chatOverlay.termsScreen.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptTerms);
         this.chatOverlay.lobbyButton.gotoAndStop(1);
         this.chatOverlay.armourButton.gotoAndStop(1);
         this.chatOverlay.leaderboardButton.gotoAndStop(1);
         this.chatOverlay.profileButton.gotoAndStop(1);
         this.chatOverlay.faqButton.gotoAndStop(1);
         this.chatOverlay.lobbyButton.buttonMode = true;
         this.chatOverlay.armourButton.buttonMode = true;
         this.chatOverlay.leaderboardButton.buttonMode = true;
         this.chatOverlay.profileButton.buttonMode = true;
         this.chatOverlay.faqButton.buttonMode = true;
         this.queueTimer.addEventListener(TimerEvent.TIMER,this.updateQueueTimer);
         this.queueTimer.start();
         this.chatOverlay.friendOnlineButton.usernameText.text = this.main.sfs.mySelf.name;
         if(this.main.sfs.mySelf.containsVariable("code"))
         {
            this.chatOverlay.friendOnlineButton.codeText.text = this.main.sfs.mySelf.getVariable("code").getStringValue();
         }
         this.chatOverlay.cancelButton.addEventListener(MouseEvent.CLICK,this.cancelMatch);
         this.chatOverlay.logOff.addEventListener(MouseEvent.CLICK,this.logout);
         var _loc1_:SFSObject = new SFSObject();
         this.main.sfs.send(new ExtensionRequest("getPopulation",_loc1_));
         this.main.soundManager.playSoundInBackground("lobbyMusic");
         this.chatOverlay.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
         this._buddyList.updateChatScrolls();
         this.chatOverlay.returningReward.acceptButton.addEventListener(MouseEvent.CLICK,this.closeReturningReward);
      }
      
      private function closeReturningReward(param1:Event) : void
      {
         this.chatOverlay.returningReward.visible = false;
      }
      
      public function setPopulation(param1:int) : void
      {
         this.population = param1;
      }
      
      private function logout(param1:Event) : void
      {
         this.main.sfs.send(new LogoutRequest());
      }
      
      private function cancelMatch(param1:Event) : void
      {
         this.main.mainLobbyScreen.afterCancelAction = null;
         var _loc2_:SFSObject = new SFSObject();
         this.main.sfs.send(new ExtensionRequest("cancelMatch",_loc2_));
         this.main.soundManager.playSoundFullVolume("CancelMatchmakingSound");
      }
      
      private function clearFieldOnClick(param1:Event) : void
      {
         var _loc2_:TextField = TextField(param1.target);
         _loc2_.text = "";
      }
      
      private function addUser(param1:Event) : void
      {
         var _loc5_:SFSObject = null;
         var _loc2_:String = String(this.chatOverlay.chatBoxMc.userAddBox.text);
         var _loc3_:String = String(this.chatOverlay.chatBoxMc.userCodeBox.text);
         var _loc4_:Boolean = false;
         if(param1.target == this.chatOverlay.chatBoxMc.addUserButton)
         {
            _loc4_ = true;
         }
         if(_loc2_.charCodeAt(_loc2_.length - 1) == 13)
         {
            _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
            _loc4_ = true;
         }
         if(_loc3_.charCodeAt(_loc3_.length - 1) == 13)
         {
            _loc3_ = _loc3_.slice(0,_loc3_.length - 1);
            _loc4_ = true;
         }
         if(_loc4_)
         {
            trace("Try to add buddy: " + _loc2_);
            (_loc5_ = new SFSObject()).putUtfString("buddy",_loc2_);
            _loc5_.putUtfString("code",_loc3_);
            _loc5_.putInt("permission",0);
            this.main.sfs.send(new ExtensionRequest("buddyAdd",_loc5_));
            this.chatOverlay.chatBoxMc.userAddBox.text = "";
            this.chatOverlay.chatBoxMc.userCodeBox.text = "";
         }
      }
      
      private function revealUserList(param1:Event) : void
      {
         this.isUserListDisplayed = !this.isUserListDisplayed;
         if(this.isUserListDisplayed)
         {
            this.chatOverlay.chatBoxMc.visible = true;
         }
         else
         {
            this.chatOverlay.chatBoxMc.visible = false;
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(this.chatOverlay.lobbyButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("lobby");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(this.chatOverlay.armourButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            if(param1.ctrlKey && this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1)
            {
               this.main.armourScreen.isEditMode = true;
            }
            else
            {
               this.main.armourScreen.isEditMode = false;
            }
            if(this.main.xml.xml.hasArmory == 1)
            {
               this.main.showScreen("armoury");
               this.main.soundManager.playSoundFullVolume("MenuTab");
            }
         }
         if(this.chatOverlay.leaderboardButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("leaderboard");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(this.chatOverlay.profileButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.profileScreen.setProfileToLoad(this.main.sfs.mySelf.name);
            this.main.showScreen("profile");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(this.chatOverlay.faqButton.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            this.main.showScreen("faq");
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
         if(Boolean(this.chatOverlay.profileButton.hitTestPoint(stage.mouseX,stage.mouseY)) && param1.ctrlKey)
         {
            if(this.main.clanId == -1)
            {
               this.main.showScreen("noClanScreen");
            }
            else
            {
               this.main.viewClanScreen.viewClan(this.main.clanName);
               this.main.showScreen("viewClanScreen");
            }
            this.main.soundManager.playSoundFullVolume("MenuTab");
         }
      }
      
      private function toggleMusic(param1:Event) : void
      {
         this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
         this.main.soundManager.isSound = this.main.soundManager.isMusic;
      }
      
      public function update(param1:Event) : void
      {
         var _loc4_:SFSObject = null;
         if(this.main.soundManager.isMusic)
         {
            this.chatOverlay.musicToggle.gotoAndStop(1);
         }
         else
         {
            this.chatOverlay.musicToggle.gotoAndStop(2);
         }
         this.chatOverlay.termsScreen.scrollPane.update();
         var _loc2_:Date = new Date();
         this.chatOverlay.timeText.text.text = _loc2_.hours + ":" + _loc2_.minutes;
         this.chatOverlay.lobbyButton.gotoAndStop(1);
         this.chatOverlay.armourButton.gotoAndStop(1);
         this.chatOverlay.leaderboardButton.gotoAndStop(1);
         this.chatOverlay.profileButton.gotoAndStop(1);
         this.chatOverlay.faqButton.gotoAndStop(1);
         var _loc3_:String = String(this.main.currentScreen());
         if(_loc3_ == "lobby" || Boolean(this.chatOverlay.lobbyButton.hitTestPoint(stage.mouseX,stage.mouseY)))
         {
            this.chatOverlay.lobbyButton.gotoAndStop(2);
         }
         if(_loc3_ == "armoury" || Boolean(this.chatOverlay.armourButton.hitTestPoint(stage.mouseX,stage.mouseY)))
         {
            this.chatOverlay.armourButton.gotoAndStop(2);
         }
         if(_loc3_ == "leaderboard" || Boolean(this.chatOverlay.leaderboardButton.hitTestPoint(stage.mouseX,stage.mouseY)))
         {
            this.chatOverlay.leaderboardButton.gotoAndStop(2);
         }
         if(_loc3_ == "profile" || Boolean(this.chatOverlay.profileButton.hitTestPoint(stage.mouseX,stage.mouseY)))
         {
            this.chatOverlay.profileButton.gotoAndStop(2);
         }
         if(_loc3_ == "faq" || Boolean(this.chatOverlay.faqButton.hitTestPoint(stage.mouseX,stage.mouseY)))
         {
            this.chatOverlay.faqButton.gotoAndStop(2);
         }
         ++this.frame;
         if(this.frame > 30 * 10)
         {
            _loc4_ = new SFSObject();
            this.main.sfs.send(new ExtensionRequest("getPopulation",_loc4_));
            this.frame = 0;
         }
         this.addManager.update();
         if(getTimer() - this.bonusShowTime < 2000)
         {
            this.chatOverlay.returningReward.bonusPopup.bonus.text = "";
            this.chatOverlay.returningReward.bonusPopup.bonus.text += int(Math.random() * 10);
            if(this.bonusReward >= 10)
            {
               this.chatOverlay.returningReward.bonusPopup.bonus.text += int(Math.random() * 10);
            }
            if(this.bonusReward >= 100)
            {
               this.chatOverlay.returningReward.bonusPopup.bonus.text += int(Math.random() * 10);
            }
         }
         else if(!this.playedBonusSound)
         {
            this.main.soundManager.playSoundFullVolume("newEmpirePoints");
            this.chatOverlay.returningReward.bonusPopup.bonus.text = "" + this.bonusReward;
            this.playedBonusSound = true;
         }
      }
      
      public function showReturningReward(param1:SFSObject) : void
      {
         if(param1.getBool("gotReward") == true)
         {
            this.chatOverlay.returningReward.visible = true;
            this.bonusReward = param1.getInt("reward");
            this.bonusShowTime = getTimer();
            this.playedBonusSound = false;
            this.chatOverlay.returningReward.days.text = param1.getInt("days");
         }
      }
      
      public function get buddyList() : com.brockw.stickwar.engine.multiplayer.BuddyList
      {
         return this._buddyList;
      }
      
      public function set buddyList(param1:com.brockw.stickwar.engine.multiplayer.BuddyList) : void
      {
         this._buddyList = param1;
      }
      
      public function get addManager() : AddManager
      {
         return this._addManager;
      }
      
      public function set addManager(param1:AddManager) : void
      {
         this._addManager = param1;
      }
   }
}
