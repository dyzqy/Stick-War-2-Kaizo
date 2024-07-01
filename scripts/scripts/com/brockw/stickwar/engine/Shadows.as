package com.brockw.stickwar.engine
{
      import com.brockw.stickwar.engine.maps.Map;
      import com.brockw.stickwar.engine.projectile.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      import flash.filters.*;
      import flash.geom.ColorTransform;
      import flash.geom.Matrix;
      import flash.geom.Rectangle;
      
      public class Shadows extends Bitmap
      {
             
            
            private var shadowBitmap:BitmapData;
            
            private var map:Map;
            
            private var shadowTransform:Matrix;
            
            private var rec:Rectangle;
            
            private var c:ColorTransform;
            
            public function Shadows(param1:Map)
            {
                  this.shadowBitmap = new BitmapData(param1.screenWidth,param1.height,true,0);
                  this.map = param1;
                  this.shadowTransform = new Matrix();
                  this.rec = new Rectangle(0,0,param1.screenWidth,param1.height);
                  this.c = new ColorTransform(0,0,0,1,0,0,0,0);
                  super(this.shadowBitmap);
            }
            
            public function update(param1:StickWar) : void
            {
                  var _loc3_:Entity = null;
                  this.shadowBitmap.fillRect(this.rec,0);
                  var _loc2_:int = 0;
                  while(_loc2_ < param1.battlefield.numChildren)
                  {
                        _loc3_ = Entity(param1.battlefield.getChildAt(_loc2_));
                        if(_loc3_ is Unit)
                        {
                              if(_loc3_ is Unit && !(_loc3_ is Statue))
                              {
                                    Unit(_loc3_).healthBar.visible = false;
                              }
                              this.shadowTransform.identity();
                              if(_loc3_ is Wingidon)
                              {
                                    this.shadowTransform.scale(_loc3_.scaleX * 1,1 * -1 * _loc3_.scaleY + Math.pow(Math.abs(_loc3_.x - this.map.width / 2) / 1000,1.5) * 0.2);
                                    this.shadowTransform.translate(_loc3_.x - param1.screenX,Wingidon(_loc3_).py);
                              }
                              else if(_loc3_ is Projectile)
                              {
                                    this.shadowTransform.scale(_loc3_.scaleX * 1,1 * -1 * _loc3_.scaleY + Math.pow(Math.abs(_loc3_.x - this.map.width / 2) / 1000,1.5) * 0.2);
                                    this.shadowTransform.translate(_loc3_.x - param1.screenX,Projectile(_loc3_).py);
                              }
                              else
                              {
                                    this.shadowTransform.scale(_loc3_.scaleX,-1 * _loc3_.scaleY + Math.pow(Math.abs(_loc3_.px - this.map.width / 2) / 1000,1.5) * 0.2);
                                    this.shadowTransform.translate(_loc3_.px - param1.screenX,_loc3_.py);
                              }
                              this.shadowTransform.c = Math.tan((_loc3_.x - this.map.width / 2) / 1000 * -35 * ((1 - 1) * 0.5 + 0.5) * Math.PI / 180);
                              this.shadowBitmap.draw(_loc3_,this.shadowTransform,this.c);
                              if(_loc3_ is Unit && !(_loc3_ is Statue))
                              {
                                    Unit(_loc3_).healthBar.visible = true;
                              }
                        }
                        _loc2_++;
                  }
            }
      }
}
