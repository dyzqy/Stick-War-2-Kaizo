package com.brockw.ds
{
   public class Heap
   {
       
      
      private var currentSize:int;
      
      private var array:Vector.<com.brockw.ds.Comparable>;
      
      public function Heap(param1:int)
      {
         super();
         this.array = new Vector.<Comparable>(param1,false);
         this.currentSize = 0;
      }
      
      public function clear() : void
      {
         this.makeEmpty();
      }
      
      public function size() : int
      {
         return this.currentSize;
      }
      
      public function insert(param1:com.brockw.ds.Comparable) : void
      {
         var _loc2_:int = int(++this.currentSize);
         while(_loc2_ > 1 && param1.compare(this.array[Math.floor(_loc2_ / 2)]) < 0)
         {
            this.array[_loc2_] = this.array[Math.floor(_loc2_ / 2)];
            _loc2_ = Math.floor(_loc2_ / 2);
         }
         this.array[_loc2_] = param1;
      }
      
      public function findMin() : com.brockw.ds.Comparable
      {
         if(this.isEmpty())
         {
            throw new Error("Heap: Can not find the min");
         }
         return this.array[1];
      }
      
      public function pop() : com.brockw.ds.Comparable
      {
         if(this.isEmpty())
         {
            throw new Error("Heap: Can not delete min");
         }
         var _loc1_:com.brockw.ds.Comparable = this.findMin();
         this.array[1] = this.array[this.currentSize--];
         this.percolateDown(1);
         return _loc1_;
      }
      
      private function buildHeap() : void
      {
         var _loc1_:int = this.currentSize / 2;
         while(_loc1_ > 0)
         {
            this.percolateDown(_loc1_);
            _loc1_--;
         }
      }
      
      public function isEmpty() : Boolean
      {
         return this.currentSize == 0;
      }
      
      public function makeEmpty() : void
      {
         this.currentSize = 0;
      }
      
      private function percolateDown(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:com.brockw.ds.Comparable = this.array[param1];
         while(param1 * 2 <= this.currentSize)
         {
            _loc2_ = param1 * 2;
            if(_loc2_ != this.currentSize && this.array[_loc2_ + 1].compare(this.array[_loc2_]) < 0)
            {
               _loc2_++;
            }
            if(this.array[_loc2_].compare(_loc3_) >= 0)
            {
               break;
            }
            this.array[param1] = this.array[_loc2_];
            param1 = _loc2_;
         }
         this.array[param1] = _loc3_;
      }
   }
}
