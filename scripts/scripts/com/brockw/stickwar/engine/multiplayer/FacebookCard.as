package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.external.*;
      import flash.net.*;
      import flash.system.*;
      import flash.utils.*;
      
      public class FacebookCard extends facebookUserCard
      {
             
            
            public var username:String;
            
            public var rating:int;
            
            public var fuid:Number;
            
            public var id:int;
            
            internal var main:Main;
            
            private var requestLoadTime:Number;
            
            private var loader:Loader;
            
            private var myURLRequest:URLRequest;
            
            private var loading:Boolean;
            
            public function FacebookCard(param1:Main, param2:Number)
            {
                  var _loc3_:SFSObject = null;
                  var _loc4_:ExtensionRequest = null;
                  this.main = param1;
                  this.fuid = param2;
                  if(param2 == -1)
                  {
                        gotoAndStop(2);
                  }
                  else
                  {
                        gotoAndStop(3);
                        _loc3_ = new SFSObject();
                        _loc3_.putLong("fuid",param2);
                        _loc4_ = new ExtensionRequest("getFacebookUserDetails",_loc3_);
                        param1.sfs.send(_loc4_);
                        this.requestLoadTime = getTimer();
                        this.loading = true;
                  }
                  this.rating = 0;
                  this.username = "";
                  this.loading = false;
                  super();
                  this.requestLoadTime = 0;
                  addEventListener(MouseEvent.CLICK,this.click);
                  buttonMode = true;
            }
            
            private function click(param1:Event) : void
            {
                  if(this.username != "")
                  {
                        Main(this.main).profileScreen.setProfileToLoad(this.username);
                        this.main.showScreen("profile");
                  }
                  else if(this.main.isOnFacebook)
                  {
                        if(ExternalInterface.available)
                        {
                              ExternalInterface.call("friendRequest");
                        }
                  }
                  else
                  {
                        this.main.mainLobbyScreen.showNotOnFacebookCard();
                  }
            }
            
            public function loadData(param1:SFSObject) : void
            {
                  var _loc3_:SFSObject = null;
                  this.username = param1.getUtfString("username");
                  this.rating = param1.getDouble("rating");
                  this.loading = false;
                  if(this.username == "" || this.rating == 0)
                  {
                        gotoAndStop(2);
                        return;
                  }
                  if(!(param1.getInt("id") in Main(this.main).chatOverlay.buddyList.buddyMap))
                  {
                        _loc3_ = new SFSObject();
                        _loc3_.putUtfString("buddy",this.username);
                        _loc3_.putInt("permission",1);
                        _loc3_.putInt("response",0);
                        this.main.sfs.send(new ExtensionRequest("buddyAdd",_loc3_));
                        trace("ATTEMPT TO ADD");
                  }
                  gotoAndStop(3);
                  var _loc2_:LoaderContext = new LoaderContext();
                  _loc2_.checkPolicyFile = false;
                  this.loader = new Loader();
                  this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onImageLoaded);
                  this.myURLRequest = new URLRequest("https://graph.facebook.com/" + this.fuid + "/picture");
                  this.loader.load(this.myURLRequest,_loc2_);
            }
            
            private function onImageLoaded(param1:Event) : void
            {
                  gotoAndStop(1);
                  container.addChild(this.loader);
                  this.loader.x = -this.loader.width / 2;
                  this.loader.y = -this.loader.height / 2;
            }
            
            public function update() : void
            {
                  if(Boolean(this.loading) && getTimer() - this.requestLoadTime > 3000)
                  {
                        gotoAndStop(3);
                  }
                  else if(!this.loading && this.username != "")
                  {
                        gotoAndStop(1);
                  }
                  if(usernameText)
                  {
                        usernameText.text = this.username;
                        usernameText.mouseEnabled = false;
                  }
                  if(ratingText)
                  {
                        ratingText.text = "" + int(this.rating);
                        ratingText.mouseEnabled = false;
                  }
            }
            
            public function cleanUp() : void
            {
                  removeEventListener(MouseEvent.CLICK,this.click);
            }
      }
}
