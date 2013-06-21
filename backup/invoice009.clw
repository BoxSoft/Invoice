

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Orders File
!!! </summary>
BrowseOrders PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
LOC:Shipped          STRING(3)                             !
LOC:Backorder        STRING(3)                             !
TaxString            STRING(8)                             !
DiscountString       STRING(8)                             !
TotalTax             DECIMAL(7,2)                          !
TotalDiscount        DECIMAL(7,2)                          !
TotalCost            DECIMAL(7,2)                          !
BRW1::View:Browse    VIEW(Orders)
                       PROJECT(ORD:OrderNumber)
                       PROJECT(ORD:OrderDate)
                       PROJECT(ORD:OrderNote)
                       PROJECT(ORD:ShipToName)
                       PROJECT(ORD:ShipAddress1)
                       PROJECT(ORD:ShipAddress2)
                       PROJECT(ORD:ShipCity)
                       PROJECT(ORD:ShipState)
                       PROJECT(ORD:ShipZip)
                       PROJECT(ORD:InvoiceNumber)
                       PROJECT(ORD:CustNumber)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
ORD:OrderNumber        LIKE(ORD:OrderNumber)          !List box control field - type derived from field
ORD:OrderDate          LIKE(ORD:OrderDate)            !List box control field - type derived from field
LOC:Shipped            LIKE(LOC:Shipped)              !List box control field - type derived from local data
ORD:OrderNote          LIKE(ORD:OrderNote)            !List box control field - type derived from field
GLOT:ShipName          LIKE(GLOT:ShipName)            !Browse hot field - type derived from global data
ORD:ShipToName         LIKE(ORD:ShipToName)           !Browse hot field - type derived from field
ORD:ShipAddress1       LIKE(ORD:ShipAddress1)         !Browse hot field - type derived from field
ORD:ShipAddress2       LIKE(ORD:ShipAddress2)         !Browse hot field - type derived from field
ORD:ShipCity           LIKE(ORD:ShipCity)             !Browse hot field - type derived from field
ORD:ShipState          LIKE(ORD:ShipState)            !Browse hot field - type derived from field
ORD:ShipZip            LIKE(ORD:ShipZip)              !Browse hot field - type derived from field
GLOT:ShipCSZ           LIKE(GLOT:ShipCSZ)             !Browse hot field - type derived from global data
ORD:InvoiceNumber      LIKE(ORD:InvoiceNumber)        !Browse hot field - type derived from field
ORD:CustNumber         LIKE(ORD:CustNumber)           !Browse key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW5::View:Browse    VIEW(Detail)
                       PROJECT(DTL:QuantityOrdered)
                       PROJECT(DTL:Price)
                       PROJECT(DTL:TaxPaid)
                       PROJECT(DTL:Discount)
                       PROJECT(DTL:TotalCost)
                       PROJECT(DTL:TaxRate)
                       PROJECT(DTL:DiscountRate)
                       PROJECT(DTL:CustNumber)
                       PROJECT(DTL:OrderNumber)
                       PROJECT(DTL:LineNumber)
                       PROJECT(DTL:ProductNumber)
                       JOIN(PRO:KeyProductNumber,DTL:ProductNumber)
                         PROJECT(PRO:Description)
                         PROJECT(PRO:ProductNumber)
                       END
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
PRO:Description        LIKE(PRO:Description)          !List box control field - type derived from field
DTL:QuantityOrdered    LIKE(DTL:QuantityOrdered)      !List box control field - type derived from field
DTL:Price              LIKE(DTL:Price)                !List box control field - type derived from field
LOC:Backorder          LIKE(LOC:Backorder)            !List box control field - type derived from local data
DTL:TaxPaid            LIKE(DTL:TaxPaid)              !List box control field - type derived from field
DTL:Discount           LIKE(DTL:Discount)             !List box control field - type derived from field
DTL:TotalCost          LIKE(DTL:TotalCost)            !List box control field - type derived from field
DTL:TaxRate            LIKE(DTL:TaxRate)              !Browse hot field - type derived from field
DTL:DiscountRate       LIKE(DTL:DiscountRate)         !Browse hot field - type derived from field
DTL:CustNumber         LIKE(DTL:CustNumber)           !Primary key field - type derived from field
DTL:OrderNumber        LIKE(DTL:OrderNumber)          !Primary key field - type derived from field
DTL:LineNumber         LIKE(DTL:LineNumber)           !Primary key field - type derived from field
PRO:ProductNumber      LIKE(PRO:ProductNumber)        !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse Orders for a Customer'),AT(,,375,193),FONT('MS Sans Serif',8,COLOR:Black),RESIZE, |
  CENTER,ICON('NOTE14.ICO'),GRAY,IMM,MDI,HLP('~BrowseOrdersforaCustomer'),SYSTEM
                       SHEET,AT(2,18,250,89),USE(?CurrentTab),FONT('Arial'),LEFT(80),UP,WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       LIST,AT(9,23,237,79),USE(?Browse:1),HVSCROLL,FORMAT('35L(1)|M~Order #~L(2)@n07@40R(4)|M' & |
  '~Order Date~L(2)@d1@31C(1)|M~Shipped~L@s3@320L(2)|M~Note~@s80@'),FROM(Queue:Browse:1),IMM, |
  MSG('Browsing Records')
                       LIST,AT(21,114,225,73),USE(?List),HVSCROLL,FORMAT('89L(2)|M~Description~L(1)@s35@36D(17' & |
  ')|M~Quantity~L(0)@n9.2B@33D(14)|M~Price~L(0)@n$10.2B@37C|M~Backorder~L(1)@s3@40D(19)' & |
  '|M~Tax Paid~L(0)@n$10.2B@40D(19)|M~Discount~L(0)@n$10.2B@56D(51)|M~Total~L(0)@n$14.2B@'), |
  FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       STRING('Customer:'),AT(7,4,46,10),USE(?String9),FONT('MS Serif',10,,FONT:bold),TRN
                       STRING(@s35),AT(53,5,115,10),USE(GLOT:CustName),FONT(,,COLOR:Red,FONT:bold)
                       STRING('Cust #:'),AT(172,4,33,10),USE(?String8),FONT('MS Serif',10,,FONT:bold)
                       STRING(@n07),AT(205,5,,10),USE(CUS:CustNumber),FONT(,,COLOR:Red,FONT:bold)
                       PANEL,AT(4,1,247,17),USE(?Panel1),BEVEL(2,-1)
                       GROUP,AT(255,2,119,72),USE(?Group1),BEVEL(2,-1),BOXED,TRN
                         STRING('Invoice #:'),AT(258,6,61,14),USE(?String11),FONT('MS Sans Serif',11,,FONT:bold+FONT:underline), |
  LEFT,TRN
                         STRING(@n07),AT(323,9,41,10),USE(ORD:InvoiceNumber),FONT(,,COLOR:Red,FONT:bold),CENTER
                         STRING('Ship To:'),AT(258,22,53,14),USE(?String1),FONT('MS Sans Serif',11,,FONT:bold+FONT:underline), |
  TRN
                         STRING(@s45),AT(258,36,113,9),USE(ORD:ShipToName)
                         STRING(@s35),AT(258,44,113,9),USE(ORD:ShipAddress1)
                         STRING(@s35),AT(258,52,113,9),USE(ORD:ShipAddress2)
                         STRING(@s40),AT(258,60,113,10),USE(GLOT:ShipCSZ)
                       END
                       BUTTON('&Insert'),AT(61,52,13,12),USE(?Insert:3),HIDE
                       BUTTON('&Change'),AT(42,53,13,12),USE(?Change:3),DEFAULT,HIDE
                       BUTTON('&Delete'),AT(99,50,13,12),USE(?Delete:3),HIDE
                       SHEET,AT(3,108,249,84),USE(?Sheet2),WIZARD
                         TAB('Tab 2'),USE(?Tab2)
                         END
                       END
                       GROUP,AT(256,109,117,83),USE(?Group2),BEVEL(2,-1),BOXED
                         STRING('Per Item'),AT(260,112,110,10),USE(?String13),FONT('MS Sans Serif',8,,FONT:bold+FONT:underline), |
  LEFT(2)
                         STRING('%'),AT(340,123,21,10),USE(?String25)
                         STRING('Tax Rate:'),AT(260,123,43,10),USE(?String14),LEFT(2)
                         STRING(@n5.2),AT(314,123,26,10),USE(DTL:TaxRate),DECIMAL(16)
                         STRING('Discount Rate:'),AT(260,132,53,10),USE(?String15),LEFT(2)
                         LINE,AT(263,145,106,0),USE(?Line1),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING('Per Order'),AT(260,148,110,10),USE(?String18),FONT('MS Sans Serif',8,,FONT:bold+FONT:underline), |
  LEFT(2)
                         STRING('Total Tax:'),AT(260,160,40,10),USE(?String19),LEFT(2)
                         STRING(@n$10.2),AT(314,160),USE(TotalTax),DECIMAL(15)
                         STRING('Total Discount:'),AT(260,169,54,10),USE(?String20),LEFT(2)
                         STRING(@n$10.2),AT(314,169),USE(TotalDiscount),DECIMAL(15)
                         STRING('Total Cost:'),AT(260,179,45,10),USE(?String21),FONT(,,,FONT:bold),LEFT(2)
                         STRING(@n$10.2B),AT(306,179),USE(TotalCost),FONT(,,COLOR:Maroon,FONT:bold),DECIMAL(15)
                         STRING(@n5.2),AT(314,132,26,10),USE(DTL:DiscountRate),DECIMAL(16)
                         STRING('%'),AT(340,132,23,10),USE(?String26),TRN
                       END
                       STRING('Items per Order'),AT(0,112,19,73),USE(?String10),FONT('Arial',11,,FONT:bold),LEFT, |
  ANGLE(900),TRN
                       BUTTON,AT(49,142,28,14),USE(?Insert),FONT(,,COLOR:Green,FONT:bold),ICON('Insert.ico'),FLAT, |
  HIDE,TIP('Insert a Detail record')
                       BUTTON,AT(99,140,33,14),USE(?Change),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON('Edit.ico'),FLAT, |
  HIDE,TIP('Edit a Detail record')
                       BUTTON,AT(170,137,33,14),USE(?Delete),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON('Delete.ico'), |
  FLAT,HIDE,TIP('Delete a Detail record')
                       BUTTON,AT(276,81,23,20),USE(?PInvButton),ICON('PRINTER.ICO'),FLAT,SKIP,TIP('Print Selec' & |
  'ted Invoice')
                       BUTTON,AT(132,60,15,15),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(330,81,23,20),USE(?Close),FONT('MS Serif',10,,FONT:bold),RIGHT,ICON('EXITS.ICO'), |
  FLAT,MSG('Close the browse'),SKIP,TIP('Close the browse')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeSelected           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
