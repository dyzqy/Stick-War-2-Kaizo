package com.brockw.stickwar
{
      import com.brockw.game.*;
      import com.brockw.stickwar.campaign.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.google.analytics.*;
      import flash.display.*;
      import flash.events.*;
      import flash.external.*;
      import flash.net.*;
      import flash.system.*;
      
      public class stickwar2 extends BaseMain
      {
             
            
            private var campaignMenuScreen:CampaignMenuScreen;
            
            private var _postGameScreen:PostGameScreen;
            
            public function stickwar2()
            {
                  super();
                  var _loc1_:XMLLoader = new XMLLoader();
                  this.xml = _loc1_;
                  isCampaignDebug = _loc1_.xml.campaignDebug == 1;
                  postGameScreen = new PostGameScreen(this);
                  addScreen("postGame",postGameScreen);
                  addScreen("campaignMap",new CampaignScreen(this));
                  addScreen("campaignGameScreen",new CampaignGameScreen(this));
                  addScreen("campaignUpgradeScreen",new CampaignUpgradeScreen(this));
                  addScreen("summary",new EndOfGameSummary(this));
                  addScreen("mainMenu",this.campaignMenuScreen = new CampaignMenuScreen(this));
                  this.campaign = new Campaign(0,0);
                  this.addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
            }
            
            private function addedToStage(param1:Event) : void
            {
                  var _loc2_:Object = null;
                  var _loc3_:String = null;
                  var _loc4_:URLRequest = null;
                  var _loc5_:Loader = null;
                  showScreen("mainMenu");
                  tracker = null;
                  if(ExternalInterface.available)
                  {
                        tracker = new GATracker(this,"UA-36522838-2","AS3",false);
                        tracker.trackPageview("/play");
                        tracker.trackEvent("hostname","url",stage.loaderInfo.url);
                  }
                  if(xml.xml.isKongregate == 1)
                  {
                        _loc2_ = LoaderInfo(stage.root.loaderInfo).parameters;
                        _loc3_ = String(String(_loc2_.kongregate_api_path) || "http://www.kongregate.com/flash/API_AS3_Local.swf");
                        isKongregate = true;
                        Security.allowDomain(_loc3_);
                        _loc4_ = new URLRequest(_loc3_);
                        (_loc5_ = new Loader()).contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
                        _loc5_.load(_loc4_);
                        this.addChild(_loc5_);
                  }
            }
            
            internal function loadComplete(param1:Event) : void
            {
                  kongregate = param1.target.content;
                  kongregate.services.connect();
            }
      }
}
