package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.Team.*;
      import com.smartfoxserver.v2.core.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      import flash.text.*;
      
      public class RaceSelectionScreen extends Screen
      {
             
            
            private var main:Main;
            
            private var mouseIsIn:int;
            
            private var mc:lobbyScreenMc;
            
            public function RaceSelectionScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  addChild(this.mc = new lobbyScreenMc());
                  this.mc.orderButton.stop();
                  this.mc.chaosButton.stop();
                  this.mc.randomButton.stop();
                  this.mouseIsIn = 0;
            }
            
            private function mouseDown(param1:Event) : void
            {
                  var _loc2_:Number = Math.sqrt(Math.pow(this.mc.orderButton.mouseX,2) + Math.pow(this.mc.orderButton.mouseY + 100,2));
                  if(_loc2_ < 150)
                  {
                        this.main.raceSelected = Team.T_GOOD;
                        this.raceChange();
                  }
                  _loc2_ = Math.sqrt(Math.pow(this.mc.chaosButton.mouseX,2) + Math.pow(this.mc.chaosButton.mouseY + 100,2));
                  if(_loc2_ < 150)
                  {
                        this.main.raceSelected = Team.T_CHAOS;
                        this.raceChange();
                  }
                  _loc2_ = Math.sqrt(Math.pow(this.mc.randomButton.mouseX,2) + Math.pow(this.mc.randomButton.mouseY,2));
                  if(_loc2_ < 75)
                  {
                        this.main.raceSelected = Team.T_RANDOM;
                        this.raceChange();
                  }
                  this.update(param1);
            }
            
            private function update(param1:Event) : void
            {
                  if(this.main.raceSelected == Team.T_GOOD)
                  {
                        this.mc.orderButton.gotoAndStop(3);
                  }
                  else if(Math.sqrt(Math.pow(this.mc.orderButton.mouseX,2) + Math.pow(this.mc.orderButton.mouseY + 100,2)) < 150)
                  {
                        this.mc.orderButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.mc.orderButton.gotoAndStop(1);
                  }
                  if(this.main.raceSelected == Team.T_CHAOS)
                  {
                        this.mc.chaosButton.gotoAndStop(3);
                  }
                  else if(Math.sqrt(Math.pow(this.mc.chaosButton.mouseX,2) + Math.pow(this.mc.chaosButton.mouseY + 100,2)) < 150)
                  {
                        this.mc.chaosButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.mc.chaosButton.gotoAndStop(1);
                  }
                  if(this.main.raceSelected == Team.T_RANDOM)
                  {
                        this.mc.randomButton.gotoAndStop(3);
                  }
                  else if(this.mc.randomButton.hitTestPoint(stage.mouseX,stage.mouseY))
                  {
                        this.mc.randomButton.gotoAndStop(2);
                  }
                  else
                  {
                        this.mc.randomButton.gotoAndStop(1);
                  }
            }
            
            private function raceChange() : void
            {
                  var _loc1_:int = int(this.main.raceSelected);
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putInt("race",_loc1_);
                  this.main.sfs.send(new ExtensionRequest("changeRace",_loc2_));
            }
            
            public function leaveQueueCount() : void
            {
            }
            
            override public function enter() : void
            {
                  this.main.setOverlayScreen("");
                  this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
                  this.addEventListener(Event.ENTER_FRAME,this.update);
                  stage.frameRate = 30;
            }
            
            override public function leave() : void
            {
                  this.removeEventListener(MouseEvent.CLICK,this.mouseDown);
                  this.removeEventListener(Event.ENTER_FRAME,this.update);
            }
      }
}
