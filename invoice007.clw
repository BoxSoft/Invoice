

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('MENUStyle.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Frame
!!! Clarion for Windows Wizard Application - with Wallpaper
!!! </summary>
Main PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
CurrentTab           STRING(80)                            !
SplashProcedureThread LONG
MenuStyleMgr MenuStyleManager
DisplayDayString STRING('Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday ')
DisplayDayText   STRING(9),DIM(7),OVER(DisplayDayString)
AppFrame             APPLICATION('Order Entry & Invoice Manager'),AT(,,437,310),FONT('MS Sans Serif',8),RESIZE, |
  MAXIMIZE,ALRT(F3Key),ALRT(F4Key),ALRT(F5Key),CENTER,ICON('ORDER.ICO'),MAX,HLP('~MainToolBar'), |
  STATUS(-1,80,120,45),SYSTEM,IMM
                       MENUBAR,USE(?MENUBAR1),FONT(,,COLOR:MENUTEXT)
                         MENU('&File'),USE(?MENU1)
                           ITEM('&Print Setup ...'),USE(?PrintSetup),MSG('Setup printer'),STD(STD:PrintSetup)
                           ITEM,USE(?SEPARATOR1),SEPARATOR
                           ITEM('E&xit'),USE(?Exit),MSG('Exit this application'),STD(STD:Close)
                         END
                         MENU('&Edit'),USE(?MENU2)
                           ITEM('Cu&t'),USE(?Cut),MSG('Remove item to Windows Clipboard'),STD(STD:Cut)
                           ITEM('&Copy'),USE(?Copy),MSG('Copy item to Windows Clipboard'),STD(STD:Copy)
                           ITEM('&Paste'),USE(?Paste),MSG('Paste contents of Windows Clipboard'),STD(STD:Paste)
                         END
                         MENU('&Browse'),USE(?MENU3)
                           ITEM('Customer''s Information'),USE(?BrowseCustomers),KEY(F3Key),MSG('Browse Customer''' & |
  's Information')
                           ITEM('All Customer''s Orders'),USE(?BrowseAllOrders),KEY(F4Key),MSG('Browse All Orders')
                           ITEM('Product''s Information'),USE(?BrowseProducts),KEY(F5Key),MSG('Browse Product''s I' & |
  'nformation')
                         END
                         MENU('&Reports'),USE(?ReportMenu),MSG('Report data')
                           ITEM('Print Invoice'),USE(?ReportsPrintInvoice),MSG('Print Customer''s Invoice')
                           ITEM('Print Mailing Labels'),USE(?ReportsPrintMailingLabels),MSG('Print mailing labels ' & |
  'for customer''s')
                           ITEM,USE(?SEPARATOR2),SEPARATOR
                           ITEM('Select CWRW Report'),USE(?ReportsSelectCWRWReport)
                           ITEM,USE(?SEPARATOR3),SEPARATOR
                           ITEM('Print Products Information'),USE(?PrintProduct:KeyProductSKU),MSG('Print ordered ' & |
  'by the Product:KeyProductSKU key')
                           ITEM('Print Customer''s Information'),USE(?PrintCustomer:StateKey),MSG('Print ordered b' & |
  'y the Customer:Statekey')
                         END
                         MENU('&Maintenance'),USE(?Maintenance)
                           ITEM('&Update Company File'),USE(?UpdateCompanyFile)
                         END
                         MENU('&Window'),USE(?MENU4),MSG('Create and Arrange windows'),STD(STD:WindowList)
                           ITEM('T&ile'),USE(?Tile),MSG('Make all open windows visible'),STD(STD:TileWindow)
                           ITEM('&Cascade'),USE(?Cascade),MSG('Stack all open windows'),STD(STD:CascadeWindow)
                           ITEM('&Arrange Icons'),USE(?Arrange),MSG('Align all window icons'),STD(STD:ArrangeIcons)
                         END
                         MENU('&Help'),USE(?MENU5),MSG('Windows Help')
                           ITEM('&Contents'),USE(?Helpindex),MSG('View the contents of the help file'),STD(STD:HelpIndex)
                           ITEM('&Search for Help On...'),USE(?HelpSearch),MSG('Search for help on a subject'),STD(STD:HelpSearch)
                           ITEM('&How to Use Help'),USE(?HelpOnHelp),MSG('How to use Windows Help'),STD(STD:HelpOnHelp)
                         END
                       END
                       TOOLBAR,AT(0,0,437,19),USE(?TOOLBAR1)
                         BUTTON,AT(279,2,16,14),USE(?Exit:2),ICON('EXITS.ICO'),FLAT,STD(STD:Close),TIP('Exit Application')
                         BUTTON,AT(19,2,16,14),USE(?OrdButton),ICON('BOOKS.ICO'),FLAT,TIP('Browse All Customer''s Orders')
                         BUTTON,AT(35,2,16,14),USE(?ProButton),ICON('FLOW04.ICO'),FLAT,TIP('Browse Products Information')
                         BUTTON,AT(3,2,16,14),USE(?CusButton),ICON('CUSTOMER.ICO'),FLAT,MSG('Browse Customer Information'), |
  TIP('Browse Customer Information')
                         BUTTON,AT(256,2,16,14),USE(?Toolbar:Help, Toolbar:Help),ICON('HELP.ICO'),DISABLE,FLAT,TIP('Get Help')
                         BUTTON,AT(240,2,16,14),USE(?Toolbar:History, Toolbar:History),ICON('DITTO.ICO'),DISABLE,FLAT, |
  TIP('Previous value')
                         BUTTON,AT(220,2,16,14),USE(?Toolbar:Delete, Toolbar:Delete),ICON('DELETE.ICO'),DISABLE,FLAT, |
  TIP('Delete This Record')
                         BUTTON,AT(204,2,16,14),USE(?Toolbar:Change, Toolbar:Change),ICON('EDIT.ICO'),DISABLE,FLAT, |
  TIP('Edit This Record')
                         BUTTON,AT(188,2,16,14),USE(?Toolbar:Insert, Toolbar:Insert),ICON('INSERT.ICO'),DISABLE,FLAT, |
  TIP('Insert a New Record')
                         BUTTON,AT(172,2,16,14),USE(?Toolbar:Select, Toolbar:Select),ICON('MARK.ICO'),DISABLE,FLAT, |
  TIP('Select This Record')
                         BUTTON,AT(152,2,16,14),USE(?Toolbar:Bottom, Toolbar:Bottom),ICON('VCRLAST.ICO'),DISABLE,FLAT, |
  TIP('Go to the Last Page')
                         BUTTON,AT(136,2,16,14),USE(?Toolbar:PageDown, Toolbar:PageDown),ICON('VCRNEXT.ICO'),DISABLE, |
  FLAT,TIP('Go to the Next Page')
                         BUTTON,AT(120,2,16,14),USE(?Toolbar:Down, Toolbar:Down),ICON('VCRDOWN.ICO'),DISABLE,FLAT,TIP('Go to the ' & |
  'Next Record')
                         BUTTON,AT(104,2,16,14),USE(?Toolbar:Locate, Toolbar:Locate),ICON('FIND.ICO'),DISABLE,FLAT, |
  TIP('Locate record')
                         BUTTON,AT(88,2,16,14),USE(?Toolbar:Up, Toolbar:Up),ICON('VCRUP.ICO'),DISABLE,FLAT,TIP('Go to the ' & |
  'Prior Record')
                         BUTTON,AT(72,2,16,14),USE(?Toolbar:PageUp, Toolbar:PageUp),ICON('VCRPRIOR.ICO'),DISABLE,FLAT, |
  TIP('Go to the Prior Page')
                         BUTTON,AT(56,2,16,14),USE(?Toolbar:Top, Toolbar:Top),ICON('VCRFIRST.ICO'),DISABLE,FLAT,TIP('Go to the ' & |
  'First Page')
                       END
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
Menu::MENUBAR1 ROUTINE                                     ! Code for menu items on ?MENUBAR1
Menu::MENU1 ROUTINE                                        ! Code for menu items on ?MENU1
Menu::MENU2 ROUTINE                                        ! Code for menu items on ?MENU2
Menu::MENU3 ROUTINE                                        ! Code for menu items on ?MENU3
  CASE ACCEPTED()
  OF ?BrowseCustomers
    START(BrowseCustomers, 050000)
  OF ?BrowseAllOrders
    START(BrowseAllOrders, 50000)
  OF ?BrowseProducts
    START(BrowseProducts, 50000)
  END
Menu::ReportMenu ROUTINE                                   ! Code for menu items on ?ReportMenu
  CASE ACCEPTED()
  OF ?ReportsPrintInvoice
    START(PrintInvoice, 50000)
  OF ?ReportsPrintMailingLabels
    START(PrintMailingLabels, 50000)
  OF ?ReportsSelectCWRWReport
    !
    IF RE.LoadReportLibrary('Invoice.txr') then   ! load report library
      RE.SetPreview()                             ! preview all pages
      RE.PrintReport(0)                           ! select report to preview/print
      RE.UnloadReportLibrary
    END
  OF ?PrintProduct:KeyProductSKU
    START(PrintProduct:KeyProductSKU, 050000)
  OF ?PrintCustomer:StateKey
    START(PrintCustomer:StateKey, 050000)
  END
Menu::Maintenance ROUTINE                                  ! Code for menu items on ?Maintenance
  CASE ACCEPTED()
  OF ?UpdateCompanyFile
    GlobalRequest = ChangeRecord
    UpdateCompany()
  END
Menu::MENU4 ROUTINE                                        ! Code for menu items on ?MENU4
Menu::MENU5 ROUTINE                                        ! Code for menu items on ?MENU5

ThisWindow.Ask PROCEDURE

  CODE
  IF NOT INRANGE(AppFrame{PROP:Timer},1,100)
    AppFrame{PROP:Timer} = 100
  END
    AppFrame{Prop:StatusText,3} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D4)
    AppFrame{PROP:StatusText,4} = FORMAT(CLOCK(),@T3)
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = 1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(AppFrame)                                      ! Open window
  Do DefineListboxStyle
  System{Prop:Icon}='~Order.ico'
  SELF.SetAlerts()
      AppFrame{PROP:TabBarVisible}  = False
      MenuStyleMgr.Init(?MENUBAR1)
      MenuStyleMgr.SuspendRefresh()
      MenuStyleMgr.SetThemeColors('XPLunaBlue')
      MenuStyleMgr.SetImageBar(False)
      MenuStyleMgr.ApplyTheme()
      MenuStyleMgr.Refresh(TRUE)
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF Status(Company) > 0
    Relate:Company.Close()  !Close file
  END
  GlobalErrors.SetProcedureName
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
    OF ?Toolbar:Help
    OROF ?Toolbar:History
    OROF ?Toolbar:Delete
    OROF ?Toolbar:Change
    OROF ?Toolbar:Insert
    OROF ?Toolbar:Select
    OROF ?Toolbar:Bottom
    OROF ?Toolbar:PageDown
    OROF ?Toolbar:Down
    OROF ?Toolbar:Locate
    OROF ?Toolbar:Up
    OROF ?Toolbar:PageUp
    OROF ?Toolbar:Top
      IF SYSTEM{PROP:Active} <> THREAD()
        POST(EVENT:Accepted,ACCEPTED(),SYSTEM{Prop:Active} )
        CYCLE
      END
    ELSE
      DO Menu::MENUBAR1                                    ! Process menu items on ?MENUBAR1 menu
      DO Menu::MENU1                                       ! Process menu items on ?MENU1 menu
      DO Menu::MENU2                                       ! Process menu items on ?MENU2 menu
      DO Menu::MENU3                                       ! Process menu items on ?MENU3 menu
      DO Menu::ReportMenu                                  ! Process menu items on ?ReportMenu menu
      DO Menu::Maintenance                                 ! Process menu items on ?Maintenance menu
      DO Menu::MENU4                                       ! Process menu items on ?MENU4 menu
      DO Menu::MENU5                                       ! Process menu items on ?MENU5 menu
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OrdButton
      START(BrowseAllOrders, 50000)
    OF ?ProButton
      START(BrowseProducts, 50000)
    OF ?CusButton
      START(BrowseCustomers, 50000)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
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
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
      SplashProcedureThread = START(SplashScreen)          ! Run the splash window procedure
    OF EVENT:Timer
      AppFrame{Prop:StatusText,3} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D4)
      AppFrame{PROP:StatusText,4} = FORMAT(CLOCK(),@T3)
    ELSE
      IF SplashProcedureThread
        IF EVENT() = Event:Accepted
          POST(Event:CloseWindow,,SplashProcedureThread)   ! Close the splash window
          SplashPRocedureThread = 0
        END
     END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

