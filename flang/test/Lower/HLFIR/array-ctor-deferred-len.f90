! RUN: bbc -emit-hlfir -o - %s | FileCheck %s
! Character array constructors without type-spec and with non-constant lengths.

! The length of a zero-trip constructor comes from the ac-value.
subroutine test_zero_trip(a)
  character(:), allocatable :: a
  call takes_char([(a, i=1,0)])
end subroutine
! CHECK-LABEL: func.func @_QPtest_zero_trip(
! CHECK:  fir.box_elesize
! CHECK:  %[[LEN:.*]] = fir.convert %{{.*}} : (i64) -> index
! CHECK:  hlfir.elemental %{{.*}} typeparams %[[LEN]]
! CHECK-NOT: _FortranAInitArrayConstructorVector

! Distinct lengths are taken from each value at runtime.
subroutine test_distinct_lengths(r, s)
  character(len=*) :: r, s
  call takes_char((/ r, s /))
end subroutine
! CHECK-LABEL: func.func @_QPtest_distinct_lengths(
! CHECK:  %[[USE_VALUE_LEN:.*]] = arith.constant true
! CHECK:  fir.call @_FortranAInitArrayConstructorVector(%{{.*}}, %{{.*}}, %[[USE_VALUE_LEN]], %{{.*}})

subroutine test_distinct_lengths_implied_do(r, s, n)
  character(len=*) :: r, s
  call takes_char([(r, s, i=1,n)])
end subroutine
! CHECK-LABEL: func.func @_QPtest_distinct_lengths_implied_do(
! CHECK:  %[[USE_VALUE_LEN:.*]] = arith.constant true
! CHECK:  fir.call @_FortranAInitArrayConstructorVector(%{{.*}}, %{{.*}}, %[[USE_VALUE_LEN]], %{{.*}})
