package com.brockw.stickwar.engine
{
      import com.brockw.stickwar.*;
      import flash.display.*;
      import flash.geom.*;
      import flash.utils.*;
      
      public class Background extends Entity
      {
             
            
            private var layers:Vector.<MovieClip>;
            
            private var animatedLayers:Vector.<MovieClip>;
            
            private var _mapLength:int;
            
            private var time:Number;
            
            private var splitLayers:Vector.<Vector.<Bitmap>>;
            
            private var splitLayersOnScreen:Vector.<int>;
            
            private var layerContainers:Vector.<Sprite>;
            
            private var animatedLayerWidths:Array;
            
            public function Background(param1:Vector.<MovieClip>, param2:StickWar)
            {
                  var _loc4_:MovieClip = null;
                  var _loc5_:Vector.<Bitmap> = null;
                  var _loc6_:int = 0;
                  var _loc7_:Rectangle = null;
                  var _loc8_:int = 0;
                  var _loc9_:Sprite = null;
                  var _loc10_:BitmapData = null;
                  var _loc11_:Bitmap = null;
                  this.splitLayers = new Vector.<Vector.<Bitmap>>();
                  this.animatedLayerWidths = [];
                  this.splitLayersOnScreen = new Vector.<int>();
                  this.layerContainers = new Vector.<Sprite>();
                  this.layers = new Vector.<MovieClip>();
                  this.animatedLayers = new Vector.<MovieClip>();
                  this.mapLength = 0;
                  ++param2.main.loadingFraction;
                  var _loc3_:int = int(param1.length - 1);
                  while(_loc3_ >= 0)
                  {
                        _loc4_ = param1[_loc3_];
                        ++param2.main.loadingFraction;
                        if(_loc4_.width > this.mapLength)
                        {
                              this.mapLength = _loc4_.width;
                        }
                        if(_loc4_.totalFrames > 1)
                        {
                              this.animatedLayers.push(_loc4_);
                              addChild(_loc4_);
                              this.animatedLayerWidths.push(_loc4_.width);
                        }
                        else
                        {
                              this.layers.push(_loc4_);
                              ++param2.main.loadingFraction;
                              _loc5_ = new Vector.<Bitmap>();
                              ++param2.main.loadingFraction;
                              _loc6_ = param2.stage.stageWidth + 1;
                              _loc7_ = new Rectangle(0,0,_loc6_,param2.stage.stageHeight);
                              ++param2.main.loadingFraction;
                              _loc8_ = 0;
                              while(_loc8_ < _loc4_.width)
                              {
                                    _loc7_.x = 0;
                                    _loc10_ = new BitmapData(_loc6_,param2.stage.stageHeight,true,0);
                                    ++param2.main.loadingFraction;
                                    _loc10_.draw(_loc4_,new Matrix(1,0,0,1,-_loc8_,0),null,null,_loc7_,false);
                                    ++param2.main.loadingFraction;
                                    _loc11_ = new Bitmap(_loc10_);
                                    ++param2.main.loadingFraction;
                                    _loc5_.push(_loc11_);
                                    _loc11_.cacheAsBitmap = true;
                                    ++param2.main.loadingFraction;
                                    _loc11_.x = _loc8_;
                                    _loc8_ += param2.stage.stageWidth;
                              }
                              this.splitLayersOnScreen.push(-1);
                              ++param2.main.loadingFraction;
                              this.splitLayers.push(_loc5_);
                              ++param2.main.loadingFraction;
                              _loc9_ = new Sprite();
                              this.layerContainers.push(_loc9_);
                              addChild(_loc9_);
                              ++param2.main.loadingFraction;
                        }
                        _loc3_--;
                  }
                  this.time = 0;
                  py = 0;
                  super();
            }
            
            override public function cleanUp() : void
            {
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:Number = NaN;
                  var _loc4_:* = undefined;
                  var _loc5_:int = 0;
                  _loc2_ = 0;
                  while(_loc2_ < this.layers.length)
                  {
                        if(param1.gameScreen.hasMovingBackground || _loc2_ == this.layers.length - 1 || param1.frame == 1)
                        {
                              _loc3_ = param1.screenX / (this.mapLength - stage.stageWidth);
                              _loc4_ = -_loc3_ * (this.layers[_loc2_].width - stage.stageWidth);
                              if((_loc5_ = Math.floor(param1.screenX / this.mapLength * this.splitLayers[_loc2_].length)) >= this.splitLayers[_loc2_].length)
                              {
                                    _loc5_ = this.splitLayers[_loc2_].length - 1;
                              }
                              if(_loc5_ < 0)
                              {
                                    _loc5_ = 0;
                              }
                              if(_loc5_ != this.splitLayersOnScreen[_loc2_])
                              {
                                    if(this.splitLayersOnScreen[_loc2_] != -1)
                                    {
                                          this.removeAround(_loc2_,this.splitLayersOnScreen[_loc2_]);
                                    }
                                    this.addAround(_loc2_,_loc5_,_loc4_);
                                    this.splitLayersOnScreen[_loc2_] = _loc5_;
                              }
                              else
                              {
                                    this.moveAround(_loc2_,_loc5_,_loc4_);
                              }
                        }
                        _loc2_++;
                  }
                  _loc2_ = 0;
                  while(_loc2_ < this.animatedLayers.length)
                  {
                        _loc3_ = param1.screenX / (this.mapLength - stage.stageWidth);
                        _loc4_ = -_loc3_ * (this.animatedLayerWidths[_loc2_] - stage.stageWidth);
                        this.animatedLayers[_loc2_].x = _loc4_;
                        if(param1.gameScreen.hasMovingBackground)
                        {
                        }
                        _loc2_++;
                  }
            }
            
            public function removeAround(param1:int, param2:int) : void
            {
                  if(param2 == -1)
                  {
                        return;
                  }
                  if(param2 - 1 >= 0)
                  {
                        this.layerContainers[param1].removeChild(this.splitLayers[param1][param2 - 1]);
                  }
                  this.layerContainers[param1].removeChild(this.splitLayers[param1][param2]);
                  if(param2 + 1 < this.splitLayers[param1].length)
                  {
                        this.layerContainers[param1].removeChild(this.splitLayers[param1][param2 + 1]);
                  }
            }
            
            public function moveAround(param1:int, param2:int, param3:Number) : void
            {
                  if(param2 == -1)
                  {
                        return;
                  }
                  if(param2 - 1 >= 0)
                  {
                        this.splitLayers[param1][param2 - 1].x = param3 + (param2 - 1) * stage.stageWidth;
                  }
                  this.splitLayers[param1][param2].x = param3 + param2 * stage.stageWidth;
                  if(param2 + 1 < this.splitLayers[param1].length)
                  {
                        this.splitLayers[param1][param2 + 1].x = param3 + (param2 + 1) * stage.stageWidth;
                  }
            }
            
            public function addAround(param1:int, param2:int, param3:Number) : void
            {
                  if(param2 == -1)
                  {
                        return;
                  }
                  if(param2 - 1 >= 0)
                  {
                        this.layerContainers[param1].addChild(this.splitLayers[param1][param2 - 1]);
                        this.splitLayers[param1][param2 - 1].x = param3 + (param2 - 1) * stage.stageWidth;
                  }
                  this.layerContainers[param1].addChild(this.splitLayers[param1][param2]);
                  this.splitLayers[param1][param2].x = param3 + param2 * stage.stageWidth;
                  if(param2 + 1 < this.splitLayers[param1].length)
                  {
                        this.layerContainers[param1].addChild(this.splitLayers[param1][param2 + 1]);
                        this.splitLayers[param1][param2 + 1].x = param3 + (param2 + 1) * stage.stageWidth;
                  }
            }
            
            public function minScreenX() : int
            {
                  return 0;
            }
            
            public function maxScreenX() : int
            {
                  return this.mapLength - stage.stageWidth;
            }
            
            public function get mapLength() : int
            {
                  return this._mapLength;
            }
            
            public function set mapLength(param1:int) : void
            {
                  this._mapLength = param1;
            }
      }
}
