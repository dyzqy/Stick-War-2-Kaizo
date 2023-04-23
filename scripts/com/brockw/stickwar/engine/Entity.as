package com.brockw.stickwar.engine
{
   import com.brockw.ds.Comparable;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   import flash.filters.*;
   
   public class Entity extends Sprite implements Comparable
   {
       
      
      public var px:Number;
      
      public var pz:Number;
      
      public var py:Number;
      
      private var _pheight:Number;
      
      private var _pwidth:Number;
      
      protected var _type:int;
      
      protected var _isArmoured:Boolean;
      
      protected var _damageToArmour:Number;
      
      protected var _damageToNotArmour:Number;
      
      protected var selectedFilter:GlowFilter;
      
      protected var nonSelectedFilter:GlowFilter;
      
      protected var _mouseIsOver;
      
      private var _selected:Boolean;
      
      protected var _isGarrisoned:Boolean;
      
      private var _id:int;
      
      public function Entity()
      {
         super();
         this.selected = this.mouseIsOver = false;
         this.selectedFilter = new GlowFilter();
         this.selectedFilter.color = 39168;
         this.selectedFilter.blurX = 3;
         this.selectedFilter.blurY = 3;
         this.nonSelectedFilter = new GlowFilter();
         this.nonSelectedFilter.color = 16777215;
         this.nonSelectedFilter.blurX = 3;
         this.nonSelectedFilter.blurY = 3;
      }
      
      public function get isGarrisoned() : Boolean
      {
         return this._isGarrisoned;
      }
      
      public function set isGarrisoned(param1:Boolean) : void
      {
         this._isGarrisoned = param1;
      }
      
      public function getDamageToUnit(param1:Unit) : int
      {
         return param1.isArmoured ? int(this.damageToArmour) : int(this.damageToNotArmour);
      }
      
      public function drawOnHud(param1:MovieClip, param2:StickWar) : void
      {
         var _loc3_:Number = param1.width * this.px / param2.map.width;
         var _loc4_:Number = param1.height * this.py / param2.map.height;
         if(this.selected)
         {
            MovieClip(param1).graphics.lineStyle(2,65280,1);
         }
         else
         {
            MovieClip(param1).graphics.lineStyle(2,0,1);
         }
         MovieClip(param1).graphics.drawRect(_loc3_,_loc4_,1,1);
      }
      
      public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
      {
      }
      
      public function cleanUp() : void
      {
      }
      
      public function onMap(param1:StickWar) : Boolean
      {
         return true;
      }
      
      public function onScreen(param1:StickWar) : Boolean
      {
         return this.px + width / 2 - param1.screenX > 0 && this.px - width / 2 - param1.screenX < param1.map.screenWidth;
      }
      
      public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
      }
      
      public function compare(param1:Object) : int
      {
         return this.py - param1.py;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get pwidth() : Number
      {
         return this._pwidth;
      }
      
      public function set pwidth(param1:Number) : void
      {
         this._pwidth = param1;
      }
      
      public function get pheight() : Number
      {
         return this._pheight;
      }
      
      public function set pheight(param1:Number) : void
      {
         this._pheight = param1;
      }
      
      public function get isArmoured() : Boolean
      {
         return this._isArmoured;
      }
      
      public function set isArmoured(param1:Boolean) : void
      {
         this._isArmoured = param1;
      }
      
      public function get damageToArmour() : Number
      {
         return this._damageToArmour;
      }
      
      public function set damageToArmour(param1:Number) : void
      {
         this._damageToArmour = param1;
      }
      
      public function get damageToNotArmour() : Number
      {
         return this._damageToNotArmour;
      }
      
      public function set damageToNotArmour(param1:Number) : void
      {
         this._damageToNotArmour = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function get mouseIsOver() : *
      {
         return this._mouseIsOver;
      }
      
      public function set mouseIsOver(param1:*) : void
      {
         this._mouseIsOver = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
   }
}
