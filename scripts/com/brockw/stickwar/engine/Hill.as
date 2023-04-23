package com.brockw.stickwar.engine
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class Hill extends Entity
   {
      
      private static const scale:Number = 1;
      
      private static const statueArea:Number = 300;
       
      
      private var teamBar:Number;
      
      private var lastTeamBar:Number;
      
      private var hillMc:_hillMc;
      
      private var hillControlBar:com.brockw.stickwar.engine.HillControlBar;
      
      private var teamAThisTurn:int;
      
      private var teamBThisTurn:int;
      
      private var collectionFrequency:int;
      
      private var collectionRate:int;
      
      private var hillCaptureTime:int;
      
      public function Hill(param1:StickWar)
      {
         super();
         this.addChild(this.hillMc = new _hillMc());
         this.hillControlBar = new HillControlBar();
         addChild(this.hillControlBar);
         this.lastTeamBar = this.teamBar = 50;
         this.collectionRate = param1.xml.xml.hill.goldCollectionRate;
         this.collectionFrequency = param1.xml.xml.hill.frequency;
         this.hillCaptureTime = param1.xml.xml.towerCaptureTime;
         this.hillMc.stop();
      }
      
      public function init(param1:int, param2:int, param3:StickWar) : void
      {
         this.x = param1;
         this.y = param2;
         this.px = param1;
         this.py = param2;
         var _loc4_:Number = Number(param3.xml.xml.battlefieldHeight);
         this.hillMc.scaleX = scale * (param3.backScale + param2 / _loc4_ * (param3.frontScale - param3.backScale));
         this.hillMc.scaleY = scale * (param3.backScale + param2 / _loc4_ * (param3.frontScale - param3.backScale));
         this.hillControlBar.y = -this.hillMc.height * 1.1;
         this.hillControlBar.scaleX *= 2;
         this.hillControlBar.scaleY *= 2;
      }
      
      public function registerUnit(param1:Unit) : void
      {
         param1.team.register = 1;
      }
      
      public function getControllingTeam(param1:StickWar) : Team
      {
         if(this.teamBar == 0)
         {
            return param1.teamA;
         }
         if(this.teamBar == 100)
         {
            return param1.teamB;
         }
         return null;
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         param1.teamA.register = param1.teamB.register = 0;
         param1.spatialHash.mapInArea(px - statueArea / 2,py - statueArea / 2,px + statueArea / 2,py + statueArea / 2,this.registerUnit,false);
         if((param1.teamA.register == 1 || param1.teamB.register == 1) && param1.teamA.register + param1.teamB.register != 2)
         {
            _loc2_ = 50 / this.hillCaptureTime;
            if(param1.teamA.register != 0)
            {
               _loc2_ *= -1;
            }
            this.teamBar += _loc2_;
            if(this.teamBar < 0)
            {
               this.teamBar = 0;
            }
            if(this.teamBar > 100)
            {
               this.teamBar = 100;
            }
         }
         if(this.teamBar == 50)
         {
            this.hillMc.flame.visible = false;
         }
         else if(this.teamBar < 50 && param1.team == param1.teamA || this.teamBar > 50 && param1.team == param1.teamB)
         {
            this.hillMc.flame.transform.colorTransform.redOffset = 0;
            _loc3_ = Number(this.teamBar);
            if(_loc3_ > 50)
            {
               _loc3_ = 100 - _loc3_;
            }
            this.hillMc.flame.alpha = (50 - _loc3_) / 50;
            this.hillMc.flame.visible = true;
         }
         else
         {
            _loc3_ = Number(this.teamBar);
            if(_loc3_ > 50)
            {
               _loc3_ = 100 - _loc3_;
            }
            this.hillMc.flame.alpha = (50 - _loc3_) / 50;
            this.hillMc.flame.transform.colorTransform.redOffset = 255;
            this.hillMc.flame.visible = true;
         }
         Util.animateMovieClip(this.hillMc);
         if(param1.frame % this.collectionFrequency == 0)
         {
            if(this.teamBar == 0)
            {
               param1.teamA.gold += this.collectionRate;
               if(param1.team == param1.teamA)
               {
                  param1.incomeDisplay.addDisplay(param1,"+ " + this.collectionRate,65280,this.x,this.y - this.height - 10);
               }
            }
            else if(this.teamBar == 100)
            {
               param1.teamB.gold += this.collectionRate;
               if(param1.team == param1.teamB)
               {
                  param1.incomeDisplay.addDisplay(param1,"+ " + this.collectionRate,65280,this.x,this.y - this.height - 10);
               }
            }
         }
         if(this.teamBar == 0 || this.teamBar == 50 || this.teamBar == 100)
         {
            this.hillControlBar.visible = false;
            if(this.lastTeamBar != 0 && this.teamBar == 0)
            {
               if(param1.teamA == param1.team)
               {
                  param1.soundManager.playSoundFullVolume("SelectRaceSound");
               }
            }
            else if(this.lastTeamBar != 100 && this.teamBar == 100)
            {
               if(param1.teamB == param1.team)
               {
                  param1.soundManager.playSoundFullVolume("SelectRaceSound");
               }
            }
         }
         else
         {
            this.hillControlBar.visible = true;
         }
         this.hillControlBar.update((this.teamBar - 50) / 100,16711680);
         this.lastTeamBar = this.teamBar;
      }
   }
}
