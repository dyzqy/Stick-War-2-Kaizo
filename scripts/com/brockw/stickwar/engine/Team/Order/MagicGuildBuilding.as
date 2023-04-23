package com.brockw.stickwar.engine.Team.Order
{
   import com.brockw.stickwar.engine.ActionInterface;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.MovieClip;
   
   public class MagicGuildBuilding extends Building
   {
       
      
      public function MagicGuildBuilding(param1:StickWar, param2:GoodTech, param3:MovieClip, param4:MovieClip)
      {
         super(param1);
         this.button = param3;
         _hitAreaMovieClip = param4;
         this.type = Unit.B_MAGIC_SHOP;
         this.tech = param2;
      }
      
      override public function setActionInterface(param1:ActionInterface) : void
      {
         param1.clear();
         if(!tech.isResearched(Tech.MAGIKILL_POISON))
         {
            param1.setAction(0,0,Tech.MAGIKILL_POISON);
         }
         if(!tech.isResearched(Tech.MAGIKILL_WALL))
         {
            param1.setAction(1,0,Tech.MAGIKILL_WALL);
         }
      }
   }
}
