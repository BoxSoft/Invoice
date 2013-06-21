

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Update the Customers File
!!! </summary>
UpdateCustomers PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
RecordChanged        BYTE,AUTO                             !
History::CUS:Record  LIKE(CUS:RECORD),THREAD
QuickWindow          WINDOW('Update Customers'),AT(,,214,191),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER, |
  ICON('CUSTOMER.ICO'),GRAY,IMM,MDI,HLP('~UpdateCustomers'),SYSTEM
                       SHEET,AT(2,2,211,188),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       PROMPT('&Company:'),AT(8,9),USE(?CUS:Company:Prompt)
                       ENTRY(@s20),AT(64,9,84,10),USE(CUS:Company),CAP,MSG('Enter the customer''s company')
                       PROMPT('&First Name:'),AT(8,23),USE(?CUS:FirstName:Prompt)
                       ENTRY(@s20),AT(64,23,84,10),USE(CUS:FirstName),CAP,MSG('Enter the first name of customer'), |
  REQ
                       PROMPT('MI:'),AT(8,37,23,10),USE(?CUS:MI:Prompt)
                       ENTRY(@s1),AT(64,37,21,10),USE(CUS:MI),UPR,MSG('Enter the middle initial of customer')
                       PROMPT('&Last Name:'),AT(8,51),USE(?CUS:LastName:Prompt)
                       ENTRY(@s25),AT(64,51,104,10),USE(CUS:LastName),CAP,MSG('Enter the last name of customer'), |
  REQ
                       PROMPT('&Address1:'),AT(8,65),USE(?CUS:Address1:Prompt)
                       ENTRY(@s35),AT(64,65,139,10),USE(CUS:Address1),CAP,MSG('Enter the first line address of customer')
                       PROMPT('Address2:'),AT(8,79),USE(?CUS:Address2:Prompt)
                       ENTRY(@s35),AT(64,79,139,10),USE(CUS:Address2),CAP,MSG('Enter the second line address o' & |
  'f customer if any')
                       PROMPT('&City:'),AT(8,93),USE(?CUS:City:Prompt)
                       ENTRY(@s25),AT(64,93,104,10),USE(CUS:City),CAP,MSG('Enter  city of customer')
                       PROMPT('&State:'),AT(8,108),USE(?CUS:State:Prompt)
                       ENTRY(@s2),AT(64,108,22,10),USE(CUS:State),UPR,MSG('Enter state of customer')
                       PROMPT('&Zip Code:'),AT(8,122),USE(?CUS:ZipCode:Prompt)
                       ENTRY(@K#####|-####KB),AT(64,122,69,10),USE(CUS:ZipCode),MSG('Enter zipcode of customer'), |
  TIP('Enter zipcode of customer'),MSG('Customer''s ZipCode')
                       PROMPT('Phone Number:'),AT(8,136),USE(?CUS:PhoneNumber:Prompt)
                       ENTRY(@P(###) ###-####PB),AT(64,136,68,10),USE(CUS:PhoneNumber),MSG('Customer''s phone number')
                       PROMPT('Extension:'),AT(8,150),USE(?CUS:Extension:Prompt)
                       ENTRY(@P<<<#PB),AT(64,150,24,10),USE(CUS:Extension),MSG('Enter customer''s phone extension')
                       PROMPT('Phone Type:'),AT(109,150,43,10),USE(?CUS:PhoneType:Prompt)
                       LIST,AT(158,150,44,10),USE(CUS:PhoneType),DROP(5),FROM('Home|Work|Cellular|Pager|Fax|Other'), |
  MSG('Enter customer''s phone type')
                       BUTTON,AT(70,167,21,20),USE(?OK),ICON('DISK12.ICO'),DEFAULT,FLAT,MSG('Save recod and Exit'), |
  TIP('Save recod and Exit')
                       BUTTON,AT(103,171,13,12),USE(?Help),ICON(ICON:Help),FLAT,HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(125,167,21,20),USE(?Cancel),ICON(ICON:Cross),FLAT,MSG('Cancels change and Exit'), |
  TIP('Cancels change and Exit')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
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
? DEBUGHOOK(Customers:Record)
? DEBUGHOOK(States:Record)
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
    ActionMessage = 'Adding a Customers Record'
  OF ChangeRecord
    ActionMessage = 'Changing a Customers Record'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateCustomers')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?CUS:Company:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(CUS:Record,History::CUS:Record)
  SELF.AddHistoryField(?CUS:Company,2)
  SELF.AddHistoryField(?CUS:FirstName,3)
  SELF.AddHistoryField(?CUS:MI,4)
  SELF.AddHistoryField(?CUS:LastName,5)
  SELF.AddHistoryField(?CUS:Address1,6)
  SELF.AddHistoryField(?CUS:Address2,7)
  SELF.AddHistoryField(?CUS:City,8)
  SELF.AddHistoryField(?CUS:State,9)
  SELF.AddHistoryField(?CUS:ZipCode,10)
  SELF.AddHistoryField(?CUS:PhoneNumber,11)
  SELF.AddHistoryField(?CUS:Extension,12)
  SELF.AddHistoryField(?CUS:PhoneType,13)
  SELF.AddUpdateFile(Access:Customers)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  Relate:States.Open                                       ! File States used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Customers
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.InsertAction = Insert:Query
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 214                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 188                        ! Restrict the minimum window height
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
    Relate:Customers.Close
    Relate:States.Close
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


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    SelectStates
    ReturnValue = GlobalResponse
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
    OF ?CUS:State
      STA:StateCode = CUS:State
      IF Access:States.TryFetch(STA:StateCodeKey)
        IF SELF.Run(1,SelectRecord) = RequestCompleted
          CUS:State = STA:StateCode
        ELSE
          SELECT(?CUS:State)
          CYCLE
        END
      END
      ThisWindow.Reset(0)
      IF Access:Customers.TryValidateField(9)              ! Attempt to validate CUS:State in Customers
        SELECT(?CUS:State)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?CUS:State
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?CUS:State{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
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

