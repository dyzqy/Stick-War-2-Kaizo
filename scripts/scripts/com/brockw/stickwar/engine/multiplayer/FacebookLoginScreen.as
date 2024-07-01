package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.core.*;
      import com.smartfoxserver.v2.entities.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import com.smartfoxserver.v2.requests.buddylist.*;
      import flash.events.*;
      import flash.external.*;
      
      public class FacebookLoginScreen extends Screen
      {
             
            
            private var main:Main;
            
            private var justFailed:Boolean;
            
            private var _isConnecting:Boolean;
            
            private var mc:facebookLoginScreenMc;
            
            public var serverManager:ServerManager;
            
            private var hasCheckedForAccount:Boolean;
            
            private var exists:Boolean;
            
            private var waitingForSuggestedNameResponse:Boolean;
            
            private var waitingForCreateAccountResponse:Boolean;
            
            public function FacebookLoginScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  this.mc = new facebookLoginScreenMc();
                  addChild(this.mc);
                  this.serverManager = new ServerManager(param1.mainIp,this.registerExtensionHandler,this.onConnection,this.lostConnection);
            }
            
            private function update(param1:Event) : void
            {
                  if(this.serverManager.sfs.mySelf == null || !this.hasCheckedForAccount || Boolean(this.exists) || Boolean(this.waitingForCreateAccountResponse))
                  {
                        this.mc.connecting.visible = true;
                        this.mc.createUsernameBox.visible = false;
                  }
                  else
                  {
                        this.mc.connecting.visible = false;
                        this.mc.createUsernameBox.visible = true;
                  }
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
            
            override public function enter() : void
            {
                  this.mc.alreadyHaveAccoutCard.visible = false;
                  this.waitingForCreateAccountResponse = false;
                  stage.frameRate = 30;
                  this.serverManager.sfs.addEventListener(SFSEvent.LOGIN,this.loginHandler);
                  this.addEventListener(Event.ENTER_FRAME,this.update);
                  this.hasCheckedForAccount = false;
                  this.exists = false;
                  this.waitingForSuggestedNameResponse = true;
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("retrieveFacebookName",this.retrieveFacebookName);
                  }
                  this.mc.createUsernameBox.indicator.visible = false;
                  this.mc.createUsernameBox.usernameInput.restrict = "A-Za-z0-9";
                  this.mc.createUsernameBox.usernameInput.maxChars = 15;
                  this.mc.createUsernameBox.usernameInput.addEventListener(Event.CHANGE,this.updatedUsernameInput);
                  this.mc.createUsernameBox.errorText.visible = false;
                  this.mc.createUsernameBox.alreadyHaveAccountButton.addEventListener(MouseEvent.CLICK,this.alreadyHaveAccount);
                  this.mc.alreadyHaveAccoutCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton);
                  this.mc.alreadyHaveAccoutCard.alreadyText.text = "";
                  this.mc.alreadyHaveAccoutCard.alreadyText.htmlText = "1. Login to your existing account at <a href=\'http://www.stickempires.com/play\' target=\'_blank\'>www.stickempires.com/play</a><br><br>2. Go to the profile page tab<br><br>3. Click on the link to facebook button<br><br>4. After the link has been made refresh this page";
            }
            
            private function closeButton(param1:Event) : void
            {
                  this.mc.alreadyHaveAccoutCard.visible = false;
            }
            
            private function updatedUsernameInput(param1:Event) : void
            {
                  this.mc.createUsernameBox.indicator.visible = false;
                  if(this.mc.createUsernameBox.usernameInput.text.length <= 3)
                  {
                        return;
                  }
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("username",this.mc.createUsernameBox.usernameInput.text);
                  var _loc3_:ExtensionRequest = new ExtensionRequest("checkAvailability",_loc2_);
                  this.serverManager.sfs.send(_loc3_);
                  this.mc.createUsernameBox.indicator.visible = false;
                  this.mc.createUsernameBox.createUsername.addEventListener(MouseEvent.CLICK,this.signUpFacebook);
            }
            
            private function signUpFacebook(param1:Event) : void
            {
                  var _loc2_:String = "";
                  if(ExternalInterface.available)
                  {
                        _loc2_ = String(ExternalInterface.call("getFacebookToken"));
                  }
                  if(this.mc.createUsernameBox.usernameInput.text.length <= 3)
                  {
                        this.mc.createUsernameBox.indicator.gotoAndStop(3);
                        this.mc.createUsernameBox.indicator.visible = true;
                        return;
                  }
                  var _loc3_:SFSObject = new SFSObject();
                  _loc3_.putUtfString("token",_loc2_);
                  _loc3_.putUtfString("username",this.mc.createUsernameBox.usernameInput.text);
                  var _loc4_:ExtensionRequest = new ExtensionRequest("registerFacebookUser",_loc3_);
                  this.serverManager.sfs.send(_loc4_);
                  this.waitingForCreateAccountResponse = true;
            }
            
            public function retrieveFacebookName(param1:String = null) : *
            {
                  var _loc2_:String = "";
                  if(ExternalInterface.available)
                  {
                        _loc2_ = param1;
                        _loc2_ += "" + int(Math.random() * 10);
                        _loc2_ += "" + int(Math.random() * 10);
                        _loc2_ += "" + int(Math.random() * 10);
                  }
                  var _loc3_:SFSObject = new SFSObject();
                  _loc3_.putUtfString("username",_loc2_);
                  var _loc4_:ExtensionRequest = new ExtensionRequest("checkAvailability",_loc3_);
                  this.serverManager.sfs.send(_loc4_);
            }
            
            private function sendCheckForAutoName() : void
            {
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.call("getFacebookName");
                  }
            }
            
            private function registerExtensionHandler(param1:SFSEvent) : void
            {
                  var _loc3_:String = null;
                  var _loc4_:SFSObject = null;
                  var _loc2_:SFSObject = param1.params.params;
                  switch(param1.params.cmd)
                  {
                        case "checkAvailability":
                              trace("Received availability data");
                              trace(_loc2_.getUtfString("username")," - ",_loc2_.getBool("available"));
                              this.mc.createUsernameBox.indicator.visible = true;
                              if(_loc2_.getBool("available"))
                              {
                                    this.mc.createUsernameBox.indicator.gotoAndStop(1);
                              }
                              else
                              {
                                    this.mc.createUsernameBox.indicator.gotoAndStop(2);
                              }
                              break;
                        case "registerUser":
                              trace("Register user response: ",_loc2_.getBool("success"));
                              if(_loc2_.getBool("success"))
                              {
                                    _loc3_ = "";
                                    if(ExternalInterface.available)
                                    {
                                          _loc3_ = String(ExternalInterface.call("getFacebookToken"));
                                    }
                                    (_loc4_ = new SFSObject()).putUtfString("password","");
                                    _loc4_.putBool("isFacebook",true);
                                    _loc4_.putUtfString("fToken",_loc3_);
                                    _loc4_.putUtfString("version",this.main.version);
                                    this.main.sfs.send(new LoginRequest("","","stickwar",_loc4_));
                              }
                              else
                              {
                                    this.mc.createUsernameBox.errorText.visible = true;
                                    this.mc.createUsernameBox.errorText.text = _loc2_.getUtfString("message");
                                    this.waitingForCreateAccountResponse = false;
                              }
                              break;
                        case "exists":
                              trace("Exists: ",_loc2_.getBool("exists"));
                              this.hasCheckedForAccount = true;
                              this.exists = _loc2_.getBool("exists");
                              if(_loc2_.getBool("exists"))
                              {
                                    _loc3_ = "";
                                    if(ExternalInterface.available)
                                    {
                                          _loc3_ = String(ExternalInterface.call("getFacebookToken"));
                                    }
                                    (_loc4_ = new SFSObject()).putUtfString("password","");
                                    _loc4_.putBool("isFacebook",true);
                                    _loc4_.putUtfString("fToken",_loc3_);
                                    _loc4_.putUtfString("version",this.main.version);
                                    this.main.sfs.send(new LoginRequest("","","stickwar",_loc4_));
                              }
                  }
            }
            
            private function onConnection() : void
            {
                  this.serverManager.sfs.send(new LoginRequest("register" + Math.random(),"","StickEmpiresRegister"));
            }
            
            private function lostConnection() : void
            {
            }
            
            public function loginHandler(param1:SFSEvent) : void
            {
                  var _loc2_:String = "";
                  if(ExternalInterface.available)
                  {
                        _loc2_ = String(ExternalInterface.call("getFacebookToken"));
                  }
                  var _loc3_:SFSObject = new SFSObject();
                  _loc3_.putUtfString("token",_loc2_);
                  this.serverManager.sfs.send(new ExtensionRequest("checkFacebookExists",_loc3_));
            }
            
            private function alreadyHaveAccount(param1:Event) : void
            {
                  this.mc.alreadyHaveAccoutCard.visible = true;
            }
            
            override public function leave() : void
            {
                  this.mc.createUsernameBox.alreadyHaveAccountButton.addEventListener(MouseEvent.CLICK,this.alreadyHaveAccount);
                  this.mc.createUsernameBox.createUsername.removeEventListener(MouseEvent.CLICK,this.signUpFacebook);
                  this.serverManager.sfs.removeEventListener(SFSEvent.LOGIN,this.loginHandler);
                  this.removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.alreadyHaveAccoutCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton);
            }
      }
}
