package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import flash.events.*;
      
      public class NoClanScreen extends Screen
      {
             
            
            internal var mc:noClanScreenMc;
            
            internal var main:BaseMain;
            
            public function NoClanScreen(param1:BaseMain)
            {
                  super();
                  this.main = param1;
                  this.mc = new noClanScreenMc();
                  addChild(this.mc);
            }
            
            private function findClan(param1:Event) : void
            {
                  this.main.showScreen("findClanScreen");
            }
            
            private function createClan(param1:Event) : void
            {
                  this.main.showScreen("createClanScreen");
            }
            
            override public function enter() : void
            {
                  this.mc.findClan.addEventListener(MouseEvent.CLICK,this.findClan);
                  this.mc.createClan.addEventListener(MouseEvent.CLICK,this.createClan);
            }
            
            override public function leave() : void
            {
                  this.mc.findClan.removeEventListener(MouseEvent.CLICK,this.findClan);
                  this.mc.createClan.removeEventListener(MouseEvent.CLICK,this.createClan);
            }
      }
}
