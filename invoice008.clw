

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Report
!!! Prints Invoice for each order
!!! </summary>
PrintInvoiceFromBrowse PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ExtendPrice          DECIMAL(7,2)                          !
LOC:CCSZ             STRING(35)                            !
Progress:Thermometer BYTE                                  !
Process:View         VIEW(InvoiceDetail)
                       PROJECT(InvoiceDetail:BackOrdered)
                       PROJECT(InvoiceDetail:Discount)
                       PROJECT(InvoiceDetail:InvoiceID)
                       PROJECT(InvoiceDetail:LineNumber)
                       PROJECT(InvoiceDetail:QuantityOrdered)
                       PROJECT(InvoiceDetail:TaxPaid)
                       PROJECT(InvoiceDetail:TotalCost)
                       PROJECT(InvoiceDetail:ProductID)
                       JOIN(Product:ProductIDKey,InvoiceDetail:ProductID)
                         PROJECT(Product:Description)
                         PROJECT(Product:Price)
                         PROJECT(Product:ProductSKU)
                       END
                     END
ProgressWindow       WINDOW('Report Progress...'),AT(,,142,59),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(45,42,48,15),USE(?Progress:Cancel),LEFT,ICON(ICON:NoPrint),FLAT,TIP('Cancel printing')
                     END

