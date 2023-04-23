package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.maps.*;
   import com.liamr.ui.dropDown.*;
   import com.liamr.ui.dropDown.Events.DropDownEvent;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;
   
   public class CustomMatchScreen extends Screen
   {
      
      private static const COMPUTER_EASY_CHAOS:String = "Easy Chaos Ai";
      
      private static const COMPUTER_HARD_CHAOS:String = "Hard Chaos Ai";
      
      private static const COMPUTER_INSANE_CHAOS:String = "Insane Chaos Ai";
      
      private static const COMPUTER_EASY_ORDER:String = "Easy Order Ai";
      
      private static const COMPUTER_HARD_ORDER:String = "Hard Order Ai";
      
      private static const COMPUTER_INSANE_ORDER:String = "Insane Order Ai";
      
      private static const TYPE_CLASSIC:String = "Classic";
      
      private static const TYPE_DEATHMATCH:String = "Deathmatch";
      
      private static const MAP_RANDOM_MAP:String = "Random Map";
       
      
      private var mc:customMatchScreenMc;
      
      private var gameTypeSelect:DropDown;
      
      private var mapSelect:DropDown;
      
      private var friendSelect:DropDown;
      
      private var currentMapPreview:MovieClip;
      
      private var main:Main;
      
      private var mapNameToId:Dictionary;
      
      private var lastInvitationSentTime:Number;
      
      public function CustomMatchScreen(param1:Main)
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Buddy = null;
         super();
         this.main = param1;
         this.currentMapPreview = null;
         this.lastInvitationSentTime = 0;
         this.mc = new customMatchScreenMc();
         addChild(this.mc);
         this.gameTypeSelect = new DropDown([TYPE_CLASSIC,TYPE_DEATHMATCH],"Select status",true,500);
         this.mc.chooseGameTypeContainer.addChild(this.gameTypeSelect);
         this.mapNameToId = new Dictionary();
         var _loc2_:Array = [MAP_RANDOM_MAP];
         for each(_loc3_ in Map.maps)
         {
            _loc2_.push(Map.getMapNameFromId(_loc3_) + " (" + Map.getSizeString(Map.getMapSizeId(_loc3_)) + ")");
            this.mapNameToId[Map.getMapNameFromId(_loc3_)] = _loc3_;
         }
         this.mapSelect = new DropDown(_loc2_,"Select status",true,500);
         this.mc.chooseMapContainer.addChild(this.mapSelect);
         this.mapSelect.addEventListener(DropDown.ITEM_SELECTED,this.updateMap);
         _loc4_ = [];
         for each(_loc5_ in param1.chatOverlay.buddyList.buddyMap)
         {
            _loc4_.push(_loc5_.name);
         }
         this.friendSelect = new DropDown(_loc4_,"Select status",true,500);
         this.mc.chooseFriendContainer.addChild(this.friendSelect);
      }
      
      private function updateMap(param1:DropDownEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:String = "Random Map";
         if(param1.selectedLabel.indexOf("(") != -1)
         {
            _loc2_ = param1.selectedLabel.slice(0,param1.selectedLabel.indexOf("(") - 1);
         }
         var _loc3_:int = -1;
         for each(_loc4_ in Map.maps)
         {
            if(Map.getMapNameFromId(_loc4_) == _loc2_)
            {
               _loc3_ = _loc4_;
            }
         }
         if(this.currentMapPreview)
         {
            removeChild(this.currentMapPreview);
            this.currentMapPreview = null;
         }
         this.currentMapPreview = Map.getMapDisplayFromId(_loc3_);
         this.currentMapPreview.filters = [new GlowFilter(16757760,1,4,4,2,1)];
         addChild(this.currentMapPreview);
         this.currentMapPreview.x = this.main.stage.stageWidth / 2 - this.currentMapPreview.width / 2;
         this.currentMapPreview.y = 185;
      }
      
      private function inviteToGame(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Buddy = null;
         var _loc11_:SFSObject = null;
         trace("TRY TO START A GAME");
         var _loc2_:String = String(this.friendSelect.selectedLabel);
         var _loc3_:String = String(this.gameTypeSelect.selectedLabel);
         _loc4_ = String(MAP_RANDOM_MAP);
         var _loc5_:int = -1;
         if(this.mapSelect.selectedLabel != MAP_RANDOM_MAP)
         {
            _loc4_ = String(this.mapSelect.selectedLabel.slice(0,this.mapSelect.selectedLabel.indexOf("(") - 1));
            _loc5_ = int(this.mapNameToId[_loc4_]);
         }
         if(_loc2_ == COMPUTER_EASY_CHAOS || _loc2_ == COMPUTER_HARD_CHAOS || _loc2_ == COMPUTER_INSANE_CHAOS || _loc2_ == COMPUTER_EASY_ORDER || _loc2_ == COMPUTER_HARD_ORDER || _loc2_ == COMPUTER_INSANE_ORDER)
         {
            trace("START AN AI GAME");
            _loc6_ = 1.2;
            _loc7_ = int(Team.T_GOOD);
            _loc8_ = "Easy Ai";
            _loc8_ = _loc2_;
            if(_loc2_ == COMPUTER_EASY_ORDER)
            {
               _loc6_ = 1.2;
               _loc7_ = int(Team.T_GOOD);
            }
            else if(_loc2_ == COMPUTER_HARD_ORDER)
            {
               _loc6_ = 1;
               _loc7_ = int(Team.T_GOOD);
            }
            else if(_loc2_ == COMPUTER_INSANE_ORDER)
            {
               _loc6_ = 0.75;
               _loc7_ = int(Team.T_GOOD);
            }
            else if(_loc2_ == COMPUTER_EASY_CHAOS)
            {
               _loc6_ = 1.2;
               _loc7_ = int(Team.T_CHAOS);
            }
            else if(_loc2_ == COMPUTER_HARD_CHAOS)
            {
               _loc6_ = 1;
               _loc7_ = int(Team.T_CHAOS);
            }
            else if(_loc2_ == COMPUTER_INSANE_CHAOS)
            {
               _loc6_ = 0.75;
               _loc7_ = int(Team.T_CHAOS);
            }
            this.main.singleplayerGameScreen.opponentName = _loc8_;
            this.main.singleplayerGameScreen.map = _loc5_;
            this.main.singleplayerGameScreen.gameType = _loc3_ == TYPE_CLASSIC ? int(StickWar.TYPE_CLASSIC) : int(StickWar.TYPE_DEATHMATCH);
            this.main.singleplayerGameScreen.handicap = _loc6_;
            this.main.singleplayerGameScreen.opponentRace = _loc7_;
            this.main.setOverlayScreen("");
            this.main.showScreen("singleplayerRaceSelect");
         }
         else if(getTimer() - this.lastInvitationSentTime > 3000)
         {
            this.lastInvitationSentTime = getTimer();
            _loc9_ = -1;
            for each(_loc10_ in this.main.chatOverlay.buddyList.buddyMap)
            {
               trace(_loc10_.name,_loc2_);
               if(_loc10_.name == _loc2_)
               {
                  _loc9_ = _loc10_.id;
               }
            }
            trace("PLAY AGAINST",_loc9_,_loc2_);
            (_loc11_ = new SFSObject()).putInt("invitee",_loc9_);
            _loc11_.putInt("map",_loc5_);
            _loc11_.putInt("gameType",_loc3_ == TYPE_CLASSIC ? int(StickWar.TYPE_CLASSIC) : int(StickWar.TYPE_DEATHMATCH));
            this.main.sfs.send(new ExtensionRequest("buddyGameInvite",_loc11_));
            this.mc.invitationResponse.visible = true;
            this.mc.invitationResponse.text = "Invitation sent to " + _loc2_;
         }
      }
      
      override public function enter() : void
      {
         var _loc2_:Buddy = null;
         this.mc.playButton.addEventListener(MouseEvent.CLICK,this.inviteToGame);
         this.mc.invitationResponse.visible = false;
         this.mc.chooseFriendContainer.removeChild(this.friendSelect);
         this.friendSelect = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.main.chatOverlay.buddyList.buddyMap)
         {
            if(_loc2_.statusType == Buddy.S_ONLINE || _loc2_.statusType == Buddy.S_AWAY)
            {
               _loc1_.push(_loc2_.name);
            }
         }
         _loc1_.push(COMPUTER_EASY_CHAOS);
         _loc1_.push(COMPUTER_HARD_CHAOS);
         _loc1_.push(COMPUTER_INSANE_CHAOS);
         _loc1_.push(COMPUTER_EASY_ORDER);
         _loc1_.push(COMPUTER_HARD_ORDER);
         _loc1_.push(COMPUTER_INSANE_ORDER);
         this.friendSelect = new DropDown(_loc1_,"Select status",true,500);
         this.mc.chooseFriendContainer.addChild(this.friendSelect);
      }
      
      override public function leave() : void
      {
         this.mc.playButton.removeEventListener(MouseEvent.CLICK,this.inviteToGame);
      }
   }
}
