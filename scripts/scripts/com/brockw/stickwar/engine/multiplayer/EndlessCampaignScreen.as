package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.missions.*;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.*;
      
      public class EndlessCampaignScreen extends Screen
      {
             
            
            internal var mc:_mapScreenMc;
            
            internal var missionStartMenu:_missionStartMenu;
            
            internal var main:BaseMain;
            
            internal var faqText:Object;
            
            private var currentMissionViewing:Mission = null;
            
            private var missions:Array;
            
            public function EndlessCampaignScreen(param1:BaseMain)
            {
                  this.missions = [];
                  super();
                  this.main = param1;
                  this.mc = new _mapScreenMc();
                  addChild(this.mc);
                  this.missionStartMenu = new _missionStartMenu();
                  addChild(this.missionStartMenu);
                  this.missionStartMenu.visible = false;
            }
            
            public function loadCampaign(param1:SFSObject) : void
            {
                  var _loc2_:Mission = null;
                  var _loc3_:ISFSArray = null;
                  var _loc4_:int = 0;
                  for each(_loc2_ in this.missions)
                  {
                        _loc2_.removeEventListener(MouseEvent.CLICK,this.openMission);
                        removeChild(_loc2_);
                  }
                  this.missions = [];
                  _loc3_ = param1.getSFSArray("missions");
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.size())
                  {
                        _loc2_ = new Mission(_loc3_.getSFSObject(_loc4_),_loc4_ + 1);
                        _loc2_.addEventListener(MouseEvent.CLICK,this.openMission);
                        addChild(_loc2_);
                        this.missions.push(_loc2_);
                        _loc4_++;
                  }
            }
            
            override public function enter() : void
            {
            }
            
            override public function leave() : void
            {
            }
            
            private function startMission(param1:Event) : void
            {
                  trace(this.currentMissionViewing);
                  var _loc2_:SFSObject = new SFSObject();
                  _loc2_.putInt("missionId",this.currentMissionViewing.id);
                  this.main.sfs.send(new ExtensionRequest("getMission",_loc2_));
            }
            
            private function showMissionStartMenu(param1:Mission) : void
            {
                  this.missionStartMenu.visible = true;
                  this.missionStartMenu.closeButton.addEventListener(MouseEvent.CLICK,this.closeMissionStartMenu);
                  this.missionStartMenu.startButton.addEventListener(MouseEvent.CLICK,this.startMission);
                  this.missionStartMenu.titleText.text = param1.missionName;
                  this.missionStartMenu.descriptionText.text = param1.description;
                  this.currentMissionViewing = param1;
            }
            
            private function closeMissionStartMenu(param1:MouseEvent) : void
            {
                  this.missionStartMenu.visible = false;
                  this.missionStartMenu.closeButton.removeEventListener(MouseEvent.CLICK,this.closeMissionStartMenu);
                  this.missionStartMenu.startButton.removeEventListener(MouseEvent.CLICK,this.startMission);
            }
            
            private function openMission(param1:MouseEvent) : void
            {
                  var _loc2_:Mission = null;
                  for each(_loc2_ in this.missions)
                  {
                        if(param1.target == _loc2_)
                        {
                              this.showMissionStartMenu(_loc2_);
                        }
                  }
            }
      }
}
