package com.smartfoxserver.v2.entities.match
{
   public class LogicOperator
   {
      
      public static const AND:com.smartfoxserver.v2.entities.match.LogicOperator = new com.smartfoxserver.v2.entities.match.LogicOperator("AND");
      
      public static const OR:com.smartfoxserver.v2.entities.match.LogicOperator = new com.smartfoxserver.v2.entities.match.LogicOperator("OR");
       
      
      private var _id:String;
      
      public function LogicOperator(param1:String)
      {
         super();
         this._id = param1;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}
