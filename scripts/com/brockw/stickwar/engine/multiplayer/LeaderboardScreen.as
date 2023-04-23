package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import fl.controls.*;
   import flash.display.*;
   import flash.events.*;
   
   public class LeaderboardScreen extends Screen
   {
      
      private static const TOP_100:int = 0;
      
      private static const FRIENDS:int = 1;
      
      private static const TOP_DM_100:int = 2;
      
      private static const FRIENDS_DM:int = 3;
       
      
      private var mc:leaderboardScreenMc;
      
      private var leaderboardType:int;
      
      private var isMouseDown:Boolean;
      
      private var main:Main;
      
      internal var leaderboardCards:Array;
      
      private var leaderboardContainer:MovieClip;
      
      public function LeaderboardScreen(param1:Main)
      {
         super();
         this.main = param1;
         this.leaderboardType = FRIENDS;
         this.mc = new leaderboardScreenMc();
         addChild(this.mc);
         this.leaderboardCards = [];
         this.leaderboardContainer = new MovieClip();
         this.mc.scrollPane.source = this.leaderboardContainer;
         this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
         this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
      }
      
      public function loadLeaderboardData(param1:ISFSArray) : void
      {
         var _loc2_:LeaderboardCard = null;
         var _loc3_:LeaderboardCard = null;
         var _loc4_:int = 0;
         var _loc5_:SFSObject = null;
         for each(_loc2_ in this.leaderboardCards)
         {
            if(this.leaderboardContainer.contains(_loc2_))
            {
               this.leaderboardContainer.removeChild(_loc2_);
            }
         }
         this.leaderboardCards = [];
         _loc4_ = 0;
         while(_loc4_ < param1.size())
         {
            _loc5_ = SFSObject(param1.getSFSObject(_loc4_));
            this.leaderboardCards.push(_loc3_ = new LeaderboardCard(_loc5_));
            _loc3_.setRank(_loc4_ + 1);
            _loc4_++;
         }
         this.leaderboardCards.sort(this.leaderboardCompare);
         _loc4_ = 0;
         while(_loc4_ < param1.size())
         {
            this.leaderboardCards[_loc4_].setRank(_loc4_ + 1);
            _loc4_++;
         }
      }
      
      private function leaderboardCompare(param1:LeaderboardCard, param2:LeaderboardCard) : int
      {
         return param2.rating - param1.rating;
      }
      
      private function updateLeaderboardCards() : void
      {
         var _loc2_:LeaderboardCard = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.leaderboardCards)
         {
            if(!this.leaderboardContainer.contains(_loc2_))
            {
               this.leaderboardContainer.addChild(_loc2_);
            }
            _loc2_.y = _loc1_ * (_loc2_.height + 5);
            _loc2_.x = 0;
            _loc1_++;
         }
      }
      
      private function getLeaderboardData(param1:int) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("type",param1);
         var _loc3_:ExtensionRequest = new ExtensionRequest("leaderboard",_loc2_);
         this.main.sfs.send(_loc3_);
      }
      
      public function update(param1:Event) : void
      {
         this.updateLeaderboardCards();
         this.mc.topButton.gotoAndStop(1);
         this.mc.friendsButton.gotoAndStop(1);
         this.mc.topDMButton.gotoAndStop(1);
         this.mc.friendsDMButton.gotoAndStop(1);
         if(this.mc.topButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.topButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.leaderboardType = TOP_100;
               this.getLeaderboardData(TOP_100);
            }
         }
         else if(this.mc.topDMButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.topDMButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.leaderboardType = TOP_DM_100;
               this.getLeaderboardData(TOP_DM_100);
            }
         }
         else if(this.mc.friendsButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.friendsButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.getLeaderboardData(FRIENDS);
               this.leaderboardType = FRIENDS;
            }
         }
         else if(this.mc.friendsDMButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.friendsDMButton.gotoAndStop(2);
            if(this.isMouseDown)
            {
               this.getLeaderboardData(FRIENDS_DM);
               this.leaderboardType = FRIENDS_DM;
            }
         }
         if(this.leaderboardType == TOP_100)
         {
            this.mc.topButton.gotoAndStop(3);
         }
         else if(this.leaderboardType == FRIENDS)
         {
            this.mc.friendsButton.gotoAndStop(3);
         }
         else if(this.leaderboardType == TOP_DM_100)
         {
            this.mc.topDMButton.gotoAndStop(3);
         }
         else if(this.leaderboardType == FRIENDS_DM)
         {
            this.mc.friendsDMButton.gotoAndStop(3);
         }
         this.mc.scrollPane.update();
         this.isMouseDown = false;
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         this.isMouseDown = true;
      }
      
      override public function enter() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.getLeaderboardData(this.leaderboardType);
      }
      
      override public function leave() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
   }
}
