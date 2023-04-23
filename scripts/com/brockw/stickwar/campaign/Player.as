package com.brockw.stickwar.campaign
{
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.market.*;
   import flash.utils.*;
   
   public class Player
   {
       
      
      private var _unitsAvailable:Dictionary;
      
      private var _statue:String;
      
      private var _race:String;
      
      private var _statueHealth:int;
      
      private var _startingUnits:Array;
      
      private var _castleArcherLevel:int;
      
      private var _gold:int;
      
      private var _mana:int;
      
      private var _raceName:String;
      
      public function Player(param1:XMLList)
      {
         var _loc2_:* = undefined;
         super();
         this.unitsAvailable = new Dictionary();
         this.race = param1.attribute("race");
         this._statueHealth = param1.attribute("statueHealth");
         this._startingUnits = [];
         for each(_loc2_ in param1.startingUnit)
         {
            this._startingUnits.push(ItemMap.unitNameToType(_loc2_));
         }
         for each(_loc2_ in param1.unit)
         {
            this.unitsAvailable[ItemMap.unitNameToType(_loc2_)] = 1;
         }
         this._castleArcherLevel = 0;
         for each(_loc2_ in param1.castleArcher)
         {
            this._castleArcherLevel = _loc2_;
         }
         if(this.race == "Chaos")
         {
            this.unitsAvailable[Unit.U_CHAOS_MINER] = 1;
         }
         if(this.race == "Order")
         {
            this.unitsAvailable[Unit.U_MINER] = 1;
         }
         this.statue = "default";
         this.statue = param1.statue;
         if(this.statue == "")
         {
            this.statue = "default";
         }
         this._mana = 0;
         this._gold = 500;
         for each(_loc2_ in param1.mana)
         {
            this._mana = _loc2_;
         }
         for each(_loc2_ in param1.gold)
         {
            this._gold = _loc2_;
         }
         this.raceName = "Order";
         for each(_loc2_ in param1.raceName)
         {
            this.raceName = _loc2_;
         }
      }
      
      public function toString() : String
      {
         return this.race;
      }
      
      public function get race() : String
      {
         return this._race;
      }
      
      public function set race(param1:String) : void
      {
         this._race = param1;
      }
      
      public function get statueHealth() : int
      {
         return this._statueHealth;
      }
      
      public function set statueHealth(param1:int) : void
      {
         this._statueHealth = param1;
      }
      
      public function get unitsAvailable() : Dictionary
      {
         return this._unitsAvailable;
      }
      
      public function set unitsAvailable(param1:Dictionary) : void
      {
         this._unitsAvailable = param1;
      }
      
      public function get startingUnits() : Array
      {
         return this._startingUnits;
      }
      
      public function set startingUnits(param1:Array) : void
      {
         this._startingUnits = param1;
      }
      
      public function get castleArcherLevel() : int
      {
         return this._castleArcherLevel;
      }
      
      public function set castleArcherLevel(param1:int) : void
      {
         this._castleArcherLevel = param1;
      }
      
      public function get statue() : String
      {
         return this._statue;
      }
      
      public function set statue(param1:String) : void
      {
         this._statue = param1;
      }
      
      public function get mana() : int
      {
         return this._mana;
      }
      
      public function set mana(param1:int) : void
      {
         this._mana = param1;
      }
      
      public function get gold() : int
      {
         return this._gold;
      }
      
      public function set gold(param1:int) : void
      {
         this._gold = param1;
      }
      
      public function get raceName() : String
      {
         return this._raceName;
      }
      
      public function set raceName(param1:String) : void
      {
         this._raceName = param1;
      }
   }
}
