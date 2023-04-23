package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.MovieClip;
   import flash.external.*;
   import flash.utils.*;
   
   public class FacebookCardManager extends MovieClip
   {
      
      internal static const NUM_CARDS:int = 8;
       
      
      private var cards:Array;
      
      private var main:Main;
      
      internal var scrollIndex:int;
      
      internal var idToCard:Dictionary;
      
      public function FacebookCardManager(param1:Main)
      {
         super();
         this.main = param1;
         this.cards = [];
         this.idToCard = new Dictionary();
         this.scrollIndex = 0;
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("retrieveFacebookIdInfo",this.retrieveFacebookId);
         }
      }
      
      public function compare(param1:FacebookCard, param2:FacebookCard) : int
      {
         if(param1.rating == param2.rating)
         {
            if(param2.username < param1.username)
            {
               return -1;
            }
            return 1;
         }
         return param2.rating - param1.rating;
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cards.length)
         {
            this.cards[_loc1_].update();
            this.cards[_loc1_].x += (this.scrollIndex * 88 + 88 * _loc1_ - this.cards[_loc1_].x) * 0.2;
            _loc1_++;
         }
      }
      
      public function scrollRight() : void
      {
         if(this.scrollIndex > -this.cards.length + 8)
         {
            --this.scrollIndex;
         }
      }
      
      public function scrollLeft() : void
      {
         if(this.scrollIndex < 0)
         {
            ++this.scrollIndex;
         }
      }
      
      public function receiveUserInfo(param1:SFSObject) : void
      {
         var _loc4_:FacebookCard = null;
         var _loc2_:Number = param1.getLong("fuid");
         if(this.idToCard[_loc2_])
         {
            (_loc4_ = this.idToCard[_loc2_]).loadData(param1);
         }
         this.cards.sort(this.compare);
         var _loc3_:int = 0;
         while(_loc3_ < this.cards.length)
         {
            this.cards[_loc3_].update();
            this.cards[_loc3_].x += (this.scrollIndex * 88 + 88 * _loc3_ - this.cards[_loc3_].x) * 1;
            _loc3_++;
         }
      }
      
      public function retrieveFacebookId(param1:Number) : *
      {
         trace("ADD SELF:",param1);
         var _loc2_:int = int(this.cards.length);
         var _loc3_:FacebookCard = new FacebookCard(this.main,param1);
         this.idToCard[param1] = _loc3_;
         this.cards.push(_loc3_);
         addChild(_loc3_);
         _loc3_.x = 88 * _loc2_;
      }
      
      public function loadCards(param1:Array) : void
      {
         var _loc2_:FacebookCard = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         for each(_loc2_ in this.cards)
         {
            if(this.contains(_loc2_))
            {
               removeChild(_loc2_);
            }
            _loc2_.cleanUp();
         }
         this.cards = [];
         this.idToCard = new Dictionary();
         _loc3_ = 0;
         for each(_loc4_ in param1)
         {
            _loc2_ = new FacebookCard(this.main,_loc4_["uid"]);
            this.idToCard[_loc4_["uid"]] = _loc2_;
            this.cards.push(_loc2_);
            addChild(_loc2_);
            _loc2_.x = 88 * _loc3_;
            _loc3_++;
         }
         if(ExternalInterface.available && this.main.isOnFacebook && this.main.sfs != null && this.main.sfs.mySelf != null)
         {
            ExternalInterface.call("getFacebookIdInfo");
            trace("ASK FOR ID SELF:");
         }
         while(_loc3_ < NUM_CARDS)
         {
            _loc2_ = new FacebookCard(this.main,-1);
            this.cards.push(_loc2_);
            addChild(_loc2_);
            _loc2_.x = 88 * _loc3_;
            _loc3_++;
         }
         this.cards.sort(this.compare);
         _loc3_ = 0;
         while(_loc3_ < this.cards.length)
         {
            this.cards[_loc3_].update();
            this.cards[_loc3_].x += (this.scrollIndex * 88 + 88 * _loc3_ - this.cards[_loc3_].x) * 1;
            _loc3_++;
         }
      }
   }
}
