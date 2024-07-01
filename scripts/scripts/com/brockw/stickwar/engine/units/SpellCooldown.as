package com.brockw.stickwar.engine.units
{
      import com.brockw.stickwar.engine.Team.Team;
      
      public class SpellCooldown
      {
             
            
            private var counter:int;
            
            public var cooldownTime:int = 0;
            
            private var effect:int = 0;
            
            private var mana:int = 0;
            
            public function SpellCooldown(param1:int, param2:int, param3:int)
            {
                  super();
                  this.cooldownTime = param2;
                  this.effect = param1;
                  this.mana = param3;
                  this.counter = param1 + param2;
            }
            
            public function spellActivate(param1:Team) : Boolean
            {
                  if(this.counter >= this.cooldownTime && this.mana <= param1.mana)
                  {
                        param1.mana -= this.mana;
                        this.counter = 0;
                        return true;
                  }
                  return false;
            }
            
            public function startCooldownNow() : void
            {
                  this.counter = 0;
            }
            
            public function update() : void
            {
                  ++this.counter;
            }
            
            public function timeRunning() : Number
            {
                  return this.counter;
            }
            
            public function inEffect() : Boolean
            {
                  return this.counter < this.effect;
            }
            
            public function cooldown() : Number
            {
                  var _loc1_:Number = 1 * (this.cooldownTime - this.counter) / (1 * this.cooldownTime);
                  if(_loc1_ < 0)
                  {
                        _loc1_ = 0;
                  }
                  return _loc1_;
            }
      }
}
