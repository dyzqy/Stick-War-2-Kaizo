package com.brockw.stickwar.engine
{
      public class HelpMessage extends helpMessageMc
      {
             
            
            private var changeFrame:int;
            
            private var game:StickWar;
            
            public function HelpMessage(param1:StickWar)
            {
                  super();
                  this.game = param1;
                  this.changeFrame = -1000;
            }
            
            public function showMessage(param1:String) : void
            {
                  text.alpha = 1;
                  text.text = param1;
                  this.changeFrame = this.game.frame;
            }
            
            public function update(param1:StickWar) : void
            {
                  if(param1.frame - this.changeFrame > 30 * 2.5)
                  {
                        text.alpha = 0;
                  }
                  else if(param1.frame - this.changeFrame > 30 * 1.5)
                  {
                        text.alpha += (0 - text.alpha) * 0.1;
                  }
            }
      }
}
