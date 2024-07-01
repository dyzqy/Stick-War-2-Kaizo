package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.*;
      import com.brockw.simulationSync.*;
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.units.Unit;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.net.*;
      import flash.system.*;
      import flash.text.*;
      import flash.utils.*;
      
      public class PostGameScreen extends Screen
      {
            
            private static const TEXT_SPACING:Number = 75;
            
            public static const M_CAMPAIGN:int = 0;
            
            public static const M_MULTIPLAYER:int = 1;
            
            public static const M_SINGLEPLAYER:int = 2;
            
            public static const M_SYNC_ERROR:int = 3;
             
            
            private var gameType:int;
            
            private var main:BaseMain;
            
            private var id:int;
            
            private var txtWelcome:GenericText;
            
            internal var btnConnect:GenericButton;
            
            internal var txtReplayFile:TextField;
            
            private var _economyRecords:Array;
            
            private var _militaryRecords:Array;
            
            private var mc:victoryScreenMc;
            
            private var displayGraph:Sprite;
            
            private var displayGraphBackground:Sprite;
            
            private var displayGraphBackgroundHighlight:Sprite;
            
            private var D_WIDTH:int = 570;
            
            private var D_HEIGHT:int = 350;
            
            private var textBoxes:Array;
            
            private var mode:int;
            
            private var unitUnlocked:Array;
            
            private var teamAName:String;
            
            private var teamBName:String;
            
            private var showCard:Boolean;
            
            private var newRating:int;
            
            private var currentRating:int;
            
            private var oldRating:int;
            
            private var timerToGetProfile:Timer;
            
            private var frameCount:int;
            
            private var wasWin:Boolean;
            
            private var lastAddImage:MovieClip;
            
            public function PostGameScreen(param1:BaseMain)
            {
                  super();
                  this.gameType = StickWar.TYPE_CLASSIC;
                  this.mode = M_CAMPAIGN;
                  this.textBoxes = [];
                  this.mc = new victoryScreenMc();
                  addChild(this.mc);
                  this.displayGraph = this.mc.graphArea;
                  this.displayGraphBackground = this.mc.graphAreaBackground;
                  this.displayGraphBackgroundHighlight = this.mc.graphAreaBackgroundHighlight;
                  this.D_WIDTH = 740;
                  this.D_HEIGHT = 216;
                  this.lastAddImage = null;
                  this.main = param1;
                  this.unitUnlocked = [];
                  this.mc.unlockCard.visible = false;
                  this.mc.exit.text.text = "Quit";
                  this.mc.exit.buttonMode = true;
                  this.mc.exit.mouseChildren = false;
                  this.id = -1;
                  this.showCard = false;
            }
            
            public static function getTimeFormat(param1:int) : String
            {
                  var _loc2_:int = Math.floor(param1 / 60);
                  param1 = Math.floor(param1 % 60);
                  var _loc3_:* = "";
                  if(_loc2_ < 10)
                  {
                        _loc3_ += "0";
                  }
                  _loc3_ += _loc2_ + ":";
                  if(param1 < 10)
                  {
                        _loc3_ += "0";
                  }
                  return _loc3_ + ("" + param1);
            }
            
            public function setGameType(param1:int) : void
            {
                  this.gameType = param1;
            }
            
            public function appendUnitUnlocked(param1:int, param2:StickWar) : void
            {
                  var _loc3_:Unit = param2.unitFactory.getUnit(param1);
                  var _loc4_:XMLList = param2.team.buttonInfoMap[param1][2];
                  this.unitUnlocked.push([_loc4_.name,_loc4_.info,param2.unitFactory.getProfile(param1)]);
                  param2.unitFactory.returnUnit(_loc3_.type,_loc3_);
            }
            
            public function showNextUnitUnlocked() : void
            {
                  var _loc1_:Array = null;
                  var _loc2_:MovieClip = null;
                  if(this.unitUnlocked.length == 0)
                  {
                        this.mc.unlockCard.visible = false;
                        this.showCard = false;
                  }
                  else
                  {
                        this.showCard = true;
                        _loc1_ = this.unitUnlocked.shift();
                        this.mc.unlockCard.visible = true;
                        this.mc.unlockCard.alpha = 0;
                        this.mc.unlockCard.description.text = _loc1_[1];
                        this.mc.unlockCard.unitName.text = _loc1_[0];
                        _loc2_ = MovieClip(this.mc.unlockCard.profilePictureBacking);
                        if(this.lastAddImage != null)
                        {
                              if(this.mc.unlockCard.profilePictureBacking.contains(this.lastAddImage))
                              {
                                    this.mc.unlockCard.profilePictureBacking.removeChild(this.lastAddImage);
                              }
                        }
                        this.mc.unlockCard.profilePictureBacking.addChild(_loc1_[2]);
                        this.main.soundManager.playSoundFullVolume("UnitUnlock");
                        this.lastAddImage = _loc1_[2];
                  }
            }
            
            public function setRatings(param1:int, param2:int) : void
            {
                  trace("Set ratings",param1,param2);
                  this.mc.ratingA.text = "" + param1;
                  this.mc.ratingB.text = "" + param2;
                  this.oldRating = this.currentRating = this.newRating = param1;
            }
            
            public function setMode(param1:int, param2:Boolean = false) : void
            {
                  this.mode = param1;
                  this.mc.userAButton.buttonMode = false;
                  this.mc.userBButton.buttonMode = false;
                  this.mc.userAButton.mouseEnabled = false;
                  this.mc.userBButton.mouseEnabled = false;
                  this.mc.tip.visible = false;
                  if(this.mode == PostGameScreen.M_CAMPAIGN)
                  {
                        this.mc.exit.text.text = "Continue";
                        this.mc.singlePlayerOverlay.visible = true;
                        this.mc.timer.visible = true;
                        this.mc.saveReplay.text.text = "Play Online";
                        this.mc.saveReplay.visible = true;
                        if(!this.wasWin)
                        {
                              this.mc.exit.text.text = "Retry";
                        }
                  }
                  else if(this.mode == PostGameScreen.M_SYNC_ERROR)
                  {
                        this.mc.exit.text.text = "Continue";
                        this.mc.replay.text = "If this continues to happen try installing the latest version of flash player";
                        this.displayGraph.graphics.clear();
                        this.mc.saveReplay.visible = false;
                        this.mc.gameStatus.gotoAndStop("syncError");
                        this.mc.singlePlayerOverlay.visible = false;
                        this.mc.timer.visible = false;
                  }
                  else if(this.mode == PostGameScreen.M_SINGLEPLAYER)
                  {
                        this.mc.exit.text.text = "Quit";
                        this.mc.singlePlayerOverlay.visible = true;
                        this.mc.timer.visible = true;
                        this.mc.saveReplay.text.text = "Game Guide";
                  }
                  else
                  {
                        this.mc.unlockCard.visible = false;
                        this.mc.exit.text.text = "Continue";
                        this.mc.singlePlayerOverlay.visible = false;
                        this.mc.timer.visible = false;
                        this.mc.saveReplay.text.text = "View Replay";
                        this.mc.userAButton.buttonMode = true;
                        this.mc.userBButton.buttonMode = true;
                        this.mc.userAButton.mouseEnabled = true;
                        this.mc.userBButton.mouseEnabled = true;
                  }
            }
            
            private function drawLineGraph(param1:Array, param2:Number, param3:Sprite, param4:Boolean, param5:Number = 0) : void
            {
                  var _loc6_:Number = this.D_WIDTH / (param1.length / 2 - 1);
                  var _loc7_:Number = this.D_HEIGHT / param2;
                  var _loc8_:int = param4 ? 0 : 1;
                  while(_loc8_ < param1.length)
                  {
                        if(_loc8_ == 0 || _loc8_ == 1)
                        {
                              param3.graphics.moveTo(_loc6_ * Math.floor(_loc8_ / 2),this.D_HEIGHT - _loc7_ * param1[_loc8_] + param5);
                        }
                        else
                        {
                              param3.graphics.lineTo(_loc6_ * Math.floor(_loc8_ / 2),this.D_HEIGHT - _loc7_ * param1[_loc8_] + param5);
                        }
                        _loc8_ += 2;
                  }
            }
            
            private function drawSpecialLine(param1:Array, param2:Number, param3:Sprite, param4:Boolean, param5:int) : void
            {
                  this.displayGraphBackground.graphics.lineStyle(10,0);
                  this.drawLineGraph(param1,param2,this.displayGraphBackground,param4);
                  this.displayGraphBackground.graphics.endFill();
                  this.displayGraph.graphics.lineStyle(2,param5);
                  this.drawLineGraph(param1,param2,param3,param4);
                  this.displayGraph.graphics.endFill();
                  this.displayGraphBackgroundHighlight.graphics.lineStyle(2,2365457);
                  this.drawLineGraph(param1,param2,this.displayGraphBackgroundHighlight,param4,6);
                  this.displayGraphBackgroundHighlight.graphics.endFill();
            }
            
            private function drawGraph() : void
            {
                  var _loc3_:int = 0;
                  var _loc7_:TextField = null;
                  var _loc8_:String = null;
                  var _loc9_:TextField = null;
                  var _loc10_:TextFormat = null;
                  this.displayGraph.graphics.clear();
                  this.displayGraphBackground.graphics.clear();
                  this.displayGraphBackgroundHighlight.graphics.clear();
                  var _loc1_:int = 0;
                  var _loc2_:int = 0;
                  _loc3_ = 0;
                  while(_loc3_ < this.economyRecords.length)
                  {
                        if(this.economyRecords[_loc3_] > _loc1_)
                        {
                              _loc1_ = int(this.economyRecords[_loc3_]);
                        }
                        _loc3_++;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < this.militaryRecords.length)
                  {
                        if(this.militaryRecords[_loc3_] > _loc2_)
                        {
                              _loc2_ = int(this.militaryRecords[_loc3_]);
                        }
                        _loc3_++;
                  }
                  var _loc4_:int = Math.max(_loc1_,_loc2_);
                  var _loc5_:Number = this.D_WIDTH / (this.economyRecords.length / 2 - 1);
                  var _loc6_:Number = this.D_HEIGHT / Math.max(_loc1_,_loc2_);
                  this.drawSpecialLine(this.economyRecords,_loc4_,this.displayGraph,true,26367);
                  this.drawSpecialLine(this.economyRecords,_loc4_,this.displayGraph,false,16685313);
                  this.drawSpecialLine(this.militaryRecords,_loc4_,this.displayGraph,true,35840);
                  this.drawSpecialLine(this.militaryRecords,_loc4_,this.displayGraph,false,10223616);
                  for each(_loc7_ in this.textBoxes)
                  {
                        this.displayGraph.removeChild(_loc7_);
                  }
                  this.textBoxes = [];
                  _loc8_ = "";
                  _loc3_ = 0;
                  while(_loc3_ < this.D_WIDTH / TEXT_SPACING)
                  {
                        (_loc9_ = new TextField()).y = this.D_HEIGHT + 3;
                        _loc9_.x = _loc3_ * TEXT_SPACING - 5;
                        (_loc10_ = new TextFormat()).color = 16777215;
                        _loc9_.defaultTextFormat = _loc10_;
                        _loc9_.text = getTimeFormat(Math.floor(_loc3_ / (this.D_WIDTH / TEXT_SPACING) * this.militaryRecords.length / 2 * 2));
                        if(_loc9_.text == _loc8_)
                        {
                              _loc9_.visible = false;
                        }
                        _loc8_ = _loc9_.text;
                        _loc9_.mouseEnabled = false;
                        this.displayGraph.addChild(_loc9_);
                        this.textBoxes.push(_loc9_);
                        _loc3_++;
                  }
                  _loc8_ = "";
                  _loc3_ = 0;
                  while(_loc3_ < this.D_HEIGHT / TEXT_SPACING + 1)
                  {
                        (_loc9_ = new TextField()).y = this.D_HEIGHT - _loc3_ * TEXT_SPACING - 6;
                        _loc9_.x = 0 - 20;
                        (_loc10_ = new TextFormat()).color = 16777215;
                        _loc9_.defaultTextFormat = _loc10_;
                        _loc9_.text = "" + Math.floor(_loc2_ * _loc3_ / (this.D_WIDTH / TEXT_SPACING));
                        _loc9_.mouseEnabled = false;
                        if(_loc9_.text == _loc8_)
                        {
                              _loc9_.visible = false;
                        }
                        _loc8_ = _loc9_.text;
                        this.displayGraph.addChild(_loc9_);
                        this.textBoxes.push(_loc9_);
                        _loc3_++;
                  }
                  this.mc.timer.text = getTimeFormat(this.militaryRecords.length);
            }
            
            public function setRecords(param1:Array, param2:Array) : void
            {
                  this.economyRecords = param1;
                  this.militaryRecords = param2;
                  this.drawGraph();
            }
            
            private function btnConnectLogin(param1:Event) : void
            {
                  if(this.mode == PostGameScreen.M_MULTIPLAYER || this.mode == PostGameScreen.M_SYNC_ERROR || this.mode == PostGameScreen.M_SINGLEPLAYER)
                  {
                        if(this.main.sfs != null && Boolean(this.main.sfs.isConnected) && this.main.sfs.mySelf != null)
                        {
                              this.main.showScreen("lobby");
                        }
                        else
                        {
                              this.main.showScreen("login");
                        }
                  }
                  else if(this.mode == PostGameScreen.M_CAMPAIGN)
                  {
                        if(this.main.campaign.isGameFinished())
                        {
                              this.main.showScreen("summary",false,true);
                        }
                        else
                        {
                              this.main.soundManager.playSoundFullVolume("clickButton");
                              this.main.showScreen("campaignUpgradeScreen",false,true);
                        }
                  }
            }
            
            private function secondButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = null;
                  var _loc3_:SimulationSyncronizer = null;
                  var _loc4_:Boolean = false;
                  if(this.mode == PostGameScreen.M_CAMPAIGN)
                  {
                        _loc2_ = new URLRequest("http://www.stickempires.com");
                        navigateToURL(_loc2_,"_blank");
                        this.main.soundManager.playSoundFullVolume("clickButton");
                  }
                  else if(this.mode == PostGameScreen.M_SINGLEPLAYER)
                  {
                        _loc2_ = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
                        navigateToURL(_loc2_,"_blank");
                  }
                  else
                  {
                        if(!this.main.stickWar)
                        {
                              this.main.stickWar = new StickWar(this.main,Main(this.main).replayGameScreen);
                        }
                        _loc3_ = new SimulationSyncronizer(this.main.stickWar,this.main,null,null);
                        if((_loc4_ = _loc3_.gameReplay.fromString(this.mc.replay.text)) && _loc3_.gameReplay.version == Main(this.main).version)
                        {
                              Main(this.main).replayGameScreen.replayString = this.mc.replay.text;
                              this.main.showScreen("replayGame");
                        }
                  }
            }
            
            private function copyReplay(param1:Event) : void
            {
                  this.mc.replayViewer.replayText.text;
                  System.setClipboard(this.mc.replayViewer.replayText.text);
                  this.main.stage.focus = this.mc.replayViewer.replayText;
                  this.mc.replayViewer.replayText.setSelection(0,this.mc.replayViewer.replayText.length);
            }
            
            override public function enter() : void
            {
                  this.frameCount = 0;
                  stage.frameRate = 30;
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.exit.addEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  this.mc.saveReplay.addEventListener(MouseEvent.CLICK,this.secondButton);
                  this.mc.saveReplay.buttonMode = true;
                  this.mc.saveReplay.text.mouseEnabled = false;
                  this.mc.userAButton.addEventListener(MouseEvent.CLICK,this.hitUserA);
                  this.mc.userBButton.addEventListener(MouseEvent.CLICK,this.hitUserB);
                  this.mc.userA.mouseEnabled = false;
                  this.mc.userB.mouseEnabled = false;
                  this.mc.userAButton.buttonMode = true;
                  this.mc.userBButton.buttonMode = true;
                  this.mc.userA.mouseEnabled = false;
                  this.mc.userB.mouseEnabled = false;
                  this.mc.unlockCard.okButton.addEventListener(MouseEvent.CLICK,this.closeCard);
                  this.mc.tip.okButton.addEventListener(MouseEvent.CLICK,this.closeTipCard);
                  if(this.mode == PostGameScreen.M_MULTIPLAYER)
                  {
                        this.timerToGetProfile = new Timer(1000,1);
                        this.timerToGetProfile.addEventListener(TimerEvent.TIMER,this.getProfile);
                        this.timerToGetProfile.start();
                  }
                  this.mc.replayViewer.visible = false;
                  this.mc.replayViewer.exit.addEventListener(MouseEvent.CLICK,this.exit);
                  this.mc.replayViewer.view.addEventListener(MouseEvent.CLICK,this.viewReplay);
                  this.mc.replayViewer.copy.addEventListener(MouseEvent.CLICK,this.copyReplay);
                  this.mc.replayViewer.exit.buttonMode = true;
                  this.mc.replayViewer.copy.buttonMode = true;
                  this.mc.replayViewer.view.buttonMode = true;
                  this.mc.replayViewer.exit.mouseChildren = false;
                  this.mc.replayViewer.copy.mouseChildren = false;
                  this.mc.replayViewer.view.mouseChildren = false;
            }
            
            private function exit(param1:Event) : void
            {
                  this.mc.replayViewer.visible = false;
            }
            
            private function viewReplay(param1:Event) : void
            {
                  this.main.showScreen("replayLoader");
                  this.main.replayLoaderScreen.mc.replayText.text.text = this.mc.replay.text;
            }
            
            private function closeTipCard(param1:Event) : void
            {
                  this.mc.tip.visible = false;
                  this.main.soundManager.playSoundFullVolume("clickButton");
            }
            
            private function getProfile(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("name",this.main.sfs.mySelf.name);
                  var _loc3_:ExtensionRequest = new ExtensionRequest("getProfile",_loc2_);
                  this.main.sfs.send(_loc3_);
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
            
            private function hitUserA(param1:Event) : void
            {
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.setProfileToLoad(this.teamAName);
                  }
                  this.main.showScreen("profile");
            }
            
            private function hitUserB(param1:Event) : void
            {
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.setProfileToLoad(this.teamBName);
                  }
                  this.main.showScreen("profile");
            }
            
            private function closeCard(param1:Event) : void
            {
                  this.showCard = false;
                  this.main.soundManager.playSoundFullVolume("clickButton");
            }
            
            private function update(param1:Event) : void
            {
                  var _loc2_:String = null;
                  var _loc3_:int = 0;
                  ++this.frameCount;
                  if(this.frameCount % 3 == 0)
                  {
                        if(this.currentRating != this.newRating)
                        {
                              this.currentRating += Util.sgn(this.newRating - this.currentRating);
                        }
                        _loc2_ = "+";
                        _loc3_ = Math.abs(this.currentRating - this.oldRating);
                        if(this.currentRating < this.oldRating)
                        {
                              _loc2_ = "-";
                        }
                        if(this.newRating != this.oldRating)
                        {
                              this.mc.ratingA.text = this.currentRating + " (" + _loc2_ + _loc3_ + ")";
                        }
                        else
                        {
                              this.mc.ratingA.text = "" + this.currentRating;
                        }
                  }
                  if(this.showCard)
                  {
                        this.mc.unlockCard.alpha += (1 - this.mc.unlockCard.alpha) * 0.2;
                  }
                  else if(this.mc.unlockCard.visible == true)
                  {
                        this.mc.unlockCard.alpha += (0 - this.mc.unlockCard.alpha) * 0.3;
                        if(this.mc.unlockCard.alpha < 0.01)
                        {
                              this.showNextUnitUnlocked();
                        }
                  }
            }
            
            override public function leave() : void
            {
                  this.mc.exit.removeEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.unlockCard.okButton.removeEventListener(MouseEvent.CLICK,this.closeCard);
                  this.mc.userAButton.removeEventListener(MouseEvent.CLICK,this.hitUserA);
                  this.mc.userBButton.removeEventListener(MouseEvent.CLICK,this.hitUserB);
                  this.mc.tip.okButton.removeEventListener(MouseEvent.CLICK,this.closeTipCard);
                  this.mc.replayViewer.copy.removeEventListener(MouseEvent.CLICK,this.copyReplay);
                  this.mc.replayViewer.exit.removeEventListener(MouseEvent.CLICK,this.exit);
                  this.mc.replayViewer.view.removeEventListener(MouseEvent.CLICK,this.viewReplay);
            }
            
            public function setReplayFile(param1:String) : void
            {
                  this.mc.replay.text = param1;
                  this.mc.saveReplay.visible = true;
            }
            
            public function setTipText(param1:String) : void
            {
                  if(param1 != "")
                  {
                        this.mc.tip.tip.text = param1;
                        this.mc.tip.visible = true;
                  }
            }
            
            public function receiveProfile(param1:SFSObject) : void
            {
                  trace("RECEIVE PROFILE AFTER A MATCH");
                  var _loc2_:String = param1.getUtfString("username");
                  var _loc3_:int = param1.getDouble("rating");
                  if(this.gameType == StickWar.TYPE_DEATHMATCH)
                  {
                        _loc3_ = param1.getDouble("ratingDeathmatch");
                  }
                  var _loc4_:int = int(this.mc.ratingA.text);
                  var _loc5_:int = int(this.mc.ratingB.text);
                  trace(_loc4_,_loc3_,_loc2_);
                  if(this.mc.userA.text.toLowerCase() == _loc2_.toLowerCase())
                  {
                        if(this.mc.ratingA.text != "" && _loc4_ != _loc3_)
                        {
                              this.startRatingAnimationA(_loc3_);
                        }
                  }
            }
            
            private function startRatingAnimationA(param1:int) : void
            {
                  this.newRating = param1;
                  trace(param1);
            }
            
            public function setWinner(param1:int, param2:int, param3:String, param4:String, param5:int) : void
            {
                  var _loc6_:* = "";
                  if(param2 == Team.T_GOOD)
                  {
                        _loc6_ += "order";
                  }
                  else
                  {
                        _loc6_ += "chaos";
                  }
                  if(param5 != -1)
                  {
                        if(param5 == param1)
                        {
                              _loc6_ += "Victory";
                              this.wasWin = true;
                              this.main.soundManager.playSoundInBackground("OrderVictory");
                        }
                        else
                        {
                              this.wasWin = false;
                              _loc6_ += "Defeat";
                              this.main.soundManager.playSoundInBackground("OrderDefeat");
                        }
                  }
                  this.mc.userA.text = param3;
                  this.mc.userB.text = param4;
                  this.teamAName = param3;
                  this.teamBName = param4;
                  this.mc.gameStatus.gotoAndStop(_loc6_);
                  this.id = param1;
            }
            
            public function get economyRecords() : Array
            {
                  return this._economyRecords;
            }
            
            public function set economyRecords(param1:Array) : void
            {
                  this._economyRecords = param1;
            }
            
            public function get militaryRecords() : Array
            {
                  return this._militaryRecords;
            }
            
            public function set militaryRecords(param1:Array) : void
            {
                  this._militaryRecords = param1;
            }
      }
}
