

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Report
!!! Prints Invoice - Using the Pause Control Template
!!! </summary>
PrintInvoice PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ExtendPrice          DECIMAL(7,2)                          !
LOC:CCSZ             STRING(35)                            !
Progress:Thermometer BYTE                                  !
Process:View         VIEW(Detail)
                       PROJECT(DTL:BackOrdered)
                       PROJECT(DTL:CustNumber)
                       PROJECT(DTL:Discount)
                       PROJECT(DTL:LineNumber)
                       PROJECT(DTL:OrderNumber)
                       PROJECT(DTL:Price)
                       PROJECT(DTL:QuantityOrdered)
                       PROJECT(DTL:TaxPaid)
                       PROJECT(DTL:TotalCost)
                       PROJECT(DTL:ProductNumber)
                       JOIN(PRO:KeyProductNumber,DTL:ProductNumber)
                         PROJECT(PRO:Description)
                         PROJECT(PRO:Price)
                         PROJECT(PRO:ProductSKU)
                       END
                     END
FDB2::View:FileDrop  VIEW(Orders)
                       PROJECT(ORD:InvoiceNumber)
                       PROJECT(ORD:OrderDate)
                       PROJECT(ORD:ShipToName)
                     END
Queue:FileDrop       QUEUE                            !Queue declaration for browse/combo box using ?ORD:InvoiceNumber:2
ORD:InvoiceNumber      LIKE(ORD:InvoiceNumber)        !List box control field - type derived from field
ORD:OrderDate          LIKE(ORD:OrderDate)            !List box control field - type derived from field
ORD:ShipToName         LIKE(ORD:ShipToName)           !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
ProgressWindow       WINDOW('Report Progress...'),AT(,,168,94),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(24,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(3,3,162,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(3,30,162,10),USE(?Progress:PctText),CENTER
                       STRING('Select An Invoice And Press Go To Preview'),AT(2,44,164,10),USE(?String3),FONT(,,COLOR:Maroon, |
  FONT:bold),CENTER
                       LIST,AT(9,60,150,12),USE(ORD:InvoiceNumber,,?ORD:InvoiceNumber:2),VSCROLL,DROP(5),FORMAT('33L(3)|~In' & |
  'voice #~L(2)@n07@41L(3)|~Order Date~L(2)@d1@180L(2)|~Ship To~@s45@'),FROM(Queue:FileDrop),MSG('Invoice number for each order')
                       BUTTON('Exit'),AT(115,77,44,13),USE(?Progress:Cancel),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON(ICON:NoPrint), |
  TIP('Exit window or cancel printing')
                       BUTTON('Pause'),AT(9,77,44,13),USE(?Pause),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON(ICON:Print1), |
  TIP('Preview Invoice to Print')
                     END

Report               REPORT,AT(500,4115,7500,5875),PRE(RPT),FONT('MS Sans Serif',10,COLOR:Black,FONT:regular),THOUS
                       HEADER,AT(500,500,7500,3583)
                         IMAGE('LANTHUR.GIF'),AT(5396,21,1875,1594),USE(?Image1)
                         LINE,AT(2927,344,1458,0),USE(?Line1),COLOR(COLOR:Black),LINEWIDTH(2)
                         IMAGE('RANTHUR.GIF'),AT(92,25,1875,1594),USE(?Image2)
                         STRING('INVOICE'),AT(1979,10,3375,323),USE(?String35),FONT('MS Sans Serif',24,,FONT:bold), |
  CENTER
                         STRING(@s20),AT(1979,448,3375,333),USE(COM:Name),FONT('MS Sans Serif',18,,FONT:bold),CENTER
                         STRING(@s35),AT(1979,781,3396,219),USE(COM:Address),FONT('MS Sans Serif',12,,FONT:bold),CENTER
                         STRING(@s35),AT(1979,1031,3396,219),USE(LOC:CCSZ),FONT('MS Sans Serif',12,,FONT:bold),CENTER
                         STRING(@P(###) ###-####P),AT(1979,1250,3396,219),USE(COM:Phone),FONT('MS Sans Serif',12,,FONT:bold), |
  CENTER
                         BOX,AT(73,1927,7232,333),USE(?Box1),LINEWIDTH(2),ROUND
                         STRING('Product SKU'),AT(104,3354,917,198),USE(?String17),TRN
                         STRING('Product Description'),AT(1063,3354,2083,198),USE(?String18),TRN
                         STRING('Quantity'),AT(5521,3354,729,198),USE(?String20),RIGHT(50),TRN
                         STRING('Extension'),AT(6500,3354,781,198),USE(?String21),RIGHT(50),TRN
                         LINE,AT(83,3563,7232,0),USE(?Line3),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING('BackOrder'),AT(3729,3354,708,198),USE(?String36),TRN
                         STRING('Price'),AT(4896,3354,406,198),USE(?String19),TRN
                         STRING('Invoice #'),AT(177,1969,927,240),USE(?String15),FONT('MS Sans Serif',14,,FONT:bold), |
  TRN
                         STRING('Order Date:'),AT(3625,2010,917,177),USE(?String33),FONT(,,,FONT:bold),TRN
                         STRING(@d1),AT(4531,2010,729,177),USE(ORD:OrderDate),CENTER,TRN
                         STRING(@n07),AT(1125,2021,729,177),USE(ORD:InvoiceNumber),CENTER,TRN
                         GROUP,AT(4083,2563,3250,573),USE(?Group2),FONT('MS Sans Serif',10)
                           STRING(@s35),AT(4146,2604,2948,167),USE(GLOT:ShipName)
                           STRING(@s45),AT(4146,2771,3125,167),USE(GLOT:ShipAddress)
                           STRING(@s40),AT(4146,2927,3125,167),USE(GLOT:ShipCSZ)
                         END
                         GROUP,AT(146,2573,3250,573),USE(?Group1),FONT('MS Sans Serif',10)
                           STRING(@s35),AT(208,2604,3083,167),USE(GLOT:CustName)
                           STRING(@s45),AT(208,2771,3125,167),USE(GLOT:CustAddress)
                           STRING(@s40),AT(208,2927,3000,167),USE(GLOT:CusCSZ)
                         END
                         LINE,AT(83,3302,7232,0),USE(?Line2),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING('Ship To:'),AT(4031,2302,750,198),USE(?String31),FONT(,,,FONT:bold)
                         BOX,AT(83,2531,3302,625),USE(?Box6),LINEWIDTH(2),ROUND
                         BOX,AT(4010,2531,3302,625),USE(?Box5),LINEWIDTH(2),ROUND
                         STRING('Sold To:'),AT(167,2313,750,188),USE(?String32),FONT(,,,FONT:bold)
                       END
detail                 DETAIL,AT(,,,242),USE(?detail)
                         STRING(@n$14.2B),AT(5406,21,83,52),USE(DTL:TotalCost),HIDE,TRN
                         STRING(@n$10.2B),AT(5500,10,135,52),USE(DTL:Discount),HIDE,TRN
                         STRING(@s10),AT(115,42,896,167),USE(PRO:ProductSKU)
                         STRING(@s35),AT(1083,42,2677,167),USE(PRO:Description)
                         CHECK,AT(3969,42,250,177),USE(DTL:BackOrdered)
                         STRING(@n7),AT(5635,42,635,167),USE(DTL:QuantityOrdered),RIGHT(100)
                         STRING(@n$10.2),AT(6458,42,823,167),USE(ExtendPrice),DECIMAL(250)
                         STRING(@n$10.2),AT(4552,42,771,167),USE(PRO:Price),DECIMAL(250)
                         STRING(@n$10.2B),AT(5635,10,63,52),USE(DTL:TaxPaid,,?DTL:TaxPaid:2),HIDE,TRN
                       END
detail1                DETAIL,AT(,,,967),USE(?detail1)
                         LINE,AT(83,10,7232,0),USE(?Line4),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING('Sub-total:'),AT(5594,52,813,198),USE(?String23),FONT(,,,FONT:bold),LEFT(50),TRN
                         STRING(@n$10.2),AT(6458,250,844,167),USE(DTL:Discount,,?DTL:Discount:2),DECIMAL(250),SUM,TALLY(detail)
                         STRING(@n$10.2),AT(6448,52,844,198),USE(ExtendPrice,,?ExtendPrice:2),DECIMAL(250),SUM,TALLY(detail), |
  TRN
                         STRING('Discount:'),AT(5604,250,781,167),USE(?String24),LEFT(50)
                         STRING('NOTE: Product on Back-Order will be available in 4 days.'),AT(83,396,3750,240),USE(?NoteString), |
  FONT('MS Sans Serif',10),CENTER
                         STRING('Tax:'),AT(5604,417,760,167),USE(?String27),LEFT(50)
                         STRING(@n$10.2),AT(6458,417,844,167),USE(DTL:TaxPaid),DECIMAL(250),SUM,TALLY(detail)
                         LINE,AT(6350,615,962,0),USE(?Line5),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING('Total:'),AT(5594,667,583,198),USE(?String30),FONT(,,,FONT:bold),LEFT(50),TRN
                         LINE,AT(6354,875,962,0),USE(?Line6),COLOR(COLOR:Black),LINEWIDTH(2)
                         LINE,AT(6354,906,962,0),USE(?Line7),COLOR(COLOR:Black),LINEWIDTH(2)
                         STRING(@n$14.2),AT(6240,656,1052,208),USE(DTL:TotalCost,,?DTL:TotalCost:2),DECIMAL(250),SUM, |
  TALLY(detail),TRN
                       END
                       FOOTER,AT(500,10021,7500,275)
                         STRING('Thank You For Your Order, Please Call Again.'),AT(21,10,7438,208),USE(?String22),FONT('MS Sans Serif', |
  10,,FONT:bold),CENTER
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Next                   PROCEDURE(),BYTE,PROC,DERIVED
Paused                 BYTE
Timer                  LONG
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeCloseEvent         PROCEDURE(),BYTE,PROC,DERIVED
Cancelled              BYTE
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ProgressMgr          StepLongClass                         ! Progress Manager
Previewer            PrintPreviewClass                     ! Print Previewer
FDB2                 CLASS(FileDropClass)                  ! File drop manager
Q                      &Queue:FileDrop                !Reference to display queue
                     END


  CODE
? DEBUGHOOK(Company:Record)
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
  GlobalErrors.SetProcedureName('PrintInvoice')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('GLOT:CustName',GLOT:CustName)                      ! Added by: Report
  BIND('GLOT:CustAddress',GLOT:CustAddress)                ! Added by: Report
  BIND('GLOT:CusCSZ',GLOT:CusCSZ)                          ! Added by: Report
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:Company.Open                                      ! File Company used by this procedure, so make sure it's RelationManager is open
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  Access:Orders.UseFile                                    ! File referenced in 'Other Files' so need to inform it's FileManager
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:Detail, ?Progress:PctText, Progress:Thermometer, ProgressMgr, DTL:CustNumber)
  ThisReport.AddSortOrder(DTL:KeyDetails)
  ThisReport.SetFilter('DTL:CustNumber=ORD:CustNumber AND DTL:OrderNumber=ORD:OrderNumber')
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:Detail.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  FDB2.Init(?ORD:InvoiceNumber:2,Queue:FileDrop.ViewPosition,FDB2::View:FileDrop,Queue:FileDrop,Relate:Orders,ThisWindow)
  FDB2.Q &= Queue:FileDrop
  FDB2.AddSortOrder(ORD:InvoiceNumberKey)
  FDB2.AddField(ORD:InvoiceNumber,FDB2.Q.ORD:InvoiceNumber) !List box control field - type derived from field
  FDB2.AddField(ORD:OrderDate,FDB2.Q.ORD:OrderDate) !List box control field - type derived from field
  FDB2.AddField(ORD:ShipToName,FDB2.Q.ORD:ShipToName) !List box control field - type derived from field
  ThisWindow.AddItem(FDB2.WindowComponent)
  FDB2.DefaultFill = 0
  SELF.SkipPreview = False
  SELF.Zoom = PageWidth
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  Previewer.Maximize = True
  ASSERT(~SELF.DeferWindow) ! A hidden Go button is not smart ...
  SELF.KeepVisible = 1
  SELF.DeferOpenReport = 1
  SELF.Timer = TARGET{PROP:Timer}
  TARGET{PROP:Timer} = 0
  ?Pause{PROP:Text} = 'Go'
  SELF.Paused = 1
  ?Progress:Cancel{PROP:Key} = EscKey
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Company.Close
    Relate:Customers.Close
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Next PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
   !Process company record
   SET(Company)
   Access:Company.Next()
   LOC:CCSZ = CLIP(Company.Record.City) & ', ' & Company.Record.State|
                & '  ' & CLIP(Company.Record.Zipcode)
  ReturnValue = PARENT.Next()
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
    CASE ACCEPTED()
    OF ?Pause
      IF SELF.Paused
        TARGET{PROP:Timer} = SELF.Timer
        ?Pause{PROP:Text} = 'Pause'
      ELSE
        SELF.Timer = TARGET{PROP:Timer}
        TARGET{PROP:Timer} = 0
        ?Pause{PROP:Text} = 'Restart'
      END
      SELF.Paused = 1 - SELF.Paused
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Progress:Cancel
      ThisWindow.Update
      SELF.Cancelled = 1
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  !Print second Detail band
  PRINT(RPT:Detail1)
  ReturnValue = PARENT.TakeCloseEvent()
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
    CASE EVENT()
    OF EVENT:CloseWindow
      SELF.KeepVisible = 1
    OF EVENT:Timer
      IF SELF.Paused THEN RETURN Level:Benign .
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:CloseWindow
      IF ~SELF.Cancelled
        Progress:Thermometer = 0
        ?Progress:PctText{PROP:Text} = '0% Completed'
        SELF.DeferOpenReport = 1
        TARGET{PROP:Timer} = 0
        ?Pause{PROP:Text} = 'Go'
        SELF.Paused = 1
        SELF.Process.Close
        SELF.Response = RequestCancelled
        DISPLAY
        RETURN Level:Notify
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  !Get Customer records
  CUS:CustNumber=ORD:CustNumber
  Access:Customers.Fetch(CUS:KeyCustNumber)
  ExtendPrice = DTL:Price * DTL:QuantityOrdered
  GLOT:CustName = CLIP(CUS:FirstName) & '   ' & CLIP(CUS:LastName)
  GLOT:CustAddress = CLIP(CUS:Address1) & '    ' & CLIP(CUS:Address2)
  GLOT:CusCSZ = CLIP(CUS:City) & ',   ' & CUS:State & '    ' & CLIP(CUS:ZipCode)
  GLOT:ShipName = CLIP(ORD:ShipToName)
  GLOT:ShipAddress = CLIP(ORD:ShipAddress1) & '   ' & CLIP(ORD:ShipAddress2)
  GLOT:ShipCSZ = CLIP(ORD:ShipCity) & ',  ' & ORD:ShipState & '    ' & CLIP(ORD:ShipZip)
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

