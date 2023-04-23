package com.brockw.game
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class XMLLoader
   {
      
      public static const GameConstants:Class = XMLLoader_GameConstants;
       
      
      public var xml:XML;
      
      public function XMLLoader()
      {
         super();
         var _loc1_:ByteArray = new XMLLoader.GameConstants();
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         this.xml = new XML(_loc2_);
      }
   }
}
