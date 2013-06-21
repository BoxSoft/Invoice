

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABQUERY.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse Products File (Edit-In-Place and calls Update form)
!!! </summary>
BrowseProducts PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(Product)
                       PROJECT(Product:Description)
                       PROJECT(Product:ProductSKU)
                       PROJECT(Product:Price)
                       PROJECT(Product:QuantityInStock)
                       PROJECT(Product:PictureFile)
                       PROJECT(Product:ProductID)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
Product:Description    LIKE(Product:Description)      !List box control field - type derived from field
Product:ProductSKU     LIKE(Product:ProductSKU)       !List box control field - type derived from field
Product:Price          LIKE(Product:Price)            !List box control field - type derived from field
Product:QuantityInStock LIKE(Product:QuantityInStock) !List box control field - type derived from field
Product:PictureFile    LIKE(Product:PictureFile)      !Browse hot field - type derived from field
Product:ProductID      LIKE(Product:ProductID)        !Primary key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse Products '),AT(,,403,180),FONT('MS Sans Serif',8),RESIZE,HVSCROLL,CENTER,ICON('FLOW04.ICO'), |
  GRAY,IMM,MDI,HLP('~BrowseProducts'),PALETTE(254),SYSTEM
                       SHEET,AT(4,0,395,177),USE(?CurrentTab)
                         TAB('Description')
                           STRING('Filter Locator: Description'),AT(9,15,103,11),USE(?String1),FONT('MS Sans Serif',8, |
  COLOR:Black,FONT:bold),TRN
                           STRING(@s35),AT(119,15,113,10),USE(Product:Description),FONT(,,COLOR:Maroon,FONT:bold),TRN
                         END
                         TAB('ProductSKU')
                           STRING('Incremental Locator: Product SKU'),AT(11,15,137,10),USE(?String4),FONT(,,,FONT:bold),TRN
                           STRING(@s10),AT(149,15,49,10),USE(Product:ProductSKU),FONT(,,COLOR:Maroon,FONT:bold),TRN
                         END
                       END
                       LIST,AT(10,26,250,132),USE(?Browse:1),VSCROLL,FORMAT('93L(2)|M~Description~@s35@45L(3)|' & |
  'M~Product SKU~L(1)@s10@37D(16)|M~Price~L(2)@n$10.2B@58D(30)|M~Quantity In Stock~L(1)@n-10.2B@'), |
  FROM(Queue:Browse:1),IMM,MSG('Browsing Records')
                       BUTTON('&Print'),AT(9,161,39,12),USE(?Print),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Print sele' & |
  'cted product information')
                       BUTTON('&Query'),AT(119,161,39,12),USE(?Query),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP,TIP('Query by example')
                       BUTTON('&Toolbox'),AT(221,161,39,12),USE(?Toolbox),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP, |
  TIP('Floating toolbox')
                       STRING('Double-Click:- Edit-In-Place (Price & Quantity); Toolbar buttons:- Update form.'), |
  AT(95,0,303,12),USE(?String3),FONT(,,COLOR:Maroon,FONT:bold),CENTER
                       IMAGE,AT(267,26,123,134),USE(?Image1)
                       BUTTON('&Insert'),AT(145,125,28,12),USE(?Insert),HIDE
                       BUTTON('&Change'),AT(187,125,28,12),USE(?Change),HIDE
                       BUTTON('&Delete'),AT(21,118,28,12),USE(?Delete),HIDE
                       BUTTON,AT(229,124,13,12),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get Help')
                       BUTTON,AT(371,161,20,12),USE(?Close),ICON('EXITS.ICO'),FLAT,MSG('Exit Browse'),SKIP,TIP('Exit Browse')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Reset                  PROCEDURE(BYTE Force=0),DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
