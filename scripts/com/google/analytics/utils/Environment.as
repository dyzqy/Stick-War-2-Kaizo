package com.google.analytics.utils
{
   import com.google.analytics.core.ga_internal;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.external.HTMLDOM;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   
   public class Environment
   {
       
      
      private var _dom:HTMLDOM;
      
      private var _appName:String;
      
      private var _debug:DebugConfiguration;
      
      private var _appVersion:com.google.analytics.utils.Version;
      
      private var _url:String;
      
      private var _protocol:com.google.analytics.utils.Protocols;
      
      private var _userAgent:com.google.analytics.utils.UserAgent;
      
      public function Environment(param1:String = "", param2:String = "", param3:String = "", param4:DebugConfiguration = null, param5:HTMLDOM = null)
      {
         var _loc6_:com.google.analytics.utils.Version = null;
         super();
         if(param2 == "")
         {
            if(isAIR())
            {
               param2 = "AIR";
            }
            else
            {
               param2 = "Flash";
            }
         }
         if(param3 == "")
         {
            _loc6_ = flashVersion;
         }
         else
         {
            _loc6_ = com.google.analytics.utils.Version.fromString(param3);
         }
         _url = param1;
         _appName = param2;
         _appVersion = _loc6_;
         _debug = param4;
         _dom = param5;
      }
      
      public function isAIR() : Boolean
      {
         return playerType == "Desktop" && Security.sandboxType.toString() == "application";
      }
      
      public function get playerType() : String
      {
         return Capabilities.playerType;
      }
      
      public function get locationSearch() : String
      {
         var _loc1_:String = null;
         _loc1_ = _dom.search;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get protocol() : com.google.analytics.utils.Protocols
      {
         if(!_protocol)
         {
            _findProtocol();
         }
         return _protocol;
      }
      
      public function get flashVersion() : com.google.analytics.utils.Version
      {
         var _loc1_:com.google.analytics.utils.Version = null;
         return com.google.analytics.utils.Version.fromString(Capabilities.version.split(" ")[1],",");
      }
      
      public function get screenWidth() : Number
      {
         return Capabilities.screenResolutionX;
      }
      
      public function get languageEncoding() : String
      {
         var _loc1_:String = null;
         if(System.useCodePage)
         {
            _loc1_ = _dom.characterSet;
            if(_loc1_)
            {
               return _loc1_;
            }
            return "-";
         }
         return "UTF-8";
      }
      
      public function get appName() : String
      {
         return _appName;
      }
      
      public function get screenColorDepth() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         switch(Capabilities.screenColor)
         {
            case "bw":
               _loc1_ = "1";
               break;
            case "gray":
               _loc1_ = "2";
               break;
            case "color":
            default:
               _loc1_ = "24";
         }
         _loc2_ = _dom.colorDepth;
         if(_loc2_)
         {
            _loc1_ = _loc2_;
         }
         return _loc1_;
      }
      
      private function _findProtocol() : void
      {
         var _loc1_:com.google.analytics.utils.Protocols = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc1_ = com.google.analytics.utils.Protocols.none;
         if(_url != "")
         {
            _loc5_ = (_loc4_ = _url.toLowerCase()).substr(0,5);
            switch(_loc5_)
            {
               case "file:":
                  _loc1_ = com.google.analytics.utils.Protocols.file;
                  break;
               case "http:":
                  _loc1_ = com.google.analytics.utils.Protocols.HTTP;
                  break;
               case "https":
                  if(_loc4_.charAt(5) == ":")
                  {
                     _loc1_ = com.google.analytics.utils.Protocols.HTTPS;
                  }
                  break;
               default:
                  _protocol = com.google.analytics.utils.Protocols.none;
            }
         }
         _loc2_ = _dom.protocol;
         _loc3_ = (_loc1_.toString() + ":").toLowerCase();
         if(_loc2_ && _loc2_ != _loc3_ && Boolean(_debug))
         {
            _debug.warning("Protocol mismatch: SWF=" + _loc3_ + ", DOM=" + _loc2_);
         }
         _protocol = _loc1_;
      }
      
      public function get locationSWFPath() : String
      {
         return _url;
      }
      
      public function get platform() : String
      {
         var _loc1_:String = null;
         _loc1_ = Capabilities.manufacturer;
         return _loc1_.split("Adobe ")[1];
      }
      
      public function get operatingSystem() : String
      {
         return Capabilities.os;
      }
      
      public function set appName(param1:String) : void
      {
         _appName = param1;
         userAgent.applicationProduct = param1;
      }
      
      public function get userAgent() : com.google.analytics.utils.UserAgent
      {
         if(!_userAgent)
         {
            _userAgent = new com.google.analytics.utils.UserAgent(this,appName,appVersion.toString(4));
         }
         return _userAgent;
      }
      
      ga_internal function set url(param1:String) : void
      {
         _url = param1;
      }
      
      public function get referrer() : String
      {
         var _loc1_:String = null;
         _loc1_ = _dom.referrer;
         if(_loc1_)
         {
            return _loc1_;
         }
         if(protocol == com.google.analytics.utils.Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function isInHTML() : Boolean
      {
         return Capabilities.playerType == "PlugIn";
      }
      
      public function get language() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         _loc1_ = _dom.language;
         _loc2_ = Capabilities.language;
         if(_loc1_)
         {
            if(_loc1_.length > _loc2_.length && _loc1_.substr(0,_loc2_.length) == _loc2_)
            {
               _loc2_ = _loc1_;
            }
         }
         return _loc2_;
      }
      
      public function get domainName() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(protocol == com.google.analytics.utils.Protocols.HTTP || protocol == com.google.analytics.utils.Protocols.HTTPS)
         {
            _loc1_ = _url.toLowerCase();
            if(protocol == com.google.analytics.utils.Protocols.HTTP)
            {
               _loc2_ = _loc1_.split("http://").join("");
            }
            else if(protocol == com.google.analytics.utils.Protocols.HTTPS)
            {
               _loc2_ = _loc1_.split("https://").join("");
            }
            _loc3_ = _loc2_.indexOf("/");
            if(_loc3_ > -1)
            {
               _loc2_ = _loc2_.substring(0,_loc3_);
            }
            return _loc2_;
         }
         if(protocol == com.google.analytics.utils.Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function set userAgent(param1:com.google.analytics.utils.UserAgent) : void
      {
         _userAgent = param1;
      }
      
      public function set appVersion(param1:com.google.analytics.utils.Version) : void
      {
         _appVersion = param1;
         userAgent.applicationVersion = param1.toString(4);
      }
      
      public function get screenHeight() : Number
      {
         return Capabilities.screenResolutionY;
      }
      
      public function get locationPath() : String
      {
         var _loc1_:String = null;
         _loc1_ = _dom.pathname;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get documentTitle() : String
      {
         var _loc1_:String = null;
         _loc1_ = _dom.title;
         if(_loc1_)
         {
            return _loc1_;
         }
         return "";
      }
      
      public function get appVersion() : com.google.analytics.utils.Version
      {
         return _appVersion;
      }
   }
}
