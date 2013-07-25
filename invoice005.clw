

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Update the Detail File
!!! </summary>
UpdateDetail PROCEDURE 

CurrentTab           STRING(80)                            !
CheckFlag            BYTE                                  !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
RecordChanged        BYTE,AUTO                             !
LOC:RegTotalPrice    DECIMAL(9,2)                          !
LOC:DiscTotalPrice   DECIMAL(9,2)                          !
LOC:QuantityAvailable DECIMAL(7,2)                         !Quantity available for sale
SAV:Quantity         DECIMAL(7,2)                          !
NEW:Quantity         DECIMAL(7,2)                          !
SAV:BackOrder        BYTE                                  !
ProductDescription   STRING(35)                            !
History::InvoiceDetail:Record LIKE(InvoiceDetail:RECORD),THREAD
QuickWindow          WINDOW('Update Detail'),AT(,,193,119),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER,ICON('NOTE14.ICO'), |
  GRAY,IMM,MDI,HLP('~UpdateDetail'),SYSTEM
                       SHEET,AT(3,2,187,116),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                           PROMPT('Product Number:'),AT(7,21),USE(?InvoiceDetail:ProductNumber:Prompt),TRN
                           ENTRY(@n07),AT(66,21,33,10),USE(InvoiceDetail:ProductID),MSG('Product Identification Number')
                           PROMPT('Description:'),AT(7,35),USE(?ProductDescription:Prompt),TRN
                           STRING(@s35),AT(66,35,119,10),USE(ProductDescription),TRN
                         END
                       END
                       PROMPT('Line Number:'),AT(7,7),USE(?InvoiceDetail:LineNumber:Prompt)
                       STRING(@n04),AT(66,7,29,10),USE(InvoiceDetail:LineNumber)
                       BUTTON('Select Product'),AT(112,17,68,14),USE(?CallLookup),FONT('MS Serif',8,COLOR:Navy,FONT:bold), |
  IMM
                       PROMPT('Quantity Ordered:'),AT(7,48),USE(?InvoiceDetail:QuantityOrdered:Prompt)
                       SPIN(@n9.2B),AT(65,48,33,10),USE(InvoiceDetail:QuantityOrdered),MSG('Quantity of product ordered'), |
  RANGE(1,99999)
                       PROMPT('Price:'),AT(117,48,19,10),USE(?InvoiceDetail:Price:Prompt)
                       STRING(@n$10.2B),AT(136,48,41,10),USE(InvoiceDetail:Price)
                       PROMPT('Tax Rate:'),AT(7,62),USE(?InvoiceDetail:TaxRate:Prompt)
                       ENTRY(@n7.4B),AT(65,62,33,10),USE(InvoiceDetail:TaxRate),MSG('Enter Consumer''s Tax rate')
                       STRING('%'),AT(99,61,13,10),USE(?String3),FONT('MS Sans Serif',11,,FONT:bold)
                       PROMPT('Discount Rate:'),AT(7,77),USE(?InvoiceDetail:DiscountRate:Prompt)
                       ENTRY(@n7.4B),AT(65,77,33,10),USE(InvoiceDetail:DiscountRate),MSG('Enter discount rate')
                       STRING('%'),AT(99,77,13,10),USE(?String4),FONT('MS Sans Serif',11,,FONT:bold)
                       CHECK('Back Ordered'),AT(117,62),USE(InvoiceDetail:BackOrdered),COLOR(COLOR:Silver),DISABLE, |
  MSG('Product is on back order')
                       BUTTON,AT(53,95,22,20),USE(?OK),ICON('DISK12.ICO'),DEFAULT,FLAT,TIP('Save record and Exit')
                       BUTTON,AT(86,100,13,12),USE(?Help),ICON(ICON:Help),FLAT,HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(110,95,22,20),USE(?Cancel),ICON(ICON:Cross),FLAT,MSG('Cancel changes and Exit'), |
  TIP('Cancel changes and Exit')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCompleted          PROCEDURE(),BYTE,PROC,DERIVED
