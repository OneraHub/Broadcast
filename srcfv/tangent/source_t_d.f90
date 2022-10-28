!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of source_t_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!StaticT
!aping):
!   variations   of useful results: res
!   with respect to varying inputs: w
!   RW status of diff variables: res:out w:in
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/
! add source term due to time integration at 2nd order (for Gear, BDF2 algo)
SUBROUTINE SOURCE_T_2D_D(res, resd, w, wd, w_save, dwr, phi, dt, dtloc, &
& vol, gh, im, jm, em)
  IMPLICIT NONE
!
!
! variables for dimension ---------------------------------------------------
  INTEGER, INTENT(IN) :: im, jm, em, gh
! required arguments --------------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: w, w_save&
& , dwr
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: wd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh), INTENT(IN) :: vol
  REAL*8, INTENT(IN) :: phi, dt, dtloc
! returned objects ----------------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: res
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: resd
! local variables -----------------------------------------------------------
  INTEGER :: i, j
  REAL*8 :: dtm1, dtlocm1, one
! ---------------------------------------------------------------------------
  one = 1.d0
  dtm1 = (one+phi)/dt
  resd = 0.0_8
  DO j=1-gh,jm+gh
    DO i=1-gh,im+gh
!
!ts(:,i,j) = (ONE/dt)*( (ONE+phi)*( w(:,i,j)-w_save(:,i,j) ) &
!                       -      phi *  dwr(:,i,j) &
!                     )
!
      resd(i, j, :) = resd(i, j, :) - vol(i, j)*dtm1*wd(i, j, :)
    END DO
  END DO
END SUBROUTINE SOURCE_T_2D_D

