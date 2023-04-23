package com.brockw.game
{
   import com.brockw.simulationSync.Simulation;
   
   public class Pool
   {
       
      
      private var free:Vector.<Object>;
      
      private var fIndex:int;
      
      private var poolClass:Class;
      
      private var capacity:int;
      
      private var game:Simulation;
      
      public function Pool(param1:int, param2:Class, param3:Simulation)
      {
         super();
         this.game = param3;
         this.capacity = param1;
         this.poolClass = param2;
         this.fIndex = 0;
         this.free = new Vector.<Object>(param1,false);
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            this.free[_loc4_] = new param2(param3);
            _loc4_++;
         }
         this.fIndex = 0;
      }
      
      public function cleanUp() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.free.length)
         {
            if(this.free[_loc1_] != null)
            {
               this.free[_loc1_].cleanUp();
               this.free[_loc1_] = null;
            }
            else
            {
               trace("that things would have happened");
            }
            _loc1_++;
         }
      }
      
      public function getItem() : Object
      {
         var _loc1_:int = 0;
         if(this.fIndex >= this.capacity)
         {
            this.free = new Vector.<Object>(2 * this.capacity,false);
            _loc1_ = int(this.capacity);
            while(_loc1_ < 2 * this.capacity)
            {
               this.free[_loc1_] = new this.poolClass(this.game);
               _loc1_++;
            }
            this.capacity *= 2;
         }
         if(this.fIndex < this.capacity)
         {
            ++this.fIndex;
            return this.free[this.fIndex - 1];
         }
         return null;
      }
      
      public function returnItem(param1:Object) : void
      {
         --this.fIndex;
         this.free[this.fIndex] = param1;
      }
   }
}
