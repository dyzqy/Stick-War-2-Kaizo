package com.brockw.stickwar.engine
{
   import flash.display.*;
   import flash.text.TextField;
   
   public class TipBox extends Sprite
   {
       
      
      private var _toolBox:toolBoxMc;
      
      private var showCount:int;
      
      private var toolBoxShowTime:int;
      
      private var isShowing:Boolean;
      
      public function TipBox(param1:StickWar)
      {
         super();
         this.toolBox = new toolBoxMc();
         this.showCount = 0;
         this.toolBoxShowTime = param1.xml.xml.toolBoxShowTime;
         this.isShowing = false;
      }
      
      public function update(param1:StickWar) : void
      {
         if(this.isShowing)
         {
            ++this.showCount;
            if(this.showCount > this.toolBoxShowTime && !param1.gameScreen.isFastForwardFrame)
            {
               removeChild(this.toolBox);
               this.isShowing = false;
            }
         }
      }
      
      private function setField(param1:String, param2:TextField) : void
      {
         param2.text = param1;
         param2.visible = true;
      }
      
      public function displayTip(param1:String, param2:String, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:Boolean = false) : void
      {
         this.setField(param2,this.toolBox.textBox.text);
         this.setField(param1,this.toolBox.title);
         this.toolBox.elements.visible = false;
         if(!param7)
         {
            this.toolBox.statDisplay.visible = true;
            this.toolBox.textBox.y = 497.6;
            this.setField("" + param4,this.toolBox.statDisplay.gold);
            this.setField("" + Math.round(param3 / 30) + "s",this.toolBox.statDisplay.time);
            this.setField("" + param5,this.toolBox.statDisplay.mana);
            if(param6 == 0)
            {
               this.toolBox.statDisplay.population.visible = false;
               this.toolBox.statDisplay.populationSymbol.visible = false;
            }
            else
            {
               this.toolBox.statDisplay.population.visible = true;
               this.toolBox.statDisplay.populationSymbol.visible = true;
               this.setField("" + param6,this.toolBox.statDisplay.population);
            }
         }
         else
         {
            this.toolBox.statDisplay.visible = false;
            this.toolBox.textBox.y = 421.6;
         }
         if(!this.contains(this.toolBox))
         {
            addChild(this.toolBox);
         }
         this.showCount = 0;
         this.isShowing = true;
      }
      
      public function displayElementalTip(param1:String, param2:String, param3:int, param4:Array, param5:Number) : void
      {
         this.setField(param2,this.toolBox.textBox.text);
         this.setField(param1,this.toolBox.title);
         this.toolBox.elements.visible = true;
         this.toolBox.statDisplay.visible = false;
         this.toolBox.elements.mana.text = param5;
         if(param4.length >= 2)
         {
            this.toolBox.elements.element1.visible = true;
            this.toolBox.elements.plus1.visible = true;
            this.toolBox.elements.element2.visible = true;
            this.toolBox.elements.element1.gotoAndStop(param4[0]);
            this.toolBox.elements.element2.gotoAndStop(param4[1]);
         }
         if(param4.length == 4)
         {
            this.toolBox.elements.plus2.visible = true;
            this.toolBox.elements.element3.visible = true;
            this.toolBox.elements.plus3.visible = true;
            this.toolBox.elements.element4.visible = true;
            this.toolBox.elements.element3.gotoAndStop(param4[2]);
            this.toolBox.elements.element4.gotoAndStop(param4[3]);
         }
         else
         {
            this.toolBox.elements.plus2.visible = false;
            this.toolBox.elements.element3.visible = false;
            this.toolBox.elements.plus3.visible = false;
            this.toolBox.elements.element4.visible = false;
         }
         if(!this.contains(this.toolBox))
         {
            addChild(this.toolBox);
         }
         this.showCount = 0;
         this.isShowing = true;
      }
      
      public function get toolBox() : toolBoxMc
      {
         return this._toolBox;
      }
      
      public function set toolBox(param1:toolBoxMc) : void
      {
         this._toolBox = param1;
      }
   }
}
