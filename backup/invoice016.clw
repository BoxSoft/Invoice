

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Report
!!! Report the Customers File
!!! </summary>
PrintCUS:StateKey PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
Progress:Thermometer BYTE                                  !
Process:View         VIEW(Customers)
                       PROJECT(CUS:City)
                       PROJECT(CUS:Company)
                       PROJECT(CUS:Extension)
                       PROJECT(CUS:FirstName)
                       PROJECT(CUS:LastName)
                       PROJECT(CUS:PhoneNumber)
                       PROJECT(CUS:State)
                       PROJECT(CUS:ZipCode)
                     END
ProgressWindow       WINDOW('Report Progress...'),AT(,,142,59),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(45,42,46,15),USE(?Progress:Cancel),FONT(,,COLOR:Green,FONT:bold),LEFT, |
  ICON(ICON:NoPrint),FLAT,TIP('Cancel Printing')
                     END

report               REPORT,AT(490,1167,7510,9104),PRE(RPT),FONT('MS Serif',8,COLOR:Black,FONT:regular),THOUS
                       HEADER,AT(500,500,7490,667)
                         STRING('Customers By State'),AT(21,10,7458,354),USE(?String16),FONT('MS Serif',18,,FONT:bold), |
  CENTER
                         BOX,AT(10,385,7490,292),USE(?Box1),COLOR(COLOR:Black),ROUND
                         STRING('Name'),AT(42,458,1813,167),FONT('MS Serif',10,,FONT:regular),TRN
                         STRING('Company'),AT(2052,458,1021,167),FONT('MS Serif',10,,FONT:regular),TRN
                         STRING('City'),AT(3271,458,1240,167),USE(?String11),FONT('MS Serif',10,,FONT:regular),TRN
                         STRING('Zipcode'),AT(4771,458,615,167),USE(?String15),FONT('MS Serif',10,,FONT:regular),TRN
                         STRING('Phone#'),AT(5729,458,729,167),USE(?String13),FONT('MS Serif',10,,FONT:regular),TRN
                         STRING('Extension'),AT(6688,458,698,167),USE(?String14),FONT('MS Serif',10),TRN
                       END
break1                 BREAK(CUS:State)
                         HEADER,AT(0,0,7510,354)
                           STRING(@s2),AT(63,73,594,240),USE(CUS:State),FONT('MS Serif',14,,FONT:bold+FONT:underline)
                         END
detail                   DETAIL,AT(10,10,7510,250),USE(?detail)
                           STRING(@K#####|-####KB),AT(4771,63),USE(CUS:ZipCode)
                           STRING(@s35),AT(42,63,1917,167),USE(GLOT:CustName)
                           STRING(@P<<<#PB),AT(6688,63,438,167),USE(CUS:Extension),RIGHT
                           STRING(@s25),AT(3271,63,1375,167),USE(CUS:City)
                           STRING(@s20),AT(2052,63,1115,167),USE(CUS:Company)
                           STRING(@P(###) ###-####PB),AT(5729,63,906,167),USE(CUS:PhoneNumber)
                         END
                       END
                       FOOTER,AT(469,10260,7521,271)
                         STRING(@pPage <<<#p),AT(6688,42,729,188),USE(?PageCount),FONT('MS Serif',10,,FONT:regular), |
  PAGENO
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
? DEBUGHOOK(Customers:Record)
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
  GlobalErrors.SetProcedureName('PrintCUS:StateKey')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  ProgressMgr.Init(ScrollSort:AllowAlpha+ScrollSort:AllowNumeric,ScrollBy:RunTime)
  ThisReport.Init(Process:View, Relate:Customers, ?Progress:PctText, Progress:Thermometer, ProgressMgr, CUS:State)
  ThisReport.CaseSensitiveValue = FALSE
  ThisReport.AddSortOrder(CUS:StateKey)
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:Customers.SetQuickScan(1,Propagate:OneMany)
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
    Relate:Customers.Close
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  GLOT:CustName = CLIP(CUS:FirstName) & '   ' & CLIP(CUS:LastName)
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

