package com.brockw.stickwar.market
{
   import com.brockw.game.*;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   
   public class NewArmoryScreen extends Screen
   {
      
      private static const W_WIDTH:Number = 93.95;
      
      private static const W_HEIGHT:Number = 100;
       
      
      private var _isEditMode:Boolean;
      
      internal var main:Main;
      
      private var _mc:new_armouryMc;
      
      public var empirePointsToShow:Number = 0;
      
      private var team:int;
      
      private var selectedUnit:com.brockw.stickwar.market.UnitButton = null;
      
      private var isMouseDown:Boolean = false;
      
      private var orderUnits:orderArmoryUnitsMc;
      
      private var chaosUnits:chaosArmoryUnitsMc;
      
      private var elementalUnits:elementalArmoryUnitsMc;
      
      private var currentUnits:MovieClip = null;
      
      private var unitButtons:Array;
      
      private var highlightFilter:GlowFilter;
      
      private var currentCard:com.brockw.stickwar.market.ArmoryUnitCard = null;
      
      public var currentItemType:int = 0;
      
      private var chromeGlow:GlowFilter;
      
      private var itemPreview:MovieClip;
      
      private var itemToBuyId:int;
      
      private var currentEditMarketItem:com.brockw.stickwar.market.MarketItem;
      
      private var backgroundMc:MovieClip = null;
      
      private var currentProfilePic:MovieClip = null;
      
      public function NewArmoryScreen(param1:Main)
      {
         this.unitButtons = [];
         super();
         this.main = param1;
         this._mc = new new_armouryMc();
         addChild(this._mc);
         this.team = Team.T_GOOD;
         this.mc.orderButton.buttonMode = true;
         this.mc.chaosButton.buttonMode = true;
         this.mc.elementalButton.buttonMode = true;
         this.mc.weaponButton.buttonMode = true;
         this.mc.armorButton.buttonMode = true;
         this.mc.miscButton.buttonMode = true;
         this.switchRace(Team.T_GOOD);
         var _loc2_:Number = 16777215;
         var _loc3_:Number = 1;
         var _loc4_:Number = 36;
         var _loc5_:Number = 18;
         var _loc6_:Number = 2.64;
         var _loc7_:Number = Number(BitmapFilterQuality.LOW);
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         this.highlightFilter = new GlowFilter(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         this.chromeGlow = new GlowFilter();
         this.chromeGlow.blurX = 5;
         this.chromeGlow.blurY = 5;
         this.chromeGlow.quality = BitmapFilterQuality.MEDIUM;
         this.chromeGlow.strength = 5;
         this.chromeGlow.color = 0;
         this.mc.cover.mouseEnabled = false;
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("paymentCompleteExt",this.paymentComplete);
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("subscriptionActivated",this.subscriptionActivated);
         }
      }
      
      public static function openPayment(param1:String, param2:Main) : void
      {
         if(param2.isOnFacebook)
         {
            openFacebookPayment(param1,param2);
         }
         else
         {
            openPaypalPayment(param1,param2);
         }
      }
      
      private static function openFacebookPayment(param1:String, param2:Main) : void
      {
         var _loc3_:uint = 0;
         if(ExternalInterface.available)
         {
            if(param1 == "membership")
            {
               _loc3_ = uint(ExternalInterface.call("startFacebookSubscription",param1));
            }
            else
            {
               _loc3_ = uint(ExternalInterface.call("startFacebookPaymentCurrencies","http://www.stickempires.com/facebookPayment/products/" + param1 + ".html"));
            }
         }
      }
      
      private static function openPaypalPayment(param1:String, param2:Main) : void
      {
         var _loc4_:URLRequest = null;
         var _loc5_:uint = 0;
         var _loc3_:String = "http://www.stickempires.com/paypal/checkout.php?item=" + param1 + "&userId=" + param2.sfs.mySelf.getVariable("dbid").getIntValue();
         if(param1 == "membership")
         {
            _loc4_ = new URLRequest(_loc3_);
            navigateToURL(_loc4_,"_blank");
         }
         else if(ExternalInterface.available)
         {
            _loc5_ = uint(ExternalInterface.call("dg.startFlow",_loc3_));
         }
      }
      
      public function paymentComplete(param1:*) : void
      {
         this.mc.paymentScreen.visible = false;
         this.mc.itemUnlockResult.visible = true;
         this.mc.itemUnlockResult.resultText.text = param1;
      }
      
      private function subscriptionActivated() : void
      {
         this.main.chatOverlay.addUserResponse("Success. Your membership will be activated within the next few minutes.",true);
         this.main.pendingMembership = true;
         this._mc.paymentScreen.membershipButton.alpha = 0.2;
         this._mc.paymentScreen.membership2YearsButton.alpha = 0.2;
         this._mc.paymentScreen.membership1YearsButton.alpha = 0.2;
         this._mc.paymentScreen.membershipButton.enabled = false;
         this._mc.paymentScreen.membership2YearsButton.enabled = false;
         this._mc.paymentScreen.membership1YearsButton.enabled = false;
         var _loc1_:SFSObject = new SFSObject();
         this.main.sfs.send(new ExtensionRequest("checkFacebookSubscription",_loc1_));
      }
      
      public function switchRace(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         this.mc.grassBackground.visible = false;
         this.mc.desertBackground.visible = false;
         this.mc.swampBackground.visible = false;
         if(param1 == Team.T_GOOD)
         {
            this.mc.grassBackground.visible = true;
         }
         else if(param1 == Team.T_CHAOS)
         {
            this.backgroundMc = new castleLevelMiddleground();
            this.mc.desertBackground.visible = true;
         }
         else
         {
            this.backgroundMc = new desertMiddleground();
            this.mc.swampBackground.visible = true;
         }
         this.orderUnits = null;
         this.chaosUnits = null;
         this.elementalUnits = null;
         if(this.currentUnits != null)
         {
            this._mc.unitContainer.removeChild(this.currentUnits);
            this.currentUnits = null;
         }
         if(param1 == Team.T_GOOD)
         {
            this.currentUnits = this.orderUnits = new orderArmoryUnitsMc();
            this._mc.unitContainer.addChild(this.orderUnits);
            this.orderUnits.flapadonMc.mc.body.arms.gotoAndStop(1);
            this.unitButtons = [new UnitButton(Unit.U_MINER,this.orderUnits.minerMc,-10,-20),new UnitButton(Unit.U_ARCHER,this.orderUnits.archerMc,-10,-10),new UnitButton(Unit.U_SPEARTON,this.orderUnits.speartonMc,-8,-30),new UnitButton(Unit.U_MAGIKILL,this.orderUnits.magikillMc,-10,-30),new UnitButton(Unit.U_MONK,this.orderUnits.clericMc,-25,-25),new UnitButton(Unit.U_SWORDWRATH,this.orderUnits.swordwrathMc,-20,-10),new UnitButton(Unit.U_ENSLAVED_GIANT,this.orderUnits.giantMc,-50,-80),new UnitButton(Unit.U_FLYING_CROSSBOWMAN,this.orderUnits.flapadonMc,-35,15),new UnitButton(Unit.U_NINJA,this.orderUnits.ninjaMc,-22,15)];
            this.selectedUnit = this.unitButtons[3];
         }
         else if(param1 == Team.T_CHAOS)
         {
            this.currentUnits = this.chaosUnits = new chaosArmoryUnitsMc();
            this._mc.unitContainer.addChild(this.chaosUnits);
            this.unitButtons = [new UnitButton(Unit.U_CHAOS_MINER,this.chaosUnits.minerMc,-13,-15),new UnitButton(Unit.U_DEAD,this.chaosUnits.deadMc,5,-8),new UnitButton(Unit.U_BOMBER,this.chaosUnits.bomberMc,-25,30),new UnitButton(Unit.U_WINGIDON,this.chaosUnits.winidonMc,-30,20),new UnitButton(Unit.U_SKELATOR,this.chaosUnits.skelatorMc,-18,-25),new UnitButton(Unit.U_MEDUSA,this.chaosUnits.medusaMc,-5,-35),new UnitButton(Unit.U_GIANT,this.chaosUnits.giantMc,-75,-80),new UnitButton(Unit.U_CAT,this.chaosUnits.catMc,-20,50),new UnitButton(Unit.U_KNIGHT,this.chaosUnits.knightMc,-5,-20)];
            _loc2_ = 0;
            while(_loc2_ < this.chaosUnits.medusaMc.mc.snakes.numChildren)
            {
               _loc3_ = this.chaosUnits.medusaMc.mc.snakes.getChildAt(_loc2_);
               if(_loc3_ is MovieClip)
               {
                  MovieClip(_loc3_).gotoAndStop(Math.floor(MovieClip(_loc3_).totalFrames * Math.random()));
               }
               _loc2_++;
            }
            this.selectedUnit = this.unitButtons[3];
         }
         else
         {
            this.currentUnits = this.elementalUnits = new elementalArmoryUnitsMc();
            this._mc.unitContainer.addChild(this.elementalUnits);
            this.unitButtons = [new UnitButton(Unit.U_MINER_ELEMENT,this.elementalUnits.minerMc,-15,20),new UnitButton(Unit.U_FIRE_ELEMENT,this.elementalUnits.fireMc,-15,-13 + 5),new UnitButton(Unit.U_WATER_ELEMENT,this.elementalUnits.waterMc,-11,-10 + 5),new UnitButton(Unit.U_EARTH_ELEMENT,this.elementalUnits.earthMc,-10,-15 + 5),new UnitButton(Unit.U_AIR_ELEMENT,this.elementalUnits.airMc,-5,8 + 5),new UnitButton(Unit.U_TREE_ELEMENT,this.elementalUnits.treeMc,-40,-85),new UnitButton(Unit.U_HURRICANE_ELEMENT,this.elementalUnits.hurricaneMc,-50,65),new UnitButton(Unit.U_SCORPION_ELEMENT,this.elementalUnits.scorpionMc,-18,55),new UnitButton(Unit.U_CHROME_ELEMENT,this.elementalUnits.chromeMc,-5,-35),new UnitButton(Unit.U_LAVA_ELEMENT,this.elementalUnits.lavaMc,-22,-20),new UnitButton(Unit.U_FIRESTORM_ELEMENT,this.elementalUnits.firestormMc,30,-25)];
            this.selectedUnit = this.unitButtons[3];
         }
      }
      
      public function get isEditMode() : Boolean
      {
         return this._isEditMode;
      }
      
      public function set isEditMode(param1:Boolean) : void
      {
         this._isEditMode = param1;
      }
      
      public function get mc() : new_armouryMc
      {
         return this._mc;
      }
      
      public function set mc(param1:new_armouryMc) : void
      {
         this._mc = param1;
      }
      
      public function update(param1:Event) : void
      {
         this._mc.empiresPoints.text = "" + Math.round(this.empirePointsToShow);
         this.empirePointsToShow += (this.main.empirePoints - this.empirePointsToShow) * 0.1;
         if(!this.isUnlocking())
         {
            this.updateRaceButtons();
            this.updateUnitButtons();
            this.updateWeaponButtons();
            this.isMouseDown = false;
            if(!(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership)) && this.team != Team.T_GOOD)
            {
               if(this.currentCard != null)
               {
                  this.currentCard.visible = false;
               }
               this.mc.unlockChaosScreen.visible = true;
            }
            else
            {
               this.currentCard.visible = true;
               this.mc.unlockChaosScreen.visible = false;
            }
            if(this.currentCard != null)
            {
               this.currentCard.update();
               this.currentCard.setUnitProfileNew(this.mc,this.selectedUnit.mc);
            }
            if(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership))
            {
               this.mc.membershipButton.visible = false;
            }
            else
            {
               this.mc.membershipButton.visible = true;
            }
         }
      }
      
      public function updateUnitButtons() : void
      {
         var _loc3_:com.brockw.stickwar.market.UnitButton = null;
         if(this.team == Team.T_GOOD)
         {
            this.orderUnits.minerMc.gotoAndStop("stand");
            this.orderUnits.swordwrathMc.gotoAndStop("stand_breath");
            this.orderUnits.archerMc.gotoAndStop("stand");
            this.orderUnits.speartonMc.gotoAndStop("stand");
            this.orderUnits.magikillMc.gotoAndStop("stand");
            this.orderUnits.clericMc.gotoAndStop("stand");
            this.orderUnits.giantMc.gotoAndStop("stand");
            this.orderUnits.flapadonMc.gotoAndStop("run");
            this.orderUnits.ninjaMc.gotoAndStop("stand");
            this.orderUnits.flapadonMc.mc.body.arms.gotoAndStop(1);
         }
         else if(this.team == Team.T_CHAOS)
         {
            this.chaosUnits.minerMc.gotoAndStop("stand");
            this.chaosUnits.deadMc.gotoAndStop("stand");
            this.chaosUnits.catMc.gotoAndStop("stand");
            this.chaosUnits.knightMc.gotoAndStop("stand");
            this.chaosUnits.giantMc.gotoAndStop("stand");
            this.chaosUnits.medusaMc.gotoAndStop("stand");
            this.chaosUnits.skelatorMc.gotoAndStop("stand");
            this.chaosUnits.bomberMc.gotoAndStop("stand");
            this.chaosUnits.winidonMc.gotoAndStop("run");
            this.chaosUnits.winidonMc.mc.body.arms.gotoAndStop(1);
         }
         else
         {
            this.elementalUnits.minerMc.gotoAndStop("stand");
            this.elementalUnits.fireMc.gotoAndStop("stand");
            this.elementalUnits.waterMc.gotoAndStop("stand");
            this.elementalUnits.earthMc.gotoAndStop("stand");
            this.elementalUnits.airMc.gotoAndStop("stand");
            this.elementalUnits.treeMc.gotoAndStop("stand");
            this.elementalUnits.hurricaneMc.gotoAndStop("stand");
            this.elementalUnits.scorpionMc.gotoAndStop("stand");
            this.elementalUnits.chromeMc.gotoAndStop("stand");
            this.elementalUnits.lavaMc.gotoAndStop("stand");
            this.elementalUnits.firestormMc.gotoAndStop("stand");
            this.elementalUnits.fireMc.mc.arms.gotoAndStop(1);
            this.elementalUnits.treeMc.mc.treedirt.gotoAndStop(1);
         }
         var _loc1_:com.brockw.stickwar.market.UnitButton = this.unitButtons[0];
         var _loc2_:com.brockw.stickwar.market.UnitButton = null;
         for each(_loc3_ in this.unitButtons)
         {
            if(this.mouseDistanceSqrToMc(_loc3_.mc) < this.mouseDistanceSqrToMc(_loc1_.mc) && _loc3_.mc.hitTestPoint(stage.mouseX,stage.mouseY,false))
            {
               _loc1_ = _loc3_;
            }
            if(_loc3_.mc.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               _loc2_ = _loc3_;
            }
            _loc3_.mc.filters = [];
            if(_loc3_.id == Unit.U_CHROME_ELEMENT)
            {
               _loc3_.mc.filters = [this.chromeGlow];
            }
            if(_loc3_ != this.selectedUnit)
            {
               this.setUnitProfileGeneric(this.mc,_loc3_.mc,_loc3_.id);
            }
         }
         if(_loc2_)
         {
            _loc1_ = _loc2_;
         }
         if(_loc1_.mc.hitTestPoint(stage.mouseX,stage.mouseY,false))
         {
            if(this.isMouseDown)
            {
               this.selectedUnit = _loc1_;
               this.updateUnitCard();
               this.main.soundManager.playSoundFullVolume("clickButton");
            }
         }
         this.selectedUnit.mc.filters = [this.highlightFilter];
         if(this.selectedUnit.id == Unit.U_CHROME_ELEMENT)
         {
            this.selectedUnit.mc.filters = [this.chromeGlow,this.highlightFilter];
         }
         this.mc.star.x += (this.selectedUnit.mc.x + this.selectedUnit.xOffset - this.mc.star.x) * 0.2;
         this.mc.star.y += (this.selectedUnit.mc.y + this.selectedUnit.yOffset - this.mc.star.y) * 0.2;
      }
      
      public function saveLoadout() : void
      {
         var _loc1_:SFSObject = this.main.loadout.toSFSObject();
         this.main.sfs.send(new ExtensionRequest("saveLoadout",_loc1_));
      }
      
      public function setUnitProfileGeneric(param1:MovieClip, param2:MovieClip, param3:int) : void
      {
         Util.animateMovieClip(param2,0);
         var _loc4_:String = String(this.main.loadout.getItem(param3,MarketItem.T_WEAPON));
         var _loc5_:String = String(this.main.loadout.getItem(param3,MarketItem.T_ARMOR));
         var _loc6_:String = String(this.main.loadout.getItem(param3,MarketItem.T_MISC));
         ItemMap.setItemsForUnitType(param3,param2,_loc4_,_loc5_,_loc6_);
         if(param3 == Unit.U_MINER_ELEMENT)
         {
            param2.mc.crabgold.gotoAndStop(100);
         }
         if(param3 == Unit.U_ARCHER)
         {
            param2.mc.bow.gotoAndStop(1);
         }
      }
      
      private function mouseDistanceSqrToMc(param1:MovieClip) : Number
      {
         return Math.pow(param1.x - stage.mouseX,2) + Math.pow(param1.y - stage.mouseY,2);
      }
      
      public function updateWeaponButtons() : void
      {
         this.mc.weaponButton.gotoAndStop(1);
         this.mc.armorButton.gotoAndStop(1);
         this.mc.miscButton.gotoAndStop(1);
         if(this.currentItemType == MarketItem.T_WEAPON)
         {
            this.mc.weaponButton.gotoAndStop(3);
         }
         else if(this.currentItemType == MarketItem.T_ARMOR)
         {
            this.mc.armorButton.gotoAndStop(3);
         }
         else
         {
            this.mc.miscButton.gotoAndStop(3);
         }
         if(this.mc.weaponButton.hitTestPoint(stage.mouseX,stage.mouseY,true) && this.mc.weaponButton.buttonMode)
         {
            if(this.isMouseDown)
            {
               this.currentItemType = MarketItem.T_WEAPON;
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
         else if(this.mc.armorButton.hitTestPoint(stage.mouseX,stage.mouseY,true) && this.mc.armorButton.buttonMode)
         {
            if(this.isMouseDown)
            {
               this.currentItemType = MarketItem.T_ARMOR;
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
         else if(this.mc.miscButton.hitTestPoint(stage.mouseX,stage.mouseY,true) && this.mc.miscButton.buttonMode)
         {
            if(this.isMouseDown)
            {
               this.currentItemType = MarketItem.T_MISC;
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
      }
      
      public function updateRaceButtons() : void
      {
         this.mc.orderButton.gotoAndStop(1);
         this.mc.chaosButton.gotoAndStop(1);
         this.mc.elementalButton.gotoAndStop(1);
         if(this.mc.orderButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.orderButton.gotoAndStop(4);
            if(this.isMouseDown)
            {
               this.team = Team.T_GOOD;
               this.switchRace(this.team);
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
         else if(this.mc.chaosButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.chaosButton.gotoAndStop(4);
            if(this.isMouseDown)
            {
               this.team = Team.T_CHAOS;
               this.switchRace(this.team);
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
         else if(this.mc.elementalButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            this.mc.elementalButton.gotoAndStop(4);
            if(this.isMouseDown)
            {
               this.team = Team.T_ELEMENTAL;
               this.switchRace(this.team);
               this.main.soundManager.playSoundFullVolume("clickButton");
               this.updateUnitCard();
            }
         }
         if(this.team == Team.T_GOOD)
         {
            this.mc.orderButton.gotoAndStop(3);
         }
         else if(this.team == Team.T_CHAOS)
         {
            this.mc.chaosButton.gotoAndStop(3);
         }
         else
         {
            this.mc.elementalButton.gotoAndStop(3);
         }
      }
      
      private function mouseDown(param1:Event) : void
      {
         this.isMouseDown = true;
      }
      
      override public function enter() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.update);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mc.leftArrow.addEventListener(MouseEvent.CLICK,this.leftArrowClick,false,0,true);
         this.mc.rightArrow.addEventListener(MouseEvent.CLICK,this.rightArrowClick,false,0,true);
         this.updateUnitCard();
         this.mc.unlockMc.visible = false;
         this.mc.earnCoinsScreen.visible = false;
         this.mc.itemUnlockResult.visible = false;
         this.mc.editCard.visible = false;
         this.mc.paymentScreen.visible = false;
         this.mc.editFeatureCard.visible = false;
         this.mc.unlockMc.closeButton.addEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.addEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.addEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.addEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.addPointsButton.addEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.addPointsButton.buttonMode = true;
         this.mc.addPointsButton.mouseChildren = false;
         this.mc.membershipButton.addEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.membershipButton.buttonMode = true;
         this.mc.membershipButton.mouseChildren = false;
         this.mc.unlockChaosScreen.addEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.unlockChaosScreen.buttonMode = true;
         this.mc.paymentScreen.closeButton.addEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.unlockChaosScreen.visible = false;
      }
      
      override public function leave() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mc.leftArrow.removeEventListener(MouseEvent.CLICK,this.leftArrowClick);
         this.mc.rightArrow.removeEventListener(MouseEvent.CLICK,this.rightArrowClick);
         this.mc.unlockMc.closeButton.removeEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.removeEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.removeEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.removeEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.removeEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.addPointsButton.removeEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.membershipButton.removeEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.paymentScreen.closeButton.removeEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.unlockChaosScreen.removeEventListener(MouseEvent.CLICK,this.openPaymentScreen);
      }
      
      private function leftArrowClick(param1:Event) : void
      {
         if(this.currentCard)
         {
            this.currentCard.leftArrowClick(param1);
         }
      }
      
      private function rightArrowClick(param1:Event) : void
      {
         if(this.currentCard)
         {
            this.currentCard.rightArrowClick(param1);
         }
      }
      
      public function receiveEmpirePoints(param1:int, param2:Boolean, param3:Boolean) : void
      {
         trace("received empiresPoints",param2,param3);
         this.main.empirePoints = param1;
         this.main.isMember = param2;
         if(param3)
         {
            this.mc.paymentScreen.visible = false;
            this.main.soundManager.playSoundFullVolume("newEmpirePoints");
         }
         else
         {
            this.empirePointsToShow = this.main.empirePoints;
         }
      }
      
      public function updateUnitCard() : *
      {
         if(this.currentCard != null)
         {
            this.mc.cardContainer.removeChild(this.currentCard);
         }
         this.currentCard = this.createCard(this.selectedUnit.id);
         this.mc.cardContainer.addChild(this.currentCard);
         var _loc1_:* = this.main.itemMap.getItems(this.selectedUnit.id,MarketItem.T_WEAPON);
         var _loc2_:* = this.main.itemMap.getItems(this.selectedUnit.id,MarketItem.T_ARMOR);
         var _loc3_:* = this.main.itemMap.getItems(this.selectedUnit.id,MarketItem.T_MISC);
         if(this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.isEditMode)
         {
            _loc1_ = _loc2_ = _loc3_ = 1;
         }
         if(this.currentCard.dontShowMisc())
         {
            _loc3_ = 0;
         }
         if(!(this.main.sfs.mySelf.getVariable("isAdmin").getIntValue() == 1 && this.isEditMode))
         {
            if(this.main.itemMap.getItems(this.selectedUnit.id,this.currentItemType) == 0)
            {
               this.currentItemType = MarketItem.T_WEAPON;
               if(_loc1_ == 0 && _loc2_ == 0)
               {
                  this.currentItemType = MarketItem.T_MISC;
               }
               else if(_loc1_ == 0)
               {
                  this.currentItemType = MarketItem.T_ARMOR;
               }
            }
         }
         if(_loc1_ == 0)
         {
            this.mc.weaponButton.buttonMode = false;
            this.mc.weaponButton.alpha = 0;
         }
         else
         {
            this.mc.weaponButton.buttonMode = true;
            this.mc.weaponButton.alpha = 1;
         }
         if(_loc2_ == 0)
         {
            this.mc.armorButton.alpha = 0;
            this.mc.armorButton.buttonMode = false;
         }
         else
         {
            this.mc.armorButton.alpha = 1;
            this.mc.armorButton.buttonMode = true;
         }
         if(_loc3_ == 0)
         {
            this.mc.miscButton.alpha = 0;
            this.mc.miscButton.buttonMode = false;
         }
         else
         {
            this.mc.miscButton.alpha = 1;
            this.mc.miscButton.buttonMode = true;
         }
         this.currentCard.currentItemType = this.currentItemType;
         this.currentCard.viewingIndex = 0;
         this.currentCard.x = 0;
         this.currentCard.y = 0;
         if(this.currentProfilePic != null)
         {
            this.mc.profileContainer.removeChild(this.currentProfilePic);
         }
         this.mc.profileContainer.addChild(this.currentCard.profileMc);
         this.currentProfilePic = this.currentCard.profileMc;
         this.currentProfilePic.x = this.currentProfilePic.width / 2;
         this.currentProfilePic.y = this.currentProfilePic.height / 2;
         this.currentProfilePic.gotoAndStop(2);
         var _loc4_:XMLList = ItemMap.unitTypeToXML(this.selectedUnit.id,this.main);
         this.mc.unitName.text = _loc4_.name;
         this.mc.unitRole.text = "Role: " + _loc4_.role;
         this.mc.unitSaying.text = "\"" + _loc4_.saying + "\"";
      }
      
      private function createCard(param1:int) : com.brockw.stickwar.market.ArmoryUnitCard
      {
         var _loc2_:com.brockw.stickwar.market.ArmoryUnitCard = null;
         if(param1 == Unit.U_SWORDWRATH)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_SWORDWRATH,Swordwrath,new Armory_Swordwrath());
         }
         else if(param1 == Unit.U_ARCHER)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_ARCHER,Archer,new Armory_Archidon());
         }
         else if(param1 == Unit.U_SPEARTON)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_SPEARTON,Spearton,new Armory_Speartan());
         }
         else if(param1 == Unit.U_MINER)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_MINER,Miner,new Armory_Miner());
         }
         else if(param1 == Unit.U_NINJA)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_NINJA,Ninja,new Armory_Ninja());
         }
         else if(param1 == Unit.U_FLYING_CROSSBOWMAN)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_FLYING_CROSSBOWMAN,FlyingCrossbowman,new Armory_Flyer());
         }
         else if(param1 == Unit.U_ENSLAVED_GIANT)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_ENSLAVED_GIANT,EnslavedGiant,new Armory_Slave_Giant());
         }
         else if(param1 == Unit.U_MAGIKILL)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_MAGIKILL,Magikill,new Armory_Wizard());
         }
         else if(param1 == Unit.U_MONK)
         {
            _loc2_ = this.initUnitCard(Team.T_GOOD,Unit.U_MONK,Monk,new Armory_Priest());
         }
         else if(param1 == Unit.U_CAT)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_CAT,Cat,new Armory_Cat());
         }
         else if(param1 == Unit.U_BOMBER)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_BOMBER,Bomber,new Armory_Suicide());
         }
         else if(param1 == Unit.U_DEAD)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_DEAD,Dead,new Armory_Deads());
         }
         else if(param1 == Unit.U_CHAOS_MINER)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_CHAOS_MINER,MinerChaos,new Armory_Slave_Miner());
         }
         else if(param1 == Unit.U_KNIGHT)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_KNIGHT,Knight,new Armory_Knight());
         }
         else if(param1 == Unit.U_WINGIDON)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_WINGIDON,Wingidon,new Armory_Wingadon());
         }
         else if(param1 == Unit.U_GIANT)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_GIANT,Giant,new Armory_Giant());
         }
         else if(param1 == Unit.U_MEDUSA)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_MEDUSA,Medusa,new Armory_Medusa());
         }
         else if(param1 == Unit.U_SKELATOR)
         {
            _loc2_ = this.initUnitCard(Team.T_CHAOS,Unit.U_SKELATOR,Skelator,new Armory_Mage());
         }
         else if(param1 == Unit.U_FIRE_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_FIRE_ELEMENT,FireElement,new Armory_Fire());
         }
         else if(param1 == Unit.U_EARTH_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_EARTH_ELEMENT,EarthElement,new Armory_Earth());
         }
         else if(param1 == Unit.U_WATER_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_WATER_ELEMENT,WaterElement,new Armory_Water());
         }
         else if(param1 == Unit.U_AIR_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_AIR_ELEMENT,AirElement,new Armory_Wind());
         }
         else if(param1 == Unit.U_HURRICANE_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_HURRICANE_ELEMENT,HurricaneElement,new Armory_Hurricane());
         }
         else if(param1 == Unit.U_CHROME_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_CHROME_ELEMENT,ChromeElement,new Armory_Chrome());
         }
         else if(param1 == Unit.U_SCORPION_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_SCORPION_ELEMENT,ScorpionElement,new Armory_Scorpion());
         }
         else if(param1 == Unit.U_LAVA_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_LAVA_ELEMENT,LavaElement,new Armory_Lava());
         }
         else if(param1 == Unit.U_MINER_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_MINER_ELEMENT,ElementalMiner,new Armory_Miner());
         }
         else if(param1 == Unit.U_TREE_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_TREE_ELEMENT,TreeElement,new Armory_Tree());
         }
         else if(param1 == Unit.U_FIRESTORM_ELEMENT)
         {
            _loc2_ = this.initUnitCard(Team.T_ELEMENTAL,Unit.U_FIRESTORM_ELEMENT,FirestormElement,new Armory_Flames());
         }
         return _loc2_;
      }
      
      public function isUnlocking() : Boolean
      {
         return this.mc.earnCoinsScreen.visible == true || this.mc.editFeatureCard.visible == true || this.mc.unlockMc.visible == true || this.mc.itemUnlockResult.visible == true || this.mc.editCard.visible == true || this.mc.paymentScreen.visible == true;
      }
      
      private function initUnitCard(param1:int, param2:int, param3:Class, param4:MovieClip) : com.brockw.stickwar.market.ArmoryUnitCard
      {
         return new ArmoryUnitCard(this.main,param1,param2,ItemMap.getUnitMcFromType(param2),param3,param4);
      }
      
      public function showUnlock(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String) : void
      {
         this.mc.unlockMc.visible = true;
         this.mc.unlockMc.current.text = "" + param1;
         this.mc.unlockMc.cost.text = "" + param2;
         this.mc.unlockMc.empiresPoints.text = "" + param2;
         this.mc.unlockMc.balance.text = "" + (param1 - param2);
         if(this.itemPreview != null)
         {
            this.mc.unlockMc.removeChild(this.itemPreview);
         }
         this.itemPreview = ItemMap.getWeaponMcFromId(param5,param3);
         this.itemPreview.gotoAndStop(param6);
         this.mc.unlockMc.addChild(this.itemPreview);
         var _loc7_:Number = 0.8;
         if(Math.abs(W_WIDTH / this.itemPreview.width) < Math.abs(W_HEIGHT / this.itemPreview.height))
         {
            _loc7_ = W_WIDTH / this.itemPreview.width;
         }
         else
         {
            _loc7_ = W_HEIGHT / this.itemPreview.height;
         }
         this.itemPreview.scaleX = _loc7_;
         this.itemPreview.scaleY = _loc7_;
         var _loc8_:Rectangle = this.itemPreview.getBounds(this.mc.unlockMc);
         this.itemPreview.x += this.mc.unlockMc.displayBox.x - _loc8_.left;
         this.itemPreview.y += this.mc.unlockMc.displayBox.y - _loc8_.top;
         this.itemPreview.x += (this.mc.unlockMc.displayBox.width - this.itemPreview.width) / 2;
         this.itemPreview.y += (this.mc.unlockMc.displayBox.height - this.itemPreview.height) / 2;
         this.itemToBuyId = param4;
         var _loc9_:MovieClip = this.mc.unlockMc;
         this.mc.removeChild(_loc9_);
         this.mc.addChild(_loc9_);
      }
      
      private function closeUnlock(param1:Event) : void
      {
         this.mc.unlockMc.visible = false;
      }
      
      private function unlockButton(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("itemId",this.itemToBuyId);
         this.main.sfs.send(new ExtensionRequest("buy",_loc2_));
         this.mc.unlockMc.visible = false;
      }
      
      public function buyResponse(param1:int) : void
      {
         this.mc.itemUnlockResult.visible = true;
         if(param1 == 1)
         {
            this.mc.itemUnlockResult.resultText.text = "Item Unlocked!";
            this.mc.itemUnlockResult.description.text = "";
         }
         else
         {
            this.mc.itemUnlockResult.resultText.text = "Item Unlock Failed";
            this.mc.itemUnlockResult.description.text = "Not enough Empire Coins to purchase item!";
         }
         this.mc.removeChild(this.mc.itemUnlockResult);
         this.mc.addChild(this.mc.itemUnlockResult);
      }
      
      public function openEditCard(param1:com.brockw.stickwar.market.MarketItem) : void
      {
         this.mc.editCard.visible = true;
         this.mc.editCard.nameText.text = param1.name;
         this.mc.editCard.id.text = "" + param1.id;
         this.mc.editCard.unitType.text = param1.unit;
         this.mc.editCard.description.text = param1.description;
         this.mc.editCard.price.text = "" + param1.price;
         this.mc.editCard.displayName.text = "" + param1.displayName;
         this.mc.editCard.displayName.text = "" + param1.displayName;
         if(param1.type == MarketItem.T_ARMOR)
         {
            this.mc.editCard.itemType.text = "Armour";
         }
         else if(param1.type == MarketItem.T_WEAPON)
         {
            this.mc.editCard.itemType.text = "Weapon";
         }
         else if(param1.type == MarketItem.T_MISC)
         {
            this.mc.editCard.itemType.text = "Misc";
         }
         this.mc.removeChild(this.mc.editCard);
         this.mc.addChild(this.mc.editCard);
         this.currentEditMarketItem = param1;
      }
      
      private function closeItemResult(param1:MouseEvent) : void
      {
         this.mc.itemUnlockResult.visible = false;
      }
      
      private function closeEditCard(param1:Event) : void
      {
         this.mc.editCard.visible = false;
      }
      
      private function updateEditCard(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putUtfString("name",this.currentEditMarketItem.name);
         _loc2_.putInt("id",this.currentEditMarketItem.id);
         _loc2_.putUtfString("unit",this.currentEditMarketItem.unit);
         _loc2_.putUtfString("description",this.mc.editCard.description.text);
         _loc2_.putInt("price",int(this.mc.editCard.price.text));
         _loc2_.putInt("type",this.currentEditMarketItem.type);
         _loc2_.putUtfString("displayName",this.mc.editCard.displayName.text);
         this.main.sfs.send(new ExtensionRequest("setMarketItem",_loc2_));
         this.mc.editCard.visible = false;
      }
      
      public function openPaymentScreen(param1:Event) : void
      {
         this.mc.paymentScreen.visible = true;
         this.mc.paymentScreen.paymentButton1.addEventListener(MouseEvent.CLICK,this.paymentButton1);
         this.mc.paymentScreen.paymentButton2.addEventListener(MouseEvent.CLICK,this.paymentButton2);
         this.mc.paymentScreen.paymentButton3.addEventListener(MouseEvent.CLICK,this.paymentButton3);
         this.mc.paymentScreen.paymentButton4.addEventListener(MouseEvent.CLICK,this.paymentButton4);
         this.mc.paymentScreen.membership1YearsButton.addEventListener(MouseEvent.CLICK,this.membership1YearsButton);
         this.mc.paymentScreen.membership2YearsButton.addEventListener(MouseEvent.CLICK,this.membership2YearsButton);
         this.mc.paymentScreen.membershipButton.addEventListener(MouseEvent.CLICK,this.membershipButton);
      }
      
      public function membershipButton(param1:Event) : void
      {
         if(!(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership)))
         {
            openPayment("membership",this.main);
         }
      }
      
      private function paymentButton1(param1:Event) : void
      {
         openPayment("ep1",this.main);
      }
      
      private function paymentButton2(param1:Event) : void
      {
         openPayment("ep2",this.main);
      }
      
      private function paymentButton3(param1:Event) : void
      {
         openPayment("ep3",this.main);
      }
      
      private function paymentButton4(param1:Event) : void
      {
         openPayment("ep4",this.main);
      }
      
      private function membership2YearsButton(param1:Event) : void
      {
         if(!(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership)))
         {
            openPayment("twoYear",this.main);
         }
      }
      
      private function membership1YearsButton(param1:Event) : void
      {
         if(!(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership)))
         {
            openPayment("oneYear",this.main);
         }
      }
      
      private function closePaymentScreen(param1:Event) : void
      {
         this.mc.paymentScreen.visible = false;
         this.mc.paymentScreen.paymentButton1.removeEventListener(MouseEvent.CLICK,this.paymentButton1);
         this.mc.paymentScreen.paymentButton2.removeEventListener(MouseEvent.CLICK,this.paymentButton2);
         this.mc.paymentScreen.paymentButton3.removeEventListener(MouseEvent.CLICK,this.paymentButton3);
         this.mc.paymentScreen.paymentButton4.removeEventListener(MouseEvent.CLICK,this.paymentButton4);
         this.mc.paymentScreen.membershipButton.removeEventListener(MouseEvent.CLICK,this.membershipButton);
         this.mc.paymentScreen.membership2YearsButton.removeEventListener(MouseEvent.CLICK,this.membership2YearsButton);
         this.mc.paymentScreen.membership1YearsButton.removeEventListener(MouseEvent.CLICK,this.membership1YearsButton);
      }
   }
}
