package com.brockw.stickwar.campaign
{
      import com.brockw.game.*;
      import com.brockw.stickwar.BaseMain;
      import flash.display.*;
      import flash.events.*;
      import flash.net.*;
      import flash.system.*;
      import flash.utils.*;
      
      public class CampaignMenuScreen extends Screen
      {
            
            private static const S_FADE_IN:int = 0;
            
            private static const S_MAIN_MENU:int = 1;
            
            private static const S_NEW_OR_CONTINUE:int = 2;
            
            private static const S_DIFFICULTY_SELECT:int = 3;
            
            private static const S_INTRO:int = 4;
            
            private static const BOTTOM_GAP:int = 20;
            
            private static const SCREEN_HEIGHT:int = 700;
            
            private static const SCREEN_WIDTH:int = 850;
             
            
            private var isFirst:Boolean;
            
            private var mc:campaignMenuMc;
            
            private var state:int;
            
            private var panels:Array;
            
            private var currentPanel:MovieClip;
            
            private var buttons:Array;
            
            private var buttonsHit:Dictionary;
            
            private var main:BaseMain;
            
            private var youtubeLoader:YoutubeLoader;
            
            private var keyboard:KeyboardState;
            
            private var mouseState:MouseState;
            
            private var version:String;
            
            private var timeSinceTriedToStartYoutube:Number;
            
            private var hasInitStickpageLink:Boolean;
            
            public function CampaignMenuScreen(param1:BaseMain)
            {
                  var _loc3_:MovieClip = null;
                  var _loc4_:URLRequest = null;
                  var _loc5_:URLLoader = null;
                  super();
                  var _loc2_:XMLLoader = new XMLLoader();
                  this.version = "1.1.1";
                  this.main = param1;
                  this.isFirst = true;
                  this.mc = new campaignMenuMc();
                  this.state = S_FADE_IN;
                  this.panels = [this.mc.newOrContinuePanel,this.mc.mainPanel,this.mc.difficultyPanel,this.mc.introPanel];
                  for each(_loc3_ in this.panels)
                  {
                        _loc3_.pHeight = _loc3_.height;
                  }
                  this.currentPanel = null;
                  addChild(this.mc);
                  this.buttons = [];
                  this.buttonsHit = new Dictionary();
                  Security.allowDomain("stickempires.com");
                  _loc4_ = new URLRequest("http://www.stickempires.com/getIntroLink");
                  (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.TEXT;
                  _loc5_.addEventListener(Event.COMPLETE,this.handleComplete);
                  _loc5_.load(_loc4_);
                  this.youtubeLoader = new YoutubeLoader("w6q9EoFmu0w");
                  addChild(this.youtubeLoader);
                  this.hasInitStickpageLink = false;
                  this.mc.introBrokenMc.visible = false;
            }
            
            public function handleComplete(param1:Event) : void
            {
                  var _loc2_:String = String(param1.target.data);
                  if(_loc2_ != "")
                  {
                        removeChild(this.youtubeLoader);
                        this.youtubeLoader = new YoutubeLoader(_loc2_);
                        addChild(this.youtubeLoader);
                  }
            }
            
            private function addNewButton(param1:MovieClip, param2:Number, param3:Function) : void
            {
                  this.buttons.push([param1,param2,param3]);
            }
            
            private function switchToFadeIn() : void
            {
                  this.mc.gotoAndStop("fadeIn");
                  this.state = S_FADE_IN;
            }
            
            private function switchToMainMenu() : void
            {
                  this.mc.gotoAndStop("mainMenu");
                  this.state = S_MAIN_MENU;
            }
            
            private function switchToNewOrContinue() : void
            {
                  this.mc.gotoAndStop("mainMenu");
                  this.state = S_NEW_OR_CONTINUE;
            }
            
            private function switchToDifficultySelect() : void
            {
                  this.mc.gotoAndStop("mainMenu");
                  this.state = S_DIFFICULTY_SELECT;
            }
            
            private function switchToIntro() : void
            {
                  this.mc.gotoAndStop("mainMenu");
                  this.state = S_INTRO;
                  this.main.soundManager.playSoundInBackground("");
                  this.timeSinceTriedToStartYoutube = getTimer();
            }
            
            private function stickpageLink(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker != null)
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com");
                  }
            }
            
            private function update(param1:Event) : void
            {
                  var _loc2_:MovieClip = null;
                  var _loc3_:Array = null;
                  var _loc4_:MovieClip = null;
                  var _loc5_:Number = NaN;
                  var _loc6_:Function = null;
                  if(stage == null)
                  {
                        return;
                  }
                  this.mc.introBrokenMc.visible = false;
                  if(this.mc.stickpageLink)
                  {
                        MovieClip(this.mc.stickpageLink).buttonMode = true;
                        this.hasInitStickpageLink = true;
                        MovieClip(this.mc.stickpageLink).addEventListener(MouseEvent.CLICK,this.stickpageLink,false,0,true);
                  }
                  if(this.main.soundManager.isMusic)
                  {
                        this.mc.musicToggle.gotoAndStop(1);
                  }
                  else
                  {
                        this.mc.musicToggle.gotoAndStop(2);
                  }
                  this.mouseState.update();
                  this.mc.backButton.visible = true;
                  this.mc.creditsButton.visible = false;
                  if(this.state == S_INTRO)
                  {
                        if(getTimer() - this.timeSinceTriedToStartYoutube > 3 * 1000 && !this.youtubeLoader.isWorking())
                        {
                              this.youtubeLoader.visible = false;
                              this.youtubeLoader.stopVideo();
                              this.mc.introBrokenMc.visible = true;
                              this.mc.introBrokenMc.buttonMode = true;
                        }
                        else
                        {
                              this.mc.introBrokenMc.buttonMode = false;
                              if(this.youtubeLoader)
                              {
                                    this.youtubeLoader.visible = true;
                                    this.youtubeLoader.playVideo();
                                    this.youtubeLoader.x = SCREEN_WIDTH / 2 - 640 / 2;
                                    this.youtubeLoader.y = SCREEN_HEIGHT / 2 - 360 / 2;
                              }
                              this.mc.introOverlay.visible = true;
                              if(this.youtubeLoader.getTimePlayed() > 105)
                              {
                                    this.youtubeLoader.pauseVideo();
                                    this.skipButton();
                              }
                              this.mc.backButton.visible = false;
                              this.mc.creditsButton.visible = false;
                        }
                  }
                  else if(this.youtubeLoader)
                  {
                        this.youtubeLoader.visible = false;
                        this.youtubeLoader.stopVideo();
                        this.mc.introOverlay.visible = false;
                  }
                  if(this.mc.difficultySelectOverlay)
                  {
                        if(this.state == S_DIFFICULTY_SELECT)
                        {
                              this.mc.difficultySelectOverlay.alpha += (1 - this.mc.difficultySelectOverlay.alpha) * 0.2;
                              this.mc.difficultySelectOverlay.normal.visible = false;
                              this.mc.difficultySelectOverlay.hard.visible = false;
                              this.mc.difficultySelectOverlay.insane.visible = false;
                        }
                        else
                        {
                              this.mc.difficultySelectOverlay.alpha = 0;
                        }
                  }
                  if(this.state == S_FADE_IN)
                  {
                        this.mc.backButton.visible = false;
                        this.mc.creditsButton.visible = false;
                        if(this.mc.fade != null)
                        {
                              if(this.mc.fade.currentFrame == MovieClip(this.mc.fade).totalFrames)
                              {
                                    this.switchToMainMenu();
                              }
                        }
                  }
                  else
                  {
                        if(this.state == S_MAIN_MENU)
                        {
                              this.currentPanel = this.mc.mainPanel;
                              this.mc.backButton.visible = false;
                              this.mc.creditsButton.visible = true;
                        }
                        else if(this.state == S_NEW_OR_CONTINUE)
                        {
                              this.currentPanel = this.mc.newOrContinuePanel;
                              if(this.main.campaign.saveGameExists())
                              {
                                    this.mc.newOrContinuePanel.continueButton.visible = true;
                                    this.mc.newOrContinuePanel.continueButton.x = 386;
                                    this.mc.newOrContinuePanel.newGameButton.x = 106;
                              }
                              else
                              {
                                    this.mc.newOrContinuePanel.continueButton.visible = false;
                                    this.mc.newOrContinuePanel.newGameButton.x = 245;
                              }
                        }
                        else if(this.state == S_DIFFICULTY_SELECT)
                        {
                              this.currentPanel = this.mc.difficultyPanel;
                        }
                        else if(this.state == S_INTRO)
                        {
                              this.currentPanel = this.mc.introPanel;
                        }
                        for each(_loc2_ in this.panels)
                        {
                              if(this.currentPanel == _loc2_)
                              {
                                    _loc2_.y += (SCREEN_HEIGHT - _loc2_.pHeight - BOTTOM_GAP - _loc2_.y) * 0.2;
                              }
                              else
                              {
                                    _loc2_.y += (SCREEN_HEIGHT + 50 - _loc2_.y) * 0.2;
                              }
                        }
                        for each(_loc3_ in this.buttons)
                        {
                              _loc4_ = _loc3_[0];
                              _loc5_ = Number(_loc3_[1]);
                              _loc6_ = _loc3_[2];
                              if(_loc4_ in this.buttonsHit)
                              {
                                    --this.buttonsHit[_loc4_];
                                    if(this.buttonsHit[_loc4_] <= 0)
                                    {
                                          _loc6_();
                                          delete this.buttonsHit[_loc4_];
                                          break;
                                    }
                                    _loc4_.gotoAndStop(3);
                              }
                              else
                              {
                                    _loc4_.gotoAndStop(1);
                                    if(_loc4_.hitTestPoint(stage.mouseX,stage.mouseY))
                                    {
                                          _loc4_.gotoAndStop(2);
                                          if(this.mouseState.mouseJustDown())
                                          {
                                                this.mouseState.mouseDown = false;
                                                _loc4_.gotoAndStop(3);
                                                this.main.soundManager.playSoundFullVolume("clickButton");
                                                if(!(_loc4_ in this.buttonsHit))
                                                {
                                                      this.buttonsHit[_loc4_] = _loc5_;
                                                }
                                          }
                                          if(this.mc.difficultySelectOverlay)
                                          {
                                                if(this.state == S_DIFFICULTY_SELECT)
                                                {
                                                      if(_loc4_ == this.mc.difficultyPanel.normalButton || this.mc.difficultyPanel.normalButton in this.buttonsHit)
                                                      {
                                                            this.mc.difficultySelectOverlay.normal.visible = true;
                                                      }
                                                      else if(_loc4_ == this.mc.difficultyPanel.hardButton || this.mc.difficultyPanel.hardButton in this.buttonsHit)
                                                      {
                                                            this.mc.difficultySelectOverlay.hard.visible = true;
                                                      }
                                                      else if(_loc4_ == this.mc.difficultyPanel.insaneButton || this.mc.difficultyPanel.insaneButton in this.buttonsHit)
                                                      {
                                                            this.mc.difficultySelectOverlay.insane.visible = true;
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
                  if(this.mc.creditsScreen.visible == true)
                  {
                        this.mc.creditsButton.visible = false;
                        this.mc.backButton.visible = true;
                  }
            }
            
            private function toggleMusic(param1:Event) : void
            {
                  this.main.soundManager.isMusic = !this.main.soundManager.isMusic;
                  this.main.soundManager.isSound = !this.main.soundManager.isSound;
            }
            
            override public function enter() : void
            {
                  if(this.main.stage)
                  {
                        this.keyboard = new KeyboardState(this.main.stage);
                        this.mouseState = new MouseState(this.main.stage);
                        stage.frameRate = 30;
                  }
                  this.timeSinceTriedToStartYoutube = getTimer();
                  this.hasInitStickpageLink = false;
                  this.main.campaign = new Campaign(0,0);
                  this.mc.version.text = this.version;
                  this.mc.musicToggle.addEventListener(MouseEvent.CLICK,this.toggleMusic);
                  this.mc.musicToggle.buttonMode = true;
                  if(this.isFirst)
                  {
                        this.switchToFadeIn();
                  }
                  else
                  {
                        this.switchToMainMenu();
                  }
                  this.isFirst = false;
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.addNewButton(this.mc.mainPanel.campaignButton,15,this.campaignButton);
                  this.addNewButton(this.mc.newOrContinuePanel.newGameButton,15,this.newGameButton);
                  this.addNewButton(this.mc.newOrContinuePanel.continueButton,15,this.continueButton);
                  this.addNewButton(this.mc.difficultyPanel.normalButton,15,this.normalButton);
                  this.addNewButton(this.mc.difficultyPanel.hardButton,15,this.hardButton);
                  this.addNewButton(this.mc.difficultyPanel.insaneButton,15,this.insaneButton);
                  this.mc.creditsButton.addEventListener(MouseEvent.CLICK,this.creditsButton);
                  this.mc.backButton.addEventListener(MouseEvent.CLICK,this.backButton);
                  this.addNewButton(this.mc.introPanel.skipButton,15,this.skipButton);
                  this.main.soundManager.playSoundInBackground("loginMusic");
                  this.mc.mainPanel.onlineButton.addEventListener(MouseEvent.CLICK,this.onlineButton);
                  this.mc.mainPanel.stickWarButton.addEventListener(MouseEvent.CLICK,this.stickWarButton);
                  this.mc.introBrokenMc.addEventListener(MouseEvent.CLICK,this.openIntroLink);
                  this.mc.creditsScreen.visible = false;
            }
            
            private function skipButton() : void
            {
                  this.main.showScreen("campaignMap",false,true);
            }
            
            private function checkCheatMode() : *
            {
                  if(!this.main.isCampaignDebug)
                  {
                        return;
                  }
                  var _loc1_:int = 48;
                  while(_loc1_ <= 57)
                  {
                        if(this.keyboard.isDown(_loc1_))
                        {
                              if(this.keyboard.isShift)
                              {
                                    this.main.campaign.currentLevel = 10 + _loc1_ - 48;
                                    this.main.campaign.campaignPoints = 10 + _loc1_ - 48;
                              }
                              else
                              {
                                    this.main.campaign.currentLevel = _loc1_ - 48;
                                    this.main.campaign.campaignPoints = _loc1_ - 48;
                              }
                        }
                        _loc1_++;
                  }
            }
            
            private function normalButton() : void
            {
                  this.checkCheatMode();
                  this.skipButton();
                  this.main.campaign.setDifficulty(Campaign.D_INSANE);
            }
            
            private function hardButton() : void
            {
                  this.checkCheatMode();
                  this.skipButton();
                  this.main.campaign.setDifficulty(Campaign.D_INSANE);
            }
            
            private function insaneButton() : void
            {
                  this.checkCheatMode();
                  this.skipButton();
                  this.main.campaign.setDifficulty(Campaign.D_INSANE);
            }
            
            private function newGameButton() : void
            {
                  this.switchToDifficultySelect();
            }
            
            private function continueButton() : void
            {
                  this.main.campaign.load();
                  this.main.showScreen("campaignMap");
            }
            
            private function onlineButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("https://discord.gg/YkTq6pbMXs");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker != null)
                  {
                        this.main.tracker.trackEvent("link","https://discord.gg/YkTq6pbMXs");
                  }
            }
            
            private function stickWarButton(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("https://www.youtube.com/channel/UCFZRUe6UPOnFO5HmHz-zyAw");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker != null)
                  {
                        this.main.tracker.trackEvent("link","https://www.youtube.com/channel/UCFZRUe6UPOnFO5HmHz-zyAw");
                  }
            }
            
            private function openIntroLink(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com/stickwar2orderempireintro.shtml");
                  navigateToURL(_loc2_,"_blank");
                  if(this.main.tracker != null)
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickwar2orderempireintro.shtml");
                  }
            }
            
            override public function leave() : void
            {
                  this.mc.musicToggle.removeEventListener(MouseEvent.CLICK,this.toggleMusic);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.backButton.removeEventListener(MouseEvent.CLICK,this.backButton);
                  this.mc.creditsButton.removeEventListener(MouseEvent.CLICK,this.creditsButton);
                  this.buttons = [];
                  this.keyboard.cleanUp();
                  this.youtubeLoader.stopVideo();
                  this.mouseState.cleanUp();
                  this.mc.mainPanel.onlineButton.removeEventListener(MouseEvent.CLICK,this.onlineButton);
                  this.mc.mainPanel.stickWarButton.removeEventListener(MouseEvent.CLICK,this.stickWarButton);
                  this.mc.introBrokenMc.removeEventListener(MouseEvent.CLICK,this.openIntroLink);
                  if(this.hasInitStickpageLink)
                  {
                        MovieClip(this.mc.stickpageLink).addEventListener(MouseEvent.CLICK,this.stickpageLink,false,0,true);
                  }
            }
            
            private function backButton(param1:Event) : void
            {
                  if(this.mc.creditsScreen.visible)
                  {
                        this.mc.creditsScreen.visible = false;
                        this.mc.creditsButton.visible = true;
                        this.mc.backButton.visible = false;
                  }
                  else
                  {
                        this.switchToMainMenu();
                  }
            }
            
            private function creditsButton(param1:Event) : void
            {
                  this.mc.creditsScreen.visible = true;
                  this.mc.creditsScreen.credits.text = this.main.xml.xml.credits;
            }
            
            private function campaignButton() : void
            {
                  this.switchToNewOrContinue();
            }
      }
}
