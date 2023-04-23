package com.brockw.stickwar.engine.maps
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.Team.Team;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public class Map
   {
      
      public static const M_ICE_WORLD:int = 0;
      
      public static const M_GRASS_HILLS:int = 1;
      
      public static const M_SWAMP_LANDS:int = 2;
      
      public static const M_DESERT:int = 3;
      
      public static const M_FOREST:int = 4;
      
      public static const M_MOUNTAINS:int = 5;
      
      public static const M_GATES:int = 6;
      
      public static const M_CASTLE:int = 7;
      
      public static const M_HALLOWEEN:int = 8;
      
      public static const maps:Array = [M_SWAMP_LANDS,M_GATES,M_CASTLE,M_HALLOWEEN,M_ICE_WORLD,M_DESERT,M_FOREST,M_GRASS_HILLS];
      
      public static const SIZE_SMALL:int = 0;
      
      public static const SIZE_MEDIUM:int = 1;
      
      public static const SIZE_LARGE:int = 2;
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var _y:int;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      private var _gold:Vector.<Ore>;
      
      private var _hills:Vector.<Hill>;
      
      private var _combiner:Class;
      
      private var combinerArray:Array;
      
      public function Map()
      {
         super();
         this._gold = new Vector.<Ore>();
         this._hills = new Vector.<Hill>();
         this.combiner = null;
         this.combinerArray = [];
      }
      
      public static function getMapNameFromId(param1:int) : String
      {
         if(param1 == M_ICE_WORLD)
         {
            return "Ice World";
         }
         if(param1 == M_CASTLE)
         {
            return "Castle";
         }
         if(param1 == M_SWAMP_LANDS)
         {
            return "Swamp Lands";
         }
         if(param1 == M_MOUNTAINS)
         {
            return "Mountains";
         }
         if(param1 == M_GATES)
         {
            return "Gates";
         }
         if(param1 == M_HALLOWEEN)
         {
            return "Halloween";
         }
         if(param1 == M_DESERT)
         {
            return "Desert";
         }
         if(param1 == M_FOREST)
         {
            return "Forest";
         }
         if(param1 == M_GRASS_HILLS)
         {
            return "Grass Hills";
         }
         return "Bad ID";
      }
      
      public static function getSizeString(param1:int) : String
      {
         if(SIZE_SMALL == param1)
         {
            return "S";
         }
         if(SIZE_MEDIUM == param1)
         {
            return "M";
         }
         if(SIZE_LARGE == param1)
         {
            return "L";
         }
         return "S";
      }
      
      public static function getMapSizeId(param1:int) : int
      {
         if(param1 == M_ICE_WORLD)
         {
            return SIZE_MEDIUM;
         }
         if(param1 == M_GRASS_HILLS)
         {
            return SIZE_LARGE;
         }
         if(param1 == M_SWAMP_LANDS)
         {
            return SIZE_SMALL;
         }
         if(param1 == M_DESERT)
         {
            return SIZE_MEDIUM;
         }
         if(param1 == M_FOREST)
         {
            return SIZE_MEDIUM;
         }
         if(param1 == M_MOUNTAINS)
         {
            return SIZE_MEDIUM;
         }
         if(param1 == M_GATES)
         {
            return SIZE_SMALL;
         }
         if(param1 == M_CASTLE)
         {
            return SIZE_SMALL;
         }
         if(param1 == M_HALLOWEEN)
         {
            return SIZE_MEDIUM;
         }
         return SIZE_SMALL;
      }
      
      public static function getMapDisplayFromId(param1:int) : MovieClip
      {
         if(param1 == -1)
         {
            return new randomMapMc();
         }
         if(param1 == M_ICE_WORLD)
         {
            return new iceWorldDisplayMc();
         }
         if(param1 == M_GRASS_HILLS)
         {
            return new grassHillsDisplayMc();
         }
         if(param1 == M_SWAMP_LANDS)
         {
            return new swampDisplayMc();
         }
         if(param1 == M_DESERT)
         {
            return new desertDisplayMc();
         }
         if(param1 == M_FOREST)
         {
            return new forestDisplayMc();
         }
         if(param1 == M_MOUNTAINS)
         {
            return new iceWorldDisplayMc();
         }
         if(param1 == M_GATES)
         {
            return new gatesDisplayMc();
         }
         if(param1 == M_CASTLE)
         {
            return new castleDisplayMc();
         }
         if(param1 == M_HALLOWEEN)
         {
            return new halloweanDisplayMc();
         }
         return new iceWorldDisplayMc();
      }
      
      public static function getMapFromId(param1:int, param2:StickWar) : Map
      {
         if(param1 == M_ICE_WORLD)
         {
            return new IceWorld(param2);
         }
         if(param1 == M_GRASS_HILLS)
         {
            return new GrassHills(param2);
         }
         if(param1 == M_SWAMP_LANDS)
         {
            return new SwampLands(param2);
         }
         if(param1 == M_DESERT)
         {
            return new Desert(param2);
         }
         if(param1 == M_FOREST)
         {
            return new Forest(param2);
         }
         if(param1 == M_MOUNTAINS)
         {
            return new Mountains(param2);
         }
         if(param1 == M_GATES)
         {
            return new Gates(param2);
         }
         if(param1 == M_CASTLE)
         {
            return new CastleLevel(param2);
         }
         if(param1 == M_HALLOWEEN)
         {
            return new Halloween(param2);
         }
         return new IceWorld(param2);
      }
      
      public function addCombiners(param1:StickWar) : void
      {
      }
      
      private function addCombinersOnStatue(param1:StickWar, param2:Team) : void
      {
         var _loc6_:MovieClip = null;
         var _loc3_:MovieClip = param2.statue.mc;
         var _loc4_:int = 0;
         var _loc5_:Number = -80;
         while(_loc5_ < 80)
         {
            _loc5_ += param1.random.nextNumber() * 80;
            _loc6_ = this.getARandomCombiner(param1);
            _loc3_.addChild(_loc6_);
            _loc6_.y = 30;
            _loc6_.x = _loc5_;
            _loc6_.scaleX = 1 / _loc3_.scaleX;
            _loc6_.scaleY = 1 / _loc3_.scaleY;
         }
      }
      
      private function addCombinersOnMines(param1:StickWar) : void
      {
         var _loc2_:Gold = null;
         for each(_loc2_ in this._gold)
         {
            this.addCombinersOnMine(param1,_loc2_.frontOre);
         }
      }
      
      private function addCombinersOnMine(param1:StickWar, param2:Entity) : void
      {
         var _loc5_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:Number = -127;
         while(_loc4_ < 110)
         {
            _loc4_ += param1.random.nextNumber() * 60;
            _loc5_ = this.getARandomCombiner(param1);
            param2.addChild(_loc5_);
            _loc5_.y = 20;
            _loc5_.x = _loc4_;
            _loc5_.scaleX = param2.scaleX * 8;
            _loc5_.scaleY = param2.scaleY * 8;
         }
      }
      
      public function getARandomCombiner(param1:StickWar) : MovieClip
      {
         var _loc5_:FrameLabel = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.combiner == null)
         {
            return null;
         }
         var _loc2_:MovieClip = new this._combiner();
         var _loc3_:Array = _loc2_.currentLabels;
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            _loc4_ += int(_loc5_.name);
         }
         _loc6_ = param1.random.nextInt() % _loc4_;
         _loc7_ = 0;
         _loc8_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc7_ += int(_loc3_[_loc8_++].name);
         }
         _loc2_.gotoAndStop(_loc8_);
         return _loc2_;
      }
      
      protected function compareX(param1:Entity, param2:Entity) : int
      {
         return param1.px - param2.px;
      }
      
      protected function createMiningBlock(param1:StickWar, param2:Number, param3:int) : void
      {
         var _loc4_:Gold;
         (_loc4_ = new Gold(param1)).init(param2 + param3 * -10,this._height / 2 - 100,param1.xml.xml.goldAtStartOfMap,param1);
         this._gold.push(_loc4_);
         param1.units[_loc4_.id] = _loc4_;
         (_loc4_ = new Gold(param1)).init(param2 + param3 * -11,this._height / 2 + 100,param1.xml.xml.goldAtStartOfMap,param1);
         this._gold.push(_loc4_);
         param1.units[_loc4_.id] = _loc4_;
         _loc4_ = new Gold(param1);
         (_loc4_ = new Gold(param1)).init(param2 + param3 * 70,this._height / 2 - 60,param1.xml.xml.goldAtStartOfMap,param1);
         this._gold.push(_loc4_);
         param1.units[_loc4_.id] = _loc4_;
         (_loc4_ = new Gold(param1)).init(param2 + param3 * 70,this._height / 2 + 60,param1.xml.xml.goldAtStartOfMap,param1);
         this._gold.push(_loc4_);
         param1.units[_loc4_.id] = _loc4_;
      }
      
      protected function setDimensions(param1:StickWar) : void
      {
         this.width = param1.background.mapLength;
         this.height = param1.xml.xml.battlefieldHeight;
         this.y = param1.xml.xml.battlefieldY;
         this.screenWidth = param1.stage.stageWidth;
         this.screenHeight = param1.stage.stageHeight;
      }
      
      public function init(param1:StickWar) : void
      {
         this._gold.sort(this.compareX);
      }
      
      public function addElementsToMap(param1:*) : void
      {
         var _loc3_:Hill = null;
         var _loc4_:Gold = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._gold.length)
         {
            _loc4_ = Gold(this._gold[_loc2_]);
            param1.battlefield.addChild(_loc4_.frontOre);
            param1.battlefield.addChild(_loc4_.ore);
            _loc2_++;
         }
         for each(_loc3_ in this.hills)
         {
            param1.battlefield.addChild(_loc3_);
         }
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function set y(param1:int) : void
      {
         this._y = param1;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function set width(param1:int) : void
      {
         this._width = param1;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function set height(param1:int) : void
      {
         this._height = param1;
      }
      
      public function get gold() : Vector.<Ore>
      {
         return this._gold;
      }
      
      public function set gold(param1:Vector.<Ore>) : void
      {
         this._gold = param1;
      }
      
      public function get screenWidth() : int
      {
         return this._screenWidth;
      }
      
      public function set screenWidth(param1:int) : void
      {
         this._screenWidth = param1;
      }
      
      public function get screenHeight() : int
      {
         return this._screenHeight;
      }
      
      public function set screenHeight(param1:int) : void
      {
         this._screenHeight = param1;
      }
      
      public function get hills() : Vector.<Hill>
      {
         return this._hills;
      }
      
      public function set hills(param1:Vector.<Hill>) : void
      {
         this._hills = param1;
      }
      
      public function get combiner() : Class
      {
         return this._combiner;
      }
      
      public function set combiner(param1:Class) : void
      {
         this._combiner = param1;
      }
   }
}
