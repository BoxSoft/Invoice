

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
History::Customer:Record LIKE(Customer:RECORD),THREAD
QuickWindow          WINDOW('Update Customers'),AT(,,214,191),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER, |
  ICON('CUSTOMER.ICO'),GRAY,IMM,MDI,HLP('~UpdateCustomers'),SYSTEM
                       SHEET,AT(2,2,211,188),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       PROMPT('&Company:'),AT(8,9),USE(?CUS:Company:Prompt)
                       ENTRY(@s20),AT(64,9,84,10),USE(Customer:Company),CAP,MSG('Enter the customer''s company')
                       PROMPT('&First Name:'),AT(8,23),USE(?CUS:FirstName:Prompt)
                       ENTRY(@s20),AT(64,23,84,10),USE(Customer:FirstName),CAP,MSG('Enter the first name of customer'), |
  REQ
                       PROMPT('MI:'),AT(8,37,23,10),USE(?CUS:MI:Prompt)
                       ENTRY(@s1),AT(64,37,21,10),USE(Customer:MI),UPR,MSG('Enter the middle initial of customer')
                       PROMPT('&Last Name:'),AT(8,51),USE(?CUS:LastName:Prompt)
                       ENTRY(@s25),AT(64,51,104,10),USE(Customer:LastName),CAP,MSG('Enter the last name of customer'), |
  REQ
                       PROMPT('&Address1:'),AT(8,65),USE(?CUS:Address1:Prompt)
                       ENTRY(@s35),AT(64,65,139,10),USE(Customer:Address1),CAP,MSG('Enter the first line addre' & |
  'ss of customer')
                       PROMPT('Address2:'),AT(8,79),USE(?CUS:Address2:Prompt)
                       ENTRY(@s35),AT(64,79,139,10),USE(Customer:Address2),CAP,MSG('Enter the second line addr' & |
  'ess of customer if any')
                       PROMPT('&City:'),AT(8,93),USE(?CUS:City:Prompt)
                       ENTRY(@s25),AT(64,93,104,10),USE(Customer:City),CAP,MSG('Enter  city of customer')
                       PROMPT('&State:'),AT(8,108),USE(?CUS:State:Prompt)
                       ENTRY(@s2),AT(64,108,22,10),USE(Customer:StateCode),UPR,MSG('Enter state of customer')
                       PROMPT('&Zip Code:'),AT(8,122),USE(?CUS:ZipCode:Prompt)
                       ENTRY(@K#####|-####KB),AT(64,122,69,10),USE(Customer:ZipCode),MSG('Enter zipcode of customer'), |
  TIP('Enter zipcode of customer'),MSG('Customer''s ZipCode')
                       PROMPT('Phone Number:'),AT(8,136),USE(?CUS:PhoneNumber:Prompt)
                       ENTRY(@P(###) ###-####PB),AT(64,136,68,10),USE(Customer:PhoneNumber),MSG('Customer''s p' & |
  'hone number')
                       PROMPT('Extension:'),AT(8,150),USE(?CUS:Extension:Prompt)
                       ENTRY(@P<<<#PB),AT(64,150,24,10),USE(Customer:Extension),MSG('Enter customer''s phone extension')
                       PROMPT('Phone Type:'),AT(109,150,43,10),USE(?CUS:PhoneType:Prompt)
                       LIST,AT(158,150,44,10),USE(Customer:PhoneType),DROP(5),FROM('Home|Work|Cellular|Pager|Fax|Other'), |
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
? DEBUGHOOK(Customer:Record)
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
  SELF.AddHistoryFile(Customer:Record,History::Customer:Record)
  SELF.AddHistoryField(?Customer:Company,2)
  SELF.AddHistoryField(?Customer:FirstName,3)
  SELF.AddHistoryField(?Customer:MI,4)
  SELF.AddHistoryField(?Customer:LastName,5)
  SELF.AddHistoryField(?Customer:Address1,6)
  SELF.AddHistoryField(?Customer:Address2,7)
  SELF.AddHistoryField(?Customer:City,8)
  SELF.AddHistoryField(?Customer:StateCode,9)
  SELF.AddHistoryField(?Customer:ZipCode,10)
  SELF.AddHistoryField(?Customer:PhoneNumber,11)
  SELF.AddHistoryField(?Customer:Extension,12)
  SELF.AddHistoryField(?Customer:PhoneType,13)
  SELF.AddUpdateFile(Access:Customer)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Customer.SetOpenRelated()
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  Access:States.UseFile                                    ! File referenced in 'Other Files' so need to inform it's FileManager
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Customer
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
    Relate:Customer.Close
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
    OF ?Customer:StateCode
      IF Access:Customer.TryValidateField(9)               ! Attempt to validate Customer:StateCode in Customer
        SELECT(?Customer:StateCode)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?Customer:StateCode
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?Customer:StateCode{PROP:FontColor} = FieldColorQueue.OldColor
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

