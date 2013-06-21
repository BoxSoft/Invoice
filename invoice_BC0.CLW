  MEMBER('invoice.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
invoice_BC0:DctInit    PROCEDURE
invoice_BC0:DctKill    PROCEDURE
invoice_BC0:FilesInit  PROCEDURE
  END

Hide:Access:States   CLASS(FileManager),TYPE               ! FileManager for States
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:States   CLASS(RelationManager),TYPE           ! RelationManager for States
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Company  CLASS(FileManager),TYPE               ! FileManager for Company
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Company  CLASS(RelationManager),TYPE           ! RelationManager for Company
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Product  CLASS(FileManager),TYPE               ! FileManager for Product
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Product  CLASS(RelationManager),TYPE           ! RelationManager for Product
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:InventoryLog CLASS(FileManager),TYPE           ! FileManager for InventoryLog
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:InventoryLog CLASS(RelationManager),TYPE       ! RelationManager for InventoryLog
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:InvoiceDetail CLASS(FileManager),TYPE          ! FileManager for InvoiceDetail
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:InvoiceDetail CLASS(RelationManager),TYPE      ! RelationManager for InvoiceDetail
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Invoice  CLASS(FileManager),TYPE               ! FileManager for Invoice
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:Invoice  CLASS(RelationManager),TYPE           ! RelationManager for Invoice
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Customer CLASS(FileManager),TYPE               ! FileManager for Customer
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED
                     END


Hide:Relate:Customer CLASS(RelationManager),TYPE           ! RelationManager for Customer
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:States  &Hide:Access:States,AUTO,THREAD
_Hide:Relate:States  &Hide:Relate:States,AUTO,THREAD
_Hide:Access:Company &Hide:Access:Company,AUTO,THREAD
_Hide:Relate:Company &Hide:Relate:Company,AUTO,THREAD
_Hide:Access:Product &Hide:Access:Product,AUTO,THREAD
_Hide:Relate:Product &Hide:Relate:Product,AUTO,THREAD
_Hide:Access:InventoryLog &Hide:Access:InventoryLog,AUTO,THREAD
_Hide:Relate:InventoryLog &Hide:Relate:InventoryLog,AUTO,THREAD
_Hide:Access:InvoiceDetail &Hide:Access:InvoiceDetail,AUTO,THREAD
_Hide:Relate:InvoiceDetail &Hide:Relate:InvoiceDetail,AUTO,THREAD
_Hide:Access:Invoice &Hide:Access:Invoice,AUTO,THREAD
_Hide:Relate:Invoice &Hide:Relate:Invoice,AUTO,THREAD
_Hide:Access:Customer &Hide:Access:Customer,AUTO,THREAD
_Hide:Relate:Customer &Hide:Relate:Customer,AUTO,THREAD


invoice_BC0:DctInit PROCEDURE
  CODE
  _Hide:Access:States &= NEW(Hide:Access:States)
  _Hide:Relate:States &= NEW(Hide:Relate:States)
  _Hide:Access:Company &= NEW(Hide:Access:Company)
  _Hide:Relate:Company &= NEW(Hide:Relate:Company)
  _Hide:Access:Product &= NEW(Hide:Access:Product)
  _Hide:Relate:Product &= NEW(Hide:Relate:Product)
  _Hide:Access:InventoryLog &= NEW(Hide:Access:InventoryLog)
  _Hide:Relate:InventoryLog &= NEW(Hide:Relate:InventoryLog)
  _Hide:Access:InvoiceDetail &= NEW(Hide:Access:InvoiceDetail)
  _Hide:Relate:InvoiceDetail &= NEW(Hide:Relate:InvoiceDetail)
  _Hide:Access:Invoice &= NEW(Hide:Access:Invoice)
  _Hide:Relate:Invoice &= NEW(Hide:Relate:Invoice)
  _Hide:Access:Customer &= NEW(Hide:Access:Customer)
  _Hide:Relate:Customer &= NEW(Hide:Relate:Customer)
  Relate:States &= _Hide:Relate:States
  Relate:Company &= _Hide:Relate:Company
  Relate:Product &= _Hide:Relate:Product
  Relate:InventoryLog &= _Hide:Relate:InventoryLog
  Relate:InvoiceDetail &= _Hide:Relate:InvoiceDetail
  Relate:Invoice &= _Hide:Relate:Invoice
  Relate:Customer &= _Hide:Relate:Customer


invoice_BC0:FilesInit PROCEDURE
  CODE
  _Hide:Relate:States.Init
  _Hide:Relate:Company.Init
  _Hide:Relate:Product.Init
  _Hide:Relate:InventoryLog.Init
  _Hide:Relate:InvoiceDetail.Init
  _Hide:Relate:Invoice.Init
  _Hide:Relate:Customer.Init


invoice_BC0:DctKill PROCEDURE
  CODE
  _Hide:Relate:States.Kill
  DISPOSE(_Hide:Relate:States)
  _Hide:Relate:Company.Kill
  DISPOSE(_Hide:Relate:Company)
  _Hide:Relate:Product.Kill
  DISPOSE(_Hide:Relate:Product)
  _Hide:Relate:InventoryLog.Kill
  DISPOSE(_Hide:Relate:InventoryLog)
  _Hide:Relate:InvoiceDetail.Kill
  DISPOSE(_Hide:Relate:InvoiceDetail)
  _Hide:Relate:Invoice.Kill
  DISPOSE(_Hide:Relate:Invoice)
  _Hide:Relate:Customer.Kill
  DISPOSE(_Hide:Relate:Customer)


Hide:Relate:States.Init PROCEDURE
  CODE
  _Hide:Access:States.Init
  SELF.Init(Access:States,1)


Hide:Access:States.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= States:Record
  SELF.FileNameValue = 'States'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= States
  PARENT.Init
  Access:States &= SELF


Hide:Access:States.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:States &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:States.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(States,GlobalErrors)
    SELF.LockRecover = 10
    SELF.AddKey(States:StateCodeKey,'States:StateCodeKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:States.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Invoice,RI:RESTRICT,RI:RESTRICT,Invoice:StateKey)
  SELF.AddRelationLink(States:StateCode,Invoice:ShipState)

  SELF.AddRelation(Relate:Customer,RI:RESTRICT,RI:RESTRICT,Customer:StateKey)
  SELF.AddRelationLink(States:StateCode,Customer:StateCode)


Hide:Relate:States.Kill PROCEDURE

  CODE
  _Hide:Access:States.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:States &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:States)                             ! destroy the file manager


Hide:Relate:Company.Init PROCEDURE
  CODE
  _Hide:Access:Company.Init
  SELF.Init(Access:Company,1)


Hide:Access:Company.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Company:Record
  SELF.FileNameValue = 'Company'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Company
  PARENT.Init
  Access:Company &= SELF


Hide:Access:Company.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Company &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Company.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Company,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Company:CompanyIDKey,'Company:CompanyIDKey',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Company.Kill PROCEDURE

  CODE
  _Hide:Access:Company.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:Company &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Company)                            ! destroy the file manager


