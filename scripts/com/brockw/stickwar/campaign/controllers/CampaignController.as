package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   
   public class CampaignController
   {
       
      
      public var comment:String = "--------------------";
      
      public var spawnNumber:int;
      
      public var reinforcements:Boolean = false;
      
      public var currentLevelNumber:int;
      
      public var respect:int;
      
      public var twoMinTimer:int;
      
      public var twoMinConstant:int;
      
      public function CampaignController(param1:GameScreen)
      {
         this.respect = 0;
         this.currentLevelNumber = param1.stageLevel.levelNumber;
         super();
      }
      
      public function update(param1:GameScreen) : void
      {
         CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
      }
   }
}
