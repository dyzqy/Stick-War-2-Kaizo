package com.brockw.stickwar
{
      import com.brockw.game.*;
      import com.brockw.stickwar.campaign.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.brockw.stickwar.engine.replay.*;
      import com.brockw.stickwar.market.*;
      import com.brockw.stickwar.singleplayer.*;
      import com.google.analytics.AnalyticsTracker;
      import com.smartfoxserver.v2.SmartFox;
      import com.smartfoxserver.v2.entities.Room;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.utils.Timer;
      
      public class BaseMain extends ScreenManager
      {
             
            
            protected var _sfs:SmartFox;
            
            private var _raceSelected:int;
            
            public var tracker:AnalyticsTracker;
            
            private var _gameServer:SmartFox;
            
            private var _campaign:Campaign;
            
            private var _lobby:Room;
            
            private var _stickWar:StickWar;
            
            private var _isMember:Boolean;
            
            private var _postGameScreen:PostGameScreen;
            
            private var connectionScreen:Screen;
            
            private var signUpScreen:SignUpScreen;
            
            private var _replayLoaderScreen:ReplayLoaderScreen;
            
            private var _mainIp:String;
            
            private var _soundLoader:SoundLoader;
            
            private var _soundManager:SoundManager;
            
            private var connectRetryTimer:Timer;
            
            public var seed:int;
            
            public var xml:XMLLoader;
            
            public var status:int;
            
            private var _loadingFraction:Number;
            
            private var _loadingBar:MovieClip;
            
            public var isCampaignDebug:Boolean;
            
            public var currentReplayLink:String;
            
            public var isReplayMode:Boolean;
            
            public var replayModeCode:String;
            
            public var kongregate:*;
            
            public var isKongregate:Boolean;
            
            public function BaseMain()
            {
                  super();
                  this._loadingBar = null;
                  this.isCampaignDebug = false;
                  trace("BASE MAIN STUFF");
                  this.status = Buddy.S_ONLINE;
                  this.soundManager = new SoundManager(this);
                  this.soundLoader = new SoundLoader(this.soundManager);
                  this.isKongregate = false;
                  this._isMember = false;
                  this.currentReplayLink = "";
                  this.isReplayMode = false;
                  this.replayModeCode = "";
            }
            
            public function kongregateReportStatistic(param1:String, param2:int) : *
            {
                  if(this.kongregate != null && Boolean(this.xml.xml.isKongregate))
                  {
                        this.kongregate.stats.submit(param1,param2);
                  }
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
            
            public function willSeeAdds() : Boolean
            {
                  return !this.isMember && !this.isA();
            }
            
            public function isA() : Boolean
            {
                  var _loc1_:int = 0;
                  if(Boolean(this.sfs) && this.sfs.mySelf != null)
                  {
                        _loc1_ = int(this.sfs.mySelf.getVariable("dbid").getIntValue());
                        return _loc1_ % 2 == 0;
                  }
                  return true;
            }
            
            public function get campaign() : Campaign
            {
                  return this._campaign;
            }
            
            public function get postGameScreen() : PostGameScreen
            {
                  return this._postGameScreen;
            }
            
            public function set postGameScreen(param1:PostGameScreen) : void
            {
                  this._postGameScreen = param1;
            }
            
            public function set campaign(param1:Campaign) : void
            {
                  this._campaign = param1;
            }
            
            public function get stickWar() : StickWar
            {
                  return this._stickWar;
            }
            
            public function set stickWar(param1:StickWar) : void
            {
                  this._stickWar = param1;
            }
            
            public function get gameServer() : SmartFox
            {
                  return this._gameServer;
            }
            
            public function set gameServer(param1:SmartFox) : void
            {
                  this._gameServer = param1;
            }
            
            public function get soundLoader() : SoundLoader
            {
                  return this._soundLoader;
            }
            
            public function set soundLoader(param1:SoundLoader) : void
            {
                  this._soundLoader = param1;
            }
            
            public function get soundManager() : SoundManager
            {
                  return this._soundManager;
            }
            
            public function set soundManager(param1:SoundManager) : void
            {
                  this._soundManager = param1;
            }
            
            public function get loadingFraction() : Number
            {
                  return this._loadingFraction;
            }
            
            public function set loadingFraction(param1:Number) : void
            {
                  this._loadingFraction = param1;
            }
            
            public function get loadingBar() : MovieClip
            {
                  return this._loadingBar;
            }
            
            public function set loadingBar(param1:MovieClip) : void
            {
                  this._loadingBar = param1;
            }
            
            public function get replayLoaderScreen() : ReplayLoaderScreen
            {
                  return this._replayLoaderScreen;
            }
            
            public function set replayLoaderScreen(param1:ReplayLoaderScreen) : void
            {
                  this._replayLoaderScreen = param1;
            }
            
            public function get isMember() : Boolean
            {
                  return this._isMember;
            }
            
            public function set isMember(param1:Boolean) : void
            {
                  this._isMember = param1;
            }
            
            public function get raceSelected() : int
            {
                  return this._raceSelected;
            }
            
            public function set raceSelected(param1:int) : void
            {
                  this._raceSelected = param1;
            }
      }
}
