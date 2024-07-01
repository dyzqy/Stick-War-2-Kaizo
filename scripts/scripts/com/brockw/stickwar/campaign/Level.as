package com.brockw.stickwar.campaign
{
      import com.brockw.stickwar.campaign.controllers.CampaignArcher;
      import com.brockw.stickwar.campaign.controllers.CampaignBomber;
      import com.brockw.stickwar.campaign.controllers.CampaignCutScene1;
      import com.brockw.stickwar.campaign.controllers.CampaignCutScene2;
      import com.brockw.stickwar.campaign.controllers.CampaignDeads;
      import com.brockw.stickwar.campaign.controllers.CampaignKnight;
      import com.brockw.stickwar.campaign.controllers.CampaignMagic;
      import com.brockw.stickwar.campaign.controllers.CampaignShadow;
      import com.brockw.stickwar.campaign.controllers.CampaignTutorial;
      import com.brockw.stickwar.market.ItemMap;
      import com.brockw.stickwar.missions.CampaignEvent;
      
      public class Level
      {
             
            
            public var title:String;
            
            public var mapName:int;
            
            public var storyName:String;
            
            public var player:Player;
            
            public var oponent:Player;
            
            public var controller:Class;
            
            public var points:int;
            
            private var _normalDamageModifier:Number;
            
            private var _normalModifier:Number;
            
            private var _hardModifier:Number;
            
            private var _insaneModifier:Number;
            
            private var _normalHealthModifier:Number;
            
            private var _tip:String;
            
            private var _unlocks:Array;
            
            private var _levelXml:XML;
            
            private var _hasInsaneWall:Boolean;
            
            public var totalTime:int;
            
            public var bestTime:int;
            
            public var retries:int;
            
            public var events:Array;
            
            public var levelNumber:*;
            
            public function Level(param1:XML)
            {
                  var _loc3_:* = undefined;
                  var _loc4_:CampaignEvent = null;
                  super();
                  this.title = param1.attribute("title");
                  this.mapName = param1.attribute("map");
                  this.storyName = param1.attribute("story");
                  this.levelNumber = param1.attribute("number");
                  this.points = param1.attribute("points");
                  this._levelXml = param1;
                  var _loc2_:* = param1.attribute("controller");
                  if(_loc2_ == "CampaignTutorial")
                  {
                        this.controller = CampaignTutorial;
                  }
                  else if(_loc2_ == "CampaignCutScene1")
                  {
                        this.controller = CampaignCutScene1;
                  }
                  else if(_loc2_ == "CampaignCutScene2")
                  {
                        this.controller = CampaignCutScene2;
                  }
                  else if(_loc2_ == "CampaignBomber")
                  {
                        this.controller = CampaignBomber;
                  }
                  else if(_loc2_ == "CampaignShadow")
                  {
                        this.controller = CampaignShadow;
                  }
                  else if(_loc2_ == "CampaignDeads")
                  {
                        this.controller = CampaignDeads;
                  }
                  else if(_loc2_ == "CampaignKnight")
                  {
                        this.controller = CampaignKnight;
                  }
                  else if(_loc2_ == "CampaignArcher")
                  {
                        this.controller = CampaignArcher;
                  }
                  else if(_loc2_ == "CampaignMagic")
                  {
                        this.controller = CampaignMagic;
                  }
                  this.unlocks = [];
                  for each(_loc3_ in param1.unlock)
                  {
                        this.unlocks.push(int(ItemMap.unitNameToType(_loc3_)));
                  }
                  this.player = new Player(param1.player);
                  this.oponent = new Player(param1.oponent);
                  this.normalModifier = param1.normal;
                  this.hardModifier = param1.hard;
                  this.insaneModifier = param1.insane;
                  this.normalHealthScale = param1.normalHealthScale;
                  this.normalDamageModifier = 1;
                  for each(_loc3_ in param1.normalDamageScale)
                  {
                        this.normalDamageModifier = _loc3_;
                  }
                  this.tip = param1.tip;
                  this.totalTime = 0;
                  this.bestTime = -1;
                  this.retries = 0;
                  this.hasInsaneWall = param1.hasInsaneWall == true;
                  this.events = [];
                  for each(_loc3_ in param1.event)
                  {
                        _loc4_ = new CampaignEvent(_loc3_);
                        this.events.push(_loc4_);
                  }
            }
            
            public function get normalDamageModifier() : Number
            {
                  return this._normalDamageModifier;
            }
            
            public function set normalDamageModifier(param1:Number) : void
            {
                  this._normalDamageModifier = param1;
            }
            
            public function get hasInsaneWall() : Boolean
            {
                  return this._hasInsaneWall;
            }
            
            public function set hasInsaneWall(param1:Boolean) : void
            {
                  this._hasInsaneWall = param1;
            }
            
            public function updateTime(param1:Number) : void
            {
                  if(this.bestTime == -1)
                  {
                        this.bestTime = param1;
                  }
                  else if(param1 < this.bestTime)
                  {
                        this.bestTime = param1;
                  }
                  this.totalTime += param1;
                  ++this.retries;
            }
            
            public function toString() : String
            {
                  var _loc1_:* = "Level: " + this.title + " (" + this.mapName + ")";
                  _loc1_ += "\nPlayer: " + this.player;
                  return _loc1_ + ("\nOponent: " + this.oponent);
            }
            
            public function get normalModifier() : Number
            {
                  return this._normalModifier;
            }
            
            public function set normalModifier(param1:Number) : void
            {
                  this._normalModifier = param1;
            }
            
            public function get hardModifier() : Number
            {
                  return this._hardModifier;
            }
            
            public function set hardModifier(param1:Number) : void
            {
                  this._hardModifier = param1;
            }
            
            public function get insaneModifier() : Number
            {
                  return this._insaneModifier;
            }
            
            public function set insaneModifier(param1:Number) : void
            {
                  this._insaneModifier = param1;
            }
            
            public function get normalHealthScale() : Number
            {
                  return this._normalHealthModifier;
            }
            
            public function set normalHealthScale(param1:Number) : void
            {
                  this._normalHealthModifier = param1;
            }
            
            public function get tip() : String
            {
                  return this._tip;
            }
            
            public function set tip(param1:String) : void
            {
                  this._tip = param1;
            }
            
            public function get unlocks() : Array
            {
                  return this._unlocks;
            }
            
            public function set unlocks(param1:Array) : void
            {
                  this._unlocks = param1;
            }
            
            public function get levelXml() : XML
            {
                  return this._levelXml;
            }
            
            public function set levelXml(param1:XML) : void
            {
                  this._levelXml = param1;
            }
      }
}
