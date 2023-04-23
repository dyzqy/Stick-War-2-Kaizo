package com.brockw.stickwar.engine.multiplayer.moves
{
   import com.brockw.simulationSync.*;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   
   public class MoveFactory
   {
       
      
      public function MoveFactory()
      {
         super();
      }
      
      public static function createMove(param1:SFSObject) : Move
      {
         var _loc2_:UnitCreateMove = null;
         var _loc3_:EndOfTurnMove = null;
         var _loc4_:UnitMove = null;
         var _loc5_:EndOfGameMove = null;
         var _loc6_:ForfeitMove = null;
         var _loc7_:PauseMove = null;
         var _loc8_:ScreenPositionUpdateMove = null;
         var _loc9_:GlobalMove = null;
         var _loc10_:ChatMove = null;
         if(param1.getInt("type") == Commands.UNIT_CREATE_MOVE)
         {
            _loc2_ = new UnitCreateMove();
            _loc2_.readFromSFSObject(param1);
            return _loc2_;
         }
         if(param1.getInt("type") == Commands.END_OF_TURN)
         {
            _loc3_ = new EndOfTurnMove();
            _loc3_.readFromSFSObject(param1);
            return _loc3_;
         }
         if(param1.getInt("type") == Commands.UNIT_MOVE)
         {
            (_loc4_ = new UnitMove()).readFromSFSObject(param1);
            return _loc4_;
         }
         if(param1.getInt("type") == Commands.END_OF_GAME)
         {
            (_loc5_ = new EndOfGameMove()).readFromSFSObject(param1);
            return _loc5_;
         }
         if(param1.getInt("type") == Commands.FORFEIT)
         {
            (_loc6_ = new ForfeitMove()).readFromSFSObject(param1);
            return _loc6_;
         }
         if(param1.getInt("type") == Commands.PAUSE)
         {
            (_loc7_ = new PauseMove()).readFromSFSObject(param1);
            return _loc7_;
         }
         if(param1.getInt("type") == Commands.SCREEN_POSITION_UPDATE)
         {
            (_loc8_ = new ScreenPositionUpdateMove()).readFromSFSObject(param1);
            return _loc8_;
         }
         if(param1.getInt("type") == Commands.GLOBAL_MOVE)
         {
            (_loc9_ = new GlobalMove()).readFromSFSObject(param1);
            return _loc9_;
         }
         if(param1.getInt("type") == Commands.CHAT_MOVE)
         {
            (_loc10_ = new ChatMove()).readFromSFSObject(param1);
            return _loc10_;
         }
         throw new Error("No type of move!!: " + param1.getInt("type"));
      }
      
      public static function createMoveFromString(param1:int, param2:Array) : Move
      {
         var _loc3_:UnitCreateMove = null;
         var _loc4_:EndOfTurnMove = null;
         var _loc5_:UnitMove = null;
         var _loc6_:EndOfGameMove = null;
         var _loc7_:ForfeitMove = null;
         var _loc8_:PauseMove = null;
         var _loc9_:ScreenPositionUpdateMove = null;
         var _loc10_:GlobalMove = null;
         var _loc11_:ChatMove = null;
         var _loc12_:ReplaySyncCheckMove = null;
         if(param1 == Commands.UNIT_CREATE_MOVE)
         {
            _loc3_ = new UnitCreateMove();
            _loc3_.fromString(param2);
            return _loc3_;
         }
         if(param1 == Commands.END_OF_TURN)
         {
            (_loc4_ = new EndOfTurnMove()).fromString(param2);
            return _loc4_;
         }
         if(param1 == Commands.UNIT_MOVE)
         {
            (_loc5_ = new UnitMove()).fromString(param2);
            return _loc5_;
         }
         if(param1 == Commands.END_OF_GAME)
         {
            (_loc6_ = new EndOfGameMove()).fromString(param2);
            return _loc6_;
         }
         if(param1 == Commands.FORFEIT)
         {
            (_loc7_ = new ForfeitMove()).fromString(param2);
            return _loc7_;
         }
         if(param1 == Commands.PAUSE)
         {
            (_loc8_ = new PauseMove()).fromString(param2);
            return _loc8_;
         }
         if(param1 == Commands.SCREEN_POSITION_UPDATE)
         {
            (_loc9_ = new ScreenPositionUpdateMove()).fromString(param2);
            return _loc9_;
         }
         if(param1 == Commands.GLOBAL_MOVE)
         {
            (_loc10_ = new GlobalMove()).fromString(param2);
            return _loc10_;
         }
         if(param1 == Commands.CHAT_MOVE)
         {
            (_loc11_ = new ChatMove()).fromString(param2);
            return _loc11_;
         }
         if(param1 == Commands.REPLAY_SYNC_CHECK)
         {
            (_loc12_ = new ReplaySyncCheckMove()).fromString(param2);
            return _loc12_;
         }
         throw new Error("No type of move!!: " + param1);
      }
   }
}
