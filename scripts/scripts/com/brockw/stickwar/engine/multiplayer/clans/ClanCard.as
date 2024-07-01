package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      
      public class ClanCard extends clanEntryMc
      {
             
            
            internal var main:BaseMain;
            
            public function ClanCard(param1:SFSObject, param2:BaseMain)
            {
                  super();
                  this.main = param2;
                  name = param1.getUtfString("name");
                  this.nameText.text = name;
                  this.view.addEventListener(MouseEvent.CLICK,this.viewClan,false,0,true);
            }
            
            private function viewClan(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("clanName",name);
                  this.main.sfs.send(new ExtensionRequest("viewClan",_loc2_));
                  if(Main(this.main).clanName == name)
                  {
                        this.main.showScreen("viewClanScreen");
                  }
                  else
                  {
                        this.main.showScreen("publicClanScreen");
                  }
            }
      }
}
