

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABQUERY.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Select a Products Record
!!! </summary>
SelectProducts PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(Product)
                       PROJECT(Product:Description)
                       PROJECT(Product:ProductSKU)
                       PROJECT(Product:Price)
                       PROJECT(Product:QuantityInStock)
                       PROJECT(Product:ProductID)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
Product:Description    LIKE(Product:Description)      !List box control field - type derived from field
Product:ProductSKU     LIKE(Product:ProductSKU)       !List box control field - type derived from field
Product:Price          LIKE(Product:Price)            !List box control field - type derived from field
Product:QuantityInStock LIKE(Product:QuantityInStock) !List box control field - type derived from field
Product:ProductID      LIKE(Product:ProductID)        !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Select a Product'),AT(,,236,134),FONT('MS Sans Serif',8),RESIZE,CENTER,ICON('ORCHID.ICO'), |
  GRAY,IMM,MDI,HLP('~SelectaProduct'),SYSTEM
                       SHEET,AT(2,0,231,132),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                           STRING(@s35),AT(46,116,76,10),USE(Product:Description),FONT(,,COLOR:Red,FONT:bold),TRN
                         END
                       END
                       LIST,AT(6,6,221,102),USE(?Browse:1),HVSCROLL,FORMAT('80L(1)|M~Description~@s35@48L(2)|M' & |
  '~Product SKU~L(0)@s10@32D(16)|M~Price~L(2)@n$10.2B@59D(20)|M~Quantity In Stock~L(2)@n-10.2B@'), |
  FROM(Queue:Browse:1),IMM,MSG('Browsing Records')
                       BUTTON('&Select'),AT(41,19,25,13),USE(?Select:2),FONT('MS Serif',8,COLOR:Black),HIDE,MSG('Select a P' & |
  'roduct from list'),TIP('Select a Product from list')
                       STRING('Locator:'),AT(7,114,39,12),USE(?String1),FONT('MS Serif',10,COLOR:Black,FONT:bold), |
  TRN
                       BUTTON,AT(45,43,13,13),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON('&Query'),AT(149,111,38,18),USE(?Query),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Query-By-Example')
                       BUTTON,AT(201,111,23,18),USE(?Close),ICON('EXITS.ICO'),FLAT,MSG('Exit Browse'),SKIP,TIP('Exit Brows' & |
  'e and cancel selection')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
QBE5                 QueryFormClass                        ! QBE List Class. 
QBV5                 QueryFormVisual                       ! QBE Visual Class
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  IncrementalLocatorClass               ! Default Locator
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


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
  GlobalErrors.SetProcedureName('SelectProducts')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Product:Description
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Product.SetOpenRelated()
  Relate:Product.Open                                      ! File Product used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Product,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QBE5.Init(QBV5, INIMgr,'SelectProducts', GlobalErrors)
  QBE5.QkSupport = True
  QBE5.QkMenuIcon = 'QkQBE.ico'
  QBE5.QkIcon = 'QkLoad.ico'
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon Product:Description for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,Product:KeyDescription) ! Add the sort order for Product:KeyDescription for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(?Product:Description,Product:Description,1,BRW1) ! Initialize the browse locator using ?Product:Description using key: Product:KeyDescription , Product:Description
  BRW1.AddField(Product:Description,BRW1.Q.Product:Description) ! Field Product:Description is a hot field or requires assignment from browse
  BRW1.AddField(Product:ProductSKU,BRW1.Q.Product:ProductSKU) ! Field Product:ProductSKU is a hot field or requires assignment from browse
  BRW1.AddField(Product:Price,BRW1.Q.Product:Price)        ! Field Product:Price is a hot field or requires assignment from browse
  BRW1.AddField(Product:QuantityInStock,BRW1.Q.Product:QuantityInStock) ! Field Product:QuantityInStock is a hot field or requires assignment from browse
  BRW1.AddField(Product:ProductID,BRW1.Q.Product:ProductID) ! Field Product:ProductID is a hot field or requires assignment from browse
  QuickWindow{PROP:MinWidth} = 236                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 139                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('SelectProducts',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.QueryControl = ?Query
  BRW1.Query &= QBE5
  QBE5.AddItem('UPPER(Product:Description)','Product Description','@s30',1)
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW1.ToolbarItem.HelpButton = ?Help
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
  IF SELF.Opened
    INIMgr.Update('SelectProducts',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select:2
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

