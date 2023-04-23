package com.google.analytics.debug
{
   public class VisualDebugMode
   {
      
      public static const advanced:com.google.analytics.debug.VisualDebugMode = new com.google.analytics.debug.VisualDebugMode(1,"advanced");
      
      public static const geek:com.google.analytics.debug.VisualDebugMode = new com.google.analytics.debug.VisualDebugMode(2,"geek");
      
      public static const basic:com.google.analytics.debug.VisualDebugMode = new com.google.analytics.debug.VisualDebugMode(0,"basic");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function VisualDebugMode(param1:int = 0, param2:String = "")
      {
         super();
         _value = param1;
         _name = param2;
      }
      
      public function valueOf() : int
      {
         return _value;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}
