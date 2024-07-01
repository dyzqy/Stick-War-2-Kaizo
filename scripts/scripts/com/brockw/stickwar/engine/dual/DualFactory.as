package com.brockw.stickwar.engine.dual
{
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      import flash.utils.*;
      
      public class DualFactory
      {
             
            
            private var duals:Dictionary;
            
            public function DualFactory(param1:StickWar)
            {
                  var _loc3_:String = null;
                  var _loc4_:String = null;
                  super();
                  var _loc2_:Array = [new Swordwrath(param1),new Miner(param1),new Archer(param1),new Spearton(param1),new Cat(param1),new Knight(param1)];
                  this.duals = new Dictionary();
                  for(_loc3_ in _loc2_)
                  {
                        this.duals[Unit(_loc2_[_loc3_]).type] = new Dictionary();
                        for(_loc4_ in _loc2_)
                        {
                              Dictionary(this.duals[Unit(_loc2_[_loc3_]).type])[Unit(_loc2_[_loc4_]).type] = this.createDuals(Unit(_loc2_[_loc3_]),Unit(_loc2_[_loc4_]));
                        }
                  }
            }
            
            public function cleanUp() : void
            {
            }
            
            private function createDuals(param1:Unit, param2:Unit) : Array
            {
                  var _loc4_:String = null;
                  var _loc5_:String = null;
                  var _loc6_:Dual = null;
                  var _loc3_:Array = [];
                  for(_loc4_ in param1.syncAttackLabels)
                  {
                        for(_loc5_ in param2.syncDefendLabels)
                        {
                              if(param1.syncAttackLabels[_loc4_][0] == param2.syncDefendLabels[_loc5_])
                              {
                                    (_loc6_ = new Dual()).attackLabel = "syncAttack_" + param1.syncAttackLabels[_loc4_][0] + "_" + param1.syncAttackLabels[_loc4_][1] + "_" + param1.syncAttackLabels[_loc4_][2];
                                    _loc6_.defendLabel = "syncDefend_" + param2.syncDefendLabels[_loc4_];
                                    _loc6_.yDiff = 0;
                                    _loc6_.xDiff = param1.syncAttackLabels[_loc4_][1];
                                    _loc6_.finalXOffset = param1.syncAttackLabels[_loc4_][2];
                                    _loc3_.push(_loc6_);
                              }
                        }
                  }
                  return _loc3_;
            }
            
            public function getDuals(param1:int, param2:int) : Array
            {
                  var _loc3_:Array = null;
                  if(param1 in this.duals && param2 in this.duals[param1])
                  {
                        _loc3_ = this.duals[param1][param2];
                        if(_loc3_ == null)
                        {
                              return null;
                        }
                        if(_loc3_.length == 0)
                        {
                              return null;
                        }
                        return _loc3_;
                  }
                  return null;
            }
      }
}
