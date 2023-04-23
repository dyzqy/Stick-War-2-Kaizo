package com.brockw.stickwar.engine.Team
{
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   
   public class Building extends Unit
   {
       
      
      protected var tech:com.brockw.stickwar.engine.Team.Tech;
      
      protected var _button:MovieClip;
      
      protected var _hitAreaMovieClip:MovieClip;
      
      public var buildingWidth:Number;
      
      public function Building(param1:StickWar)
      {
         super(param1);
         _interactsWith = Unit.I_IS_BUILDING;
         this.buildingWidth = 0;
      }
      
      public function get button() : MovieClip
      {
         return this._button;
      }
      
      public function set button(param1:MovieClip) : void
      {
         this._button = param1;
      }
      
      public function get hitAreaMovieClip() : MovieClip
      {
         return this._hitAreaMovieClip;
      }
      
      public function set hitAreaMovieClip(param1:MovieClip) : void
      {
         this.buildingWidth = param1.width;
         this._hitAreaMovieClip = param1;
      }
   }
}
