package com.brockw.stickwar.missions
{
      import com.smartfoxserver.v2.entities.data.SFSObject;
      
      public class Mission extends _missionMc
      {
             
            
            public var missionName:String;
            
            public var description:String;
            
            public var id:int;
            
            public function Mission(param1:SFSObject, param2:Number)
            {
                  super();
                  this.x = param1.getDouble("locationX");
                  this.y = param1.getDouble("locationY");
                  this.missionName = param1.getUtfString("name");
                  this.description = param1.getUtfString("description");
                  this.id = param1.getInt("missionId");
                  this.idText.text = "" + param2;
                  idText.mouseEnabled = false;
            }
      }
}
