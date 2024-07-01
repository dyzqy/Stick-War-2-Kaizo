package com.brockw.stickwar.engine.multiplayer
{
      import AS.encryption.MD5;
      import com.brockw.game.Screen;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.smartfoxserver.v2.core.*;
      import com.smartfoxserver.v2.entities.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import com.smartfoxserver.v2.requests.buddylist.*;
      import flash.display.*;
      import flash.events.*;
      import flash.external.*;
      import flash.net.*;
      
      public class LoginScreen extends Screen
      {
             
            
            private var main:Main;
            
            private var inputText:GenericTextInput;
            
            internal var btnConnect:GenericButton;
            
            internal var btnSingleplayer:GenericButton;
            
            internal var btnReplay:GenericButton;
            
            internal var loginMc:loginMenuMc;
            
            public var forgotPasswordForm:ForgotPasswordForm;
            
            private var justFailed:Boolean;
            
            private var _isConnecting:Boolean;
            
            public var preRegisterForm:PreRegisterForm;
            
            public var attemptAutoLoginAfterSignup:int = 0;
            
            private var newsPanels:Array;
            
            private var originalPanelX:Number = 0;
            
            private var newsIndex:int = 0;
            
            public function LoginScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  this.newsPanels = [];
                  this.loginMc = new loginMenuMc();
                  addChild(this.loginMc);
                  this.preRegisterForm = new PreRegisterForm(param1);
                  this.preRegisterForm.visible = false;
                  addChild(this.preRegisterForm);
                  this.forgotPasswordForm = new ForgotPasswordForm(param1);
                  this.addChild(this.forgotPasswordForm);
                  this.forgotPasswordForm.visible = false;
                  this.loginMc.versionText.text = param1.version;
                  this.getNewsItem(0);
                  this.getNewsItem(1);
                  this.getNewsItem(2);
                  this.originalPanelX = this.loginMc.newsContainer.x;
                  this.loginMc.leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrow);
                  this.loginMc.rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrow);
            }
            
            private function getNewsItem(param1:int) : *
            {
                  var loader:URLLoader;
                  var handleVariables:* = undefined;
                  var index:int = param1;
                  handleVariables = function(param1:Event):void
                  {
                        var _loc2_:String = String(param1.target.data);
                        var _loc3_:Array = _loc2_.split("\n",6);
                        var _loc4_:int = int(_loc3_[0]);
                        var _loc5_:String = String(_loc3_[1]);
                        var _loc6_:int = int(_loc3_[2]);
                        var _loc7_:String = String(_loc3_[3]);
                        var _loc8_:int = int(_loc3_[4]);
                        var _loc9_:String = String(_loc3_[5]);
                        var _loc10_:SFSObject;
                        (_loc10_ = new SFSObject()).putUtfString("title",_loc5_);
                        _loc10_.putUtfString("message",_loc9_);
                        _loc10_.putUtfString("youtubeId","");
                        _loc10_.putUtfString("date",_loc7_);
                        _loc10_.putInt("type",_loc6_);
                        _loc10_.putInt("id",_loc4_);
                        _loc10_.putInt("index",_loc8_);
                        receiveNewsItem(_loc10_);
                  };
                  var request:URLRequest = new URLRequest("http://www.stickempires.com/news.php?index=" + index);
                  request.method = URLRequestMethod.GET;
                  loader = new URLLoader();
                  loader.dataFormat = URLLoaderDataFormat.TEXT;
                  loader.addEventListener(Event.COMPLETE,handleVariables,false,0,true);
                  loader.load(request);
            }
            
            public function receiveNewsItem(param1:SFSObject) : void
            {
                  var _loc2_:String = param1.getUtfString("title");
                  var _loc3_:String = param1.getUtfString("message");
                  var _loc4_:String = param1.getUtfString("youtubeId");
                  var _loc5_:String = param1.getUtfString("date");
                  var _loc6_:int = param1.getInt("type");
                  var _loc7_:int = param1.getInt("index");
                  var _loc8_:int = param1.getInt("id");
                  if(_loc6_ == -1)
                  {
                        if(_loc7_ in this.newsPanels)
                        {
                              MovieClip(this.newsPanels[_loc7_]).parent.removeChild(MovieClip(this.newsPanels[_loc7_]));
                              delete this.newsPanels[_loc7_];
                        }
                        return;
                  }
                  if(!(_loc7_ in this.newsPanels))
                  {
                        this.newsPanels[_loc7_] = new NewsPanel(_loc2_,_loc3_,_loc5_,_loc6_,_loc7_,_loc4_,_loc8_);
                        this.loginMc.newsContainer.addChild(this.newsPanels[_loc7_]);
                        this.newsPanels[_loc7_].y = 0;
                        this.newsPanels[_loc7_].x += (this.newsPanels[_loc7_].index * 200 - this.newsPanels[_loc7_].x) * 1;
                  }
                  else if(this.newsPanels[_loc7_].id != _loc8_)
                  {
                        MovieClip(this.newsPanels[_loc7_]).parent.removeChild(MovieClip(this.newsPanels[_loc7_]));
                        this.newsPanels[_loc7_] = new NewsPanel(_loc2_,_loc3_,_loc5_,_loc6_,_loc7_,_loc4_,_loc8_);
                        this.loginMc.newsContainer.addChild(this.newsPanels[_loc7_]);
                        this.newsPanels[_loc7_].y = 0;
                        this.newsPanels[_loc7_].x += (this.newsPanels[_loc7_].index * 200 - this.newsPanels[_loc7_].x) * 1;
                  }
            }
            
            private function rightArrow(param1:Event) : void
            {
                  if(this.loginMc.newsContainer.x > -(this.loginMc.newsContainer.width - 1 * 200))
                  {
                        --this.newsIndex;
                  }
                  this.getNewsItem(-1 * this.newsIndex + 1);
            }
            
            private function leftArrow(param1:Event) : void
            {
                  ++this.newsIndex;
                  if(this.newsIndex > 0)
                  {
                        this.newsIndex = 0;
                  }
            }
            
            private function toggleMusic(param1:Event) : void
            {
                  this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
                  this.main.soundManager.isSound = this.main.soundManager.isMusic;
            }
            
            private function update(param1:Event) : void
            {
                  var _loc3_:NewsPanel = null;
                  var _loc2_:int = 0;
                  for each(_loc3_ in this.newsPanels)
                  {
                        _loc3_.update();
                        if(_loc2_ == -1 * this.newsIndex)
                        {
                              _loc3_.visible = true;
                        }
                        else
                        {
                              _loc3_.visible = false;
                        }
                        _loc2_++;
                  }
                  if(this.loginMc.newsContainer.x - this.originalPanelX > 0 * 200)
                  {
                        this.loginMc.newsContainer.x += (this.originalPanelX + this.newsIndex * 200 - this.loginMc.newsContainer.x) * 1;
                  }
                  else
                  {
                        this.loginMc.newsContainer.x += (this.originalPanelX + this.newsIndex * 200 - this.loginMc.newsContainer.x) * 1;
                  }
                  if(this.loginMc.newsContainer.x - this.originalPanelX <= -(this.loginMc.newsContainer.width - 1 * 200))
                  {
                        this.loginMc.rightArrow.visible = true;
                  }
                  else
                  {
                        this.loginMc.rightArrow.visible = true;
                  }
                  if(this.newsIndex == 0)
                  {
                        this.loginMc.leftArrow.visible = false;
                  }
                  else
                  {
                        this.loginMc.leftArrow.visible = true;
                  }
                  if(this.loginMc.connectingMc.currentFrame == this.loginMc.connectingMc.totalFrames)
                  {
                        this.loginMc.connectingMc.stop();
                  }
                  if(this.main.soundManager.isMusic)
                  {
                        this.loginMc.musicToggle.gotoAndStop(1);
                  }
                  else
                  {
                        this.loginMc.musicToggle.gotoAndStop(2);
                  }
            }
            
            override public function enter() : void
            {
                  this.loginMc.musicToggle.buttonMode = true;
                  this.loginMc.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
                  this.main.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.sfs.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
                  this.main.sfs.addEventListener(SFSEvent.LOGOUT,this.SFSLogout);
                  this.main.sfs.addEventListener(SFSEvent.ROOM_JOIN,this.SFSRoomJoin);
                  this.main.sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
                  this.loginMc.loginBox.usernameInput.text.addEventListener(Event.CHANGE,this.loginUserEnterButton);
                  this.loginMc.loginBox.passwordInput.text.addEventListener(Event.CHANGE,this.loginUserEnterButton);
                  this.loginMc.signIn.addEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  this.loginMc.loginBox.usernameInput.text.text = "";
                  this.loginMc.loginBox.passwordInput.text.text = "";
                  stage.frameRate = 30;
                  this.loginMc.loginBox.passwordInput.text.displayAsPassword = true;
                  this.loginMc.failBox.tryAgain.addEventListener(MouseEvent.CLICK,this.tryAgain);
                  this.justFailed = false;
                  this.addEventListener(Event.ENTER_FRAME,this.update);
                  this.loginMc.failBox.visible = false;
                  this.loginMc.loginBox.visible = true;
                  this.loginMc.connectingMc.visible = false;
                  this.loginMc.loginFacebook.addEventListener(MouseEvent.CLICK,this.loginWithFacebook);
                  this.loginMc.forgotPasswordButton.addEventListener(MouseEvent.CLICK,this.openForgotPassword);
                  this.loginMc.loginBox.usernameInput.addEventListener(MouseEvent.CLICK,this.inputClick);
                  this.loginMc.register.addEventListener(MouseEvent.CLICK,this.btnSingleplayerClick);
                  this.loginMc.guest.addEventListener(MouseEvent.CLICK,this.btnReplayClick);
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("facebookLogin",this.facebookLogin);
                  }
                  this.loginMc.loginBox.usernameInput.text.tabIndex = 1;
                  this.loginMc.loginBox.passwordInput.text.tabIndex = 2;
                  this.loginMc.signIn.tabIndex = 3;
            }
            
            public function facebookLogin(param1:String) : *
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("password","");
                  _loc2_.putBool("isFacebook",true);
                  _loc2_.putUtfString("fToken",param1);
                  _loc2_.putUtfString("version",this.main.version);
                  this.main.sfs.send(new LoginRequest(this.loginMc.loginBox.usernameInput.text.text,this.loginMc.loginBox.passwordInput.text.text,"stickwar",_loc2_));
                  this.loginMc.loginBox.usernameInput.buttonMode = false;
            }
            
            private function openForgotPassword(param1:Event) : void
            {
                  this.forgotPasswordForm.enter();
            }
            
            private function tryAgain(param1:Event) : void
            {
                  this.loginMc.failBox.visible = false;
                  this.loginMc.loginBox.visible = true;
                  this.justFailed = false;
            }
            
            private function loginWithFacebook(param1:Event) : void
            {
                  this.preRegisterForm.enter();
            }
            
            override public function leave() : void
            {
                  this.loginMc.loginFacebook.removeEventListener(MouseEvent.CLICK,this.loginWithFacebook);
                  this.main.sfs.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.sfs.removeEventListener(SFSEvent.LOGIN,this.SFSLogin);
                  this.main.sfs.removeEventListener(SFSEvent.ROOM_JOIN,this.SFSRoomJoin);
                  this.main.sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
                  this.loginMc.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
                  this.loginMc.loginBox.usernameInput.text.removeEventListener(Event.CHANGE,this.loginUserEnterButton);
                  this.loginMc.loginBox.passwordInput.text.removeEventListener(Event.CHANGE,this.loginUserEnterButton);
                  this.loginMc.failBox.tryAgain.addEventListener(MouseEvent.CLICK,this.tryAgain);
                  this.removeEventListener(Event.ENTER_FRAME,this.update);
                  this.loginMc.signIn.removeEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  this.loginMc.forgotPasswordButton.removeEventListener(MouseEvent.CLICK,this.openForgotPassword);
                  this.loginMc.loginBox.usernameInput.removeEventListener(MouseEvent.CLICK,this.inputClick);
                  this.loginMc.register.removeEventListener(MouseEvent.CLICK,this.btnSingleplayerClick);
                  this.loginMc.guest.removeEventListener(MouseEvent.CLICK,this.btnReplayClick);
            }
            
            public function inputClick(param1:MouseEvent) : void
            {
                  this.loginMc.loginBox.usernameInput.text.text = "";
            }
            
            public function btnSingleplayerClick(param1:MouseEvent) : void
            {
                  var _loc2_:URLRequest = null;
                  if(param1.ctrlKey)
                  {
                        this.main.singleplayerGameScreen.map = this.main.xml.xml.sandboxMap;
                        this.main.raceSelected = Team.getIdFromRaceName(this.main.xml.xml.debugTeamA);
                        this.main.singleplayerGameScreen.opponentRace = Team.getIdFromRaceName(this.main.xml.xml.debugTeamB);
                        this.main.showScreen("singleplayerGame");
                  }
                  else
                  {
                        _loc2_ = new URLRequest("http://www.stickempires.com/index.php");
                        navigateToURL(_loc2_,"_blank");
                  }
            }
            
            public function btnReplayClick(param1:MouseEvent) : void
            {
                  if(param1.ctrlKey)
                  {
                        this.main.showScreen("campaignMap");
                  }
            }
            
            public function btnConnectLogin(param1:MouseEvent) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  var _loc3_:String = MD5.hash(this.loginMc.loginBox.passwordInput.text.text);
                  this.main.passwordEncrypted = _loc3_;
                  _loc2_.putUtfString("password",_loc3_);
                  _loc2_.putUtfString("version",this.main.version);
                  _loc2_.putBool("isFacebook",false);
                  _loc2_.putInt("fuid",0);
                  this.main.sfs.send(new LoginRequest(this.loginMc.loginBox.usernameInput.text.text,this.loginMc.loginBox.passwordInput.text.text,"stickwar",_loc2_));
                  this.loginMc.loginBox.usernameInput.buttonMode = false;
            }
            
            public function SFSLoginError(param1:SFSEvent) : void
            {
                  trace("Can not login: ",param1.params.errorMessage,param1.params.errorCode);
                  if(param1.params.errorCode == 8)
                  {
                        this.main.showScreen("versionMismatch");
                  }
                  if(param1.params.errorCode == 7)
                  {
                        this.loginMc.failBox.loginError.text = "Server is full";
                  }
                  else if(param1.params.errorCode == 10)
                  {
                        this.loginMc.failBox.loginError.text = "Please check your email to complete the signup process";
                  }
                  else if(param1.params.errorCode == 4)
                  {
                        this.loginMc.failBox.loginError.text = "User has been Banned";
                  }
                  else if(param1.params.errorCode == 11)
                  {
                        this.loginMc.failBox.loginError.text = "IP Address has been Banned";
                  }
                  else
                  {
                        this.loginMc.failBox.loginError.text = "Login Failed";
                  }
                  this.loginMc.loginBox.usernameInput.buttonMode = true;
                  this.justFailed = true;
                  this.loginMc.loginBox.visible = false;
                  this.loginMc.failBox.visible = true;
            }
            
            public function SFSLogout(param1:SFSEvent) : void
            {
                  if(this.attemptAutoLoginAfterSignup > 0)
                  {
                        this.btnConnectLogin(null);
                        --this.attemptAutoLoginAfterSignup;
                  }
            }
            
            public function SFSLogin(param1:SFSEvent) : void
            {
                  trace("Logged into: " + this.main.sfs.currentZone);
                  if(this.main.sfs.currentZone == "stickwar")
                  {
                        this.loginMc.loginBox.usernameInput.text.text = "Joining Main Lobby...";
                        this.main.sfs.send(new JoinRoomRequest("Lobby"));
                        this.main.soundManager.playSoundFullVolume("LoginSound");
                  }
            }
            
            private function loginUserEnterButton(param1:Event) : void
            {
                  var _loc2_:String = String(param1.target.text);
                  if(_loc2_.charCodeAt(_loc2_.length - 1) == 13)
                  {
                        _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
                        param1.target.text = _loc2_;
                        if(param1.target == this.loginMc.loginBox.usernameInput.text)
                        {
                              stage.focus = this.loginMc.loginBox.passwordInput.text;
                        }
                        else
                        {
                              this.btnConnectLogin(null);
                        }
                  }
            }
            
            public function SFSRoomJoin(param1:SFSEvent) : void
            {
                  if(param1.params.room.name == "Lobby")
                  {
                        this.main.lobby = param1.params.room;
                        this.main.showScreen("lobby");
                  }
                  else
                  {
                        this.SFSRoomJoinError(param1);
                  }
            }
            
            public function SFSRoomJoinError(param1:SFSEvent) : void
            {
                  trace("Can not join Lobby");
                  if(this.btnConnect)
                  {
                        if(this.btnConnect.text)
                        {
                              this.btnConnect.text.text = "Login";
                              this.btnConnect.buttonMode = true;
                        }
                  }
            }
            
            public function get isConnecting() : Boolean
            {
                  return this._isConnecting;
            }
            
            public function set isConnecting(param1:Boolean) : void
            {
                  if(param1)
                  {
                        this.loginMc.failBox.visible = false;
                        this.loginMc.loginBox.visible = false;
                        this.loginMc.connectingMc.visible = true;
                        this.loginMc.connectingMc.gotoAndPlay(1);
                  }
                  else
                  {
                        if(!this.justFailed)
                        {
                              this.loginMc.failBox.visible = false;
                              this.loginMc.loginBox.visible = true;
                        }
                        else
                        {
                              this.loginMc.failBox.visible = true;
                              this.loginMc.loginBox.visible = false;
                        }
                        this.loginMc.connectingMc.visible = false;
                  }
                  this._isConnecting = param1;
            }
      }
}