TakeSelected           PROCEDURE(),BYTE,PROC,DERIVED
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
? DEBUGHOOK(InvoiceDetail:Record)
? DEBUGHOOK(Product:Record)
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
!Calculate taxes, discounts, and total cost
!----------------------------------------------------------------------
CalcValues  ROUTINE
  IF InvoiceDetail:TaxRate = 0 THEN
    IF InvoiceDetail:DiscountRate = 0 THEN
      InvoiceDetail:TotalCost = InvoiceDetail:Price * |
                                             InvoiceDetail:QuantityOrdered
    ELSE
      LOC:RegTotalPrice = InvoiceDetail:Price * InvoiceDetail:QuantityOrdered
      InvoiceDetail:Discount = LOC:RegTotalPrice * |
                                             InvoiceDetail:DiscountRate / 100
      InvoiceDetail:TotalCost = LOC:RegTotalPrice - InvoiceDetail:Discount
      InvoiceDetail:Savings = LOC:RegTotalPrice - InvoiceDetail:TotalCost
    END
  ELSE
    IF InvoiceDetail:DiscountRate = 0 THEN
      LOC:RegTotalPrice = InvoiceDetail:Price * InvoiceDetail:QuantityOrdered
      InvoiceDetail:TaxPaid = LOC:RegTotalPrice * InvoiceDetail:TaxRate / 100
      InvoiceDetail:TotalCost = LOC:RegTotalPrice + InvoiceDetail:TaxPaid
    ELSE
      LOC:RegTotalPrice = InvoiceDetail:Price * InvoiceDetail:QuantityOrdered
      InvoiceDetail:Discount = LOC:RegTotalPrice * |
                                             InvoiceDetail:DiscountRate / 100
      LOC:DiscTotalPrice = LOC:RegTotalPrice - InvoiceDetail:Discount
      InvoiceDetail:TaxPaid = LOC:DiscTotalPrice * InvoiceDetail:TaxRate / 100
      InvoiceDetail:TotalCost = LOC:DiscTotalPrice + InvoiceDetail:TaxPaid
      InvoiceDetail:Savings = LOC:RegTotalPrice - InvoiceDetail:TotalCost
    END
  END