Report               REPORT,AT(500,4115,7500,5875),PRE(RPT),FONT('MS Sans Serif',10,COLOR:Black,FONT:regular),THOUS
                       HEADER,AT(500,500,7500,3583)
                         IMAGE('LANTHUR.GIF'),AT(5417,21,1875,1594),USE(?Image1)
                         LINE,AT(2948,354,1458,0),USE(?Line7),COLOR(COLOR:Black),LINEWIDTH(3)
                         IMAGE('RANTHUR.GIF'),AT(83,21,1875,1594),USE(?Image2)
                         STRING('INVOICE'),AT(1990,10,3375,302),USE(?String35),FONT('MS Sans Serif',24,,FONT:bold), |
  CENTER
                         STRING(@s20),AT(1990,448,3375,333),USE(Company:Name),FONT('MS Sans Serif',18,,FONT:bold),CENTER
                         STRING(@s35),AT(1990,781,3375,250),USE(Company:Address),FONT('MS Sans Serif',12,,FONT:bold), |
  CENTER
                         STRING(@s35),AT(1990,1031,3375,250),USE(LOC:CCSZ),FONT('MS Sans Serif',12,,FONT:bold),CENTER
                         STRING(@P(###) ###-####P),AT(1990,1260,3375,250),USE(Company:Phone),FONT('MS Sans Serif',12, |
  ,FONT:bold),CENTER
                         BOX,AT(83,1906,7232,333),USE(?Box1),COLOR(COLOR:Black),LINEWIDTH(4),ROUND
                         STRING('Product SKU'),AT(104,3333,917,198),USE(?String17),TRN
                         STRING('Product Description'),AT(1042,3333,2083,198),USE(?String18),TRN
                         STRING('Quantity'),AT(5521,3333,729,198),USE(?String20),RIGHT(50),TRN
                         STRING('Extension'),AT(6500,3333,781,198),USE(?String21),RIGHT(50),TRN
                         LINE,AT(83,3542,7232,0),USE(?Line2),COLOR(COLOR:Black),LINEWIDTH(3)
                         STRING('BackOrder'),AT(3729,3333,708,198),USE(?String36),TRN
                         STRING('Price'),AT(4896,3333,406,198),USE(?String19),TRN
                         STRING('Invoice #'),AT(177,1969,927,240),USE(?String15),FONT('MS Sans Serif',14,,FONT:bold), |
  TRN
                         STRING('Order Date:'),AT(3625,2010,917,177),USE(?String33),FONT(,,,FONT:bold),TRN
                         STRING(@d1),AT(4531,2010,729,177),USE(Invoice:OrderDate),CENTER,TRN
                         STRING(@n07),AT(1125,2021,729,177),USE(Invoice:InvoiceNumber),CENTER,TRN
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
                         LINE,AT(83,3281,7232,0),USE(?Line1),COLOR(COLOR:Black),LINEWIDTH(3)
                         STRING('Ship To:'),AT(4031,2313,750,198),USE(?String31),FONT(,,,FONT:bold)
                         BOX,AT(83,2531,3302,625),USE(?Box6),COLOR(COLOR:Black),LINEWIDTH(2),ROUND
                         BOX,AT(4010,2531,3302,625),USE(?Box5),COLOR(COLOR:Black),LINEWIDTH(2),ROUND
                         STRING('Sold To:'),AT(115,2313,750,188),USE(?String32),FONT(,,,FONT:bold)
                       END
detail                 DETAIL,AT(,,,242),USE(?detail)
                         STRING(@n$14.2B),AT(5406,21,83,52),USE(InvoiceDetail:TotalCost),HIDE,TRN
                         STRING(@n$10.2B),AT(5500,10,135,52),USE(InvoiceDetail:Discount),HIDE,TRN
                         STRING(@s10),AT(115,42,896,167),USE(Product:ProductSKU)
                         STRING(@s35),AT(1083,42,2677,167),USE(Product:Description)
                         CHECK,AT(3969,42,250,177),USE(InvoiceDetail:BackOrdered)
                         STRING(@n7),AT(5635,42,635,167),USE(InvoiceDetail:QuantityOrdered),RIGHT(100)
                         STRING(@n$10.2),AT(6458,42,823,167),USE(ExtendPrice),DECIMAL(250)
                         STRING(@n$10.2),AT(4552,42,771,167),USE(Product:Price),DECIMAL(250)
                         STRING(@n$10.2B),AT(5635,10,63,52),USE(InvoiceDetail:TaxPaid,,?DTL:TaxPaid:2),HIDE,TRN
                       END
detail1                DETAIL,AT(,,,967),USE(?detail1)
                         LINE,AT(83,10,7232,0),USE(?Line3),COLOR(COLOR:Black),LINEWIDTH(3)
                         STRING('Sub-total:'),AT(5594,52,813,198),USE(?String23),FONT(,,,FONT:bold),LEFT(50),TRN
                         STRING(@n$10.2),AT(6417,240,844,167),USE(InvoiceDetail:Discount,,?DTL:Discount:2),DECIMAL(250), |
  SUM,TALLY(detail)
                         STRING(@n$10.2),AT(6417,52,844,198),USE(ExtendPrice,,?ExtendPrice:2),DECIMAL(250),SUM,TALLY(detail), |
  TRN
                         STRING('Discount:'),AT(5594,240,781,167),USE(?String24),LEFT(50)
                         STRING('NOTE: Product on Back-Order will be available in 4 days.'),AT(83,375,3750,240),USE(?NoteString), |
  FONT('MS Sans Serif',10),CENTER
                         STRING('Tax:'),AT(5594,406,760,167),USE(?String27),LEFT(50)
                         STRING(@n$10.2),AT(6417,406,844,167),USE(InvoiceDetail:TaxPaid),DECIMAL(250),SUM,TALLY(detail)
                         LINE,AT(6350,625,962,0),USE(?Line4),COLOR(COLOR:Black),LINEWIDTH(3)
                         LINE,AT(6350,875,962,0),USE(?Line5),COLOR(COLOR:Black),LINEWIDTH(3)
                         LINE,AT(6350,917,962,0),USE(?Line6),COLOR(COLOR:Black),LINEWIDTH(3)
                         STRING('Total:'),AT(5594,677,583,198),USE(?String30),FONT(,,,FONT:bold),LEFT(50),TRN
                         STRING(@n$14.2),AT(6208,677,1052,208),USE(InvoiceDetail:TotalCost,,?DTL:TotalCost:2),DECIMAL(250), |
  SUM,TALLY(detail),TRN
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
TakeCloseEvent         PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ProgressMgr          StepLongClass                         ! Progress Manager
Previewer            PrintPreviewClass                     ! Print Previewer

  CODE
? DEBUGHOOK(Company:Record)
? DEBUGHOOK(Customer:Record)
? DEBUGHOOK(Invoice:Record)
? DEBUGHOOK(InvoiceDetail:Record)
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
  GlobalErrors.SetProcedureName('PrintInvoiceFromBrowse')
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
  Relate:Customer.SetOpenRelated()
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  Access:Invoice.UseFile                                   ! File referenced in 'Other Files' so need to inform it's FileManager
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:InvoiceDetail, ?Progress:PctText, Progress:Thermometer, ProgressMgr, InvoiceDetail:InvoiceID)
  ThisReport.AddSortOrder(InvoiceDetail:InvoiceKey)
  ThisReport.SetFilter('DTL:CustNumber=ORD:CustNumber AND DTL:OrderNumber=ORD:OrderNumber')
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:InvoiceDetail.SetQuickScan(1,Propagate:OneMany)
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  SELF.SkipPreview = False
  SELF.Zoom = PageWidth
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  Previewer.Maximize = True
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Company.Close
    Relate:Customer.Close
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


ThisWindow.TakeCloseEvent PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  !Print second Detail band
  PRINT(RPT:Detail1)
  ReturnValue = PARENT.TakeCloseEvent()
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ExtendPrice = DTL:Price * DTL:QuantityOrdered
  GLOT:CustName = CLIP(CUS:FirstName) & '   ' & CLIP(CUS:LastName)
  GLOT:CustAddress = CLIP(CUS:Address1) & '    ' & CLIP(CUS:Address2)
  GLOT:CusCSZ = CLIP(CUS:City) & ',  ' & CUS:State & '     ' & CLIP(CUS:ZipCode)
  GLOT:ShipName = CLIP(ORD:ShipToName)
  GLOT:ShipAddress = CLIP(ORD:ShipAddress1) & '    ' & CLIP(ORD:ShipAddress2)
  GLOT:ShipCSZ = CLIP(ORD:ShipCity) & ',  ' & ORD:ShipState & '    ' & CLIP(ORD:ShipZip)
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

