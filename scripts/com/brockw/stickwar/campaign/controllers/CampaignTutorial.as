package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Miner;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Statue;
   import com.brockw.stickwar.engine.units.Unit;
   
   public class CampaignTutorial extends CampaignController
   {
       
      
      private var message:InGameMessage;
      
      private var frames:int;
      
      private var spawnNumber:int;
      
      private var reinforcements:Boolean = false;
      
      private var counter:int = 1;
      
      public function CampaignTutorial(param1:GameScreen)
      {
         super(param1);
         this.respect = 0.6;
      }
      
      override public function update(param1:GameScreen) : void
      {
         var u:Unit = null;
         var spear:Unit = null;
         var miner:Unit = null;
         var time:int = 0;
         var idk:int = 0;
         param1.isFastForward = false;
         param1.userInterface.hud.hud.fastForward.visible = false;
         if(param1.game.frame % (30 * 60) == 0)
         {
            this.SummonSpearton(spear,param1,this.counter,param1.team.enemyTeam,false,"");
            if(this.counter < 7)
            {
               ++this.counter;
            }
         }
         var enemyStatue:Statue = null;
         enemyStatue = param1.team.enemyTeam.statue;
         if(enemyStatue.health <= enemyStatue.maxHealth / 2 && enemyStatue.maxHealth != 2000 && !this.reinforcements)
         {
            enemyStatue.protect(600);
            enemyStatue.health += 1300;
            enemyStatue.maxHealth = 2000;
            enemyStatue.healthBar.totalHealth = enemyStatue.maxHealth;
            this.SummonSpearton(spear,param1,10,param1.team.enemyTeam,true,"");
            this.reinforcements = true;
         }
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
            this.message.setMessage("It\'s not too late to back down and repent","");
            this.frames = 0;
         }
         param1.game.team.enemyTeam.attack(true);
      }
      
      public function SummonSpearton(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean, name:String) : void
      {
         var i:int = 0;
         while(i < copies)
         {
            if(teamSpawn.population <= 77 || ignorePop)
            {
               u1 = Spearton(param1.game.unitFactory.getUnit(Unit.U_SPEARTON));
               u1.speartonType = name;
               teamSpawn.spawn(u1,param1.game);
               teamSpawn.population += 3;
               i++;
            }
         }
      }
      
      public function SummonMiner(u1:Unit, param1:GameScreen, copies:int, teamSpawn:Team, ignorePop:Boolean) : void
      {
         var i:int = 0;
         while(i < copies)
         {
            if(teamSpawn.enemyTeam.population <= 79 || ignorePop)
            {
               u1 = Miner(param1.game.unitFactory.getUnit(Unit.U_MINER));
               teamSpawn.spawn(u1,param1.game);
               ++teamSpawn.population;
               i++;
            }
         }
      }
   }
}
