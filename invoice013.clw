

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Report
!!! Report the Products File
!!! </summary>
PrintSelectedProduct PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
Progress:Thermometer BYTE                                  !
Process:View         VIEW(Product)
                       PROJECT(Product:Cost)
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

report               REPORT,AT(1000,896,6500,9125),PRE(RPT),FONT('Arial',10),THOUS
                       HEADER,AT(1000,458,6500,427)
                         STRING(' Product Information'),AT(21,10,6458,240),FONT('MS Serif',14,,FONT:bold+FONT:underline), |
  CENTER
                       END
detail                 DETAIL,AT(,,7500,1792),USE(?detail)
                         STRING('Product SKU:'),AT(219,10,896,188),TRN
                         IMAGE,AT(4417,10,1885,1771),USE(?Image1)
                         STRING(@s10),AT(1542,10,896,167),USE(Product:ProductSKU)
                         STRING(@s35),AT(1542,313,2375,167),USE(Product:Description)
                         STRING('Quantity In Stock:'),AT(219,615,1135,188),TRN
                         STRING('Re-order Quantity:'),AT(219,917,1188,188),USE(?String12),TRN
                         STRING('Unit Price:'),AT(219,1219,698,188),TRN
                         STRING(@n$10.2B),AT(1542,1208,771,208),USE(Product:Price)
                         STRING('Unit Cost:'),AT(219,1542),USE(?String14),TRN
                         STRING(@n$10.2B),AT(1542,1542),USE(Product:Cost)
                         STRING('Description:'),AT(219,313,802,188),TRN
                         STRING(@n6),AT(1542,917,563,167),USE(Product:ReorderQuantity),RIGHT
                         STRING(@n-7),AT(1542,615,573,167),USE(Product:QuantityInStock),RIGHT
                       END
                       FOOTER,AT(1000,10042,6500,240)
                         STRING(@pPage <<<#p),AT(5542,10,865,208),USE(?PageCount),FONT('Arial',10,COLOR:Black),PAGENO
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
  GlobalErrors.SetProcedureName('PrintSelectedProduct')
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
  SELF.DeferWindow = 0
  SELF.WaitCursor = 1
  IF SELF.OriginalRequest = ProcessRecord
    CLEAR(SELF.DeferWindow,1)
    ThisReport.AddRange(Product:ProductSKU)        ! Overrides any previous range
  END
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
  Report$?Image1{PROP:TEXT} = PRO:PictureFile
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

