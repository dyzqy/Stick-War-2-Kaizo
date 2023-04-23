package com.brockw.stickwar.market
{
   import com.brockw.game.Screen;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import com.brockw.stickwar.engine.units.elementals.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.text.*;
   
   public class ArmoryScreen extends Screen
   {
      
      private static const W_WIDTH:Number = 93.95;
      
      private static const W_HEIGHT:Number = 100;
       
      
      internal var main:Main;
      
      private var _mc:armoryScreenMc;
      
      private var currentCard:com.brockw.stickwar.market.ArmoryUnitCard;
      
      private var team:int;
      
      private var unitCards:Array;
      
      private var isMouseDown:Boolean;
      
      private var itemToBuyId:int;
      
      private var itemPreview:MovieClip;
      
      internal var hasWeapon:Boolean;
      
      internal var hasArmor:Boolean;
      
      internal var hasMisc:Boolean;
      
      private var currentEditMarketItem:com.brockw.stickwar.market.MarketItem;
      
      public var empirePointsToShow:Number;
      
      private var scrollIndex:int;
      
      private var _isEditMode:Boolean;
      
      private var visibleCount:int;
      
      private var currentType:int;
      
      private var currencyType:String = "USD";
      
      private var currencyExchange:Number = 1;
      
      public function ArmoryScreen(param1:Main)
      {
         super();
         this.main = param1;
         this.itemPreview = null;
         this.mc = new armoryScreenMc();
         addChild(this.mc);
         this.unitCards = [];
         this.currentCard = null;
         this.team = Team.T_GOOD;
         this.hasWeapon = this.hasArmor = this.hasMisc = true;
         this.empirePointsToShow = 0;
         this.isEditMode = false;
         this.scrollIndex = 0;
         this.visibleCount = 0;
         this.mc.bottomPanel.mouseEnabled = false;
         this.currentType = MarketItem.T_WEAPON;
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
      
      public function updateCurrency(param1:String, param2:Number) : *
      {
         this.currencyType = param1;
         this.currencyExchange = param2;
         this._mc.paymentScreen.price1.text = "$" + this.twoDecimalPlaces(1.99 * param2) + " " + param1;
         this._mc.paymentScreen.price2.text = "$" + this.twoDecimalPlaces(4.99 * param2) + " " + param1;
         this._mc.paymentScreen.price3.text = "$" + this.twoDecimalPlaces(24.99 * param2) + " " + param1;
         this._mc.paymentScreen.price4.text = "$" + this.twoDecimalPlaces(29.99 * param2) + " " + param1;
         this._mc.paymentScreen.membershipPrice.text = "$" + this.twoDecimalPlaces(3.99 * param2) + " " + param1;
         this._mc.paymentScreen.membership1YearPrice.text = "$" + this.twoDecimalPlaces(36.99 * param2) + " " + param1;
         this._mc.paymentScreen.membership2YearPrice.text = "$" + this.twoDecimalPlaces(47.99 * param2) + " " + param1;
         this._mc.paymentScreen.price1.mouseEnabled = false;
         this._mc.paymentScreen.price2.mouseEnabled = false;
         this._mc.paymentScreen.price3.mouseEnabled = false;
         this._mc.paymentScreen.price4.mouseEnabled = false;
         this._mc.paymentScreen.membershipPrice.mouseEnabled = false;
      }
      
      private function twoDecimalPlaces(param1:Number) : *
      {
         var _loc2_:int = param1;
         var _loc3_:int = (param1 - _loc2_) * 100;
         var _loc4_:* = _loc2_ + "." + _loc3_;
         if(_loc3_ < 10)
         {
            _loc4_ += "0";
         }
         return _loc4_;
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
      
      private function initUnitCard(param1:int, param2:int, param3:Class, param4:MovieClip) : void
      {
         var _loc5_:com.brockw.stickwar.market.ArmoryUnitCard;
         (_loc5_ = new ArmoryUnitCard(this.main,param1,param2,ItemMap.getUnitMcFromType(param2),param3,param4)).currentItemType = this.currentType;
         this.unitCards.push(_loc5_);
         if(this.currentCard)
         {
            if(this.currentCard.unitType == param2)
            {
               this.currentCard.setSelected();
               _loc5_.viewingIndex = this.currentCard.viewingIndex;
               this.currentCard = _loc5_;
            }
         }
      }
      
      public function initUnitCards() : void
      {
         var _loc2_:com.brockw.stickwar.market.ArmoryUnitCard = null;
         var _loc1_:int = 0;
         if(this.currentCard != null)
         {
            _loc1_ = int(this.currentCard.viewingIndex);
            this.currentCard.removeUnitProfile(this.mc.unitDisplayBox);
         }
         for each(_loc2_ in this.unitCards)
         {
            if(this.mc.cardContainer.contains(_loc2_))
            {
               this.mc.cardContainer.removeChild(_loc2_);
            }
            else
            {
               trace("Would not have cleaned");
            }
         }
         this.unitCards = [];
         this.mc.unlockChaosScreen.visible = false;
         if(this.team == Team.T_GOOD)
         {
            this.initUnitCard(Team.T_GOOD,Unit.U_SWORDWRATH,Swordwrath,new Armory_Swordwrath());
            this.initUnitCard(Team.T_GOOD,Unit.U_ARCHER,Archer,new Armory_Archidon());
            this.initUnitCard(Team.T_GOOD,Unit.U_SPEARTON,Spearton,new Armory_Speartan());
            this.initUnitCard(Team.T_GOOD,Unit.U_MINER,Miner,new Armory_Miner());
            this.initUnitCard(Team.T_GOOD,Unit.U_NINJA,Ninja,new Armory_Ninja());
            this.initUnitCard(Team.T_GOOD,Unit.U_FLYING_CROSSBOWMAN,FlyingCrossbowman,new Armory_Flyer());
            this.initUnitCard(Team.T_GOOD,Unit.U_ENSLAVED_GIANT,EnslavedGiant,new Armory_Slave_Giant());
            this.initUnitCard(Team.T_GOOD,Unit.U_MAGIKILL,Magikill,new Armory_Wizard());
            this.initUnitCard(Team.T_GOOD,Unit.U_MONK,Monk,new Armory_Priest());
         }
         else if(this.team == Team.T_CHAOS)
         {
            if(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership))
            {
               this.initUnitCard(Team.T_CHAOS,Unit.U_CAT,Cat,new Armory_Cat());
               this.initUnitCard(Team.T_CHAOS,Unit.U_BOMBER,Bomber,new Armory_Suicide());
               this.initUnitCard(Team.T_CHAOS,Unit.U_DEAD,Dead,new Armory_Deads());
               this.initUnitCard(Team.T_CHAOS,Unit.U_CHAOS_MINER,MinerChaos,new Armory_Slave_Miner());
               this.initUnitCard(Team.T_CHAOS,Unit.U_KNIGHT,Knight,new Armory_Knight());
               this.initUnitCard(Team.T_CHAOS,Unit.U_WINGIDON,Wingidon,new Armory_Wingadon());
               this.initUnitCard(Team.T_CHAOS,Unit.U_GIANT,Giant,new Armory_Giant());
               this.initUnitCard(Team.T_CHAOS,Unit.U_MEDUSA,Medusa,new Armory_Medusa());
               this.initUnitCard(Team.T_CHAOS,Unit.U_SKELATOR,Skelator,new Armory_Mage());
            }
            else
            {
               this.mc.unlockChaosScreen.visible = true;
            }
         }
         else if(this.team == Team.T_ELEMENTAL)
         {
            if(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership))
            {
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_FIRE_ELEMENT,FireElement,new Armory_Fire());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_EARTH_ELEMENT,EarthElement,new Armory_Earth());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_WATER_ELEMENT,WaterElement,new Armory_Water());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_AIR_ELEMENT,AirElement,new Armory_Wind());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_HURRICANE_ELEMENT,HurricaneElement,new Armory_Hurricane());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_CHROME_ELEMENT,ChromeElement,new Armory_Chrome());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_SCORPION_ELEMENT,ScorpionElement,new Armory_Scorpion());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_LAVA_ELEMENT,LavaElement,new Armory_Lava());
               this.initUnitCard(Team.T_ELEMENTAL,Unit.U_MINER_ELEMENT,ElementalMiner,new Armory_Miner());
            }
            else
            {
               this.mc.unlockChaosScreen.visible = true;
            }
         }
         this.currentCard = this.unitCards[0];
         this.updateUnitCards();
         if(this.currentCard != null)
         {
            this.currentCard.setUnitProfile(this.mc.unitDisplayBox);
            this.currentCard.currentItemType = this.currentCard.currentItemType;
            this.currentCard.viewingIndex = _loc1_;
         }
      }
      
      private function updateUnitCards(param1:Boolean = false) : void
      {
         var _loc3_:com.brockw.stickwar.market.ArmoryUnitCard = null;
         var _loc4_:Number = NaN;
         var _loc2_:int = 0;
         this.visibleCount = 0;
         for each(_loc3_ in this.unitCards)
         {
            if(!this.mc.cardContainer.contains(_loc3_))
            {
               this.mc.cardContainer.addChild(_loc3_);
            }
            if(_loc3_.currentItems.length != 0)
            {
               _loc3_.x = 111;
               _loc4_ = 1;
               if(param1)
               {
                  _loc4_ = 0.3;
               }
               _loc3_.y += (143 + (this.visibleCount++ - this.scrollIndex) * 147 - _loc3_.y) * _loc4_;
               _loc3_.visible = true;
            }
            else
            {
               _loc3_.visible = false;
               _loc3_.y = 900;
            }
            _loc2_++;
         }
      }
      
      public function update(param1:Event) : void
      {
         var _loc3_:com.brockw.stickwar.market.ArmoryUnitCard = null;
         var _loc4_:int = 0;
         var _loc5_:com.brockw.stickwar.market.ArmoryUnitCard = null;
         this.mc.editFeatureButton.visible = this.main.armourScreen.isEditMode;
         if(this.mc.editFeatureCard.visible)
         {
            this.mc.editFeatureCard.weaponRadio.gotoAndStop(1);
            this.mc.editFeatureCard.armorRadio.gotoAndStop(1);
            this.mc.editFeatureCard.miscRadio.gotoAndStop(1);
            if(this.currentType == MarketItem.T_WEAPON)
            {
               this.mc.editFeatureCard.weaponRadio.gotoAndStop(2);
            }
            else if(this.currentType == MarketItem.T_ARMOR)
            {
               this.mc.editFeatureCard.armorRadio.gotoAndStop(2);
            }
            else if(this.currentType == MarketItem.T_MISC)
            {
               this.mc.editFeatureCard.miscRadio.gotoAndStop(2);
            }
         }
         var _loc2_:int = 0;
         this.mc.downButton.enabled = true;
         this.mc.upButton.enabled = true;
         this.mc.upButton.mouseEnabled = true;
         this.mc.downButton.mouseEnabled = true;
         this.mc.downButton.visible = true;
         this.mc.upButton.visible = true;
         this.mc.upDisabled.visible = false;
         this.mc.downDisabled.visible = false;
         _loc2_ = this.scrollIndex + 2;
         _loc2_ = Math.min(this.visibleCount - 3,_loc2_);
         _loc2_ = Math.max(_loc2_,0);
         if(_loc2_ == this.scrollIndex)
         {
            this.mc.downButton.enabled = false;
            this.mc.downButton.mouseEnabled = false;
            this.mc.downButton.visible = false;
            this.mc.downDisabled.visible = true;
         }
         _loc2_ = this.scrollIndex - 2;
         _loc2_ = Math.max(_loc2_,0);
         if(_loc2_ == this.scrollIndex)
         {
            this.mc.upButton.enabled = false;
            this.mc.upButton.mouseEnabled = false;
            this.mc.upButton.visible = false;
            this.mc.upDisabled.visible = true;
         }
         this.mc.empiresPoints.text = "" + Math.round(this.empirePointsToShow);
         this.empirePointsToShow += (this.main.empirePoints - this.empirePointsToShow) * 0.1;
         this.updateUnitCards(true);
         if(!this.isUnlocking())
         {
            if(this.team == Team.T_GOOD)
            {
               this.mc.teamBanner.gotoAndStop(1);
            }
            else if(this.team == Team.T_CHAOS)
            {
               this.mc.teamBanner.gotoAndStop(2);
            }
            else
            {
               this.mc.teamBanner.gotoAndStop(3);
            }
            this.mc.orderButton.gotoAndStop(1);
            this.mc.chaosButton.gotoAndStop(1);
            this.mc.elementalButton.gotoAndStop(1);
            if(this.mc.orderButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               this.mc.orderButton.gotoAndStop(2);
               if(this.isMouseDown)
               {
                  this.team = Team.T_GOOD;
                  this.initUnitCards();
               }
            }
            else if(this.mc.chaosButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               this.mc.chaosButton.gotoAndStop(2);
               if(this.isMouseDown)
               {
                  this.team = Team.T_CHAOS;
                  this.initUnitCards();
               }
            }
            else if(this.mc.elementalButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
            {
               this.mc.elementalButton.gotoAndStop(2);
               if(this.isMouseDown)
               {
                  this.team = Team.T_ELEMENTAL;
                  this.initUnitCards();
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
            else if(this.team == Team.T_ELEMENTAL)
            {
               this.mc.elementalButton.gotoAndStop(3);
            }
            if(this.currentCard != null)
            {
               _loc4_ = int(this.currentCard.currentItemType);
               if(this.mc.weaponButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(Boolean(this.isMouseDown) && Boolean(this.hasWeapon))
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        this.currentType = _loc5_.currentItemType = MarketItem.T_WEAPON;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.weaponButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.weaponButton.gotoAndStop(1);
               }
               if(this.mc.armorButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(Boolean(this.isMouseDown) && Boolean(this.hasArmor))
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        this.currentType = _loc5_.currentItemType = MarketItem.T_ARMOR;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.armorButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.armorButton.gotoAndStop(1);
               }
               if(this.mc.miscButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(Boolean(this.isMouseDown) && Boolean(this.hasMisc))
                  {
                     for each(_loc5_ in this.unitCards)
                     {
                        this.currentType = _loc5_.currentItemType = MarketItem.T_MISC;
                     }
                     this.scrollIndex = 0;
                     this.updateUnitCards();
                  }
                  this.mc.miscButton.gotoAndStop(2);
               }
               else
               {
                  this.mc.miscButton.gotoAndStop(1);
               }
               if((_loc4_ = int(this.currentType)) == MarketItem.T_WEAPON)
               {
                  this.mc.weaponButton.gotoAndStop(3);
               }
               else if(_loc4_ == MarketItem.T_ARMOR)
               {
                  this.mc.armorButton.gotoAndStop(3);
               }
               else if(_loc4_ == MarketItem.T_MISC)
               {
                  this.mc.miscButton.gotoAndStop(3);
               }
            }
            if(Boolean(this.main.isMember) || Boolean(this.main.pendingMembership))
            {
               this._mc.paymentScreen.membershipButton.alpha = 0.2;
               this._mc.paymentScreen.membershipButton.enabled = false;
               this._mc.paymentScreen.membership2YearsButton.alpha = 0.2;
               this._mc.paymentScreen.membership2YearsButton.enabled = false;
               this._mc.paymentScreen.membership1YearsButton.alpha = 0.2;
               this._mc.paymentScreen.membership1YearsButton.enabled = false;
               this._mc.earnCoinsScreen.membershipButton.alpha = 0.2;
               this._mc.earnCoinsScreen.membershipButton.enabled = false;
            }
            else
            {
               this._mc.paymentScreen.membershipButton.alpha = 1;
               this._mc.paymentScreen.membershipButton.enabled = true;
               this._mc.paymentScreen.membership1YearsButton.alpha = 1;
               this._mc.paymentScreen.membership1YearsButton.enabled = true;
               this._mc.paymentScreen.membership2YearsButton.alpha = 1;
               this._mc.paymentScreen.membership2YearsButton.enabled = true;
            }
         }
         for each(_loc3_ in this.unitCards)
         {
            if(!this.isUnlocking())
            {
               if(_loc3_.isSelected)
               {
                  if(_loc3_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                  {
                     _loc3_.setHover();
                  }
               }
               else if(_loc3_.hitTestPoint(stage.mouseX,stage.mouseY,true))
               {
                  if(this.isMouseDown)
                  {
                     this.currentCard.setNotSelected();
                     this.currentCard.removeUnitProfile(this.mc.unitDisplayBox);
                     _loc3_.setSelected();
                     this.currentCard = _loc3_;
                     this.currentCard.setUnitProfile(this.mc.unitDisplayBox);
                     _loc3_.setHover();
                  }
                  else
                  {
                     _loc3_.setHover();
                  }
               }
               else
               {
                  _loc3_.setNotSelected();
               }
            }
            _loc3_.update();
         }
         this.isMouseDown = false;
      }
      
      private function mouseDown(param1:Event) : void
      {
         this.isMouseDown = true;
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
         this.initUnitCards();
      }
      
      override public function enter() : void
      {
         this.mc.editFeatureButton.visible = false;
         this.mc.editFeatureCard.visible = false;
         this.main.setOverlayScreen("chatOverlay");
         this.mc.pillar.mouseEnabled = false;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.addEventListener(Event.ENTER_FRAME,this.update);
         this.mc.unlockMc.closeButton.addEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.addEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.addEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.addEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.earnCoinsScreen.closeButton.addEventListener(MouseEvent.CLICK,this.closeEarnCoins);
         this.mc.earnCoinsScreen.paymentButton1.enabled = false;
         this.mc.earnCoinsScreen.paymentButton2.enabled = false;
         this.mc.earnCoinsScreen.paymentButton3.enabled = false;
         this.mc.paymentScreen.closeButton.addEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.addPointsButton.addEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.mc.editFeatureCard.updateButton.addEventListener(MouseEvent.CLICK,this.updateFeatureCard);
         this.mc.upButton.addEventListener(MouseEvent.CLICK,this.upButton);
         this.mc.downButton.addEventListener(MouseEvent.CLICK,this.downButton);
         this.mc.unlockChaosScreen.membershipButton.addEventListener(MouseEvent.CLICK,this.membershipButton);
         this.mc.editFeatureButton.addEventListener(MouseEvent.CLICK,this.editFeature);
         this.mc.editFeatureCard.closeButton.addEventListener(MouseEvent.CLICK,this.closeFeatureCard);
         this.mc.editFeatureCard.weaponRadio.addEventListener(MouseEvent.CLICK,this.radioChanger);
         this.mc.editFeatureCard.armorRadio.addEventListener(MouseEvent.CLICK,this.radioChanger);
         this.mc.editFeatureCard.miscRadio.addEventListener(MouseEvent.CLICK,this.radioChanger);
         this.initUnitCards();
         stage.frameRate = 30;
         this.main.sfs.send(new ExtensionRequest("getLoadout",null));
         this.main.sfs.send(new ExtensionRequest("getEmpirePoints",null));
         this.mc.unlockMc.visible = false;
         this.mc.earnCoinsScreen.visible = false;
         this.mc.itemUnlockResult.visible = false;
         this.mc.editCard.visible = false;
         this.mc.paymentScreen.visible = false;
      }
      
      private function closeFeatureCard(param1:Event) : void
      {
         this.mc.editFeatureCard.visible = false;
      }
      
      private function updateFeatureCard(param1:Event) : void
      {
         if(this.currentCard.itemMap[this.currentType] == "Default")
         {
            return;
         }
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("unitType",this.currentCard.unitType);
         _loc2_.putUtfString("weapon",this.currentCard.itemMap[MarketItem.T_WEAPON]);
         _loc2_.putUtfString("armor",this.currentCard.itemMap[MarketItem.T_ARMOR]);
         _loc2_.putUtfString("misc",this.currentCard.itemMap[MarketItem.T_MISC]);
         _loc2_.putUtfString("title",this.mc.editFeatureCard.title.text);
         _loc2_.putUtfString("description",this.mc.editFeatureCard.description.text);
         _loc2_.putInt("type",this.currentType);
         this.main.sfs.send(new ExtensionRequest("setFeature",_loc2_));
         this.mc.editFeatureCard.visible = false;
      }
      
      private function editFeature(param1:Event) : void
      {
         this.mc.editFeatureCard.unitType.text = "" + this.currentCard.unitType;
         this.mc.editFeatureCard.weapon.text = this.currentCard.itemMap[MarketItem.T_WEAPON];
         this.mc.editFeatureCard.armor.text = this.currentCard.itemMap[MarketItem.T_ARMOR];
         this.mc.editFeatureCard.misc.text = this.currentCard.itemMap[MarketItem.T_MISC];
         this.mc.editFeatureCard.description.text = "";
         this.mc.editFeatureCard.visible = true;
      }
      
      private function downButton(param1:Event) : void
      {
         this.scrollIndex += 2;
         this.scrollIndex = Math.min(this.visibleCount - 3,this.scrollIndex);
         this.scrollIndex = Math.max(this.scrollIndex,0);
      }
      
      private function upButton(param1:Event) : void
      {
         this.scrollIndex -= 2;
         this.scrollIndex = Math.max(this.scrollIndex,0);
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
      
      public function openEarnCoinsScreen(param1:Event) : void
      {
         this.mc.earnCoinsScreen.visible = true;
         this.mc.earnCoinsScreen.membershipButton.addEventListener(MouseEvent.CLICK,this.membershipButton,false,0,true);
      }
      
      public function paymentComplete(param1:*) : void
      {
         this.mc.paymentScreen.visible = false;
         this.mc.itemUnlockResult.visible = true;
         this.mc.itemUnlockResult.resultText.text = param1;
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
      
      private function radioChanger(param1:Event) : void
      {
         if(param1.target == this.mc.editFeatureCard.weaponRadio)
         {
            this.currentType = MarketItem.T_WEAPON;
         }
         if(param1.target == this.mc.editFeatureCard.armorRadio)
         {
            this.currentType = MarketItem.T_ARMOR;
         }
         if(param1.target == this.mc.editFeatureCard.miscRadio)
         {
            this.currentType = MarketItem.T_MISC;
         }
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
      
      private function closeEditCard(param1:Event) : void
      {
         this.mc.editCard.visible = false;
      }
      
      private function closeItemResult(param1:MouseEvent) : void
      {
         this.mc.itemUnlockResult.visible = false;
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
      
      public function isUnlocking() : Boolean
      {
         return this.mc.earnCoinsScreen.visible == true || this.mc.editFeatureCard.visible == true || this.mc.unlockMc.visible == true || this.mc.itemUnlockResult.visible == true || this.mc.editCard.visible == true || this.mc.paymentScreen.visible == true;
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
      
      private function unlockButton(param1:Event) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putInt("itemId",this.itemToBuyId);
         this.main.sfs.send(new ExtensionRequest("buy",_loc2_));
         this.mc.unlockMc.visible = false;
      }
      
      private function closeUnlock(param1:Event) : void
      {
         this.mc.unlockMc.visible = false;
      }
      
      private function closeEarnCoins(param1:Event) : void
      {
         this.mc.earnCoinsScreen.visible = false;
      }
      
      override public function leave() : void
      {
         this.mc.earnCoinsScreen.closeButton.removeEventListener(MouseEvent.CLICK,this.closeEarnCoins);
         this.mc.editFeatureCard.closeButton.removeEventListener(MouseEvent.CLICK,this.closeFeatureCard);
         this.mc.editFeatureCard.visible = false;
         this.mc.editFeatureButton.removeEventListener(MouseEvent.CLICK,this.editFeature);
         this.mc.paymentScreen.closeButton.removeEventListener(MouseEvent.CLICK,this.closePaymentScreen);
         this.mc.addPointsButton.removeEventListener(MouseEvent.CLICK,this.openPaymentScreen);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         this.mc.unlockMc.closeButton.removeEventListener(MouseEvent.CLICK,this.closeUnlock);
         this.mc.unlockMc.unlockButton.removeEventListener(MouseEvent.CLICK,this.unlockButton);
         this.mc.itemUnlockResult.doneButton.removeEventListener(MouseEvent.CLICK,this.closeItemResult);
         this.mc.editCard.closeButton.removeEventListener(MouseEvent.CLICK,this.closeEditCard);
         this.mc.editCard.updateButton.removeEventListener(MouseEvent.CLICK,this.updateEditCard);
         this.mc.editFeatureCard.updateButton.removeEventListener(MouseEvent.CLICK,this.updateFeatureCard);
         this.mc.upButton.removeEventListener(MouseEvent.CLICK,this.upButton);
         this.mc.downButton.removeEventListener(MouseEvent.CLICK,this.downButton);
         this.mc.unlockChaosScreen.membershipButton.removeEventListener(MouseEvent.CLICK,this.membershipButton);
         this.mc.editFeatureCard.weaponRadio.buttonMode = true;
         this.mc.editFeatureCard.armorRadio.buttonMode = true;
         this.mc.editFeatureCard.miscRadio.buttonMode = true;
         this.mc.editFeatureCard.weaponRadio.removeEventListener(MouseEvent.CLICK,this.radioChanger);
         this.mc.editFeatureCard.armorRadio.removeEventListener(MouseEvent.CLICK,this.radioChanger);
         this.mc.editFeatureCard.miscRadio.removeEventListener(MouseEvent.CLICK,this.radioChanger);
      }
      
      public function saveLoadout() : void
      {
         var _loc1_:SFSObject = this.main.loadout.toSFSObject();
         this.main.sfs.send(new ExtensionRequest("saveLoadout",_loc1_));
      }
      
      public function get mc() : armoryScreenMc
      {
         return this._mc;
      }
      
      public function set mc(param1:armoryScreenMc) : void
      {
         this._mc = param1;
      }
      
      public function get isEditMode() : Boolean
      {
         return this._isEditMode;
      }
      
      public function set isEditMode(param1:Boolean) : void
      {
         this._isEditMode = param1;
      }
   }
}
