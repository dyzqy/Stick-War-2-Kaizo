package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.*;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.maps.*;
      import com.brockw.stickwar.market.*;
      import com.smartfoxserver.v2.core.*;
      import com.smartfoxserver.v2.entities.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.MovieClip;
      import flash.events.*;
      import flash.external.*;
      import flash.utils.*;
      
      public class LoadingScreen extends Screen
      {
             
            
            private var main:Main;
            
            private var timer:Timer;
            
            private var txtWelcome:GenericText;
            
            private var loadingScreen:pregameScreenMc;
            
            private var raceSelectMc:lobbyScreenMc;
            
            private var minWaitTime:int;
            
            private var setUpLoadingScreen:Boolean;
            
            private var isSelectingRace:Boolean;
            
            private var mouseIsIn:int;
            
            private var gotGameRoom:Boolean;
            
            private var initInNFrames:int;
            
            private var raceSelectionParams:SFSObject;
            
            private var didSelect:Boolean;
            
            private var readyTimer:Timer;
            
            private var timerStartTime:Number;
            
            private var isShowingMembershipRequired:Boolean = false;
            
            private var hasClicked:Boolean;
            
            private var mapDisplayPic:MovieClip;
            
            public var isFresh:Boolean;
            
            public function LoadingScreen(param1:Main)
            {
                  super();
                  this.isFresh = true;
                  this.mapDisplayPic = null;
                  this.hasClicked = true;
                  this.loadingScreen = new pregameScreenMc();
                  this.raceSelectMc = new lobbyScreenMc();
                  addChild(this.loadingScreen);
                  addChild(this.raceSelectMc);
                  this.main = param1;
                  this.timer = new Timer(1000 / 33,0);
                  this.raceSelectMc.orderButton.stop();
                  this.raceSelectMc.chaosButton.stop();
                  this.raceSelectMc.randomButton.stop();
                  this.raceSelectMc.elementalButton.stop();
                  this.mouseIsIn = 0;
                  this.initInNFrames = 0;
                  this.raceSelectionParams = null;
                  this.didSelect = false;
            }
            
            private function mouseUp(param1:Event) : void
            {
                  this.hasClicked = true;
            }
            
            private function mouseDown(param1:MouseEvent) : void
            {
                  var _loc2_:Number = NaN;
                  if(this.hasClicked)
                  {
                        this.hasClicked = false;
                        if(!this.setUpLoadingScreen)
                        {
                              _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY + 100,2));
                              if(_loc2_ < 150)
                              {
                                    this.main.raceSelected = Team.T_GOOD;
                                    this.didSelect = true;
                                    this.raceChange();
                                    this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                              }
                              _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY + 100,2));
                              if((Boolean(this.main.isMember) || this.main.numberOfTrialsLeft > 0) && _loc2_ < 150)
                              {
                                    this.main.raceSelected = Team.T_CHAOS;
                                    this.didSelect = true;
                                    this.raceChange();
                                    this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                              }
                              _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.randomButton.mouseX,2) + Math.pow(this.raceSelectMc.randomButton.mouseY,2));
                              if(Boolean(this.main.isMember) && _loc2_ < 75)
                              {
                                    this.main.raceSelected = Team.T_RANDOM;
                                    this.didSelect = true;
                                    this.raceChange();
                                    this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                              }
                              if(this.main.xml.xml.elementalsEnabled == 1)
                              {
                                    _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.elementalButton.mouseX,2) + Math.pow(this.raceSelectMc.elementalButton.mouseY,2));
                                    if(Boolean(this.main.isMember) && _loc2_ < 75)
                                    {
                                          this.main.raceSelected = Team.T_ELEMENTAL;
                                          this.didSelect = true;
                                          this.raceChange();
                                          this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                                    }
                                    this.raceSelectMc.elementalButton.mouseEnabled = true;
                                    this.raceSelectMc.elementalButton.buttonMode = true;
                                    this.raceSelectMc.comingSoon.visible = false;
                              }
                              else
                              {
                                    this.raceSelectMc.elementalButton.mouseEnabled = false;
                                    this.raceSelectMc.elementalButton.buttonMode = false;
                                    this.raceSelectMc.comingSoon.visible = true;
                                    Util.animateToNeutral(this.raceSelectMc.elementalButton);
                              }
                        }
                  }
                  this.update(param1);
            }
            
            private function raceChange() : void
            {
                  var _loc1_:int = 0;
                  var _loc2_:SFSObject = null;
                  if(this.gotGameRoom)
                  {
                        _loc1_ = int(this.main.raceSelected);
                        trace("RACE CHANGE");
                        this.main.didSelectRace = true;
                        _loc2_ = new SFSObject();
                        _loc2_.putInt("race",_loc1_);
                        this.main.gameServer.send(new ExtensionRequest("racePick",_loc2_,Main(this.main).gameRoom));
                        this.didSelect = false;
                  }
            }
            
            public function onConnection(param1:SFSEvent) : void
            {
                  var _loc2_:SFSObject = null;
                  var _loc3_:String = null;
                  if(param1.params.success)
                  {
                        trace("Connected to server!");
                        trace("Attempting to login to game server");
                        _loc2_ = new SFSObject();
                        if(this.main.isOnFacebook)
                        {
                              _loc3_ = "";
                              if(ExternalInterface.available)
                              {
                                    _loc3_ = String(ExternalInterface.call("getFacebookToken"));
                              }
                              _loc2_.putUtfString("password","");
                              _loc2_.putBool("isFacebook",true);
                              _loc2_.putUtfString("fToken",_loc3_);
                              _loc2_.putUtfString("version",this.main.version);
                        }
                        else
                        {
                              _loc2_.putUtfString("password",this.main.passwordEncrypted);
                              _loc2_.putUtfString("version",this.main.version);
                        }
                        this.main.gameServer.send(new LoginRequest(this.main.sfs.mySelf.name,"","stickwar",_loc2_));
                  }
                  else
                  {
                        trace("Error connecting",param1.params.errorMessage);
                  }
            }
            
            public function SFSLoginError(param1:SFSEvent) : void
            {
                  trace("Can not login to game server: ",param1.params.errorMessage);
            }
            
            override public function enter() : void
            {
                  this.isFresh = true;
                  this.isShowingMembershipRequired = false;
                  this.raceSelectMc.membershipRequired.y = 740;
                  this.main.soundManager.playSoundFullVolume("MatchFoundSound");
                  trace("Select your races!");
                  stage.frameRate = 30;
                  this.timerStartTime = getTimer();
                  this.didSelect = false;
                  this.loadingScreen.visible = false;
                  this.raceSelectMc.visible = true;
                  this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
                  this.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
                  this.raceSelectMc.comingSoon.buttonMode = false;
                  this.raceSelectMc.comingSoon.mouseEnabled = false;
                  this.isSelectingRace = true;
                  this.main.gameServer.addEventListener(SFSEvent.CONNECTION,this.onConnection);
                  this.timer.addEventListener(TimerEvent.TIMER,this.update);
                  this.timer.start();
                  this.main.gameServer.addEventListener(SFSEvent.LOGIN,this.SFSLogin);
                  this.main.gameServer.addEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.gameServer.addEventListener(SFSEvent.LOGOUT,this.SFSLogout);
                  this.minWaitTime = 0;
                  this.main.gameServer.addEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
                  this.main.gameServer.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.main.extensionResponse,false,0,true);
                  this.setUpLoadingScreen = false;
                  this.gotGameRoom = false;
                  this.main.setOverlayScreen("");
                  this.main.raceSelected = -1;
                  this.raceSelectMc.countdown.text = "" + Math.floor(10);
                  this.initInNFrames = 0;
                  this.raceSelectMc.chaosLocked.addEventListener(MouseEvent.CLICK,this.showMembershipRequired);
                  this.raceSelectMc.elementalsLocked.addEventListener(MouseEvent.CLICK,this.showMembershipRequired);
                  this.raceSelectMc.chaosLocked.buttonMode = true;
                  this.raceSelectMc.elementalsLocked.buttonMode = true;
                  this.raceSelectMc.randomButton.buttonMode = true;
                  this.raceSelectMc.orderButton.buttonMode = true;
                  this.raceSelectMc.chaosButton.buttonMode = true;
                  this.raceSelectMc.elementalButton.buttonMode = true;
                  if(this.main.isMember)
                  {
                        this.raceSelectMc.chaosLocked.visible = false;
                        this.raceSelectMc.randomButton.visible = true;
                        this.raceSelectMc.elementalsLocked.visible = false;
                  }
                  else
                  {
                        this.raceSelectMc.chaosLocked.visible = true;
                        this.raceSelectMc.elementalsLocked.visible = true;
                        this.raceSelectMc.randomButton.visible = false;
                        this.raceSelectMc.elementalButton.buttonMode = false;
                  }
                  this.readyTimer = new Timer(1000,1);
                  this.readyTimer.addEventListener(TimerEvent.TIMER,this.readyToPlay);
            }
            
            private function showMembershipRequired(param1:Event) : void
            {
                  this.isShowingMembershipRequired = true;
            }
            
            private function openMembershipBuy(param1:Event) : void
            {
                  ArmoryScreen.openPayment("membership",this.main);
            }
            
            public function setCountdown(param1:Number) : void
            {
            }
            
            override public function leave() : void
            {
                  this.isFresh = true;
                  trace("Finished loading the game!");
                  this.timer.stop();
                  this.timer.removeEventListener(TimerEvent.TIMER,this.update);
                  this.main.gameServer.removeEventListener(SFSEvent.CONNECTION,this.onConnection);
                  this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
                  this.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
                  this.main.gameServer.removeEventListener(SFSEvent.LOGIN_ERROR,this.SFSLoginError);
                  this.main.gameServer.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
                  this.main.gameServer.removeEventListener(SFSEvent.LOGOUT,this.SFSLogout);
                  this.main.gameServer.removeEventListener(SFSEvent.ROOM_JOIN_ERROR,this.SFSRoomJoinError);
                  this.raceSelectMc.chaosLocked.removeEventListener(MouseEvent.CLICK,this.openMembershipBuy);
                  this.raceSelectMc.elementalsLocked.removeEventListener(MouseEvent.CLICK,this.showMembershipRequired);
                  this.readyTimer.removeEventListener(TimerEvent.TIMER,this.readyToPlay);
            }
            
            public function SFSLogin(param1:SFSEvent) : void
            {
                  trace("Login successful");
            }
            
            public function receivedRaceSelection(param1:SFSObject) : void
            {
                  var _loc3_:int = 0;
                  var _loc4_:int = 0;
                  var _loc15_:int = 0;
                  this.isSelectingRace = false;
                  this.raceSelectionParams = param1;
                  var _loc2_:int = int(this.main.gameRoom.getVariable("gameType").getIntValue());
                  if(_loc2_ == StickWar.TYPE_DEATHMATCH)
                  {
                        this.loadingScreen.gameType.text = "Deathmatch";
                  }
                  else
                  {
                        this.loadingScreen.gameType.text = "";
                  }
                  trace("received race selection");
                  _loc3_ = int(this.main.gameRoom.playerList[0].id);
                  _loc4_ = int(this.main.gameRoom.playerList[1].id);
                  var _loc5_:String = "race_" + User(this.main.gameRoom.playerList[0]).name;
                  var _loc6_:String = "race_" + User(this.main.gameRoom.playerList[1]).name;
                  var _loc7_:int = param1.getInt(this.main.gameRoom.playerList[0].name);
                  var _loc8_:int = param1.getInt(this.main.gameRoom.playerList[1].name);
                  trace(_loc7_,_loc8_);
                  var _loc9_:String = String(User(this.main.gameRoom.playerList[0]).name);
                  var _loc10_:String = String(User(this.main.gameRoom.playerList[1]).name);
                  var _loc11_:Number = Number(User(this.main.gameRoom.playerList[0]).getVariable("rating").getDoubleValue());
                  var _loc12_:Number = Number(User(this.main.gameRoom.playerList[1]).getVariable("rating").getDoubleValue());
                  if(_loc2_ == StickWar.TYPE_DEATHMATCH)
                  {
                        _loc11_ = Number(User(this.main.gameRoom.playerList[0]).getVariable("ratingDeathmatch").getDoubleValue());
                        _loc12_ = Number(User(this.main.gameRoom.playerList[1]).getVariable("ratingDeathmatch").getDoubleValue());
                  }
                  var _loc13_:String = "";
                  var _loc14_:String = "";
                  if(_loc3_ > _loc4_)
                  {
                        _loc15_ = _loc8_;
                        _loc8_ = _loc7_;
                        _loc7_ = _loc15_;
                        _loc15_ = _loc12_;
                        _loc12_ = _loc11_;
                        _loc11_ = _loc15_;
                        _loc13_ = _loc10_;
                        _loc14_ = _loc9_;
                  }
                  else
                  {
                        _loc13_ = _loc9_;
                        _loc14_ = _loc10_;
                  }
                  this.setUpLoadingScreen = true;
                  this.loadingScreen.userAName.text = _loc13_;
                  this.loadingScreen.userBName.text = _loc14_;
                  this.loadingScreen.userARace.text = Team.getRaceNameFromId(_loc7_);
                  this.loadingScreen.userBRace.text = Team.getRaceNameFromId(_loc8_);
                  this.loadingScreen.userAFavour.text = this.getFavour(_loc11_,_loc12_);
                  this.loadingScreen.userBFavour.text = this.getFavour(_loc12_,_loc11_);
                  this.loadingScreen.raceIconA.gotoAndStop(Team.getRaceNameFromId(_loc7_));
                  this.loadingScreen.raceIconB.gotoAndStop(Team.getRaceNameFromId(_loc8_));
                  this.loadingScreen.mapName.text = Map.getMapNameFromId(this.main.gameRoom.getVariable("map").getIntValue());
            }
            
            public function update(param1:Event) : void
            {
                  var _loc3_:Room = null;
                  var _loc4_:Number = NaN;
                  var _loc5_:* = undefined;
                  var _loc6_:Number = NaN;
                  if(Boolean(this.main.isMember) || this.main.numberOfTrialsLeft > 0)
                  {
                        this.raceSelectMc.chaosLocked.visible = false;
                        this.raceSelectMc.randomButton.visible = true;
                  }
                  else
                  {
                        this.raceSelectMc.chaosLocked.visible = true;
                        this.raceSelectMc.randomButton.visible = false;
                  }
                  if(!this.main.isMember)
                  {
                        this.raceSelectMc.randomButton.visible = false;
                  }
                  if(!this.main.isMember && this.main.numberOfTrialsLeft > 0)
                  {
                        if(this.main.numberOfTrialsLeft == 1)
                        {
                              this.raceSelectMc.trialsLeft.text = this.main.numberOfTrialsLeft + " Free Trial Left!";
                        }
                        else
                        {
                              this.raceSelectMc.trialsLeft.text = this.main.numberOfTrialsLeft + " Free Trials Left!";
                        }
                        this.raceSelectMc.trialsLeft.mouseEnabled = false;
                  }
                  else
                  {
                        this.raceSelectMc.trialsLeft.visible = false;
                  }
                  if(this.main.raceSelected == Team.T_GOOD)
                  {
                        this.raceSelectMc.orderButton.gotoAndStop(3);
                  }
                  else if(Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY,2)) < 150)
                  {
                        this.raceSelectMc.orderButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.raceSelectMc.orderButton.gotoAndStop(1);
                  }
                  if(this.main.raceSelected == Team.T_CHAOS)
                  {
                        this.raceSelectMc.chaosButton.gotoAndStop(3);
                  }
                  else if((Boolean(this.main.isMember) || this.main.numberOfTrialsLeft > 0) && Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY,2)) < 150)
                  {
                        this.raceSelectMc.chaosButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.raceSelectMc.chaosButton.gotoAndStop(1);
                  }
                  if(this.main.xml.xml.elementalsEnabled == 1)
                  {
                        if(this.main.raceSelected == Team.T_ELEMENTAL)
                        {
                              this.raceSelectMc.elementalButton.gotoAndStop(3);
                        }
                        else if((Boolean(this.main.isMember) || this.main.numberOfTrialsLeft > 0) && Math.sqrt(Math.pow(this.raceSelectMc.elementalButton.mouseX,2) + Math.pow(this.raceSelectMc.elementalButton.mouseY,2)) < 150)
                        {
                              this.raceSelectMc.elementalButton.gotoAndStop(2);
                        }
                        else
                        {
                              this.raceSelectMc.elementalButton.gotoAndStop(1);
                        }
                        this.raceSelectMc.elementalButton.mouseEnabled = true;
                        this.raceSelectMc.elementalButton.buttonMode = true;
                        this.raceSelectMc.comingSoon.visible = false;
                  }
                  else
                  {
                        this.raceSelectMc.elementalButton.mouseEnabled = false;
                        this.raceSelectMc.elementalButton.buttonMode = false;
                        this.raceSelectMc.comingSoon.visible = true;
                        Util.animateToNeutral(this.raceSelectMc.elementalButton);
                  }
                  if(this.main.raceSelected == Team.T_RANDOM)
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(3);
                  }
                  else if((Boolean(this.main.isMember) || this.main.numberOfTrialsLeft > 0) && Boolean(this.raceSelectMc.randomButton.hitTestPoint(stage.mouseX,stage.mouseY)))
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(1);
                  }
                  if(this.isShowingMembershipRequired)
                  {
                        this.raceSelectMc.membershipRequired.y += (684 - this.raceSelectMc.membershipRequired.y) * 0.1;
                  }
                  else
                  {
                        this.raceSelectMc.membershipRequired.y += (740 - this.raceSelectMc.membershipRequired.y) * 0.1;
                  }
                  if(!this.setUpLoadingScreen)
                  {
                        for each(_loc3_ in this.main.gameServer.roomList)
                        {
                              if(Boolean(_loc3_.isGame) && _loc3_.name == this.main.gameRoomName)
                              {
                                    this.main.gameRoom = _loc3_;
                                    this.gotGameRoom = true;
                                    if(this.didSelect)
                                    {
                                          this.raceChange();
                                    }
                              }
                        }
                  }
                  var _loc2_:Number = 10000 - (getTimer() - this.timerStartTime);
                  if(_loc2_ < 0)
                  {
                        _loc2_ = 0;
                        if(!this.gotGameRoom)
                        {
                              this.main.gameServer.send(new LogoutRequest());
                              this.main.showScreen("lobby");
                        }
                  }
                  this.raceSelectMc.countdown.text = "" + Math.floor(_loc2_ / 1000);
                  if(this.loadingScreen.visible == false && this.isSelectingRace == false && this.main.gameRoom != null && this.main.gameRoom.playerList.length == 2 && this.minWaitTime > 30 * 4)
                  {
                        this.loadingScreen.visible = true;
                        this.raceSelectMc.visible = false;
                        this.initInNFrames = 5;
                        if(this.mapDisplayPic)
                        {
                              if(this.loadingScreen.container.contains(this.mapDisplayPic))
                              {
                                    this.loadingScreen.container.removeChild(this.mapDisplayPic);
                              }
                        }
                        this.mapDisplayPic = null;
                        this.mapDisplayPic = Map.getMapDisplayFromId(Main(this.main).gameRoom.getVariable("map").getIntValue());
                        this.loadingScreen.container.addChild(this.mapDisplayPic);
                        this.mapDisplayPic.x = 425 - this.mapDisplayPic.width / 2;
                        this.mapDisplayPic.y = 432 - this.mapDisplayPic.height / 2;
                  }
                  if(this.initInNFrames - 1 == 0)
                  {
                        _loc4_ = Number(getTimer());
                        this.timer.removeEventListener(TimerEvent.TIMER,this.update);
                        addChild(this.main.multiplayerGameScreen);
                        this.main.multiplayerGameScreen.alpha = 0;
                        this.main.multiplayerGameScreen.init(this.raceSelectionParams);
                        removeChild(this.main.multiplayerGameScreen);
                        this.main.multiplayerGameScreen.alpha = 1;
                        --this.initInNFrames;
                        _loc5_ = getTimer() - _loc4_;
                        _loc6_ = Math.max(0,2000 - _loc5_);
                        trace(_loc6_);
                        this.readyTimer.delay = _loc6_;
                        this.readyTimer.start();
                  }
                  else if(this.initInNFrames > 0)
                  {
                        --this.initInNFrames;
                  }
                  ++this.minWaitTime;
            }
            
            private function SFSLogout(param1:Event) : void
            {
                  trace("Logout");
            }
            
            private function readyToPlay(param1:Event) : void
            {
                  Main(this.main).gameServer.send(new ExtensionRequest("r",new SFSObject(),Main(this.main).gameRoom));
            }
            
            private function getFavour(param1:Number, param2:Number) : String
            {
                  if(Math.abs(param1 - param2) < 25)
                  {
                        return "Even";
                  }
                  if(param1 < param2)
                  {
                        return "";
                  }
                  return "Favored";
            }
            
            public function SFSRoomJoinError(param1:SFSEvent) : void
            {
                  trace("Could not join the game!");
            }
      }
}
