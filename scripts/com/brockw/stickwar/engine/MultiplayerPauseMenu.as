package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.multiplayer.moves.*;
   import flash.events.*;
   import flash.net.*;
   
   public class MultiplayerPauseMenu extends PauseMenu
   {
       
      
      private var mc:pauseMenuMultiplayer;
      
      private var isConfirming:Boolean;
      
      public function MultiplayerPauseMenu(param1:GameScreen)
      {
         super(param1);
         this.mc = new pauseMenuMultiplayer();
         addChild(this.mc);
         this.isConfirming = false;
         tabEnabled = false;
         tabChildren = false;
         this.mc.soundToggle.buttonMode = true;
         this.mc.musicToggle.buttonMode = true;
         this.mc.buttons.backToGameButton.addEventListener(MouseEvent.CLICK,this.backButton);
         this.mc.buttons.howToPlayButton.addEventListener(MouseEvent.CLICK,this.howToPlayButton);
         this.mc.buttons.pauseButton.addEventListener(MouseEvent.CLICK,this.pauseButton);
         this.mc.buttons.unpauseButton.addEventListener(MouseEvent.CLICK,this.pauseButton);
         this.mc.buttons.surrenderButton.addEventListener(MouseEvent.CLICK,this.surrenderButton);
         this.mc.confirmation.yesButton.addEventListener(MouseEvent.CLICK,this.yesButton);
         this.mc.confirmation.noButton.addEventListener(MouseEvent.CLICK,this.noButton);
      }
      
      private function noButton(param1:Event) : void
      {
         this.isConfirming = false;
      }
      
      private function yesButton(param1:Event) : void
      {
         var _loc2_:ForfeitMove = new ForfeitMove();
         gameScreen.doMove(_loc2_,gameScreen.team.id);
         this.isConfirming = false;
         this.hideMenu();
      }
      
      private function surrenderButton(param1:Event) : void
      {
         this.isConfirming = true;
      }
      
      private function backButton(param1:Event) : void
      {
         this.hideMenu();
      }
      
      private function pauseButton(param1:Event) : void
      {
         var _loc2_:PauseMove = new PauseMove();
         gameScreen.doMove(_loc2_,gameScreen.team.id);
      }
      
      private function howToPlayButton(param1:Event) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
         navigateToURL(_loc2_,"_blank");
      }
      
      override public function update() : void
      {
         super.update();
         if(isShowing)
         {
            this.mc.visible = true;
            this.mc.buttons.visible = true;
            this.mc.confirmation.visible = false;
            if(this.isConfirming)
            {
               this.mc.buttons.visible = false;
               this.mc.confirmation.visible = true;
            }
            if(gameScreen.game.soundManager.isSound)
            {
               this.mc.soundToggle.gotoAndStop(1);
            }
            else
            {
               this.mc.soundToggle.gotoAndStop(3);
            }
            if(gameScreen.userInterface.isMusic)
            {
               this.mc.musicToggle.gotoAndStop(1);
            }
            else
            {
               this.mc.musicToggle.gotoAndStop(3);
            }
            if(this.mc.soundToggle.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               if(gameScreen.userInterface.mouseState.mouseDown)
               {
                  gameScreen.game.soundManager.isSound = !gameScreen.game.soundManager.isSound;
                  gameScreen.userInterface.mouseState.mouseDown = false;
               }
            }
            if(this.mc.musicToggle.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               if(gameScreen.userInterface.mouseState.mouseDown)
               {
                  gameScreen.userInterface.isMusic = !gameScreen.userInterface.isMusic;
                  gameScreen.userInterface.mouseState.mouseDown = false;
               }
            }
            if(gameScreen.isPaused)
            {
               this.mc.buttons.pauseButtonMultiplayer.visible = false;
               this.mc.buttons.unpauseButtonMultiplayer.visible = true;
               this.mc.buttons.unpauseButton.visible = true;
               this.mc.buttons.pauseButton.visible = false;
            }
            else
            {
               this.mc.buttons.pauseButtonMultiplayer.visible = true;
               this.mc.buttons.unpauseButtonMultiplayer.visible = false;
               this.mc.buttons.unpauseButton.visible = false;
               this.mc.buttons.pauseButton.visible = true;
            }
            return;
         }
         this.mc.visible = false;
      }
   }
}
