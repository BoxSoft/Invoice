   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   !C6RW library
   INCLUDE('RWPRLIB.INC')

   MAP
     MODULE('INVOICE_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
     MODULE('INVOICE001.CLW')
SelectStates           PROCEDURE   !Browse the States File and Edit-in-Place update
     END
     MODULE('INVOICE002.CLW')
UpdateCustomers        PROCEDURE   !Update the Customers File
     END
     MODULE('INVOICE003.CLW')
BrowseAllOrders        PROCEDURE   !Browse Orders using a relation tree
     END
     MODULE('INVOICE004.CLW')
SelectProducts         PROCEDURE   !Select a Products Record
     END
     MODULE('INVOICE005.CLW')
UpdateDetail           PROCEDURE   !Update the Detail File
     END
     MODULE('INVOICE006.CLW')
UpdateOrders           PROCEDURE   !Update the Orders File
     END
     MODULE('INVOICE007.CLW')
Main                   PROCEDURE   !Clarion for Windows Wizard Application - with Wallpaper
     END
     MODULE('INVOICE008.CLW')
PrintInvoiceFromBrowse PROCEDURE   !Prints Invoice for each order
     END
     MODULE('INVOICE009.CLW')
BrowseOrders           PROCEDURE   !Browse the Orders File
     END
     MODULE('INVOICE010.CLW')
BrowseCustomers        PROCEDURE   !Browse the Customers File with "Filter Locator"
     END
     MODULE('INVOICE011.CLW')
CityStateZip           FUNCTION(<String>,<String>,<String>),String   !Function to return CSZ
     END
     MODULE('INVOICE012.CLW')
PrintSelectedCustomer  PROCEDURE   !Report the Customers File
     END
     MODULE('INVOICE013.CLW')
PrintSelectedProduct   PROCEDURE   !Report the Products File
     END
     MODULE('INVOICE014.CLW')
BrowseProducts         PROCEDURE   !Browse Products File (Edit-In-Place and calls Update form)
     END
     MODULE('INVOICE015.CLW')
UpdateProducts         PROCEDURE   !Update the Products File
     END
     MODULE('INVOICE016.CLW')
PrintCUS:StateKey      PROCEDURE   !Report the Customers File
     END
     MODULE('INVOICE017.CLW')
PrintPRO:KeyProductSKU PROCEDURE   !Report the Products File
     END
     MODULE('INVOICE018.CLW')
PrintInvoice           PROCEDURE   !Prints Invoice - Using the Pause Control Template
     END
     MODULE('INVOICE019.CLW')
PrintMailingLabels     PROCEDURE   !Printing mailing labels
     END
     MODULE('INVOICE020.CLW')
UpdateCompany          PROCEDURE   !Update the Company File
     END
     MODULE('INVOICE021.CLW')
SplashScreen           PROCEDURE   !
     END
     INCLUDE('CWUtil.INC')
   END

GLOT:CustName        STRING(35),THREAD
GLOT:ShipName        STRING(35),THREAD
GLOT:CustAddress     STRING(45),THREAD
GLOT:ShipAddress     STRING(45),THREAD
GLOT:CusCSZ          STRING(40),THREAD
GLOT:ShipCSZ         STRING(40),THREAD
GLO:Pathname         STRING(50)
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
States               FILE,DRIVER('TOPSPEED'),NAME('States'),PRE(States),CREATE,BINDABLE,THREAD !State's code and name
StateCodeKey             KEY(States:StateCode),NOCASE,PRIMARY !                    
Record                   RECORD,PRE()
StateCode                   STRING(2)                      !Code for  State     
Name                        STRING(25)                     !Name of State       
                         END
                     END                       

Company              FILE,DRIVER('TOPSPEED'),NAME('Company'),PRE(Company),CREATE,BINDABLE,THREAD !Default company information
CompanyIDKey             KEY(Company:CompanyID),NOCASE,PRIMARY !                    
Record                   RECORD,PRE()
CompanyID                   LONG                           !                    
Name                        STRING(20)                     !Company name        
Address                     STRING(35)                     !First line of company's address
City                        STRING(25)                     !Company's city      
State                       STRING(2)                      !Company's state     
Zipcode                     STRING(10)                     !Company's zipcode   
Phone                       STRING(10)                     !Company's phone number
                         END
                     END                       

Product              FILE,DRIVER('TOPSPEED'),NAME('Product'),PRE(Product),CREATE,BINDABLE,THREAD !Product's Information
ProductIDKey             KEY(Product:ProductID),NOCASE,PRIMARY !                    
KeyProductSKU            KEY(Product:ProductSKU),NOCASE    !                    
KeyDescription           KEY(Product:Description),DUP,NOCASE !                    
Record                   RECORD,PRE()
ProductID                   LONG                           !                    
ProductSKU                  STRING(10)                     !User defined Product Number
Description                 STRING(35)                     !Product's Description
Price                       DECIMAL(7,2)                   !Product's Price     
QuantityInStock             DECIMAL(7,2)                   !Quantity of product in stock
ReorderQuantity             DECIMAL(7,2)                   !Product's quantity for re-order
Cost                        DECIMAL(7,2)                   !Product's cost      
PictureFile                 STRING(64)                     !Path of graphic file
                         END
                     END                       

InventoryLog         FILE,DRIVER('TOPSPEED'),NAME('InventoryLog'),PRE(InventoryLog),CREATE,BINDABLE,THREAD !                    
InventoryLogIDKey        KEY(InventoryLog:InventoryLogID),NOCASE,PRIMARY !                    
KeyProdNumberDate        KEY(InventoryLog:ProductID,InventoryLog:Date),DUP,NOCASE,OPT !                    
KeyProductNumberDate     KEY(InventoryLog:ProductID,InventoryLog:VendorNumber,InventoryLog:Date),DUP,NOCASE,OPT !                    
KeyVendorNumberDate      KEY(InventoryLog:VendorNumber,InventoryLog:Date),DUP,NOCASE,OPT !                    
Record                   RECORD,PRE()
InventoryLogID              LONG                           !                    
Date                        LONG                           !Date of transaction 
TransType                   STRING(7)                      !Type of transaction 
ProductID                   LONG                           !                    
Quantity                    DECIMAL(7,2)                   !Quantity for each transaction
VendorNumber                LONG                           !Vendor's Identification Number
Cost                        DECIMAL(7,2)                   !Cost of product     
Notes                       STRING(50)                     !Notes on current transaction
                         END
                     END                       

InvoiceDetail        FILE,DRIVER('TOPSPEED'),NAME('InvoiceDetail'),PRE(InvoiceDetail),CREATE,BINDABLE,THREAD !Product-Order detail
InvoiceDetailIDKey       KEY(InvoiceDetail:InvoiceDetailID),NAME('PK_InvoiceDetail'),NOCASE,PRIMARY !                    
InvoiceKey               KEY(InvoiceDetail:InvoiceID,InvoiceDetail:LineNumber),NOCASE !                    
ProductKey               KEY(InvoiceDetail:ProductID),DUP,NOCASE !                    
Record                   RECORD,PRE()
InvoiceDetailID             LONG                           !                    
InvoiceID                   LONG                           !                    
LineNumber                  SHORT                          !Line number         
ProductID                   LONG                           !                    
QuantityOrdered             DECIMAL(7,2)                   !Quantity of product ordered
BackOrdered                 BYTE                           !Product is on back order
Price                       DECIMAL(7,2)                   !Product's price     
TaxRate                     DECIMAL(6,4)                   !Consumer's Tax rate 
TaxPaid                     DECIMAL(7,2)                   !Calculated tax on product
DiscountRate                DECIMAL(6,4)                   !Special discount rate on product
Discount                    DECIMAL(7,2)                   !Calculated discount on product
Savings                     DECIMAL(7,2)                   !Amount saved due to discount
TotalCost                   DECIMAL(10,2)                  !Extended Total for product
                         END
                     END                       

Invoice              FILE,DRIVER('TOPSPEED'),NAME('Invoice'),PRE(Invoice),CREATE,BINDABLE,THREAD !Customer's Orders   
InvoiceIDKey             KEY(Invoice:InvoiceID),NOCASE,PRIMARY !                    
KeyCustOrderNumber       KEY(Invoice:CustomerID,Invoice:OrderNumber),DUP,NOCASE !                    
InvoiceNumberKey         KEY(Invoice:InvoiceNumber),NOCASE !                    
StateKey                 KEY(Invoice:ShipState),DUP,NOCASE !                    
Record                   RECORD,PRE()
InvoiceID                   LONG                           !                    
CustomerID                  LONG                           !                    
OrderNumber                 LONG                           !Order Identification Number
InvoiceNumber               LONG                           !Invoice number for each order
OrderDate                   LONG                           !Date of Order       
SameName                    BYTE                           !ShipTo name same as Customer's
ShipToName                  STRING(45)                     !Customer the order is shipped to
SameAdd                     BYTE                           !Ship to address same as customer's
ShipAddress1                STRING(35)                     !1st Line of ship address
ShipAddress2                STRING(35)                     !2nd line of ship address
ShipCity                    STRING(25)                     !City of Ship address
ShipState                   STRING(2)                      !State to ship to    
ShipZip                     STRING(10)                     !ZipCode of ship city
OrderShipped                BYTE                           !Checked if order is shipped
OrderNote                   STRING(80)                     !Additional Information about order
                         END
                     END                       

Customer             FILE,DRIVER('TOPSPEED'),NAME('Customer'),PRE(Customer),CREATE,BINDABLE,THREAD !Customer's Information
CustomerIDKey            KEY(Customer:CustomerID),NOCASE,PRIMARY !                    
KeyFullName              KEY(Customer:LastName,Customer:FirstName,Customer:MI),DUP,NOCASE !                    
KeyCompany               KEY(Customer:Company),DUP,NOCASE  !                    
KeyZipCode               KEY(Customer:ZipCode),DUP,NOCASE  !                    
StateKey                 KEY(Customer:StateCode),DUP,NOCASE !                    
Record                   RECORD,PRE()
CustomerID                  LONG                           !                    
Company                     STRING(20)                     !Customer's Company Name
FirstName                   STRING(20)                     !Customer's First Name
MI                          STRING(1)                      !Customer's Middle Initial
LastName                    STRING(25)                     !Customer's Last Name
Address1                    STRING(35)                     !Customer's Street Address - 1st Line
Address2                    STRING(35)                     !Customer's Address - 2nd Line
City                        STRING(25)                     !Customer's City     
StateCode                   STRING(2)                      !Customer's State    
ZipCode                     STRING(10)                     !Customer's ZipCode  
PhoneNumber                 STRING(10)                     !Customer's phone number
Extension                   STRING(4)                      !Customer's phone extension
PhoneType                   STRING(8)                      !Customer's phone type
                         END
                     END                       

!endregion

RE          ReportEngine
Access:States        &FileManager,THREAD                   ! FileManager for States
Relate:States        &RelationManager,THREAD               ! RelationManager for States
Access:Company       &FileManager,THREAD                   ! FileManager for Company
Relate:Company       &RelationManager,THREAD               ! RelationManager for Company
Access:Product       &FileManager,THREAD                   ! FileManager for Product
Relate:Product       &RelationManager,THREAD               ! RelationManager for Product
Access:InventoryLog  &FileManager,THREAD                   ! FileManager for InventoryLog
Relate:InventoryLog  &RelationManager,THREAD               ! RelationManager for InventoryLog
Access:InvoiceDetail &FileManager,THREAD                   ! FileManager for InvoiceDetail
Relate:InvoiceDetail &RelationManager,THREAD               ! RelationManager for InvoiceDetail
Access:Invoice       &FileManager,THREAD                   ! FileManager for Invoice
Relate:Invoice       &RelationManager,THREAD               ! RelationManager for Invoice
Access:Customer      &FileManager,THREAD                   ! FileManager for Customer
Relate:Customer      &RelationManager,THREAD               ! RelationManager for Customer

GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  HELP('INVOICE.HLP')                                      ! Open the applications help file
  GlobalErrors.Init(GlobalErrorStatus)
  INIMgr.Init('.\invoice.INI', NVD_INI)                    ! Configure INIManager to use INI file
  DctInit
  OPEN(Company)
  IF ERRORCODE() = 2                  !File not found
    CREATE(Company)                   !Create file
    OPEN(Company)
    GlobalRequest = InsertRecord      !Insert mode for form
    UpdateCompany
  ELSE
    CLOSE(Company)
  END
  Relate:Company.Open
  SET(Company)
  Access:Company.Next()
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

