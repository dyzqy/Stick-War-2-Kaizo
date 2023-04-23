package calista.util
{
   public class LZW
   {
       
      
      public function LZW()
      {
         super();
      }
      
      public static function compress(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc8_:String = null;
         var _loc5_:Number = 256;
         var _loc6_:String = new String(param1);
         var _loc7_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc7_[String(_loc2_)] = _loc2_;
            _loc2_++;
         }
         var _loc9_:String = new String("");
         var _loc10_:Array = _loc6_.split("");
         var _loc11_:Array = new Array();
         _loc3_ = _loc10_.length;
         _loc2_ = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc8_ = new String(_loc10_[_loc2_]);
            _loc4_ = _loc11_.length == 0 ? String(_loc8_.charCodeAt(0)) : _loc11_.join("-") + "-" + String(_loc8_.charCodeAt(0));
            if(_loc7_[_loc4_] !== undefined)
            {
               _loc11_.push(_loc8_.charCodeAt(0));
            }
            else
            {
               _loc9_ += String.fromCharCode(_loc7_[_loc11_.join("-")]);
               _loc7_[_loc4_] = _loc5_;
               _loc5_++;
               (_loc11_ = new Array()).push(_loc8_.charCodeAt(0));
            }
            _loc2_++;
         }
         return _loc9_;
      }
      
      public static function decompress(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc3_:Number = 256;
         var _loc4_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_] = String.fromCharCode(_loc2_);
            _loc2_++;
         }
         var _loc6_:Array;
         var _loc5_:String;
         var _loc7_:Number = (_loc6_ = (_loc5_ = new String(param1)).split("")).length;
         var _loc8_:String = new String("");
         var _loc9_:String = new String("");
         var _loc10_:String = new String("");
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc11_ = _loc5_.charCodeAt(_loc2_);
            _loc12_ = String(_loc4_[_loc11_]);
            if(_loc8_ == "")
            {
               _loc8_ = _loc12_;
               _loc10_ += _loc12_;
            }
            else if(_loc11_ <= 255)
            {
               _loc10_ += _loc12_;
               _loc9_ = _loc8_ + _loc12_;
               _loc4_[_loc3_] = _loc9_;
               _loc3_++;
               _loc8_ = _loc12_;
            }
            else
            {
               if((_loc9_ = String(_loc4_[_loc11_])) == null)
               {
                  _loc9_ = _loc8_ + _loc8_.slice(0,1);
               }
               _loc10_ += _loc9_;
               _loc4_[_loc3_] = _loc8_ + _loc9_.slice(0,1);
               _loc3_++;
               _loc8_ = _loc9_;
            }
            _loc2_++;
         }
         return _loc10_;
      }
   }
}
