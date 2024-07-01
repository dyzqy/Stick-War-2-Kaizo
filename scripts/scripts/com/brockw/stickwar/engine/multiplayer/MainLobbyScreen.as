package com.brockw.stickwar.engine.multiplayer
{
      import CPMStar.*;
      import com.brockw.game.*;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.market.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.external.*;
      import flash.net.*;
      import flash.utils.*;
      
      public class MainLobbyScreen extends Screen
      {
            
            private static const NUM_NEWS_ITEMS:int = 2;
            
            private static const TIME_TO_WAIT_BETWEEN_PLAY:Number = 1500;
             
            
            public var mc:realLobbyScreenMc;
            
            private var main:BaseMain;
            
            private var newsIndex:Number;
            
            private var newsPanels:Array;
            
            private var featureUnitMc:MovieClip;
            
            private var featureUnitType:int;
            
            private var featureUnitWeapon:String;
            
            private var featureUnitMisc:String;
            
            private var featureUnitArmor:String;
            
            private var _facebookCardManager:FacebookCardManager;
            
            private var featureWeapon:MovieClip;
            
            private var featureMisc:MovieClip;
            
            private var featureArmor:MovieClip;
            
            private var lastFriendUpdateTime:Number;
            
            public var afterCancelAction:Function;
            
            private var timeOfLastPlayAction:Number;
            
            public var lobbyChat:LobbyChat;
            
            public var featuredGames:FeaturedGames;
            
            private var currentAdBox:adBox = null;
            
            public function MainLobbyScreen(param1:BaseMain)
            {
                  this.timeOfLastPlayAction = 0;
                  this.afterCancelAction = null;
                  this.mc = new realLobbyScreenMc();
                  addChild(this.mc);
                  this.newsIndex = 0;
                  this.main = param1;
                  this.newsPanels = [];
                  super();
                  this.featureUnitMc = null;
                  this.featureUnitType = Unit.U_SPEARTON;
                  this.featureUnitWeapon = "";
                  this.featureUnitMisc = "";
                  this.featureUnitArmor = "";
                  this.featureArmor = this.featureMisc = this.featureWeapon = null;
                  this.lastFriendUpdateTime = -70 * 1000;
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("getFacebookFriendsInstalled",this.getFacebookFriendsInstalled);
                  }
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("loadCurrency",this.loadCurrency);
                        ExternalInterface.call("getCurrency");
                  }
                  this.lobbyChat = new LobbyChat(param1,this.mc.lobbyChat);
                  this.featuredGames = new FeaturedGames(this.mc.featuredGames,this.main);
            }
            
            private function loadCurrency(param1:String, param2:Number) : *
            {
                  Main(this.main).armourScreen.updateCurrency(param1,param2);
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
                        this.mc.container.addChild(this.newsPanels[_loc7_]);
                        this.newsPanels[_loc7_].y = 416;
                        this.newsPanels[_loc7_].x += (10 + 30 + 2 * 200 + this.newsPanels[_loc7_].index * 200 - this.newsPanels[_loc7_].x) * 1;
                  }
                  else if(this.newsPanels[_loc7_].id != _loc8_)
                  {
                        MovieClip(this.newsPanels[_loc7_]).parent.removeChild(MovieClip(this.newsPanels[_loc7_]));
                        this.newsPanels[_loc7_] = new NewsPanel(_loc2_,_loc3_,_loc5_,_loc6_,_loc7_,_loc4_,_loc8_);
                        this.mc.container.addChild(this.newsPanels[_loc7_]);
                        this.newsPanels[_loc7_].y = 416;
                        this.newsPanels[_loc7_].x += (10 + 30 + 2 * 200 + this.newsPanels[_loc7_].index * 200 - this.newsPanels[_loc7_].x) * 1;
                  }
            }
            
            private function getFacebookFriendsInstalled(param1:Array) : *
            {
                  this.facebookCardManager.loadCards(param1);
            }
            
            private function updateElementalCountdown() : void
            {
                  var _loc1_:String = "";
                  var _loc2_:Number = 2010;
                  var _loc3_:Number = 1;
                  var _loc4_:Number = 1;
                  var _loc5_:Date = new Date(2014,1,27,18);
                  var _loc6_:Date = new Date();
                  var _loc7_:Number = _loc5_.getTime() - _loc6_.getTime();
                  var _loc8_:Number = Math.floor(_loc7_ / 1000);
                  var _loc9_:Number = Math.floor(_loc8_ / 60);
                  var _loc10_:Number = Math.floor(_loc9_ / 60);
                  var _loc11_:Number = Math.floor(_loc10_ / 24);
                  var _loc12_:String = (_loc8_ % 60).toString();
                  var _loc13_:String = (_loc9_ % 60).toString();
                  var _loc14_:String = (_loc10_ % 24).toString();
                  var _loc15_:String = _loc11_.toString();
                  if(_loc12_.length < 2)
                  {
                        _loc12_ = "0" + _loc12_;
                  }
                  if(_loc13_.length < 2)
                  {
                        _loc13_ = "0" + _loc13_;
                  }
                  if(_loc14_.length < 2)
                  {
                        _loc14_ = "0" + _loc14_;
                  }
                  this.mc.countdown.text = _loc15_ + " days " + _loc14_ + ":" + _loc13_ + ":" + _loc12_;
            }
            
            private function update(param1:Event) : void
            {
                  var _loc2_:NewsPanel = null;
                  this.featuredGames.update();
                  if(Main(this.main).isMember)
                  {
                        this.mc.unlockChaosButton.visible = false;
                  }
                  else
                  {
                        this.mc.unlockChaosButton.visible = true;
                  }
                  for each(_loc2_ in this.newsPanels)
                  {
                        _loc2_.update();
                  }
                  if(this.mc.container.x > 0 * 200)
                  {
                        this.mc.container.x += (this.newsIndex * 200 - this.mc.container.x) * 1;
                  }
                  else
                  {
                        this.mc.container.x += (this.newsIndex * 200 - this.mc.container.x) * 0.2;
                  }
                  if(this.mc.container.x <= -(this.mc.container.width - NUM_NEWS_ITEMS * 200))
                  {
                        this.mc.rightArrow.visible = true;
                  }
                  else
                  {
                        this.mc.rightArrow.visible = true;
                  }
                  if(this.newsIndex == 0)
                  {
                        this.mc.leftArrow.visible = true;
                  }
                  else
                  {
                        this.mc.leftArrow.visible = true;
                  }
                  if(this.featureUnitMc == null)
                  {
                        this.featureUnitMc = ItemMap.getUnitMcFromType(this.featureUnitType);
                        this.mc.featureUnitContainer.addChild(this.featureUnitMc);
                        this.featureUnitMc.gotoAndStop(1);
                  }
                  if(this.featureUnitMc != null)
                  {
                        ItemMap.setItemsForUnitType(this.featureUnitType,this.featureUnitMc,this.featureUnitWeapon,this.featureUnitArmor,this.featureUnitMisc);
                        if(this.featureUnitType == Unit.U_FLYING_CROSSBOWMAN || this.featureUnitType == Unit.U_WINGIDON)
                        {
                              this.featureUnitMc.y = -40;
                              this.featureUnitMc.x = -25;
                              this.featureUnitMc.mc.body.arms.stop();
                        }
                        else if(this.featureUnitType == Unit.U_GIANT)
                        {
                              this.featureUnitMc.scaleX = 1.2;
                              this.featureUnitMc.scaleY = 1.2;
                        }
                        else if(this.featureUnitType == Unit.U_MAGIKILL)
                        {
                              this.featureUnitMc.scaleX = 0.75;
                              this.featureUnitMc.scaleY = 0.75;
                        }
                        else if(this.featureUnitType == Unit.U_ARCHER)
                        {
                              this.featureUnitMc.mc.bow.stop();
                        }
                        else if(this.featureUnitType == Unit.U_MINER_ELEMENT)
                        {
                              this.featureUnitMc.y = -10;
                              this.featureUnitMc.mc.crabgold.gotoAndStop(MovieClip(this.featureUnitMc.mc.crabgold).totalFrames);
                        }
                        else if(this.featureUnitType == Unit.U_SCORPION_ELEMENT)
                        {
                              this.featureUnitMc.y = -10;
                        }
                        else if(this.featureUnitType == Unit.U_HURRICANE_ELEMENT)
                        {
                              this.featureUnitMc.y = -70;
                              this.featureUnitMc.x = 20;
                        }
                        else if(this.featureUnitType == Unit.U_CHROME_ELEMENT)
                        {
                              this.featureUnitMc.scaleX = 0.8;
                              this.featureUnitMc.scaleY = 0.8;
                              this.featureUnitMc.y = -10;
                              this.featureUnitMc.x = -5;
                        }
                        else
                        {
                              Util.animateMovieClip(this.featureUnitMc);
                        }
                  }
            }
            
            public function recieveFeature(param1:SFSObject) : void
            {
                  if(this.featureUnitMc != null)
                  {
                        this.mc.featureUnitContainer.removeChild(this.featureUnitMc);
                        this.featureUnitMc = null;
                  }
                  this.featureUnitType = param1.getInt("unitType");
                  this.featureUnitWeapon = param1.getUtfString("weapon");
                  this.featureUnitArmor = param1.getUtfString("armor");
                  this.featureUnitMisc = param1.getUtfString("misc");
                  this.mc.featureTitle.text = param1.getUtfString("title");
                  this.mc.featureDescription.text = param1.getUtfString("description");
            }
            
            private function rightArrow(param1:Event) : void
            {
                  this.featuredGames.moveFeatureIndex(1);
                  this.main.soundManager.playSoundFullVolume("clickButton");
            }
            
            public function justCancelledQueue() : void
            {
                  if(this.afterCancelAction != null)
                  {
                        this.afterCancelAction();
                  }
            }
            
            private function leftArrow(param1:Event) : void
            {
                  this.featuredGames.moveFeatureIndex(-1);
                  this.main.soundManager.playSoundFullVolume("clickButton");
            }
            
            override public function enter() : void
            {
                  var _loc1_:ExtensionRequest = null;
                  this.afterCancelAction = null;
                  this.mc.feature.earnCoins.addEventListener(MouseEvent.CLICK,this.earnCoinsButton);
                  this.mc.feature.buyCoins.addEventListener(MouseEvent.CLICK,this.buyCoinsButton);
                  this.mc.notOnFacebookCard.visible = false;
                  this.mc.leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrow);
                  this.mc.rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrow);
                  this.main.setOverlayScreen("chatOverlay");
                  stage.frameRate = 30;
                  this.mc.helpMiniButton.addEventListener(MouseEvent.CLICK,this.helpMiniButton);
                  this.mc.stickpageButton.addEventListener(MouseEvent.CLICK,this.stickpageButton);
                  this.mc.forumButton.addEventListener(MouseEvent.CLICK,this.forumButton);
                  this.mc.fanWikiButton.addEventListener(MouseEvent.CLICK,this.fanWikiButton);
                  this.mc.devBlogButton.addEventListener(MouseEvent.CLICK,this.devBlogButton);
                  this.mc.customMatch.addEventListener(MouseEvent.CLICK,this.customMatch);
                  this.mc.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
                  this.mc.playDeathmatchButton.addEventListener(MouseEvent.CLICK,this.playDeathmatchButton);
                  this.mc.tutorialButton.addEventListener(MouseEvent.CLICK,this.tutorialButton);
                  this.mc.gameGuideButton.addEventListener(MouseEvent.CLICK,this.gameGuideButton);
                  this.mc.campaignButton.addEventListener(MouseEvent.CLICK,this.campaignButton);
                  this.mc.replayButton.addEventListener(MouseEvent.CLICK,this.replayButton);
                  this.mc.facebookAddButton.addEventListener(MouseEvent.CLICK,this.addFacebookFriend);
                  addEventListener(Event.ENTER_FRAME,this.update);
                  if(Main(this.main).isOnFacebook)
                  {
                        if(Boolean(ExternalInterface.available) && getTimer() - this.lastFriendUpdateTime > 60 * 1000)
                        {
                              ExternalInterface.call("getFacebookFriendsInstalled");
                              this.lastFriendUpdateTime = getTimer();
                        }
                  }
                  _loc1_ = new ExtensionRequest("getFeature",null);
                  this.main.sfs.send(_loc1_);
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("friendRequestComplete",this.friendRequestComplete);
                  }
                  this.mc.helpMiniButton.addEventListener(MouseEvent.CLICK,this.helpMiniButton);
                  this.mc.stickpageButton.addEventListener(MouseEvent.CLICK,this.stickpageButton);
                  this.mc.forumButton.addEventListener(MouseEvent.CLICK,this.forumButton);
                  this.mc.fanWikiButton.addEventListener(MouseEvent.CLICK,this.fanWikiButton);
                  this.mc.devBlogButton.addEventListener(MouseEvent.CLICK,this.devBlogButton);
                  this.mc.unlockChaosButton.addEventListener(MouseEvent.CLICK,this.unlockChaos);
                  this.mc.featuredGames.watchNowButton.addEventListener(MouseEvent.CLICK,this.watchFeaturedGame);
                  this.mc.featuredGames.radio1.addEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio2.addEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio3.addEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio4.addEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio1.buttonMode = true;
                  this.mc.featuredGames.radio2.buttonMode = true;
                  this.mc.featuredGames.radio3.buttonMode = true;
                  this.mc.featuredGames.radio4.buttonMode = true;
                  _loc1_ = new ExtensionRequest("getFeatureGames",null);
                  this.main.sfs.send(_loc1_);
            }
            
            private function unlockChaos(param1:Event) : void
            {
                  Main(this.main).armourScreen.membershipButton(param1);
            }
            
            private function helpMiniButton(param1:Event) : void
            {
                  Main(this.main).showScreen("faq");
            }
            
            private function stickpageButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com");
                  navigateToURL(_loc2_,"_blank");
            }
            
            private function forumButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://forums.stickpage.com/forumdisplay.php?62-Stick-Empires");
                  navigateToURL(_loc2_,"_blank");
            }
            
            private function fanWikiButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://stickempires-rts.wikia.com/wiki/Stick_Empires_Wiki");
                  navigateToURL(_loc2_,"_blank");
            }
            
            private function devBlogButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickwar.com/");
                  navigateToURL(_loc2_,"_blank");
            }
            
            private function gameGuideButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker)
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickempiresguide.shtml");
                  }
            }
            
            private function customMatch(param1:MouseEvent) : void
            {
                  this.main.showScreen("customMatch");
            }
            
            private function playButton(param1:MouseEvent) : void
            {
                  var _loc2_:SFSObject = null;
                  if(Main(this.main).chatOverlay.queueType == StickWar.TYPE_CLASSIC && getTimer() - this.timeOfLastPlayAction < MainLobbyScreen.TIME_TO_WAIT_BETWEEN_PLAY)
                  {
                        trace("TOO FAST");
                        return;
                  }
                  if(Main(this.main).inQueue == false)
                  {
                        this.playAction();
                        trace("SEND CLASSIC REQUEST");
                        this.afterCancelAction = null;
                  }
                  else if(Main(this.main).chatOverlay.queueType == StickWar.TYPE_DEATHMATCH)
                  {
                        _loc2_ = new SFSObject();
                        this.main.sfs.send(new ExtensionRequest("cancelMatch",_loc2_));
                        this.afterCancelAction = this.playAction;
                  }
            }
            
            private function playDeathmatchButton(param1:MouseEvent) : void
            {
                  var _loc2_:SFSObject = null;
                  if(Main(this.main).chatOverlay.queueType == StickWar.TYPE_DEATHMATCH && getTimer() - this.timeOfLastPlayAction < MainLobbyScreen.TIME_TO_WAIT_BETWEEN_PLAY)
                  {
                        trace("TOO FAST");
                        return;
                  }
                  if(Main(this.main).inQueue == false)
                  {
                        this.playDeathmatchAction();
                        trace("SEND DEATHMATCH REQUEST");
                        this.afterCancelAction = null;
                  }
                  else if(Main(this.main).chatOverlay.queueType == StickWar.TYPE_CLASSIC)
                  {
                        _loc2_ = new SFSObject();
                        this.main.sfs.send(new ExtensionRequest("cancelMatch",_loc2_));
                        this.afterCancelAction = this.playDeathmatchAction;
                  }
            }
            
            private function formatTime(param1:Number) : String
            {
                  var _loc2_:* = "";
                  param1 /= 1000;
                  var _loc3_:int = param1 % 60;
                  var _loc4_:int;
                  if((_loc4_ = param1 / 60) < 10)
                  {
                        _loc2_ += "";
                  }
                  _loc2_ += _loc4_;
                  _loc2_ += "m ";
                  if(_loc3_ < 10)
                  {
                        _loc2_ += "";
                  }
                  _loc2_ += _loc3_;
                  return _loc2_ + "s";
            }
            
            private function playAction() : void
            {
                  var _loc2_:Number = NaN;
                  var _loc3_:SFSObject = null;
                  var _loc1_:Main = Main(this.main);
                  if(getTimer() - _loc1_.timeDodgedQueue < Main.QUEUE_DODGE_WAIT_TIME)
                  {
                        _loc2_ = Main.QUEUE_DODGE_WAIT_TIME - (getTimer() - _loc1_.timeDodgedQueue);
                        _loc1_.chatOverlay.addUserResponse("You failed to pick an empire. You must wait " + this.formatTime(_loc2_) + "  before rejoining the queue.",true,14);
                  }
                  else
                  {
                        _loc3_ = new SFSObject();
                        _loc3_.putInt("gameType",StickWar.TYPE_CLASSIC);
                        this.main.sfs.send(new ExtensionRequest("match",_loc3_));
                        this.main.soundManager.playSoundFullVolume("StartMatchmaking");
                        Main(this.main).chatOverlay.setQueueType(StickWar.TYPE_CLASSIC);
                  }
            }
            
            private function playDeathmatchAction() : void
            {
                  var _loc2_:Number = NaN;
                  var _loc3_:SFSObject = null;
                  var _loc1_:Main = Main(this.main);
                  if(getTimer() - _loc1_.timeDodgedQueue < Main.QUEUE_DODGE_WAIT_TIME)
                  {
                        _loc2_ = Main.QUEUE_DODGE_WAIT_TIME - (getTimer() - _loc1_.timeDodgedQueue);
                        _loc1_.chatOverlay.addUserResponse("You failed to pick an empire. You must wait " + this.formatTime(_loc2_) + "  before rejoining the queue.",true,14);
                  }
                  else
                  {
                        this.timeOfLastPlayAction = getTimer();
                        _loc3_ = new SFSObject();
                        _loc3_.putInt("gameType",StickWar.TYPE_DEATHMATCH);
                        this.main.sfs.send(new ExtensionRequest("match",_loc3_));
                        this.main.soundManager.playSoundFullVolume("StartMatchmaking");
                        Main(this.main).chatOverlay.setQueueType(StickWar.TYPE_DEATHMATCH);
                  }
            }
            
            private function campaignButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com/stickwar2gameplay.shtml");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker)
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickwar2gameplay.shtml");
                  }
            }
            
            private function tutorialButton(param1:MouseEvent) : void
            {
                  this.main.campaign.currentLevel = 0;
                  this.main.campaign.justTutorial = true;
                  this.main.showScreen("campaignGameScreen");
                  var _loc2_:SFSObject = new SFSObject();
                  this.main.sfs.send(new ExtensionRequest("cancelMatch",_loc2_));
            }
            
            public function showNotOnFacebookCard() : void
            {
                  this.mc.notOnFacebookCard.visible = true;
                  var _loc1_:SFSObject = new SFSObject();
                  _loc1_.putUtfString("name",this.main.sfs.mySelf.name);
                  var _loc2_:ExtensionRequest = new ExtensionRequest("getProfile",_loc1_);
                  this.main.sfs.send(_loc2_);
                  this.mc.notOnFacebookCard.closeButton.addEventListener(MouseEvent.CLICK,this.exitNotOnFacebook,false,0,true);
                  this.mc.notOnFacebookCard.gotoFacebook.visible = false;
                  this.mc.notOnFacebookCard.connect.visible = false;
                  this.mc.notOnFacebookCard.loading.visible = true;
                  this.mc.notOnFacebookCard.connect.connectButton.addEventListener(MouseEvent.CLICK,this.connectToFacebook,false,0,true);
                  this.mc.notOnFacebookCard.gotoFacebook.facebookButton.addEventListener(MouseEvent.CLICK,this.goToFacebook,false,0,true);
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.addCallback("retrieveFacebookId",this.retrieveFacebookId);
                  }
            }
            
            private function exitNotOnFacebook(param1:Event) : void
            {
                  trace("EXIT");
                  this.mc.notOnFacebookCard.visible = false;
            }
            
            public function retrieveFacebookId(param1:Number) : *
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putLong("fuid",param1);
                  this.main.sfs.send(new ExtensionRequest("setFacebookConnection",_loc2_));
            }
            
            private function connectToFacebook(param1:Event) : void
            {
                  if(ExternalInterface.available)
                  {
                        ExternalInterface.call("getFacebookId");
                  }
                  this.exitNotOnFacebook(param1);
                  this.showNotOnFacebookCard();
            }
            
            private function goToFacebook(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("https://apps.facebook.com/stickempires");
                  navigateToURL(_loc2_,"_self");
                  this.exitNotOnFacebook(param1);
            }
            
            public function receiveFacebookId(param1:String) : void
            {
                  if(this.mc.notOnFacebookCard.visible == true)
                  {
                        if(param1 != "")
                        {
                              this.mc.notOnFacebookCard.gotoFacebook.visible = true;
                              this.mc.notOnFacebookCard.connect.visible = false;
                              this.mc.notOnFacebookCard.loading.visible = false;
                        }
                        else
                        {
                              this.mc.notOnFacebookCard.gotoFacebook.visible = false;
                              this.mc.notOnFacebookCard.connect.visible = true;
                              this.mc.notOnFacebookCard.loading.visible = false;
                        }
                  }
            }
            
            private function replayButton(param1:MouseEvent) : void
            {
                  this.main.showScreen("liveMatches");
            }
            
            override public function leave() : void
            {
                  this.afterCancelAction = null;
                  this.mc.playButton.removeEventListener(MouseEvent.CLICK,this.playButton);
                  this.mc.playDeathmatchButton.removeEventListener(MouseEvent.CLICK,this.playDeathmatchButton);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.gameGuideButton.removeEventListener(MouseEvent.CLICK,this.gameGuideButton);
                  this.mc.campaignButton.removeEventListener(MouseEvent.CLICK,this.campaignButton);
                  this.mc.tutorialButton.removeEventListener(MouseEvent.CLICK,this.tutorialButton);
                  this.mc.leftArrow.removeEventListener(MouseEvent.CLICK,this.leftArrow);
                  this.mc.rightArrow.removeEventListener(MouseEvent.CLICK,this.rightArrow);
                  this.mc.replayButton.removeEventListener(MouseEvent.CLICK,this.replayButton);
                  this.mc.facebookAddButton.removeEventListener(MouseEvent.CLICK,this.addFacebookFriend);
                  this.mc.feature.earnCoins.removeEventListener(MouseEvent.CLICK,this.earnCoinsButton);
                  this.mc.feature.buyCoins.removeEventListener(MouseEvent.CLICK,this.buyCoinsButton);
                  this.mc.helpMiniButton.removeEventListener(MouseEvent.CLICK,this.helpMiniButton);
                  this.mc.stickpageButton.removeEventListener(MouseEvent.CLICK,this.stickpageButton);
                  this.mc.forumButton.removeEventListener(MouseEvent.CLICK,this.forumButton);
                  this.mc.fanWikiButton.removeEventListener(MouseEvent.CLICK,this.fanWikiButton);
                  this.mc.devBlogButton.removeEventListener(MouseEvent.CLICK,this.devBlogButton);
                  this.mc.unlockChaosButton.removeEventListener(MouseEvent.CLICK,this.unlockChaos);
                  this.mc.featuredGames.watchNowButton.removeEventListener(MouseEvent.CLICK,this.watchFeaturedGame);
                  this.mc.featuredGames.radio1.removeEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio2.removeEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio3.removeEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
                  this.mc.featuredGames.radio4.removeEventListener(MouseEvent.CLICK,this.featuredGames.featuredGamesRadioClick);
            }
            
            private function watchFeaturedGame(param1:Event) : *
            {
                  this.main.soundManager.playSoundFullVolume("StartMatchmaking");
                  this.featuredGames.watch();
            }
            
            private function earnCoinsButton(param1:Event) : void
            {
                  this.main.showScreen("armoury");
                  Main(this.main).armourScreen.update(null);
                  Main(this.main).armourScreen.openEarnCoinsScreen(null);
            }
            
            private function buyCoinsButton(param1:Event) : void
            {
                  this.main.showScreen("armoury");
                  Main(this.main).armourScreen.update(null);
                  Main(this.main).armourScreen.openPaymentScreen(null);
            }
            
            private function rightArrowFriends(param1:Event) : void
            {
                  this.facebookCardManager.scrollRight();
            }
            
            private function leftArrowFriends(param1:Event) : void
            {
                  this.facebookCardManager.scrollLeft();
            }
            
            private function friendRequestComplete() : void
            {
                  Main(this.main).chatOverlay.addUserResponse("Friend Request has been sent.",true);
            }
            
            private function addFacebookFriend(param1:Event) : void
            {
                  if(Main(this.main).isOnFacebook)
                  {
                        if(ExternalInterface.available)
                        {
                              ExternalInterface.call("friendRequest");
                        }
                  }
                  else
                  {
                        Main(this.main).mainLobbyScreen.showNotOnFacebookCard();
                  }
            }
            
            public function get facebookCardManager() : FacebookCardManager
            {
                  return this._facebookCardManager;
            }
            
            public function set facebookCardManager(param1:FacebookCardManager) : void
            {
                  this._facebookCardManager = param1;
            }
            
            public function showAdd() : void
            {
                  if(this.currentAdBox != null)
                  {
                        this.mc.removeChild(this.currentAdBox);
                        this.currentAdBox = null;
                  }
                  var _loc1_:int = 20005;
                  var _loc2_:int = 1;
                  var _loc3_:DisplayObject = AdLoader.LoadAd(_loc1_,_loc2_);
                  this.currentAdBox = new adBox();
                  this.currentAdBox.x = 850 / 2 - 150;
                  this.currentAdBox.y = 700 / 2 - 125;
                  this.mc.addChild(this.currentAdBox);
                  this.currentAdBox.addChild(_loc3_);
            }
      }
}
