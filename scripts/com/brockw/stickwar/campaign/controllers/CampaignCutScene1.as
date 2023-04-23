package com.brockw.stickwar.campaign.controllers
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.campaign.CampaignGameScreen;
   import com.brockw.stickwar.campaign.InGameMessage;
   import com.brockw.stickwar.engine.Ai.command.HoldCommand;
   import com.brockw.stickwar.engine.Ai.command.MoveCommand;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Tech;
   import com.brockw.stickwar.engine.units.EnslavedGiant;
   import com.brockw.stickwar.engine.units.Giant;
   import com.brockw.stickwar.engine.units.Medusa;
   import com.brockw.stickwar.engine.units.Spearton;
   import com.brockw.stickwar.engine.units.Swordwrath;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class CampaignCutScene1 extends CampaignController
   {
      
      private static const S_BEFORE_CUTSCENE:int = -1;
      
      private static const S_FADE_OUT:int = 0;
      
      private static const S_FADE_IN:int = 1;
      
      private static const S_MEDUSA_LEAVES:int = 3;
      
      private static const S_ENTER_REBELS:int = 4;
      
      private static const S_END:int = 6;
      
      private static const S_MEDUSA_TALKS_1:int = 2;
      
      private static const S_MEDUSA_TALKS_2:int = 7;
      
      private static const S_MEDUSA_TALKS_3:int = 8;
      
      private static const S_MEDUSA_TALKS_4:int = 9;
      
      private static const S_REBELS_TALK_1:int = 5;
      
      private static const S_REBELS_TALK_2:int = 10;
      
      private static const S_REBELS_TALK_3:int = 11;
      
      private static const S_REBELS_TALK_4:int = 12;
       
      
      private var state:int;
      
      private var counter:int;
      
      private var overlay:MovieClip;
      
      private var medusa:Unit;
      
      private var message:InGameMessage;
      
      private var rebelsAreEvil:Boolean;
      
      private var rebels:Array;
      
      public function CampaignCutScene1(param1:GameScreen)
      {
         super(param1);
         this.state = S_BEFORE_CUTSCENE;
         this.counter = 0;
         this.overlay = new MovieClip();
         this.overlay.graphics.beginFill(0,1);
         this.overlay.graphics.drawRect(0,0,850,750);
         this.rebels = [];
         this.rebelsAreEvil = true;
         this.respect = 0.000001;
      }
      
      override public function update(param1:GameScreen) : void
      {
         param1.game.team.enemyTeam.tech.isResearchedMap[Tech.TOWER_SPAWN_I] = true;
         CampaignGameScreen(param1).enemyTeamAi.setRespectForEnemy(this.respect);
         var _loc2_:Unit = null;
         var _loc3_:ColorTransform = null;
         var _loc4_:int = 0;
         var _loc5_:Giant = null;
         var _loc6_:StickWar = null;
         var _loc7_:Unit = null;
         var _loc8_:Number = NaN;
         var _loc9_:MoveCommand = null;
         var _loc10_:int = 0;
         param1.isFastForward = false;
         param1.userInterface.hud.hud.fastForward.visible = false;
         if(this.message)
         {
            this.message.update();
         }
         param1.team.enemyTeam.statue.health = 180;
         param1.team.enemyTeam.gold = 0;
         if(this.medusa)
         {
            this.medusa.faceDirection(-1);
         }
         if(!this.rebelsAreEvil)
         {
            for each(_loc2_ in this.rebels)
            {
               _loc3_ = _loc2_.mc.transform.colorTransform;
               _loc3_.redOffset = 0;
               _loc3_.blueOffset = 0;
               _loc3_.greenOffset = 0;
               _loc2_.mc.transform.colorTransform = _loc3_;
            }
         }
         if(this.state != S_BEFORE_CUTSCENE)
         {
            param1.isFastForward = false;
            param1.userInterface.hud.hud.fastForward.visible = false;
         }
         else
         {
            param1.userInterface.hud.hud.fastForward.visible = true;
         }
         if(this.state != S_BEFORE_CUTSCENE)
         {
            for each(_loc2_ in param1.game.team.units)
            {
               _loc2_.ai.mayAttack = false;
            }
            for each(_loc2_ in param1.game.team.enemyTeam.units)
            {
               _loc2_.ai.mayAttack = false;
            }
            param1.userInterface.selectedUnits.clear();
            CampaignGameScreen(param1).doAiUpdates = false;
            param1.userInterface.isGlobalsEnabled = false;
         }
         if(this.state == S_BEFORE_CUTSCENE)
         {
            param1.game.team.enemyTeam.attack(true);
            _loc4_ = 0;
            if(param1.team.enemyTeam.unitGroups[Unit.U_GIANT])
            {
               _loc4_ = 1;
               if((_loc5_ = param1.team.enemyTeam.unitGroups[Unit.U_GIANT][0]) == null || _loc5_.health == 0)
               {
                  _loc4_ = 0;
               }
            }
            if(_loc4_ == 0)
            {
               this.state = S_FADE_OUT;
               param1.game.team.enemyTeam.attack(false);
               this.counter = 0;
               param1.addChild(this.overlay);
               this.overlay.alpha = 0;
               param1.main.kongregateReportStatistic("killAGiant",1);
               trace("Report Kill a giant");
            }
         }
         else if(this.state == S_FADE_OUT)
         {
            ++this.counter;
            this.overlay.alpha = this.counter / 60;
            if(this.counter > 45)
            {
               param1.game.team.cleanUpUnits();
               param1.game.team.enemyTeam.cleanUpUnits();
               param1.game.team.gold = param1.game.team.mana = 0;
               param1.game.team.enemyTeam.gold = param1.game.team.enemyTeam.mana = 0;
            }
            if(this.counter > 60)
            {
               this.state = S_FADE_IN;
               this.counter = 0;
               _loc6_ = param1.game;
               _loc7_ = EnslavedGiant(_loc6_.unitFactory.getUnit(Unit.U_ENSLAVED_GIANT));
               param1.team.spawn(_loc7_,_loc6_);
               _loc7_.px = param1.team.enemyTeam.statue.x - 200;
               _loc7_.py = _loc6_.map.height / 2;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_.ai.mayAttack = false;
               _loc7_ = Swordwrath(_loc6_.unitFactory.getUnit(Unit.U_SWORDWRATH));
               param1.team.spawn(_loc7_,_loc6_);
               _loc7_.px = param1.team.enemyTeam.statue.x - 200 + 50;
               _loc7_.py = _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Swordwrath(_loc6_.unitFactory.getUnit(Unit.U_SWORDWRATH));
               param1.team.spawn(_loc7_,_loc6_);
               _loc7_.px = param1.team.enemyTeam.statue.x - 200 + 50;
               _loc7_.py = 3 * _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Spearton(_loc6_.unitFactory.getUnit(Unit.U_SPEARTON));
               param1.team.spawn(_loc7_,_loc6_);
               _loc7_.px = param1.team.enemyTeam.statue.x - 200 - 50;
               _loc7_.py = _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Spearton(_loc6_.unitFactory.getUnit(Unit.U_SPEARTON));
               param1.team.spawn(_loc7_,_loc6_);
               _loc7_.px = param1.team.enemyTeam.statue.x - 200 - 50;
               _loc7_.py = 3 * _loc6_.map.height / 4;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_ = Medusa(_loc6_.unitFactory.getUnit(Unit.U_MEDUSA));
               param1.team.enemyTeam.spawn(_loc7_,_loc6_);
               this.medusa = _loc7_;
               _loc7_.ai.setCommand(_loc6_,new HoldCommand(_loc6_));
               _loc7_.flyingHeight = 380;
               _loc7_.pz = -_loc7_.flyingHeight;
               _loc7_.py = _loc6_.map.height / 2;
               _loc7_.y = 0;
               _loc7_.px = param1.team.enemyTeam.homeX + param1.team.enemyTeam.direction * 100;
               _loc7_.x = _loc7_.px;
               _loc7_.faceDirection(-1);
            }
         }
         else if(this.state == S_FADE_IN)
         {
            param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 350;
            param1.game.screenX = param1.game.team.enemyTeam.statue.x - 350;
            ++this.counter;
            this.overlay.alpha = (60 - this.counter) / 60;
            if(this.counter > 60)
            {
               this.state = S_MEDUSA_TALKS_1;
               param1.removeChild(this.overlay);
               this.counter = 0;
               this.message = new InGameMessage("",param1.game);
               this.message.x = param1.game.stage.stageWidth / 2;
               this.message.y = param1.game.stage.stageHeight / 4 - 75;
               this.message.scaleX *= 1.3;
               this.message.scaleY *= 1.3;
               param1.addChild(this.message);
            }
         }
         else if(this.state == S_MEDUSA_TALKS_1)
         {
            param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 350;
            param1.game.screenX = param1.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("You fools thought Inamorta belonged to you!","",0,"medusaVoice1");
            ++this.counter;
            if(this.counter > 150)
            {
               this.state = S_MEDUSA_TALKS_2;
               this.counter = 0;
            }
         }
         else if(this.state == S_MEDUSA_TALKS_2)
         {
            param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 350;
            param1.game.screenX = param1.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("We\'ve been here all along biding our time growing with power while your armys destroy themselves in battles over land that belongs to me!","",0,"medusaVoice2");
            this.counter = 0;
            param1.addChild(this.overlay);
            this.overlay.alpha = 0;
            if(this.message.hasFinishedPlayingSound())
            {
               this.state = S_MEDUSA_TALKS_3;
               this.counter = 0;
            }
         }
         else if(this.state == S_MEDUSA_TALKS_3)
         {
            param1.game.soundManager.playSoundFullVolumeRandom("medusaPetrifySound",1);
            param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 350;
            param1.game.screenX = param1.game.team.enemyTeam.statue.x - 350;
            this.message.setMessage("But now you have enslaved my babies and I will wait no more... now you will feel the wrath of the Chaos Empire!","",0,"medusaVoice3");
            if(this.message.hasFinishedPlayingSound())
            {
               ++this.counter;
               this.overlay.alpha = this.counter / 60;
               if(this.counter > 60)
               {
                  this.counter = 0;
                  param1.game.soundManager.playSoundFullVolumeRandom("medusaPetrifySound",1);
                  this.state = S_MEDUSA_LEAVES;
               }
            }
         }
         else if(this.state == S_MEDUSA_LEAVES)
         {
            this.message.setMessage("","",0,"medusaPetrifySound");
            if(this.message.hasFinishedPlayingSound())
            {
               param1.team.statue.health = 0;
            }
         }
         super.update(param1);
      }
   }
}
