

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Splash
!!! </summary>
SplashScreen PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
window               WINDOW,AT(,,306,147),FONT('MS Sans Serif',8,COLOR:Black,FONT:regular),NOFRAME,CENTER,COLOR(0080FFFFh), |
  CURSOR('GLOVE.CUR'),GRAY,MDI,PALETTE(256)
                       PANEL,AT(0,0,306,147),USE(?PANEL1),BEVEL(3)
                       PANEL,AT(7,6,292,134),USE(?PANEL2),BEVEL(-2,1)
                       STRING('ORDER ENTRY '),AT(114,19,178,20),USE(?String2),FONT('Courier New',22,,FONT:bold),CENTER, |
  TRN
                       STRING('&'),AT(114,50,178,20),USE(?String4),FONT('Courier New',22,,FONT:bold),CENTER,TRN
                       STRING('INVOICE SYSTEM'),AT(114,82,178,20),USE(?String3),FONT('Courier New',22,,FONT:bold), |
  CENTER,TRN
                       IMAGE('Alstroemeria.jpg'),AT(12,11,101,102),USE(?Image1)
                       PANEL,AT(17,111,273,10),USE(?PANEL3),BEVEL(-1,1,9)
                       STRING('Revised by ClarionLive Webinar using Clarion 8'),AT(11,124,284,12),USE(?String1),FONT('MS Sans Serif', |
  10),CENTER,TRN
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SplashScreen')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PANEL1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  TARGET{Prop:Timer} = 1000                                ! Close window on timer event, so configure timer
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
      CASE KEYCODE()
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)                            ! Splash window will close on mouse click
      END
    OF EVENT:LoseFocus
        POST(Event:CloseWindow)                            ! Splash window will close when focus is lost
    OF Event:Timer
      POST(Event:CloseWindow)                              ! Splash window will close on event timer
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)
      END
    ELSE
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

