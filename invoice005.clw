

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
                           PROMPT('Product Number:'),AT(7,21),USE(?DTL:ProductNumber:Prompt),TRN
                           ENTRY(@n07),AT(66,21,33,10),USE(InvoiceDetail:ProductID),MSG('Product Identification Number')
                           PROMPT('Description:'),AT(7,35),USE(?ProductDescription:Prompt),TRN
                           STRING(@s35),AT(66,35,119,10),USE(ProductDescription),TRN
                         END
                       END
                       PROMPT('Line Number:'),AT(7,7),USE(?DTL:LineNumber:Prompt)
                       STRING(@n04),AT(66,7,29,10),USE(InvoiceDetail:LineNumber)
                       BUTTON('Select Product'),AT(112,17,68,14),USE(?CallLookup),FONT('MS Serif',8,COLOR:Navy,FONT:bold), |
  IMM
                       PROMPT('Quantity Ordered:'),AT(7,48),USE(?DTL:QuantityOrdered:Prompt)
                       SPIN(@n9.2B),AT(65,48,33,10),USE(InvoiceDetail:QuantityOrdered),MSG('Quantity of product ordered'), |
  RANGE(1,99999)
                       PROMPT('Price:'),AT(117,48,19,10),USE(?DTL:Price:Prompt)
                       STRING(@n$10.2B),AT(136,48,41,10),USE(InvoiceDetail:Price)
                       PROMPT('Tax Rate:'),AT(7,62),USE(?DTL:TaxRate:Prompt)
                       ENTRY(@n7.4B),AT(65,62,33,10),USE(InvoiceDetail:TaxRate),MSG('Enter Consumer''s Tax rate')
                       STRING('%'),AT(99,61,13,10),USE(?String3),FONT('MS Sans Serif',11,,FONT:bold)
                       PROMPT('Discount Rate:'),AT(7,77),USE(?DTL:DiscountRate:Prompt)
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
  IF DTL:TaxRate = 0 THEN
    IF DTL:DiscountRate = 0 THEN
      DTL:TotalCost = DTL:Price * |
                                             DTL:QuantityOrdered
    ELSE
      LOC:RegTotalPrice = DTL:Price * DTL:QuantityOrdered
      DTL:Discount = LOC:RegTotalPrice * |
                                             DTL:DiscountRate / 100
      DTL:TotalCost = LOC:RegTotalPrice - DTL:Discount
      DTL:Savings = LOC:RegTotalPrice - DTL:TotalCost
    END
  ELSE
    IF DTL:DiscountRate = 0 THEN
      LOC:RegTotalPrice = DTL:Price * DTL:QuantityOrdered
      DTL:TaxPaid = LOC:RegTotalPrice * DTL:TaxRate / 100
      DTL:TotalCost = LOC:RegTotalPrice + DTL:TaxPaid
    ELSE
      LOC:RegTotalPrice = DTL:Price * DTL:QuantityOrdered
      DTL:Discount = LOC:RegTotalPrice * |
                                             DTL:DiscountRate / 100
      LOC:DiscTotalPrice = LOC:RegTotalPrice - DTL:Discount
      DTL:TaxPaid = LOC:DiscTotalPrice * DTL:TaxRate / 100
      DTL:TotalCost = LOC:DiscTotalPrice + DTL:TaxPaid
      DTL:Savings = LOC:RegTotalPrice - DTL:TotalCost
    END
  END
