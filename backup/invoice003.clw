

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse Orders using a relation tree
!!! </summary>
BrowseAllOrders PROCEDURE 

LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
DisplayString        STRING(255)                           !
REL1::Toolbar        CLASS(ToolbarReltreeClass)
TakeEvent            PROCEDURE(<*LONG VCR>,WindowManager WM),VIRTUAL
  END
REL1::SaveLevel      BYTE,AUTO
REL1::Action         LONG,AUTO
Queue:RelTree        QUEUE,PRE()                           ! Browsing Queue
REL1::Display        STRING(200)                           ! Queue display string
REL1::NormalFG       LONG
REL1::NormalBG       LONG
REL1::SelectedFG     LONG
REL1::SelectedBG     LONG
REL1::Icon           SHORT
REL1::Level          LONG                                  ! Record level in the tree
REL1::Loaded         SHORT                                 ! Inferior level is loaded
REL1::Position       STRING(1024)                          ! Record POSITION in VIEW
                END
REL1::LoadedQueue    QUEUE,PRE()                           ! Status Queue
REL1::LoadedLevel    LONG                                  ! Record level
REL1::LoadedPosition STRING(1024)                          ! Record POSITION in VIEW
               END
REL1::CurrentLevel   LONG                                  ! Current loaded level
REL1::CurrentChoice  LONG                                  ! Current record
REL1::NewItemLevel   LONG                                  ! Level for a new item
REL1::NewItemPosition STRING(1024)                         ! POSITION of a new record
REL1::LoadAll        LONG
window               WINDOW('Browse Customers Orders In Tree View'),AT(,,312,193),FONT('MS Sans Serif',8,COLOR:Black, |
  FONT:bold),RESIZE,CENTER,ICON('NOTE14.ICO'),GRAY,IMM,MDI,HLP('~BrowseCustomersOrdersInTreeView'), |
  PALETTE(256),SYSTEM
                       LIST,AT(3,17,305,156),USE(?RelTree),FONT('Times New Roman',10,,FONT:bold),VSCROLL,COLOR(,COLOR:White, |
  COLOR:Blue),FORMAT('800L*ITS(70)@s200@'),FROM(Queue:RelTree),MSG('Ctrl+-> Expand bran' & |
  'ch,  Ctrl+<<- Contract branch')
                       BUTTON('Insert'),AT(4,177,48,15),USE(?Insert),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON('Insert.ico'), |
  FLAT,SKIP,TIP('Insert a record')
                       BUTTON('Change'),AT(55,177,48,15),USE(?Change),FONT(,8,COLOR:Green,FONT:bold),LEFT,ICON('Edit.ico'), |
  FLAT,SKIP,TIP('Edit a record')
                       BUTTON('Delete'),AT(106,177,48,15),USE(?Delete),FONT(,,COLOR:Green,FONT:bold),LEFT,ICON('Delete.ico'), |
  FLAT,SKIP,TIP('Delete a record')
                       STRING('Backordered Item'),AT(104,2,89,12),USE(?String1),FONT('MS Sans Serif',10,COLOR:Red, |
  FONT:bold),CENTER
                       BUTTON('&Expand All'),AT(161,177,55,15),USE(?Expand),FONT(,,COLOR:Navy,FONT:bold),FLAT,SKIP, |
  TIP('Expand All Branches')
                       BUTTON('Co&ntract All'),AT(218,177,55,15),USE(?Contract),FONT(,,COLOR:Navy,FONT:bold),FLAT, |
  SKIP,TIP('Contract All Branches')
                       BUTTON,AT(274,143,11,12),USE(?Help),ICON(ICON:Help),HIDE,STD(STD:Help),TIP('Get help')
                       BUTTON,AT(290,177,19,15),USE(?Close),ICON('EXITS.ICO'),FLAT,SKIP,TIP('Exits Browse')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection       PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
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
REL1::NextParent ROUTINE
  GET(Queue:RelTree,CHOICE(?RelTree))
  IF ABS(REL1::Level) > 1
    REL1::SaveLevel = ABS(REL1::Level)-1
    DO REL1::NextSavedLevel
  END

REL1::PreviousParent ROUTINE
  GET(Queue:RelTree,CHOICE(?RelTree))
  IF ABS(REL1::Level) > 1
    REL1::SaveLevel = ABS(REL1::Level)-1
    DO REL1::PreviousSavedLevel
  END

REL1::NextLevel ROUTINE
  GET(Queue:RelTree,CHOICE(?RelTree))
  REL1::SaveLevel = ABS(REL1::Level)
  DO REL1::NextSavedLevel

REL1::NextSavedLevel ROUTINE
  DATA
