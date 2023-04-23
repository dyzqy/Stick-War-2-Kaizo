package com.brockw.stickwar.market
{
   import com.smartfoxserver.v2.entities.data.*;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.utils.*;
   
   public class Loadout
   {
       
      
      private var _data:Dictionary;
      
      public function Loadout()
      {
         super();
         this.data = new Dictionary();
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:* = "";
         for(_loc2_ in this.data)
         {
            _loc1_ += _loc2_ + ":";
            for(_loc3_ in this.data[_loc2_])
            {
               _loc1_ += _loc3_ + ";" + this.data[_loc2_][_loc3_] + "-";
            }
            _loc1_ += "|";
         }
         return _loc1_;
      }
      
      public function toSFSObject() : SFSObject
      {
         var _loc1_:SFSObject = new SFSObject();
         var _loc2_:String = this.toString();
         _loc1_.putUtfString("loadout",_loc2_);
         return _loc1_;
      }
      
      public function fromSFSObject(param1:SFSObject) : void
      {
         var _loc2_:String = param1.getUtfString("loadout");
         this.fromString(_loc2_);
      }
      
      public function fromString(param1:String) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:MovieClip = null;
         var _loc12_:Boolean = false;
         var _loc13_:FrameLabel = null;
         var _loc2_:String = param1;
         var _loc3_:Array = _loc2_.split("|");
         this._data = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] != "")
            {
               if((_loc5_ = _loc3_[_loc4_].split(":")).length != 0)
               {
                  _loc6_ = int(_loc5_[0]);
                  _loc8_ = (_loc7_ = _loc5_[1]).split("-");
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_.length)
                  {
                     if(_loc8_[_loc9_] != "")
                     {
                        if((_loc10_ = _loc8_[_loc9_].split(";")).length != 0)
                        {
                           _loc11_ = ItemMap.getWeaponMcFromId(int(_loc10_[0]),_loc6_);
                           _loc12_ = false;
                           for each(_loc13_ in _loc11_.currentLabels)
                           {
                              if(_loc13_.name == _loc10_[1])
                              {
                                 _loc12_ = true;
                              }
                           }
                           if(_loc12_)
                           {
                              this.setItem(_loc6_,int(_loc10_[0]),_loc10_[1]);
                           }
                           else
                           {
                              trace("DOES NOT HAVE LABEL");
                           }
                        }
                     }
                     _loc9_++;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function unitHasDefaultLoadout(param1:int) : Boolean
      {
         return this.getItem(param1,MarketItem.T_WEAPON) == "Default" && this.getItem(param1,MarketItem.T_ARMOR) == "Default" && this.getItem(param1,MarketItem.T_MISC) == "Default";
      }
      
      public function getItem(param1:int, param2:int) : String
      {
         if(!(param1 in this._data))
         {
            return "Default";
         }
         if(!(param2 in this._data[param1]))
         {
            return "Default";
         }
         return this._data[param1][param2];
      }
      
      public function setItem(param1:int, param2:int, param3:String) : void
      {
         if(!(param1 in this._data))
         {
            this._data[param1] = new Dictionary();
         }
         if(!(param2 in this._data[param1]))
         {
            this._data[param1][param2] = new Dictionary();
         }
         this._data[param1][param2] = param3;
      }
      
      public function get data() : Dictionary
      {
         return this._data;
      }
      
      public function set data(param1:Dictionary) : void
      {
         this._data = param1;
      }
   }
}