!Update InvHist and Products files
!-----------------------------------------------------------------------
UpdateOtherFiles ROUTINE

 PRO:ProductNumber = DTL:ProductNumber
 Access:Products.TryFetch(PRO:KeyProductNumber)
 CASE ThisWindow.Request
 OF InsertRecord
   IF DTL:BackOrdered = FALSE
     PRO:QuantityInStock -= DTL:QuantityOrdered
     IF Access:Products.Update() <> Level:Benign
       STOP(ERROR())
     END !end if
     INV:Date = TODAY()
     INV:ProductNumber = DTL:ProductNumber
     INV:TransType = 'Sale'
     INV:Quantity =- DTL:QuantityOrdered
     INV:Cost = PRO:Cost
     INV:Notes = 'New purchase'
     IF Access:InvHist.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   END !end if
 OF ChangeRecord
   IF SAV:BackOrder = FALSE
     PRO:QuantityInStock += SAV:Quantity
     PRO:QuantityInStock -= NEW:Quantity
     IF Access:Products.Update() <> Level:Benign
       STOP(ERROR())
     END
     InvHist.Date = TODAY()
     INV:ProductNumber = DTL:ProductNumber
     INV:TransType = 'Adj.'
     INV:Quantity = (SAV:Quantity - NEW:Quantity)
     INV:Notes = 'Change in quantity purchased'
     IF Access:InvHist.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   ELSIF SAV:BackOrder = TRUE AND DTL:BackOrdered = FALSE
     PRO:QuantityInStock -= DTL:QuantityOrdered
     IF Access:Products.Update() <> Level:Benign
       STOP(ERROR())
     END !end if
     INV:Date = TODAY()
     INV:ProductNumber = DTL:ProductNumber
     INV:TransType = 'Sale'
     INV:Quantity =- DTL:QuantityOrdered
     INV:Cost = PRO:Cost
     INV:Notes = 'New purchase'
     IF Access:InvHist.Insert() <> Level:Benign
       STOP(ERROR())
     END !end if
   END ! end if elsif
 OF DeleteRecord
   IF SAV:BackOrder = FALSE
     PRO:QuantityInStock += DTL:QuantityOrdered
     IF Access:Products.Update() <> Level:Benign
       STOP(ERROR())
     END
     INV:Date = TODAY()
     INV:ProductNumber = DTL:ProductNumber
     INV:TransType = 'Adj.'
     INV:Quantity =+ DTL:QuantityOrdered
     INV:Notes = 'Cancelled Order'
     IF Access:InvHist.Insert() <> Level:Benign
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
  SELF.FirstField = ?DTL:ProductNumber:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  !Initializing a variable
  SAV:Quantity = DTL:QuantityOrdered
  SAV:BackOrder = DTL:BackOrdered
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
    PRO:ProductNumber = DTL:ProductNumber
    Access:Products.TryFetch(PRO:KeyProductNumber)
    ProductDescription = PRO:Description
  END
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 191                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 112                        ! Restrict the minimum window height
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
  ! After lookup and out of stock message
  IF GlobalResponse = RequestCompleted
    DTL:ProductNumber = PRO:ProductNumber
    ProductDescription = PRO:Description
    DTL:Price = PRO:Price
    LOC:QuantityAvailable = PRO:QuantityInStock
    DISPLAY
    IF LOC:QuantityAvailable <= 0
      CASE MESSAGE('Yes for BACKORDER or No for CANCEL',|
                   'OUT OF STOCK: Select Order Options',ICON:Question,|
                      BUTTON:Yes+BUTTON:No,BUTTON:Yes,1)
      OF BUTTON:Yes
        DTL:BackOrdered = TRUE
        DISPLAY
        SELECT(?DTL:QuantityOrdered)
      OF BUTTON:No
        IF ThisWindow.Request = InsertRecord
          ThisWindow.Response = RequestCancelled
          Access:Detail.CancelAutoInc
          POST(EVENT:CloseWindow)
        END !If
      END !end case
    END !end if
    IF ThisWindow.Request = ChangeRecord
      IF DTL:QuantityOrdered < LOC:QuantityAvailable
        DTL:BackOrdered = FALSE
        DISPLAY
      ELSE
        DTL:BackOrdered = TRUE
        DISPLAY
      END !end if
    END !end if
    IF ProductDescription = ''
      CLEAR(DTL:Price)
      SELECT(?CallLookup)
    END
    SELECT(?DTL:QuantityOrdered)
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
       = InvoiceDetail:ProductID
      IF SELF.Run(0,SelectRecord) = RequestCompleted       ! Call lookup procedure and verify RequestCompleted
        InvoiceDetail:ProductID = 
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


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

