package com.brockw.stickwar
{
   import com.brockw.game.*;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.multiplayer.*;
   import com.brockw.stickwar.engine.replay.*;
   import com.brockw.stickwar.market.*;
   import com.brockw.stickwar.singleplayer.*;
   import com.smartfoxserver.v2.*;
   import com.smartfoxserver.v2.core.*;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class RegisterMain extends ScreenManager
   {
       
      
      protected var _sfs:SmartFox;
      
      private var _lobby:Room;
      
      private var signUpScreen:SignUpScreen;
      
      private var _mainIp:String;
      
      private var connectRetryTimer:Timer;
      
      public var referrer:String;
      
      public function RegisterMain()
      {
         super();
         var _loc1_:XMLLoader = new XMLLoader();
         this._sfs = new SmartFox();
         this._sfs.debug = false;
         this.sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         this._sfs.addEventListener(SFSEvent.CONNECTION_LOST,this.onConnectionLost);
         this._sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         this._sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         addScreen("login",this.signUpScreen = new SignUpScreen(this));
         this.signUpScreen.signUpForm.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
         showScreen("login");
         this.sfs.useBlueBox = true;
         this.mainIp = _loc1_.xml.mainServer;
         if(_loc1_.xml.isTesting == 1)
         {
            this.mainIp = _loc1_.xml.testServer;
         }
         this._sfs.connect(this.mainIp,9933);
         this.sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         this.connectRetryTimer = new Timer(5000);
         this.connectRetryTimer.addEventListener(TimerEvent.TIMER,this.connectRetry);
         trace("Register MAIN STUFF");
         this.referrer = "";
         addEventListener(Event.ADDED_TO_STAGE,this.aToStage);
      }
      
      private function aToStage(param1:Event) : void
      {
         var _loc2_:Object = LoaderInfo(stage.root.loaderInfo).parameters.referrer;
         if(_loc2_)
         {
            this.referrer = _loc2_.toString();
         }
      }
      
      private function playButton(param1:Event) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.stickempires.com/play");
         navigateToURL(_loc2_,"_self");
      }
      
      private function onConnection(param1:SFSEvent) : void
      {
         if(param1.params.success)
         {
            trace("Connection Success!");
            this.connectRetryTimer.stop();
            this.sfs.send(new LoginRequest("register" + Math.random(),"","StickEmpiresRegister"));
         }
         else
         {
            trace("Connection Failure: " + param1.params.errorMessage);
            this.connectRetryTimer.start();
         }
      }
      
      private function onConnectionLost(param1:SFSEvent) : void
      {
         if(this.currentScreen() == "singleplayerGame" || this.currentScreen() == "replayGame")
         {
         }
         trace("Connection was lost. Reason: " + param1.params.reason);
         trace("Try to reconnect...");
         this.connectRetryTimer.start();
      }
      
      private function connectRetry(param1:Event) : void
      {
         trace("try to connect");
         this._sfs.connect(this.mainIp,9933);
      }
      
      public function extensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:SFSObject = param1.params.params;
         switch(param1.params.cmd)
         {
            case "checkAvailability":
               trace("Received availability data");
               trace(_loc2_.getUtfString("username")," - ",_loc2_.getBool("available"));
               this.signUpScreen.signUpForm.usernameAvailable(_loc2_.getUtfString("username"),_loc2_.getBool("available"));
               break;
            case "registerUser":
               trace("Register user response: ",_loc2_.getBool("success"));
               this.signUpScreen.signUpForm.registerResponse(_loc2_.getBool("success"),_loc2_.getBool("usernameUnique"),_loc2_.getBool("emailUnique"),_loc2_.getBool("emailValid"));
         }
      }
      
      private function onConfigLoadSuccess(param1:SFSEvent) : void
      {
         trace("Config load success!");
         trace("Server settings: " + this._sfs.config.host + ":" + this._sfs.config.port);
      }
      
      private function onConfigLoadFailure(param1:SFSEvent) : void
      {
         trace("Config load failure!!!");
      }
      
      public function get sfs() : SmartFox
      {
         return this._sfs;
      }
      
      public function set sfs(param1:SmartFox) : void
      {
         this._sfs = param1;
      }
      
      public function get mainIp() : String
      {
         return this._mainIp;
      }
      
      public function set mainIp(param1:String) : void
      {
         this._mainIp = param1;
      }
   }
}
