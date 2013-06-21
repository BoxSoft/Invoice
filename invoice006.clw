

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Update the Orders File
!!! </summary>
UpdateOrders PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
RecordChanged        BYTE,AUTO                             !
LOC:BackOrdered      STRING(3)                             !
LOC:TotalPrice       DECIMAL(9,2)                          !
History::Invoice:Record LIKE(Invoice:RECORD),THREAD
QuickWindow          WINDOW('Update Order'),AT(,,275,163),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER,ICON('NOTE14.ICO'), |
  GRAY,IMM,MDI,HLP('~UpdateOrder'),SYSTEM
                       SHEET,AT(3,2,269,159),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       PROMPT('Order Date:'),AT(8,7),USE(?ORD:OrderDate:Prompt)
                       STRING(@d1),AT(63,7,41,10),USE(Invoice:OrderDate)
                       PROMPT('Invoice Number:'),AT(131,7,57,10),USE(?ORD:InvoiceNumber:Prompt)
                       STRING(@n07),AT(197,7),USE(Invoice:InvoiceNumber)
                       CHECK('Same Name As Customer''s'),AT(63,18,113,10),USE(Invoice:SameName),MSG('ShipTo nam' & |
  'e same as Customer''s')
                       PROMPT('Ship To Name:'),AT(8,31),USE(?ORD:ShipToName:Prompt)
                       ENTRY(@s45),AT(63,31,176,10),USE(Invoice:ShipToName),CAP,MSG('Customer the order is shipped to')
                       CHECK('Same  Address As Customer''s'),AT(63,44,113,10),USE(Invoice:SameAdd),MSG('Ship to ad' & |
  'dress same as customer''s')
                       PROMPT('Ship Address 1:'),AT(8,58),USE(?ORD:ShipAddress1:Prompt)
                       ENTRY(@s35),AT(63,58,144,10),USE(Invoice:ShipAddress1),CAP,MSG('1st Line of ship address')
                       PROMPT('Ship Address 2:'),AT(8,71),USE(?ORD:ShipAddress2:Prompt)
                       ENTRY(@s35),AT(63,73,144,10),USE(Invoice:ShipAddress2),CAP,MSG('2nd line of ship address')
                       PROMPT('Ship City:'),AT(8,87),USE(?ORD:ShipCity:Prompt)
                       ENTRY(@s25),AT(63,87,104,10),USE(Invoice:ShipCity),CAP,MSG('City of Ship address')
                       PROMPT('Ship State:'),AT(8,103),USE(?ORD:ShipState:Prompt)
                       ENTRY(@s2),AT(63,103,25,10),USE(Invoice:ShipState),UPR,MSG('State to ship to')
                       PROMPT('Ship Zip:'),AT(96,103,33,10),USE(?ORD:ShipZip:Prompt)
                       ENTRY(@K#####|-####KB),AT(131,103,60,10),USE(Invoice:ShipZip),MSG('ZipCode of ship city'),MSG('ZipCode of ship city')
                       CHECK('Order Shipped'),AT(205,103,59,10),USE(Invoice:OrderShipped),MSG('Checked if orde' & |
  'r is shipped')
                       PROMPT('Order Note:'),AT(8,119),USE(?ORD:OrderNote:Prompt)
                       ENTRY(@s80),AT(63,119,204,10),USE(Invoice:OrderNote),MSG('Additional Information about order'), |
  SCROLL
                       BUTTON,AT(99,137,20,19),USE(?OK),LEFT,ICON('DISK12.ICO'),DEFAULT,FLAT,MSG('Save  record and Exit'), |
  TIP('Save  record and Exit')
                       BUTTON,AT(133,139,13,14),USE(?Help),ICON(ICON:Help),FLAT,HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(159,137,20,19),USE(?Cancel),ICON(ICON:Cross),FLAT,MSG('Cancel changes and Exit'), |
  TIP('Cancel changes and Exit')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
Reset                  PROCEDURE(BYTE Force=0),DERIVED
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
? DEBUGHOOK(InventoryLog:Record)
? DEBUGHOOK(Invoice:Record)
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
    ActionMessage = 'Adding a Orders Record'
  OF ChangeRecord
    ActionMessage = 'Changing a Orders Record'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateOrders')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?ORD:OrderDate:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(Invoice:Record,History::Invoice:Record)
  SELF.AddHistoryField(?Invoice:OrderDate,5)
  SELF.AddHistoryField(?Invoice:InvoiceNumber,4)
  SELF.AddHistoryField(?Invoice:SameName,6)
  SELF.AddHistoryField(?Invoice:ShipToName,7)
  SELF.AddHistoryField(?Invoice:SameAdd,8)
  SELF.AddHistoryField(?Invoice:ShipAddress1,9)
  SELF.AddHistoryField(?Invoice:ShipAddress2,10)
  SELF.AddHistoryField(?Invoice:ShipCity,11)
  SELF.AddHistoryField(?Invoice:ShipState,12)
  SELF.AddHistoryField(?Invoice:ShipZip,13)
  SELF.AddHistoryField(?Invoice:OrderShipped,14)
  SELF.AddHistoryField(?Invoice:OrderNote,15)
  SELF.AddUpdateFile(Access:Invoice)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:InventoryLog.SetOpenRelated()
  Relate:InventoryLog.Open                                 ! File InventoryLog used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Invoice
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 275                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 157                        ! Restrict the minimum window height
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
    Relate:InventoryLog.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.PrimeFields PROCEDURE

  CODE
  Invoice:ShipToName = CLIP(CUS:FirstName)&' '&CLIP(CUS:LastName)
  Invoice:ShipAddress1 = CUS:Address1
  Invoice:ShipAddress2 = CUS:Address2
  Invoice:ShipCity = CUS:City
  Invoice:ShipState = CUS:State
  Invoice:ShipZip = CUS:ZipCode
  PARENT.PrimeFields


ThisWindow.Reset PROCEDURE(BYTE Force=0)

  CODE
  SELF.ForcedReset += Force
  IF QuickWindow{Prop:AcceptAll} THEN RETURN.
  Customer:CustomerID = Invoice:CustomerID                 ! Assign linking field value
  Access:Customer.Fetch(Customer:CustomerIDKey)
  States:StateCode = Invoice:ShipState                     ! Assign linking field value
  Access:States.Fetch(States:StateCodeKey)
  PARENT.Reset(Force)


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
    OF ?Invoice:ShipState
      IF Access:Invoice.TryValidateField(12)               ! Attempt to validate Invoice:ShipState in Invoice
        SELECT(?Invoice:ShipState)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?Invoice:ShipState
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?Invoice:ShipState{PROP:FontColor} = FieldColorQueue.OldColor
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

