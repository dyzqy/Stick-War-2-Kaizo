package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.*;
   
   public class FeaturedGames
   {
       
      
      internal var mc:featuredGamesPanel;
      
      private var featuredGames:Array;
      
      private var featuredGamesIndex:int = 0;
      
      private var featuredGamesRadios:Array;
      
      private var main:Main;
      
      private var lastFeatureSwitch:Number;
      
      public function FeaturedGames(param1:featuredGamesPanel, param2:Main)
      {
         super();
         this.mc = param1;
         this.main = param2;
         this.lastFeatureSwitch = 0;
         this.featuredGames = [];
         this.featuredGamesRadios = [param1.radio1,param1.radio2,param1.radio3,param1.radio4];
         var _loc3_:int = 0;
         while(_loc3_ < this.featuredGamesRadios.length)
         {
            this.featuredGamesRadios[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      public function watch() : void
      {
         this.main.currentReplayLink = "www.stickempires.com/play?replay=" + this.featuredGames[this.featuredGamesIndex].replayPointer + "&version=" + this.featuredGames[this.featuredGamesIndex].version;
         this.main.replayLoadingScreen.loadReplay(this.featuredGames[this.featuredGamesIndex].replayPointer);
         this.main.showScreen("replayLoadingScreen");
      }
      
      public function featuredGamesRadioClick(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         this.main.soundManager.playSoundFullVolume("clickButton");
         var _loc2_:int = 0;
         for each(_loc3_ in this.featuredGamesRadios)
         {
            if(_loc3_ == param1.target.parent)
            {
               this.featuredGamesIndex = _loc2_;
            }
            _loc2_++;
         }
      }
      
      public function moveFeatureIndex(param1:int, param2:Boolean = false) : *
      {
         if(this.featuredGames.length == 0)
         {
            return;
         }
         this.featuredGamesIndex += param1;
         if(this.featuredGamesIndex < 0)
         {
            this.featuredGamesIndex = 0;
         }
         if(param2)
         {
            this.featuredGamesIndex %= this.featuredGames.length;
         }
         else if(this.featuredGamesIndex >= this.featuredGames.length)
         {
            this.featuredGamesIndex = this.featuredGames.length - 1;
         }
      }
      
      public function update() : *
      {
         var _loc1_:int = 0;
         if(this.featuredGames.length == 0)
         {
            this.mc.watchNowDisabled.visible = true;
            this.mc.watchNowButton.visible = false;
         }
         else
         {
            if(getTimer() - this.lastFeatureSwitch > 10000)
            {
               this.moveFeatureIndex(1,true);
               this.lastFeatureSwitch = getTimer();
            }
            this.mc.watchNowButton.visible = true;
            this.mc.watchNowDisabled.visible = false;
            _loc1_ = 0;
            while(_loc1_ < this.featuredGames.length)
            {
               this.featuredGamesRadios[_loc1_].visible = true;
               if(_loc1_ == this.featuredGamesIndex)
               {
                  this.featuredGames[_loc1_].visible = true;
                  this.featuredGames[_loc1_].alpha += (1 - this.featuredGames[_loc1_].alpha) * 0.15;
                  this.featuredGamesRadios[_loc1_].gotoAndStop(2);
               }
               else
               {
                  this.featuredGames[_loc1_].visible = true;
                  this.featuredGames[_loc1_].alpha += (0 - this.featuredGames[_loc1_].alpha) * 0.15;
                  this.featuredGamesRadios[_loc1_].gotoAndStop(1);
               }
               _loc1_++;
            }
         }
      }
      
      public function loadFeaturedGames(param1:SFSObject) : *
      {
         var _loc2_:int = 0;
         var _loc3_:FeaturedGameCard = null;
         var _loc4_:ISFSArray = null;
         var _loc5_:ISFSObject = null;
         this.lastFeatureSwitch = getTimer();
         _loc2_ = 0;
         while(_loc2_ < this.featuredGamesRadios.length)
         {
            this.featuredGamesRadios[_loc2_].visible = false;
            _loc2_++;
         }
         for each(_loc3_ in this.featuredGames)
         {
            if(this.mc.contains(_loc3_))
            {
               this.mc.removeChild(_loc3_);
            }
         }
         this.featuredGames = [];
         if((_loc4_ = param1.getSFSArray("games")).size() > 0)
         {
            this.mc.noReplays.visible = false;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.size())
         {
            _loc5_ = _loc4_.getSFSObject(_loc2_);
            _loc3_ = new FeaturedGameCard(_loc5_);
            this.mc.addChild(_loc3_);
            this.featuredGames.push(_loc3_);
            _loc3_.alpha = 0;
            _loc2_++;
         }
      }
   }
}
