package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      
      public class ClanRequestScreen extends Screen
      {
             
            
            internal var mc:clanRequestScreenMc;
            
            internal var main:BaseMain;
            
            private var clanId:int;
            
            public function ClanRequestScreen(param1:BaseMain)
            {
                  super();
                  this.main = param1;
                  this.mc = new clanRequestScreenMc();
                  addChild(this.mc);
                  this.clanId = -1;
            }
            
            public function setClanId(param1:int) : void
            {
                  this.clanId = param1;
            }
            
            private function request(param1:Event) : void
            {
                  var _loc2_:SFSObject = null;
                  if(this.clanId != -1)
                  {
                        _loc2_ = new SFSObject();
                        _loc2_.putInt("clanId",this.clanId);
                        _loc2_.putUtfString("message",this.mc.message.text);
                        this.main.sfs.send(new ExtensionRequest("requestClan",_loc2_));
                        this.main.showScreen("viewClanScreen");
                  }
            }
            
            override public function enter() : void
            {
                  this.mc.request.addEventListener(MouseEvent.CLICK,this.request);
            }
            
            override public function leave() : void
            {
                  this.mc.request.removeEventListener(MouseEvent.CLICK,this.request);
            }
      }
}
