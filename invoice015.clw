

   MEMBER('invoice.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

!!! <summary>
!!! Generated from procedure template - Window
!!! Update the Products File
!!! </summary>
UpdateProducts PROCEDURE 

CurrentTab           STRING(80)                            !
LocalRequest         LONG                                  !
FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
RecordChanged        BYTE,AUTO                             !
DOSDialogHeader      CSTRING(40)                           !
DOSExtParameter      CSTRING(250)                          !
DOSTargetVariable    CSTRING(80)                           !
LOC:FileName         STRING(85)                            !
History::Product:Record LIKE(Product:RECORD),THREAD
QuickWindow          WINDOW('Update Products'),AT(,,288,130),FONT('MS Sans Serif',8,COLOR:Black),DOUBLE,CENTER, |
  ICON('FLOW04.ICO'),GRAY,IMM,MDI,HLP('~UpdateProducts'),PALETTE(256),SYSTEM
                       SHEET,AT(3,0,282,128),USE(?CurrentTab),WIZARD
                         TAB('Tab 1'),USE(?Tab1)
                         END
                       END
                       PROMPT('Product SKU:'),AT(7,9),USE(?PRO:ProductSKU:Prompt)
                       ENTRY(@s10),AT(70,9,44,10),USE(Product:ProductSKU),LEFT(1),UPR,MSG('User defined Product Number'), |
  REQ
                       PROMPT('Description:'),AT(7,25),USE(?PRO:Description:Prompt)
                       ENTRY(@s35),AT(70,25,101,10),USE(Product:Description),LEFT(1),CAP,MSG('Enter Product''s' & |
  ' Description'),REQ
                       PROMPT('Price:'),AT(7,41,29,10),USE(?PRO:Price:Prompt)
                       ENTRY(@n$10.2B),AT(70,41,35,10),USE(Product:Price),DECIMAL(12),MSG('Enter Product''s Price')
                       PROMPT('Cost:'),AT(7,57,23,10),USE(?PRO:Cost:Prompt)
                       ENTRY(@n$10.2B),AT(70,57,35,10),USE(Product:Cost),DECIMAL(12),MSG('Enter product''s cost')
                       ENTRY(@n-10.2),AT(70,73,35,10),USE(Product:QuantityInStock),DECIMAL(12),MSG('Enter quan' & |
  'tity of product in stock')
                       PROMPT('Quantity In Stock:'),AT(7,73,60,10),USE(?PRO:QuantityInStock:Prompt)
                       PROMPT('Reorder Quantity:'),AT(7,89,59,10),USE(?PRO:ReorderQuantity:Prompt)
                       ENTRY(@n9.2),AT(70,89,35,10),USE(Product:ReorderQuantity),DECIMAL(12),MSG('Enter produc' & |
  't''s quantity for re-order')
                       PROMPT('Picture File:'),AT(7,105),USE(?PRO:PictureFile:Prompt)
                       ENTRY(@s64),AT(70,105,101,10),USE(Product:PictureFile),LEFT(1),DISABLE,MSG('Path of graphic file')
                       BUTTON('Select Image'),AT(110,87,65,14),USE(?LookupFile),FONT(,,COLOR:Navy,FONT:bold),TIP('Insert or ' & |
  'Change Image')
                       GROUP,AT(181,5,97,94),USE(?Group1),BEVEL(-2,2),BOXED
                         IMAGE,AT(185,9,89,87),USE(?Image1)
                       END
                       BUTTON,AT(195,105,22,20),USE(?OK),ICON('DISK12.ICO'),DEFAULT,FLAT,TIP('Save record and exit ')
                       BUTTON,AT(225,110,13,12),USE(?Help),ICON(ICON:Help),FLAT,HIDE,STD(STD:Help)
                       BUTTON,AT(244,105,22,20),USE(?Cancel),ICON(ICON:Cross),FLAT,TIP('Cancel changes and exit')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FileLookup5          SelectFileClass
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
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

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  CASE SELF.Request
  OF ChangeRecord OROF DeleteRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (' & CLIP(PRO:Description) & ')' ! Append status message to window title text
  OF InsertRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (New)'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateProducts')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PRO:ProductSKU:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(Product:Record,History::Product:Record)
  SELF.AddHistoryField(?Product:ProductSKU,2)
  SELF.AddHistoryField(?Product:Description,3)
  SELF.AddHistoryField(?Product:Price,4)
  SELF.AddHistoryField(?Product:Cost,7)
  SELF.AddHistoryField(?Product:QuantityInStock,5)
  SELF.AddHistoryField(?Product:ReorderQuantity,6)
  SELF.AddHistoryField(?Product:PictureFile,8)
  SELF.AddUpdateFile(Access:Product)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Product.SetOpenRelated()
  Relate:Product.Open                                      ! File Product used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Product
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.InsertAction = Insert:Query
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QuickWindow{PROP:MinWidth} = 281                         ! Restrict the minimum window width
  QuickWindow{PROP:MinHeight} = 127                        ! Restrict the minimum window height
  QuickWindow{PROP:MaxWidth} = 281                         ! Restrict the maximum window width
  QuickWindow{PROP:MaxHeight} = 127                        ! Restrict the maximum window height
  Resizer.Init(AppStrategy:NoResize)                       ! Don't change the windows controls when window resized
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  IF SELF.Request = ChangeRecord OR SELF.Request = DeleteRecord
    ?Image1{PROP:TEXT} = Products.Record.PictureFile
  END
  ToolBarForm.HelpButton=?Help
  SELF.AddItem(ToolbarForm)
  FileLookup5.Init
  FileLookup5.ClearOnCancel = True
  FileLookup5.SetMask('JPEG Images','*.JPG')               ! Set the file mask
  FileLookup5.AddMask('BMP Images','*.BMP')                ! Add additional masks
  FileLookup5.AddMask('GIF Files','*.GIF')                 ! Add additional masks
  FileLookup5.WindowTitle='Locate and Select Product Image File'
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


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
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
    OF ?LookupFile
      ThisWindow.Update
      LOC:FileName = FileLookup5.Ask(1)
      DISPLAY
      IF LOC:FileName
         ?Image1{PROP:TEXT} = CLIP(LOC:FileName)
         ResizeImage(?Image1,185,9,89,87)
         UNHIDE(?Image1)
      END
      !Display filename only and not the path.
      IF LOC:FileName <> ''
        LX# = LEN(CLIP(LOC:FileName))
        LOOP X# = LX# TO 1 BY -1
          IF LOC:FileName[X#] = '\'
            BREAK
          END
        END
        IF LOC:FileName[1 : (X#-1)] = LONGPATH(PATH())
          PRO:PictureFile = UPPER(LOC:FileName[(X#+1) : LX#])
          DISPLAY
        END
      END
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.DeferMoves = False
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

