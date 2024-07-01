package com.brockw.stickwar.engine.units
{
      import com.brockw.game.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Chaos.*;
      import com.brockw.stickwar.engine.Team.Order.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.MovieClip;
      import flash.utils.*;
      
      public class UnitFactory
      {
             
            
            private var pools:Dictionary;
            
            private var _profilePics:Dictionary;
            
            public function UnitFactory(param1:int, param2:StickWar)
            {
                  super();
                  this.pools = new Dictionary();
                  this.pools[new Swordwrath(param2).type] = new Pool(1,Swordwrath,param2);
                  this.pools[new Miner(param2).type] = new Pool(1,Miner,param2);
                  this.pools[new Archer(param2).type] = new Pool(1,Archer,param2);
                  this.pools[new Dead(param2).type] = new Pool(1,Dead,param2);
                  this.pools[new Wingidon(param2).type] = new Pool(1,Wingidon,param2);
                  this.pools[new FlyingCrossbowman(param2).type] = new Pool(1,FlyingCrossbowman,param2);
                  this.pools[new Spearton(param2).type] = new Pool(1,Spearton,param2);
                  this.pools[new Ninja(param2).type] = new Pool(1,Ninja,param2);
                  this.pools[new Magikill(param2).type] = new Pool(1,Magikill,param2);
                  this.pools[new Monk(param2).type] = new Pool(1,Monk,param2);
                  this.pools[new EnslavedGiant(param2).type] = new Pool(1,EnslavedGiant,param2);
                  this.pools[new Bomber(param2).type] = new Pool(1,Bomber,param2);
                  this.pools[new Skelator(param2).type] = new Pool(1,Skelator,param2);
                  this.pools[new Cat(param2).type] = new Pool(1,Cat,param2);
                  this.pools[new Knight(param2).type] = new Pool(1,Knight,param2);
                  this.pools[new Medusa(param2).type] = new Pool(1,Medusa,param2);
                  this.pools[new Giant(param2).type] = new Pool(1,Giant,param2);
                  this.pools[new MinerChaos(param2).type] = new Pool(1,MinerChaos,param2);
                  this.pools[new ChaosTower(param2).type] = new Pool(1,ChaosTower,param2);
                  this.pools[new FireElement(param2).type] = new Pool(1,FireElement,param2);
                  this.pools[new WaterElement(param2).type] = new Pool(1,WaterElement,param2);
                  this.pools[new AirElement(param2).type] = new Pool(1,AirElement,param2);
                  this.pools[new ElementalMiner(param2).type] = new Pool(1,ElementalMiner,param2);
                  this.pools[new LavaElement(param2).type] = new Pool(1,LavaElement,param2);
                  this.pools[new HurricaneElement(param2).type] = new Pool(1,HurricaneElement,param2);
                  this.pools[new TreeElement(param2).type] = new Pool(1,TreeElement,param2);
                  this.pools[new ChromeElement(param2).type] = new Pool(1,ChromeElement,param2);
                  this.pools[new FirestormElement(param2).type] = new Pool(1,FirestormElement,param2);
                  this.pools[new EarthElement(param2).type] = new Pool(1,EarthElement,param2);
                  this.pools[new ScorpionElement(param2).type] = new Pool(1,ScorpionElement,param2);
                  this._profilePics = new Dictionary();
                  this._profilePics[new Miner(param2).type] = new minerProfile();
                  this._profilePics[new Swordwrath(param2).type] = new profileSwordwrath();
                  this._profilePics[new Archer(param2).type] = new profileArchidon();
                  this._profilePics[new Dead(param2).type] = new deadProfile();
                  this._profilePics[new Wingidon(param2).type] = new wingadonProfile();
                  this._profilePics[new FlyingCrossbowman(param2).type] = new profileFlyer();
                  this._profilePics[new Spearton(param2).type] = new profileSpearton();
                  this._profilePics[new Ninja(param2).type] = new profileAssassin();
                  this._profilePics[new Magikill(param2).type] = new profileMagikill();
                  this._profilePics[new Monk(param2).type] = new profileMonk();
                  this._profilePics[new EnslavedGiant(param2).type] = new Profile_Slave_Giant();
                  this._profilePics[new Bomber(param2).type] = new bomberProfile();
                  this._profilePics[new Skelator(param2).type] = new mageProfile();
                  this._profilePics[new Cat(param2).type] = new crawlerProfile();
                  this._profilePics[new Knight(param2).type] = new knightProfile();
                  this._profilePics[new Medusa(param2).type] = new medusaProfile();
                  this._profilePics[new Giant(param2).type] = new giantProfile();
                  this._profilePics[new MinerChaos(param2).type] = new minerProfile();
                  this._profilePics[new FireElement(param2).type] = new fireProfileMc();
                  this._profilePics[new WaterElement(param2).type] = new waterProfileMc();
                  this._profilePics[new AirElement(param2).type] = new airProfileMc();
                  this._profilePics[new ElementalMiner(param2).type] = new elementalMinerProfileMc();
                  this._profilePics[new LavaElement(param2).type] = new lavaProfileMc();
                  this._profilePics[new HurricaneElement(param2).type] = new hurricaneProfileMc();
                  this._profilePics[new TreeElement(param2).type] = new treeProfileMc();
                  this._profilePics[new ChromeElement(param2).type] = new chromeProfileMc();
                  this._profilePics[new FirestormElement(param2).type] = new firestormProfileMc();
                  this._profilePics[new EarthElement(param2).type] = new earthProfileMc();
                  this._profilePics[new ScorpionElement(param2).type] = new scorpionProfile();
            }
            
            public function cleanUp() : void
            {
                  var _loc1_:* = undefined;
                  for(_loc1_ in this.pools)
                  {
                        this.pools[_loc1_].cleanUp();
                        this.pools[_loc1_] = null;
                  }
                  this.pools = null;
            }
            
            public function getProfile(param1:int) : MovieClip
            {
                  return this._profilePics[param1];
            }
            
            public function getUnit(param1:int) : Unit
            {
                  return Unit(Pool(this.pools[param1]).getItem());
            }
            
            public function returnUnit(param1:int, param2:Unit) : void
            {
                  Pool(this.pools[param1]).returnItem(param2);
            }
            
            public function get profilePics() : Dictionary
            {
                  return this._profilePics;
            }
            
            public function set profilePics(param1:Dictionary) : void
            {
                  this._profilePics = param1;
            }
      }
}
