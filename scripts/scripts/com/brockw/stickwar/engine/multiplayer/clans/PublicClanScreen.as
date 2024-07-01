package com.brockw.stickwar.engine.multiplayer.clans
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      import flash.display.*;
      import flash.events.*;
      
      public class PublicClanScreen extends Screen
      {
             
            
            internal var mc:publicClanScreen;
            
            internal var main:BaseMain;
            
            internal var memberCards:Array;
            
            private var membersContainer:MovieClip;
            
            private var clanId:int = -1;
            
            private var usernameRequest:String = "";
            
            private var confirmationFunction:Function = null;
            
            public function PublicClanScreen(param1:BaseMain)
            {
                  super();
                  this.main = param1;
                  this.mc = new publicClanScreen();
                  addChild(this.mc);
                  this.memberCards = [];
                  this.membersContainer = new MovieClip();
                  this.mc.scrollPane.source = this.membersContainer;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            
            public function viewClan(param1:String) : void
            {
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putUtfString("clanName",param1);
                  this.main.sfs.send(new ExtensionRequest("viewClan",_loc2_));
            }
            
            public function loadClan(param1:SFSObject) : void
            {
                  var _loc5_:MemberCard = null;
                  var _loc6_:MemberCard = null;
                  var _loc7_:SFSArray = null;
                  var _loc8_:int = 0;
                  var _loc9_:SFSObject = null;
                  var _loc10_:SFSArray = null;
                  var _loc2_:* = param1.getUtfString("name") == Main(this.main).clanName;
                  var _loc3_:* = Main(this.main).clanId != -1;
                  var _loc4_:Boolean = param1.containsKey("requests");
                  this.clanId = param1.getInt("id");
                  this.mc.joinClan.visible = false;
                  this.mc.leaveClan.visible = false;
                  if(!_loc3_)
                  {
                        this.mc.joinClan.visible = true;
                  }
                  else if(_loc2_)
                  {
                        this.mc.leaveClan.visible = true;
                  }
                  trace("Is viewing own clan: ",_loc2_);
                  this.mc.clanName.text = param1.getUtfString("name");
                  for each(_loc5_ in this.memberCards)
                  {
                        if(this.membersContainer.contains(_loc5_))
                        {
                              this.membersContainer.removeChild(_loc5_);
                        }
                  }
                  this.memberCards = [];
                  _loc7_ = param1.getSFSArray("clanMembers");
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.size())
                  {
                        _loc9_ = SFSObject(_loc7_.getSFSObject(_loc8_));
                        this.memberCards.push(_loc6_ = new MemberCard(_loc9_,this.main,_loc4_,false,this.clanId));
                        _loc8_++;
                  }
                  if(param1.containsKey("requests"))
                  {
                        trace("contains requests",param1.getSFSArray("requests").size());
                        _loc10_ = param1.getSFSArray("requests");
                        _loc8_ = 0;
                        while(_loc8_ < _loc10_.size())
                        {
                              _loc9_ = SFSObject(_loc10_.getSFSObject(_loc8_));
                              this.memberCards.push(_loc6_ = new MemberCard(_loc9_,this.main,_loc4_,true,this.clanId));
                              _loc8_++;
                        }
                  }
                  this.updateClanCards();
            }
            
            private function updateClanCards() : void
            {
                  var _loc2_:MemberCard = null;
                  var _loc1_:int = 0;
                  for each(_loc2_ in this.memberCards)
                  {
                        if(!this.membersContainer.contains(_loc2_))
                        {
                              this.membersContainer.addChild(_loc2_);
                        }
                        _loc2_.y = _loc1_ * (_loc2_.height + 5);
                        _loc2_.x = 0;
                        _loc1_++;
                  }
            }
            
            private function findClans(param1:Event) : void
            {
                  this.main.showScreen("findClanScreen");
            }
            
            private function joinClan(param1:Event) : void
            {
                  Main(this.main).clanRequestScreen.setClanId(this.clanId);
                  this.main.showScreen("clanRequestScreen");
            }
            
            override public function enter() : void
            {
                  this.mc.findButton.addEventListener(MouseEvent.CLICK,this.findClans);
                  this.mc.joinClan.addEventListener(MouseEvent.CLICK,this.joinClan);
            }
            
            override public function leave() : void
            {
                  this.mc.findButton.removeEventListener(MouseEvent.CLICK,this.findClans);
                  this.mc.joinClan.removeEventListener(MouseEvent.CLICK,this.joinClan);
            }
      }
}
