package com.brockw.stickwar.engine.Ai
{
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.*;
      
      public class MedusaAi extends UnitAi
      {
             
            
            public function MedusaAi(param1:Medusa)
            {
                  super();
                  unit = param1;
                  isNonAttackingMage = true;
            }
            
            override public function update(param1:StickWar) : void
            {
                  var _loc2_:int = 0;
                  var _loc3_:Entity = null;
                  unit.isBusyForSpell = false;
                  if(currentCommand.type == UnitCommand.STONE)
                  {
                        _loc2_ = int(StoneCommand(currentCommand).targetId);
                        if(_loc2_ in param1.units)
                        {
                              _loc3_ = param1.units[_loc2_];
                              if(!(_loc3_ is Unit) || Unit(_loc3_).team == unit.team)
                              {
                                    nextMove(param1);
                              }
                              else if(!this.currentCommand.inRange(unit))
                              {
                                    unit.mayWalkThrough = true;
                                    unit.isBusyForSpell = true;
                                    unit.walk((_loc3_.px - unit.px) / 100,(_loc3_.py - unit.py) / 100,(_loc3_.px - unit.px) / 100);
                              }
                              else
                              {
                                    _loc3_ = param1.units[_loc2_];
                                    if(_loc3_ is Unit && Unit(_loc3_).team != unit.team)
                                    {
                                          Medusa(unit).stone(_loc3_);
                                          nextMove(param1);
                                    }
                                    else
                                    {
                                          baseUpdate(param1);
                                    }
                              }
                        }
                        else
                        {
                              nextMove(param1);
                        }
                  }
                  else if(currentCommand.type == UnitCommand.POISON_POOL)
                  {
                        Medusa(unit).poisonSpray();
                        nextMove(param1);
                  }
                  else
                  {
                        baseUpdate(param1);
                  }
            }
      }
}
