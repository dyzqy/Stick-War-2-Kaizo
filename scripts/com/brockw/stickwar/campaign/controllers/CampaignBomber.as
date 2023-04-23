package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Bomber;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignBomber extends CampaignController
   {
      
      private static const MIN_NUM_BOMBERS:int = 0;
      
      public static const MAX_NUM_BOMBERS:int = 10;
      
      private static const FREQUENCY_SPAWN_1:int = 30;
      
      private static const FREQUENCY_SPAWN_2:int = 30;
      
      private static const FREQUENCY_SPAWN_3:int = 60;
      
      private static const FREQUENCY_SPAWN_4:int = 75;
      
      private static const FREQUENCY_UPDATE:int = 60;
       
      
      private var isTooLate:Boolean = true;
      
      private var frames:int;
      
      private var message:InGameMessage;
      
      private var INCREASE_FREQUENCY:int = 1;
      
      private var FrequencyDecreaseCounter:int = 0;
      
      private var numToSpawn:int = 1;
      
      public function CampaignBomber(param1:GameScreen)
      {
         super(param1);
         this.frames = 0;
         this.numToSpawn = MIN_NUM_BOMBERS;
         this.respect = 0.000001;
      }
      
      override public function update(param1:GameScreen) : void
      {
         CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
         var u1:Unit = null;
         var u2:Unit = null;
         var u3:Unit = null;
         var u4:Unit = null;
         var u5:Unit = null;
         var enemyStatue:Statue = param1.team.enemyTeam.statue;
         param1.isFastForward = false;
         param1.userInterface.hud.hud.fastForward.visible = false;
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
            this.message = new InGameMessage("",param1.game);
            this.message.x = param1.game.stage.stageWidth / 2;
            this.message.y = param1.game.stage.stageHeight / 4 - 75;
            this.message.scaleX *= 1.3;
            this.message.scaleY *= 1;
            param1.addChild(this.message);
            this.message.setMessage("15 mins before fireworks!","");
            this.frames = 0;
         }
         if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
         {
            enemyStatue.protect(600);
            enemyStatue.health += 1300;
            enemyStatue.maxHealth = 2000;
            enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
            this.SummonBomber(u3,param1,"nukeBomber",5,param1.team.enemyTeam,true);
            this.SummonBomber(u4,param1,"poisonBomber",2,param1.team.enemyTeam,true);
            this.SummonGiant(u5,param1,1,team.enemyTeam,true);
            this.INCREASE_FREQUENCY = 2;
            this.reinforcements = true;
         }
         if(param1.game.frame % (30 * (FREQUENCY_SPAWN_2 - 2 * this.FrequencyDecreaseCounter)) == 0)
         {
            this.SummonBomber(u2,param1,"fastBomber",1,param1.team.enemyTeam,true);
         }
         if(param1.game.frame % (30 * FREQUENCY_SPAWN_1) == 0)
         {
            this.SummonBomber(u1,param1,"armoredBomber",this.numToSpawn,param1.team.enemyTeam,true);
         }
         if(param1.game.frame % (30 * (FREQUENCY_SPAWN_3 / this.INCREASE_FREQUENCY)) == 0)
         {
            if(this.numToSpawn > 1)
            {
               this.SummonBomber(u3,param1,"nukeBomber",1,param1.team.enemyTeam,true);
            }
         }
         if(param1.game.frame % (30 * FREQUENCY_SPAWN_4) == 0)
         {
            if(this.numToSpawn > 1)
            {
               this.SummonBomber(u4,param1,"poisonBomber",1,param1.team.enemyTeam,true);
            }
         }
         if(param1.game.frame > 30 * 60 * 15)
         {
            this.INCREASE_FREQUENCY = 60;
         }
         if(param1.game.frame % (30 * FREQUENCY_UPDATE) == 30)
         {
            if(this.numToSpawn < MAX_NUM_BOMBERS)
            {
               ++this.numToSpawn;
            }
            if(this.FrequencyDecreaseCounter < 10)
            {
               ++this.FrequencyDecreaseCounter;
            }
         }
         param1.game.team.enemyTeam.attack(true);
      }
      
      public function SummonGiant(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
      {
         var i:int = 0;
         while(i < copies)
         {
            if(teamSpawn.enemyTeam.population <= 73 || ignorePop)
            {
               u1 = Giant(param1.game.unitFactory.getUnit(Unit.U_GIANT));
               param1.team.enemyTeam.spawn(u1,param1.game);
               param1.team.enemyTeam.population += 7;
               i++;
            }
         }
      }
      
      public function SummonBomber(u1:Unit, param1:GameScreen, bomberName:String, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
      {
         var i:int = 0;
         while(i < copies)
         {
            if(teamSpawn.enemyTeam.population <= 79 || ignorePop)
            {
               u1 = Bomber(param1.game.unitFactory.getUnit(Unit.U_BOMBER));
               u1.bomberType = bomberName;
               param1.team.enemyTeam.spawn(u1,param1.game);
               ++param1.team.enemyTeam.population;
               i++;
            }
         }
      }
   }
}
