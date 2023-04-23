package com.brockw.stickwar.engine.multiplayer.adds
{
   import com.brockw.stickwar.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AddManager extends MovieClip
   {
       
      
      internal var adds:Array;
      
      internal var main:BaseMain;
      
      internal var currentAdd:Add;
      
      public function AddManager(param1:BaseMain)
      {
         super();
         this.main = param1;
         this.adds = [];
         this.adds.push(new AddItems(this));
         this.adds.push(new AddChaos(this));
      }
      
      public function update() : void
      {
         if(Main(this.main).currentScreen() == "armoury")
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
         if(this.currentAdd)
         {
            this.currentAdd.update();
         }
      }
      
      public function exit(param1:Event) : void
      {
         this.hideAdd();
      }
      
      public function signUp(param1:Event) : void
      {
         if(this.main is Main)
         {
            this.main.showScreen("armoury");
            Main(this.main).armourScreen.update(null);
            Main(this.main).armourScreen.openPaymentScreen(null);
         }
      }
      
      public function addRequest() : void
      {
         var _loc1_:ExtensionRequest = new ExtensionRequest("getAddRequest");
         this.main.sfs.send(_loc1_);
      }
      
      public function showAdd(param1:int = 0) : void
      {
         if(Boolean(this.main.willSeeAdds()) && param1 > 5)
         {
            if(this.currentAdd)
            {
               this.adds.push(this.currentAdd);
            }
            this.currentAdd = this.adds.shift();
            addChild(this.currentAdd);
            this.currentAdd.enter();
            this.currentAdd.addShowTime = param1 / 3;
            if(this.currentAdd.addShowTime > 60)
            {
               this.currentAdd.addShowTime = 60;
            }
         }
      }
      
      public function hideAdd() : void
      {
         if(this.currentAdd)
         {
            this.currentAdd.leave();
            this.adds.push(this.currentAdd);
            removeChild(this.currentAdd);
            this.currentAdd = null;
         }
      }
   }
}
