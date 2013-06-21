

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Update the Company File
!!! </summary>
UpdateCompany PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
RecordChanged        BYTE,AUTO                             !
History::Company:Record LIKE(Company:RECORD),THREAD
QuickWindow          WINDOW('Update Company'),AT(,,199,121),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER,GRAY, |
  IMM,HLP('~UpdateCompany'),SYSTEM
                       SHEET,AT(4,2,191,117),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       PROMPT('Name:'),AT(8,7),USE(?COM:Name:Prompt)
                       ENTRY(@s20),AT(49,7,84,10),USE(Company:Name),CAP,MSG('Company name')
                       PROMPT('Address:'),AT(8,20),USE(?COM:Address:Prompt)
                       ENTRY(@s35),AT(49,20,137,10),USE(Company:Address),CAP,MSG('First line of company''s address')
                       PROMPT('City:'),AT(8,34,17,10),USE(?COM:City:Prompt)
                       ENTRY(@s25),AT(49,34,104,10),USE(Company:City),CAP,MSG('Company''s city')
                       PROMPT('State:'),AT(8,47),USE(?COM:State:Prompt)
                       ENTRY(@s2),AT(49,47,25,10),USE(Company:State),UPR,MSG('Company''s state')
                       PROMPT('Zipcode:'),AT(8,61),USE(?COM:Zipcode:Prompt)
                       ENTRY(@K#####|-####K),AT(49,61,64,10),USE(Company:Zipcode),MSG('Company''s zipcode'),MSG('Company''s zipcode')
                       PROMPT('Phone:'),AT(8,74),USE(?COM:Phone:Prompt)
                       ENTRY(@P(###) ###-####P),AT(49,74,64,10),USE(Company:Phone),MSG('Company''s phone number')
                       BUTTON,AT(52,92,21,18),USE(?OK),ICON('DISK12.ICO'),DEFAULT,FLAT,TIP('Save changes and exit')
                       BUTTON,AT(88,92,21,18),USE(?Help),ICON(ICON:Help),FLAT,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(124,92,21,18),USE(?Cancel),ICON(ICON:Cross),FLAT,TIP('Cancel changes and exit ')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
? DEBUGHOOK(Company:Record)
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Enter  your Company''''s Information'
  OF ChangeRecord
    ActionMessage = 'Change your Company''''s Information'
  OF DeleteRecord
    GlobalErrors.Throw(Msg:DeleteIllegal)
    RETURN
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateCompany')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?COM:Name:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(Company:Record,History::Company:Record)
  SELF.AddHistoryField(?Company:Name,2)
  SELF.AddHistoryField(?Company:Address,3)
  SELF.AddHistoryField(?Company:City,4)
  SELF.AddHistoryField(?Company:State,5)
  SELF.AddHistoryField(?Company:Zipcode,6)
  SELF.AddHistoryField(?Company:Phone,7)
  SELF.AddUpdateFile(Access:Company)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Company.Open                                      ! File Company used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Company
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.DeleteAction = Delete:None                        ! Deletes not allowed
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 199                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 111                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  ToolBarForm.HelpButton=?Help
  SELF.AddItem(ToolbarForm)
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Company.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

