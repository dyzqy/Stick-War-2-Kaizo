package com.liamr.ui.dropDown.Events
{
   import flash.events.Event;
   
   public class DropDownEvent extends Event
   {
       
      
      public var selectedId:int;
      
      public var selectedLabel:String;
      
      public var selectedData;
      
      public function DropDownEvent(param1:String, param2:int, param3:String, param4:*, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.selectedId = param2;
         this.selectedLabel = param3;
         this.selectedData = param4;
      }
   }
}
