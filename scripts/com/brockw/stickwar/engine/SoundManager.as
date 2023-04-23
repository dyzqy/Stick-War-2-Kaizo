package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.BaseMain;
   import flash.events.*;
   import flash.media.*;
   import flash.utils.*;
   
   public class SoundManager
   {
      
      private static const globalSoundModifier:Number = 1.4;
       
      
      internal var sounds:Dictionary;
      
      internal var volumeMap:Dictionary;
      
      private var main:BaseMain;
      
      internal var playing:Array;
      
      internal var waiting:Array;
      
      private var lastX:Number;
      
      private var lastY:Number;
      
      private var _isMusic:Boolean;
      
      private var _isSound:Boolean;
      
      private var backgroundLoop:SoundChannel;
      
      private var backgroundVolume:Number;
      
      private var currentBackgroundName:String;
      
      private var targetBackgroundVolume:Number;
      
      private var timer:Timer;
      
      public function SoundManager(param1:BaseMain)
      {
         super();
         this.sounds = new Dictionary();
         this.volumeMap = new Dictionary();
         this.main = param1;
         this.playing = [];
         this.waiting = [];
         var _loc2_:int = 0;
         while(_loc2_ < 20)
         {
            this.waiting.push(new SoundChannel());
            _loc2_++;
         }
         this.lastX = this.lastY = 0;
         this.backgroundLoop = null;
         this.backgroundVolume = 0.3;
         this.timer = new Timer(1000 / 30);
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.timer.start();
         this.isMusic = true;
         this.isSound = true;
         this.currentBackgroundName = "";
         this.targetBackgroundVolume = 0.2;
      }
      
      public function cleanUp() : void
      {
         this.backgroundLoop.stop();
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.lastX = param1;
         this.lastY = param2;
      }
      
      public function update(param1:Event) : void
      {
         var _loc2_:SoundTransform = new SoundTransform();
         if(this.isMusic == true)
         {
            this.backgroundVolume += (this.targetBackgroundVolume - this.backgroundVolume) * 0.2;
         }
         else
         {
            this.backgroundVolume += (0 - this.backgroundVolume) * 0.2;
         }
         _loc2_.volume = this.backgroundVolume;
         if(this.backgroundLoop)
         {
            this.backgroundLoop.soundTransform = _loc2_;
         }
      }
      
      public function addSound(param1:String, param2:Class, param3:int, param4:Number = 1) : void
      {
         ++this.main.loadingFraction;
         if(param2 != null)
         {
            this.sounds[param1] = param2;
            this.volumeMap[param1] = param4 * globalSoundModifier;
         }
      }
      
      public function playSoundInBackground(param1:String) : void
      {
         if(param1 == this.currentBackgroundName)
         {
            return;
         }
         if(this.backgroundLoop != null)
         {
            this.backgroundLoop.stop();
         }
         if(param1 == "")
         {
            return;
         }
         var _loc2_:Sound = new this.sounds[param1]();
         this.backgroundLoop = _loc2_.play(0,int.MAX_VALUE);
         var _loc3_:SoundTransform = new SoundTransform();
         _loc3_.volume = this.backgroundVolume;
         this.backgroundLoop.soundTransform = _loc3_;
         this.currentBackgroundName = param1;
         this.targetBackgroundVolume = 0.2 * this.volumeMap[param1];
      }
      
      public function playSoundFullVolumeRandom(param1:String, param2:int) : Number
      {
         var _loc3_:String = param1 + (1 + Math.floor(Math.random() * param2));
         return this.playSoundFullVolume(_loc3_);
      }
      
      public function playSoundFullVolume(param1:String) : Number
      {
         var _loc2_:Sound = null;
         var _loc3_:SoundChannel = null;
         var _loc4_:SoundTransform = null;
         if(this.sounds[param1] != null)
         {
            _loc2_ = new this.sounds[param1]();
            _loc3_ = _loc2_.play();
            if(_loc3_ != null)
            {
               (_loc4_ = new SoundTransform()).volume = this.volumeMap[param1];
               if(!this.isSound)
               {
                  _loc4_.volume = 0;
               }
               _loc3_.soundTransform = _loc4_;
            }
            return _loc2_.length;
         }
         return 0;
      }
      
      public function playSoundRandom(param1:String, param2:int, param3:Number, param4:Number) : void
      {
         var _loc5_:String = param1 + (1 + Math.floor(Math.random() * param2));
         this.playSound(_loc5_,param3,param4);
      }
      
      public function playSound(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:SoundChannel = null;
         if(this.sounds[param1] != null)
         {
            _loc4_ = new this.sounds[param1]().play();
            this.setSoundTransformation(_loc4_,this.lastX,this.lastY,param2,param3,this.volumeMap[param1]);
         }
      }
      
      public function setSoundTransformation(param1:SoundChannel, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1) : void
      {
         var _loc7_:SoundTransform = null;
         var _loc8_:Number = NaN;
         if(param1 != null && this.main.stickWar != null)
         {
            (_loc7_ = new SoundTransform()).volume = 0.3 * param6;
            _loc8_ = (param4 - param2 - this.main.stickWar.stage.stageWidth / 2) / this.main.stickWar.stage.stageWidth;
            _loc7_.volume *= 1 / Math.max(1,Math.pow(Math.abs(_loc8_),4));
            _loc8_ = Math.max(Math.min(_loc8_,1),-1);
            _loc7_.pan = _loc8_;
            if(!this.isSound)
            {
               _loc7_.volume = 0;
            }
            param1.soundTransform = _loc7_;
         }
      }
      
      public function soundComplete(param1:Event) : void
      {
      }
      
      public function get isMusic() : Boolean
      {
         return this._isMusic;
      }
      
      public function set isMusic(param1:Boolean) : void
      {
         this._isMusic = param1;
      }
      
      public function get isSound() : Boolean
      {
         return this._isSound;
      }
      
      public function set isSound(param1:Boolean) : void
      {
         this._isSound = param1;
      }
   }
}
