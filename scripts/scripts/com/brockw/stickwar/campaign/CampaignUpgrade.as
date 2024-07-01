package com.brockw.stickwar.campaign
{
      public class CampaignUpgrade
      {
             
            
            public var parents:Array;
            
            public var children:Array;
            
            public var tech:int;
            
            public var name:String;
            
            public var upgraded:Boolean;
            
            public function CampaignUpgrade(param1:String, param2:Array, param3:Array, param4:int)
            {
                  super();
                  this.name = param1;
                  this.parents = param2;
                  this.children = param3;
                  this.tech = param4;
                  this.upgraded = false;
            }
      }
}
