package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Ai.command.*;
   import com.brockw.stickwar.engine.Team.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class ActionInterface extends Sprite
   {
      
      private static const BOX_WIDTH:Number = 70;
      
      private static const BOX_HEIGHT:Number = 32.9;
      
      public static const ROWS:Number = 3;
      
      public static const COLS:Number = 3;
      
      private static const START_X:Number = 637.9;
      
      private static const START_Y:Number = 598.15;
      
      private static const SPACING:Number = 0;
       
      
      private var boxes:Array;
      
      private var currentActions:Array;
      
      private var actions:Dictionary;
      
      private var actionsToButtonMap:Dictionary;
      
      private var _currentMove:UnitCommand;
      
      private var _currentEntity:com.brockw.stickwar.engine.Entity;
      
      private var _currentCursor:MovieClip;
      
      protected var team:Team;
      
      private var _clicked:Boolean;
      
      private var _game:com.brockw.stickwar.engine.StickWar;
      
      public function ActionInterface(param1:UserInterface)
      {
         super();
         this._game = param1.gameScreen.game;
         this.setUpGrid(param1);
         this.setUpActions();
         this._currentMove = null;
         this._currentEntity = null;
         this._currentCursor = null;
         this.clicked = false;
         this.team = param1.team;
      }
      
      public function refresh() : void
      {
         var _loc1_:Sprite = Sprite(this._game.cursorSprite);
         if(this._currentMove)
         {
            this._currentMove.cleanUpPreClick(_loc1_);
         }
         this._currentMove = null;
         this._currentCursor = null;
         this.clicked = false;
         Mouse.show();
      }
      
      public function isInCommand() : Boolean
      {
         if(this.currentMove == null || (this._clicked == true || this.currentMove.type == UnitCommand.MOVE))
         {
            return false;
         }
         return true;
      }
      
      private function setUpGrid(param1:UserInterface) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         this.boxes = [];
         this.boxes.push(param1.hud.hud.action1);
         this.boxes.push(param1.hud.hud.action2);
         this.boxes.push(param1.hud.hud.action3);
         this.boxes.push(param1.hud.hud.action4);
         this.boxes.push(param1.hud.hud.action5);
         this.boxes.push(param1.hud.hud.action6);
         this.boxes.push(param1.hud.hud.action7);
         this.boxes.push(param1.hud.hud.action8);
         this.boxes.push(param1.hud.hud.action9);
         var _loc2_:int = 0;
         while(_loc2_ < this.boxes.length)
         {
            _loc3_ = this.boxes[_loc2_];
            _loc3_.stop();
            (_loc4_ = new Sprite()).name = "overlay";
            _loc3_.visible = true;
            _loc3_.addChild(_loc4_);
            param1.hud.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      public function drawCoolDown(param1:MovieClip, param2:Number) : void
      {
         var _loc3_:Sprite = Sprite(param1.getChildByName("overlay"));
         var _loc4_:Sprite = Sprite(param1.getChildByName("cancelMc"));
         var _loc5_:DisplayObject = param1.getChildByName("mc");
         param1.removeChild(_loc3_);
         param1.addChild(_loc3_);
         if(_loc4_)
         {
            param1.removeChild(_loc4_);
            param1.addChild(_loc4_);
         }
         param2 = 1 - param2;
         _loc3_.graphics.clear();
         var _loc6_:int = int(BOX_HEIGHT);
         var _loc7_:int = int(BOX_WIDTH);
         _loc3_.x = -_loc7_ / 2;
         _loc3_.y = -_loc6_ / 2;
         _loc3_.graphics.moveTo(0,_loc6_);
         _loc3_.graphics.beginFill(0,0.6);
         _loc3_.graphics.lineTo(_loc7_,_loc6_);
         _loc3_.graphics.lineTo(_loc7_,_loc6_ * param2);
         _loc3_.graphics.lineTo(0,_loc6_ * param2);
         _loc3_.graphics.lineTo(0,_loc6_);
      }
      
      public function drawToggle(param1:MovieClip, param2:Boolean) : void
      {
         var _loc3_:Sprite = null;
         _loc3_ = Sprite(param1.getChildByName("overlay"));
         var _loc4_:DisplayObject = param1.getChildByName("mc");
         param1.removeChild(_loc3_);
         param1.addChild(_loc3_);
         _loc3_.graphics.clear();
         var _loc5_:int = int(BOX_HEIGHT);
         var _loc6_:int = int(BOX_WIDTH);
         _loc3_.x = -_loc6_ / 2;
         _loc3_.y = -_loc5_ / 2;
         if(param2)
         {
            _loc3_.graphics.beginFill(65280,0.8);
         }
         else
         {
            _loc3_.graphics.beginFill(16711680,0.8);
         }
         _loc3_.graphics.drawCircle(_loc6_ * 0.75,_loc5_ * 0.25,6);
      }
      
      public function updateActionAlpha(param1:GameScreen) : void
      {
         var _loc2_:int = 0;
         if(this.currentEntity != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.currentActions.length)
            {
               if(this.currentActions[_loc2_] < 0)
               {
                  if(this.team.tech.isResearching(this.currentActions[_loc2_]))
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],this.team.tech.getResearchCooldown(this.currentActions[_loc2_]));
                  }
                  else
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],0);
                  }
                  if(!this.team.tech.getTechAllowed(this.currentActions[_loc2_]))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 0.2;
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 1;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function update(param1:GameScreen) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TechItem = null;
         var _loc6_:TechCommand = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:TechItem = null;
         var _loc12_:UnitCommand = null;
         _loc2_ = 0;
         while(_loc2_ < param1.game.postCursors.length)
         {
            _loc3_ = param1.game.postCursors[_loc2_];
            if(_loc3_.currentFrame != _loc3_.totalFrames)
            {
               _loc3_.nextFrame();
            }
            else
            {
               if((_loc4_ = Sprite(param1.game.cursorSprite)).contains(_loc3_))
               {
                  _loc4_.removeChild(_loc3_);
               }
               param1.game.postCursors.splice(_loc2_,1);
            }
            _loc2_++;
         }
         if(param1.userInterface.selectedUnits.hasChanged && this._currentMove != null)
         {
            this.refresh();
         }
         if(this.currentEntity != null)
         {
            _loc2_ = 0;
            for(; _loc2_ < this.currentActions.length; _loc2_++)
            {
               if(this.currentActions[_loc2_] < 0)
               {
                  if(this.team.tech.isResearching(this.currentActions[_loc2_]))
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],this.team.tech.getResearchCooldown(this.currentActions[_loc2_]));
                     (_loc5_ = TechItem(this.team.tech.upgrades[this.currentActions[_loc2_]])).cancelMc.visible = true;
                     if(param1.userInterface.mouseState.mouseDown && _loc5_.cancelMc.hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,true))
                     {
                        param1.userInterface.mouseState.mouseDown = false;
                        param1.userInterface.mouseState.oldMouseDown = false;
                        param1.userInterface.mouseState.clicked = false;
                        (_loc6_ = new TechCommand(param1.game)).goalX = this.currentActions[_loc2_];
                        _loc6_.goalY = this.team.id;
                        _loc6_.team = this.team;
                        _loc6_.isCancel = true;
                        _loc6_.prepareNetworkedMove(param1);
                        this.clicked = false;
                        param1.main.soundManager.playSoundFullVolume("clickButton");
                     }
                  }
                  else
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],0);
                     (_loc5_ = TechItem(this.team.tech.upgrades[this.currentActions[_loc2_]])).cancelMc.visible = false;
                  }
                  if(!this.team.tech.getTechAllowed(this.currentActions[_loc2_]))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 0.2;
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 1;
                  }
               }
               else
               {
                  if(UnitCommand(this.actions[this.currentActions[_loc2_]]).hasCoolDown)
                  {
                     if(param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length == 0)
                     {
                        continue;
                     }
                     _loc7_ = Number(UnitCommand(this.actions[this.currentActions[_loc2_]]).coolDownTime(param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]));
                     _loc8_ = 1;
                     while(_loc8_ < param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length)
                     {
                        if((_loc9_ = Number(UnitCommand(this.actions[this.currentActions[_loc2_]]).coolDownTime(param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type][_loc8_]))) < _loc7_)
                        {
                           _loc7_ = _loc9_;
                        }
                        _loc8_++;
                     }
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],_loc7_);
                  }
                  if(UnitCommand(this.actions[this.currentActions[_loc2_]]).isToggle)
                  {
                     this.drawToggle(this.actionsToButtonMap[this.currentActions[_loc2_]],UnitCommand(this.actions[this.currentActions[_loc2_]]).isToggled(this.currentEntity));
                  }
                  else if(!UnitCommand(this.actions[this.currentActions[_loc2_]]).hasCoolDown)
                  {
                     (_loc4_ = Sprite(this.actionsToButtonMap[this.currentActions[_loc2_]].getChildByName("overlay"))).graphics.clear();
                  }
               }
            }
         }
         if(this._currentMove != null && !this.clicked)
         {
            if(this._currentMove.type in this.actionsToButtonMap)
            {
               MovieClip(this.actionsToButtonMap[this._currentMove.type]).alpha = 0.2;
            }
            if(param1.userInterface.mouseState.mouseDown && this.stage.mouseY <= 700 - 75)
            {
               if(this._currentMove.type != UnitCommand.MOVE && param1.userInterface.mouseState.isRightClick == true)
               {
                  this.refresh();
                  param1.userInterface.mouseState.mouseDown = false;
                  param1.userInterface.mouseState.isRightClick = false;
               }
               else if(!(this._currentMove.type == UnitCommand.MOVE && param1.userInterface.mouseState.isRightClick != true && this.stage.mouseY > 700 - 125))
               {
                  if(!(param1.userInterface.mouseState.isRightClick == false && param1.userInterface.keyBoardState.isShift))
                  {
                     param1.userInterface.mouseState.mouseDown = false;
                     param1.userInterface.mouseState.oldMouseDown = false;
                     param1.userInterface.mouseState.clicked = false;
                     Mouse.show();
                     this._currentMove.team = param1.team;
                     if(param1.game.mouseOverUnit != null)
                     {
                        if(param1.game.mouseOverUnit is Unit)
                        {
                           if(!Unit(param1.game.mouseOverUnit).isTargetable())
                           {
                              this._currentMove.targetId = -1;
                           }
                           else
                           {
                              this._currentMove.targetId = param1.game.mouseOverUnit.id;
                           }
                        }
                        else
                        {
                           this._currentMove.targetId = param1.game.mouseOverUnit.id;
                        }
                     }
                     else
                     {
                        this._currentMove.targetId = -1;
                     }
                     this.clicked = true;
                     if(this.currentMove.mayCast(param1,param1.team))
                     {
                        this._currentMove.prepareNetworkedMove(param1);
                     }
                     else
                     {
                        param1.userInterface.helpMessage.showMessage(this._currentMove.unableToCastMessage());
                     }
                  }
               }
            }
         }
         if(this._currentMove == null || this._currentMove != null && !this.clicked || this._currentMove == UnitCommand(this.actions[UnitCommand.MOVE]) || this.clicked)
         {
            _loc10_ = 0;
            while(_loc10_ < this.currentActions.length)
            {
               if(this.currentActions[_loc10_] < 0)
               {
                  _loc11_ = this.team.tech.upgrades[this.currentActions[_loc10_]];
                  if(MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,true))
                  {
                     param1.game.team.updateButtonOver(param1.game,_loc11_.name,_loc11_.tip,_loc11_.researchTime,_loc11_.cost,_loc11_.mana,0);
                  }
                  if(param1.userInterface.keyBoardState.isDownForAction(_loc11_.hotKey) || param1.userInterface.mouseState.clicked && Boolean(MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,false)))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).alpha = 0.2;
                     (_loc6_ = new TechCommand(param1.game)).goalX = this.currentActions[_loc10_];
                     _loc6_.goalY = this.team.id;
                     _loc6_.team = this.team;
                     _loc6_.isCancel = false;
                     _loc6_.prepareNetworkedMove(param1);
                     param1.main.soundManager.playSoundFullVolume("clickButton");
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).alpha = 1;
                  }
               }
               else
               {
                  if(MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,false))
                  {
                     param1.game.team.updateButtonOverXML(param1.game,UnitCommand(this.actions[this.currentActions[_loc10_]]).xmlInfo);
                  }
                  if(UnitCommand(this.actions[this.currentActions[_loc10_]]).isActivatable)
                  {
                     _loc12_ = UnitCommand(this.actions[this.currentActions[_loc10_]]);
                     if(param1.userInterface.keyBoardState.isDownForAction(UnitCommand(this.actions[this.currentActions[_loc10_]]).hotKey) || param1.userInterface.mouseState.clicked && Boolean(MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,false)))
                     {
                        param1.userInterface.mouseState.clicked = false;
                        _loc7_ = _loc12_.coolDownTime(param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]);
                        _loc8_ = 1;
                        while(_loc8_ < param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length)
                        {
                           if((_loc9_ = _loc12_.coolDownTime(param1.userInterface.selectedUnits.unitTypes[this.currentEntity.type][_loc8_])) < _loc7_)
                           {
                              _loc7_ = _loc9_;
                           }
                           _loc8_++;
                        }
                        if(_loc12_.getGoldRequired() > this.team.gold)
                        {
                           param1.userInterface.helpMessage.showMessage("Not enough gold to cast ");
                        }
                        else if(_loc12_.getManaRequired() > this.team.mana)
                        {
                           param1.userInterface.helpMessage.showMessage("Not enough mana to cast ");
                        }
                        else if(_loc7_ != 0)
                        {
                           param1.userInterface.helpMessage.showMessage("Ability is on cooldown");
                        }
                        else if(!UnitCommand(this.actions[this.currentActions[_loc10_]]).requiresMouseInput)
                        {
                           UnitCommand(this.actions[this.currentActions[_loc10_]]).prepareNetworkedMove(param1);
                           if(this.actionsToButtonMap[this.currentActions[_loc10_]] != null)
                           {
                              MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).alpha = 0.2;
                           }
                        }
                        else
                        {
                           this.refresh();
                           this._currentMove = UnitCommand(this.actions[this.currentActions[_loc10_]]);
                           Mouse.hide();
                           this.clicked = false;
                        }
                     }
                     else
                     {
                        MovieClip(this.actionsToButtonMap[this.currentActions[_loc10_]]).alpha = 1;
                     }
                  }
               }
               _loc10_++;
            }
         }
         if(this._currentMove != null)
         {
            if(this.clicked)
            {
               if(this._currentMove)
               {
                  this._currentMove.cleanUpPreClick(Sprite(param1.game.cursorSprite));
               }
               if(this._currentMove.drawCursorPostClick(Sprite(param1.game.cursorSprite),param1))
               {
                  this._currentMove = null;
               }
            }
            else
            {
               this._currentMove.drawCursorPreClick(Sprite(param1.game.cursorSprite),param1);
            }
         }
         if(param1.userInterface.selectedUnits.hasFinishedSelecting && this._currentMove == null && param1.userInterface.selectedUnits.interactsWith != 0 && param1.userInterface.selectedUnits.interactsWith != Unit.I_IS_BUILDING)
         {
            this._currentMove = UnitCommand(this.actions[UnitCommand.MOVE]);
            Mouse.hide();
            this.clicked = false;
         }
      }
      
      public function clear() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < COLS)
         {
            _loc3_ = 0;
            while(_loc3_ < ROWS)
            {
               (_loc4_ = Sprite(MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).getChildByName("overlay"))).graphics.clear();
               MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).alpha = 1;
               if((_loc5_ = MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).getChildByName("mc")) != null)
               {
                  MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).removeChild(_loc5_);
               }
               if((_loc5_ = MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).getChildByName("cancelMc")) != null)
               {
                  MovieClip(this.boxes[_loc1_ * COLS + _loc3_]).removeChild(_loc5_);
               }
               _loc3_++;
            }
            _loc1_++;
         }
         for(_loc2_ in this.actionsToButtonMap)
         {
            delete this.actionsToButtonMap[_loc2_];
         }
         this.currentActions.splice(0,this.currentActions.length);
      }
      
      public function setEntity(param1:com.brockw.stickwar.engine.Entity) : void
      {
         if(param1 == null)
         {
            this.currentEntity = param1;
            this.clear();
         }
         else
         {
            param1.setActionInterface(this);
            this.currentEntity = param1;
         }
      }
      
      public function setAction(param1:int, param2:int, param3:int) : void
      {
         var _loc6_:TechItem = null;
         var _loc7_:Bitmap = null;
         if(param3 < 0)
         {
            if(param3 in this.team.tech.upgrades)
            {
               _loc6_ = this.team.tech.upgrades[param3];
               MovieClip(this.boxes[param2 * COLS + param1]).visible = true;
               _loc7_ = _loc6_.mc;
               _loc7_.x = -_loc7_.width / 2;
               _loc7_.y = -_loc7_.height / 2;
               _loc7_.name = "mc";
               MovieClip(this.boxes[param2 * COLS + param1]).addChild(_loc7_);
               MovieClip(this.boxes[param2 * COLS + param1]).addChild(_loc6_.cancelMc);
               _loc6_.cancelMc.name = "cancelMc";
               _loc6_.cancelMc.x = 20;
               _loc6_.cancelMc.y = -17;
               _loc6_.cancelMc.visible = false;
               this.actionsToButtonMap[param3] = MovieClip(this.boxes[param2 * COLS + param1]);
               this.currentActions.push(param3);
            }
         }
         else if(param3 == UnitCommand.NO_COMMAND)
         {
            MovieClip(this.boxes[param2 * COLS + param1]).visible = true;
         }
         else
         {
            MovieClip(this.boxes[param2 * COLS + param1]).visible = true;
            _loc7_ = UnitCommand(this.actions[param3]).buttonBitmap;
            _loc7_.x = -_loc7_.width / 2;
            _loc7_.y = -_loc7_.height / 2;
            _loc7_.name = "mc";
            MovieClip(this.boxes[param2 * COLS + param1]).addChild(_loc7_);
            this.actionsToButtonMap[param3] = MovieClip(this.boxes[param2 * COLS + param1]);
            this.currentActions.push(param3);
         }
         var _loc4_:Sprite = Sprite(MovieClip(this.boxes[param2 * COLS + param1]).getChildByName("overlay"));
         var _loc5_:DisplayObject = MovieClip(this.boxes[param2 * COLS + param1]).getChildByName("mc");
         MovieClip(this.boxes[param2 * COLS + param1]).removeChild(_loc4_);
         MovieClip(this.boxes[param2 * COLS + param1]).addChild(_loc4_);
      }
      
      private function setUpActions() : void
      {
         this.actionsToButtonMap = new Dictionary();
         this.currentActions = [];
         this.actions = new Dictionary();
         this.actions[new AttackMoveCommand(this._game).type] = new AttackMoveCommand(this._game);
         this.actions[new MoveCommand(this._game).type] = new MoveCommand(this._game);
         this.actions[new StandCommand(this._game).type] = new StandCommand(this._game);
         this.actions[new HoldCommand(this._game).type] = new HoldCommand(this._game);
         this.actions[new GarrisonCommand(this._game).type] = new GarrisonCommand(this._game);
         this.actions[new UnGarrisonCommand(this._game).type] = new UnGarrisonCommand(this._game);
         this.actions[new SwordwrathRageCommand(this._game).type] = new SwordwrathRageCommand(this._game);
         this.actions[new NukeCommand(this._game).type] = new NukeCommand(this._game);
         this.actions[new StunCommand(this._game).type] = new StunCommand(this._game);
         this.actions[new StealthCommand(this._game).type] = new StealthCommand(this._game);
         this.actions[new HealCommand(this._game).type] = new HealCommand(this._game);
         this.actions[new CureCommand(this._game).type] = new CureCommand(this._game);
         this.actions[new PoisonDartCommand(this._game).type] = new PoisonDartCommand(this._game);
         this.actions[new SlowDartCommand(this._game).type] = new SlowDartCommand(this._game);
         this.actions[new ArcherFireCommand(this._game).type] = new ArcherFireCommand(this._game);
         this.actions[new BlockCommand(this._game).type] = new BlockCommand(this._game);
         this.actions[new FistAttackCommand(this._game).type] = new FistAttackCommand(this._game);
         this.actions[new ReaperCommand(this._game).type] = new ReaperCommand(this._game);
         this.actions[new WingidonSpeedCommand(this._game).type] = new WingidonSpeedCommand(this._game);
         this.actions[new SpeartonShieldBashCommand(this._game).type] = new SpeartonShieldBashCommand(this._game);
         this.actions[new ChargeCommand(this._game).type] = new ChargeCommand(this._game);
         this.actions[new CatPackCommand(this._game).type] = new CatPackCommand(this._game);
         this.actions[new CatFuryCommand(this._game).type] = new CatFuryCommand(this._game);
         this.actions[new DeadPoisonCommand(this._game).type] = new DeadPoisonCommand(this._game);
         this.actions[new NinjaStackCommand(this._game).type] = new NinjaStackCommand(this._game);
         this.actions[new StoneCommand(this._game).type] = new StoneCommand(this._game);
         this.actions[new PoisonPoolCommand(this._game).type] = new PoisonPoolCommand(this._game);
         this.actions[new ConstructTowerCommand(this._game).type] = new ConstructTowerCommand(this._game);
         this.actions[new ConstructWallCommand(this._game).type] = new ConstructWallCommand(this._game);
         this.actions[new BomberDetonateCommand(this._game).type] = new BomberDetonateCommand(this._game);
         this.actions[new RemoveWallCommand(this._game).type] = new RemoveWallCommand(this._game);
         this.actions[new RemoveTowerCommand(this._game).type] = new RemoveTowerCommand(this._game);
         this.actions[new WaterHealCommand(this._game).type] = new WaterHealCommand(this._game);
         this.actions[new FirestormCommand(this._game).type] = new FirestormCommand(this._game);
         this.actions[new TeleportCommand(this._game).type] = new TeleportCommand(this._game);
         this.actions[new SplitCommand(this._game).type] = new SplitCommand(this._game);
         this.actions[new ProtectCommand(this._game).type] = new ProtectCommand(this._game);
         this.actions[new FireBreathCommand(this._game).type] = new FireBreathCommand(this._game);
         this.actions[new ConvertCommand(this._game).type] = new ConvertCommand(this._game);
         this.actions[new HurricaneCommand(this._game).type] = new HurricaneCommand(this._game);
         this.actions[new MorphMinerCommand(this._game).type] = new MorphMinerCommand(this._game);
         this.actions[new FlowerCommand(this._game).type] = new FlowerCommand(this._game);
         this.actions[new TreeRootCommand(this._game).type] = new TreeRootCommand(this._game);
         this.actions[new RadiantHeatCommand(this._game).type] = new RadiantHeatCommand(this._game);
         this.actions[new BurrowCommand(this._game).type] = new BurrowCommand(this._game);
         this.actions[new UnBurrowCommand(this._game).type] = new UnBurrowCommand(this._game);
      }
      
      public function get currentMove() : UnitCommand
      {
         return this._currentMove;
      }
      
      public function set currentMove(param1:UnitCommand) : void
      {
         this._currentMove = param1;
      }
      
      public function get currentEntity() : com.brockw.stickwar.engine.Entity
      {
         return this._currentEntity;
      }
      
      public function set currentEntity(param1:com.brockw.stickwar.engine.Entity) : void
      {
         this._currentEntity = param1;
      }
      
      public function get clicked() : Boolean
      {
         return this._clicked;
      }
      
      public function set clicked(param1:Boolean) : void
      {
         this._clicked = param1;
      }
   }
}
