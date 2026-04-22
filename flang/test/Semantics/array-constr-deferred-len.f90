! RUN: %python %S/test_errors.py %s %flang_fc1
! Test for checking zero-sized array constructor with deferred-length character
! type parameter should be valid when the length does not depend on the
! implied DO variable.
program deferred_type_parameter_array_constructor
  character(:), pointer :: a
  character(:), allocatable :: b
  allocate(a, source="ok!")
  allocate(b, source="fine")
  print *, [(a,i=1,0)] ! ok; deferred-length pointer
  print *, [(b,i=1,0)] ! ok; deferred-length allocatable
  !ERROR: Array constructor implied DO loop has no iterations and indeterminate character length
  print *, [(a(1:i),i=1,0)]
end program
