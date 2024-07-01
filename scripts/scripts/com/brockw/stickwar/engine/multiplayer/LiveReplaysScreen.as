package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.Main;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      
      public class LiveReplaysScreen extends Screen
      {
             
            
            private var mc:liveReplaysMc;
            
            private var main:Main;
            
            private var gameRecords:Array;
            
            public function LiveReplaysScreen(param1:Main)
            {
                  super();
                  this.main = param1;
                  this.mc = new liveReplaysMc();
                  addChild(this.mc);
                  this.mc.scrollPane.source = this.mc.container;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            
            public function receiveTopGames(param1:SFSObject) : void
            {
                  var _loc3_:MatchRecord = null;
                  var _loc4_:int = 0;
                  var _loc5_:ISFSObject = null;
                  var _loc6_:Boolean = false;
                  var _loc7_:MatchRecord = null;
                  var _loc8_:MatchRecord = null;
                  var _loc2_:ISFSArray = param1.getSFSArray("games");
                  for each(_loc3_ in this.gameRecords)
                  {
                        if(this.mc.container.contains(_loc3_))
                        {
                              _loc3_.cleanUp();
                              this.mc.container.removeChild(_loc3_);
                        }
                  }
                  this.gameRecords = [];
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.size())
                  {
                        _loc5_ = _loc2_.getSFSObject(_loc4_);
                        _loc6_ = true;
                        if(_loc5_.getUtfString("replayPointer") == "")
                        {
                              _loc6_ = false;
                        }
                        if(_loc5_.getUtfString("version") != this.main.version)
                        {
                              _loc6_ = false;
                        }
                        _loc7_ = new MatchRecord(false,false,_loc5_.getUtfString("version"),true,_loc5_.getUtfString("userAusername"),_loc5_.getUtfString("userBusername"),_loc5_.getInt("raceA"),_loc5_.getInt("raceB"),_loc5_.getUtfString("replayPointer"),_loc5_.getInt("gameType"),_loc6_,this.main,true,_loc5_.getDouble("userArating"),_loc5_.getDouble("userBrating"));
                        this.mc.container.addChild(_loc7_);
                        _loc7_.y = _loc4_ * (49 + 55 / 4);
                        this.gameRecords.push(_loc7_);
                        _loc4_++;
                  }
                  this.gameRecords.sort(MatchRecord.compare);
                  _loc4_ = 0;
                  while(_loc4_ < this.gameRecords.length)
                  {
                        this.gameRecords[_loc4_].y = _loc4_ * (49 + 55 / 4);
                        (_loc8_ = MatchRecord(this.gameRecords[_loc4_])).mc.rank.text = "" + (_loc4_ + 1);
                        _loc4_++;
                  }
                  this.mc.scrollPane.update();
            }
            
            private function requestLiveGames() : void
            {
                  var _loc1_:SFSObject = new SFSObject();
                  var _loc2_:ExtensionRequest = new ExtensionRequest("getLiveMatches",_loc1_);
                  this.main.sfs.send(_loc2_);
            }
            
            override public function enter() : void
            {
                  this.requestLiveGames();
            }
            
            override public function leave() : void
            {
            }
      }
}
