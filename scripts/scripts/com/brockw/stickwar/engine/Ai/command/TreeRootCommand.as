package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.engine.units.elementals.*;
      import flash.display.*;
      
      public class TreeRootCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new rootBitmap());
             
            
            public function TreeRootCommand(param1:StickWar)
            {
                  super();
                  type = UnitCommand.TREE_ROOT;
                  _hasCoolDown = false;
                  _intendedEntityType = Unit.U_TREE_ELEMENT;
                  requiresMouseInput = false;
                  isSingleSpell = false;
                  isToggle = true;
                  buttonBitmap = actualButtonBitmap;
                  if(param1 != null)
                  {
                        this.loadXML(param1.xml.xml.Elemental.Units.treeElement.root);
                  }
                  hotKey = 87;
            }
            
            override public function isToggled(param1:Entity) : Boolean
            {
                  return TreeElement(param1).isRooted();
            }
            
            override public function coolDownTime(param1:Entity) : Number
            {
                  return 0;
            }
            
            override public function isFinished(param1:Unit) : Boolean
            {
                  return false;
            }
            
            override public function inRange(param1:Entity) : Boolean
            {
                  return true;
            }
      }
}
