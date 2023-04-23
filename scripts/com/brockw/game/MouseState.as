package com.brockw.game
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   
   public class MouseState extends Sprite
   {
      
      private static const CLICK_FRAMES:int = 10;
      
      private static const DOUBLE_CLICK_FRAMES:int = 8;
       
      
      private var _mouseDown:Boolean;
      
      private var _oldMouseDown:Boolean;
      
      private var mouseDownFrames:int;
      
      private var _clicked:Boolean;
      
      private var lastMouseX:int;
      
      private var lastMouseY:int;
      
      private var _mouseDownX:int;
      
      private var _mouseDownY:int;
      
      private var currentMouseX:int;
      
      private var currentMouseY:int;
      
      private var lastClickTime:int;
      
      private var _doubleClicked:Boolean;
      
      private var _mouseIn:Boolean;
      
      private var _target:Stage;
      
      private var _isRightClick:Boolean;
      
      public function MouseState(param1:Stage)
      {
         super();
         this._target = param1;
         this.oldMouseDown = this.mouseDown = false;
         this.clicked = false;
         this.mouseDownFrames = 0;
         this.lastClickTime = -DOUBLE_CLICK_FRAMES;
         this.lastMouseX = this.mouseX;
         this.lastMouseY = this.mouseY;
         this.mouseIn = true;
         this._isRightClick = false;
         param1.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
         param1.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
         param1.stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveEvent);
         param1.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseEnterEvent);
         param1.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouseDownEventRight);
         this._target.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouseUpEventRight);
         this._mouseDownX = 0;
         this._mouseDownY = 0;
      }
      
      public function cleanUp() : void
      {
         this._target.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
         this._target.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
         this._target.stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveEvent);
         this._target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseEnterEvent);
         this._target.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.mouseDownEventRight);
         this._target.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.mouseUpEventRight);
      }
      
      private function mouseUpEventRight(param1:Event) : void
      {
         this.isRightClick = false;
         this.mouseDown = false;
      }
      
      public function isDrag() : Boolean
      {
         return Math.sqrt(Math.pow(this.currentMouseX - this.lastMouseX,2) + Math.pow(this.currentMouseY - this.lastMouseY,2)) > 50;
      }
      
      public function update() : void
      {
         if(this.oldMouseDown == true && this.mouseDown == false && this.mouseDownFrames < CLICK_FRAMES && !this.isDrag())
         {
            this.clicked = true;
            if(this.lastClickTime < DOUBLE_CLICK_FRAMES)
            {
               this._doubleClicked = true;
            }
            this.lastClickTime = 0;
         }
         else
         {
            this._doubleClicked = false;
            this.clicked = false;
         }
         ++this.lastClickTime;
         ++this.mouseDownFrames;
         this.oldMouseDown = this.mouseDown;
      }
      
      private function mouseLeaveEvent(param1:Event) : void
      {
         this.mouseIn = false;
      }
      
      private function mouseEnterEvent(param1:MouseEvent) : void
      {
         this.mouseIn = true;
      }
      
      private function mouseDownEventRight(param1:MouseEvent) : void
      {
         this.isRightClick = true;
         if(this.mouseDown == false)
         {
            this.mouseDownX = param1.stageX;
            this.mouseDownY = param1.stageY;
         }
         this.mouseDown = true;
         this.mouseDownFrames = 0;
         this.currentMouseX = this.lastMouseX = param1.stageX;
         this.currentMouseY = this.lastMouseY = param1.stageY;
      }
      
      private function mouseDownEvent(param1:MouseEvent) : void
      {
         this.isRightClick = false;
         if(this.mouseDown == false)
         {
            this.mouseDownX = param1.stageX;
            this.mouseDownY = param1.stageY;
         }
         this.mouseDown = true;
         this.mouseDownFrames = 0;
         this.currentMouseX = this.lastMouseX = param1.stageX;
         this.currentMouseY = this.lastMouseY = param1.stageY;
      }
      
      public function mouseJustDown() : Boolean
      {
         return this.mouseDownFrames <= 1 && this.mouseDown == true;
      }
      
      private function mouseUpEvent(param1:MouseEvent) : void
      {
         this.mouseDown = false;
         this.currentMouseX = param1.stageX;
         this.currentMouseY = param1.stageY;
      }
      
      public function get clicked() : Boolean
      {
         return this._clicked;
      }
      
      public function set clicked(param1:Boolean) : void
      {
         this._clicked = param1;
      }
      
      public function get doubleClicked() : Boolean
      {
         return this._doubleClicked;
      }
      
      public function set doubleClicked(param1:Boolean) : void
      {
         this._doubleClicked = param1;
      }
      
      public function get mouseDown() : Boolean
      {
         return this._mouseDown;
      }
      
      public function set mouseDown(param1:Boolean) : void
      {
         this._mouseDown = param1;
      }
      
      public function get mouseIn() : Boolean
      {
         return this._mouseIn;
      }
      
      public function set mouseIn(param1:Boolean) : void
      {
         this._mouseIn = param1;
      }
      
      public function get mouseDownX() : int
      {
         return this._mouseDownX;
      }
      
      public function set mouseDownX(param1:int) : void
      {
         this._mouseDownX = param1;
      }
      
      public function get mouseDownY() : int
      {
         return this._mouseDownY;
      }
      
      public function set mouseDownY(param1:int) : void
      {
         this._mouseDownY = param1;
      }
      
      public function get oldMouseDown() : Boolean
      {
         return this._oldMouseDown;
      }
      
      public function set oldMouseDown(param1:Boolean) : void
      {
         this._oldMouseDown = param1;
      }
      
      public function get isRightClick() : Boolean
      {
         return this._isRightClick;
      }
      
      public function set isRightClick(param1:Boolean) : void
      {
         this._isRightClick = param1;
      }
   }
}
