package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.*;
      
      public class CampaignKnight extends CampaignController
      {
             
            
            private var message:InGameMessage;
            
            private var frames:int;
            
            public function CampaignKnight(param1:GameScreen)
            {
                  super(param1);
            }
            
            override public function update(param1:GameScreen) : void
            {
                  if(Boolean(this.message) && param1.contains(this.message))
                  {
                        this.message.update();
                        if(this.frames++ > 30 * 5)
                        {
                              param1.removeChild(this.message);
                        }
                  }
                  else if(!this.message)
                  {
                        if(Boolean(param1.team.forwardUnit) && param1.team.forwardUnit.px > param1.game.map.width / 2)
                        {
                              this.message = new InGameMessage("",param1.game);
                              this.message.x = param1.game.stage.stageWidth / 2;
                              this.message.y = param1.game.stage.stageHeight / 4 - 75;
                              this.message.scaleX *= 1.3;
                              this.message.scaleY *= 1.3;
                              param1.addChild(this.message);
                              this.message.setMessage("Press SPACE to select all of your attacking units","");
                              this.frames = 0;
                        }
                  }
            }
      }
}
