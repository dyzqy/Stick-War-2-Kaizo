package CPMStar
{
   import flash.display.*;
   import flash.net.*;
   import flash.system.*;
   
   public class AdLoader
   {
      
      private static var cpmstarLoader:Loader;
       
      
      public function AdLoader()
      {
         super();
      }
      
      public static function LoadAd(param1:int, param2:int) : DisplayObject
      {
         Security.allowDomain("server.cpmstar.com");
         var _loc3_:String = "http://server.cpmstar.com/adviewas3.swf";
         cpmstarLoader = new Loader();
         cpmstarLoader.load(new URLRequest(_loc3_ + "?poolid=" + param1 + "&subpoolid=" + param2));
         return cpmstarLoader;
      }
   }
}
