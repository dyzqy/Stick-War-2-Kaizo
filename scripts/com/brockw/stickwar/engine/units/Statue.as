package com.brockw.stickwar.engine.units
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class Statue extends Unit implements Ore
   {
       
      
      private var miners:Vector.<com.brockw.stickwar.engine.units.Miner>;
      
      private var lights:Sprite;
      
      private var MAX_WORSHIP:int;
      
      private var numMiners:int;
      
      private var beamMiners:Array;
      
      private var prayRate:int;
      
      private var statueHealth:int;
      
      private var debugTextA:TextField;
      
      public function Statue(param1:MovieClip, param2:StickWar, param3:int)
      {
         super(param2);
         this.statueHealth = param3;
         _mc = param1;
         this.init(param2);
         addChild(_mc);
         _mc.cacheAsBitmap = true;
         ai = null;
         initSync();
         this.miners = new Vector.<com.brockw.stickwar.engine.units.Miner>(param2.xml.xml.maxWorshipers);
         var _loc4_:int = 0;
         while(_loc4_ < this.miners.length)
         {
            this.miners[_loc4_] = null;
            _loc4_++;
         }
         this.lights = new Sprite();
         this.addChild(this.lights);
         this.MAX_WORSHIP = param2.xml.xml.maxWorshipers;
         this.numMiners = 0;
         this.beamMiners = [];
         this.prayRate = param2.xml.xml.Order.Units.miner.manaMineRate;
         id = param2.getNextUnitId();
         pwidth = param1.width / 2;
         pheight = 175;
         this.mayWalkThrough = true;
         flyingHeight = 0;
         this.debugTextA = new TextField();
      }
      
      override public function setFire(param1:int, param2:Number) : void
      {
      }
      
      override public function checkForHitPoint(param1:Point, param2:Unit) : Boolean
      {
         if(param2 == null)
         {
            return false;
         }
         var _loc3_:int = Util.sgn(param2.px - px);
         param1 = this.globalToLocal(param1);
         if(param1.x > -pwidth && param1.x < width && param1.y > -pheight && param1.y < 0)
         {
            return true;
         }
         return false;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc3_:Number = NaN;
         if(team.tech.isResearched(Tech.STATUE_HEALTH))
         {
            if(maxHealth != param1.xml.xml.Order.Units.statue.upgradedHealth)
            {
               _loc3_ = maxHealth - health;
               maxHealth = param1.xml.xml.Order.Units.statue.upgradedHealth;
               health = maxHealth - _loc3_;
               healthBar.totalHealth = maxHealth;
            }
         }
         healthBar.health = health;
         healthBar.update();
         this.lights.graphics.clear();
         var _loc2_:int = 0;
         while(_loc2_ < this.beamMiners.length)
         {
            if(this.beamMiners[_loc2_] != null)
            {
               this.drawHolyLight(param1,this.beamMiners[_loc2_]);
            }
            _loc2_++;
         }
         if(this.isProtected())
         {
            this.debugTextA.textColor = 16711680;
            --this.protectedFrames;
            this.debugTextA.multiline = true;
            this.debugTextA.height = 1500;
            this.debugTextA.width = 1500;
            param1.gameScreen.userInterface.hud.addChild(this.debugTextA);
            this.debugTextA.text = this.protectedFrames / 30;
         }
         this.debugTextA.x = this.x + param1.battlefield.x - 40;
         this.debugTextA.y = this.y - this.pheight * 1.2 + param1.battlefield.y - 105;
      }
      
      public function isMouseHitTest(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = 250;
         var _loc4_:Number = 700;
         var _loc5_:Point = new Point(param1,param2);
         param1 = (_loc5_ = globalToLocal(_loc5_)).x;
         param2 = _loc5_.y;
         if(param1 > -_loc3_ / 2 && param1 < _loc3_ / 2 && param2 > -_loc4_ / 2 && param2 < _loc4_ * 0.05)
         {
            return true;
         }
         return false;
      }
      
      public function isMineFull() : Boolean
      {
         return this.numMiners == this.miners.length;
      }
      
      override public function damage(param1:int, param2:Number, param3:Entity, param4:Number = 1) : void
      {
         var _loc5_:* = NaN;
         if(isTargetable())
         {
            _loc5_ = 0;
            if(param3 != null)
            {
               _loc5_ = this.isArmoured ? Number(param3.damageToArmour) : Number(param3.damageToNotArmour);
            }
            else
            {
               _loc5_ = param2;
            }
            if(this.isProtected())
            {
               trace("take reduced damage protected");
               _loc5_ *= 0.1;
            }
            _health -= _loc5_;
            team.game.soundManager.playSoundRandom("StatueHit",5,px,py);
            if(_health <= 0)
            {
               isDieing = true;
               _health = 0;
               if(shadowSprite != null && mc.contains(shadowSprite))
               {
                  mc.removeChild(shadowSprite);
               }
               shadowSprite = null;
               healthBar.health = 0;
               healthBar.update();
            }
         }
      }
      
      override public function drawOnHud(param1:MovieClip, param2:StickWar) : void
      {
         var _loc3_:Number = param1.width * px / param2.map.width;
         var _loc4_:Number = param1.height * py / param2.map.height;
         if(selected)
         {
            MovieClip(param1).graphics.lineStyle(2,65280,1);
         }
         else
         {
            MovieClip(param1).graphics.lineStyle(2,6710886,1);
         }
         MovieClip(param1).graphics.beginFill(6710886,1);
         MovieClip(param1).graphics.drawRect(_loc3_ - 2,_loc4_ - 2,4,4);
         MovieClip(param1).graphics.endFill();
      }
      
      public function mine(param1:int, param2:com.brockw.stickwar.engine.units.Miner) : Number
      {
         param2.team.mana += this.prayRate;
         return 0;
      }
      
      public function drawHolyLight(param1:StickWar, param2:Unit) : void
      {
         var _loc3_:Point = new Point(0,0);
         _loc3_ = param2.localToGlobal(_loc3_);
         _loc3_ = this.globalToLocal(_loc3_);
      }
      
      override public function init(param1:StickWar) : void
      {
         initBase();
         this._health = maxHealth = this.statueHealth;
         _mass = 50;
         _maxForce = 30;
         _dragForce = 0.89;
         _scale = 0.8;
         _maxVelocity = 5;
         type = Unit.U_STATUE;
         _mc.stop();
         _mc.width *= _scale;
         _mc.height *= _scale;
         _hitBoxWidth = 25;
         this.numMiners = 0;
         var _loc2_:Number = mc.height;
         healthBar.totalHealth = _health;
         mc.addChild(healthBar);
         healthBar.scaleX *= 3.5;
         healthBar.scaleY *= 2.5;
         healthBar.y = -_loc2_ * 1;
      }
      
      public function inMineRange(param1:com.brockw.stickwar.engine.units.Miner) : Boolean
      {
         return Math.abs(x - param1.team.direction * 50 - param1.x) < 150;
      }
      
      public function getMiningSpot(param1:com.brockw.stickwar.engine.units.Miner) : Number
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.miners.length)
         {
            if(this.miners[_loc2_] == param1)
            {
               return (this.MAX_WORSHIP - _loc2_) * 20 - 50;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function reserveMiningSpot(param1:com.brockw.stickwar.engine.units.Miner) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.miners.length)
         {
            if(this.miners[_loc2_] == null)
            {
               this.miners[_loc2_] = param1;
               ++this.numMiners;
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function hasMiningSpot(param1:com.brockw.stickwar.engine.units.Miner) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.miners.length)
         {
            if(this.miners[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function releaseMiningSpot(param1:com.brockw.stickwar.engine.units.Miner) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.miners.length)
         {
            if(this.miners[_loc2_] == param1)
            {
               this.miners[_loc2_] = null;
               --this.numMiners;
               this.stopMining(param1);
               return;
            }
            _loc2_++;
         }
      }
      
      override public function poison(param1:Number) : Boolean
      {
         return false;
      }
      
      public function startMining(param1:com.brockw.stickwar.engine.units.Miner) : void
      {
         if(this.beamMiners.indexOf(param1) == -1)
         {
            this.beamMiners.push(param1);
         }
      }
      
      public function stopMining(param1:com.brockw.stickwar.engine.units.Miner) : void
      {
         this.beamMiners.splice(this.beamMiners.indexOf(param1),1);
      }
      
      public function mayMine(param1:com.brockw.stickwar.engine.units.Miner) : Boolean
      {
         if(param1.isBagFull())
         {
            return false;
         }
         if(Math.abs(x - param1.team.direction * 50 - param1.x) < 30 && Math.abs(y - param1.y + this.getMiningSpot(param1)) < 20 && param1.getDirection() == Util.sgn(x - param1.x))
         {
            return true;
         }
         return false;
      }
      
      override public function stun(param1:int, param2:Number = 1) : void
      {
      }
      
      public function hitTest(param1:int, param2:int) : Boolean
      {
         if(param1 > this.x - this.width / 2 && param1 < this.x + this.width / 2 && param2 > this.y - this.height && param2 < this.y + 100)
         {
            return true;
         }
         return false;
      }
      
      public function miningRate(param1:int) : Number
      {
         return param1;
      }
   }
}
