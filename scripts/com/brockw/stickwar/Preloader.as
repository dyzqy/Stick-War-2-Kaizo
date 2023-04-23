package com.brockw.stickwar
{
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class Preloader extends MovieClip
   {
       
      
      internal var loadingMc:loadingScreenMc;
      
      internal var isLocked:Boolean;
      
      internal var version:int;
      
      internal var minorVersion:int;
      
      public var mainClassName:String = "com.brockw.stickwar.stickwar2";
      
      private var _firstEnterFrame:Boolean;
      
      private var _preloaderBackground:Shape;
      
      private var _preloaderPercent:Shape;
      
      public function Preloader()
      {
         super();
         this.loadingMc = new loadingScreenMc();
         addChild(this.loadingMc);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stop();
         this.loadingMc.loader.mask.scaleX = 1;
         var _loc1_:String = Capabilities.version;
         var _loc2_:Array = _loc1_.split(" ");
         var _loc3_:Array = _loc2_[1].split(",");
         var _loc4_:Number = Number(_loc3_[0]);
         var _loc5_:Number = Number(_loc3_[1]);
         this.version = _loc4_;
         this.minorVersion = _loc5_;
         if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
         {
            this.isLocked = true;
         }
      }
      
      public function start() : void
      {
         this._firstEnterFrame = true;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.align = StageAlign.TOP_LEFT;
         this.start();
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(this._firstEnterFrame)
         {
            this._firstEnterFrame = false;
            if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
            {
               this.dispose();
               this.run();
            }
            else
            {
               this.beginLoading();
            }
            return;
         }
         if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
         {
            this.dispose();
            this.run();
         }
         else
         {
            _loc2_ = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            this.updateLoading(_loc2_);
         }
      }
      
      private function updateLoading(param1:Number) : void
      {
         this.loadingMc.loader.mask.scaleX += (1 - param1 - this.loadingMc.loader.mask.scaleX) * 0.1;
      }
      
      private function beginLoading() : void
      {
         trace("begin Loading");
      }
      
      private function dispose() : void
      {
         trace("dispose preloader");
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this._preloaderBackground)
         {
            removeChild(this._preloaderBackground);
         }
         if(this._preloaderPercent)
         {
            removeChild(this._preloaderPercent);
         }
         if(this.loadingMc)
         {
            removeChild(this.loadingMc);
         }
         this._preloaderBackground = null;
         this._preloaderPercent = null;
      }
      
      private function run() : void
      {
         var _loc1_:Class = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:lockedMc = null;
         var _loc4_:String = null;
         var _loc5_:StyleSheet = null;
         var _loc6_:Object = null;
         if(!this.isLocked)
         {
            nextFrame();
            _loc1_ = getDefinitionByName(this.mainClassName) as Class;
            if(_loc1_ == null)
            {
               throw new Error("AbstractPreloader:initialize. There was no class matching that name. Did you remember to override mainClassName?");
            }
            _loc2_ = new _loc1_() as DisplayObject;
            if(_loc2_ == null)
            {
               throw new Error("AbstractPreloader:initialize. Main class needs to inherit from Sprite or MovieClip.");
            }
            addChildAt(_loc2_,0);
         }
         else
         {
            _loc3_ = new lockedMc();
            _loc4_ = stage.loaderInfo.url;
            addChild(_loc3_);
            if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
            {
               _loc5_ = new StyleSheet();
               (_loc6_ = new Object()).color = "#0000FF";
               _loc5_.setStyle(".myText",_loc6_);
               _loc3_.text.styleSheet = _loc5_;
               _loc3_.text.htmlText = "Flash version " + this.version + "." + this.minorVersion + " is out of date\n\nPlease update to the latest version of <a class=\'myText\' href=\'http://get.adobe.com/flashplayer/\'>Flash Player</a>\nor\nUse <a class=\'myText\' href=\'https://www.google.com/intl/en/chrome/browser/\'>Chrome browser</a>";
               _loc3_.text.selectable = true;
            }
         }
      }
   }
}
