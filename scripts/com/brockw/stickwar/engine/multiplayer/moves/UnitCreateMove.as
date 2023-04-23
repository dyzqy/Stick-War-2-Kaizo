package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.Move;
   import com.brockw.simulationSync.Simulation;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class UnitCreateMove extends Move
   {
       
      
      private var _unitType:int;
      
      public function UnitCreateMove()
      {
         type = Commands.UNIT_CREATE_MOVE;
         this._unitType = Unit.U_SWORDWRATH;
         super();
      }
      
      override public function toString() : String
      {
         var _loc1_:String = super.toString();
         return _loc1_ + (String(this._unitType) + " ");
      }
      
      override public function fromString(param1:Array) : Boolean
      {
         super.fromString(param1);
         this._unitType = int(param1.shift());
         return true;
      }
      
      override public function readFromSFSObject(param1:SFSObject) : void
      {
         readBasicsSFSObject(param1);
         this._unitType = param1.getInt("u");
      }
      
      override public function writeToSFSObject(param1:SFSObject) : void
      {
         writeBasicsSFSObject(param1);
         param1.putInt("u",this._unitType);
      }
      
      override public function execute(param1:Simulation) : void
      {
         var _loc2_:StickWar = StickWar(param1);
         _loc2_.requestToSpawn(this.owner,this._unitType);
      }
      
      public function get unitType() : int
      {
         return this._unitType;
      }
      
      public function set unitType(param1:int) : void
      {
         this._unitType = param1;
      }
   }
}
