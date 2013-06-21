

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABQUERY.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Customers File with "Filter Locator"
!!! </summary>
BrowseCustomers PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
LOC:NameLetter       STRING(1)                             !
LOC:CompanyLetter    STRING(1)                             !
LOC:ZipNum           STRING(2)                             !
LOC:State            STRING(2)                             !
LOC:FilterString     STRING(255)                           !
BRW1::View:Browse    VIEW(Customers)
                       PROJECT(CUS:FirstName)
                       PROJECT(CUS:MI)
                       PROJECT(CUS:LastName)
                       PROJECT(CUS:Company)
                       PROJECT(CUS:State)
                       PROJECT(CUS:ZipCode)
                       PROJECT(CUS:Address1)
                       PROJECT(CUS:Address2)
                       PROJECT(CUS:City)
                       PROJECT(CUS:PhoneNumber)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
CUS:FirstName          LIKE(CUS:FirstName)            !List box control field - type derived from field
CUS:MI                 LIKE(CUS:MI)                   !List box control field - type derived from field
CUS:LastName           LIKE(CUS:LastName)             !List box control field - type derived from field
CUS:Company            LIKE(CUS:Company)              !List box control field - type derived from field
CUS:State              LIKE(CUS:State)                !List box control field - type derived from field
CUS:ZipCode            LIKE(CUS:ZipCode)              !List box control field - type derived from field
CUS:Address1           LIKE(CUS:Address1)             !Browse hot field - type derived from field
CUS:Address2           LIKE(CUS:Address2)             !Browse hot field - type derived from field
CUS:City               LIKE(CUS:City)                 !Browse hot field - type derived from field
GLOT:CusCSZ            LIKE(GLOT:CusCSZ)              !Browse hot field - type derived from global data
CUS:PhoneNumber        LIKE(CUS:PhoneNumber)          !Browse hot field - type derived from field
LOC:FilterString       LIKE(LOC:FilterString)         !Browse hot field - type derived from local data
LOC:CompanyLetter      LIKE(LOC:CompanyLetter)        !Browse hot field - type derived from local data
LOC:ZipNum             LIKE(LOC:ZipNum)               !Browse hot field - type derived from local data
LOC:State              LIKE(LOC:State)                !Browse hot field - type derived from local data
LOC:NameLetter         LIKE(LOC:NameLetter)           !Browse hot field - type derived from local data
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse Customers'),AT(,,322,227),FONT('MS Sans Serif',8,COLOR:Black),RESIZE,CENTER, |
  ICON('CUSTOMER.ICO'),GRAY,IMM,MDI,HLP('~BrowseCustomers'),SYSTEM
                       SHEET,AT(3,1,318,223),USE(?CurrentTab)
                         TAB('FullName'),USE(?Tab:2)
                           STRING('Locator: Lastname'),AT(11,20,77,10),USE(?String7),FONT('MS Sans Serif',8,,FONT:bold),TRN
                           STRING(@s25),AT(92,20,104,10),USE(CUS:LastName),FONT(,,COLOR:Red,FONT:bold),TRN
                         END
                         TAB('Company'),USE(?Tab:3)
                           STRING('Locator: Company'),AT(13,20,73,10),USE(?String12),FONT(,,,FONT:bold),TRN
                           STRING(@s20),AT(90,20,83,10),USE(CUS:Company),FONT(,,COLOR:Red,FONT:bold),TRN
                         END
                         TAB('ZipCode'),USE(?Tab:4)
                           STRING('Locator:  Zipcode'),AT(11,20,71,10),USE(?String13),FONT(,,,FONT:bold),TRN
                           STRING(@K#####|-####KB),AT(87,20,51,10),USE(CUS:ZipCode),FONT(,,COLOR:Red,FONT:bold),TRN,TRN
                         END
                         TAB('State'),USE(?Tab:5)
                           STRING(@s2),AT(73,20,26,10),USE(CUS:State),FONT(,,COLOR:Red,FONT:bold),CENTER,TRN
                           STRING('Locator: State'),AT(12,20,62,10),USE(?String14),FONT(,,,FONT:bold),TRN
                         END
                       END
                       LIST,AT(12,33,301,124),USE(?Browse:1),VSCROLL,FORMAT('63L(2)|M~First Name~@s20@14C|M~MI' & |
  '~L(1)@s1@63L(2)|M~Last Name~@s25@71L(2)|M~Company~@s20@22C|M~State~L(1)@s2@80L(1)|M~' & |
  'Zip Code~L(2)@K#####|-####KB@'),FROM(Queue:Browse:1),IMM,MSG('Browsing Records')
                       BUTTON('&Select'),AT(193,113,28,14),USE(?Select:2),HIDE
                       BUTTON('&Insert'),AT(159,113,27,14),USE(?Insert:3),HIDE
                       BUTTON('&Change'),AT(93,114,25,14),USE(?Change:3),DEFAULT,HIDE
                       BUTTON('&Delete'),AT(253,113,30,14),USE(?Delete:3),HIDE
                       BUTTON,AT(132,112,15,14),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get Help')
                       GROUP,AT(6,167,177,52),USE(?Group1),BEVEL(2,-1),BOXED
                         STRING('Customer''s Address'),AT(10,169,150,10),USE(?String1),FONT('MS Sans Serif',10,COLOR:Navy, |
  FONT:bold+FONT:underline),LEFT(2)
                         STRING(@s35),AT(10,180,169,9),USE(CUS:Address1),FONT(,,COLOR:Teal,FONT:bold)
                         STRING(@s35),AT(10,188,167,9),USE(CUS:Address2),FONT(,,COLOR:Teal,FONT:bold)
                         STRING(@s40),AT(10,196,169,11),USE(GLOT:CusCSZ),FONT(,,COLOR:Teal,FONT:bold)
                         STRING('Phone Number:'),AT(10,206,64,10),USE(?PString),FONT(,,COLOR:Navy,FONT:bold)
                         STRING(@P(###) ###-####PB),AT(73,206,72,10),USE(CUS:PhoneNumber),FONT(,,COLOR:Teal,FONT:bold), |
  CENTER
                       END
                       BUTTON('&Print'),AT(187,168,42,14),USE(?Print),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Print sele' & |
  'cted customer info')
                       BUTTON('&Query'),AT(187,186,42,14),USE(?Query),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Query by example')
                       BUTTON('Orders'),AT(239,175,36,39),USE(?BOButton),FONT('MS Sans Serif',8,COLOR:Navy,FONT:bold), |
  ICON('NOTE14.ICO'),FLAT,MSG('Browse the selected Customer''s Orders'),SKIP,TIP('Browse the' & |
  ' selected Customer''s Orders')
                       BUTTON('Close'),AT(281,175,36,39),USE(?Close),FONT('MS Sans Serif',8,COLOR:Navy,FONT:bold), |
  ICON('EXITS.ICO'),FLAT,SKIP,TIP('Exit browse')
                       BUTTON('&Toolbox'),AT(187,204),USE(?Toolbox),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Floating toolbox')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
QBE6                 QueryFormClass                        ! QBE List Class. 
QBV6                 QueryFormVisual                       ! QBE Visual Class
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW1::Sort0:Locator  FilterLocatorClass                    ! Default Locator
BRW1::Sort1:Locator  FilterLocatorClass                    ! Conditional Locator - CHOICE(?CurrentTab) = 2
BRW1::Sort2:Locator  FilterLocatorClass                    ! Conditional Locator - CHOICE(?CurrentTab) = 3
BRW1::Sort3:Locator  FilterLocatorClass                    ! Conditional Locator - CHOICE(?CurrentTab) = 4
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
BRW1::Sort1:StepClass StepStringClass                      ! Conditional Step Manager - CHOICE(?CurrentTab) = 2
BRW1::Sort2:StepClass StepStringClass                      ! Conditional Step Manager - CHOICE(?CurrentTab) = 3
BRW1::Sort3:StepClass StepStringClass                      ! Conditional Step Manager - CHOICE(?CurrentTab) = 4
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


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
  GlobalErrors.SetProcedureName('BrowseCustomers')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?String7
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('GLOT:CusCSZ',GLOT:CusCSZ)                          ! Added by: BrowseBox(ABC)
  BIND('LOC:FilterString',LOC:FilterString)                ! Added by: BrowseBox(ABC)
  BIND('LOC:CompanyLetter',LOC:CompanyLetter)              ! Added by: BrowseBox(ABC)
  BIND('LOC:ZipNum',LOC:ZipNum)                            ! Added by: BrowseBox(ABC)
  BIND('LOC:State',LOC:State)                              ! Added by: BrowseBox(ABC)
  BIND('LOC:NameLetter',LOC:NameLetter)                    ! Added by: BrowseBox(ABC)
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Customers,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QBE6.Init(QBV6, INIMgr,'BrowseCustomers', GlobalErrors)
  QBE6.QkSupport = True
  QBE6.QkMenuIcon = 'QkQBE.ico'
  QBE6.QkIcon = 'QkLoad.ico'
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort1:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon CUS:Company for sort order 1
  BRW1.AddSortOrder(BRW1::Sort1:StepClass,CUS:KeyCompany)  ! Add the sort order for CUS:KeyCompany for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(?CUS:Company,CUS:Company,1,BRW1) ! Initialize the browse locator using ?CUS:Company using key: CUS:KeyCompany , CUS:Company
  BRW1::Sort2:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon CUS:ZipCode for sort order 2
  BRW1.AddSortOrder(BRW1::Sort2:StepClass,CUS:KeyZipCode)  ! Add the sort order for CUS:KeyZipCode for sort order 2
  BRW1.AddLocator(BRW1::Sort2:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort2:Locator.Init(?CUS:ZipCode,CUS:ZipCode,1,BRW1) ! Initialize the browse locator using ?CUS:ZipCode using key: CUS:KeyZipCode , CUS:ZipCode
  BRW1::Sort3:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon CUS:State for sort order 3
  BRW1.AddSortOrder(BRW1::Sort3:StepClass,CUS:StateKey)    ! Add the sort order for CUS:StateKey for sort order 3
  BRW1.AddLocator(BRW1::Sort3:Locator)                     ! Browse has a locator for sort order 3
  BRW1::Sort3:Locator.Init(?CUS:State,CUS:State,1,BRW1)    ! Initialize the browse locator using ?CUS:State using key: CUS:StateKey , CUS:State
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon CUS:LastName for sort order 4
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,CUS:KeyFullName) ! Add the sort order for CUS:KeyFullName for sort order 4
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 4
  BRW1::Sort0:Locator.Init(?CUS:LastName,CUS:LastName,1,BRW1) ! Initialize the browse locator using ?CUS:LastName using key: CUS:KeyFullName , CUS:LastName
  BRW1.AddField(CUS:FirstName,BRW1.Q.CUS:FirstName)        ! Field CUS:FirstName is a hot field or requires assignment from browse
  BRW1.AddField(CUS:MI,BRW1.Q.CUS:MI)                      ! Field CUS:MI is a hot field or requires assignment from browse
  BRW1.AddField(CUS:LastName,BRW1.Q.CUS:LastName)          ! Field CUS:LastName is a hot field or requires assignment from browse
  BRW1.AddField(CUS:Company,BRW1.Q.CUS:Company)            ! Field CUS:Company is a hot field or requires assignment from browse
  BRW1.AddField(CUS:State,BRW1.Q.CUS:State)                ! Field CUS:State is a hot field or requires assignment from browse
  BRW1.AddField(CUS:ZipCode,BRW1.Q.CUS:ZipCode)            ! Field CUS:ZipCode is a hot field or requires assignment from browse
  BRW1.AddField(CUS:Address1,BRW1.Q.CUS:Address1)          ! Field CUS:Address1 is a hot field or requires assignment from browse
  BRW1.AddField(CUS:Address2,BRW1.Q.CUS:Address2)          ! Field CUS:Address2 is a hot field or requires assignment from browse
  BRW1.AddField(CUS:City,BRW1.Q.CUS:City)                  ! Field CUS:City is a hot field or requires assignment from browse
  BRW1.AddField(GLOT:CusCSZ,BRW1.Q.GLOT:CusCSZ)            ! Field GLOT:CusCSZ is a hot field or requires assignment from browse
  BRW1.AddField(CUS:PhoneNumber,BRW1.Q.CUS:PhoneNumber)    ! Field CUS:PhoneNumber is a hot field or requires assignment from browse
  BRW1.AddField(LOC:FilterString,BRW1.Q.LOC:FilterString)  ! Field LOC:FilterString is a hot field or requires assignment from browse
  BRW1.AddField(LOC:CompanyLetter,BRW1.Q.LOC:CompanyLetter) ! Field LOC:CompanyLetter is a hot field or requires assignment from browse
  BRW1.AddField(LOC:ZipNum,BRW1.Q.LOC:ZipNum)              ! Field LOC:ZipNum is a hot field or requires assignment from browse
  BRW1.AddField(LOC:State,BRW1.Q.LOC:State)                ! Field LOC:State is a hot field or requires assignment from browse
  BRW1.AddField(LOC:NameLetter,BRW1.Q.LOC:NameLetter)      ! Field LOC:NameLetter is a hot field or requires assignment from browse
  QuickWindow{PROP:MinWidth} = 315                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 209                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  BRW1.QueryControl = ?Query
  BRW1.Query &= QBE6
  QBE6.AddItem('UPPER(CUS:FirstName)','FirstName','@s20',1)
  QBE6.AddItem('UPPER(CUS:LastName)','LastName','@s25',1)
  QBE6.AddItem('UPPER(CUS:Company)','Company','@s25',1)
  QBE6.AddItem('UPPER(CUS:ZipCode)','Zipcode','@s10',1)
  QBE6.AddItem('CUS:State','State','@s2',1)
  BRW1.AskProcedure = 1
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW1.ToolbarItem.HelpButton = ?Help
  BRW1.PrintProcedure = 2
  BRW1.PrintControl = ?Print
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
      UpdateCustomers
      PrintSelectedCustomer
    END
    ReturnValue = GlobalResponse
  END
  IF Number = 2
    ThisWindow.Reset(TRUE)
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
    OF ?BOButton
      ThisWindow.Update
      BrowseOrders()
      ThisWindow.Reset
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select:2
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END
  SELF.ToolControl = ?Toolbox


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?CurrentTab) = 2
    RETURN SELF.SetSort(1,Force)
  ELSIF CHOICE(?CurrentTab) = 3
    RETURN SELF.SetSort(2,Force)
  ELSIF CHOICE(?CurrentTab) = 4
    RETURN SELF.SetSort(3,Force)
  ELSE
    RETURN SELF.SetSort(4,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW1.SetQueueRecord PROCEDURE

  CODE
  GLOT:CusCSZ = CLIP(CUS:City) & ',  ' & CUS:State & '   ' & CLIP(CUS:ZipCode)
  PARENT.SetQueueRecord
  


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

