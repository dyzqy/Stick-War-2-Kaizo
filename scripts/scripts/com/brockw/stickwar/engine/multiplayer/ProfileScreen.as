package com.brockw.stickwar.engine.multiplayer
{
      import AS.encryption.MD5;
      import com.brockw.game.Screen;
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.entities.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      import flash.display.*;
      import flash.events.*;
      import flash.external.*;
      import flash.net.*;
      import flash.system.*;
      import flash.text.*;
      
      public class ProfileScreen extends Screen
      {
            
            private static const BAR_LENGTH:int = 260;
             
            
            private var main:Main;
            
            private var mc:profileScreenMc;
            
            private var wins:int;
            
            private var loses:int;
            
            private var winsDeathmatch:int;
            
            private var losesDeathmatch:int;
            
            private var totalGames:int;
            
            private var totalDeathmatchGames:int;
            
            private var isChanging:Boolean;
            
            private var isChangingPassword:Boolean;
            
            private var loader:Loader;
            
            private var myURLRequest:URLRequest;
            
            private var profileImage:Sprite;
            
            private var hasNoPassword:Boolean;
            
            private var profileToLoad:String;
            
            private var gameRecords:Array;
            
            private var canAdd:Boolean;
            
            private var isOwnProfile:Boolean;
            
            private var usernameToBan:String = "";
            
            public function ProfileScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  this.isOwnProfile = false;
                  this.gameRecords = [];
                  this.mc = new profileScreenMc();
                  addChild(this.mc);
                  this.winsDeathmatch = 0;
                  this.losesDeathmatch = 0;
                  this.totalDeathmatchGames = 0;
                  this.mc.winsBar.width = 0;
                  this.mc.losesBar.width = 0;
                  this.mc.winsDeathmatchBar.width = 0;
                  this.mc.losesDeathmatchBar.width = 0;
                  this.canAdd = true;
                  this.isChanging = false;
                  this.profileImage = null;
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("retrieveFacebookId",this.retrieveFacebookId);
                  }
                  this.hasNoPassword = false;
                  this.profileToLoad = "";
                  this.mc.scrollPane.source = this.mc.matchesContainer;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
                  this.mc.banMessage.banStatus.visible = false;
                  this.mc.chatBanButton.visible = false;
            }
            
            public function loadProfile(param1:String) : void
            {
                  var _loc2_:SFSObject = null;
                  var _loc3_:ExtensionRequest = null;
                  this.usernameToBan = param1;
                  _loc2_ = new SFSObject();
                  _loc2_.putUtfString("name",param1);
                  _loc3_ = new ExtensionRequest("getProfile",_loc2_);
                  this.main.sfs.send(_loc3_);
                  var _loc4_:SFSObject;
                  (_loc4_ = new SFSObject()).putUtfString("name",param1);
                  var _loc5_:ExtensionRequest = new ExtensionRequest("getUsersGameHistory",_loc4_);
                  this.main.sfs.send(_loc5_);
                  this.mc.username.text = "";
                  this.mc.rating.text = "";
                  this.mc.winsBar.width = 0;
                  this.mc.losesBar.width = 0;
                  this.mc.winsCount.text = "0";
                  this.mc.losesCount.text = "0";
                  this.mc.winsDeathmatchCount.text = "0";
                  this.mc.losesDeathmatchCount.text = "0";
                  this.wins = 0;
                  this.loses = 0;
                  this.totalGames = 0;
                  this.mc.raceType.visible = false;
                  this.mc.changeEmailButton.visible = false;
                  this.mc.changePasswordButton.visible = false;
                  this.mc.addToFriendsButton.visible = false;
                  this.mc.isAMember.visible = false;
                  this.mc.isAMember.visible = false;
                  if(this.main.sfs.mySelf.name == param1)
                  {
                        this.isOwnProfile = true;
                  }
                  else
                  {
                        this.isOwnProfile = false;
                  }
                  if(this.main.sfs.mySelf.getVariable("isChatAdmin").getIntValue() == 1)
                  {
                        this.mc.banMessage.banStatus.visible = true;
                        this.mc.chatBanButton.visible = true;
                        _loc2_ = new SFSObject();
                        _loc2_.putUtfString("name",param1);
                        _loc3_ = new ExtensionRequest("getChatBanStatus",_loc2_);
                        this.main.sfs.send(_loc3_);
                  }
                  else
                  {
                        this.mc.banMessage.banStatus.visible = false;
                        this.mc.chatBanButton.visible = false;
                  }
            }
            
            public function receiveChatBanStatus(param1:SFSObject) : void
            {
                  var _loc2_:Boolean = param1.getBool("isChatBanned");
                  var _loc3_:Number = param1.getLong("timeChatBanExpires");
                  var _loc4_:* = _loc3_ / (60 * 60 * 24);
                  if(_loc2_)
                  {
                        if(_loc3_ < 3600)
                        {
                              this.mc.banMessage.banStatus.text = Math.ceil(_loc3_ / 60) + " minutes left in current ban.";
                        }
                        else if(_loc3_ < 3600 * 24)
                        {
                              this.mc.banMessage.banStatus.text = this.mc.banMessage.banStatus.text = Math.ceil(_loc3_ / (60 * 60)) + " hours left in current ban.";
                        }
                        else
                        {
                              this.mc.banMessage.banStatus.text = this.mc.banMessage.banStatus.text = Math.ceil(_loc3_ / (60 * 60 * 24)) + " days left in current ban.";
                        }
                  }
                  else
                  {
                        this.mc.banMessage.banStatus.text = "Not banned from chat";
                  }
            }
            
            public function receiveGameHistory(param1:SFSObject) : void
            {
                  var _loc3_:MatchRecord = null;
                  var _loc4_:int = 0;
                  var _loc5_:ISFSObject = null;
                  var _loc6_:Boolean = false;
                  var _loc7_:* = undefined;
                  var _loc8_:MatchRecord = null;
                  var _loc2_:ISFSArray = param1.getSFSArray("games");
                  for each(_loc3_ in this.gameRecords)
                  {
                        if(this.mc.matchesContainer.contains(_loc3_))
                        {
                              _loc3_.cleanUp();
                              this.mc.matchesContainer.removeChild(_loc3_);
                        }
                  }
                  this.gameRecords = [];
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.size())
                  {
                        _loc5_ = _loc2_.getSFSObject(_loc4_);
                        _loc6_ = true;
                        if(_loc5_.getUtfString("replayPointer") == "")
                        {
                              _loc6_ = false;
                        }
                        if(_loc5_.getUtfString("version") != this.main.version)
                        {
                              _loc6_ = false;
                        }
                        if(!this.isOwnProfile)
                        {
                              _loc6_ = false;
                        }
                        _loc7_ = !this.main.isMember && _loc4_ > 1;
                        _loc8_ = new MatchRecord(_loc7_,this.isOwnProfile,_loc5_.getUtfString("version"),_loc5_.getInt("win") == 1 ? true : false,_loc5_.getUtfString("userAusername"),_loc5_.getUtfString("userBusername"),_loc5_.getInt("raceA"),_loc5_.getInt("raceB"),_loc5_.getUtfString("replayPointer"),_loc5_.getInt("gameType"),_loc6_,this.main);
                        this.mc.matchesContainer.addChild(_loc8_);
                        _loc8_.y = _loc4_ * (54 + 55 / 4);
                        this.gameRecords.push(_loc8_);
                        _loc4_++;
                  }
            }
            
            public function receiveProfile(param1:SFSObject) : void
            {
                  var _loc5_:LoaderContext = null;
                  if(this.main.sfs.mySelf.name == param1.getUtfString("username"))
                  {
                        this.mc.changeEmailButton.visible = true;
                        this.mc.changePasswordButton.visible = true;
                        this.mc.addToFriendsButton.visible = false;
                  }
                  else
                  {
                        this.mc.changeEmailButton.visible = false;
                        this.mc.changePasswordButton.visible = false;
                        this.mc.addToFriendsButton.visible = true;
                        this.mc.connectToDifferentFacebookButton.visible = false;
                        if(param1.getInt("id") in Main(this.main).chatOverlay.buddyList.buddyMap)
                        {
                              this.mc.addToFriendsButton.visible = false;
                        }
                  }
                  if(!this.canAdd)
                  {
                        this.mc.addToFriendsButton.visible = false;
                  }
                  this.usernameToBan = param1.getUtfString("username");
                  this.mc.username.text = "" + param1.getUtfString("username");
                  this.mc.rating.text = "" + Math.floor(param1.getDouble("rating"));
                  this.mc.ratingDeathmatch.text = "" + Math.floor(param1.getDouble("ratingDeathmatch"));
                  this.mc.raceType.visible = true;
                  this.wins = param1.getInt("wins");
                  this.totalGames = param1.getInt("wins") + param1.getInt("loses");
                  this.loses = param1.getInt("loses");
                  this.winsDeathmatch = param1.getInt("winsDeathmatch");
                  this.totalDeathmatchGames = param1.getInt("winsDeathmatch") + param1.getInt("losesDeathmatch");
                  this.losesDeathmatch = param1.getInt("losesDeathmatch");
                  var _loc2_:int = param1.getInt("orderCount");
                  var _loc3_:int = param1.getInt("chaosCount");
                  var _loc4_:int = param1.getInt("randomCount");
                  this.hasNoPassword = param1.getBool("hasNoPassword");
                  trace("HAS NO PASS:",this.hasNoPassword);
                  if(_loc2_ > _loc3_ && _loc2_ > _loc4_)
                  {
                        this.mc.raceType.gotoAndStop("Order");
                  }
                  else if(_loc3_ > _loc2_ && _loc3_ > _loc4_)
                  {
                        this.mc.raceType.gotoAndStop("Chaos");
                  }
                  else
                  {
                        this.mc.raceType.gotoAndStop("Random");
                  }
                  if(param1.containsKey("isMember"))
                  {
                        this.mc.isAMember.visible = param1.getInt("isMember") == 1;
                  }
                  if(this.loader != null)
                  {
                        if(contains(this.loader))
                        {
                              removeChild(this.loader);
                        }
                  }
                  if(param1.getUtfString("fbid") != "")
                  {
                        (_loc5_ = new LoaderContext()).checkPolicyFile = false;
                        this.mc.connectToFacebookButton.visible = false;
                        this.loader = new Loader();
                        this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onImageLoaded);
                        addChild(this.loader);
                        this.loader.x = 620;
                        this.loader.y = 305;
                        this.myURLRequest = new URLRequest("https://graph.facebook.com/v2.3/" + param1.getUtfString("fbid") + "/picture");
                        this.loader.load(this.myURLRequest,_loc5_);
                        this.mc.connectToDifferentFacebookButton.visible = true;
                  }
                  else
                  {
                        this.mc.connectToDifferentFacebookButton.visible = false;
                        this.mc.connectToFacebookButton.visible = true;
                  }
                  if(this.loader)
                  {
                        this.loader.visible = true;
                        if(this.main.sfs.mySelf.name != param1.getUtfString("username"))
                        {
                              this.mc.connectToDifferentFacebookButton.visible = false;
                              this.mc.connectToFacebookButton.visible = false;
                              this.loader.visible = false;
                        }
                  }
            }
            
            private function onImageLoaded(param1:Event) : void
            {
                  this.loader.x -= this.loader.width / 2;
                  this.loader.y -= this.loader.height / 2;
                  if(!this.isOwnProfile)
                  {
                        this.loader.visible = false;
                  }
                  else
                  {
                        this.loader.visible = true;
                  }
            }
            
            public function update(param1:Event) : void
            {
                  this.mc.scrollPane.update();
                  if(this.totalGames >= 0)
                  {
                        this.mc.winsBar.width += (BAR_LENGTH * this.wins / Math.max(this.wins,this.loses) - this.mc.winsBar.width) * 0.1;
                        this.mc.losesBar.width += (BAR_LENGTH * this.loses / Math.max(this.wins,this.loses) - this.mc.losesBar.width) * 0.1;
                        this.mc.winsCount.text = "" + this.wins;
                        this.mc.losesCount.text = "" + this.loses;
                        if(this.totalGames == 0)
                        {
                              this.mc.winsCount.x = this.mc.winsBar.x + this.mc.winsCount.width * 0.2;
                              this.mc.losesCount.x = this.mc.losesBar.x + this.mc.losesCount.width * 0.2;
                        }
                        else
                        {
                              this.mc.winsCount.x = BAR_LENGTH * this.wins / Math.max(this.wins,this.loses) + this.mc.winsBar.x + this.mc.winsCount.width * 0.2;
                              this.mc.losesCount.x = BAR_LENGTH * this.loses / Math.max(this.wins,this.loses) + this.mc.losesBar.x + this.mc.losesCount.width * 0.2;
                        }
                  }
                  if(this.totalDeathmatchGames >= 0)
                  {
                        this.mc.winsDeathmatchBar.width += (BAR_LENGTH * this.winsDeathmatch / Math.max(this.winsDeathmatch,this.losesDeathmatch) - this.mc.winsDeathmatchBar.width) * 0.1;
                        this.mc.losesDeathmatchBar.width += (BAR_LENGTH * this.losesDeathmatch / Math.max(this.winsDeathmatch,this.losesDeathmatch) - this.mc.losesDeathmatchBar.width) * 0.1;
                        this.mc.winsDeathmatchCount.text = "" + this.winsDeathmatch;
                        this.mc.losesDeathmatchCount.text = "" + this.losesDeathmatch;
                        if(this.totalDeathmatchGames == 0)
                        {
                              this.mc.winsDeathmatchCount.x = this.mc.winsDeathmatchBar.x + this.mc.winsDeathmatchCount.width * 0.2;
                              this.mc.losesDeathmatchCount.x = this.mc.losesDeathmatchBar.x + this.mc.losesDeathmatchCount.width * 0.2;
                        }
                        else
                        {
                              this.mc.winsDeathmatchCount.x = BAR_LENGTH * this.winsDeathmatch / Math.max(this.winsDeathmatch,this.losesDeathmatch) + this.mc.winsDeathmatchBar.x + this.mc.winsDeathmatchCount.width * 0.2;
                              this.mc.losesDeathmatchCount.x = BAR_LENGTH * this.losesDeathmatch / Math.max(this.winsDeathmatch,this.losesDeathmatch) + this.mc.losesDeathmatchBar.x + this.mc.losesDeathmatchCount.width * 0.2;
                        }
                  }
                  if(this.isChanging)
                  {
                        this.mc.changeItemMc.visible = true;
                        if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
                        {
                              if(this.isChangingPassword)
                              {
                                    this.mc.changeItemMc.matchingText.text = "Passwords must match";
                              }
                              else
                              {
                                    this.mc.changeItemMc.matchingText.text = "Emails must match";
                              }
                        }
                        else
                        {
                              this.mc.changeItemMc.matchingText.text = "";
                        }
                        this.mc.winsBar.visible = false;
                        this.mc.winsText.visible = false;
                        this.mc.winsCount.visible = false;
                        this.mc.losesBar.visible = false;
                        this.mc.losesText.visible = false;
                        this.mc.losesCount.visible = false;
                        this.mc.losesdmText.visible = false;
                        this.mc.winsdmText.visible = false;
                        this.mc.winsDeathmatchBar.visible = false;
                        this.mc.losesDeathmatchBar.visible = false;
                        this.mc.losesDeathmatchCount.visible = false;
                        this.mc.winsDeathmatchCount.visible = false;
                  }
                  else
                  {
                        this.mc.changeItemMc.visible = false;
                        this.mc.winsBar.visible = true;
                        this.mc.winsText.visible = true;
                        this.mc.winsCount.visible = true;
                        this.mc.losesBar.visible = true;
                        this.mc.losesText.visible = true;
                        this.mc.losesCount.visible = true;
                        this.mc.losesdmText.visible = true;
                        this.mc.winsdmText.visible = true;
                        this.mc.winsDeathmatchBar.visible = true;
                        this.mc.losesDeathmatchBar.visible = true;
                        this.mc.losesDeathmatchCount.visible = true;
                        this.mc.winsDeathmatchCount.visible = true;
                  }
            }
            
            public function setProfileToLoad(param1:String, param2:Boolean = true) : void
            {
                  this.canAdd = param2;
                  this.profileToLoad = param1;
            }
            
            override public function enter() : void
            {
                  this.main.setOverlayScreen("chatOverlay");
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.linkMc.visible = false;
                  this.mc.linkMc.okButton.addEventListener(MouseEvent.CLICK,this.closeLinkMc);
                  this.mc.linkMc.copyButton.addEventListener(MouseEvent.CLICK,this.copyLinkMc);
                  this.mc.changeEmailButton.addEventListener(MouseEvent.CLICK,this.changeEmail);
                  this.mc.changePasswordButton.addEventListener(MouseEvent.CLICK,this.changePassword);
                  this.mc.changeItemMc.cancelButton.addEventListener(MouseEvent.CLICK,this.cancelButtonEvent);
                  this.mc.changeItemMc.changeButton.addEventListener(MouseEvent.CLICK,this.changeButtonEvent);
                  this.mc.changeMessage.okButton.addEventListener(MouseEvent.CLICK,this.okButton);
                  this.mc.addToFriendsButton.addEventListener(MouseEvent.CLICK,this.addToFriends);
                  this.mc.changeMessage.visible = false;
                  this.main.profileScreen.loadProfile(this.profileToLoad);
                  this.mc.connectToDifferentFacebookButton.addEventListener(MouseEvent.CLICK,this.removeFacebookLink);
                  this.mc.connectToFacebookButton.visible = false;
                  this.mc.connectToDifferentFacebookButton.visible = false;
                  this.mc.connectToFacebookButton.addEventListener(MouseEvent.CLICK,this.connectToFacebook);
                  this.mc.chatBanButton.addEventListener(MouseEvent.CLICK,this.openChatBanMenu);
                  this.mc.banMessage.visible = false;
                  this.mc.banMessage.closeButton.addEventListener(MouseEvent.CLICK,this.closeChatBanMenu);
                  this.mc.banMessage.ban1.addEventListener(MouseEvent.CLICK,this.ban1);
                  this.mc.banMessage.ban7.addEventListener(MouseEvent.CLICK,this.ban7);
                  this.mc.banMessage.banMonth.addEventListener(MouseEvent.CLICK,this.banMonth);
                  this.mc.banMessage.banYear.addEventListener(MouseEvent.CLICK,this.banYear);
                  this.mc.banMessage.banUnban.addEventListener(MouseEvent.CLICK,this.banUnban);
                  this.mc.banMessage.ban1Hour.addEventListener(MouseEvent.CLICK,this.ban1Hour);
            }
            
            public function openChatBanMenu(param1:Event) : void
            {
                  this.mc.banMessage.visible = true;
            }
            
            public function closeChatBanMenu(param1:Event) : void
            {
                  this.mc.banMessage.visible = false;
            }
            
            public function facebookConnectResponse(param1:String) : *
            {
                  if(param1 != "")
                  {
                        this.receiveChangeMessage("Connection to facebook account established");
                        this.main.profileScreen.loadProfile(this.main.sfs.mySelf.name);
                  }
                  else
                  {
                        this.receiveChangeMessage("Failed to connect to facebook account");
                  }
            }
            
            public function facebookRemoveResponse(param1:Boolean) : *
            {
                  if(param1)
                  {
                        this.receiveChangeMessage("Connection to facebook account removed");
                        this.main.profileScreen.loadProfile(this.main.sfs.mySelf.name);
                  }
                  else
                  {
                        this.receiveChangeMessage("Failed to remove facebook connectoin");
                  }
            }
            
            public function retrieveFacebookId(param1:String) : *
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("fuid",param1);
                  this.main.sfs.send(new ExtensionRequest("setFacebookConnection",_loc2_));
            }
            
            private function connectToFacebook(param1:Event) : void
            {
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.call("getFacebookId");
                  }
            }
            
            private function addToFriends(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("buddy",this.mc.username.text);
                  _loc2_.putInt("permission",1);
                  this.main.sfs.send(new ExtensionRequest("buddyAdd",_loc2_));
            }
            
            private function removeFacebookLink(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  this.main.sfs.send(new ExtensionRequest("removeFacebookConnection",_loc2_));
            }
            
            private function okButton(param1:Event) : void
            {
                  this.mc.changeMessage.visible = false;
            }
            
            private function cancelButtonEvent(param1:Event) : void
            {
                  this.isChanging = false;
            }
            
            private function changeButtonEvent(param1:Event) : void
            {
                  this.isChanging = false;
                  var _loc2_:SFSObject = new SFSObject();
                  if(this.isChangingPassword)
                  {
                        _loc2_.putUtfString("currentPassword",MD5.hash(this.mc.changeItemMc.currentPassword.text));
                        _loc2_.putUtfString("newPassword",MD5.hash(this.mc.changeItemMc.firstInput.text));
                        _loc2_.putUtfString("repeatPassword",MD5.hash(this.mc.changeItemMc.secondInput.text));
                        this.main.sfs.send(new ExtensionRequest("changePassword",_loc2_));
                  }
                  else
                  {
                        _loc2_.putUtfString("currentPassword",MD5.hash(this.mc.changeItemMc.currentPassword.text));
                        _loc2_.putUtfString("newEmail",this.mc.changeItemMc.firstInput.text);
                        _loc2_.putUtfString("repeatEmail",this.mc.changeItemMc.secondInput.text);
                        this.main.sfs.send(new ExtensionRequest("changeEmail",_loc2_));
                  }
            }
            
            public function showLinkMc(param1:String) : void
            {
                  this.mc.linkMc.link.text = param1;
                  this.mc.linkMc.visible = true;
            }
            
            private function closeLinkMc(param1:Event) : void
            {
                  this.mc.linkMc.visible = false;
            }
            
            private function copyLinkMc(param1:Event) : void
            {
                  System.setClipboard(this.mc.linkMc.link.text);
                  this.main.stage.focus = this.mc.linkMc.link;
                  this.mc.linkMc.link.setSelection(0,this.mc.linkMc.link.text.length);
            }
            
            public function receiveChangeMessage(param1:String) : void
            {
                  this.mc.changeMessage.messageText.text = param1;
                  this.mc.changeMessage.visible = true;
            }
            
            private function changeEmail(param1:Event) : void
            {
                  if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
                  {
                        return;
                  }
                  this.isChanging = true;
                  this.isChangingPassword = false;
                  this.mc.changeItemMc.firstText.text = "Email";
                  this.mc.changeItemMc.secondText.text = "Repeat Email";
                  this.mc.changeItemMc.currentPassword.text = "";
                  TextField(this.mc.changeItemMc.firstInput).displayAsPassword = false;
                  TextField(this.mc.changeItemMc.secondInput).displayAsPassword = false;
                  this.mc.changeItemMc.firstInput.text = "";
                  this.mc.changeItemMc.secondInput.text = "";
            }
            
            public function generatePasswordResponse(param1:String) : void
            {
                  this.receiveChangeMessage(param1);
            }
            
            private function changePassword(param1:Event) : void
            {
                  if(this.mc.changeItemMc.firstInput.text != this.mc.changeItemMc.secondInput.text)
                  {
                        return;
                  }
                  if(this.hasNoPassword)
                  {
                        this.main.sfs.send(new ExtensionRequest("generatePassword",null));
                  }
                  this.isChanging = true;
                  this.isChangingPassword = true;
                  this.mc.changeItemMc.firstInput.text = "";
                  this.mc.changeItemMc.secondInput.text = "";
                  this.mc.changeItemMc.currentPassword.text = "";
                  this.mc.changeItemMc.firstText.text = "Passsword";
                  this.mc.changeItemMc.secondText.text = "Repeat Password";
                  TextField(this.mc.changeItemMc.firstInput).displayAsPassword = true;
                  TextField(this.mc.changeItemMc.secondInput).displayAsPassword = true;
            }
            
            override public function leave() : void
            {
                  this.mc.connectToDifferentFacebookButton.removeEventListener(MouseEvent.CLICK,this.removeFacebookLink);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.connectToFacebookButton.removeEventListener(MouseEvent.CLICK,this.connectToFacebook);
                  this.mc.changeEmailButton.removeEventListener(MouseEvent.CLICK,this.changeEmail);
                  this.mc.changePasswordButton.removeEventListener(MouseEvent.CLICK,this.changePassword);
                  this.mc.changeItemMc.cancelButton.removeEventListener(MouseEvent.CLICK,this.cancelButtonEvent);
                  this.mc.changeItemMc.changeButton.removeEventListener(MouseEvent.CLICK,this.changeButtonEvent);
                  this.mc.changeMessage.okButton.removeEventListener(MouseEvent.CLICK,this.okButton);
                  this.mc.addToFriendsButton.removeEventListener(MouseEvent.CLICK,this.addToFriends);
                  this.mc.linkMc.okButton.removeEventListener(MouseEvent.CLICK,this.closeLinkMc);
                  this.mc.linkMc.copyButton.removeEventListener(MouseEvent.CLICK,this.copyLinkMc);
                  this.mc.chatBanButton.removeEventListener(MouseEvent.CLICK,this.openChatBanMenu);
                  this.mc.banMessage.closeButton.removeEventListener(MouseEvent.CLICK,this.closeChatBanMenu);
                  this.mc.banMessage.ban1.removeEventListener(MouseEvent.CLICK,this.ban1);
                  this.mc.banMessage.ban7.removeEventListener(MouseEvent.CLICK,this.ban7);
                  this.mc.banMessage.banMonth.removeEventListener(MouseEvent.CLICK,this.banMonth);
                  this.mc.banMessage.banYear.removeEventListener(MouseEvent.CLICK,this.banYear);
                  this.mc.banMessage.ban1Hour.removeEventListener(MouseEvent.CLICK,this.ban1Hour);
            }
            
            private function banUnban(param1:Event) : void
            {
                  this.banFromChat(-5);
            }
            
            private function ban1Hour(param1:Event) : void
            {
                  this.banFromChat(1);
            }
            
            private function ban1(param1:Event) : void
            {
                  this.banFromChat(1 * 24);
            }
            
            private function ban7(param1:Event) : void
            {
                  this.banFromChat(7 * 24);
            }
            
            private function banMonth(param1:Event) : void
            {
                  this.banFromChat(30 * 24);
            }
            
            private function banYear(param1:Event) : void
            {
                  this.banFromChat(365 * 24);
            }
            
            private function banFromChat(param1:Number) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putInt("hours",param1);
                  _loc2_.putUtfString("username",this.usernameToBan);
                  this.main.sfs.send(new ExtensionRequest("banFromChat",_loc2_));
            }
      }
}
