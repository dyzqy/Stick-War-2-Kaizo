package com.brockw.stickwar.singleplayer
{
      import com.brockw.game.*;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.Team.*;
      import flash.events.*;
      import flash.utils.*;
      
      public class SingleplayerRaceSelect extends Screen
      {
             
            
            private var raceSelectMc:lobbyScreenMc;
            
            private var main:Main;
            
            private var startGameTimer:Timer;
            
            private var hasClicked:Boolean;
            
            private var isShowingMembershipRequired:Boolean;
            
            public function SingleplayerRaceSelect(param1:Main)
            {
                  this.main = param1;
                  this.hasClicked = false;
                  this.raceSelectMc = new lobbyScreenMc();
                  addChild(this.raceSelectMc);
                  this.isShowingMembershipRequired = false;
                  this.raceSelectMc.orderButton.stop();
                  this.raceSelectMc.chaosButton.stop();
                  this.raceSelectMc.randomButton.stop();
                  this.raceSelectMc.elementalButton.stop();
                  this.startGameTimer = new Timer(1.5,1);
                  this.raceSelectMc.countdown.visible = false;
                  super();
            }
            
            private function mouseDown(param1:MouseEvent) : void
            {
                  if(this.hasClicked)
                  {
                        return;
                  }
                  var _loc2_:Number = Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY,2));
                  if(_loc2_ < 150)
                  {
                        this.main.raceSelected = Team.T_GOOD;
                        this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                        this.hasClicked = true;
                  }
                  _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY,2));
                  if(Boolean(this.main.isMember) && _loc2_ < 150)
                  {
                        this.main.raceSelected = Team.T_CHAOS;
                        this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                        this.hasClicked = true;
                  }
                  _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.randomButton.mouseX,2) + Math.pow(this.raceSelectMc.randomButton.mouseY,2));
                  if(Boolean(this.main.isMember) && _loc2_ < 75)
                  {
                        this.main.raceSelected = Team.T_RANDOM;
                        this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                        this.hasClicked = true;
                  }
                  if(this.main.xml.xml.elementalsEnabled == 1)
                  {
                        _loc2_ = Math.sqrt(Math.pow(this.raceSelectMc.elementalButton.mouseX,2) + Math.pow(this.raceSelectMc.elementalButton.mouseY,2));
                        if(Boolean(this.main.isMember) && _loc2_ < 75)
                        {
                              this.main.raceSelected = Team.T_ELEMENTAL;
                              this.main.soundManager.playSoundFullVolume("SelectRaceSound");
                              this.hasClicked = true;
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
                  if(this.hasClicked)
                  {
                        this.startGameTimer.delay = 500;
                        this.startGameTimer.start();
                        trace("Start the timer");
                  }
            }
            
            private function startGame(param1:Event) : void
            {
                  trace("START GAME");
                  this.main.showScreen("singleplayerGame");
            }
            
            private function update(param1:Event) : void
            {
                  this.raceSelectMc.trialsLeft.visible = false;
                  if(this.main.raceSelected == Team.T_GOOD)
                  {
                        this.raceSelectMc.orderButton.gotoAndStop(3);
                  }
                  else if(Math.sqrt(Math.pow(this.raceSelectMc.orderButton.mouseX,2) + Math.pow(this.raceSelectMc.orderButton.mouseY + 100,2)) < 150)
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
                  else if(Boolean(this.main.isMember) && Math.sqrt(Math.pow(this.raceSelectMc.chaosButton.mouseX,2) + Math.pow(this.raceSelectMc.chaosButton.mouseY + 100,2)) < 150)
                  {
                        this.raceSelectMc.chaosButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.raceSelectMc.chaosButton.gotoAndStop(1);
                  }
                  if(this.main.raceSelected == Team.T_RANDOM)
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(3);
                  }
                  else if(Boolean(this.main.isMember) && Boolean(this.raceSelectMc.randomButton.hitTestPoint(stage.mouseX,stage.mouseY)))
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.raceSelectMc.randomButton.gotoAndStop(1);
                  }
                  if(this.main.xml.xml.elementalsEnabled == 1)
                  {
                        if(this.main.raceSelected == Team.T_ELEMENTAL)
                        {
                              this.raceSelectMc.elementalButton.gotoAndStop(3);
                        }
                        else if(Boolean(this.main.isMember) && Boolean(this.raceSelectMc.elementalButton.hitTestPoint(stage.mouseX,stage.mouseY)))
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
                  if(this.isShowingMembershipRequired)
                  {
                        this.raceSelectMc.membershipRequired.y += (684 - this.raceSelectMc.membershipRequired.y) * 0.1;
                  }
                  else
                  {
                        this.raceSelectMc.membershipRequired.y += (740 - this.raceSelectMc.membershipRequired.y) * 0.1;
                  }
            }
            
            private function showMembershipRequired(param1:Event) : void
            {
                  this.isShowingMembershipRequired = true;
            }
            
            override public function enter() : void
            {
                  this.main.raceSelected = -1;
                  this.hasClicked = false;
                  this.startGameTimer.addEventListener(TimerEvent.TIMER,this.startGame);
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
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
                        this.raceSelectMc.elementalsLocked.visible = false;
                        this.raceSelectMc.randomButton.visible = true;
                  }
                  else
                  {
                        this.raceSelectMc.chaosLocked.visible = true;
                        this.raceSelectMc.elementalsLocked.visible = true;
                        this.raceSelectMc.randomButton.visible = false;
                  }
                  this.raceSelectMc.comingSoon.buttonMode = false;
                  this.raceSelectMc.comingSoon.mouseEnabled = false;
            }
            
            override public function leave() : void
            {
                  this.raceSelectMc.chaosLocked.removeEventListener(MouseEvent.CLICK,this.showMembershipRequired);
                  this.raceSelectMc.elementalsLocked.removeEventListener(MouseEvent.CLICK,this.showMembershipRequired);
                  this.startGameTimer.removeEventListener(TimerEvent.TIMER,this.startGame);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
            }
      }
}
