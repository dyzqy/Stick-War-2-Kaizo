package com.brockw.stickwar.market
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.StickWar;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.*;
      import flash.events.*;
      import flash.text.*;
      import flash.utils.Timer;
      
      public class MarketScreen extends Screen
      {
            
            private static const NUM_COLS:* = 5;
            
            private static const NUM_ROWS:* = 5;
             
            
            private var main:Main;
            
            private var marketItems:Array;
            
            private var items:Array;
            
            private var timer:Timer;
            
            internal var stickwar:StickWar;
            
            public function MarketScreen(param1:Main)
            {
                  var txtWelcome:GenericText = null;
                  var mainMenuButton:GenericButton = null;
                  var main:Main = param1;
                  super();
                  this.main = main;
                  txtWelcome = new GenericText();
                  txtWelcome.text.text = "Market Place";
                  txtWelcome.width *= 2.5;
                  txtWelcome.height *= 2.5;
                  txtWelcome.x = main.stage.stageWidth / 2 - txtWelcome.width / 2;
                  txtWelcome.y = main.stage.stageHeight * 0.1 - txtWelcome.height / 2;
                  addChild(txtWelcome);
                  mainMenuButton = new GenericButton();
                  mainMenuButton.text.text = "Main Menu";
                  mainMenuButton.buttonMode = true;
                  mainMenuButton.mouseChildren = false;
                  mainMenuButton.width *= 1;
                  mainMenuButton.height *= 1;
                  mainMenuButton.x = main.stage.stageWidth / 2 - mainMenuButton.width / 2;
                  mainMenuButton.y = main.stage.stageHeight * 0.9 - mainMenuButton.height / 2;
                  mainMenuButton.addEventListener(MouseEvent.CLICK,function(param1:Event):*
                  {
                        main.showScreen("lobby");
                  });
                  addChild(mainMenuButton);
            }
            
            public function update(param1:Event) : void
            {
            }
            
            public function clicked(param1:MouseEvent) : void
            {
                  var _loc3_:MovieClip = null;
                  var _loc4_:SFSObject = null;
                  var _loc5_:ExtensionRequest = null;
                  var _loc2_:* = 0;
                  while(_loc2_ < this.marketItems.length)
                  {
                        _loc3_ = MarketItem(this.marketItems[_loc2_]).marketMc;
                        if(_loc3_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                        {
                              (_loc4_ = new SFSObject()).putInt("itemId",MarketItem(this.marketItems[_loc2_]).id);
                              _loc5_ = new ExtensionRequest("buy",_loc4_);
                              this.main.sfs.send(_loc5_);
                        }
                        _loc2_++;
                  }
            }
            
            public function drawMarketPlace() : void
            {
            }
            
            public function updateMarketItems() : void
            {
                  this.setMarketItems();
            }
            
            public function setMarketItems() : void
            {
                  if(this.main.marketItems == null)
                  {
                        return;
                  }
            }
            
            override public function enter() : void
            {
                  this.setMarketItems();
                  this.addEventListener(MouseEvent.CLICK,this.clicked);
            }
            
            override public function leave() : void
            {
                  var _loc2_:MarketItem = null;
                  var _loc1_:int = 0;
                  while(_loc1_ < this.main.marketItems.length)
                  {
                        _loc2_ = this.main.marketItems[_loc1_];
                        if(this.contains(_loc2_.marketMc))
                        {
                              removeChild(_loc2_.marketMc);
                        }
                        _loc1_++;
                  }
                  this.removeEventListener(MouseEvent.CLICK,this.clicked);
            }
      }
}