QBE6                 QueryFormClass                        ! QBE List Class. 
QBV6                 QueryFormVisual                       ! QBE Visual Class
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Ask                    PROCEDURE(BYTE Request),BYTE,PROC,DERIVED
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
TakeKey                PROCEDURE(),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  FilterLocatorClass                    ! Default Locator
BRW1::Sort1:Locator  IncrementalLocatorClass               ! Conditional Locator - CHOICE(?CurrentTab) = 2
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
BRW1::Sort1:StepClass StepStringClass                      ! Conditional Step Manager - CHOICE(?CurrentTab) = 2
BRW1::EIPManager     BrowseEIPManager                      ! Browse EIP Manager for Browse using ?Browse:1
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
  GlobalErrors.SetProcedureName('BrowseProducts')
  !Set default update action
   BRW1.AskProcedure = 1
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?String1
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
  QBE6.Init(QBV6, INIMgr,'BrowseProducts', GlobalErrors)
  QBE6.QkSupport = True
  QBE6.QkMenuIcon = 'QkQBE.ico'
  QBE6.QkIcon = 'QkLoad.ico'
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort1:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon Product:ProductSKU for sort order 1
  BRW1.AddSortOrder(BRW1::Sort1:StepClass,Product:KeyProductSKU) ! Add the sort order for Product:KeyProductSKU for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(?Product:ProductSKU,Product:ProductSKU,1,BRW1) ! Initialize the browse locator using ?Product:ProductSKU using key: Product:KeyProductSKU , Product:ProductSKU
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon Product:Description for sort order 2
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,Product:KeyDescription) ! Add the sort order for Product:KeyDescription for sort order 2
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort0:Locator.Init(?Product:Description,Product:Description,1,BRW1) ! Initialize the browse locator using ?Product:Description using key: Product:KeyDescription , Product:Description
  BRW1.AddField(Product:Description,BRW1.Q.Product:Description) ! Field Product:Description is a hot field or requires assignment from browse
  BRW1.AddField(Product:ProductSKU,BRW1.Q.Product:ProductSKU) ! Field Product:ProductSKU is a hot field or requires assignment from browse
  BRW1.AddField(Product:Price,BRW1.Q.Product:Price)        ! Field Product:Price is a hot field or requires assignment from browse
  BRW1.AddField(Product:QuantityInStock,BRW1.Q.Product:QuantityInStock) ! Field Product:QuantityInStock is a hot field or requires assignment from browse
  BRW1.AddField(Product:PictureFile,BRW1.Q.Product:PictureFile) ! Field Product:PictureFile is a hot field or requires assignment from browse
  BRW1.AddField(Product:ProductID,BRW1.Q.Product:ProductID) ! Field Product:ProductID is a hot field or requires assignment from browse
  QuickWindow{PROP:MinWidth} = 403                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 180                        ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  BRW1.QueryControl = ?Query
  BRW1.UpdateQuery(QBE6,1)
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
    Relate:Product.Close
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Reset PROCEDURE(BYTE Force=0)

  CODE
  SELF.ForcedReset += Force
  IF QuickWindow{Prop:AcceptAll} THEN RETURN.
  !Display image
  ?Image1{PROP:TEXT} = Products.Record.PictureFile
  ResizeImage(?Image1,267,19,123,134)
  PARENT.Reset(Force)


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    EXECUTE Number
      UpdateProducts
      PrintSelectedProduct
    END
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


BRW1.Ask PROCEDURE(BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Ask(Request)
  !Set action back after edit-in-place
  BRW1.AskProcedure = 1
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.EIP &= BRW1::EIPManager                             ! Set the EIP manager
  SELF.AddEditControl(,2) ! Product:ProductSKU Disable
  SELF.AddEditControl(,1) ! Product:Description Disable
  SELF.DeleteAction = EIPAction:Always
  SELF.ArrowAction = EIPAction:Default+EIPAction:Remain+EIPAction:RetainColumn
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END
  SELF.ToolControl = ?Toolbox


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?CurrentTab) = 2
    RETURN SELF.SetSort(1,Force)
  ELSE
    RETURN SELF.SetSort(2,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


BRW1.TakeKey PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  !Set update action for edit-in-place
  IF RECORDS(SELF.ListQueue) AND KEYCODE() = MouseLeft2
    BRW1.AskProcedure = 0
  END
  ReturnValue = PARENT.TakeKey()
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