SavePointer LONG,AUTO
  CODE
  LOOP
    LOOP
      GET(Queue:RelTree,POINTER(Queue:RelTree)+1)
      IF ERRORCODE()
        EXIT                ! Unable to find another record on similar level
      END
    WHILE ABS(REL1::Level) > REL1::SaveLevel
    IF ABS(REL1::Level) = REL1::SaveLevel
      SELECT(?RelTree,POINTER(Queue:RelTree))
      EXIT
    END
    SavePointer = POINTER(Queue:RelTree)
    ?RelTree{PROPLIST:MouseDownRow} = SavePointer
    DO REL1::LoadLevel
    GET(Queue:RelTree,SavePointer)
  END

REL1::PreviousSavedLevel ROUTINE
  DATA
SaveRecords LONG,AUTO
SavePointer LONG,AUTO
  CODE
  LOOP
    LOOP
      GET(Queue:RelTree,POINTER(Queue:RelTree)-1)
      IF ERRORCODE()
        EXIT                ! Unable to find another record on similar level
      END
    WHILE ABS(REL1::Level) > REL1::SaveLevel
    IF ABS(REL1::Level) = REL1::SaveLevel
      SELECT(?RelTree,POINTER(Queue:RelTree))
      EXIT
    END
    SavePointer = POINTER(Queue:RelTree)
    SaveRecords = RECORDS(Queue:RelTree)
    ?RelTree{PROPLIST:MouseDownRow} = SavePointer
    DO REL1::LoadLevel
    IF RECORDS(Queue:RelTree) <> SaveRecords
      SavePointer += 1 + RECORDS(Queue:RelTree) - SaveRecords
    END
    GET(Queue:RelTree,SavePointer)
  END

REL1::PreviousLevel ROUTINE
  GET(Queue:RelTree,CHOICE(?RelTree))
  REL1::SaveLevel = ABS(REL1::Level)
  DO REL1::PreviousSavedLevel

REL1::NextRecord ROUTINE
  DO REL1::LoadLevel
  IF CHOICE(?RelTree) < RECORDS(Queue:RelTree)
    SELECT(?RelTree,CHOICE(?RelTree)+1)
  END

REL1::PreviousRecord ROUTINE
  DATA
SaveRecords LONG,AUTO
SavePointer LONG,AUTO
  CODE
  SavePointer = CHOICE(?RelTree)-1
  LOOP
    SaveRecords = RECORDS(Queue:RelTree)
    ?RelTree{PROPLIST:MouseDownRow} = SavePointer
    DO REL1::LoadLevel
    IF RECORDS(Queue:RelTree) = SaveRecords
      BREAK
    END
    SavePointer += RECORDS(Queue:RelTree) - SaveRecords
  END
  SELECT(?RelTree,SavePointer)

REL1::AssignButtons ROUTINE
  REL1::Toolbar.DeleteButton = ?Delete
  REL1::Toolbar.InsertButton = ?Insert
  REL1::Toolbar.ChangeButton = ?Change
  REL1::Toolbar.HelpButton = ?Help
  Toolbar.SetTarget(?RelTree)

