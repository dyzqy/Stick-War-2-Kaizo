package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.Pool;
   import com.brockw.game.Util;
   import com.brockw.stickwar.engine.StickWar;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.units.Skelator;
   import com.brockw.stickwar.engine.units.Unit;
   import com.brockw.stickwar.engine.units.elementals.AirElement;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class ProjectileManager
   {
       
      
      private var arrowPool:Pool;
      
      private var gutPool:Pool;
      
      private var boltPool:Pool;
      
      private var electricWallPool:Pool;
      
      private var nukePool:Pool;
      
      private var poisonDartPool:Pool;
      
      private var curePool:Pool;
      
      private var healPool:Pool;
      
      private var _projectiles:Array;
      
      private var _waitingToBeCleaned:Array;
      
      private var _projectileMap:Dictionary;
      
      private var medusaPoisonAmount:int;
      
      private var _airEffects:Array;
      
      private var _game:StickWar;
      
      public function ProjectileManager(param1:StickWar)
      {
         super();
         this._game = param1;
         this._projectileMap = new Dictionary();
         this._projectileMap[Projectile.ARROW] = new Pool(10,Arrow,param1);
         this._projectileMap[Projectile.GUTS] = new Pool(10,Guts,param1);
         this._projectileMap[Projectile.BOLT] = new Pool(10,Bolt,param1);
         this._projectileMap[Projectile.ELECTRIC_WALL] = new Pool(10,ElectricWall,param1);
         this._projectileMap[Projectile.NUKE] = new Pool(10,Nuke,param1);
         this._projectileMap[Projectile.WALL_EXPLOSION] = new Pool(10,WallExplosion,param1);
         this._projectileMap[Projectile.TOWER_SPAWN] = new Pool(10,TowerSpawn,param1);
         this._projectileMap[Projectile.SPAWN_DRIP] = new Pool(10,SpawnDrip,param1);
         this._projectileMap[Projectile.POISON_DART] = new Pool(10,PoisonDart,param1);
         this._projectileMap[Projectile.CURE] = new Pool(10,Cure,param1);
         this._projectileMap[Projectile.HEAL] = new Pool(10,Heal,param1);
         this._projectileMap[Projectile.SLOW_DART] = new Pool(10,SlowDart,param1);
         this._projectileMap[Projectile.BOULDER] = new Pool(10,Boulder,param1);
         this._projectileMap[Projectile.POISON_SPRAY] = new Pool(10,PoisonSpray,param1);
         this._projectileMap[Projectile.FIST_ATTACK] = new Pool(10,FistAttack,param1);
         this._projectileMap[Projectile.REAPER] = new Pool(10,Reaper,param1);
         this._projectileMap[Projectile.POISON_POOL] = new Pool(10,PoisonPool,param1);
         this._projectileMap[Projectile.TOWER_DART] = new Pool(10,ChaosTowerDart,param1);
         this._projectileMap[Projectile.HEAL_EFFECT] = new Pool(10,HealEffect,param1);
         this._projectileMap[Projectile.FIRE_BALL] = new Pool(10,FireBall,param1);
         this._projectileMap[Projectile.SMOKE_PUFF] = new Pool(10,SmokePuff,param1);
         this._projectileMap[Projectile.ICE_FREEZE_EFFECT] = new Pool(10,IceFreezeEffect,param1);
         this._projectileMap[Projectile.FIRE_BALL_EXPLOSION] = new Pool(10,FireBallExplosion,param1);
         this._projectileMap[Projectile.FIRE_BALL_PROJECTILE] = new Pool(10,FireBallProjectile,param1);
         this._projectileMap[Projectile.FIRE_WATER_EXPLOSION] = new Pool(10,FireWaterExplosion,param1);
         this._projectileMap[Projectile.FIRE] = new Pool(10,Fire,param1);
         this._projectileMap[Projectile.LIGHTNING] = new Pool(10,Lightning,param1);
         this._projectileMap[Projectile.PROTECT_EFFECT] = new Pool(10,ProtectEffect,param1);
         this._projectileMap[Projectile.HURRICANE] = new Pool(10,Hurricane,param1);
         this._projectileMap[Projectile.FLOWER] = new Pool(10,Flower,param1);
         this._projectileMap[Projectile.THORN] = new Pool(10,Thorn,param1);
         this._projectileMap[Projectile.FIREBREATH] = new Pool(10,Firebreath,param1);
         this._projectileMap[Projectile.LAVA_SPARK] = new Pool(10,LavaSpark,param1);
         this._projectileMap[Projectile.TELEPORT_EFFECT] = new Pool(10,TeleportEffect,param1);
         this._projectileMap[Projectile.TELEPORT_EFFECT_IN] = new Pool(10,TeleportEffectIn,param1);
         this._projectileMap[Projectile.FIRE_ON_THE_GROUND] = new Pool(10,FireOnTheGround,param1);
         this._projectileMap[Projectile.MOUND_OF_DIRT] = new Pool(10,MoundOfDirt,param1);
         this._projectileMap[Projectile.SANDSTORM_TOWER] = new Pool(10,SandstormTower,param1);
         this._projectileMap[Projectile.SANDSTORM_EYE] = new Pool(10,SandstormEye,param1);
         this._projectileMap[Projectile.FIRESTORM_BACK] = new Pool(10,FirestormBack,param1);
         this._projectileMap[Projectile.FIRESTORM_FRONT] = new Pool(10,FirestormFront,param1);
         this._projectileMap[Projectile.LAVA_RAIN] = new Pool(10,LavaRain,param1);
         this._projectileMap[Projectile.LAVA_COMET] = new Pool(10,LavaComet,param1);
         this._projectileMap[Projectile.COMBINE_EFFECT] = new Pool(10,CombineEffect,param1);
         this.projectiles = [];
         this._waitingToBeCleaned = [];
         this._airEffects = [];
         this.medusaPoisonAmount = param1.xml.xml.Chaos.Units.medusa.poison.poison;
      }
      
      public function cleanUp() : void
      {
         var _loc1_:Projectile = null;
         for each(_loc1_ in this.projectiles)
         {
            this._projectileMap[_loc1_.type].returnItem(_loc1_);
            if(this._game.battlefield.contains(_loc1_))
            {
               this._game.battlefield.removeChild(_loc1_);
            }
         }
         for each(_loc1_ in this._waitingToBeCleaned)
         {
            this._projectileMap[_loc1_.type].returnItem(_loc1_);
            if(this._game.battlefield.contains(_loc1_))
            {
               this._game.battlefield.removeChild(_loc1_);
            }
         }
         this._waitingToBeCleaned = [];
         this.projectiles = [];
      }
      
      public function initReaper(param1:Unit, param2:Unit) : void
      {
         var _loc3_:Reaper = Reaper(this._projectileMap[Projectile.REAPER].getItem());
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.inflictor = param1;
         _loc3_.target = param2;
         _loc3_.init(param1.px,param1.py,param1.pz,param2,0,param1.team);
         _loc3_.visible = false;
         _loc3_.damageToDeal = param1.team.game.xml.xml.Chaos.Units.skelator.reaper.damage;
         this.projectiles.push(_loc3_);
         param1.team.game.battlefield.addChild(_loc3_);
         param1.team.game.soundManager.playSoundRandom("ReaperAir",3,param1.px,param1.py);
      }
      
      public function initLightning(param1:Unit, param2:Unit, param3:Number) : void
      {
         var _loc4_:Lightning = null;
         if((_loc4_ = Lightning(this._projectileMap[Projectile.LIGHTNING].getItem())) == null)
         {
            return;
         }
         _loc4_.inflictor = param1;
         _loc4_.target = param2;
         _loc4_.init(param1.px,param1.py,param1.pz,param2,0,param1.team);
         _loc4_.burnDamage = AirElement(param1).burnDamage;
         _loc4_.burnFrames = AirElement(param1).burnFrames;
         _loc4_.burnRadius = AirElement(param1).burnRadius;
         _loc4_.visible = false;
         this.projectiles.push(_loc4_);
         param1.team.game.battlefield.addChild(_loc4_);
         Util.animateToNeutral(_loc4_.spellMc);
         var _loc5_:int = Math.floor(param1.team.game.random.nextNumber() * _loc4_.spellMc.totalFrames) + 1;
         _loc4_.spellMc.gotoAndStop(_loc5_);
         param1.team.game.soundManager.playSoundRandom("lightningSound",3,param1.px,param1.py);
      }
      
      public function initFireBall(param1:Number, param2:Number, param3:Unit, param4:Unit) : void
      {
         var _loc5_:FireBall = null;
         if((_loc5_ = FireBall(this._projectileMap[Projectile.FIRE_BALL].getItem())) == null)
         {
            return;
         }
         _loc5_.inflictor = param3;
         _loc5_.target = param4;
         _loc5_.team = param3.team;
         _loc5_.init(param1,param2,0,param4,0,param3.team);
         _loc5_.visible = false;
         this.projectiles.push(_loc5_);
         param3.team.game.battlefield.addChild(_loc5_);
      }
      
      public function initFirebreath(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:Number, param7:Number, param8:int) : void
      {
         var _loc9_:Firebreath = null;
         if((_loc9_ = Firebreath(this._projectileMap[Projectile.FIREBREATH].getItem())) == null)
         {
            return;
         }
         _loc9_.visible = true;
         _loc9_.px = param1;
         _loc9_.py = param2;
         _loc9_.pz = param3;
         _loc9_.x = _loc9_.px;
         _loc9_.y = _loc9_.py;
         _loc9_.z = _loc9_.pz;
         _loc9_.alpha = 1;
         _loc9_.burnDamage = param7;
         _loc9_.burnFrames = param8;
         _loc9_.scale = param6;
         var _loc10_:StickWar = param4.game;
         _loc9_.scaleX = param6 * param5 * (_loc10_.backScale + param2 / _loc10_.map.height * (_loc10_.frontScale - _loc10_.backScale));
         _loc9_.scaleY = param6 * (_loc10_.backScale + param2 / _loc10_.map.height * (_loc10_.frontScale - _loc10_.backScale));
         Util.animateToNeutral(_loc9_.spellMc);
         _loc9_.spellMc.gotoAndStop(1);
         _loc9_.stunTime = 0;
         this.projectiles.push(_loc9_);
         param4.game.battlefield.addChild(_loc9_);
         _loc9_.team = param4;
      }
      
      public function initFistAttack(param1:Number, param2:Number, param3:Unit, param4:int) : void
      {
         var _loc5_:FistAttack = null;
         if((_loc5_ = FistAttack(this._projectileMap[Projectile.FIST_ATTACK].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = false;
         var _loc6_:Point = MovieClip(param3.mc).localToGlobal(new Point(0,0));
         var _loc7_:Point = param3.team.game.battlefield.globalToLocal(_loc6_);
         _loc5_.team = param3.team;
         _loc5_.x = _loc7_.x;
         _loc5_.y = _loc7_.y;
         _loc5_.startX = _loc7_.x;
         _loc5_.startY = _loc7_.y;
         _loc5_.endX = param1;
         _loc5_.endY = param2;
         var _loc8_:Number = Math.sqrt(Math.pow(_loc5_.endX - _loc5_.startX,2) + Math.pow(_loc5_.endY - _loc5_.startY,2));
         var _loc9_:Number = (_loc5_.endX - _loc5_.startX) / _loc8_;
         var _loc10_:Number = (_loc5_.endY - _loc5_.startY) / _loc8_;
         var _loc11_:Number = param4 + 1.5;
         _loc5_.x = _loc5_.px = _loc5_.startX + _loc9_ * _loc11_ * 400 / 6;
         _loc5_.y = _loc5_.py = _loc5_.startY + _loc10_ * _loc11_ * 400 / 6;
         _loc5_.inflictor = param3;
         _loc5_.damageToDeal = Skelator(param3).fistDamage;
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.stunTime = 0;
         param3.team.game.battlefield.addChild(_loc5_);
         this.projectiles.push(_loc5_);
         _loc5_.visible = false;
         if(_loc5_.py < 0)
         {
            _loc5_.visible = false;
         }
      }
      
      public function initPoisonSpray(param1:Number, param2:Number, param3:Unit, param4:Number) : void
      {
         var _loc5_:PoisonSpray = null;
         if((_loc5_ = PoisonSpray(this._projectileMap[Projectile.POISON_SPRAY].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = false;
         _loc5_.px = param3.px;
         _loc5_.py = param3.py;
         _loc5_.inflictor = param3;
         var _loc6_:Number = Math.sqrt(Math.pow(param3.px - param1,2) + Math.pow(param3.py - param2,2));
         var _loc7_:Number = (param1 - param3.px) / _loc6_;
         var _loc8_:Number = (param2 - param3.py) / _loc6_;
         param1 = param3.px + _loc7_ * param4;
         param2 = param3.py + _loc8_ * param4;
         var _loc9_:Point = MovieClip(param3.mc.mc.wizstaff).localToGlobal(new Point(0,0));
         var _loc10_:Point = param3.team.game.battlefield.globalToLocal(_loc9_);
         _loc5_.team = param3.team;
         _loc5_.x = _loc10_.x;
         _loc5_.y = _loc10_.y;
         _loc5_.startX = _loc10_.x;
         _loc5_.startY = _loc10_.y;
         _loc5_.endX = param1;
         _loc5_.endY = param2;
         _loc5_.rotation = 180 / Math.PI * Math.atan2(param2 - _loc5_.py,param1 - _loc5_.px);
         _loc5_.poisonDamage = param3.team.game.xml.xml.Order.Units.magikill.poisonSpray.damage;
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.stunTime = 0;
         param3.team.game.battlefield.addChild(_loc5_);
         this.projectiles.push(_loc5_);
      }
      
      public function initSlowDart(param1:Number, param2:Number, param3:Number, param4:Unit, param5:Unit) : void
      {
         var _loc6_:SlowDart = null;
         if((_loc6_ = SlowDart(this._projectileMap[Projectile.SLOW_DART].getItem())) == null)
         {
            return;
         }
         _loc6_.inflictor = param4;
         _loc6_.init(param1,param2,param3,param5,0,param4.team);
         _loc6_.slowFrames = param5.team.game.xml.xml.Order.Units.monk.slowFrames;
         this.projectiles.push(_loc6_);
         param4.team.game.battlefield.addChild(_loc6_);
         _loc6_.visible = false;
      }
      
      public function initTowerDart(param1:Number, param2:Number, param3:Number, param4:Unit, param5:Unit) : void
      {
         var _loc6_:ChaosTowerDart = null;
         if((_loc6_ = ChaosTowerDart(this._projectileMap[Projectile.TOWER_DART].getItem())) == null)
         {
            return;
         }
         _loc6_.inflictor = param4;
         _loc6_.init(param1,param2,param3,param5,0,param4.team);
         this.projectiles.push(_loc6_);
         param4.team.game.battlefield.addChild(_loc6_);
         _loc6_.visible = false;
      }
      
      public function initArrow(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Unit, param8:Number, param9:Number, param10:Boolean, param11:Number, param12:Number, param13:Unit, param14:Number, param15:int) : void
      {
         var _loc16_:Arrow = null;
         (_loc16_ = Arrow(this._projectileMap[Projectile.ARROW].getItem())).setArrowGraphics(param10 > 0 ? true : false);
         _loc16_.isFire = param10;
         if(_loc16_ == null)
         {
            return;
         }
         _loc16_.initProjectile();
         _loc16_.px = param1;
         _loc16_.py = param7.py;
         _loc16_.pz = param2 - param7.py;
         var _loc17_:Number = param7.team.game.backScale + param7.py / param7.team.game.map.height * (param7.team.game.frontScale - param7.team.game.backScale);
         if(param10)
         {
            _loc16_.burnDamage = param14;
            _loc16_.burnFrames = param15;
         }
         else
         {
            _loc16_.burnDamage = 0;
            _loc16_.burnFrames = 0;
         }
         _loc16_.inflictor = param7;
         _loc16_.scaleX = _loc17_;
         _loc16_.scaleY = _loc17_;
         _loc16_.dx = param4 * Util.cos(param3 * Math.PI / 180);
         _loc16_.dz = param4 * Util.sin(param3 * Math.PI / 180);
         _loc16_.dy = param6;
         _loc16_.team = param7.team;
         _loc16_.x = -100;
         _loc16_.y = -100;
         _loc16_.damageToDeal = param8;
         _loc16_.stunTime = 0;
         if(param7.team.isEnemy && !param7.isCastleArcher)
         {
            _loc16_.slowFrames = 7;
         }
         else
         {
            _loc16_.slowFrames = 0;
         }
         _loc16_.poisonDamage = param9;
         _loc16_.visible = false;
         _loc16_.area = param11;
         _loc16_.areaDamage = param12;
         this.projectiles.push(_loc16_);
         param7.team.game.battlefield.addChild(_loc16_);
         _loc16_.intendedTarget = param13;
         _loc16_.update(param7.team.game);
         _loc16_.update(param7.team.game);
      }
      
      public function initBoulder(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Unit, param8:Number, param9:Boolean, param10:Unit = null) : void
      {
         var _loc11_:Boulder = null;
         if((_loc11_ = Boulder(this._projectileMap[Projectile.BOULDER].getItem())) == null)
         {
            return;
         }
         var _loc12_:Number = param7.team.game.backScale + param7.py / param7.team.game.map.height * (param7.team.game.frontScale - param7.team.game.backScale);
         _loc11_.initProjectile();
         _loc11_.px = param1;
         _loc11_.py = param7.py;
         _loc11_.pz = param2 - param7.py;
         _loc11_.inflictor = param7;
         _loc11_.intendedTarget = param10;
         _loc11_.dx = param4 * Util.cos(param3 * Math.PI / 180);
         _loc11_.dz = param4 * Util.sin(param3 * Math.PI / 180);
         _loc11_.dy = param6;
         _loc11_.team = param7.team;
         _loc11_.x = -100;
         _loc11_.y = -100;
         _loc11_.scale = 1;
         _loc11_.stunTime = 0;
         _loc11_.drotation = param7.team.game.random.nextInt() % 4 - 2;
         _loc11_.rot = param7.team.game.random.nextInt() % 360;
         _loc11_.isDebris = false;
         this.projectiles.push(_loc11_);
         _loc11_.visible = false;
         param7.team.game.battlefield.addChild(_loc11_);
      }
      
      public function initBoulderDebris(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:StickWar, param9:Unit, param10:Unit) : void
      {
         var _loc11_:Boulder = null;
         if((_loc11_ = Boulder(this._projectileMap[Projectile.BOULDER].getItem())) == null)
         {
            return;
         }
         _loc11_.initProjectile();
         _loc11_.visible = false;
         _loc11_.px = param1;
         _loc11_.py = param2;
         _loc11_.pz = param3;
         _loc11_.dx = param4;
         _loc11_.dz = param6;
         _loc11_.dy = param5;
         _loc11_.x = -100;
         _loc11_.y = -100;
         _loc11_.isDebris = true;
         _loc11_.inflictor = null;
         _loc11_.unitNotToHit = param10;
         _loc11_.scale = param7;
         _loc11_.damageToDeal = param8.xml.xml.Order.Units.giant.debrisDamage;
         _loc11_.stunTime = 0;
         _loc11_.drotation = param8.random.nextInt() % 4 - 2;
         _loc11_.rot = param8.random.nextInt() % 360;
         this.projectiles.push(_loc11_);
         param8.battlefield.addChild(_loc11_);
      }
      
      public function initBolt(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Unit, param8:Number, param9:int, param10:Boolean, param11:Unit, param12:Number, param13:int) : void
      {
         var _loc14_:Bolt = null;
         if((_loc14_ = Bolt(this._projectileMap[Projectile.BOLT].getItem())) == null)
         {
            return;
         }
         _loc14_.initProjectile();
         _loc14_.visible = false;
         _loc14_.inflictor = param7;
         var _loc15_:Number = param7.team.game.backScale + param7.py / param7.team.game.map.height * (param7.team.game.frontScale - param7.team.game.backScale);
         _loc14_.px = param1;
         _loc14_.py = param7.py;
         _loc14_.pz = param2 - param7.py;
         if(param10)
         {
            _loc14_.burnDamage = param12;
            _loc14_.burnFrames = param13;
         }
         else
         {
            _loc14_.burnDamage = 0;
            _loc14_.burnFrames = 0;
         }
         _loc14_.dx = param4 * Util.cos(param3 * Math.PI / 180);
         _loc14_.dz = param4 * Util.sin(param3 * Math.PI / 180);
         _loc14_.dy = param6;
         _loc14_.team = param7.team;
         _loc14_.x = -100;
         _loc14_.intendedTarget = param11;
         _loc14_.y = -100;
         _loc14_.damageToDeal = param8;
         _loc14_.slowFrames = 0;
         _loc14_.isFire = param10;
         _loc14_.setArrowGraphics(param10);
         this.projectiles.push(_loc14_);
         param7.team.game.battlefield.addChild(_loc14_);
         _loc14_.update(param7.team.game);
         _loc14_.update(param7.team.game);
         _loc14_.update(param7.team.game);
      }
      
      public function initFireBallProjectile(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Unit, param9:Unit, param10:Number, param11:int) : void
      {
         var _loc12_:FireBallProjectile = null;
         if((_loc12_ = FireBallProjectile(this._projectileMap[Projectile.FIRE_BALL_PROJECTILE].getItem())) == null)
         {
            return;
         }
         _loc12_.initProjectile();
         _loc12_.visible = true;
         _loc12_.px = param1;
         _loc12_.py = param8.py;
         _loc12_.pz = param2 - param8.py;
         _loc12_.inflictor = param8;
         _loc12_.poisonDamage = 0;
         _loc12_.burnDamage = param10;
         _loc12_.burnFrames = param11;
         _loc12_.dx = param4 * Util.cos(param3 * Math.PI / 180);
         _loc12_.dz = param4 * Util.sin(param3 * Math.PI / 180);
         _loc12_.dy = param6;
         _loc12_.team = param8.team;
         _loc12_.t = 0;
         _loc12_.intendedTarget = param9;
         _loc12_.x = -100;
         _loc12_.y = -100;
         _loc12_.stunTime = 0;
         this.projectiles.push(_loc12_);
         param8.team.game.battlefield.addChild(_loc12_);
         param8.team.game.soundManager.playSoundRandom("shootingfireSound",3,param8.px,param8.py);
      }
      
      public function initGuts(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Unit, param9:Unit = null) : void
      {
         var _loc10_:Guts = null;
         if((_loc10_ = Guts(this._projectileMap[Projectile.GUTS].getItem())) == null)
         {
            return;
         }
         _loc10_.initProjectile();
         _loc10_.visible = true;
         _loc10_.px = param1;
         _loc10_.py = param8.py;
         _loc10_.pz = param2 - param8.py;
         _loc10_.inflictor = param8;
         _loc10_.poisonDamage = param7;
         _loc10_.dx = param4 * Util.cos(param3 * Math.PI / 180);
         _loc10_.dz = param4 * Util.sin(param3 * Math.PI / 180);
         _loc10_.dy = param6;
         _loc10_.team = param8.team;
         _loc10_.intendedTarget = param9;
         _loc10_.x = -100;
         _loc10_.y = -100;
         _loc10_.drotation = param8.team.game.random.nextInt() % 4 - 2;
         _loc10_.rot = param8.team.game.random.nextInt() % 360;
         _loc10_.stunTime = 0;
         this.projectiles.push(_loc10_);
         param8.team.game.battlefield.addChild(_loc10_);
      }
      
      public function initStun(param1:Number, param2:Number, param3:int, param4:Unit) : void
      {
         var _loc5_:ElectricWall = null;
         if((_loc5_ = ElectricWall(this._projectileMap[Projectile.ELECTRIC_WALL].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         if(Math.abs(param1 - param4.x) > param4.team.game.xml.xml.Order.Units.magikill.electricWall.range)
         {
            param1 = -param4.team.game.xml.xml.Order.Units.magikill.electricWall.area / 2 + param4.x + Util.sgn(param1 - param4.x) * param4.team.game.xml.xml.Order.Units.magikill.electricWall.range;
         }
         _loc5_.inflictor = param4;
         _loc5_.damageToDeal = param4.team.game.xml.xml.Order.Units.magikill.electricWall.damage;
         _loc5_.px = param1;
         _loc5_.py = 0;
         _loc5_.spellMc.height = param4.team.game.map.height;
         _loc5_.team = param4.team;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         _loc5_.spellMc.gotoAndStop(1);
         this.projectiles.push(_loc5_);
         param4.team.game.battlefield.addChild(_loc5_);
         param4.team.game.soundManager.playSound("ElectricWallSoundEffect",param1,param2);
      }
      
      public function initHurricane(param1:Number, param2:Number, param3:Unit, param4:Number) : void
      {
         var _loc5_:Hurricane = null;
         if((_loc5_ = Hurricane(this._projectileMap[Projectile.HURRICANE].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         _loc5_.alreadyHit = new Dictionary();
         var _loc6_:Number = Math.sqrt(Math.pow(param3.px - param1,2) + Math.pow(param3.py - param2,2));
         var _loc7_:Number = (param1 - param3.px) / _loc6_;
         var _loc8_:Number = (param2 - param3.py) / _loc6_;
         param1 = param3.px + _loc7_ * param3.team.game.xml.xml.Elemental.Units.hurricaneElement.hurricane.range;
         param2 = param3.py + _loc8_ * param3.team.game.xml.xml.Elemental.Units.hurricaneElement.hurricane.range;
         _loc5_.inflictor = param3;
         _loc5_.endX = param1;
         _loc5_.endY = param2;
         _loc5_.px = param3.px;
         _loc5_.py = param3.py;
         _loc5_.team = param3.team;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         _loc5_.arrived = false;
         Util.animateToNeutral(_loc5_.spellMc);
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.stunTime = 0;
         this.projectiles.push(_loc5_);
         param3.team.game.battlefield.addChild(_loc5_);
      }
      
      public function initLavaComet(param1:Number, param2:Number, param3:Unit, param4:Number, param5:Number, param6:int) : void
      {
         var _loc7_:LavaComet = null;
         if((_loc7_ = LavaComet(this._projectileMap[Projectile.LAVA_COMET].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = false;
         _loc7_.scale = 1.5 * param3.team.direction;
         _loc7_.inflictor = param3;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.team = param3.team;
         _loc7_.x = _loc7_.px;
         _loc7_.y = _loc7_.py;
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         _loc7_.explosionDamage = param4;
         this.projectiles.push(_loc7_);
         param3.team.game.battlefield.addChild(_loc7_);
      }
      
      public function initLavaRain(param1:Number, param2:Number, param3:Unit, param4:Number, param5:Number, param6:int) : void
      {
         var _loc7_:LavaRain = null;
         if((_loc7_ = LavaRain(this._projectileMap[Projectile.LAVA_RAIN].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = false;
         _loc7_.burnDamage = param5;
         _loc7_.burnFrames = param6;
         _loc7_.scale = 2 * param3.team.direction;
         _loc7_.inflictor = param3;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.team = param3.team;
         _loc7_.x = _loc7_.px;
         _loc7_.y = _loc7_.py;
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         _loc7_.explosionDamage = param4;
         this.projectiles.push(_loc7_);
         param3.team.game.battlefield.addChild(_loc7_);
      }
      
      public function initNuke(param1:Number, param2:Number, param3:Unit, param4:Number, param5:Number, param6:int) : void
      {
         var _loc7_:Nuke = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if((_loc7_ = Nuke(this._projectileMap[Projectile.NUKE].getItem())) == null)
         {
            return;
         }
         _loc7_.inflictor = param3;
         if(_loc7_.inflictor.type == Unit.U_BOMBER)
         {
            _loc7_.whoNuked = _loc7_.inflictor.bomberType;
         }
         _loc7_.visible = true;
         if(Math.abs(param1 - param3.px) > param3.team.game.xml.xml.Order.Units.magikill.nuke.range)
         {
            param1 = param3.px + Util.sgn(param1 - param3.px) * param3.team.game.xml.xml.Order.Units.magikill.nuke.range;
         }
         _loc7_.burnDamage = param5;
         _loc7_.burnFrames = param6;
         _loc7_.inflictor = param3;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.team = param3.team;
         _loc7_.x = _loc7_.px;
         _loc7_.y = _loc7_.py;
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         _loc7_.explosionDamage = param4;
         this.projectiles.push(_loc7_);
         param3.team.game.battlefield.addChild(_loc7_);
         param3.team.game.bloodManager.addAsh(param1,param2,param3.team.direction,param3.team.game);
         var _loc8_:int = 0;
         while(_loc8_ < 5)
         {
            param1 = param1 + param3.team.game.random.nextNumber() * 100 - 50;
            param2 = param2 + param3.team.game.random.nextNumber() * 50 - 25;
            _loc9_ = param3.team.game.random.nextNumber() < 0.5 ? Number(1) : Number(-1);
            _loc10_ = 1 + param3.team.game.random.nextNumber() * 1;
            param3.team.game.projectileManager.initFireOnTheGround(param1,param2,0,param3.team,_loc9_,_loc10_);
            _loc8_++;
         }
      }
      
      public function initFireWaterExplosion(param1:Number, param2:Number, param3:Unit, param4:Number, param5:Number, param6:int, param7:int, param8:Number) : void
      {
         var _loc9_:FireWaterExplosion = null;
         if((_loc9_ = FireWaterExplosion(this._projectileMap[Projectile.FIRE_WATER_EXPLOSION].getItem())) == null)
         {
            return;
         }
         _loc9_.visible = true;
         if(Math.abs(param1 - param3.px) > param3.team.game.xml.xml.Order.Units.magikill.nuke.range)
         {
            param1 = param3.px + Util.sgn(param1 - param3.px) * param3.team.game.xml.xml.Order.Units.magikill.nuke.range;
         }
         _loc9_.inflictor = param3;
         _loc9_.px = param1;
         _loc9_.py = param2;
         _loc9_.burnDamage = param5;
         _loc9_.burnFrames = param6;
         _loc9_.stunTime = param7;
         _loc9_.stunForce = param8;
         _loc9_.team = param3.team;
         _loc9_.x = _loc9_.px;
         _loc9_.y = _loc9_.py;
         Util.animateToNeutral(_loc9_.spellMc);
         _loc9_.spellMc.gotoAndStop(1);
         _loc9_.explosionDamage = param4;
         this.projectiles.push(_loc9_);
         param3.team.game.battlefield.addChild(_loc9_);
         param3.team.game.bloodManager.addAsh(param1,param2,param3.team.direction,param3.team.game);
         param3.team.game.soundManager.playSoundRandom("mediumExplosion",3,param1,param2);
         param3.team.game.soundManager.playSound("waterSplashSound",param1,param2);
      }
      
      public function initWallExplosion(param1:Number, param2:Number, param3:Team) : void
      {
         var _loc4_:WallExplosion = null;
         if((_loc4_ = WallExplosion(this._projectileMap[Projectile.WALL_EXPLOSION].getItem())) == null)
         {
            return;
         }
         _loc4_.visible = true;
         _loc4_.px = param1;
         _loc4_.py = param2;
         _loc4_.x = _loc4_.px;
         _loc4_.y = _loc4_.py;
         Util.animateToNeutral(_loc4_.spellMc);
         _loc4_.spellMc.gotoAndStop(1);
         _loc4_.stunTime = 0;
         this.projectiles.push(_loc4_);
         param3.game.battlefield.addChild(_loc4_);
         param3.game.bloodManager.addAsh(param1,param2,param3.direction,param3.game);
      }
      
      public function initTowerSpawn(param1:Number, param2:Number, param3:Team, param4:Number = 1) : void
      {
         var _loc5_:TowerSpawn = null;
         if((_loc5_ = TowerSpawn(this._projectileMap[Projectile.TOWER_SPAWN].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         _loc5_.px = param1;
         _loc5_.py = param2;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         Util.animateToNeutral(_loc5_.spellMc);
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.scale = param4;
         _loc5_.stunTime = 0;
         this.projectiles.push(_loc5_);
         param3.game.battlefield.addChild(_loc5_);
         _loc5_.team = param3;
      }
      
      public function initProtectEffect(param1:Unit, param2:int, param3:Team) : void
      {
         var _loc4_:ProtectEffect = null;
         if((_loc4_ = ProtectEffect(this._projectileMap[Projectile.PROTECT_EFFECT].getItem())) == null)
         {
            return;
         }
         _loc4_.visible = true;
         _loc4_.timeToLive = param2;
         _loc4_.target = param1;
         _loc4_.x = param1.px;
         _loc4_.y = param1.py;
         Util.animateToNeutral(_loc4_.spellMc);
         _loc4_.spellMc.gotoAndStop(1);
         _loc4_.stunTime = 0;
         this.projectiles.push(_loc4_);
         param3.game.battlefield.addChild(_loc4_);
         _loc4_.team = param3;
      }
      
      public function initSpawnDrip(param1:Number, param2:Number, param3:Team) : void
      {
         var _loc4_:SpawnDrip = null;
         if((_loc4_ = SpawnDrip(this._projectileMap[Projectile.SPAWN_DRIP].getItem())) == null)
         {
            return;
         }
         _loc4_.visible = true;
         _loc4_.px = param1;
         _loc4_.py = param2;
         _loc4_.x = _loc4_.px;
         _loc4_.y = _loc4_.py;
         Util.animateToNeutral(_loc4_.spellMc);
         _loc4_.spellMc.gotoAndStop(1);
         _loc4_.stunTime = 0;
         this.projectiles.push(_loc4_);
         param3.game.battlefield.addChild(_loc4_);
         _loc4_.team = param3;
      }
      
      public function initFlower(param1:Number, param2:Number, param3:Team) : Flower
      {
         var _loc4_:Flower = null;
         if((_loc4_ = Flower(this._projectileMap[Projectile.FLOWER].getItem())) == null)
         {
            return;
         }
         _loc4_.visible = true;
         _loc4_.px = param1;
         _loc4_.py = param2;
         _loc4_.x = _loc4_.px;
         _loc4_.y = _loc4_.py;
         Util.animateToNeutral(_loc4_.spellMc);
         _loc4_.scale = 0.3 + param3.game.random.nextNumber() * 0.5;
         var _loc5_:int = Math.floor(param3.game.random.nextNumber() * _loc4_.spellMc.totalFrames);
         _loc4_.spellMc.gotoAndStop(_loc5_ + 1);
         _loc4_.hasBloomed = false;
         _loc4_.stunTime = 0;
         this.projectiles.push(_loc4_);
         param3.game.battlefield.addChild(_loc4_);
         _loc4_.team = param3;
         return _loc4_;
      }
      
      public function initThorn(param1:Number, param2:Number, param3:Unit, param4:Unit, param5:Team, param6:Number, param7:int) : void
      {
         var _loc8_:Thorn = null;
         if((_loc8_ = Thorn(this._projectileMap[Projectile.THORN].getItem())) == null)
         {
            return;
         }
         _loc8_.visible = true;
         _loc8_.inflictor = param3;
         _loc8_.target = param4;
         _loc8_.stunTime = param7;
         _loc8_.px = param1;
         _loc8_.py = param2;
         _loc8_.x = _loc8_.px;
         _loc8_.y = _loc8_.py;
         _loc8_.damageToDeal = param6;
         Util.animateToNeutral(_loc8_.spellMc);
         _loc8_.spellMc.gotoAndStop(1);
         this.projectiles.push(_loc8_);
         param5.game.battlefield.addChild(_loc8_);
         _loc8_.team = param5;
      }
      
      public function initFireBallExplosion(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:FireBallExplosion = null;
         if((_loc6_ = FireBallExplosion(this._projectileMap[Projectile.FIRE_BALL_EXPLOSION].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initTeleportEffectIn(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:TeleportEffectIn = null;
         if((_loc6_ = TeleportEffectIn(this._projectileMap[Projectile.TELEPORT_EFFECT_IN].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = false;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initTeleportEffect(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:TeleportEffect = null;
         if((_loc6_ = TeleportEffect(this._projectileMap[Projectile.TELEPORT_EFFECT].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = false;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initFireOnTheGround(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:Number) : void
      {
         var _loc7_:FireOnTheGround = null;
         if((_loc7_ = FireOnTheGround(this._projectileMap[Projectile.FIRE_ON_THE_GROUND].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = false;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.pz = param3;
         _loc7_.alpha = 1;
         var _loc8_:StickWar = param4.game;
         _loc7_.scaleX = 0.3 * param6 * param5 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         _loc7_.scaleY = 0.3 * param6 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(Math.floor(_loc8_.random.nextNumber() * 60));
         _loc7_.stunTime = 0;
         this.projectiles.push(_loc7_);
         param4.game.battlefield.addChild(_loc7_);
         _loc7_.team = param4;
      }
      
      public function initSandstormEye(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:int) : void
      {
         var _loc7_:SandstormEye = null;
         if((_loc7_ = SandstormEye(this._projectileMap[Projectile.SANDSTORM_EYE].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = true;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.pz = param3;
         _loc7_.alpha = 1;
         _loc7_.lifeFrames = param6;
         var _loc8_:StickWar = param4.game;
         _loc7_.scaleX = 1.3 * param5 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         _loc7_.scaleY = 1.3 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         this.projectiles.push(_loc7_);
         param4.game.battlefield.addChild(_loc7_);
         _loc7_.team = param4;
      }
      
      public function initSandstormTower(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:int) : void
      {
         var _loc7_:SandstormTower = SandstormTower(this._projectileMap[Projectile.SANDSTORM_TOWER].getItem());
         param4.game.soundManager.playSound("blindGateSound",param1,param2);
         if(_loc7_ == null)
         {
            return;
         }
         _loc7_.visible = true;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.pz = param3;
         _loc7_.alpha = 1;
         _loc7_.lifeFrames = param6;
         _loc7_.isReversing = false;
         var _loc8_:StickWar = param4.game;
         _loc7_.scaleX = param5 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         _loc7_.scaleY = _loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale);
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         this.projectiles.push(_loc7_);
         param4.game.battlefield.addChild(_loc7_);
         _loc7_.team = param4;
      }
      
      public function initFirestorm(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:Number, param7:int, param8:Number, param9:Number) : void
      {
         var _loc10_:FirestormBack = null;
         var _loc12_:FirestormFront = null;
         var _loc11_:StickWar = null;
         if((_loc10_ = FirestormBack(this._projectileMap[Projectile.FIRESTORM_BACK].getItem())) == null)
         {
            return;
         }
         _loc10_.visible = true;
         _loc10_.px = param1;
         _loc10_.py = param2 + 20;
         _loc10_.pz = param3;
         _loc10_.y = param2;
         _loc10_.x = param1;
         _loc10_.alpha = 1;
         _loc10_.damageToDeal = param6;
         _loc10_.burnDamage = param8;
         _loc10_.burnFrames = param7;
         _loc10_.stunForce = param9;
         _loc11_ = param4.game;
         _loc10_.scaleX = param5 * (_loc11_.backScale + param2 / _loc11_.map.height * (_loc11_.frontScale - _loc11_.backScale));
         _loc10_.scaleY = _loc11_.backScale + param2 / _loc11_.map.height * (_loc11_.frontScale - _loc11_.backScale);
         Util.animateToNeutral(_loc10_.spellMc);
         _loc10_.spellMc.gotoAndStop(1);
         _loc10_.stunTime = 0;
         this.projectiles.push(_loc10_);
         param4.game.battlefield.addChild(_loc10_);
         _loc10_.team = param4;
         if((_loc12_ = FirestormFront(this._projectileMap[Projectile.FIRESTORM_FRONT].getItem())) == null)
         {
            return;
         }
         _loc12_.visible = true;
         _loc12_.px = param1;
         _loc12_.py = param2 - 20;
         _loc12_.y = param2;
         _loc12_.pz = param3;
         _loc12_.x = param1;
         _loc12_.alpha = 1;
         _loc11_ = param4.game;
         _loc12_.scaleX = param5 * (_loc11_.backScale + param2 / _loc11_.map.height * (_loc11_.frontScale - _loc11_.backScale));
         _loc12_.scaleY = _loc11_.backScale + param2 / _loc11_.map.height * (_loc11_.frontScale - _loc11_.backScale);
         Util.animateToNeutral(_loc12_.spellMc);
         _loc12_.spellMc.gotoAndStop(1);
         _loc12_.stunTime = 0;
         this.projectiles.push(_loc12_);
         param4.game.battlefield.addChild(_loc12_);
         _loc12_.team = param4;
      }
      
      public function initCombineEffect(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:CombineEffect = null;
         if((_loc6_ = CombineEffect(this._projectileMap[Projectile.COMBINE_EFFECT].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initSmokePuff(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:SmokePuff = null;
         if((_loc6_ = SmokePuff(this._projectileMap[Projectile.SMOKE_PUFF].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initMound(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:MoundOfDirt = null;
         if((_loc6_ = MoundOfDirt(this._projectileMap[Projectile.MOUND_OF_DIRT].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.x = _loc6_.px;
         _loc6_.y = _loc6_.py;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initLavaSpark(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:LavaSpark = null;
         if((_loc6_ = LavaSpark(this._projectileMap[Projectile.LAVA_SPARK].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.x = _loc6_.px;
         _loc6_.y = _loc6_.py;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initFire(param1:Number, param2:Number, param3:Number, param4:Team, param5:int, param6:Number = 1) : void
      {
         var _loc7_:Fire = null;
         if((_loc7_ = Fire(this._projectileMap[Projectile.FIRE].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = true;
         _loc7_.px = param1;
         _loc7_.py = param2;
         _loc7_.pz = param3;
         _loc7_.x = _loc7_.px;
         _loc7_.y = _loc7_.py;
         _loc7_.z = _loc7_.pz;
         _loc7_.alpha = 1;
         _loc7_.scale = param6;
         var _loc8_:StickWar = param4.game;
         _loc7_.scaleX = param6 * param5 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         _loc7_.scaleY = param6 * (_loc8_.backScale + param2 / _loc8_.map.height * (_loc8_.frontScale - _loc8_.backScale));
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         this.projectiles.push(_loc7_);
         param4.game.battlefield.addChild(_loc7_);
         _loc7_.team = param4;
      }
      
      public function initFreezeEffect(param1:Number, param2:Number, param3:Number, param4:Team, param5:int) : void
      {
         var _loc6_:IceFreezeEffect = null;
         if((_loc6_ = IceFreezeEffect(this._projectileMap[Projectile.ICE_FREEZE_EFFECT].getItem())) == null)
         {
            return;
         }
         _loc6_.visible = true;
         _loc6_.px = param1;
         _loc6_.py = param2;
         _loc6_.pz = param3;
         _loc6_.x = _loc6_.px;
         _loc6_.y = _loc6_.py;
         _loc6_.alpha = 1;
         var _loc7_:StickWar = param4.game;
         _loc6_.scaleX = param5 * (_loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale));
         _loc6_.scaleY = _loc7_.backScale + param2 / _loc7_.map.height * (_loc7_.frontScale - _loc7_.backScale);
         Util.animateToNeutral(_loc6_.spellMc);
         _loc6_.spellMc.gotoAndStop(1);
         _loc6_.stunTime = 0;
         this.projectiles.push(_loc6_);
         param4.game.battlefield.addChild(_loc6_);
         _loc6_.team = param4;
      }
      
      public function initHealEffect(param1:Number, param2:Number, param3:Number, param4:Team, param5:Unit, param6:Boolean = false) : void
      {
         var _loc7_:HealEffect = null;
         if((_loc7_ = HealEffect(this._projectileMap[Projectile.HEAL_EFFECT].getItem())) == null)
         {
            return;
         }
         _loc7_.visible = true;
         _loc7_.isCure = param6;
         _loc7_.unit = param5;
         _loc7_.px = param1;
         _loc7_.py = param3;
         _loc7_.x = _loc7_.px;
         _loc7_.y = param2;
         Util.animateToNeutral(_loc7_.spellMc);
         _loc7_.spellMc.gotoAndStop(1);
         _loc7_.stunTime = 0;
         this.projectiles.push(_loc7_);
         param4.game.battlefield.addChild(_loc7_);
         _loc7_.team = param4;
      }
      
      public function initPoisonPool(param1:Number, param2:Number, param3:Unit, param4:Number) : void
      {
         var _loc5_:PoisonPool = null;
         if((_loc5_ = PoisonPool(this._projectileMap[Projectile.POISON_POOL].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         if(Math.abs(param1 - param3.px) > param3.team.game.xml.xml.Chaos.Units.medusa.poison.range)
         {
            param1 = param3.x + Util.sgn(param1 - param3.px) * param3.team.game.xml.xml.Chaos.Units.medusa.poison.range;
         }
         _loc5_.inflictor = param3;
         _loc5_.px = param1;
         _loc5_.py = param2;
         _loc5_.team = param3.team;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         Util.animateToNeutral(_loc5_.spellMc);
         _loc5_.frames = 0;
         _loc5_.scaleX = Util.sgn(param3.mc.scaleX);
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.poisonDamage = this.medusaPoisonAmount;
         _loc5_.stunTime = 0;
         _loc5_.explosionDamage = param4;
         this.projectiles.push(_loc5_);
         param3.team.game.battlefield.addChild(_loc5_);
      }
      
      public function initCure(param1:Number, param2:Number, param3:Number, param4:Unit) : void
      {
         var _loc5_:Cure = null;
         if((_loc5_ = Cure(this._projectileMap[Projectile.CURE].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         _loc5_.inflictor = param4;
         _loc5_.px = param1;
         _loc5_.py = param2;
         _loc5_.team = param4.team;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.stunTime = 0;
         this.projectiles.push(_loc5_);
         param4.team.game.battlefield.addChild(_loc5_);
      }
      
      public function initHeal(param1:Number, param2:Number, param3:Number, param4:Unit) : void
      {
         var _loc5_:Heal = null;
         if((_loc5_ = Heal(this._projectileMap[Projectile.HEAL].getItem())) == null)
         {
            return;
         }
         _loc5_.visible = true;
         _loc5_.inflictor = param4;
         _loc5_.px = param1;
         _loc5_.py = param2;
         _loc5_.team = param4.team;
         _loc5_.x = _loc5_.px;
         _loc5_.y = _loc5_.py;
         _loc5_.spellMc.gotoAndStop(1);
         _loc5_.stunTime = 0;
         this.projectiles.push(_loc5_);
         param4.team.game.battlefield.addChild(_loc5_);
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Projectile = null;
         _loc2_ = 0;
         while(_loc2_ < this.projectiles.length)
         {
            if(!Projectile(this.projectiles[_loc2_]).isInFlight())
            {
               _loc3_ = this.projectiles.splice(_loc2_,1)[0];
               _loc3_.framesDead = 0;
               this._waitingToBeCleaned.push(_loc3_);
            }
            else
            {
               this.projectiles[_loc2_].update(param1);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._waitingToBeCleaned.length)
         {
            ++this._waitingToBeCleaned[_loc2_].framesDead;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._waitingToBeCleaned.length)
         {
            if(this._waitingToBeCleaned[_loc2_].isReadyForCleanup())
            {
               _loc3_ = this._waitingToBeCleaned.splice(_loc2_,1)[0];
               if(param1.battlefield.contains(_loc3_))
               {
                  param1.battlefield.removeChild(_loc3_);
               }
               this._projectileMap[_loc3_.type].returnItem(_loc3_);
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public function get projectiles() : Array
      {
         return this._projectiles;
      }
      
      public function set projectiles(param1:Array) : void
      {
         this._projectiles = param1;
      }
      
      public function get airEffects() : Array
      {
         return this._airEffects;
      }
      
      public function set airEffects(param1:Array) : void
      {
         this._airEffects = param1;
      }
   }
}
