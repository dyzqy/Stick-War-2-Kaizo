package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.smartfoxserver.v2.entities.data.SFSObject;
      import com.smartfoxserver.v2.requests.*;
      import fl.controls.*;
      import flash.events.*;
      import flash.net.*;
      import flash.text.*;
      
      public class FAQScreen extends Screen
      {
             
            
            internal var mc:faqScreenMc;
            
            internal var main:BaseMain;
            
            internal var faqText:Object;
            
            public function FAQScreen(param1:BaseMain)
            {
                  var _loc3_:Object = null;
                  super();
                  this.main = param1;
                  this.mc = new faqScreenMc();
                  addChild(this.mc);
                  var _loc2_:StyleSheet = new StyleSheet();
                  _loc3_ = new Object();
                  _loc3_.color = "#ebb73a";
                  _loc2_.setStyle(".question",_loc3_);
                  _loc3_ = new Object();
                  _loc3_.color = "#FFFFFF";
                  _loc2_.setStyle(".answer",_loc3_);
                  this.mc.faq.styleSheet = _loc2_;
                  this.mc.faq.htmlText = "";
                  this.faqText = this.mc.faq;
                  this.mc.faq.mouseWheelEnabled = false;
                  this.mc.scrollPane.source = this.mc.faq;
                  this.mc.scrollPane.setSize(this.mc.scrollPane.width,this.mc.scrollPane.height);
                  this.mc.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            }
            
            public function loadFAQ(param1:SFSObject) : void
            {
                  this.faqText.htmlText = param1.getUtfString("faq");
            }
            
            override public function enter() : void
            {
                  this.main.sfs.send(new ExtensionRequest("getFAQ"));
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.playButton.addEventListener(MouseEvent.CLICK,this.gameGuide);
                  this.mc.forumButton.addEventListener(MouseEvent.CLICK,this.forum);
            }
            
            private function gameGuide(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
                  if(this.main.tracker)
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickempiresguide.shtml");
                  }
                  navigateToURL(_loc2_,"_blank");
            }
            
            public function update(param1:Event) : void
            {
                  this.mc.scrollPane.update();
                  this.faqText.height = this.faqText.textHeight + 100;
            }
            
            private function forum(param1:Event) : void
            {
                  var _loc2_:URLRequest = new URLRequest("http://forums.stickpage.com/forumdisplay.php?62-Stick-Empires");
                  navigateToURL(_loc2_,"_blank");
            }
            
            override public function leave() : void
            {
                  removeEventListener(MouseEvent.CLICK,this.update);
                  this.mc.forumButton.removeEventListener(MouseEvent.CLICK,this.forum);
            }
      }
}
