package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      import flash.display.*;
      import flash.events.*;
      
      public class FindClanScreen extends Screen
      {
             
            
            internal var mc:findClanScreenMc;
            
            internal var main:BaseMain;
            
            internal var clanCards:Array;
            
            private var clansContainer:MovieClip;
            
            public function FindClanScreen(param1:BaseMain)
            {
                  super();
                  this.main = param1;
                  this.mc = new findClanScreenMc();
                  addChild(this.mc);
                  this.clanCards = [];
                  this.clansContainer = new MovieClip();
                  this.mc.scrollPane.source = this.clansContainer;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            
            public function loadClanData(param1:ISFSArray) : void
            {
                  var _loc2_:ClanCard = null;
                  var _loc3_:ClanCard = null;
                  var _loc4_:int = 0;
                  var _loc5_:SFSObject = null;
                  for each(_loc2_ in this.clanCards)
                  {
                        if(this.clansContainer.contains(_loc2_))
                        {
                              this.clansContainer.removeChild(_loc2_);
                        }
                  }
                  this.clanCards = [];
                  _loc4_ = 0;
                  while(_loc4_ < param1.size())
                  {
                        _loc5_ = SFSObject(param1.getSFSObject(_loc4_));
                        this.clanCards.push(_loc3_ = new ClanCard(_loc5_,this.main));
                        _loc4_++;
                  }
                  this.updateClanCards();
            }
            
            private function updateClanCards() : void
            {
                  var _loc2_:ClanCard = null;
                  var _loc1_:int = 0;
                  for each(_loc2_ in this.clanCards)
                  {
                        if(!this.clansContainer.contains(_loc2_))
                        {
                              this.clansContainer.addChild(_loc2_);
                        }
                        _loc2_.y = _loc1_ * (_loc2_.height + 5);
                        _loc2_.x = 0;
                        _loc1_++;
                  }
            }
            
            private function findClans(param1:Event) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("query",this.mc.clanName.text);
                  this.main.sfs.send(new ExtensionRequest("findClan",_loc2_));
            }
            
            override public function enter() : void
            {
                  this.mc.findClans.addEventListener(MouseEvent.CLICK,this.findClans);
                  this.mc.clanName.text = "";
                  var _loc1_:SFSObject = new SFSObject();
                  _loc1_.putUtfString("query","");
                  this.main.sfs.send(new ExtensionRequest("findClan",_loc1_));
            }
            
            override public function leave() : void
            {
                  this.mc.findClans.removeEventListener(MouseEvent.CLICK,this.findClans);
            }
      }
}
