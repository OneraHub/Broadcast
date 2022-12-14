!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of jn_match_geom_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!St
!aticTaping):
!   variations   of useful results: wr
!   with respect to varying inputs: wd
!   RW status of diff variables: wr:out wd:in
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
! =============================================================================
! Join match 2-D
! =============================================================================
SUBROUTINE JN_MATCH_GEOM_2D_D(wr, wrd, prr, gh1r, gh2r, gh3r, gh4r, imr&
& , jmr, wd, wdd, prd, gh1d, gh2d, gh3d, gh4d, imd, jmd, tr)
  IMPLICIT NONE
!
! Variables for dimension -----------------------------------------
  INTEGER, INTENT(IN) :: imr, jmr, imd, jmd
  INTEGER, INTENT(IN) :: gh1r, gh2r, gh3r, gh4r
  INTEGER, INTENT(IN) :: gh1d, gh2d, gh3d, gh4d
! Input variables -------------------------------------------------
  REAL*8, DIMENSION(1-gh1d:imd+gh2d, 1-gh3d:jmd+gh4d), INTENT(IN) :: wd
  REAL*8, DIMENSION(1-gh1d:imd+gh2d, 1-gh3d:jmd+gh4d), INTENT(IN) :: wdd
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: prr, prd
  INTEGER, DIMENSION(2), INTENT(IN) :: tr
! Output variables ------------------------------------------------
  REAL*8, DIMENSION(1-gh1r:imr+gh2r, 1-gh3r:jmr+gh4r), INTENT(INOUT) :: &
& wr
  REAL*8, DIMENSION(1-gh1r:imr+gh2r, 1-gh3r:jmr+gh4r), INTENT(INOUT) :: &
& wrd
! Local variables -------------------------------------------------
  INTEGER, POINTER :: ind1, ind2
  INTEGER :: ir, jr
  INTEGER, TARGET :: id, jd
  INTEGER :: istep, jstep, idir, jdir, idd, jdd, i, j
  INTEGER :: i1, i2, j1, j2
  INTRINSIC SIGN
  INTRINSIC ABS
! -----------------------------------------------------------------
  istep = SIGN(1, tr(1))
  jstep = SIGN(1, tr(2))
  IF (tr(1) .GE. 0.) THEN
    idir = tr(1)
  ELSE
    idir = -tr(1)
  END IF
  IF (tr(2) .GE. 0.) THEN
    jdir = tr(2)
  ELSE
    jdir = -tr(2)
  END IF
!
  IF (istep .EQ. 1) THEN
    i1 = 1
    i2 = prd(2, idir) - prd(1, idir) + 1
  ELSE
    i1 = prd(2, idir) - prd(1, idir) + 1
    i2 = 1
  END IF
!
  IF (jstep .EQ. 1) THEN
    j1 = 1
    j2 = prd(2, jdir) - prd(1, jdir) + 1
  ELSE
    j1 = prd(2, jdir) - prd(1, jdir) + 1
    j2 = 1
  END IF
!
  IF (idir .EQ. 1) THEN
    ind1 => id
    ind2 => jd
  ELSE IF (idir .EQ. 2) THEN
    ind1 => jd
    ind2 => id
  END IF
!
  idd = 1
  jdd = 1
  wrd = 0.0_8
!
  DO j=j1,j2,jstep
    DO i=i1,i2,istep
      ir = prr(1, 1) + idd - 1
      jr = prr(1, 2) + jdd - 1
      wrd(ir, jr) = wdd(ind1, ind2)
      idd = idd + 1
    END DO
    idd = 1
    jdd = jdd + 1
  END DO
END SUBROUTINE JN_MATCH_GEOM_2D_D

