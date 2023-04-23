package com.brockw.stickwar.engine.multiplayer
{
   import fl.controls.*;
   
   public class NewsPanel extends newsPanelMc
   {
       
      
      public var index:int;
      
      public var id:int;
      
      public function NewsPanel(param1:String, param2:String, param3:String, param4:int, param5:int, param6:String, param7:int)
      {
         super();
         this.title.text = param1;
         var _loc8_:messageContainer = new messageContainer();
         _loc8_.y += 5;
         _loc8_.message.htmlText = param2;
         _loc8_.message.mouseWheelEnabled = false;
         this.dateBox.text = param3;
         _loc8_.message.height = _loc8_.message.textHeight + 5;
         scrollPane.source = _loc8_;
         scrollPane.setSize(scrollPane.width,scrollPane.height);
         scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
         scrollPane.update();
         this.index = param5;
         this.id = param7;
         this.gotoAndStop(getNewsTypeById(param4));
      }
      
      public static function getNewsTypeById(param1:int) : String
      {
         if(param1 == 1)
         {
            return "News";
         }
         if(param1 == 2)
         {
            return "Patch";
         }
         if(param1 == 3)
         {
            return "Art";
         }
         if(param1 == 4)
         {
            return "Community";
         }
         return "News";
      }
      
      public function update() : void
      {
         scrollPane.update();
      }
   }
}
