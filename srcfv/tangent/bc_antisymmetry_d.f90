!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_antisymmetry_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!
!StaticTaping):
!   variations   of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
! =============================================================================
! BC symmetry 2D
! =============================================================================
SUBROUTINE BC_ANTISYMMETRY_2D_D(w, wd, loc, interf, nx, ny, gh, im, jm)
  IMPLICIT NONE
! Variables for dimension ---------------------------------------------------
  INTEGER, INTENT(IN) :: im, jm
  INTEGER, INTENT(IN) :: gh
! Input variables -----------------------------------------------------------
  CHARACTER(len=3), INTENT(IN) :: loc
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: interf
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: nx
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: ny
! Output variables ----------------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wd
! Local variables -------------------------------------------------
  INTEGER :: da, i1, j1
  REAL*8 :: one, two, half, nsum, nsumi, nxnorm, nynorm, nxloc, nyloc, &
& sens
  REAL*8 :: rho, rhoinv, velx, vely, veln
  REAL*8 :: rhod, rhoinvd, velxd, velyd, velnd
! -----------------------------------------------------------------
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC FLOAT
  INTRINSIC SQRT
  REAL*8 :: arg1
  REAL*8 :: temp
  REAL*8 :: temp0
  REAL*8 :: temp1
  REAL*8 :: temp2
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
  high = 0
  lmin = 1
  IF (loc .EQ. 'Ilo') THEN
    kdir = 1
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    kdir = 1
    i0 = -1
    lmax = jmax - jmin + 1
    high = 1
  ELSE IF (loc .EQ. 'Jlo') THEN
    kdir = 2
    j0 = 1
    lmax = imax - imin + 1
  ELSE IF (loc .EQ. 'Jhi') THEN
    kdir = 2
    j0 = -1
    lmax = imax - imin + 1
    high = 1
  END IF
  one = 1.d0
  two = 2.d0
  half = 0.5d0
  sens = FLOAT(i0 + j0)
!
  i1 = i0*i0
  j1 = j0*j0
  DO l=lmin,lmax
    i = imin + (l-lmin)*j0*j0
    j = jmin + (l-lmin)*i0*i0
! write(1200,*) ' '
! write(1200,*) ' =====================', j
    nxloc = nx(i+high*i1, j+high*j1, kdir)
    nyloc = ny(i+high*i1, j+high*j1, kdir)
! highis used to select the last normal when the face is of type *hi
    arg1 = nxloc*nxloc + nyloc*nyloc
    nsum = SQRT(arg1)
    nsumi = one/nsum
    nxnorm = nxloc*nsumi*sens
    nynorm = nyloc*nsumi*sens
!
    DO de=1,gh
      da = de - 1
!
      rhod = wd(i+da*i0, j+da*j0, 1)
      rho = w(i+da*i0, j+da*j0, 1)
      rhoinvd = -(one*rhod/rho**2)
      rhoinv = one/rho
      temp = w(i+da*i0, j+da*j0, 2)
      velxd = rhoinv*wd(i+da*i0, j+da*j0, 2) + temp*rhoinvd
      velx = temp*rhoinv
      temp = w(i+da*i0, j+da*j0, 3)
      velyd = rhoinv*wd(i+da*i0, j+da*j0, 3) + temp*rhoinvd
      vely = temp*rhoinv
! veln = ( velx*nxloc + vely*nyloc ) * nsumi
      velnd = nxnorm*velxd + nynorm*velyd
      veln = velx*nxnorm + vely*nynorm
!
! velx = velx - TWO * veln * nxloc*nsumi
      velxd = velxd - two*nxnorm*velnd
      velx = velx - two*veln*nxnorm
! vely = vely - TWO * veln * nyloc*nsumi
      velyd = velyd - two*nynorm*velnd
      vely = vely - two*veln*nynorm
!
      wd(i-de*i0, j-de*j0, 1) = -rhod
      w(i-de*i0, j-de*j0, 1) = -rho
      wd(i-de*i0, j-de*j0, 2) = -(velx*rhod+rho*velxd)
      w(i-de*i0, j-de*j0, 2) = -(rho*velx)
      wd(i-de*i0, j-de*j0, 3) = vely*rhod + rho*velyd
      w(i-de*i0, j-de*j0, 3) = rho*vely
      temp = w(i+da*i0, j+da*j0, 1)
      temp0 = (w(i+da*i0, j+da*j0, 2)*w(i+da*i0, j+da*j0, 2)+w(i+da*i0, &
&       j+da*j0, 3)*w(i+da*i0, j+da*j0, 3))/temp
      temp1 = w(i-de*i0, j-de*j0, 1)
      temp2 = (w(i-de*i0, j-de*j0, 2)*w(i-de*i0, j-de*j0, 2)+w(i-de*i0, &
&       j-de*j0, 3)*w(i-de*i0, j-de*j0, 3))/temp1
      wd(i-de*i0, j-de*j0, 5) = half*(2*w(i+da*i0, j+da*j0, 2)*wd(i+da*&
&       i0, j+da*j0, 2)+2*w(i+da*i0, j+da*j0, 3)*wd(i+da*i0, j+da*j0, 3)&
&       -temp0*wd(i+da*i0, j+da*j0, 1))/temp - wd(i+da*i0, j+da*j0, 5) -&
&       half*(2*w(i-de*i0, j-de*j0, 2)*wd(i-de*i0, j-de*j0, 2)+2*w(i-de*&
&       i0, j-de*j0, 3)*wd(i-de*i0, j-de*j0, 3)-temp2*wd(i-de*i0, j-de*&
&       j0, 1))/temp1
      w(i-de*i0, j-de*j0, 5) = half*temp0 - w(i+da*i0, j+da*j0, 5) - &
&       half*temp2
    END DO
  END DO
END SUBROUTINE BC_ANTISYMMETRY_2D_D
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