!Update InvHist and Products files
!-----------------------------------------------------------------------
UpdateOtherFiles ROUTINE

 Product:ProductID = InvoiceDetail:ProductID
 Access:Product.TryFetch(Product:ProductIDKey)
 CASE ThisWindow.Request
 OF InsertRecord
   IF InvoiceDetail:BackOrdered = FALSE
     Product:QuantityInStock -= InvoiceDetail:QuantityOrdered
     IF Access:Product.Update() <> Level:Benign
       STOP(ERROR())
     END !end if
     InventoryLog:Date = TODAY()
     InventoryLog:ProductID = InvoiceDetail:ProductID
     InventoryLog:TransType = 'Sale'
     InventoryLog:Quantity =- InvoiceDetail:QuantityOrdered
     InventoryLog:Cost = Product:Cost
     InventoryLog:Notes = 'New purchase'
     IF Access:InventoryLog.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   END !end if
 OF ChangeRecord
   IF SAV:BackOrder = FALSE
     Product:QuantityInStock += SAV:Quantity
     Product:QuantityInStock -= NEW:Quantity
     IF Access:Product.Update() <> Level:Benign
       STOP(ERROR())
     END
     InventoryLog:Date = TODAY()
     InventoryLog:ProductID = InvoiceDetail:ProductID
     InventoryLog:TransType = 'Adj.'
     InventoryLog:Quantity = (SAV:Quantity - NEW:Quantity)
     InventoryLog:Notes = 'Change in quantity purchased'
     IF Access:InventoryLog.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   ELSIF SAV:BackOrder = TRUE AND InvoiceDetail:BackOrdered = FALSE
     Product:QuantityInStock -= InvoiceDetail:QuantityOrdered
     IF Access:Product.Update() <> Level:Benign
       STOP(ERROR())
     END !end if
     InventoryLog:Date = TODAY()
     InventoryLog:ProductID = InvoiceDetail:ProductID
     InventoryLog:TransType = 'Sale'
     InventoryLog:Quantity =- InvoiceDetail:QuantityOrdered
     InventoryLog:Cost = Product:Cost
     InventoryLog:Notes = 'New purchase'
     IF Access:InventoryLog.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   END ! end if elsif
 OF DeleteRecord
   IF SAV:BackOrder = FALSE
     Product:QuantityInStock += InvoiceDetail:QuantityOrdered
     IF Access:Product.Update() <> Level:Benign
       STOP(ERROR())
     END
     InventoryLog:Date = TODAY()
     InventoryLog:ProductID = InvoiceDetail:ProductID
     InventoryLog:TransType = 'Adj.'
     InventoryLog:Quantity =+ InvoiceDetail:QuantityOrdered
     InventoryLog:Notes = 'Cancelled Order'
     IF Access:InventoryLog.Insert() <> Level:Benign
       STOP(ERROR())
     END  !End if
   END !End if
 END !End case

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Adding a Detail Record'
  OF ChangeRecord
    ActionMessage = 'Changing a Detail Record'
  OF DeleteRecord
    ActionMessage = 'Deleting a Detail Record'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateDetail')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?InvoiceDetail:ProductNumber:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  !Initializing a variable
  SAV:Quantity = InvoiceDetail:QuantityOrdered
  SAV:BackOrder = InvoiceDetail:BackOrdered
  CheckFlag = False
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(InvoiceDetail:Record,History::InvoiceDetail:Record)
  SELF.AddHistoryField(?InvoiceDetail:ProductID,4)
  SELF.AddHistoryField(?InvoiceDetail:LineNumber,3)
  SELF.AddHistoryField(?InvoiceDetail:QuantityOrdered,5)
  SELF.AddHistoryField(?InvoiceDetail:Price,7)
  SELF.AddHistoryField(?InvoiceDetail:TaxRate,8)
  SELF.AddHistoryField(?InvoiceDetail:DiscountRate,10)
  SELF.AddHistoryField(?InvoiceDetail:BackOrdered,6)
  SELF.AddUpdateFile(Access:InvoiceDetail)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:InventoryLog.SetOpenRelated()
  Relate:InventoryLog.Open                                 ! File InventoryLog used by this procedure, so make sure it's RelationManager is open
  Access:Product.UseFile                                   ! File referenced in 'Other Files' so need to inform it's FileManager
  SELF.FilesOpened = True
  SELF.Primary &= Relate:InvoiceDetail
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.InsertAction = Insert:Query
    SELF.DeleteAction = Delete:Form                        ! Display form on delete
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  IF ThisWindow.Request = ChangeRecord OR ThisWindow.Request = DeleteRecord
    Product:ProductID = InvoiceDetail:ProductID
    Access:Product.TryFetch(Product:ProductIDKey)
    ProductDescription = Product:Description
  END
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 191                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 112                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('UpdateDetail',QuickWindow)                 ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
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
  IF SELF.Opened
    INIMgr.Update('UpdateDetail',QuickWindow)              ! Save window data to non-volatile store
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
    SelectProducts
    ReturnValue = GlobalResponse
  END
  ! After lookup and out of stock message
  IF GlobalResponse = RequestCompleted
    InvoiceDetail:ProductID = Product:ProductID
    ProductDescription = Product:Description
    InvoiceDetail:Price = Product:Price
    LOC:QuantityAvailable = Product:QuantityInStock
    DISPLAY
    IF LOC:QuantityAvailable <= 0
      CASE MESSAGE('Yes for BACKORDER or No for CANCEL',|
                   'OUT OF STOCK: Select Order Options',ICON:Question,|
                      BUTTON:Yes+BUTTON:No,BUTTON:Yes,1)
      OF BUTTON:Yes
        InvoiceDetail:BackOrdered = TRUE
        DISPLAY
        SELECT(?InvoiceDetail:QuantityOrdered)
      OF BUTTON:No
        IF ThisWindow.Request = InsertRecord
          ThisWindow.Response = RequestCancelled
          Access:InvoiceDetail.CancelAutoInc
          POST(EVENT:CloseWindow)
        END !If
      END !end case
    END !end if
    IF ThisWindow.Request = ChangeRecord
      IF InvoiceDetail:QuantityOrdered < LOC:QuantityAvailable
        InvoiceDetail:BackOrdered = FALSE
        DISPLAY
      ELSE
        InvoiceDetail:BackOrdered = TRUE
        DISPLAY
      END !end if
    END !end if
    IF ProductDescription = ''
      CLEAR(InvoiceDetail:Price)
      SELECT(?CallLookup)
    END
    SELECT(?InvoiceDetail:QuantityOrdered)
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
    OF ?CallLookup
      ThisWindow.Update
      Product:ProductID = InvoiceDetail:ProductID
      IF SELF.Run(1,SelectRecord) = RequestCompleted       ! Call lookup procedure and verify RequestCompleted
        InvoiceDetail:ProductID = Product:ProductID
      END
      ThisWindow.Reset(1)
    OF ?InvoiceDetail:QuantityOrdered
      IF Access:InvoiceDetail.TryValidateField(5)          ! Attempt to validate InvoiceDetail:QuantityOrdered in InvoiceDetail
        SELECT(?InvoiceDetail:QuantityOrdered)
        QuickWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?InvoiceDetail:QuantityOrdered
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?InvoiceDetail:QuantityOrdered{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
      !Initializing a variable
      NEW:Quantity = InvoiceDetail:QuantityOrdered
       !Low stock message
      IF CheckFlag = FALSE
        IF LOC:QuantityAvailable > 0
          IF InvoiceDetail:QuantityOrdered > LOC:QuantityAvailable
            CASE MESSAGE('Yes for BACKORDER or No for CANCEL',|
                           'LOW STOCK: Select Order Options',ICON:Question,|
                             BUTTON:Yes+BUTTON:No,BUTTON:Yes,1)
            OF BUTTON:Yes
              InvoiceDetail:BackOrdered = TRUE
              DISPLAY
            OF BUTTON:No
              IF ThisWindow.Request = InsertRecord
                ThisWindow.Response = RequestCancelled
                Access:InvoiceDetail.CancelAutoInc
                POST(EVENT:CloseWindow)
              END !
            END !end case
          ELSE
            InvoiceDetail:BackOrdered = FALSE
            DISPLAY
          END !end if Detail
        END !End if LOC:
        IF ThisWindow.Request = ChangeRecord
          IF InvoiceDetail:QuantityOrdered <= LOC:QuantityAvailable
            InvoiceDetail:BackOrdered = FALSE
            DISPLAY
          ELSE
            InvoiceDetail:BackOrdered = TRUE
            DISPLAY
          END !end if
        END !end if
        CheckFlag = TRUE
      END !end if
    OF ?OK
      ThisWindow.Update
      !Calculate all totals
      DO CalcValues
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCompleted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
   !Updating other files
    DO UpdateOtherFiles
  ReturnValue = PARENT.TakeCompleted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeSelected PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all Selected events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeSelected()
    CASE FIELD()
    OF ?InvoiceDetail:ProductID
      Product:ProductID = InvoiceDetail:ProductID
      IF Access:Product.TryFetch(Product:ProductIDKey)
        IF SELF.Run(1,SelectRecord) = RequestCompleted
          InvoiceDetail:ProductID = Product:ProductID
        END
      END
      ThisWindow.Reset
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

