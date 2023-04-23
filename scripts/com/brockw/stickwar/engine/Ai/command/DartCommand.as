package com.brockw.stickwar.engine.Ai.command
{
   import com.brockw.stickwar.engine.Entity;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import com.brockw.stickwar.engine.units.*;
   
   public class DartCommand extends UnitCommand
   {
       
      
      public function DartCommand(param1:StickWar)
      {
         super();
      }
      
      override public function coolDownTime(param1:Entity) : Number
      {
         return Magikill(param1).poisonDartCooldown();
      }
      
      override public function isFinished(param1:Unit) : Boolean
      {
         return false;
      }
      
      override public function inRange(param1:Entity) : Boolean
      {
         return Math.pow(realX - param1.px,2) + Math.pow(realY - param1.py,2) < Math.pow(Unit(param1).team.game.xml.xml.Order.Units.magikill.poisonRange,2);
      }
   }
}
