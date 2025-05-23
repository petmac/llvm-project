! REQUIRES: openmp_runtime

! RUN: %python %S/../test_errors.py %s %flang_fc1 %openmp_flags -fopenmp-version=50

! 2.17.8 Flush construct [OpenMP 5.0]
!        memory-order-clause ->
!                               acq_rel
!                               release
!                               acquire
use omp_lib
  implicit none

  integer :: i, a, b
  real, DIMENSION(10) :: array

  a = 1.0
  !$omp parallel num_threads(4)
  !Only memory-order-clauses.
  if (omp_get_thread_num() == 1) then
    ! Allowed clauses.
    !$omp flush acq_rel
    array = (/1, 2, 3, 4, 5, 6, 7, 8, 9, 10/)
    !$omp flush release
    array = (/1, 2, 3, 4, 5, 6, 7, 8, 9, 10/)
    !$omp flush acquire

    !ERROR: PRIVATE clause is not allowed on the FLUSH directive
    !$omp flush private(array)
    !ERROR: NUM_THREADS clause is not allowed on the FLUSH directive
    !$omp flush num_threads(4)

    ! Mix allowed and not allowed clauses.
    !ERROR: NUM_THREADS clause is not allowed on the FLUSH directive
    !$omp flush num_threads(4) acquire
  end if
  !$omp end parallel
end

