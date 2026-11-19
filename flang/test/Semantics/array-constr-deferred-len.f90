! RUN: %python %S/test_errors.py %s %flang_fc1
! F'2023 7.8 p5: the length of the ac-value of a zero-trip ac-implied-do must
! not depend on the ac-do-variable or on the value of a non-constant
! expression.  The length of a deferred-length or assumed-length variable is a
! type parameter, not the value of an expression.
subroutine test(a, r, s, n)
  character(:), pointer :: a
  character(:), allocatable :: b
  character(*) :: r, s
  print *, [(a,i=1,0)] ! ok
  print *, [(b,i=1,0)] ! ok
  print *, [(r,i=1,0)] ! ok
  print *, [(a,i=1,0),(a,j=1,0)] ! ok
  print *, [(r,i=1,0),(r,j=1,3)] ! ok
  !ERROR: Array constructor implied DO loop has no iterations and indeterminate character length
  print *, [(a(1:i),i=1,0)]
  !ERROR: Array constructor implied DO loop has no iterations and indeterminate character length
  print *, [(a(1:n),i=1,0)]
  !ERROR: Array constructor implied DO loop has no iterations and indeterminate character length
  print *, [((a(1:i),i=1,3),j=1,0)]
  !ERROR: Array constructor implied DO loop has no iterations and indeterminate character length
  print *, [(r,i=1,0),(s,j=1,0)]
end
