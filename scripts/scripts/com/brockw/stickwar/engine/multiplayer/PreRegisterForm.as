package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.core.*;
      import com.smartfoxserver.v2.entities.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import com.smartfoxserver.v2.requests.buddylist.*;
      import flash.events.*;
      import flash.text.*;
      
      public class PreRegisterForm extends registerForm
      {
             
            
            private var tryingToConnect:Boolean;
            
            private var main:BaseMain;
            
            private var hasRegistered:Boolean;
            
            public function PreRegisterForm(param1:BaseMain)
            {
                  super();
                  this.main = param1;
            }
            
            public function enter() : void
            {
                  trace("ENTER THE REGISTRATION");
                  this.addEventListener(Event.ENTER_FRAME,this.update);
                  gotoAndStop(1);
                  this.hasRegistered = false;
                  this.visible = true;
                  this.y = -700;
                  this.tryingToConnect = true;
                  var _loc1_:String = "";
                  var _loc2_:int = 0;
                  while(_loc2_ < 10)
                  {
                        _loc1_ += Math.round(Math.random() * 10);
                        _loc2_++;
                  }
                  this.main.sfs.send(new LoginRequest("register" + _loc1_,"","StickEmpiresRegister"));
                  this.main.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.sfs.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
                  form.usernameField.text.addEventListener(Event.CHANGE,this.usernameChanged);
                  TextField(this.form.passwordField.text).displayAsPassword = true;
                  TextField(this.form.confirmPasswordField.text).displayAsPassword = true;
                  close.addEventListener(MouseEvent.CLICK,this.closeForm);
                  form.confirmPasswordField.text.addEventListener(Event.CHANGE,this.passwordChanged);
                  this.form.emailConfirm.text = "";
                  form.passwordConfirm.text = "";
                  form.usernameField.text.text = "";
                  form.passwordField.text.text = "";
                  form.emailField.text.text = "";
                  form.confirmPasswordField.text.text = "";
                  form.usernameField.text.restrict = "A-Za-z0-9";
                  TextField(this.form.usernameField.text).maxChars = 15;
                  this.form.emailField.text.restrict = "^\n";
                  TextField(this.form.emailField.text).maxChars = 255;
                  this.form.passwordField.text.restrict = "^\n";
                  this.form.confirmPasswordField.text.restrict = "^\n";
                  form.usernameField.text.tabIndex = 1;
                  this.form.emailField.text.tabIndex = 2;
                  this.form.passwordField.text.tabIndex = 3;
                  this.form.confirmPasswordField.text.tabIndex = 4;
                  this.form.registerButton.tabIndex = 5;
                  this.form.usernameBacking.visible = false;
                  this.form.emailBacking.visible = false;
                  this.form.confirmBacking.visible = false;
                  form.registerButton.addEventListener(MouseEvent.CLICK,this.register);
                  form.availability.text = "";
                  form.emailConfirm.text = "";
                  form.passwordConfirm.text = "";
                  alpha = 0;
            }
            
            private function closeForm(param1:Event) : *
            {
                  this.leave();
            }
            
            private function attemptLogin() : *
            {
            }
            
            public function registerResponse(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : void
            {
                  if(param1)
                  {
                        this.leave();
                        Main(this.main).loginScreen.loginMc.loginBox.usernameInput.text.text = form.usernameField.text.text;
                        Main(this.main).loginScreen.loginMc.loginBox.passwordInput.text.text = form.passwordField.text.text;
                        Main(this.main).loginScreen.attemptAutoLoginAfterSignup = 1;
                  }
                  else
                  {
                        if(!param2)
                        {
                              form.availability.text = "Username is already taken";
                              this.form.usernameBacking.visible = true;
                        }
                        if(!param3)
                        {
                              form.emailConfirm.text = "Email address already in use";
                              this.form.emailBacking.visible = true;
                        }
                        if(!param4)
                        {
                              form.emailConfirm.text = "Email address is not valid";
                              this.form.emailBacking.visible = true;
                        }
                  }
            }
            
            private function continueClick(param1:Event) : void
            {
                  gotoAndStop(1);
                  this.leave();
            }
            
            private function performSanityChecks() : Boolean
            {
                  form.availability.text = "";
                  form.emailConfirm.text = "";
                  form.passwordConfirm.text = "";
                  this.form.usernameBacking.visible = false;
                  this.form.emailBacking.visible = false;
                  this.form.confirmBacking.visible = false;
                  var _loc1_:Boolean = true;
                  if(form.usernameField.text.text.length < 3)
                  {
                        form.availability.text = "Username must be atleast 3 characters";
                        this.form.usernameBacking.visible = true;
                        _loc1_ = false;
                  }
                  if(form.emailField.text.text.length < 1)
                  {
                        this.form.emailBacking.visible = true;
                        form.emailConfirm.text = "You must enter an email address";
                        _loc1_ = false;
                  }
                  if(form.confirmPasswordField.text.text.length < 8)
                  {
                        form.passwordConfirm.text = "Password must be alteast 8 characters";
                        this.form.confirmBacking.visible = true;
                        _loc1_ = false;
                  }
                  else if(form.confirmPasswordField.text.text != form.passwordField.text.text)
                  {
                        form.passwordConfirm.text = "Passwords must match";
                        this.form.confirmBacking.visible = true;
                        _loc1_ = false;
                  }
                  return _loc1_;
            }
            
            private function register(param1:Event) : void
            {
                  var _loc2_:SFSObject = null;
                  var _loc3_:ExtensionRequest = null;
                  if(this.performSanityChecks())
                  {
                        _loc2_ = new SFSObject();
                        _loc2_.putUtfString("username",form.usernameField.text.text);
                        _loc2_.putUtfString("firstName","Jane");
                        _loc2_.putUtfString("lastName","Doe");
                        _loc2_.putUtfString("password",form.passwordField.text.text);
                        _loc2_.putUtfString("email",form.emailField.text.text);
                        _loc2_.putUtfString("referrer",this.main.referrer);
                        _loc3_ = new ExtensionRequest("registerUser",_loc2_);
                        this.main.sfs.send(_loc3_);
                  }
            }
            
            private function emailChanged(param1:Event) : void
            {
            }
            
            private function passwordChanged(param1:Event) : void
            {
                  if(form.confirmPasswordField.text.text != form.passwordField.text.text)
                  {
                        form.passwordConfirm.text = "Passwords do not match";
                        this.form.confirmBacking.visible = true;
                  }
                  else
                  {
                        form.passwordConfirm.text = "";
                        this.form.confirmBacking.visible = false;
                  }
            }
            
            private function usernameChanged(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("username",form.usernameField.text.text);
                  var _loc3_:ExtensionRequest = new ExtensionRequest("checkAvailability",_loc2_);
                  this.main.sfs.send(_loc3_);
                  this.form.availability.text = "";
                  this.form.usernameBacking.visible = false;
            }
            
            public function usernameAvailable(param1:String, param2:Boolean) : void
            {
                  if(form.usernameField.text.text == param1)
                  {
                        if(!param2)
                        {
                              this.form.availability.text = "Not Available";
                              this.form.usernameBacking.visible = true;
                        }
                  }
            }
            
            public function leave() : void
            {
                  trace("LEAVE THE REGISTRATION");
                  gotoAndStop(1);
                  this.removeEventListener(Event.ENTER_FRAME,this.update);
                  this.visible = false;
                  this.main.sfs.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.sfs.removeEventListener(SFSEvent.LOGIN,this.SFSLogin);
                  this.main.sfs.send(new LogoutRequest());
                  form.usernameField.text.removeEventListener(Event.CHANGE,this.usernameChanged);
                  form.confirmPasswordField.text.removeEventListener(Event.CHANGE,this.passwordChanged);
                  form.usernameField.text.tabIndex = -1;
                  this.form.emailField.text.tabIndex = -1;
                  this.form.passwordField.text.tabIndex = -1;
                  this.form.confirmPasswordField.text.tabIndex = -1;
                  this.form.registerButton.tabIndex = -1;
                  form.registerButton.removeEventListener(MouseEvent.CLICK,this.register);
                  this.main.sfs.send(new LogoutRequest());
            }
            
            private function SFSLoginError(param1:SFSEvent) : void
            {
                  trace("Error login for registration",param1.params.error);
            }
            
            private function SFSLogin(param1:SFSEvent) : void
            {
                  trace("Logged in for registration");
                  this.tryingToConnect = false;
                  if(this.main.sfs.currentZone == "StickEmpiresRegister")
                  {
                  }
            }
            
            public function update(param1:Event) : void
            {
                  alpha += (1 - alpha) * 0.2;
                  y += (0 - this.y) * 1;
                  if(!this.tryingToConnect)
                  {
                  }
            }
      }
}
