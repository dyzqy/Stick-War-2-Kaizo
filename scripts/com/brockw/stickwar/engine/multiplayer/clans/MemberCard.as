package com.brockw.stickwar.engine.multiplayer.clans
{
   import com.brockw.stickwar.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.events.*;
   
   public class MemberCard extends memberEntryMc
   {
       
      
      internal var main:BaseMain;
      
      internal var data:SFSObject;
      
      internal var clanId:int = -1;
      
      public function MemberCard(param1:SFSObject, param2:BaseMain, param3:Boolean, param4:Boolean, param5:int)
      {
         super();
         this.data = param1;
         this.clanId = param5;
         this.main = param2;
         name = param1.getUtfString("username");
         this.nameText.text = name;
         this.visitProfile.addEventListener(MouseEvent.CLICK,this.profile,false,0,true);
         kickButton.visible = false;
         viewRequest.visible = false;
         if(param4)
         {
            viewRequest.visible = true;
            this.viewRequest.addEventListener(MouseEvent.CLICK,this.request,false,0,true);
         }
         else if(param3)
         {
            kickButton.visible = true;
            this.kickButton.addEventListener(MouseEvent.CLICK,this.kick,false,0,true);
         }
      }
      
      private function kickCallback() : void
      {
         var _loc1_:SFSObject = new SFSObject();
         _loc1_.putInt("clanId",this.clanId);
         _loc1_.putUtfString("userToKick",name);
         Main(this.main).sfs.send(new ExtensionRequest("kickFromClan",_loc1_));
      }
      
      private function kick(param1:Event) : void
      {
         Main(this.main).viewClanScreen.showConfirmation("Are you sure you want to kick " + name,this.kickCallback);
      }
      
      private function profile(param1:Event) : void
      {
         this.main.showScreen("profile");
         Main(this.main).profileScreen.loadProfile(name);
      }
      
      private function request(param1:Event) : void
      {
         Main(this.main).viewClanScreen.showRequestWindow(this.data.getUtfString("username"),this.data.getUtfString("message"));
      }
   }
}
