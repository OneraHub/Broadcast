!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_extrapolate_o3_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs wit
!h!StaticTaping):
!   variations   of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
SUBROUTINE BC_EXTRAPOLATE_O3_2D_D(w, wd, loc, interf, im, jm, gh, em)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: im, jm, gh, em
  CHARACTER(len=3), INTENT(IN) :: loc
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: interf
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: wd
! Local variables -----------------------------------------------------------
  INTEGER :: d1, d2, d3
  REAL*8 :: three
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
! ---------------------------------------------------------------------------
!
  imin = interf(1, 1)
  jmin = interf(1, 2)
  imax = interf(2, 1)
  jmax = interf(2, 2)
! write(200,*) loc, 'imin = ', interf(1,1)
! write(200,*) loc, 'jmin = ', interf(1,2)
! write(200,*) loc, 'imax = ', interf(2,1)
! write(200,*) loc, 'jmax = ', interf(2,2)
  i0 = 0
  j0 = 0
  lmin = 1
  IF (loc .EQ. 'Ilo') THEN
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    i0 = -1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Jlo') THEN
    j0 = 1
    lmax = imax - imin + 1
  ELSE IF (loc .EQ. 'Jhi') THEN
    j0 = -1
    lmax = imax - imin + 1
  END IF
  three = 3.d0
  DO l=lmin,lmax
    i = imin + (l-lmin)*j0*j0
    j = jmin + (l-lmin)*i0*i0
    DO de=1,gh
      d1 = de - 1
      d2 = de - 2
      d3 = de - 3
!ordre 3
      wd(i-i0*de, j-j0*de, :) = three*wd(i-i0*d1, j-j0*d1, :) - three*wd&
&       (i-i0*d2, j-j0*d2, :) + wd(i-i0*d3, j-j0*d3, :)
    END DO
  END DO
END SUBROUTINE BC_EXTRAPOLATE_O3_2D_D

