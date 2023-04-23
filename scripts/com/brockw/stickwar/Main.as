package com.brockw.stickwar
{
   import com.brockw.game.*;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.multiplayer.*;
   import com.brockw.stickwar.engine.multiplayer.clans.*;
   import com.brockw.stickwar.engine.replay.*;
   import com.brockw.stickwar.market.*;
   import com.brockw.stickwar.missions.*;
   import com.brockw.stickwar.singleplayer.*;
   import com.smartfoxserver.v2.*;
   import com.smartfoxserver.v2.core.*;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class Main extends BaseMain
   {
      
      public static var QUEUE_DODGE_WAIT_TIME:Number = 2 * 60 * 1000;
      
      public static const SwearWords:Class = Main_SwearWords;
       
      
      public var badWords:Array;
      
      public var badWorldRegex:RegExp;
      
      private var _gameIp:String;
      
      private var C_MATCHMAKE:int = 0;
      
      private var C_CIRCLE_MOVE:int = 0;
      
      private var _lobby:Room;
      
      private var _gameRoom:Room;
      
      private var _gameRoomName:String;
      
      private var _hasReceivedPurchases:Boolean;
      
      private var _trialGamesLeft:int;
      
      public var timeDodgedQueue:Number;
      
      public var didSelectRace:Boolean = false;
      
      private var _replayGameScreen:ReplayGameScreen;
      
      private var _marketScreen:MarketScreen;
      
      private var _armourScreen:NewArmoryScreen;
      
      private var _chatOverlay:ChatOverlayScreen;
      
      private var _lobbyScreen:RaceSelectionScreen;
      
      private var connectionScreen:Screen;
      
      private var _profileScreen:ProfileScreen;
      
      private var _leaderboardScreen:LeaderboardScreen;
      
      private var _campaignUpgradeScreen:CampaignUpgradeScreen;
      
      private var _campaignGameScreen:CampaignGameScreen;
      
      private var _loginScreen:LoginScreen;
      
      private var _facebookLoginScreen:FacebookLoginScreen;
      
      private var _multiplayerGameScreen:MultiplayerGameScreen;
      
      private var _faqScreen:FAQScreen;
      
      private var _mainLobbyScreen:MainLobbyScreen;
      
      private var _replayLoadingScreen:ReplayLoadingScreen;
      
      private var _liveReplaysScreen:LiveReplaysScreen;
      
      private var _customMatchScreen:CustomMatchScreen;
      
      private var loadingScreen:LoadingScreen;
      
      private var _singleplayerGameScreen:SingleplayerGameScreen;
      
      private var _singleplayerRaceSelectScreen:SingleplayerRaceSelect;
      
      private var _noClanScreen:NoClanScreen;
      
      private var _findClanScreen:FindClanScreen;
      
      private var _createClanScreen:CreateClanScreen;
      
      private var _viewClanScreen:ClanScreen;
      
      private var _clanRequestScreen:ClanRequestScreen;
      
      private var _publicClanScreen:PublicClanScreen;
      
      private var _mapScreen:EndlessCampaignScreen;
      
      private var _missionGameScreen:MissionGameScreen;
      
      private var _purchases:Array;
      
      private var _marketItems:Array;
      
      private var _itemMap:ItemMap;
      
      private var _loadout:Loadout;
      
      private var timer:Timer;
      
      public var _stickWarEngine;
      
      private var _mainIp:String;
      
      private var _inQueue:Boolean;
      
      private var _numberOfTrialsLeft:int;
      
      private var _isOnFacebook;
      
      private var connectRetryTimer:Timer;
      
      public var passwordEncrypted:String;
      
      private var _pendingMembership:Boolean;
      
      private var _empirePoints:int;
      
      public var referrer:String = "";
      
      public var version:String;
      
      public var clanName:String = "";
      
      public var clanId:int = -1;
      
      public function Main()
      {
         this.badWords = [];
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      public function get clanRequestScreen() : ClanRequestScreen
      {
         return this._clanRequestScreen;
      }
      
      public function set clanRequestScreen(param1:ClanRequestScreen) : void
      {
         this._clanRequestScreen = param1;
      }
      
      public function get viewClanScreen() : ClanScreen
      {
         return this._viewClanScreen;
      }
      
      public function set viewClanScreen(param1:ClanScreen) : void
      {
         this._viewClanScreen = param1;
      }
      
      public function get numberOfTrialsLeft() : int
      {
         return this._numberOfTrialsLeft;
      }
      
      public function set numberOfTrialsLeft(param1:int) : void
      {
         this._numberOfTrialsLeft = param1;
      }
      
      public function get trialGamesLeft() : int
      {
         return this._trialGamesLeft;
      }
      
      public function set trialGamesLeft(param1:int) : void
      {
         this._trialGamesLeft = param1;
      }
      
      public function get singleplayerGameScreen() : SingleplayerGameScreen
      {
         return this._singleplayerGameScreen;
      }
      
      public function set singleplayerGameScreen(param1:SingleplayerGameScreen) : void
      {
         this._singleplayerGameScreen = param1;
      }
      
      public function get liveReplaysScreen() : LiveReplaysScreen
      {
         return this._liveReplaysScreen;
      }
      
      public function set liveReplaysScreen(param1:LiveReplaysScreen) : void
      {
         this._liveReplaysScreen = param1;
      }
      
      public function init() : void
      {
         this._numberOfTrialsLeft = 0;
         this._trialGamesLeft = 0;
         currentReplayLink = "";
         this.timeDodgedQueue = getTimer() - Main.QUEUE_DODGE_WAIT_TIME;
         var _loc1_:XMLLoader = new XMLLoader();
         this.xml = _loc1_;
         this.version = _loc1_.xml.version;
         this._stickWarEngine = null;
         sfs = new SmartFox();
         gameServer = new SmartFox();
         this.connectionScreen = new ConnectionScreen(this);
         this._itemMap = new ItemMap();
         this._loadout = new Loadout();
         this._itemMap = new ItemMap();
         this._loadout = new Loadout();
         sfs.debug = false;
         seed = 0;
         sfs.addEventListener(SFSEvent.SOCKET_ERROR,this.connectRetry);
         sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         sfs.addEventListener(SFSEvent.CONNECTION_LOST,this.onConnectionLost);
         sfs.addEventListener(SFSEvent.LOGOUT,this.onConnectionLost);
         sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         addScreen("connect",this.connectionScreen);
         addScreen("login",this.loginScreen = new LoginScreen(this));
         this.lobbyScreen = new RaceSelectionScreen(this);
         addScreen("pickRace",this.lobbyScreen);
         addScreen("lobby",this.mainLobbyScreen = new MainLobbyScreen(this));
         addScreen("loading",this.loadingScreen = new LoadingScreen(this));
         addScreen("game",this.multiplayerGameScreen = new MultiplayerGameScreen(this));
         addScreen("singleplayerGame",this.singleplayerGameScreen = new SingleplayerGameScreen(this));
         this._replayGameScreen = new ReplayGameScreen(this);
         addScreen("replayGame",this._replayGameScreen);
         addScreen("replayLoader",replayLoaderScreen = new ReplayLoaderScreen(this));
         this._marketScreen = new MarketScreen(this);
         addScreen("market",this._marketScreen);
         this._armourScreen = new NewArmoryScreen(this);
         addScreen("armoury",this._armourScreen);
         this._chatOverlay = new ChatOverlayScreen(this);
         addScreen("chatOverlay",this._chatOverlay);
         this._profileScreen = new ProfileScreen(this);
         addScreen("profile",this._profileScreen);
         postGameScreen = new PostGameScreen(this);
         addScreen("postGame",postGameScreen);
         addScreen("campaignMap",new CampaignScreen(this));
         addScreen("campaignGameScreen",new CampaignGameScreen(this));
         addScreen("campaignUpgradeScreen",new CampaignUpgradeScreen(this));
         addScreen("leaderboard",this._leaderboardScreen = new LeaderboardScreen(this));
         addScreen("versionMismatch",new VersionMismatchScreen());
         addScreen("faq",this._faqScreen = new FAQScreen(BaseMain(this)));
         addScreen("replayLoadingScreen",this._replayLoadingScreen = new ReplayLoadingScreen(Main(this)));
         addScreen("liveMatches",this._liveReplaysScreen = new LiveReplaysScreen(Main(this)));
         addScreen("singleplayerRaceSelect",this._singleplayerRaceSelectScreen = new SingleplayerRaceSelect(this));
         addScreen("customMatch",this._customMatchScreen = new CustomMatchScreen(Main(this)));
         addScreen("mapScreen",this._mapScreen = new EndlessCampaignScreen(Main(this)));
         addScreen("missionScreen",this._missionGameScreen = new MissionGameScreen(Main(this)));
         this.inQueue = false;
         this.pendingMembership = false;
         this.lobby = null;
         this.gameRoom = null;
         showScreen("login");
         sfs.useBlueBox = false;
         gameServer.useBlueBox = false;
         mainIp = _loc1_.xml.mainServer;
         if(_loc1_.xml.isTesting == 1)
         {
            mainIp = _loc1_.xml.testServer;
         }
         addScreen("facebookLogin",this.facebookLoginScreen = new FacebookLoginScreen(this));
         trace("MAINIP:",mainIp);
         _sfs.connect(mainIp,9933);
         this.loginScreen.isConnecting = true;
         this.purchases = [];
         sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.extensionResponse);
         this.timer = new Timer(5000,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.keepAlive);
         this.timer.start();
         campaign = new Campaign(_loc1_.xml.skipToLevel,_loc1_.xml.campaignDifficulty);
         raceSelected = 0;
         this.connectRetryTimer = new Timer(250);
         this.connectRetryTimer.addEventListener(TimerEvent.TIMER,this.connectRetry);
         isMember = false;
         this.empirePoints = 0;
         this.isOnFacebook = false;
         Security.allowDomain("*.facebook.com");
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         addEventListener(Event.ADDED_TO_STAGE,this.aToStage);
         this.loadWords();
      }
      
      private function loadWords() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:ByteArray = new SwearWords();
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         _loc2_ = _loc2_.replace(" *","");
         _loc2_ = _loc2_.replace(/\r/g,"");
         this.badWords = _loc2_.split("\n");
         var _loc3_:String = "";
         for(_loc4_ in this.badWords)
         {
            if((_loc5_ = String(this.badWords[_loc4_].replace(/[^a-z]/gi,""))) == this.badWords[_loc4_])
            {
               _loc3_ += _loc3_ == "" ? "" : "|";
               _loc3_ += "" + _loc5_ + "";
            }
         }
         this.badWorldRegex = new RegExp(_loc3_,"gi");
      }
      
      private function aToStage(param1:Event) : void
      {
         var _loc2_:Object = LoaderInfo(stage.root.loaderInfo).parameters.referrer;
         if(_loc2_)
         {
            this.referrer = _loc2_.toString();
         }
      }
      
      private function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         this.init();
         var _loc2_:Object = LoaderInfo(stage.root.loaderInfo).parameters.isOnFacebook;
         if(_loc2_)
         {
            if(_loc2_.toString() == "true")
            {
               this.isOnFacebook = true;
            }
         }
         trace("Load variables");
         var _loc3_:Object = LoaderInfo(stage.root.loaderInfo).parameters.replay;
         var _loc4_:Object = LoaderInfo(stage.root.loaderInfo).parameters.version;
         if(Boolean(_loc3_) && Boolean(_loc4_))
         {
            isReplayMode = true;
            replayModeCode = _loc3_.toString();
            trace("Replay to load is",replayModeCode);
            this.currentReplayLink = "www.stickempires.com/play?replay=" + replayModeCode + "&version=" + _loc4_.toString();
            this.replayLoadingScreen.loadReplay(replayModeCode);
            showScreen("replayLoadingScreen");
         }
         if(this.isOnFacebook && !isReplayMode)
         {
            showScreen("facebookLogin");
         }
      }
      
      private function connectRetry(param1:Event) : void
      {
         trace("try to connect the main server");
         this.connectRetryTimer.delay = Math.min(this.connectRetryTimer.delay,5000);
         _sfs.connect(mainIp,9933);
      }
      
      private function keepAlive(param1:Event) : void
      {
         if(sfs.currentZone == "stickwar")
         {
            sfs.send(new ExtensionRequest("keepAlive",null));
         }
      }
      
      public function extensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:SFSObject = null;
         var _loc3_:SFSObject = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:SFSArray = null;
         _loc2_ = param1.params.params;
         switch(param1.params.cmd)
         {
            case "loadout":
               this.receiveLoadout(param1.params.params);
               trace("receiving loadout");
               break;
            case "empirePoints":
               this.armourScreen.receiveEmpirePoints(_loc2_.getInt("empirePoints"),_loc2_.getBool("isMember"),_loc2_.getBool("justBought"));
               trace("receiving empire points");
               break;
            case "marketItems":
               this.receiveMarketItems(param1.params.params);
               trace("receiving market items");
               break;
            case "purchases":
               this.receivePurchases(param1.params.params);
               trace("receiving purchases");
               break;
            case "buddyList":
               this._chatOverlay.buddyList.receiveBuddyList(param1.params.params);
               trace("receiving buddy list");
               break;
            case "buddyUpdate":
               this._chatOverlay.buddyList.receiveUpdate(param1.params.params);
               trace("update buddy list");
               break;
            case "buddyGameInvitation":
               _loc3_ = param1.params.params;
               _loc4_ = _loc3_.getInt("inviter");
               _loc5_ = _loc3_.getUtfString("name");
               this._chatOverlay.buddyList.startGameInvite(_loc4_,_loc5_);
               break;
            case "buddyChat":
               _loc3_ = param1.params.params;
               _loc6_ = _loc3_.getUtfString("n");
               _loc7_ = _loc3_.getInt("id");
               _loc8_ = _loc3_.getUtfString("m");
               this._chatOverlay.buddyList.receiveChat(_loc7_,_loc6_,_loc8_);
               trace("buddy chat");
               break;
            case "p":
               this.gameServer.send(new ExtensionRequest("p",_loc2_,this.gameRoom));
               break;
            case "chaosTrial":
               this.numberOfTrialsLeft = _loc2_.getInt("numberOfTrialsLeft");
               break;
            case "gameCreated":
               this.inQueue = false;
               if(this.currentScreen() == "game")
               {
                  trace("Already in game so do not join");
                  break;
               }
               trace("Game created on server: " + _loc2_.getUtfString("server"));
               trace("SEED",seed);
               this.gameIp = _loc2_.getUtfString("server");
               if(this.gameIp != mainIp)
               {
                  gameServer = new SmartFox();
                  gameServer.useBlueBox = false;
                  this.showScreen("loading");
                  this.didSelectRace = false;
                  gameServer.connect(this.gameIp,9933);
                  trace("Attempting to connect to game server",this.gameIp);
               }
               else
               {
                  gameServer = sfs;
                  trace("Playing on main server...");
               }
               break;
            case "gameRoomName":
               if(this.currentScreen() == "game")
               {
                  trace("Already in game so do not set game room");
                  break;
               }
               trace("Game room is: " + _loc2_.getUtfString("name"));
               this.gameRoomName = _loc2_.getUtfString("name");
               this.loadingScreen.isFresh = false;
               showScreen("loading");
               break;
            case "buddyAddResponse":
               trace("Buddy add response: " + _loc2_.getUtfString("response"));
               this._chatOverlay.addUserResponse(_loc2_.getUtfString("response"));
               break;
            case "inMatchmakingQueue":
               this.inQueue = true;
               this._chatOverlay.startQueueCount();
               break;
            case "notInMatchmakingQueue":
               this.inQueue = false;
               this.mainLobbyScreen.justCancelledQueue();
               break;
            case "leaderboard":
               trace("Received leaderboard data");
               this._leaderboardScreen.loadLeaderboardData(_loc2_.getSFSArray("data"));
               break;
            case "checkAvailability":
               trace("Received availability data");
               trace(_loc2_.getUtfString("username")," - ",_loc2_.getBool("available"));
               this.loginScreen.preRegisterForm.usernameAvailable(_loc2_.getUtfString("username"),_loc2_.getBool("available"));
               break;
            case "registerUser":
               trace("Register user response: ",_loc2_.getBool("success"));
               this.loginScreen.preRegisterForm.registerResponse(_loc2_.getBool("success"),_loc2_.getBool("usernameUnique"),_loc2_.getBool("emailUnique"),_loc2_.getBool("emailValid"));
               break;
            case "forgotPassword":
               trace("Forgot password response: ",_loc2_.getBool("success"));
               this.loginScreen.forgotPasswordForm.submitResponse(_loc2_.getBool("success"),_loc2_.getUtfString("message"));
               break;
            case "population":
               this._chatOverlay.setPopulation(_loc2_.getInt("n"));
               break;
            case "news":
               trace("receiving news");
               break;
            case "loadEngine":
               this.loadingScreen.receivedRaceSelection(_loc2_);
               break;
            case "raceTimeout":
               trace("TIMEOUT");
               if(this.currentScreen() == "game")
               {
                  trace("Already in game so forget about the imposter game");
                  break;
               }
               this.showScreen("lobby");
               if(this.didSelectRace)
               {
                  this._chatOverlay.addUserResponse("Opponent timed out. Hit find match to try again.",true);
               }
               else
               {
                  this._chatOverlay.addUserResponse("You failed to pick an empire. You must wait 2 minutes before rejoining the queue.",true,15);
                  this.timeDodgedQueue = getTimer();
               }
               break;
            case "loadTimeout":
               if(this.currentScreen() == "game")
               {
                  trace("Already in game so forget about the imposter game");
                  break;
               }
               addChild(this.multiplayerGameScreen);
               this.multiplayerGameScreen.cleanUp();
               removeChild(this.multiplayerGameScreen);
               this.showScreen("lobby");
               this._chatOverlay.addUserResponse("Opponent timed out. Hit find match to try again.",true);
               break;
            case "raceSelectCountdown":
               this.loadingScreen.setCountdown(_loc2_.getLong("timeLeft"));
               break;
            case "profile":
               trace("receiving profile");
               this._profileScreen.receiveProfile(_loc2_);
               this.postGameScreen.receiveProfile(_loc2_);
               this.mainLobbyScreen.receiveFacebookId(_loc2_.getUtfString("fbid"));
               break;
            case "changePassword":
               this._profileScreen.receiveChangeMessage(_loc2_.getUtfString("reply"));
               break;
            case "changeEmail":
               this._profileScreen.receiveChangeMessage(_loc2_.getUtfString("reply"));
               break;
            case "buyResponse":
               this.armourScreen.buyResponse(_loc2_.getInt("response"));
               break;
            case "termsOfService":
               trace("receiving TOS");
               this._chatOverlay.showTerms(_loc2_);
               break;
            case "faq":
               trace("receiving FAQ");
               this._faqScreen.loadFAQ(_loc2_);
               break;
            case "systemNotifcation":
               trace("Received notification:",_loc2_.getUtfString("message"));
               this._chatOverlay.addUserResponse(_loc2_.getUtfString("message"),true);
               break;
            case "feature":
               trace("RECEIVE FEATURE");
               this.mainLobbyScreen.recieveFeature(_loc2_);
               break;
            case "setFacebookConnectionResponse":
               trace("RECEIVE facebook connection response");
               this.profileScreen.facebookConnectResponse(_loc2_.getUtfString("fbid"));
               break;
            case "removeFacebookConnectionResponse":
               trace("RECEIVE facebook remove response");
               this.profileScreen.facebookRemoveResponse(_loc2_.getBool("success"));
               break;
            case "generatePassword":
               trace("RECEIVE facebook remove response");
               this.profileScreen.generatePasswordResponse(_loc2_.getUtfString("message"));
               break;
            case "facebookUserInfo":
               trace("RECEIVE facebook user info");
               this.mainLobbyScreen.facebookCardManager.receiveUserInfo(_loc2_);
               break;
            case "gameHistory":
               trace("Received game history");
               this.profileScreen.receiveGameHistory(_loc2_);
               break;
            case "liveGames":
               trace("Received live games");
               this.liveReplaysScreen.receiveTopGames(_loc2_);
               break;
            case "showAdd":
               trace("Show add");
               trace("Games played",_loc2_.getInt("count"));
               this.chatOverlay.addManager.showAdd(_loc2_.getInt("count"));
               break;
            case "newsUpdate":
               trace("news: ",_loc2_.getUtfString("text"));
               break;
            case "newsFeed":
               _loc9_ = _loc2_.getSFSArray("newsItems");
               trace("Received news items: ",_loc9_.size());
               break;
            case "findClan":
               trace("Received clan search: ");
               this._findClanScreen.loadClanData(_loc2_.getSFSArray("clans"));
               break;
            case "createClan":
               trace("Received create clan response: ");
               this._createClanScreen.showError(_loc2_.getUtfString("result"));
               break;
            case "viewClan":
               trace("Received view clan response: ");
               this._viewClanScreen.loadClan(_loc2_);
               break;
            case "getClan":
               trace("Get clan info",_loc2_.getUtfString("name"),_loc2_.getInt("id"));
               this.clanName = _loc2_.getUtfString("name");
               this.clanId = _loc2_.getInt("id");
               break;
            case "requestClan":
               trace("Clan request response");
               this.chatOverlay.addUserResponse(_loc2_.getUtfString("message"),true);
               break;
            case "getRequestsClan":
               trace("Get clan requests response");
               break;
            case "notification":
               this.chatOverlay.addUserResponse(_loc2_.getUtfString("message"),true);
               break;
            case "leftClan":
               showScreen("lobby");
               break;
            case "clanMessage":
               trace("Received clan message: ",_loc2_.getUtfString("message"));
               this.viewClanScreen.addClanChat(_loc2_.getUtfString("sender"),_loc2_.getUtfString("message"));
               break;
            case "lobbyChat":
               this.mainLobbyScreen.lobbyChat.receiveChat(_loc2_.getUtfString("p"),_loc2_.getUtfString("m"),_loc2_.getInt("t"),_loc2_.getInt("a"));
               break;
            case "featureGames":
               trace("Received featured games");
               this.mainLobbyScreen.featuredGames.loadFeaturedGames(_loc2_);
               break;
            case "campaign":
               trace("Received campaign");
               this._mapScreen.loadCampaign(_loc2_);
               break;
            case "mission":
               trace("Received mission");
               this._missionGameScreen.setMission(_loc2_.getInt("id"),_loc2_.getUtfString("data"));
               this.showScreen("missionScreen");
               break;
            case "chatBanStatus":
               trace("Received chat ban status: ",_loc2_.getBool("isChatBanned"));
               this.profileScreen.receiveChatBanStatus(_loc2_);
               break;
            case "returningReward":
               trace("Received returning reward: " + _loc2_.getInt("reward"));
               this.chatOverlay.showReturningReward(_loc2_);
         }
      }
      
      private function receiveLoadout(param1:SFSObject) : void
      {
         this.loadout.fromSFSObject(param1);
      }
      
      private function receiveMarketItems(param1:SFSObject) : void
      {
         var _loc4_:MarketItem = null;
         this.marketItems = [];
         var _loc2_:ISFSArray = param1.getSFSArray("marketData");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.size())
         {
            _loc4_ = new MarketItem(SFSObject(_loc2_.getSFSObject(_loc3_)));
            this.marketItems.push(_loc4_);
            _loc3_++;
         }
         this._marketScreen.updateMarketItems();
         this.itemMap.loadItems(this);
         this.armourScreen.updateUnitCard();
      }
      
      private function receivePurchases(param1:SFSObject) : void
      {
         this.hasReceivedPurchases = true;
         var _loc2_:ISFSArray = param1.getSFSArray("purchases");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.size())
         {
            this.purchases.push(_loc2_.getInt(_loc3_));
            _loc3_++;
         }
         this._marketScreen.updateMarketItems();
      }
      
      private function onConnection(param1:SFSEvent) : void
      {
         this.connectRetryTimer.delay = 250;
         if(param1.params.success)
         {
            trace("Connection Success!");
            this.connectRetryTimer.stop();
            this.loginScreen.isConnecting = false;
            if(this.isOnFacebook)
            {
               this.facebookLoginScreen.serverManager.sfs.disconnect();
            }
         }
         else
         {
            this.connectRetryTimer.start();
            this.connectRetryTimer.delay += 250;
            trace("Connection Failure: " + param1.params.errorMessage);
         }
      }
      
      private function onConnectionLost(param1:SFSEvent) : void
      {
         this._chatOverlay.cleanUp();
         this.loadout.data = new Dictionary();
         this.itemMap.data = new Dictionary();
         this.marketItems = [];
         this.purchases = [];
         this.inQueue = false;
         trace("Connection lost");
         trace("Currently on screen: ",currentScreen());
         if(this.getScreen(currentScreen()).maySwitchOnDisconnect())
         {
            trace("Show login");
            if(this.isOnFacebook)
            {
               showScreen("facebookLogin");
            }
            else
            {
               showScreen("login");
            }
            this.setOverlayScreen("");
         }
         if(!sfs.isConnected)
         {
            trace("Connection was lost. Reason: " + param1.params.reason);
            trace("Try to reconnect...");
            this.connectRetryTimer.start();
            this.connectRetryTimer.delay += 250;
            this.gameRoom = null;
            this.gameRoomName = "";
            this._gameIp = "";
            this.loginScreen.isConnecting = true;
         }
      }
      
      private function onConfigLoadSuccess(param1:SFSEvent) : void
      {
         trace("Config load success!");
         trace("Server settings: " + _sfs.config.host + ":" + _sfs.config.port);
      }
      
      private function onConfigLoadFailure(param1:SFSEvent) : void
      {
         trace("Config load failure!!!");
      }
      
      public function get lobby() : Room
      {
         return this._lobby;
      }
      
      public function set lobby(param1:Room) : void
      {
         this._lobby = param1;
      }
      
      public function get gameRoom() : Room
      {
         return this._gameRoom;
      }
      
      public function set gameRoom(param1:Room) : void
      {
         this._gameRoom = param1;
      }
      
      public function get replayGameScreen() : ReplayGameScreen
      {
         return this._replayGameScreen;
      }
      
      public function set replayGameScreen(param1:ReplayGameScreen) : void
      {
         this._replayGameScreen = param1;
      }
      
      public function get purchases() : Array
      {
         return this._purchases;
      }
      
      public function set purchases(param1:Array) : void
      {
         this._purchases = param1;
      }
      
      public function get itemMap() : ItemMap
      {
         return this._itemMap;
      }
      
      public function set itemMap(param1:ItemMap) : void
      {
         this._itemMap = param1;
      }
      
      public function get loadout() : Loadout
      {
         return this._loadout;
      }
      
      public function set loadout(param1:Loadout) : void
      {
         this._loadout = param1;
      }
      
      public function get marketItems() : Array
      {
         return this._marketItems;
      }
      
      public function set marketItems(param1:Array) : void
      {
         this._marketItems = param1;
      }
      
      public function get gameIp() : String
      {
         return this._gameIp;
      }
      
      public function set gameIp(param1:String) : void
      {
         this._gameIp = param1;
      }
      
      public function get gameRoomName() : String
      {
         return this._gameRoomName;
      }
      
      public function set gameRoomName(param1:String) : void
      {
         this._gameRoomName = param1;
      }
      
      public function get inQueue() : Boolean
      {
         return this._inQueue;
      }
      
      public function set inQueue(param1:Boolean) : void
      {
         this._inQueue = param1;
      }
      
      public function get lobbyScreen() : RaceSelectionScreen
      {
         return this._lobbyScreen;
      }
      
      public function set lobbyScreen(param1:RaceSelectionScreen) : void
      {
         this._lobbyScreen = param1;
      }
      
      public function get campaignUpgradeScreen() : CampaignUpgradeScreen
      {
         return this._campaignUpgradeScreen;
      }
      
      public function set campaignUpgradeScreen(param1:CampaignUpgradeScreen) : void
      {
         this._campaignUpgradeScreen = param1;
      }
      
      public function get loginScreen() : LoginScreen
      {
         return this._loginScreen;
      }
      
      public function set loginScreen(param1:LoginScreen) : void
      {
         this._loginScreen = param1;
      }
      
      public function get multiplayerGameScreen() : MultiplayerGameScreen
      {
         return this._multiplayerGameScreen;
      }
      
      public function set multiplayerGameScreen(param1:MultiplayerGameScreen) : void
      {
         this._multiplayerGameScreen = param1;
      }
      
      public function get mainLobbyScreen() : MainLobbyScreen
      {
         return this._mainLobbyScreen;
      }
      
      public function set mainLobbyScreen(param1:MainLobbyScreen) : void
      {
         this._mainLobbyScreen = param1;
      }
      
      public function get profileScreen() : ProfileScreen
      {
         return this._profileScreen;
      }
      
      public function set profileScreen(param1:ProfileScreen) : void
      {
         this._profileScreen = param1;
      }
      
      public function get armourScreen() : NewArmoryScreen
      {
         return this._armourScreen;
      }
      
      public function set armourScreen(param1:NewArmoryScreen) : void
      {
         this._armourScreen = param1;
      }
      
      public function get hasReceivedPurchases() : Boolean
      {
         return this._hasReceivedPurchases;
      }
      
      public function set hasReceivedPurchases(param1:Boolean) : void
      {
         this._hasReceivedPurchases = param1;
      }
      
      public function get empirePoints() : int
      {
         return this._empirePoints;
      }
      
      public function set empirePoints(param1:int) : void
      {
         this._empirePoints = param1;
      }
      
      public function get campaignGameScreen() : CampaignGameScreen
      {
         return this._campaignGameScreen;
      }
      
      public function set campaignGameScreen(param1:CampaignGameScreen) : void
      {
         this._campaignGameScreen = param1;
      }
      
      public function get chatOverlay() : ChatOverlayScreen
      {
         return this._chatOverlay;
      }
      
      public function set chatOverlay(param1:ChatOverlayScreen) : void
      {
         this._chatOverlay = param1;
      }
      
      public function get isOnFacebook() : *
      {
         return this._isOnFacebook;
      }
      
      public function set isOnFacebook(param1:*) : void
      {
         this._isOnFacebook = param1;
      }
      
      public function get facebookLoginScreen() : FacebookLoginScreen
      {
         return this._facebookLoginScreen;
      }
      
      public function set facebookLoginScreen(param1:FacebookLoginScreen) : void
      {
         this._facebookLoginScreen = param1;
      }
      
      public function get pendingMembership() : Boolean
      {
         return this._pendingMembership;
      }
      
      public function set pendingMembership(param1:Boolean) : void
      {
         this._pendingMembership = param1;
      }
      
      public function get replayLoadingScreen() : ReplayLoadingScreen
      {
         return this._replayLoadingScreen;
      }
      
      public function set replayLoadingScreen(param1:ReplayLoadingScreen) : void
      {
         this._replayLoadingScreen = param1;
      }
   }
}
