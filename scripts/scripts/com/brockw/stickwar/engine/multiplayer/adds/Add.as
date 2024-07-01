package com.brockw.stickwar.engine.multiplayer.adds
{
      import flash.display.MovieClip;
      
      public class Add extends MovieClip
      {
             
            
            internal var manager:AddManager;
            
            public var addShowTime:Number;
            
            public function Add(param1:AddManager)
            {
                  this.manager = param1;
                  super();
            }
            
            public function update() : void
            {
            }
            
            public function enter() : void
            {
            }
            
            public function leave() : void
            {
            }
      }
}