Hide:Relate:Product.Init PROCEDURE
  CODE
  _Hide:Access:Product.Init
  SELF.Init(Access:Product,1)


Hide:Access:Product.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Product:Record
  SELF.FileNameValue = 'Product'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Product
  PARENT.Init
  Access:Product &= SELF


Hide:Access:Product.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Product &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Product.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Product,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Product:ProductIDKey,'Product:ProductIDKey',1)
    SELF.AddKey(Product:KeyProductSKU,'Product:KeyProductSKU',0)
    SELF.AddKey(Product:KeyDescription,'Product:KeyDescription',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Product.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:InvoiceDetail,RI:None,RI:RESTRICT,InvoiceDetail:ProductKey)
  SELF.AddRelationLink(Product:ProductID,InvoiceDetail:ProductID)

  SELF.AddRelation(Relate:InventoryLog,RI:None,RI:RESTRICT,InventoryLog:KeyProdNumberDate)
  SELF.AddRelationLink(Product:ProductID,InventoryLog:ProductID)


Hide:Relate:Product.Kill PROCEDURE

  CODE
  _Hide:Access:Product.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:Product &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Product)                            ! destroy the file manager


Hide:Relate:InventoryLog.Init PROCEDURE
  CODE
  _Hide:Access:InventoryLog.Init
  SELF.Init(Access:InventoryLog,1)


Hide:Access:InventoryLog.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= InventoryLog:Record
  SELF.FileNameValue = 'InventoryLog'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= InventoryLog
  PARENT.Init
  Access:InventoryLog &= SELF


Hide:Access:InventoryLog.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:InventoryLog &= NULL                              ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:InventoryLog.PrimeFields PROCEDURE

  CODE
  InventoryLog:Date = today()                              ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:InventoryLog.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(InventoryLog,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(InventoryLog:InventoryLogIDKey,'InventoryLog:InventoryLogIDKey',1)
    SELF.AddKey(InventoryLog:KeyProdNumberDate,'InventoryLog:KeyProdNumberDate',0)
    SELF.AddKey(InventoryLog:KeyProductNumberDate,'InventoryLog:KeyProductNumberDate',0)
    SELF.AddKey(InventoryLog:KeyVendorNumberDate,'InventoryLog:KeyVendorNumberDate',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:InventoryLog.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Product)


Hide:Relate:InventoryLog.Kill PROCEDURE

  CODE
  _Hide:Access:InventoryLog.Kill                           ! Kill the file manager
  PARENT.Kill
  Relate:InventoryLog &= NULL                              ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:InventoryLog)                       ! destroy the file manager


Hide:Relate:InvoiceDetail.Init PROCEDURE
  CODE
  _Hide:Access:InvoiceDetail.Init
  SELF.Init(Access:InvoiceDetail,1)


Hide:Access:InvoiceDetail.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= InvoiceDetail:Record
  SELF.FileNameValue = 'InvoiceDetail'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= InvoiceDetail
  PARENT.Init
  Access:InvoiceDetail &= SELF


