package com.brockw.stickwar.engine
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class Gold extends Entity implements Ore
      {
            
            private static const scale:Number = 0.4;
             
            
            private var amount:Number;
            
            public var ore:Entity;
            
            public var frontOre:Entity;
            
            private var _total:Number;
            
            private var miners:Vector.<Miner>;
            
            private var numMiners:int;
            
            internal var gold:_ore;
            
            public function Gold(param1:StickWar)
            {
                  this.ore = new Entity();
                  this.ore.addChild(this.gold = new _ore());
                  this.frontOre = new Entity();
                  this.frontOre.addChild(new _oreFront());
                  this.miners = new Vector.<Miner>(2);
                  var _loc2_:int = 0;
                  while(_loc2_ < this.miners.length)
                  {
                        this.miners[_loc2_] = null;
                        _loc2_++;
                  }
                  this.numMiners = 0;
                  _type = 0;
                  super();
            }
            
            public function init(param1:int, param2:int, param3:Number, param4:StickWar) : void
            {
                  this.x = param1;
                  this.y = param2;
                  this.px = param1;
                  this.py = param2;
                  this.ore.x = param1;
                  this.ore.y = param2 - 3;
                  this.ore.px = this.ore.x;
                  this.ore.py = this.ore.y;
                  this.frontOre.x = param1;
                  this.frontOre.y = param2 + 3;
                  this.frontOre.px = this.frontOre.x;
                  this.frontOre.py = this.frontOre.y;
                  this._total = this.amount = param3;
                  var _loc5_:Number = Number(param4.xml.xml.battlefieldHeight);
                  this.ore.scaleX = scale * (param4.backScale + param2 / _loc5_ * (param4.frontScale - param4.backScale));
                  this.ore.scaleY = scale * (param4.backScale + param2 / _loc5_ * (param4.frontScale - param4.backScale));
                  this.frontOre.scaleX = scale * (param4.backScale + param2 / _loc5_ * (param4.frontScale - param4.backScale));
                  this.frontOre.scaleY = scale * (param4.backScale + param2 / _loc5_ * (param4.frontScale - param4.backScale));
                  id = param4.getNextUnitId();
                  if(this.gold.glow)
                  {
                        this.gold.glow.gotoAndStop(1);
                  }
                  this.gold.gotoAndStop(1);
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
                  MovieClip(param1).graphics.drawRect(_loc3_,_loc4_,1,1);
            }
            
            public function update(param1:StickWar) : void
            {
                  if(this.gold.glow)
                  {
                        this.gold.glow.gotoAndStop(1);
                  }
                  this.gold.gotoAndStop(1);
            }
            
            public function inMineRange(param1:Miner) : Boolean
            {
                  return true;
            }
            
            public function mine(param1:int, param2:Miner) : Number
            {
                  var _loc3_:int = 0;
                  if(this.amount - this.miningRate(param1) < 0)
                  {
                        _loc3_ = int(this.amount);
                        this.amount = 0;
                  }
                  else
                  {
                        _loc3_ = this.miningRate(param1);
                        this.amount -= _loc3_;
                  }
                  this.ore.scaleX = this.amount / this._total * scale * (param2.team.game.backScale + y / param2.team.game.map.height * (param2.team.game.frontScale - param2.team.game.backScale));
                  this.ore.scaleY = this.amount / this._total * scale * (param2.team.game.backScale + y / param2.team.game.map.height * (param2.team.game.frontScale - param2.team.game.backScale));
                  return _loc3_;
            }
            
            public function getMiningSpot(param1:Miner) : Number
            {
                  var _loc2_:int = 0;
                  while(_loc2_ < this.miners.length)
                  {
                        if(this.miners[_loc2_] == param1)
                        {
                              return param1.team.direction * (2 * _loc2_ - 1) * 50;
                        }
                        _loc2_++;
                  }
                  return 0;
            }
            
            public function reserveMiningSpot(param1:Miner) : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return false;
                  }
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
            
            public function hasMiningSpot(param1:Miner) : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return false;
                  }
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
            
            public function releaseMiningSpot(param1:Miner) : void
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
            
            public function isMineFull() : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return true;
                  }
                  return this.numMiners == this.miners.length;
            }
            
            public function startMining(param1:Miner) : void
            {
            }
            
            public function stopMining(param1:Miner) : void
            {
            }
            
            public function isBeingMined(param1:Miner) : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return false;
                  }
                  return this.numMiners < 2;
            }
            
            public function mayStartMining(param1:Miner) : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return false;
                  }
                  return !this.isBeingMined(param1);
            }
            
            public function mayMine(param1:Miner) : Boolean
            {
                  if(this.amount <= 0)
                  {
                        return false;
                  }
                  if(param1.isBagFull())
                  {
                        return false;
                  }
                  if(Math.abs(x + this.getMiningSpot(param1) - param1.x) < 30 && Math.abs(y - param1.y) < 20 && param1.getDirection() == Util.sgn(x - param1.x))
                  {
                        return true;
                  }
                  return false;
            }
            
            public function hitTest(param1:int, param2:int) : Boolean
            {
                  if(param1 > this.x - this.ore.width / 2 && param1 < this.x + this.ore.width / 2 && param2 > this.y - this.ore.width && param2 < this.y)
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
