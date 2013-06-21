

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Report
!!! Report the Products File
!!! </summary>
PrintPRO:KeyProductSKU PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
Progress:Thermometer BYTE                                  !
Process:View         VIEW(Product)
                       PROJECT(Product:Description)
                       PROJECT(Product:Price)
                       PROJECT(Product:ProductSKU)
                       PROJECT(Product:QuantityInStock)
                       PROJECT(Product:ReorderQuantity)
                     END
ProgressWindow       WINDOW('Report Progress...'),AT(,,142,59),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(45,42,46,15),USE(?Progress:Cancel),FONT(,,COLOR:Green,FONT:bold),LEFT, |
  ICON(ICON:NoPrint),FLAT,TIP('Cancel Printing')
                     END

report               REPORT,AT(500,1010,7500,9010),PRE(RPT),FONT('Arial',10,COLOR:Black),THOUS
                       HEADER,AT(500,458,7500,563)
                         STRING(' Products List'),AT(31,10,7458,240),FONT('MS Serif',14,,FONT:bold),CENTER
                         BOX,AT(10,271,7479,281),COLOR(COLOR:Black),ROUND
                         LINE,AT(1000,271,0,281),COLOR(COLOR:Black)
                         LINE,AT(3510,271,0,281),COLOR(COLOR:Black)
                         LINE,AT(4896,271,0,281),COLOR(COLOR:Black)
                         LINE,AT(6385,271,0,281),COLOR(COLOR:Black)
                         STRING('Product SKU'),AT(52,323,896,188),TRN
                         STRING('Description'),AT(1042,323,2438,188),TRN
                         STRING('Quantity In Stock'),AT(3552,323,1313,188),CENTER,TRN
                         STRING('Unit Price'),AT(6438,323,1010,188),CENTER,TRN
                         STRING('Re-order Quantity'),AT(4938,323,1417,188),USE(?String12),CENTER,TRN
                       END
detail                 DETAIL,AT(,,7500,281),USE(?detail)
                         LINE,AT(1000,0,0,281),COLOR(COLOR:Black)
                         LINE,AT(3510,0,0,281),COLOR(COLOR:Black)
                         LINE,AT(6385,0,0,281),COLOR(COLOR:Black)
                         STRING(@s10),AT(52,52,896,167),USE(Product:ProductSKU)
                         STRING(@s35),AT(1063,52,2375,167),USE(Product:Description)
                         STRING(@n$10.2B),AT(6427,52,1031,167),USE(Product:Price),DECIMAL(500)
                         STRING(@n6),AT(4948,52,802,167),USE(Product:ReorderQuantity),RIGHT
                         LINE,AT(4896,0,0,281),COLOR(COLOR:Black)
                         STRING(@n-7),AT(3531,52,750,167),USE(Product:QuantityInStock),RIGHT
                         LINE,AT(10,281,7490,0),COLOR(COLOR:Black)
                       END
                       FOOTER,AT(490,10042,7500,240)
                         STRING(@pPage <<<#p),AT(6479,10,865,208),USE(?PageCount),FONT('Arial',10),PAGENO
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
                     END

ProgressMgr          StepStringClass                       ! Progress Manager
Previewer            PrintPreviewClass                     ! Print Previewer

  CODE
? DEBUGHOOK(Product:Record)
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
  GlobalErrors.SetProcedureName('PrintPRO:KeyProductSKU')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:Product.SetOpenRelated()
  Relate:Product.Open                                      ! File Product used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  ProgressMgr.Init(ScrollSort:AllowAlpha+ScrollSort:AllowNumeric,ScrollBy:RunTime)
  ThisReport.Init(Process:View, Relate:Product, ?Progress:PctText, Progress:Thermometer, ProgressMgr, Product:ProductSKU)
  ThisReport.CaseSensitiveValue = FALSE
  ThisReport.AddSortOrder(Product:KeyProductSKU)
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:Product.SetQuickScan(1,Propagate:OneMany)
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
    Relate:Product.Close
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

