package com.brockw.stickwar.engine.replay
{
      import com.brockw.game.Screen;
      import com.brockw.simulationSync.*;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      import flash.text.*;
      
      public class ReplayLoaderScreen extends Screen
      {
             
            
            private var main:Main;
            
            public var mc:replayLoaderMc;
            
            internal var txtReplayInput:GenericTextInput;
            
            public function ReplayLoaderScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  this.mc = new replayLoaderMc();
                  addChild(this.mc);
                  var _loc2_:TextField = TextField(this.mc.replayText.text);
                  _loc2_.embedFonts = false;
            }
            
            override public function enter() : void
            {
                  this.main.setOverlayScreen("chatOverlay");
                  this.mc.viewReplay.addEventListener(MouseEvent.CLICK,this.startReplay);
                  this.mc.broken.visible = false;
                  this.mc.broken.continueButton.addEventListener(MouseEvent.CLICK,this.continueButton);
            }
            
            private function continueButton(param1:Event) : void
            {
                  this.mc.broken.visible = false;
            }
            
            private function startReplay(param1:Event) : void
            {
                  var _loc2_:SimulationSyncronizer = null;
                  if(!this.main.stickWar)
                  {
                        this.main.stickWar = new StickWar(this.main,this.main.replayGameScreen);
                  }
                  _loc2_ = new SimulationSyncronizer(this.main.stickWar,this.main,null,null);
                  var _loc3_:Boolean = _loc2_.gameReplay.fromString(this.mc.replayText.text.text);
                  if(_loc3_ && _loc2_.gameReplay.version == this.main.version)
                  {
                        this.main.replayGameScreen.replayString = this.mc.replayText.text.text;
                        this.main.showScreen("replayGame");
                  }
                  else
                  {
                        this.mc.broken.visible = true;
                        if(_loc2_.gameReplay.version == this.main.version)
                        {
                              this.mc.broken.text.text = "Replay code is broken or incomplete. Please ensure that you have copied it correctly";
                        }
                        else
                        {
                              this.mc.broken.text.text = "Replay is from an older version of Stick Empires and is no longer viewable";
                        }
                  }
            }
            
            override public function leave() : void
            {
                  this.mc.viewReplay.removeEventListener(MouseEvent.CLICK,this.startReplay);
                  this.mc.broken.continueButton.removeEventListener(MouseEvent.CLICK,this.continueButton);
            }
      }
}
