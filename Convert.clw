  PROGRAM

  INCLUDE('EQUATES.CLW'),ONCE

  MAP
    CheckError(),LONG
  END

sourceName        STRING(260)
targetName        STRING(260)
count             ULONG

SourceFile              FILE,DRIVER('TOPSPEED'),NAME(sourceName)
record                    RECORD
NAME                        STRING(20)
ADDRESS                     STRING(35)
CITY                        STRING(25)
STATE                       STRING(2)
ZIPCODE                     STRING(10)
PHONE                       STRING(10)
                          END
                        END

Company         FILE,DRIVER('TOPSPEED'),NAME('Company'),PRE(Company),CREATE,THREAD !Default company information
CompanyIDKey      KEY(Company:CompanyID),PRIMARY,NOCASE
record            RECORD
CompanyID           LONG
Name                STRING(20) !Company name
Address             STRING(35) !First line of company's address
City                STRING(25) !Company's city
State               STRING(2) !Company's state
Zipcode             STRING(10) !Company's zipcode
Phone               STRING(10) !Company's phone number
                  END
                END


PROGRESS WINDOW('Converting File'),AT(,,107,33),FONT('MS Sans Serif',8),GRAY,CENTER,DOUBLE
           STRING('Converting Record #:'),AT(4,13,,),USE(?ConvertStr)
           STRING('Building Keys'),AT(4,13,,),USE(?BuildStr),HIDE
           STRING(@n8),AT(74,12,24,12),USE(Count)
         END

  CODE
  sourceName = 'Company.tps'
  targetName = 'CONV0001'

  OPEN(SourceFile)
  IF CheckError() THEN RETURN END
  SET(SourceFile)
  CREATE(Company)
  IF CheckError() THEN RETURN END
  OPEN(Company)
  IF CheckError() THEN RETURN END

  STREAM(SourceFile)
  STREAM(Company)

  OPEN(Progress)

  LOOP
    NEXT(SourceFile)
    IF ErrorCode() = 33 THEN BREAK END
    DO AssignRecord
    APPEND(Company)
    IF CheckError() THEN RETURN END
    count += 1
    DISPLAY(?Count)
  END

  FLUSH(SourceFile)
  FLUSH(Company)

  HIDE(?ConvertStr)
  HIDE(?Count)
  UNHIDE(?BuildStr)
  DISPLAY()

  BUILD(Company)
  IF CheckError() THEN RETURN END
  CLOSE(SourceFile)
  CLOSE(Company)

  COPY(Company, 'Company')
  !REMOVE(Company)

AssignRecord      ROUTINE
  Company.Name = SourceFile.Name
  Company.Address = SourceFile.Address
  Company.City = SourceFile.City
  Company.State = SourceFile.State
  Company.Zipcode = SourceFile.Zipcode
  Company.Phone = SourceFile.Phone

CheckError        FUNCTION
  CODE
  IF ERRORCODE()
    IF ERRORCODE() = 90
      MESSAGE('File System Error: (' & FILEERRORCODE() & ') ' & FILEERROR())
      RETURN ERRORCODE()
    END
    MESSAGE('Error: ' & ERROR())
    RETURN ERRORCODE()
  END
  RETURN 0