OrdersBrowse         CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetQueue             PROCEDURE(BYTE ResetMode),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort0:StepClass StepLongClass                        ! Default Step Manager
DetailBrowse         CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetFromView          PROCEDURE(),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW5::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
? DEBUGHOOK(Customers:Record)
? DEBUGHOOK(Detail:Record)
? DEBUGHOOK(Orders:Record)
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
  GlobalErrors.SetProcedureName('BrowseOrders')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('LOC:Shipped',LOC:Shipped)                          ! Added by: BrowseBox(ABC)
  BIND('GLOT:ShipName',GLOT:ShipName)                      ! Added by: BrowseBox(ABC)
  BIND('GLOT:ShipCSZ',GLOT:ShipCSZ)                        ! Added by: BrowseBox(ABC)
  BIND('LOC:Backorder',LOC:Backorder)                      ! Added by: BrowseBox(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  GLOT:CustName = CLIP(CUS:FirstName) & '   ' & CLIP(CUS:LastName)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  OrdersBrowse.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Orders,SELF) ! Initialize the browse manager
  DetailBrowse.Init(?List,Queue:Browse.ViewPosition,BRW5::View:Browse,Queue:Browse,Relate:Detail,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  ! Disable select on second list box
  ?List{PROP:NoBar} = TRUE
  Do DefineListboxStyle
  OrdersBrowse.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha)       ! Moveable thumb based upon ORD:OrderNumber for sort order 1
  OrdersBrowse.AddSortOrder(BRW1::Sort0:StepClass,ORD:KeyCustOrderNumber) ! Add the sort order for ORD:KeyCustOrderNumber for sort order 1
  OrdersBrowse.AddRange(ORD:CustNumber,Relate:Orders,Relate:Customers) ! Add file relationship range limit for sort order 1
  OrdersBrowse.AddLocator(BRW1::Sort0:Locator)             ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,ORD:OrderNumber,1,OrdersBrowse) ! Initialize the browse locator using  using key: ORD:KeyCustOrderNumber , ORD:OrderNumber
  OrdersBrowse.AddField(ORD:OrderNumber,OrdersBrowse.Q.ORD:OrderNumber) ! Field ORD:OrderNumber is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:OrderDate,OrdersBrowse.Q.ORD:OrderDate) ! Field ORD:OrderDate is a hot field or requires assignment from browse
  OrdersBrowse.AddField(LOC:Shipped,OrdersBrowse.Q.LOC:Shipped) ! Field LOC:Shipped is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:OrderNote,OrdersBrowse.Q.ORD:OrderNote) ! Field ORD:OrderNote is a hot field or requires assignment from browse
  OrdersBrowse.AddField(GLOT:ShipName,OrdersBrowse.Q.GLOT:ShipName) ! Field GLOT:ShipName is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipToName,OrdersBrowse.Q.ORD:ShipToName) ! Field ORD:ShipToName is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipAddress1,OrdersBrowse.Q.ORD:ShipAddress1) ! Field ORD:ShipAddress1 is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipAddress2,OrdersBrowse.Q.ORD:ShipAddress2) ! Field ORD:ShipAddress2 is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipCity,OrdersBrowse.Q.ORD:ShipCity) ! Field ORD:ShipCity is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipState,OrdersBrowse.Q.ORD:ShipState) ! Field ORD:ShipState is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:ShipZip,OrdersBrowse.Q.ORD:ShipZip) ! Field ORD:ShipZip is a hot field or requires assignment from browse
  OrdersBrowse.AddField(GLOT:ShipCSZ,OrdersBrowse.Q.GLOT:ShipCSZ) ! Field GLOT:ShipCSZ is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:InvoiceNumber,OrdersBrowse.Q.ORD:InvoiceNumber) ! Field ORD:InvoiceNumber is a hot field or requires assignment from browse
  OrdersBrowse.AddField(ORD:CustNumber,OrdersBrowse.Q.ORD:CustNumber) ! Field ORD:CustNumber is a hot field or requires assignment from browse
  DetailBrowse.Q &= Queue:Browse
  DetailBrowse.AddSortOrder(,DTL:KeyDetails)               ! Add the sort order for DTL:KeyDetails for sort order 1
  DetailBrowse.AddRange(DTL:OrderNumber,Relate:Detail,Relate:Orders) ! Add file relationship range limit for sort order 1
  DetailBrowse.AddLocator(BRW5::Sort0:Locator)             ! Browse has a locator for sort order 1
  BRW5::Sort0:Locator.Init(,DTL:LineNumber,1,DetailBrowse) ! Initialize the browse locator using  using key: DTL:KeyDetails , DTL:LineNumber
  DetailBrowse.AddField(PRO:Description,DetailBrowse.Q.PRO:Description) ! Field PRO:Description is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:QuantityOrdered,DetailBrowse.Q.DTL:QuantityOrdered) ! Field DTL:QuantityOrdered is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:Price,DetailBrowse.Q.DTL:Price) ! Field DTL:Price is a hot field or requires assignment from browse
  DetailBrowse.AddField(LOC:Backorder,DetailBrowse.Q.LOC:Backorder) ! Field LOC:Backorder is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:TaxPaid,DetailBrowse.Q.DTL:TaxPaid) ! Field DTL:TaxPaid is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:Discount,DetailBrowse.Q.DTL:Discount) ! Field DTL:Discount is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:TotalCost,DetailBrowse.Q.DTL:TotalCost) ! Field DTL:TotalCost is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:TaxRate,DetailBrowse.Q.DTL:TaxRate) ! Field DTL:TaxRate is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:DiscountRate,DetailBrowse.Q.DTL:DiscountRate) ! Field DTL:DiscountRate is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:CustNumber,DetailBrowse.Q.DTL:CustNumber) ! Field DTL:CustNumber is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:OrderNumber,DetailBrowse.Q.DTL:OrderNumber) ! Field DTL:OrderNumber is a hot field or requires assignment from browse
  DetailBrowse.AddField(DTL:LineNumber,DetailBrowse.Q.DTL:LineNumber) ! Field DTL:LineNumber is a hot field or requires assignment from browse
  DetailBrowse.AddField(PRO:ProductNumber,DetailBrowse.Q.PRO:ProductNumber) ! Field PRO:ProductNumber is a hot field or requires assignment from browse
  QuickWindow{PROP:MinWidth} = 375                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 193                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  OrdersBrowse.AskProcedure = 1
  DetailBrowse.AskProcedure = 2
  OrdersBrowse.AddToolbarTarget(Toolbar)                   ! Browse accepts toolbar control
  OrdersBrowse.ToolbarItem.HelpButton = ?Help
  DetailBrowse.AddToolbarTarget(Toolbar)                   ! Browse accepts toolbar control
  DetailBrowse.ToolbarItem.HelpButton = ?Help
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Customers.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      UpdateOrders
      UpdateDetail
    END
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
    OF ?PInvButton
      ThisWindow.Update
      PrintInvoiceFromBrowse()
      ThisWindow.Reset
    END
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
    CASE FIELD()
    OF ?Browse:1
      Toolbar.SetTarget(?Browse:1) !BRW1
    OF ?List
      Toolbar.SetTarget(?Browse:1) !BRW1
    END
  ReturnValue = PARENT.TakeSelected()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


