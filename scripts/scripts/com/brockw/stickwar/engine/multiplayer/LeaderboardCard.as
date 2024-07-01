package com.brockw.stickwar.engine.multiplayer
{
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      
      public class LeaderboardCard extends rankEntryMc
      {
             
            
            private var wins:int;
            
            private var loses:int;
            
            private var _rating:int;
            
            private var rank:int;
            
            public function LeaderboardCard(param1:SFSObject)
            {
                  super();
                  this.wins = param1.getInt("w");
                  this.loses = param1.getInt("l");
                  this.rating = param1.getInt("r");
                  name = param1.getUtfString("n");
                  this.rank = -1;
                  this.nameText.text = name;
                  this.winText.text = "" + this.wins + "/" + this.loses;
                  this.rankText.text = "N/A";
                  this.ratingText.text = "" + this.rating;
            }
            
            public function setRank(param1:int) : *
            {
                  this.rank = param1;
                  this.rankText.text = "" + param1;
            }
            
            public function get rating() : int
            {
                  return this._rating;
            }
            
            public function set rating(param1:int) : void
            {
                  this._rating = param1;
            }
      }
}