!---------------------------------------------------------------------------
REL1::Load:Customers ROUTINE
!|
!| This routine is used to load the base level of the RelationTree.
!|
!| First, the Title line is added.
!|
!| Next, each record of the file Customers is read. If the record is not filtered,
!| then the following happens:
!|
!|   First, the queue REL1::LoadedQueue is searched, to see if the tree branch
!|   corresponding to the record is "loaded", that is, if the branch is currently opened.
!|
!|   If the branch is open, then the records for that branch are read from the file
!|   Orders. This is done in the routine REL1::Load:Orders.
!|
!|   If the branch is not open, then the RelationTree looks for a single record from
!|   Orders, to see if any child records are available. If they are, the
!|   branch can be expanded, so REL1::Level gets a -1. This
!|   value is used by the list box to display a "closed" box next to the entry.
!|
!|   Finally, the queue record that corresponds to the Customers record read is
!|   formatted and added to the queue Queue:RelTree. This is done in the routine
!|   REL1::Format:Customers.
!|
  REL1::Display = 'CUSTOMERS'''' ORDERS'
  REL1::Loaded = 0
  REL1::Position = ''
  REL1::Level = 0
  REL1::Icon = 1
  REL1::NormalFG = -1
  REL1::NormalBG = -1
  REL1::SelectedFG = -1
  REL1::SelectedBG = -1
  ADD(Queue:RelTree)
  Access:Customers.UseFile
  SET(CUS:KeyFullName)
  LOOP
    IF Access:Customers.Next() NOT= Level:Benign
      IF Access:Customers.GetEOF()
        BREAK
      ELSE
        POST(EVENT:CloseWindow)
        EXIT
      END
    END
    REL1::Loaded = 0
    REL1::Position = POSITION(CUS:KeyFullName)
    REL1::Level = 1
    REL1::LoadedLevel = ABS(REL1::Level)
    REL1::LoadedPosition = REL1::Position
    GET(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
    IF ERRORCODE() AND NOT REL1::LoadAll
      ORD:CustNumber = CUS:CustNumber
      CLEAR(ORD:OrderNumber,0)
      Access:Orders.UseFile
      SET(ORD:KeyCustOrderNumber,ORD:KeyCustOrderNumber)
      LOOP
        IF Access:Orders.Next()
          IF Access:Orders.GetEOF()
            BREAK
          ELSE
            POST(EVENT:CloseWindow)
            EXIT
          END
        END
        IF UPPER(ORD:CustNumber) <> UPPER(CUS:CustNumber) THEN BREAK.
        REL1::Level = -1
        BREAK
      END
      DO REL1::Format:Customers
      ADD(Queue:RelTree,POINTER(Queue:RelTree)+1)
    ELSE
      IF REL1::LoadAll
        ADD(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
      END
      REL1::Level = 1
      REL1::Loaded = True
      DO REL1::Format:Customers
      ADD(Queue:RelTree,POINTER(Queue:RelTree)+1)
      DO REL1::Load:Orders
    END
  END

!---------------------------------------------------------------------------
REL1::Format:Customers ROUTINE
!|
!| This routine formats a line of the display queue Queue:RelTree to display the
!| contents of a record of Customers.
!|
!| First, the variable DisplayString is assigned the formatted value.
!|
!| Next, the queue variable REL1::Display is assigned the value in
!| DisplayString. It is possible for the display string to be reformatted in
!| the EMBED point "Relation Tree, Before Setting Display on Primary File".
!|
!| Next, any coloring done to the line is performed.
!|
!| Next, any icon assigments are made.
!|
  DisplayString = CLIP(CUS:FirstName) & ' ' & CLIP(CUS:LastName) &'  '& FORMAT(CUS:CustNumber,@P(#######)P)
  REL1::Display = DisplayString
  REL1::NormalFG = 128
  REL1::NormalBG = -1
  REL1::SelectedFG = -1
  REL1::SelectedBG = -1
  REL1::Icon = 2

!---------------------------------------------------------------------------
REL1::LoadLevel ROUTINE
!|
!| This routine is used to load a single level of the RelationTree.
!|
!| First, we see where the load comes from. Since the alert-key handling sets
!| ?RelTree{PropList:MouseDownRow} to CHOICE, we can rely on this property
!| containing the correct selection.
!|
!| Next, we retrieve the Queue:RelTree record that corresponds to the requested
!| load row. If the requested load row is already loaded, we don't have to do
!| anything. If the requested row is not loaded...
!|
!|   First, we set REL1::Level to a positive value for the selected
!|   row and put that record back into the queue Queue:RelTree. The presence of
!|   records with a greater Level below this record in the queue tells the
!|   listbox that the level is opened.
!|
!|   Next, we add a record the the queue REL1::LoadedQueue. This queue
!|   is used to rebuild the display when necessary.
!|
!|   Next, we retrieve the file record that corresponds to the requested load row.
!|
!|   Finally, we reformat the Queue:RelTree entry. This allows for any changes in icon
!|   and colors based on conditional usage.
!|
  REL1::CurrentChoice = ?RelTree{PROPLIST:MouseDownRow}
  GET(Queue:RelTree,REL1::CurrentChoice)
  IF NOT REL1::Loaded
    REL1::Level = ABS(REL1::Level)
    PUT(Queue:RelTree)
    REL1::Loaded = True
    REL1::LoadedLevel = ABS(REL1::Level)
    REL1::LoadedPosition = REL1::Position
    ADD(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
    EXECUTE(ABS(REL1::Level))
      BEGIN
        REGET(CUS:KeyFullName,REL1::Position)
        DO REL1::Format:Customers
      END
      BEGIN
        REGET(Orders,REL1::Position)
        DO REL1::Format:Orders
      END
      BEGIN
        REGET(Detail,REL1::Position)
        DO REL1::Format:Detail
      END
    END
    PUT(Queue:RelTree)
    EXECUTE(ABS(REL1::Level))
      DO REL1::Load:Orders
      DO REL1::Load:Detail
    END
  END
!---------------------------------------------------------------------------
REL1::UnloadLevel ROUTINE
!|
!| This routine is used to unload a level of the RelationTree.
!|
!| First, we see where the unload comes from. Since the alert-key handling sets
!| ?RelTree{PropList:MouseDownRow} to CHOICE, we can rely on this property
!| containing the correct selection.
!|
!| Next, we retrieve the Queue:RelTree record that corresponds to the requested
!| unload row. If the requested load row isn't loaded, we don't have to do
!| anything. If the requested row is loaded...
!|
!|   First, we set REL1::Level to a negative value for the selected
!|   row and put that record back into the queue Queue:RelTree. Since there
!|   won't be any records at lower levels, we use the negative value to signal
!|   the listbox that the level is closed, but children exist.
!|
!|   Next, we retrieve the record the the queue REL1::LoadedQueue that
!|   corresponds to the unloaded level. This queue record is then deleted.
!|
!|   Next, we retrieve the file record that corresponds to the requested load row.
!|
!|   Next, we reformat the Queue:RelTree entry. This allows for any changes in icon
!|   and colors based on conditional usage.
!|
!|   Finally, we run through all of the Queue:RelTree entries for branches below the
!|   unloaded level, and delete these entries.
!|
  REL1::CurrentChoice = ?RelTree{PROPLIST:MouseDownRow}
  GET(Queue:RelTree,REL1::CurrentChoice)
  IF REL1::Loaded
    REL1::Level = -ABS(REL1::Level)
    PUT(Queue:RelTree)
    REL1::Loaded = False
    REL1::LoadedLevel = ABS(REL1::Level)
    REL1::LoadedPosition = REL1::Position
    GET(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
    IF NOT ERRORCODE()
      DELETE(REL1::LoadedQueue)
    END
    EXECUTE(ABS(REL1::Level))
      BEGIN
        REGET(CUS:KeyFullName,REL1::Position)
        DO REL1::Format:Customers
      END
      BEGIN
        REGET(Orders,REL1::Position)
        DO REL1::Format:Orders
      END
      BEGIN
        REGET(Detail,REL1::Position)
        DO REL1::Format:Detail
      END
    END
    PUT(Queue:RelTree)
    REL1::CurrentLevel = ABS(REL1::Level)
    REL1::CurrentChoice += 1
    LOOP
      GET(Queue:RelTree,REL1::CurrentChoice)
      IF ERRORCODE() THEN BREAK.
      IF ABS(REL1::Level) <= REL1::CurrentLevel THEN BREAK.
      DELETE(Queue:RelTree)
    END
  END
!---------------------------------------------------------------------------
REL1::Load:Orders ROUTINE
!|
!| This routine is used to load the base level of the RelationTree.
!|
!| For each record of the file Orders is read. If the record is not filtered,
!| then the following happens:
!|
!|   First, the queue REL1::LoadedQueue is searched, to see if the tree branch
!|   corresponding to the record is "loaded", that is, if the branch is currently opened.
!|
!|   If the branch is open, then the records for that branch are read from the file
!|   Detail. This is done in the routine REL1::Load:Detail.
!|
!|   If the branch is not open, then the RelationTree looks for a single record from
!|   Detail, to see if any child records are available. If they are, the
!|   branch can be expanded, so REL1::Level gets a -2. This
!|   value is used by the list box to display a "closed" box next to the entry.
!|
!|   Finally, the queue record that corresponds to the Orders record read is
!|   formatted and added to the queue Queue:RelTree. This is done in the routine
!|   REL1::Format:Orders.
!|
  ORD:CustNumber = CUS:CustNumber
  CLEAR(ORD:OrderNumber)
  Access:Orders.UseFile
  SET(ORD:KeyCustOrderNumber,ORD:KeyCustOrderNumber)
  LOOP
    IF Access:Orders.Next()
      IF Access:Orders.GetEOF()
        BREAK
      ELSE
        POST(EVENT:CloseWindow)
        EXIT
      END
    END
    IF ORD:CustNumber <> CUS:CustNumber THEN BREAK.
    REL1::Loaded = 0
    REL1::Position = POSITION(Orders)
    REL1::Level = 2
    REL1::LoadedLevel = ABS(REL1::Level)
    REL1::LoadedPosition = REL1::Position
    GET(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
    IF ERRORCODE() AND NOT REL1::LoadAll
      DTL:CustNumber = ORD:CustNumber
      DTL:OrderNumber = ORD:OrderNumber
      CLEAR(DTL:LineNumber,0)
      Access:Detail.UseFile
      SET(DTL:KeyDetails,DTL:KeyDetails)
      LOOP
        IF Access:Detail.Next()
          IF Access:Detail.GetEOF()
            BREAK
          ELSE
            POST(EVENT:CloseWindow)
            EXIT
          END
        END
        IF UPPER(DTL:CustNumber) <> UPPER(ORD:CustNumber) THEN BREAK.
        IF UPPER(DTL:OrderNumber) <> UPPER(ORD:OrderNumber) THEN BREAK.
        REL1::Level = -2
        BREAK
      END
      DO REL1::Format:Orders
      ADD(Queue:RelTree,POINTER(Queue:RelTree)+1)
    ELSE
      IF REL1::LoadAll
        ADD(REL1::LoadedQueue,REL1::LoadedLevel,REL1::LoadedPosition)
      END
      REL1::Level = 2
      REL1::Loaded = True
      DO REL1::Format:Orders
      ADD(Queue:RelTree,POINTER(Queue:RelTree)+1)
      DO REL1::Load:Detail
    END
  END

!-------------------------------------------------------
REL1::Format:Orders ROUTINE
!|
!| This routine formats a line of the display queue Queue:RelTree to display the
!| contents of a record of Orders.
!|
!| First, the variable DisplayString is assigned the formatted value.
!|
!| Next, the queue variable REL1::Display is assigned the value in
!| DisplayString. It is possible for the display string to be reformatted in
!| the EMBED point "Relation Tree, Before Setting Display on Primary File".
!|
!| Next, any coloring done to the line is performed.
!|
!| Next, any icon assigments are made.
!|
  DisplayString = 'Invoice# ' & FORMAT(ORD:InvoiceNumber,@P######P) &', Order# ' & FORMAT(ORD:OrderNumber,@P#######P) & ', (' & LEFT(FORMAT(ORD:OrderDate,@D1)) & ')'
  REL1::Display = DisplayString
  REL1::NormalFG = 8388608
  REL1::NormalBG = -1
  REL1::SelectedFG = -1
  REL1::SelectedBG = -1
  REL1::Icon = 3
!---------------------------------------------------------------------------
REL1::Load:Detail ROUTINE
!|
!| This routine is used to load the base level of the RelationTree.
!|
!| Next, each record of the file Detail is read. If the record is not filtered,
!| the queue record that corresponds to this record is formatted and added to the queue
!| Queue:RelTree. This is done in the routine REL1::Format:Detail.
!|
  DTL:CustNumber = ORD:CustNumber
  DTL:OrderNumber = ORD:OrderNumber
  CLEAR(DTL:LineNumber)
  Access:Detail.UseFile
  SET(DTL:KeyDetails,DTL:KeyDetails)
  LOOP
    IF Access:Detail.Next()
      IF Access:Detail.GetEOF()
        BREAK
      ELSE
        POST(EVENT:CloseWindow)
        EXIT
      END
    END
    IF DTL:CustNumber <> ORD:CustNumber THEN BREAK.
    IF DTL:OrderNumber <> ORD:OrderNumber THEN BREAK.
    REL1::Loaded = 0
    REL1::Position = POSITION(Detail)
    REL1::Level = 3
    DO REL1::Format:Detail
    ADD(Queue:RelTree,POINTER(Queue:RelTree)+1)
  END

!-------------------------------------------------------
REL1::Format:Detail ROUTINE
!|
!| This routine formats a line of the display queue Queue:RelTree to display the
!| contents of a record of Detail.
!|
!| First, the variable DisplayString is assigned the formatted value.
!|
!| Next, the queue variable REL1::Display is assigned the value in
!| DisplayString. It is possible for the display string to be reformatted in
!| the EMBED point "Relation Tree, Before Setting Display on Primary File".
!|
!| Next, any coloring done to the line is performed.
!|
!| Next, any icon assigments are made.
!|
  CLEAR(DisplayString)
   PRO:ProductNumber = DTL:ProductNumber                   ! Move value for lookup
   Access:Products.Fetch(PRO:KeyProductNumber)             ! Get value from file
  !Format DisplayString
  DisplayString = CLIP(PRO:Description) & ' ('|
                  & CLIP(LEFT(FORMAT(DTL:QuantityOrdered,@N5))) & ' @ '|
                  & CLIP(LEFT(FORMAT(DTL:Price,@N$10.2))) & '), Tax = '|
                  & CLIP(LEFT(FORMAT(DTL:TaxPaid,@N$10.2))) & ', Discount = '|
                  & CLIP(LEFT(FORMAT(DTL:Discount,@N$10.2))) & ', ' & |
                  'Total Cost = '& LEFT(FORMAT(DTL:TotalCost,@N$14.2))
  REL1::Display = DisplayString
  IF DTL:BackOrdered = TRUE
    REL1::NormalFG = 255
    REL1::NormalBG = -1
    REL1::SelectedFG = -1
    REL1::SelectedBG = -1
  ELSE
    REL1::NormalFG = 32768
    REL1::NormalBG = -1
    REL1::SelectedFG = -1
    REL1::SelectedBG = -1
  END
  REL1::Icon = 4

REL1::AddEntry ROUTINE
  REL1::Action = InsertRecord
  DO REL1::UpdateLoop

REL1::EditEntry ROUTINE
  REL1::Action = ChangeRecord
  DO REL1::UpdateLoop

REL1::RemoveEntry ROUTINE
  REL1::Action = DeleteRecord
  DO REL1::UpdateLoop

REL1::UpdateLoop ROUTINE
  LOOP
    VCRRequest = VCR:None
    ?RelTree{PROPLIST:MouseDownRow} = CHOICE(?RelTree)
    CASE REL1::Action
      OF InsertRecord
        DO REL1::AddEntryServer
      OF DeleteRecord
        DO REL1::RemoveEntryServer
      OF ChangeRecord
        DO REL1::EditEntryServer
    END
    CASE VCRRequest
      OF VCR:Forward
        DO REL1::NextRecord
      OF VCR:Backward
        DO REL1::PreviousRecord
      OF VCR:PageForward
        DO REL1::NextLevel
      OF VCR:PageBackward
        DO REL1::PreviousLevel
      OF VCR:First
        DO REL1::PreviousParent
      OF VCR:Last
        DO REL1::NextParent
      OF VCR:Insert
        DO REL1::PreviousParent
        REL1::Action = InsertRecord
      OF VCR:None
        BREAK
    END
  END
!---------------------------------------------------------------------------
REL1::AddEntryServer ROUTINE
!|
!| This routine calls the RelationTree's update procedure to insert a new record.
!|
!| First, we see where the insert request comes from. Since no alert-key handling
!| is present for editing, ?RelTree{PropList:MouseDownRow} is all that is
!| necessary for editing, and we can rely on this property containing the
!| correct selection.
!|
!| Next, we retrieve the Queue:RelTree record that corresponds to the requested
!| insert row. The new record will be added to the RelationTree level BELOW
!| the requested insert row. To add a first-level record, the RelationTree
!| header must be selected for the insert.
!|
!| Next, the record is cleared, and any related values are primed.
!|
!| Next, GlobalRequest is set to InsertRecord, and the appropriate update procedure
!| is called.
!|
!| Finally, if the insert is successful (GlobalRequest = RequestCompleted) then the
!| RelationTree is refreshed, and the newly inserted record highlighted.
!|
  IF ?Insert{PROP:Disable}
    EXIT
  END
  REL1::CurrentChoice = ?RelTree{PROPLIST:MouseDownRow}
  GET(Queue:RelTree,REL1::CurrentChoice)
  CASE ABS(REL1::Level)
  OF 0
    Access:Customers.PrimeRecord
    GlobalRequest = InsertRecord
    UpdateCustomers
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 1
      REL1::NewItemPosition = POSITION(Detail)
      DO REL1::RefreshTree
    END
  OF 1
    REGET(Customers,REL1::Position)
    GET(Orders,0)
    CLEAR(Orders)
    ORD:CustNumber = CUS:CustNumber
    Access:Orders.PrimeRecord(1)
    GlobalRequest = InsertRecord
    UpdateOrders
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 2
      REL1::NewItemPosition = POSITION(Orders)
      DO REL1::RefreshTree
    END
  OF 2
  OROF 3
    LOOP WHILE ABS(REL1::Level) = 3
      REL1::CurrentChoice -= 1
      GET(Queue:RelTree,REL1::CurrentChoice)
    UNTIL ERRORCODE()
    REGET(Orders,REL1::Position)
    GET(Detail,0)
    CLEAR(Detail)
    DTL:CustNumber = ORD:CustNumber
    DTL:OrderNumber = ORD:OrderNumber
    Access:Detail.PrimeRecord(1)
    GlobalRequest = InsertRecord
    UpdateDetail
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 3
      REL1::NewItemPosition = POSITION(Detail)
      DO REL1::RefreshTree
    END
  END
!---------------------------------------------------------------------------
REL1::EditEntryServer ROUTINE
!|
!| This routine calls the RelationTree's update procedure to change a record.
!|
!| First, we see where the change request comes from. Since no alert-key handling
!| is present for editing, ?RelTree{PropList:MouseDownRow} is all that is
!| necessary for editing, and we can rely on this property containing the
!| correct selection.
!|
!| Next, we retrieve the Queue:RelTree record that corresponds to the requested
!| change row. and retrieve the appropriate record from disk.
!|
!| Next, GlobalRequest is set to ChangeRecord, and the appropriate update procedure
!| is called.
!|
!| Finally, if the change is successful (GlobalRequest = RequestCompleted) then the
!| RelationTree is refreshed, and the newly changed record highlighted.
!|
  IF ?Change{PROP:Disable}
    EXIT
  END
  REL1::CurrentChoice = ?RelTree{PROPLIST:MouseDownRow}
  GET(Queue:RelTree,REL1::CurrentChoice)
  CASE ABS(REL1::Level)
  OF 1
    WATCH(Customers)
    REGET(Customers,REL1::Position)
    GlobalRequest = ChangeRecord
    UpdateCustomers
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 1
      REL1::NewItemPosition = POSITION(Customers)
      DO REL1::RefreshTree
    END
  OF 2
    WATCH(Orders)
    REGET(Orders,REL1::Position)
    GlobalRequest = ChangeRecord
    UpdateOrders
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 1
      REL1::NewItemPosition = POSITION(Orders)
      DO REL1::RefreshTree
    END
  OF 3
    WATCH(Detail)
    REGET(Detail,REL1::Position)
    GlobalRequest = ChangeRecord
    UpdateDetail
    IF GlobalResponse = RequestCompleted
      REL1::NewItemLevel = 1
      REL1::NewItemPosition = POSITION(Detail)
      DO REL1::RefreshTree
    END
  END
!---------------------------------------------------------------------------
REL1::RemoveEntryServer ROUTINE
!|
!| This routine calls the RelationTree's update procedure to delete a record.
!|
!| First, we see where the delete request comes from. Since no alert-key handling
!| is present for editing, ?RelTree{PropList:MouseDownRow} is all that is
!| necessary for editing, and we can rely on this property containing the
!| correct selection.
!|
!| Next, we retrieve the Queue:RelTree record that corresponds to the requested
!| delete row. and retrieve the appropriate record from disk.
!|
!| Next, GlobalRequest is set to DeleteRecord, and the appropriate update procedure
!| is called.
!|
!| Finally, if the change is successful (GlobalRequest = RequestCompleted) then the
!| RelationTree is refreshed, and the record below the deleted record is highlighted.
!|
  IF ?Delete{PROP:Disable}
    EXIT
  END
  REL1::CurrentChoice = ?RelTree{PROPLIST:MouseDownRow}
  GET(Queue:RelTree,REL1::CurrentChoice)
  CASE ABS(REL1::Level)
  OF 1
    REGET(Customers,REL1::Position)
    GlobalRequest = DeleteRecord
    UpdateCustomers
    IF GlobalResponse = RequestCompleted
      DO REL1::RefreshTree
    END
  OF 2
    REGET(Orders,REL1::Position)
    GlobalRequest = DeleteRecord
    UpdateOrders
    IF GlobalResponse = RequestCompleted
      DO REL1::RefreshTree
    END
  OF 3
    REGET(Detail,REL1::Position)
    GlobalRequest = DeleteRecord
    UpdateDetail
    IF GlobalResponse = RequestCompleted
      DO REL1::RefreshTree
    END
  END
!---------------------------------------------------------------------------
REL1::RefreshTree ROUTINE
!|
!| This routine is used to refresh the RelationTree.
!|
!| First, the queue Queue:RelTree is FREEd. The display is always completely rebuilt.
!|
!| Next, the routine REL1::Load:Customers is called. This routine will
!| call any other routines necessary to rebuild the display.
!|
!| Finally, if a new item has been added (via REL1::AddEntry), then the
!| queue is searched for that entry, and the record is highlighted.
!|
  FREE(Queue:RelTree)
  DO REL1::Load:Customers
  IF REL1::NewItemLevel
    REL1::CurrentChoice = 0
    LOOP
      REL1::CurrentChoice += 1
      GET(Queue:RelTree,REL1::CurrentChoice)
      IF ERRORCODE() THEN BREAK.
      IF ABS(REL1::Level) <> ABS(REL1::NewItemLevel) THEN CYCLE.
      IF REL1::Position <> REL1::NewItemPosition THEN CYCLE.
      SELECT(?RelTree,REL1::CurrentChoice)
      BREAK
    END
  END
!---------------------------------------------------------------------------
REL1::ContractAll ROUTINE
!|
!| This routine re-initializes the RelationTree.
!|
!| The two queues used by the RelationTree (Queue:RelTree and REL1::LoadedQueue)
!| are FREEd, and the routine REL1::Load:Customers is called, which loads
!| the first level of the RelationTree.
!|
  FREE(Queue:RelTree)
  FREE(REL1::LoadedQueue)
  DO REL1::Load:Customers
!---------------------------------------------------------------------------
REL1::ExpandAll ROUTINE
!|
!| This routine expands every branch of the RelationTree.
!|
!| First, The two queues used by the RelationTree (Queue:RelTree and REL1::LoadedQueue)
!| are FREEd.
!|
!| Next, the variable REL1::LoadAll is set to true, and the routine REL1::Load:Customers
!| is called. Since REL1::LoadAll is True, all branches are completely loaded.
!|
  FREE(Queue:RelTree)
  FREE(REL1::LoadedQueue)
  REL1::LoadAll = True
  DO REL1::Load:Customers
  REL1::LoadAll = False

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('BrowseAllOrders')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?RelTree
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
  Relate:Customers.SetOpenRelated()
  Relate:Customers.Open                                    ! File Customers used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  DO REL1::ContractAll
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  window{PROP:MinWidth} = 295                              ! Restrict the minimum window width
  window{PROP:MinHeight} = 193                             ! Restrict the minimum window height
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  Toolbar.AddTarget(REL1::Toolbar, ?RelTree)
  DO REL1::AssignButtons
  ?RelTree{PROP:IconList,1} = '~File.ico'
  ?RelTree{PROP:IconList,2} = '~Folder.ico'
  ?RelTree{PROP:IconList,3} = '~Invoice.ico'
  ?RelTree{PROP:IconList,4} = '~star1.ico'
  ?RelTree{Prop:Selected} = 1
  ?RelTree{PROP:Alrt,255} = CtrlRight
  ?RelTree{PROP:Alrt,254} = CtrlLeft
  ?RelTree{PROP:Alrt,253} = MouseLeft2
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
    OF ?Insert
      ThisWindow.Update
      ?RelTree{PropList:MouseDownRow} = CHOICE(?RelTree)
      DO REL1::AddEntry
    OF ?Change
      ThisWindow.Update
      ?RelTree{PropList:MouseDownRow} = CHOICE(?RelTree)
      DO REL1::EditEntry
    OF ?Delete
      ThisWindow.Update
      ?RelTree{PropList:MouseDownRow} = CHOICE(?RelTree)
      DO REL1::RemoveEntry
    OF ?Expand
      ThisWindow.Update
      ?RelTree{PROPLIST:MouseDownRow} = CHOICE(?RelTree)
      DO REL1::ExpandAll
    OF ?Contract
      ThisWindow.Update
      ?RelTree{PROPLIST:MouseDownRow} = CHOICE(?RelTree)
      DO REL1::ContractAll
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeFieldEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all field specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  CASE FIELD()
  OF ?RelTree
    CASE EVENT()
    ELSE
      CASE EVENT()
      OF EVENT:AlertKey
        CASE KEYCODE()
        OF CtrlRight
          ?RelTree{PropList:MouseDownRow} = CHOICE(?RelTree)
          POST(EVENT:Expanded,?RelTree)
        OF CtrlLeft
          ?RelTree{PropList:MouseDownRow} = CHOICE(?RelTree)
          POST(EVENT:Contracted,?RelTree)
        OF MouseLeft2
          DO REL1::EditEntry
        END
      END
    END
  END
  ReturnValue = PARENT.TakeFieldEvent()
  CASE FIELD()
  OF ?RelTree
    CASE EVENT()
    OF EVENT:Expanded
      DO REL1::LoadLevel
    OF EVENT:Contracted
      DO REL1::UnloadLevel
    END
  END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeNewSelection PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all NewSelection events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeNewSelection()
    CASE FIELD()
    OF ?RelTree
      CASE KEYCODE()
      OF MouseRight
      OROF AppsKey
        EXECUTE(POPUP('Insert|Change|Delete|-|&Expand All|Co&ntract All'))
          DO REL1::AddEntry
          DO REL1::EditEntry
          DO REL1::RemoveEntry
          DO REL1::ExpandAll
          DO REL1::ContractAll
        END
      END
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
    OF EVENT:GainFocus
      REL1::CurrentChoice = CHOICE(?RelTree)
      GET(Queue:RelTree,REL1::CurrentChoice)
      REL1::NewItemLevel = REL1::Level
      REL1::NewItemPosition = REL1::Position
      DO REL1::RefreshTree
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

REL1::Toolbar.TakeEvent PROCEDURE(<*LONG VCR>,WindowManager WM)
  CODE
  CASE ACCEPTED()
  OF Toolbar:Bottom TO Toolbar:Up
    SELF.Control{PROPLIST:MouseDownRow} = CHOICE(SELF.Control) !! Server routines assume this
    EXECUTE(ACCEPTED()-Toolbar:Bottom+1)
      DO REL1::NextParent
      DO REL1::PreviousParent
      DO REL1::NextLevel
      DO REL1::PreviousLevel
      DO REL1::NextRecord
      DO REL1::PreviousRecord
    END
  OF Toolbar:Insert TO Toolbar:Delete
    SELF.Control{PROPLIST:MouseDownRow} = CHOICE(SELF.Control) !! Server routines assume this
    EXECUTE(ACCEPTED()-Toolbar:Insert+1)
      DO REL1::AddEntry
      DO REL1::EditEntry
      DO REL1::RemoveEntry
    END
  ELSE
    PARENT.TakeEvent(VCR,ThisWindow)
  END

Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

