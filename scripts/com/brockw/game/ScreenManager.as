package com.brockw.game
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class ScreenManager extends Sprite
   {
       
      
      private var screens:Dictionary;
      
      private var currentScreenName:String;
      
      private var nextScreenName:String;
      
      private var currentOverlayScreenName:String;
      
      private var currentOverlay:com.brockw.game.Screen;
      
      private var fadeTransitionMc:Sprite;
      
      private var isFade:Boolean;
      
      internal var timer:Timer;
      
      public function ScreenManager()
      {
         super();
         this.screens = new Dictionary();
         this.currentScreenName = null;
         this.nextScreenName = null;
         this.currentOverlayScreenName = null;
         this.currentOverlay = null;
         this.fadeTransitionMc = new Sprite();
         this.fadeTransitionMc.graphics.beginFill(0,1);
         this.fadeTransitionMc.graphics.drawRect(0,0,1000,1000);
         this.fadeTransitionMc.alpha = 0;
         this.timer = new Timer(33,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
      }
      
      public function setOverlayScreen(param1:String) : void
      {
         if(param1 == this.currentOverlayScreenName)
         {
            return;
         }
         if(this.currentOverlayScreenName != null && this.contains(this.screens[this.currentOverlayScreenName]))
         {
            Screen(this.screens[this.currentOverlayScreenName]).leave();
            this.removeChild(this.screens[this.currentOverlayScreenName]);
            this.currentOverlayScreenName = null;
         }
         if(param1 in this.screens)
         {
            this.addChild(this.screens[param1]);
            this.currentOverlayScreenName = param1;
            Screen(this.screens[param1]).enter();
         }
      }
      
      public function getOverlayScreen() : String
      {
         return this.currentOverlayScreenName;
      }
      
      public function currentScreen() : String
      {
         return this.currentScreenName;
      }
      
      public function getScreen(param1:String) : com.brockw.game.Screen
      {
         if(param1 in this.screens)
         {
            return this.screens[param1];
         }
         return null;
      }
      
      public function addScreen(param1:String, param2:com.brockw.game.Screen) : Boolean
      {
         this.screens[param1] = param2;
         return true;
      }
      
      public function removeScreen(param1:String) : Boolean
      {
         delete this.screens[param1];
         return true;
      }
      
      public function showScreen(param1:String, param2:Boolean = false, param3:Boolean = false) : Boolean
      {
         var _loc4_:com.brockw.game.Screen = null;
         if(param1 == this.currentScreenName && param2 == true)
         {
            this.screens[this.currentScreenName].leave();
            this.screens[this.currentScreenName].enter();
         }
         if(this.screens[param1] != null && param1 != this.currentScreenName && param1 != this.nextScreenName)
         {
            this.nextScreenName = param1;
            _loc4_ = this.screens[param1];
            this.addChildAt(_loc4_,0);
            _loc4_.enter();
            _loc4_.visible = false;
            this.timer.start();
            if(param3 == true)
            {
               addChild(this.fadeTransitionMc);
               this.fadeTransitionMc.alpha = 0;
            }
            else if(contains(this.fadeTransitionMc))
            {
               removeChild(this.fadeTransitionMc);
            }
         }
         return true;
      }
      
      private function switchToNextScreen() : Boolean
      {
         if(this.nextScreenName == this.currentScreenName)
         {
            return false;
         }
         var _loc1_:com.brockw.game.Screen = this.screens[this.nextScreenName];
         var _loc2_:com.brockw.game.Screen = this.screens[this.currentScreenName];
         if(_loc2_ != null)
         {
            _loc2_.x = 0;
            this.screens[this.currentScreenName].leave();
            if(this.contains(this.screens[this.currentScreenName]))
            {
               this.removeChild(this.screens[this.currentScreenName]);
            }
         }
         this.currentScreenName = this.nextScreenName;
         _loc1_.visible = true;
         this.nextScreenName = null;
         return true;
      }
      
      private function update(param1:TimerEvent) : void
      {
         var _loc2_:com.brockw.game.Screen = this.screens[this.nextScreenName];
         var _loc3_:com.brockw.game.Screen = this.screens[this.currentScreenName];
         if(this.contains(this.fadeTransitionMc))
         {
            if(_loc3_ != _loc2_ && _loc2_ != null)
            {
               this.fadeTransitionMc.alpha += 0.075;
               if(this.fadeTransitionMc.alpha >= 1)
               {
                  this.switchToNextScreen();
               }
            }
            else
            {
               this.fadeTransitionMc.alpha -= 0.075;
               if(this.fadeTransitionMc.alpha <= 0)
               {
                  this.timer.stop();
                  if(this.contains(this.fadeTransitionMc))
                  {
                     removeChild(this.fadeTransitionMc);
                  }
               }
            }
         }
         else
         {
            this.switchToNextScreen();
            this.timer.stop();
            if(this.contains(this.fadeTransitionMc))
            {
               removeChild(this.fadeTransitionMc);
            }
         }
         param1.updateAfterEvent();
      }
   }
}
