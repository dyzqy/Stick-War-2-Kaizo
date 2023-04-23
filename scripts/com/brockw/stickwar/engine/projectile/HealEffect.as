package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   import flash.geom.*;
   
   public class HealEffect extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var unit:Unit;
      
      private var _isCure:Boolean;
      
      public function HealEffect(param1:StickWar)
      {
         super();
         type = HEAL_EFFECT;
         this.spellMc = new healingEffectMc();
         this.addChild(this.spellMc);
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Point = null;
         Util.animateMovieClipBasic(this.spellMc);
         this.scaleX = 2.2;
         this.scaleY = 2.2;
         _loc2_ = this.unit.healthBar.localToGlobal(new Point(0,60));
         _loc2_ = team.game.battlefield.globalToLocal(_loc2_);
         px = this.unit.x;
         py = this.unit.py;
         x = px;
         y = _loc2_.y;
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.spellMc.currentFrame == this.spellMc.totalFrames;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.spellMc.currentFrame != this.spellMc.totalFrames;
      }
      
      public function get isCure() : Boolean
      {
         return this._isCure;
      }
      
      public function set isCure(param1:Boolean) : void
      {
         if(param1)
         {
            removeChild(this.spellMc);
            addChild(this.spellMc = new cureEffectMc());
         }
         else
         {
            removeChild(this.spellMc);
            addChild(this.spellMc = new healingEffectMc());
         }
         this._isCure = param1;
      }
   }
}