OrdersBrowse.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


OrdersBrowse.ResetQueue PROCEDURE(BYTE ResetMode)

  CODE
  PARENT.ResetQueue(ResetMode)
  !Enable and Disable control
  DetailBrowse.InsertControl{PROP:DISABLE} = CHOOSE(RECORDS(SELF.ListQueue) <> 0,FALSE,TRUE)


OrdersBrowse.SetQueueRecord PROCEDURE

  CODE
  GLOT:ShipCSZ = CLIP(ORD:ShipCity) & ',  ' & ORD:ShipState & '   ' & CLIP(ORD:ShipZip)
  IF (ORD:OrderShipped)
    LOC:Shipped = 'Yes'
  ELSE
    LOC:Shipped = 'No'
  END
  PARENT.SetQueueRecord
  
  SELF.Q.LOC:Shipped = LOC:Shipped                         !Assign formula result to display queue


DetailBrowse.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


DetailBrowse.ResetFromView PROCEDURE

TotalTax:Sum         REAL                                  ! Sum variable for browse totals
TotalDiscount:Sum    REAL                                  ! Sum variable for browse totals
TotalCost:Sum        REAL                                  ! Sum variable for browse totals
  CODE
  SETCURSOR(Cursor:Wait)
  Relate:Detail.SetQuickScan(1)
  SELF.Reset
  IF SELF.UseMRP
     IF SELF.View{PROP:IPRequestCount} = 0
          SELF.View{PROP:IPRequestCount} = 60
     END
  END
  LOOP
    IF SELF.UseMRP
       IF SELF.View{PROP:IPRequestCount} = 0
            SELF.View{PROP:IPRequestCount} = 60
       END
    END
    CASE SELF.Next()
    OF Level:Notify
      BREAK
    OF Level:Fatal
      SETCURSOR()
      RETURN
    END
    SELF.SetQueueRecord
    TotalTax:Sum += DTL:TaxPaid
    TotalDiscount:Sum += DTL:Discount
    TotalCost:Sum += DTL:TotalCost
  END
  SELF.View{PROP:IPRequestCount} = 0
  TotalTax = TotalTax:Sum
  TotalDiscount = TotalDiscount:Sum
  TotalCost = TotalCost:Sum
  PARENT.ResetFromView
  Relate:Detail.SetQuickScan(0)
  SETCURSOR()


DetailBrowse.SetQueueRecord PROCEDURE

  CODE
  IF (DTL:BackOrdered)
    LOC:Backorder = 'Yes'
  ELSE
    LOC:Backorder = 'No'
  END
  PARENT.SetQueueRecord
  
  SELF.Q.LOC:Backorder = LOC:Backorder                     !Assign formula result to display queue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

