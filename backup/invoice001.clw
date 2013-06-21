

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the States File and Edit-in-Place update
!!! </summary>
SelectStates PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(States)
                       PROJECT(STA:StateCode)
                       PROJECT(STA:Name)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
STA:StateCode          LIKE(STA:StateCode)            !List box control field - type derived from field
STA:Name               LIKE(STA:Name)                 !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Select a State'),AT(,,173,203),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER,ICON('USA1.ICO'), |
  GRAY,IMM,MDI,HLP('~SelectaState'),SYSTEM
                       SHEET,AT(4,1,165,199),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                           STRING(@s2),AT(69,185,18,10),USE(STA:StateCode),FONT(,,COLOR:Red,FONT:bold),TRN
                         END
                       END
                       LIST,AT(10,7,151,171),USE(?Browse:1),VSCROLL,FORMAT('39C|M~State Code~L(2)@s2@80L(1)|M~' & |
  'State Name~@s25@'),FROM(Queue:Browse:1),IMM,MSG('Browsing Records')
                       BUTTON('&Select'),AT(74,96,19,14),USE(?Select:2),HIDE
                       BUTTON('&Insert'),AT(57,130,19,14),USE(?Insert:3),HIDE
                       BUTTON('&Change'),AT(106,130,19,14),USE(?Change:3),DEFAULT,HIDE
                       BUTTON('&Delete'),AT(42,90,19,14),USE(?Delete:3),HIDE
                       STRING('Locator: Code'),AT(9,185,57,10),USE(?String1),FONT('MS Sans Serif',8,,FONT:bold)
                       BUTTON,AT(125,157,13,12),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(145,181,19,16),USE(?Close),ICON('EXITS.ICO'),FLAT,TIP('Cancel selection and e' & |
  'xit browse')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  IncrementalLocatorClass               ! Default Locator
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
BRW1::EIPManager     BrowseEIPManager                      ! Browse EIP Manager for Browse using ?Browse:1
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
? DEBUGHOOK(States:Record)
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
  GlobalErrors.SetProcedureName('SelectStates')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?STA:StateCode
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:States.Open                                       ! File States used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:States,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon STA:StateCode for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,STA:StateCodeKey) ! Add the sort order for STA:StateCodeKey for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(?STA:StateCode,STA:StateCode,1,BRW1) ! Initialize the browse locator using ?STA:StateCode using key: STA:StateCodeKey , STA:StateCode
  BRW1.AddField(STA:StateCode,BRW1.Q.STA:StateCode)        ! Field STA:StateCode is a hot field or requires assignment from browse
  BRW1.AddField(STA:Name,BRW1.Q.STA:Name)                  ! Field STA:Name is a hot field or requires assignment from browse
  QuickWindow{PROP:MinWidth} = 173                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 203                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW1.ToolbarItem.HelpButton = ?Help
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:States.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select:2
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.EIP &= BRW1::EIPManager                             ! Set the EIP manager
  SELF.DeleteAction = EIPAction:Always
  SELF.ArrowAction = EIPAction:Default+EIPAction:Remain+EIPAction:RetainColumn
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

