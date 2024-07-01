package com.brockw.stickwar.market
{
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import com.smartfoxserver.v2.entities.data.*;
      import flash.display.*;
      import flash.filters.*;
      import flash.geom.Rectangle;
      import flash.utils.*;
      
      public class ItemMap
      {
            
            private static const races:* = ["Order","Chaos","Elementals"];
            
            private static const orderUnits:* = ["Miner","Swordwrath","Archidon","Spearton","Monk","Magikill","Ninja","Flying Crossbowman","Enslaved Giant"];
             
            
            private var _data:Dictionary;
            
            public function ItemMap()
            {
                  super();
                  this.data = new Dictionary();
            }
            
            public static function getWeaponMcFromString(param1:int, param2:String) : MovieClip
            {
                  var _loc3_:int = unitNameToType(param2);
                  return getWeaponMcFromId(param1,_loc3_);
            }
            
            public static function getUnitMcFromType(param1:int) : MovieClip
            {
                  var _loc2_:_medusaMc = null;
                  var _loc3_:int = 0;
                  var _loc4_:DisplayObject = null;
                  var _loc5_:GlowFilter = null;
                  var _loc6_:MovieClip = null;
                  if(param1 == Unit.U_SWORDWRATH)
                  {
                        return new _swordwrath();
                  }
                  if(param1 == Unit.U_ARCHER)
                  {
                        return new _archer();
                  }
                  if(param1 == Unit.U_SPEARTON)
                  {
                        return new _speartonMc();
                  }
                  if(param1 == Unit.U_MINER)
                  {
                        return new _miner();
                  }
                  if(param1 == Unit.U_NINJA)
                  {
                        return new _ninja();
                  }
                  if(param1 == Unit.U_FLYING_CROSSBOWMAN)
                  {
                        return new _flyingcrossbowmanMc();
                  }
                  if(param1 == Unit.U_ENSLAVED_GIANT)
                  {
                        return new _giantMc();
                  }
                  if(param1 == Unit.U_MAGIKILL)
                  {
                        return new _magikill();
                  }
                  if(param1 == Unit.U_MONK)
                  {
                        return new _cleric();
                  }
                  if(param1 == Unit.U_CAT)
                  {
                        return new _cat();
                  }
                  if(param1 == Unit.U_BOMBER)
                  {
                        return new _bomber();
                  }
                  if(param1 == Unit.U_DEAD)
                  {
                        return new _dead();
                  }
                  if(param1 == Unit.U_CHAOS_MINER)
                  {
                        return new _chaosminer();
                  }
                  if(param1 == Unit.U_KNIGHT)
                  {
                        return new _knight();
                  }
                  if(param1 == Unit.U_WINGIDON)
                  {
                        return new _wingidon();
                  }
                  if(param1 == Unit.U_GIANT)
                  {
                        return new _giant();
                  }
                  if(param1 == Unit.U_MEDUSA)
                  {
                        _loc2_ = new _medusaMc();
                        _loc3_ = 0;
                        while(_loc3_ < _loc2_.mc.snakes.numChildren)
                        {
                              if((_loc4_ = _loc2_.mc.snakes.getChildAt(_loc3_)) is MovieClip)
                              {
                                    MovieClip(_loc4_).gotoAndStop(Math.floor(MovieClip(_loc4_).totalFrames * Math.random()));
                              }
                              _loc3_++;
                        }
                        return _loc2_;
                  }
                  if(param1 == Unit.U_SKELATOR)
                  {
                        return new _skelator();
                  }
                  if(param1 == Unit.U_FIRE_ELEMENT)
                  {
                        return new _fireElemental();
                  }
                  if(param1 == Unit.U_EARTH_ELEMENT)
                  {
                        return new _earthElemental();
                  }
                  if(param1 == Unit.U_WATER_ELEMENT)
                  {
                        return new _waterElemental();
                  }
                  if(param1 == Unit.U_AIR_ELEMENT)
                  {
                        return new _airElemental();
                  }
                  if(param1 == Unit.U_MINER_ELEMENT)
                  {
                        return new _minerElementMc();
                  }
                  if(param1 == Unit.U_LAVA_ELEMENT)
                  {
                        return new _lavaElement();
                  }
                  if(param1 == Unit.U_HURRICANE_ELEMENT)
                  {
                        return new _hurricaneMc();
                  }
                  if(param1 == Unit.U_FIRESTORM_ELEMENT)
                  {
                        return new _firestormElement();
                  }
                  if(param1 == Unit.U_CHROME_ELEMENT)
                  {
                        (_loc5_ = new GlowFilter()).blurX = 5;
                        _loc5_.blurY = 5;
                        _loc5_.quality = BitmapFilterQuality.MEDIUM;
                        _loc5_.strength = 5;
                        _loc5_.color = 0;
                        (_loc6_ = new _chromeElement()).filters = [_loc5_];
                        return _loc6_;
                  }
                  if(param1 == Unit.U_TREE_ELEMENT)
                  {
                        return new _tree();
                  }
                  if(param1 == Unit.U_SCORPION_ELEMENT)
                  {
                        return new _scorpion();
                  }
                  return null;
            }
            
            public static function setItemsForUnitType(param1:int, param2:MovieClip, param3:String, param4:String, param5:String) : *
            {
                  if(param1 == Unit.U_SWORDWRATH)
                  {
                        Swordwrath.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_NINJA)
                  {
                        Ninja.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_SPEARTON)
                  {
                        Spearton.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_KNIGHT)
                  {
                        Knight.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_ENSLAVED_GIANT)
                  {
                        EnslavedGiant.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_MAGIKILL)
                  {
                        Magikill.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_MONK)
                  {
                        Monk.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_BOMBER)
                  {
                        Bomber.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_CAT)
                  {
                        Cat.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_GIANT)
                  {
                        Giant.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_MEDUSA)
                  {
                        Medusa.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_SKELATOR)
                  {
                        Skelator.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_ARCHER)
                  {
                        Archer.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_FLYING_CROSSBOWMAN)
                  {
                        FlyingCrossbowman.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_WINGIDON)
                  {
                        Wingidon.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_DEAD)
                  {
                        Dead.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_MINER)
                  {
                        Miner.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_CHAOS_MINER)
                  {
                        MinerChaos.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_FIRE_ELEMENT)
                  {
                        FireElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_AIR_ELEMENT)
                  {
                        AirElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_WATER_ELEMENT)
                  {
                        WaterElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_EARTH_ELEMENT)
                  {
                        EarthElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_HURRICANE_ELEMENT)
                  {
                        HurricaneElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_LAVA_ELEMENT)
                  {
                        LavaElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_SCORPION_ELEMENT)
                  {
                        ScorpionElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_TREE_ELEMENT)
                  {
                        TreeElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_FIRESTORM_ELEMENT)
                  {
                        FirestormElement.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_MINER_ELEMENT)
                  {
                        ElementalMiner.setItem(param2,param3,param4,param5);
                  }
                  else if(param1 == Unit.U_CHROME_ELEMENT)
                  {
                        ChromeElement.setItem(param2,param3,param4,param5);
                  }
            }
            
            public static function getUnitMcItemsFromType(param1:int, param2:String, param3:String, param4:String) : Array
            {
                  return [ItemMap.getScaledWeaponMcFromId(param1,MarketItem.T_WEAPON,param2),ItemMap.getScaledWeaponMcFromId(param1,MarketItem.T_ARMOR,param3),ItemMap.getScaledWeaponMcFromId(param1,MarketItem.T_MISC,param4)];
            }
            
            public static function getScaledWeaponMcFromId(param1:int, param2:int, param3:String) : MovieClip
            {
                  var _loc4_:MovieClip = null;
                  var _loc6_:Number = NaN;
                  var _loc7_:Number = NaN;
                  var _loc8_:Number = NaN;
                  var _loc9_:Number = NaN;
                  var _loc10_:Number = NaN;
                  var _loc11_:Number = NaN;
                  var _loc12_:Boolean = false;
                  var _loc13_:Boolean = false;
                  var _loc14_:GlowFilter = null;
                  var _loc15_:int = 0;
                  var _loc16_:int = 0;
                  var _loc17_:Number = NaN;
                  var _loc18_:Rectangle = null;
                  _loc4_ = ItemMap.getWeaponMcFromId(param2,param1);
                  var _loc5_:MovieClip = null;
                  if(_loc4_ != null)
                  {
                        _loc6_ = 16777215;
                        _loc7_ = 0.5;
                        _loc8_ = 14;
                        _loc9_ = 14;
                        _loc10_ = 1;
                        _loc11_ = Number(BitmapFilterQuality.LOW);
                        _loc12_ = false;
                        _loc13_ = false;
                        _loc14_ = new GlowFilter(_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_);
                        (_loc5_ = new MovieClip()).filters = [_loc14_];
                        _loc5_.addChild(_loc4_);
                        if(param3 != "")
                        {
                              _loc4_.gotoAndStop(param3);
                        }
                        _loc15_ = 50;
                        _loc16_ = 50;
                        _loc17_ = 0.8;
                        if(Math.abs(_loc15_ / _loc4_.width) < Math.abs(_loc16_ / _loc4_.height))
                        {
                              _loc17_ = _loc15_ / _loc4_.width;
                        }
                        else
                        {
                              _loc17_ = _loc16_ / _loc4_.height;
                        }
                        _loc4_.scaleX = _loc17_;
                        _loc4_.scaleY = _loc17_;
                        _loc18_ = _loc4_.getBounds(_loc4_);
                        _loc4_.x -= _loc18_.left;
                        _loc4_.y -= _loc18_.top;
                        _loc4_.x -= _loc4_.width / 2;
                        _loc4_.y -= _loc4_.height / 2;
                  }
                  return _loc5_;
            }
            
            public static function getWeaponMcFromId(param1:int, param2:int) : MovieClip
            {
                  var _loc4_:spearton_spear = null;
                  var _loc3_:int = param2;
                  if(_loc3_ == Unit.U_SWORDWRATH)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new itemSword();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new swordwrathHat();
                        }
                  }
                  if(_loc3_ == Unit.U_SPEARTON)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              _loc4_ = new spearton_spear();
                              _loc4_.rotation -= 65;
                              return _loc4_;
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new spearton_helmet();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new spearton_shield();
                        }
                  }
                  if(_loc3_ == Unit.U_KNIGHT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new knight_weapon();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new knight_helmet();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new knight_shield();
                        }
                  }
                  if(_loc3_ == Unit.U_MINER)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new miner_pickaxe();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return null;
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new miner_bag();
                        }
                  }
                  if(_loc3_ == Unit.U_CHAOS_MINER)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new chaosminer_pickaxe();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return null;
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new chaosminer_bag();
                        }
                  }
                  if(_loc3_ == Unit.U_NINJA)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new ninja_bostaff();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new ninja_head();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new ninja_katana();
                        }
                  }
                  if(_loc3_ == Unit.U_MAGIKILL)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new magikill_staff();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new magikill_hat();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new magikill_beard();
                        }
                  }
                  if(_loc3_ == Unit.U_ENSLAVED_GIANT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new giant_bag();
                        }
                  }
                  if(_loc3_ == Unit.U_MONK)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new cleric_wand();
                        }
                  }
                  if(_loc3_ == Unit.U_BOMBER)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new bomber_dynamite();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new bombers_head();
                        }
                  }
                  if(_loc3_ == Unit.U_CAT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new crawler_head();
                        }
                  }
                  if(_loc3_ == Unit.U_GIANT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new giant_weapon();
                        }
                  }
                  if(_loc3_ == Unit.U_MEDUSA)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new medusa_cape();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new medusa_crown();
                        }
                  }
                  if(_loc3_ == Unit.U_SKELATOR)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new skeletor_head();
                        }
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new skeletor_staff();
                        }
                  }
                  if(_loc3_ == Unit.U_DEAD)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new dead_head();
                        }
                  }
                  if(_loc3_ == Unit.U_ARCHER)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new archidon_head();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new archidon_sleve();
                        }
                  }
                  if(_loc3_ == Unit.U_WINGIDON)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new eclipsor_head();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new eclipsor_sleve();
                        }
                  }
                  if(_loc3_ == Unit.U_FLYING_CROSSBOWMAN)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new allbowtross_head();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new allbowtross_frontwing();
                        }
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new allbowtross_sleve();
                        }
                  }
                  if(_loc3_ == Unit.U_FIRE_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _fireHat();
                        }
                  }
                  if(_loc3_ == Unit.U_EARTH_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _earthHat();
                        }
                  }
                  if(_loc3_ == Unit.U_WATER_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _waterHat();
                        }
                  }
                  if(_loc3_ == Unit.U_AIR_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _airHat();
                        }
                  }
                  if(_loc3_ == Unit.U_CHROME_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _chromeHead();
                        }
                  }
                  if(_loc3_ == Unit.U_HURRICANE_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _hurricaneHead();
                        }
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new _hurricaneFrontHand();
                        }
                  }
                  if(_loc3_ == Unit.U_SCORPION_ELEMENT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new _scorpionStinger();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _scorpionDress();
                        }
                  }
                  if(_loc3_ == Unit.U_MINER_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _crabbody();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new _crabhead();
                        }
                  }
                  if(_loc3_ == Unit.U_LAVA_ELEMENT)
                  {
                        if(param1 == MarketItem.T_WEAPON)
                        {
                              return new _lavafrontarm();
                        }
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _lavahead();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new _lavatorso();
                        }
                  }
                  if(_loc3_ == Unit.U_FIRESTORM_ELEMENT)
                  {
                        if(param1 == MarketItem.T_ARMOR)
                        {
                              return new _fireburnface();
                        }
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new _bodyfireburn();
                        }
                  }
                  if(_loc3_ == Unit.U_TREE_ELEMENT)
                  {
                        if(param1 == MarketItem.T_MISC)
                        {
                              return new _treehair();
                        }
                  }
                  return null;
            }
            
            public static function unitNameToType(param1:String) : int
            {
                  if(param1 == "Miner")
                  {
                        return Unit.U_MINER;
                  }
                  if(param1 == "Swordwrath")
                  {
                        return Unit.U_SWORDWRATH;
                  }
                  if(param1 == "Archidon")
                  {
                        return Unit.U_ARCHER;
                  }
                  if(param1 == "Spearton")
                  {
                        return Unit.U_SPEARTON;
                  }
                  if(param1 == "Ninja")
                  {
                        return Unit.U_NINJA;
                  }
                  if(param1 == "FlyingCrossbowman")
                  {
                        return Unit.U_FLYING_CROSSBOWMAN;
                  }
                  if(param1 == "Monk")
                  {
                        return Unit.U_MONK;
                  }
                  if(param1 == "Magikill")
                  {
                        return Unit.U_MAGIKILL;
                  }
                  if(param1 == "EnslavedGiant")
                  {
                        return Unit.U_ENSLAVED_GIANT;
                  }
                  if(param1 == "ChaosMiner")
                  {
                        return Unit.U_CHAOS_MINER;
                  }
                  if(param1 == "Bomber")
                  {
                        return Unit.U_BOMBER;
                  }
                  if(param1 == "Wingadon")
                  {
                        return Unit.U_WINGIDON;
                  }
                  if(param1 == "SkelatalMage")
                  {
                        return Unit.U_SKELATOR;
                  }
                  if(param1 == "Dead")
                  {
                        return Unit.U_DEAD;
                  }
                  if(param1 == "Cat")
                  {
                        return Unit.U_CAT;
                  }
                  if(param1 == "Knight")
                  {
                        return Unit.U_KNIGHT;
                  }
                  if(param1 == "Medusa")
                  {
                        return Unit.U_MEDUSA;
                  }
                  if(param1 == "Giant")
                  {
                        return Unit.U_GIANT;
                  }
                  if(param1 == "Fire Element")
                  {
                        return Unit.U_FIRE_ELEMENT;
                  }
                  if(param1 == "Earth Element")
                  {
                        return Unit.U_EARTH_ELEMENT;
                  }
                  if(param1 == "Water Element")
                  {
                        return Unit.U_WATER_ELEMENT;
                  }
                  if(param1 == "Air Element")
                  {
                        return Unit.U_AIR_ELEMENT;
                  }
                  if(param1 == "Lava Element")
                  {
                        return Unit.U_LAVA_ELEMENT;
                  }
                  if(param1 == "Hurricane Element")
                  {
                        return Unit.U_HURRICANE_ELEMENT;
                  }
                  if(param1 == "Firestorm Element")
                  {
                        return Unit.U_FIRESTORM_ELEMENT;
                  }
                  if(param1 == "Tree Element")
                  {
                        return Unit.U_TREE_ELEMENT;
                  }
                  if(param1 == "Scorpion Element")
                  {
                        return Unit.U_SCORPION_ELEMENT;
                  }
                  if(param1 == "Chrome Element")
                  {
                        return Unit.U_CHROME_ELEMENT;
                  }
                  if(param1 == "Miner Element")
                  {
                        return Unit.U_MINER_ELEMENT;
                  }
                  return -1;
            }
            
            public static function unitTypeToName(param1:int) : String
            {
                  if(param1 == Unit.U_MINER)
                  {
                        return "Miner";
                  }
                  if(param1 == Unit.U_SWORDWRATH)
                  {
                        return "Swordwrath";
                  }
                  if(param1 == Unit.U_ARCHER)
                  {
                        return "Archidon";
                  }
                  if(param1 == Unit.U_SPEARTON)
                  {
                        return "Spearton";
                  }
                  if(param1 == Unit.U_NINJA)
                  {
                        return "Ninja";
                  }
                  if(param1 == Unit.U_FLYING_CROSSBOWMAN)
                  {
                        return "FlyingCrossbowman";
                  }
                  if(param1 == Unit.U_MONK)
                  {
                        return "Monk";
                  }
                  if(param1 == Unit.U_MAGIKILL)
                  {
                        return "Magikill";
                  }
                  if(param1 == Unit.U_ENSLAVED_GIANT)
                  {
                        return "EnslavedGiant";
                  }
                  if(param1 == Unit.U_CHAOS_MINER)
                  {
                        return "ChaosMiner";
                  }
                  if(param1 == Unit.U_BOMBER)
                  {
                        return "Bomber";
                  }
                  if(param1 == Unit.U_WINGIDON)
                  {
                        return "Wingadon";
                  }
                  if(param1 == Unit.U_SKELATOR)
                  {
                        return "SkelatalMage";
                  }
                  if(param1 == Unit.U_DEAD)
                  {
                        return "Dead";
                  }
                  if(param1 == Unit.U_CAT)
                  {
                        return "Cat";
                  }
                  if(param1 == Unit.U_KNIGHT)
                  {
                        return "Knight";
                  }
                  if(param1 == Unit.U_MEDUSA)
                  {
                        return "Medusa";
                  }
                  if(param1 == Unit.U_GIANT)
                  {
                        return "Giant";
                  }
                  if(param1 == Unit.U_FIRE_ELEMENT)
                  {
                        return "Fire Element";
                  }
                  if(param1 == Unit.U_EARTH_ELEMENT)
                  {
                        return "Earth Element";
                  }
                  if(param1 == Unit.U_WATER_ELEMENT)
                  {
                        return "Water Element";
                  }
                  if(param1 == Unit.U_AIR_ELEMENT)
                  {
                        return "Air Element";
                  }
                  if(param1 == Unit.U_LAVA_ELEMENT)
                  {
                        return "Lava Element";
                  }
                  if(param1 == Unit.U_HURRICANE_ELEMENT)
                  {
                        return "Hurricane Element";
                  }
                  if(param1 == Unit.U_FIRESTORM_ELEMENT)
                  {
                        return "Firestorm Element";
                  }
                  if(param1 == Unit.U_TREE_ELEMENT)
                  {
                        return "Tree Element";
                  }
                  if(param1 == Unit.U_SCORPION_ELEMENT)
                  {
                        return "Scorpion Element";
                  }
                  if(param1 == Unit.U_CHROME_ELEMENT)
                  {
                        return "Chrome Element";
                  }
                  if(param1 == Unit.U_MINER_ELEMENT)
                  {
                        return "Miner Element";
                  }
                  return "";
            }
            
            public static function unitTypeToXML(param1:int, param2:Main) : XMLList
            {
                  if(param1 == Unit.U_MINER)
                  {
                        return param2.xml.xml.Order.Units.miner;
                  }
                  if(param1 == Unit.U_SWORDWRATH)
                  {
                        return param2.xml.xml.Order.Units.swordwrath;
                  }
                  if(param1 == Unit.U_ARCHER)
                  {
                        return param2.xml.xml.Order.Units.archer;
                  }
                  if(param1 == Unit.U_SPEARTON)
                  {
                        return param2.xml.xml.Order.Units.spearton;
                  }
                  if(param1 == Unit.U_NINJA)
                  {
                        return param2.xml.xml.Order.Units.ninja;
                  }
                  if(param1 == Unit.U_FLYING_CROSSBOWMAN)
                  {
                        return param2.xml.xml.Order.Units.flyingCrossbowman;
                  }
                  if(param1 == Unit.U_MONK)
                  {
                        return param2.xml.xml.Order.Units.monk;
                  }
                  if(param1 == Unit.U_MAGIKILL)
                  {
                        return param2.xml.xml.Order.Units.magikill;
                  }
                  if(param1 == Unit.U_ENSLAVED_GIANT)
                  {
                        return param2.xml.xml.Order.Units.giant;
                  }
                  if(param1 == Unit.U_CHAOS_MINER)
                  {
                        return param2.xml.xml.Chaos.Units.miner;
                  }
                  if(param1 == Unit.U_BOMBER)
                  {
                        return param2.xml.xml.Chaos.Units.bomber;
                  }
                  if(param1 == Unit.U_WINGIDON)
                  {
                        return param2.xml.xml.Chaos.Units.wingidon;
                  }
                  if(param1 == Unit.U_SKELATOR)
                  {
                        return param2.xml.xml.Chaos.Units.skelator;
                  }
                  if(param1 == Unit.U_DEAD)
                  {
                        return param2.xml.xml.Chaos.Units.dead;
                  }
                  if(param1 == Unit.U_CAT)
                  {
                        return param2.xml.xml.Chaos.Units.cat;
                  }
                  if(param1 == Unit.U_KNIGHT)
                  {
                        return param2.xml.xml.Chaos.Units.knight;
                  }
                  if(param1 == Unit.U_MEDUSA)
                  {
                        return param2.xml.xml.Chaos.Units.medusa;
                  }
                  if(param1 == Unit.U_GIANT)
                  {
                        return param2.xml.xml.Chaos.Units.giant;
                  }
                  if(param1 == Unit.U_FIRE_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.fireElement;
                  }
                  if(param1 == Unit.U_EARTH_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.earthElement;
                  }
                  if(param1 == Unit.U_WATER_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.waterElement;
                  }
                  if(param1 == Unit.U_AIR_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.airElement;
                  }
                  if(param1 == Unit.U_LAVA_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.lavaElement;
                  }
                  if(param1 == Unit.U_HURRICANE_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.hurricaneElement;
                  }
                  if(param1 == Unit.U_FIRESTORM_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.firestormElement;
                  }
                  if(param1 == Unit.U_TREE_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.treeElement;
                  }
                  if(param1 == Unit.U_SCORPION_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.scorpionElement;
                  }
                  if(param1 == Unit.U_CHROME_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.chrome;
                  }
                  if(param1 == Unit.U_MINER_ELEMENT)
                  {
                        return param2.xml.xml.Elemental.Units.miner;
                  }
                  return null;
            }
            
            public static function getUnitsInRace(param1:String) : Array
            {
                  if(param1 == "Order")
                  {
                        return orderUnits;
                  }
                  return null;
            }
            
            public static function getRaces() : Array
            {
                  return races;
            }
            
            public function loadItems(param1:Main) : void
            {
                  var _loc3_:MarketItem = null;
                  this._data = new Dictionary();
                  var _loc2_:int = 0;
                  while(_loc2_ < param1.marketItems.length)
                  {
                        _loc3_ = param1.marketItems[_loc2_];
                        this.setItem(unitNameToType(_loc3_.unit),_loc3_.type,_loc3_);
                        _loc2_++;
                  }
            }
            
            public function getItems(param1:int, param2:int) : Array
            {
                  if(!(param1 in this._data))
                  {
                        return [];
                  }
                  if(!(param2 in this._data[param1]))
                  {
                        return [];
                  }
                  return this._data[param1][param2];
            }
            
            public function setItem(param1:int, param2:int, param3:MarketItem) : void
            {
                  if(!(param1 in this._data))
                  {
                        this._data[param1] = new Dictionary();
                  }
                  if(!(param2 in this._data[param1]))
                  {
                        this._data[param1][param2] = [];
                  }
                  this._data[param1][param2].push(param3);
            }
            
            public function get data() : Dictionary
            {
                  return this._data;
            }
            
            public function set data(param1:Dictionary) : void
            {
                  this._data = param1;
            }
      }
}
