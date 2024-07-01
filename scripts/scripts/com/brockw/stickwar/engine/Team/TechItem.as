package com.brockw.stickwar.engine.Team
{
      import flash.display.*;
      
      public class TechItem
      {
             
            
            public var researchTime:int;
            
            public var cost:int;
            
            public var mc:Bitmap;
            
            public var replayMc:Bitmap;
            
            public var f:Function;
            
            public var hotKey:int;
            
            public var tip:String;
            
            public var mana:int;
            
            public var xmlInfo:XMLList;
            
            public var name:String;
            
            public var cancelMc:cancelButton;
            
            public function TechItem(param1:XMLList, param2:Bitmap)
            {
                  super();
                  this.xmlInfo = param1;
                  this.mana = this.xmlInfo.mana;
                  this.researchTime = this.xmlInfo.time;
                  this.cost = this.xmlInfo.cost;
                  this.mc = param2;
                  this.replayMc = new Bitmap(param2.bitmapData);
                  this.f = this.f;
                  this.hotKey = this.xmlInfo.hotKey;
                  this.tip = this.xmlInfo.tip;
                  this.name = this.xmlInfo.name;
                  this.cancelMc = new cancelButton();
            }
            
            public function upgrade() : void
            {
                  this.f();
            }
      }
}
