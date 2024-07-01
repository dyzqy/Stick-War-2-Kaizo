package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.stickwar.*;
      import com.brockw.stickwar.engine.Team.*;
      import flash.display.*;
      import flash.events.*;
      
      public class MatchRecord extends Sprite
      {
             
            
            public var mc:MovieClip;
            
            private var replayCode:String;
            
            private var main:Main;
            
            private var playerA:String;
            
            private var playerB:String;
            
            public var userARatingValue:int;
            
            public var userBRatingValue:int;
            
            private var version:String;
            
            private var noWinLoss:Boolean;
            
            private var showAsMemberOnly:Boolean;
            
            private var isOwnReplay:Boolean;
            
            public function MatchRecord(param1:Boolean, param2:Boolean, param3:String, param4:Boolean, param5:String, param6:String, param7:int, param8:int, param9:String, param10:int, param11:Boolean, param12:Main, param13:Boolean = false, param14:Number = 0, param15:Number = 0, param16:Number = 0, param17:Number = 0)
            {
                  super();
                  this.userARatingValue = 0;
                  this.userBRatingValue = 0;
                  this.main = param12;
                  this.version = param3;
                  this.isOwnReplay = param2;
                  this.noWinLoss = param13;
                  this.showAsMemberOnly = param1;
                  if(param1)
                  {
                        this.mc = new gameRecordmembersOnlyMc();
                        this.mc.alpha = 0.2;
                        addChild(this.mc);
                        this.mc.addEventListener(MouseEvent.CLICK,this.membershipButton);
                        this.mc.buttonMode = true;
                        this.mc.mouseChildren = false;
                  }
                  else
                  {
                        if(param13)
                        {
                              this.mc = new gameRecordLiveGames();
                              this.mc.gameType.visible = true;
                              this.mc.userARating.text = "" + int(param14);
                              this.mc.userBRating.text = "" + int(param15);
                              this.userARatingValue = int(param14);
                              this.userBRatingValue = int(param15);
                        }
                        else
                        {
                              this.mc = new gameRecord();
                              this.mc.shareButton.addEventListener(MouseEvent.CLICK,this.share);
                              if(param2)
                              {
                                    this.mc.shareButton.buttonMode = true;
                                    this.mc.shareButton.mouseEnabled = true;
                              }
                              else
                              {
                                    this.mc.shareButton.buttonMode = false;
                                    this.mc.shareButton.mouseEnabled = false;
                                    this.mc.shareButton.alpha = 0.1;
                              }
                        }
                        addChild(this.mc);
                        this.mc.winOrLoss.gotoAndStop(param4 ? 1 : 3);
                        this.mc.userA.text = param5;
                        this.mc.userB.text = param6;
                        this.playerA = param5;
                        this.playerB = param6;
                        this.mc.raceTypeA.gotoAndStop(Team.getRaceNameFromId(param7));
                        this.mc.raceTypeB.gotoAndStop(Team.getRaceNameFromId(param8));
                        this.replayCode = param9;
                        this.mc.gameType.gotoAndStop(param10 + 1);
                        if(param11)
                        {
                              this.mc.replayButton.gotoAndStop(1);
                              this.mc.replayButton.buttonMode = true;
                              this.mc.replayButton.mouseEnabled = true;
                        }
                        else
                        {
                              this.mc.replayButton.gotoAndStop(2);
                              this.mc.replayButton.buttonMode = false;
                              this.mc.replayButton.mouseEnabled = false;
                        }
                        this.mc.userAButton.buttonMode = true;
                        this.mc.userBButton.buttonMode = true;
                        this.mc.userAButton.alpha = 0;
                        this.mc.userBButton.alpha = 0;
                        this.mc.replayButton.buttonMode = true;
                        this.mc.replayButton.addEventListener(MouseEvent.CLICK,this.replay);
                        this.mc.userAButton.addEventListener(MouseEvent.CLICK,this.userAButtonEvent);
                        this.mc.userBButton.addEventListener(MouseEvent.CLICK,this.userBButtonEvent);
                  }
            }
            
            public static function compare(param1:MatchRecord, param2:MatchRecord) : int
            {
                  return param2.getAverageRating() - param1.getAverageRating();
            }
            
            public function getAverageRating() : int
            {
                  return (this.userARatingValue + this.userBRatingValue) / 2;
            }
            
            private function userAButtonEvent(param1:Event) : void
            {
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.setProfileToLoad(this.playerA,this.isOwnReplay);
                  }
                  this.main.showScreen("profile",true);
            }
            
            private function userBButtonEvent(param1:Event) : void
            {
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.setProfileToLoad(this.playerB,this.isOwnReplay);
                  }
                  this.main.showScreen("profile",true);
            }
            
            private function replay(param1:Event) : void
            {
                  this.main.currentReplayLink = "www.stickempires.com/play?replay=" + this.replayCode + "&version=" + this.version;
                  this.main.replayLoadingScreen.loadReplay(this.replayCode);
                  this.main.showScreen("replayLoadingScreen");
            }
            
            private function share(param1:Event) : void
            {
                  trace("SHARE");
                  this.main.profileScreen.showLinkMc("www.stickempires.com/play?replay=" + this.replayCode + "&version=" + this.version);
            }
            
            private function membershipButton(param1:Event) : void
            {
                  this.main.showScreen("armoury");
                  Main(this.main).armourScreen.update(null);
                  Main(this.main).armourScreen.openPaymentScreen(null);
            }
            
            public function cleanUp() : void
            {
                  if(!this.showAsMemberOnly)
                  {
                        this.mc.replayButton.removeEventListener(MouseEvent.CLICK,this.replay);
                        this.mc.userAButton.removeEventListener(MouseEvent.CLICK,this.userAButtonEvent);
                        this.mc.userBButton.removeEventListener(MouseEvent.CLICK,this.userBButtonEvent);
                        if(!this.noWinLoss)
                        {
                              this.mc.shareButton.removeEventListener(MouseEvent.CLICK,this.share);
                        }
                  }
                  else
                  {
                        this.mc.removeEventListener(MouseEvent.CLICK,this.membershipButton);
                  }
            }
      }
}
