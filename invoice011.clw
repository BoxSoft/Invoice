

   MEMBER('invoice.clw')                                   ! This is a MEMBER module

!!! <summary>
!!! Generated from procedure template - Source
!!! Function to return CSZ
!!! </summary>
CityStateZip         PROCEDURE  (LOC:City,LOC:State,LOC:Zip) ! Declare Procedure

  CODE
 !Format City, State, and Zip
  IF OMITTED(1) OR LOC:City = ''
    RETURN(LOC:State &'  '& LOC:Zip)
  ELSIF OMITTED(2) OR LOC:State = ''
    RETURN(CLIP(LOC:City) &',  '& LOC:Zip)
  ELSIF OMITTED(3) OR LOC:Zip = ''
    RETURN(CLIP(LOC:City) &',  '& LOC:State)
  ELSE
    RETURN(CLIP(LOC:City) &', '& LOC:State &'  '& LOC:Zip)
  END

