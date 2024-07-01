package com.brockw.stickwar.engine
{
      import com.brockw.stickwar.engine.units.Wall;
      import flash.utils.*;
      
      public class SpatialHash
      {
             
            
            private var partitions:Vector.<Vector.<Entity>>;
            
            private var partitionSizes:Vector.<int>;
            
            private var width:Number;
            
            private var height:Number;
            
            private var boxWidth:Number;
            
            private var boxHeight:Number;
            
            private var cols:int;
            
            private var rows:int;
            
            internal var visited:Dictionary;
            
            internal var game:StickWar;
            
            public function SpatialHash(param1:StickWar, param2:Number, param3:Number, param4:Number, param5:Number, param6:int)
            {
                  var _loc8_:int = 0;
                  super();
                  this.game = param1;
                  this.partitions = new Vector.<Vector.<Entity>>(param2 / param4 * param3 / param5,false);
                  this.partitionSizes = new Vector.<int>(param2 / param4 * param3 / param5,false);
                  this.visited = new Dictionary();
                  this.width = param2;
                  this.height = param3;
                  this.boxWidth = param4;
                  this.boxHeight = param5;
                  this.rows = param3 / param5;
                  this.cols = param2 / param4;
                  var _loc7_:int = 0;
                  while(_loc7_ < this.rows)
                  {
                        _loc8_ = 0;
                        while(_loc8_ < this.cols)
                        {
                              this.partitions[this.cols * _loc7_ + _loc8_] = new Vector.<Entity>(param6,false);
                              this.partitionSizes[this.cols * _loc7_ + _loc8_] = 0;
                              _loc8_++;
                        }
                        _loc7_++;
                  }
            }
            
            public function cleanUp() : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:int = 0;
                  var _loc1_:int = 0;
                  while(_loc1_ < this.rows)
                  {
                        _loc2_ = 0;
                        while(_loc2_ < this.cols)
                        {
                              _loc3_ = 0;
                              while(_loc3_ < this.partitions[this.cols * _loc1_ + _loc2_].length)
                              {
                                    this.partitions[this.cols * _loc1_ + _loc2_][_loc3_] = null;
                                    _loc3_++;
                              }
                              this.partitions[this.cols * _loc1_ + _loc2_] = null;
                              _loc2_++;
                        }
                        _loc1_++;
                  }
                  this.partitions = null;
                  this.partitionSizes = null;
            }
            
            public function add(param1:Entity) : void
            {
                  var _loc2_:int = param1.px / this.boxWidth;
                  var _loc3_:int = param1.py / this.boxHeight;
                  if(_loc2_ < 0 || _loc2_ >= this.cols || _loc3_ < 0 || _loc3_ >= this.rows)
                  {
                        return;
                  }
                  Vector.<Entity>(this.partitions[this.cols * _loc3_ + _loc2_])[this.partitionSizes[this.cols * _loc3_ + _loc2_]] = param1;
                  ++this.partitionSizes[this.cols * _loc3_ + _loc2_];
                  if(_loc2_ > 0)
                  {
                        Vector.<Entity>(this.partitions[this.cols * _loc3_ + _loc2_ - 1])[this.partitionSizes[this.cols * _loc3_ + _loc2_ - 1]] = param1;
                        ++this.partitionSizes[this.cols * _loc3_ + _loc2_ - 1];
                  }
                  if(_loc3_ > 0)
                  {
                        Vector.<Entity>(this.partitions[this.cols * (_loc3_ - 1) + _loc2_])[this.partitionSizes[this.cols * (_loc3_ - 1) + _loc2_]] = param1;
                        ++this.partitionSizes[this.cols * (_loc3_ - 1) + _loc2_];
                  }
                  if(_loc3_ < this.rows - 1)
                  {
                        Vector.<Entity>(this.partitions[this.cols * (_loc3_ + 1) + _loc2_])[this.partitionSizes[this.cols * (_loc3_ + 1) + _loc2_]] = param1;
                        ++this.partitionSizes[this.cols * (_loc3_ + 1) + _loc2_];
                  }
                  if(_loc2_ < this.cols - 1)
                  {
                        Vector.<Entity>(this.partitions[this.cols * _loc3_ + _loc2_ + 1])[this.partitionSizes[this.cols * _loc3_ + _loc2_ + 1]] = param1;
                        ++this.partitionSizes[this.cols * _loc3_ + _loc2_ + 1];
                  }
            }
            
            public function mapInArea(param1:Number, param2:Number, param3:Number, param4:Number, param5:Function, param6:Boolean = true) : void
            {
                  var _loc10_:String = null;
                  var _loc11_:Wall = null;
                  var _loc12_:int = 0;
                  var _loc13_:int = 0;
                  var _loc7_:Number = Math.min(param1,param3);
                  var _loc8_:Number = Math.max(param1,param3);
                  if(param6)
                  {
                        for each(_loc11_ in this.game.teamA.walls)
                        {
                              if(_loc11_.px > _loc7_ && _loc11_.px < _loc8_)
                              {
                                    param5(_loc11_);
                              }
                        }
                        for each(_loc11_ in this.game.teamB.walls)
                        {
                              if(_loc11_.px > _loc7_ && _loc11_.px < _loc8_)
                              {
                                    param5(_loc11_);
                              }
                        }
                  }
                  param1 /= this.boxWidth;
                  param2 /= this.boxHeight;
                  param3 /= this.boxWidth;
                  param4 /= this.boxHeight;
                  var _loc9_:int = param1;
                  while(_loc9_ < param3)
                  {
                        _loc12_ = param2;
                        while(_loc12_ < param4)
                        {
                              if(!(this.cols * _loc12_ + _loc9_ < 0 || this.cols * _loc12_ + _loc9_ >= this.partitions.length))
                              {
                                    _loc13_ = 0;
                                    while(_loc13_ < this.partitionSizes[this.cols * _loc12_ + _loc9_])
                                    {
                                          if(!(this.partitions[this.cols * _loc12_ + _loc9_][_loc13_].id in this.visited))
                                          {
                                                param5(this.partitions[this.cols * _loc12_ + _loc9_][_loc13_]);
                                                this.visited[this.partitions[this.cols * _loc12_ + _loc9_][_loc13_].id] = 0;
                                          }
                                          _loc13_++;
                                    }
                              }
                              _loc12_++;
                        }
                        _loc9_++;
                  }
                  for(_loc10_ in this.visited)
                  {
                        delete this.visited[_loc10_];
                  }
            }
            
            public function getNearbyEntitys(param1:Entity) : Vector.<Entity>
            {
                  var _loc2_:int = param1.px / this.boxWidth;
                  var _loc3_:int = param1.py / this.boxHeight;
                  if(this.cols * _loc3_ + _loc2_ < 0 || this.cols * _loc3_ + _loc2_ >= this.partitions.length)
                  {
                        return new Vector.<Entity>();
                  }
                  return this.partitions[this.cols * _loc3_ + _loc2_];
            }
            
            public function getNearbyEntitysXY(param1:Number, param2:Number) : Vector.<Entity>
            {
                  param1 = Math.floor(param1 / this.boxWidth);
                  param2 = Math.floor(param2 / this.boxHeight);
                  if(this.cols * param2 + param1 < 0 || this.cols * param2 + param1 >= this.partitions.length)
                  {
                        return new Vector.<Entity>();
                  }
                  return this.partitions[this.cols * param2 + param1];
            }
            
            public function getNumberOfNearbyEntitysXY(param1:Number, param2:Number) : int
            {
                  param1 = Math.floor(param1 / this.boxWidth);
                  param2 = Math.floor(param2 / this.boxHeight);
                  if(this.cols * param2 + param1 < 0 || this.cols * param2 + param1 >= this.partitions.length)
                  {
                        return 0;
                  }
                  return this.partitionSizes[this.cols * param2 + param1];
            }
            
            public function getNumberOfNearbyEntitys(param1:Entity) : int
            {
                  var _loc2_:int = param1.px / this.boxWidth;
                  var _loc3_:int = param1.py / this.boxHeight;
                  if(this.cols * _loc3_ + _loc2_ < 0 || this.cols * _loc3_ + _loc2_ >= this.partitions.length)
                  {
                        return 0;
                  }
                  return this.partitionSizes[this.cols * _loc3_ + _loc2_];
            }
            
            public function clear() : void
            {
                  var _loc2_:int = 0;
                  var _loc1_:int = 0;
                  while(_loc1_ < this.rows)
                  {
                        _loc2_ = 0;
                        while(_loc2_ < this.cols)
                        {
                              this.partitionSizes[this.cols * _loc1_ + _loc2_] = 0;
                              _loc2_++;
                        }
                        _loc1_++;
                  }
            }
      }
}
