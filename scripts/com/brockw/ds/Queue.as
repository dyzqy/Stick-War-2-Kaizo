package com.brockw.ds
{
   public class Queue
   {
       
      
      internal var data:Array;
      
      public function Queue(param1:int)
      {
         super();
         this.data = new Array(param1);
      }
      
      public function pop() : Object
      {
         return this.data.shift();
      }
      
      public function push(param1:Object) : void
      {
         this.data.push(param1);
      }
      
      public function size() : int
      {
         return this.data.length;
      }
      
      public function isEmpty() : Boolean
      {
         return this.data.length == 0;
      }
      
      public function clear() : void
      {
         while(!this.isEmpty())
         {
            this.data.pop();
         }
      }
   }
}
