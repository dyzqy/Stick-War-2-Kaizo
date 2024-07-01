package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      
      public class CreateClanScreen extends Screen
      {
             
            
            internal var mc:createClanScreenMc;
            
            internal var main:BaseMain;
            
            public function CreateClanScreen(param1:BaseMain)
            {
                  super();
                  this.main = param1;
                  this.mc = new createClanScreenMc();
                  addChild(this.mc);
            }
            
            private function createClan(param1:Event) : void
            {
                  var _loc2_:String = String(this.mc.clanName.text);
                  _loc2_ = _loc2_.replace(/^\s+|\s+$/g,"");
                  if(_loc2_.length > 20)
                  {
                        this.mc.error.text = "Clan name must be less than 20 characters.";
                        return;
                  }
                  if(_loc2_.length == 0)
                  {
                        this.mc.error.text = "No clan name supplied.";
                        return;
                  }
                  var _loc3_:SFSObject = new SFSObject();
                  _loc3_.putUtfString("clanName",this.mc.clanName.text);
                  this.main.sfs.send(new ExtensionRequest("createClan",_loc3_));
            }
            
            public function showError(param1:String) : void
            {
                  this.mc.error.text = param1;
            }
            
            override public function enter() : void
            {
                  this.mc.createClan.addEventListener(MouseEvent.CLICK,this.createClan);
                  this.mc.error.text = "";
                  this.mc.clanName.text = "";
            }
            
            override public function leave() : void
            {
                  this.mc.createClan.removeEventListener(MouseEvent.CLICK,this.createClan);
            }
      }
}
