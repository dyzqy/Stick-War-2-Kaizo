package com.brockw.stickwar.market
{
   import com.brockw.stickwar.Main;
   import com.smartfoxserver.v2.core.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   
   public class MarketItem extends MovieClip
   {
      
      public static const T_WEAPON:int = 0;
      
      public static const T_ARMOR:int = 1;
      
      public static const T_MISC:int = 2;
      
      private static const W_WIDTH:Number = 93.95;
      
      private static const W_HEIGHT:Number = 100;
       
      
      public var unit:String;
      
      public var type:int;
      
      public var price:int;
      
      public var description:String;
      
      public var mc:MovieClip;
      
      public var id:int;
      
      public var marketMc:marketBox;
      
      public var isOwned:Boolean;
      
      public var displayName:String;
      
      private var card:com.brockw.stickwar.market.ArmoryUnitCard;
      
      public function MarketItem(param1:SFSObject)
      {
         super();
         this.marketMc = new marketBox();
         this.readFromSFSObject(param1);
         this.isOwned = false;
         this.card = this.card;
         this.marketMc.unlockDisplay.unlockButton.addEventListener(MouseEvent.CLICK,this.unlock,false,0,true);
         this.marketMc.useDisplay.useButton.addEventListener(MouseEvent.CLICK,this.useButton,false,0,true);
         this.marketMc.editButton.addEventListener(MouseEvent.CLICK,this.editButton,false,0,true);
      }
      
      public function cleanUp() : void
      {
         this.marketMc.unlockDisplay.unlockButton.removeEventListener(MouseEvent.CLICK,this.unlock);
         this.marketMc.useDisplay.useButton.removeEventListener(MouseEvent.CLICK,this.useButton);
         this.marketMc.editButton.removeEventListener(MouseEvent.CLICK,this.editButton);
      }
      
      private function editButton(param1:Event) : void
      {
         this.card.main.armourScreen.openEditCard(this);
      }
      
      public function setCard(param1:com.brockw.stickwar.market.ArmoryUnitCard) : void
      {
         this.card = param1;
      }
      
      private function unlock(param1:Event) : void
      {
         if(!this.card.main.armourScreen.isUnlocking())
         {
            this.card.main.armourScreen.showUnlock(this.card.main.empirePoints,this.price,ItemMap.unitNameToType(this.unit),this.id,this.type,this.mc.currentFrameLabel);
         }
      }
      
      private function useButton(param1:Event) : void
      {
         if(!this.card.main.armourScreen.isUnlocking())
         {
            this.card.equip(ItemMap.unitNameToType(this.unit),this.type,name);
         }
      }
      
      public function update(param1:Main) : void
      {
         if(param1.armourScreen.isEditMode)
         {
            this.marketMc.editButton.visible = true;
         }
         else
         {
            this.marketMc.editButton.visible = false;
         }
         if(this.id == -1)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = false;
         }
         else if(param1.purchases.indexOf(this.id) == -1)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = true;
            this.marketMc.unlockDisplay.empiresPoints.text = "" + this.price;
         }
         else if(param1.loadout.getItem(ItemMap.unitNameToType(this.unit),this.type) == name)
         {
            this.marketMc.useDisplay.visible = false;
            this.marketMc.armedDisplay.visible = true;
            this.marketMc.unlockDisplay.visible = false;
         }
         else
         {
            this.marketMc.useDisplay.visible = true;
            this.marketMc.armedDisplay.visible = false;
            this.marketMc.unlockDisplay.visible = false;
         }
      }
      
      public function readFromSFSObject(param1:SFSObject) : void
      {
         var _loc3_:FrameLabel = null;
         this.id = param1.getInt("id");
         this.unit = param1.getUtfString("unit");
         trace(this.unit);
         name = param1.getUtfString("name");
         this.type = param1.getInt("type");
         this.description = param1.getUtfString("description");
         this.price = param1.getInt("price");
         this.displayName = param1.getUtfString("displayName");
         this.mc = ItemMap.getWeaponMcFromString(this.type,this.unit);
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.mc.currentLabels)
         {
            if(_loc3_.name == name)
            {
               _loc2_ = true;
            }
         }
         if(!_loc2_)
         {
            name = "Default";
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0.5;
         var _loc6_:Number = 14;
         var _loc7_:Number = 14;
         var _loc8_:Number = 1;
         var _loc9_:Number = Number(BitmapFilterQuality.LOW);
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:GlowFilter = new GlowFilter(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
         this.mc.filters = [_loc12_];
         this.marketMc.displayBox.addChild(this.mc);
         this.mc.gotoAndStop(name);
         var _loc13_:Number = 0.8;
         if(Math.abs(W_WIDTH / this.mc.width) < Math.abs(W_HEIGHT / this.mc.height))
         {
            _loc13_ = W_WIDTH / this.mc.width;
         }
         else
         {
            _loc13_ = W_HEIGHT / this.mc.height;
         }
         this.mc.scaleX = _loc13_;
         this.mc.scaleY = _loc13_;
         var _loc14_:Rectangle = this.mc.getBounds(this.marketMc);
         this.mc.x -= _loc14_.left;
         this.mc.y -= _loc14_.top;
         this.mc.x += (W_WIDTH - _loc14_.width) / 2;
         this.mc.y += (W_HEIGHT - _loc14_.height) / 2;
         addChild(this.marketMc);
      }
      
      override public function toString() : String
      {
         return String(name) + " for " + String(this.unit);
      }
   }
}