Hide:Access:InvoiceDetail.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:InvoiceDetail &= NULL                             ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:InvoiceDetail.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(InvoiceDetail,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(InvoiceDetail:InvoiceDetailIDKey,'InvoiceDetail:InvoiceDetailIDKey',1)
    SELF.AddKey(InvoiceDetail:InvoiceKey,'InvoiceDetail:InvoiceKey',2)
    SELF.AddKey(InvoiceDetail:ProductKey,'InvoiceDetail:ProductKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:InvoiceDetail.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 3
    GlobalErrors.SetField('Line number')
    IF NOT INRANGE(InvoiceDetail:LineNumber,1,99999.99)
      ReturnValue = Level:Notify
    END
    IF ReturnValue <> Level:Benign
      IF HandleErrors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldOutOfRange,'1 .. 99999.99')
      END
    END
  OF 5
    GlobalErrors.SetField('Quantity of product ordered')
    IF NOT INRANGE(InvoiceDetail:QuantityOrdered,1,99999)
      ReturnValue = Level:Notify
    END
    IF ReturnValue <> Level:Benign
      IF HandleErrors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldOutOfRange,'1 .. 99999')
      END
    END
  END
  RETURN ReturnValue


Hide:Relate:InvoiceDetail.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Product)

  SELF.AddRelation(Relate:Invoice)


Hide:Relate:InvoiceDetail.Kill PROCEDURE

  CODE
  _Hide:Access:InvoiceDetail.Kill                          ! Kill the file manager
  PARENT.Kill
  Relate:InvoiceDetail &= NULL                             ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:InvoiceDetail)                      ! destroy the file manager


Hide:Relate:Invoice.Init PROCEDURE
  CODE
  _Hide:Access:Invoice.Init
  SELF.Init(Access:Invoice,1)


Hide:Access:Invoice.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Invoice:Record
  SELF.FileNameValue = 'Invoice'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Invoice
  PARENT.Init
  Access:Invoice &= SELF


Hide:Access:Invoice.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Invoice &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Invoice.PrimeFields PROCEDURE

  CODE
  Invoice:OrderDate = TODAY()                              ! Assign initial field value
  Invoice:ShipState = 'FL'                                 ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Invoice.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Invoice,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Invoice:InvoiceIDKey,'Invoice:InvoiceIDKey',1)
    SELF.AddKey(Invoice:KeyCustOrderNumber,'Invoice:KeyCustOrderNumber',2)
    SELF.AddKey(Invoice:InvoiceNumberKey,'Invoice:InvoiceNumberKey',1)
    SELF.AddKey(Invoice:StateKey,'Invoice:StateKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:Invoice.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:States12      USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 12
    GlobalErrors.SetField('State to ship to')
    Save:States12 = Access:States.SaveFile()
    States:StateCode = Invoice:ShipState
    ReturnValue = Access:States.TryFetch(States:StateCodeKey)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'States')
      END
    END
    Access:States.RestoreFile(Save:States12)
  END
  RETURN ReturnValue


Hide:Relate:Invoice.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Customer)

  SELF.AddRelation(Relate:States)

  SELF.AddRelation(Relate:InvoiceDetail,RI:None,RI:CASCADE,InvoiceDetail:InvoiceKey)
  SELF.AddRelationLink(Invoice:InvoiceID,InvoiceDetail:InvoiceID)


Hide:Relate:Invoice.Kill PROCEDURE

  CODE
  _Hide:Access:Invoice.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:Invoice &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Invoice)                            ! destroy the file manager


Hide:Relate:Customer.Init PROCEDURE
  CODE
  _Hide:Access:Customer.Init
  SELF.Init(Access:Customer,1)


Hide:Access:Customer.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Customer:Record
  SELF.FileNameValue = 'Customer'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Customer
  PARENT.Init
  Access:Customer &= SELF


Hide:Access:Customer.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Customer &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Customer.PrimeFields PROCEDURE

  CODE
  Customer:StateCode = 'FL'                                ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Customer.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Customer,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Customer:CustomerIDKey,'Customer:CustomerIDKey',1)
    SELF.AddKey(Customer:KeyFullName,'Customer:KeyFullName',0)
    SELF.AddKey(Customer:KeyCompany,'Customer:KeyCompany',0)
    SELF.AddKey(Customer:KeyZipCode,'Customer:KeyZipCode',0)
    SELF.AddKey(Customer:StateKey,'Customer:StateKey',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:Customer.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:States9       USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 9
    GlobalErrors.SetField('Customer''s State')
    Save:States9 = Access:States.SaveFile()
    States:StateCode = Customer:StateCode
    ReturnValue = Access:States.TryFetch(States:StateCodeKey)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'States')
      END
    END
    Access:States.RestoreFile(Save:States9)
  END
  RETURN ReturnValue


Hide:Relate:Customer.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Invoice,RI:None,RI:RESTRICT,Invoice:KeyCustOrderNumber)
  SELF.AddRelationLink(Customer:CustomerID,Invoice:CustomerID)

  SELF.AddRelation(Relate:States)


Hide:Relate:Customer.Kill PROCEDURE

  CODE
  _Hide:Access:Customer.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:Customer &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Customer)                           ! destroy the file manager

