package com.liamr.ui.dropDown
{
   import com.liamr.ui.dropDown.Events.*;
   import flash.display.*;
   import flash.events.*;
   import gs.*;
   import gs.easing.*;
   
   public class DropDown extends DropDownMc
   {
      
      public static var ITEM_SELECTED:String = "itemSelected";
       
      
      public var dropDownArray:Array;
      
      private var listHolder:Sprite;
      
      private var listScroller:Sprite;
      
      private var masker:Sprite;
      
      private var listBg:Sprite;
      
      private var listHeight:Number;
      
      private var listOpen:Boolean = false;
      
      private var scrollable:Boolean;
      
      public var selectedId:int;
      
      public var selectedLabel:String;
      
      public var selectedData;
      
      public function DropDown(param1:Array, param2:String = "Please choose...", param3:Boolean = false, param4:Number = 100)
      {
         this.dropDownArray = [];
         super();
         this.dropDownArray = param1;
         this.listHeight = param4;
         this.scrollable = param3;
         selectedItem_txt.text = param2;
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(param1:Event) : void
      {
         hit.addEventListener(MouseEvent.CLICK,this.openClose);
         hit.buttonMode = true;
         stage.addEventListener(MouseEvent.CLICK,this.stageClose);
         this.buildList();
      }
      
      public function buildList() : void
      {
         var _loc2_:DropDownItem = null;
         this.listHolder = new Sprite();
         addChildAt(this.listHolder,0);
         this.listScroller = new Sprite();
         this.listHolder.addChildAt(this.listScroller,0);
         this.listHolder.y = 10;
         var _loc1_:int = 0;
         while(_loc1_ < this.dropDownArray.length)
         {
            _loc2_ = new DropDownItem();
            _loc2_._id = _loc1_;
            _loc2_.item_txt.text = this.dropDownArray[_loc1_];
            _loc2_.y = this.listScroller.height;
            _loc2_.mouseChildren = false;
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.itemOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            _loc2_.addEventListener(MouseEvent.CLICK,this.selectItem);
            this.listScroller.addChild(_loc2_);
            if(_loc1_ == 0)
            {
               this.selectItemWithTarget(_loc2_);
            }
            _loc1_++;
         }
         if(this.listScroller.height < this.listHeight)
         {
            this.listHeight = this.listScroller.height;
         }
         this.listBg = new Sprite();
         this.listBg.graphics.beginFill(0,0);
         this.listBg.graphics.drawRoundRect(0,-10,this.listScroller.width,this.listScroller.height + 10,11);
         this.listBg.graphics.endFill();
         this.listScroller.addChildAt(this.listBg,0);
         this.masker = new Sprite();
         this.masker.graphics.beginFill(0);
         this.masker.graphics.drawRoundRect(0,-10,this.listScroller.width,this.listHeight + 10,11);
         this.masker.graphics.endFill();
         this.listHolder.addChild(this.masker);
         this.masker.y = -int(this.listHeight - 10);
         this.listScroller.mask = this.masker;
         if(this.scrollable)
         {
            this.initScrolling();
         }
      }
      
      public function openClose(param1:Event = null) : void
      {
         if(this.listOpen)
         {
            this.close();
         }
         else
         {
            this.open();
         }
      }
      
      public function stageClose(param1:Event) : void
      {
         if(param1.target.name != "hit")
         {
            this.close();
         }
      }
      
      public function open(param1:Event = null) : void
      {
         this.listOpen = true;
         trace(Strong.easeOut,hit.height);
         TweenLite.to(this.masker,0.5,{
            "y":0,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listHolder,0.5,{
            "y":hit.height,
            "ease":Strong.easeOut
         });
      }
      
      public function close(param1:Event = null) : void
      {
         this.listOpen = false;
         TweenLite.to(this.masker,0.5,{
            "y":-int(this.listHeight - 10),
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listHolder,0.5,{
            "y":10,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.listScroller,0.1,{
            "y":0,
            "ease":Strong.easeOut
         });
      }
      
      private function itemOver(param1:Event) : void
      {
         TweenLite.to(param1.target,0.5,{
            "alpha":1,
            "ease":Strong.easeOut,
            "scaleX":1.3,
            "scaleY":1.3
         });
      }
      
      private function itemOut(param1:Event) : void
      {
         TweenLite.to(param1.target,0.5,{
            "alpha":1,
            "ease":Strong.easeOut,
            "scaleX":1,
            "scaleY":1
         });
      }
      
      private function selectItemWithTarget(param1:Object) : void
      {
         this.selectedId = param1._id;
         this.selectedLabel = param1.item_txt.text;
         this.selectedData = param1._data;
         selectedItem_txt.text = param1.item_txt.text;
         this.close();
         dispatchEvent(new DropDownEvent(ITEM_SELECTED,this.selectedId,this.selectedLabel,this.selectedData));
      }
      
      private function selectItem(param1:Event) : void
      {
         this.selectItemWithTarget(param1.target);
      }
      
      private function initScrolling() : void
      {
         this.addEventListener(MouseEvent.ROLL_OVER,this.startScroll);
         this.addEventListener(MouseEvent.ROLL_OUT,this.stopScroll);
         addEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function startScroll(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.listScroll);
      }
      
      private function listScroll(param1:Event) : void
      {
         var _loc2_:int = int(this.masker.height);
         if(this.listOpen)
         {
            if(this.listScroller.height > _loc2_)
            {
               this.listScroller.y += Math.cos(-this.masker.mouseY / _loc2_ * Math.PI) * 3;
               if(this.listScroller.y > 0)
               {
                  this.listScroller.y = 0;
               }
               if(-this.listScroller.y > this.listScroller.height - _loc2_)
               {
                  this.listScroller.y = -(this.listScroller.height - _loc2_);
               }
            }
            else
            {
               this.listScroller.y = 0;
            }
         }
      }
   }
}
