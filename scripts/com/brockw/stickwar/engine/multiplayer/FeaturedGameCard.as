package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class FeaturedGameCard extends featuredGameCard
   {
       
      
      public var replayPointer:String;
      
      public var version:String;
      
      public function FeaturedGameCard(param1:SFSObject)
      {
         super();
         this.usernameA.text = param1.getUtfString("userAusername") + " (" + Math.round(param1.getDouble("userArating")) + ")";
         this.usernameB.text = param1.getUtfString("userBusername") + " (" + Math.round(param1.getDouble("userBrating")) + ")";
         this.raceA.gotoAndStop(Team.getRaceNameFromId(param1.getInt("raceA")));
         this.raceB.gotoAndStop(Team.getRaceNameFromId(param1.getInt("raceB")));
         this.replayPointer = param1.getUtfString("replayPointer");
         this.version = param1.getUtfString("version");
         if((param1.getInt("gameType") - 1) / 2 == StickWar.TYPE_CLASSIC)
         {
            this.type.text = "Classic";
         }
         else
         {
            this.type.text = "Deathmatch";
         }
      }
   }
}
