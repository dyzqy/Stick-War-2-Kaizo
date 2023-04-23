package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.*;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignDeads extends CampaignController
   {
       
      
      private var message:InGameMessage;
      
      private var frames:int;
      
      public function CampaignDeads(param1:GameScreen)
      {
         super(param1);
      }
      
      override public function update(param1:GameScreen) : void
      {
         var _loc2_:Unit = null;
         if(this.message && param1.contains(this.message))
         {
            this.message.update();
            if(this.frames++ > 30 * 5)
            {
               param1.removeChild(this.message);
            }
         }
         else if(!this.message)
         {
            for each(_loc2_ in param1.team.units)
            {
               if(_loc2_.isPoisoned())
               {
                  this.message = new InGameMessage("",param1.game);
                  this.message.x = param1.game.stage.stageWidth / 2;
                  this.message.y = param1.game.stage.stageHeight / 4 - 75;
                  this.message.scaleX *= 1.3;
                  this.message.scaleY *= 1.3;
                  param1.addChild(this.message);
                  this.message.setMessage("A unit has been poisoned. Garrisoning this unit will cure its poison","");
                  this.frames = 0;
                  break;
               }
            }
         }
         CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(0.8);
      }
   }
}
