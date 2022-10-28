!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_symmetry_2d in reverse (adjoint) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!Stat
!icTaping):
!   gradient     of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
! =============================================================================
! BC symmetry 2D
! =============================================================================
SUBROUTINE BC_SYMMETRY_2D_B(w, wb, loc, interf, nx, ny, gh, im, jm)
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
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wb
! Local variables -------------------------------------------------
  INTEGER :: da, i1, j1
  REAL*8 :: one, two, half, nsum, nsumi, nxnorm, nynorm, nxloc, nyloc, &
& sens
  REAL*8 :: rho, rhoinv, velx, vely, veln
  REAL*8 :: rhob, rhoinvb, velxb, velyb, velnb
! -----------------------------------------------------------------
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC FLOAT
  INTRINSIC SQRT
  REAL*8 :: tmp
  REAL*8 :: tmpb
  REAL*8 :: temp
  REAL*8 :: tempb
  REAL*8 :: temp0
  REAL*8 :: temp1
  REAL*8 :: temp2
  REAL*8 :: tempb0
  REAL*8 :: temp3
  REAL*8 :: temp4
  INTEGER :: ad_branch
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
    ad_branch = 0
    kdir = 1
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    ad_branch = 1
    kdir = 1
    i0 = -1
    lmax = jmax - jmin + 1
    high = 1
  ELSE IF (loc .EQ. 'Jlo') THEN
    ad_branch = 2
    kdir = 2
    j0 = 1
    lmax = imax - imin + 1
  ELSE IF (loc .EQ. 'Jhi') THEN
    ad_branch = 3
    kdir = 2
    j0 = -1
    lmax = imax - imin + 1
    high = 1
  ELSE
    ad_branch = 3
  END IF
  one = 1.d0
  two = 2.d0
  half = 0.5d0
  sens = FLOAT(i0 + j0)
!
  i1 = i0*i0
  j1 = j0*j0
!$BWD-OF II-LOOP 
  DO l=lmin,lmax
    i = imin + (l-lmin)*j0*j0
    j = jmin + (l-lmin)*i0*i0
! write(1200,*) ' '
! write(1200,*) ' =====================', j
    nxloc = nx(i+high*i1, j+high*j1, kdir)
    nyloc = ny(i+high*i1, j+high*j1, kdir)
! highis used to select the last normal when the face is of type *hi
    nsum = SQRT(nxloc*nxloc + nyloc*nyloc)
    nsumi = one/nsum
    nxnorm = nxloc*nsumi*sens
    nynorm = nyloc*nsumi*sens
!
    DO de=1,gh
      da = de - 1
!
      CALL PUSHREAL8(rho)
      rho = w(i+da*i0, j+da*j0, 1)
      rhoinv = one/rho
      CALL PUSHREAL8(velx)
      velx = w(i+da*i0, j+da*j0, 2)*rhoinv
      CALL PUSHREAL8(vely)
      vely = w(i+da*i0, j+da*j0, 3)*rhoinv
! veln = ( velx*nxloc + vely*nyloc ) * nsumi
      veln = velx*nxnorm + vely*nynorm
!
! velx = velx - TWO * veln * nxloc*nsumi
      velx = velx - two*veln*nxnorm
! vely = vely - TWO * veln * nyloc*nsumi
      vely = vely - two*veln*nynorm
!
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 1))
      w(i-de*i0, j-de*j0, 1) = rho
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 2))
      w(i-de*i0, j-de*j0, 2) = rho*velx
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 3))
      w(i-de*i0, j-de*j0, 3) = rho*vely
      tmp = w(i+da*i0, j+da*j0, 5) - half*(w(i+da*i0, j+da*j0, 2)**2+w(i&
&       +da*i0, j+da*j0, 3)**2)/w(i+da*i0, j+da*j0, 1) + half*(w(i-de*i0&
&       , j-de*j0, 2)**2+w(i-de*i0, j-de*j0, 3)**2)/w(i-de*i0, j-de*j0, &
&       1)
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 5))
      w(i-de*i0, j-de*j0, 5) = tmp
    END DO
    DO de=gh,1,-1
      da = de - 1
      CALL POPREAL8(w(i-de*i0, j-de*j0, 5))
      tmpb = wb(i-de*i0, j-de*j0, 5)
      wb(i-de*i0, j-de*j0, 5) = 0.0_8
      temp = w(i+da*i0, j+da*j0, 1)
      temp0 = w(i+da*i0, j+da*j0, 2)
      temp1 = w(i+da*i0, j+da*j0, 3)
      temp2 = w(i-de*i0, j-de*j0, 1)
      temp3 = w(i-de*i0, j-de*j0, 2)
      temp4 = w(i-de*i0, j-de*j0, 3)
      wb(i+da*i0, j+da*j0, 5) = wb(i+da*i0, j+da*j0, 5) + tmpb
      tempb = -(half*tmpb/temp)
      tempb0 = half*tmpb/temp2
      wb(i-de*i0, j-de*j0, 2) = wb(i-de*i0, j-de*j0, 2) + 2*temp3*tempb0
      wb(i-de*i0, j-de*j0, 3) = wb(i-de*i0, j-de*j0, 3) + 2*temp4*tempb0
      wb(i-de*i0, j-de*j0, 1) = wb(i-de*i0, j-de*j0, 1) - (temp3**2+&
&       temp4**2)*tempb0/temp2
      wb(i+da*i0, j+da*j0, 2) = wb(i+da*i0, j+da*j0, 2) + 2*temp0*tempb
      wb(i+da*i0, j+da*j0, 3) = wb(i+da*i0, j+da*j0, 3) + 2*temp1*tempb
      wb(i+da*i0, j+da*j0, 1) = wb(i+da*i0, j+da*j0, 1) - (temp0**2+&
&       temp1**2)*tempb/temp
      CALL POPREAL8(w(i-de*i0, j-de*j0, 3))
      velyb = rho*wb(i-de*i0, j-de*j0, 3)
      CALL POPREAL8(w(i-de*i0, j-de*j0, 2))
      velxb = rho*wb(i-de*i0, j-de*j0, 2)
      CALL POPREAL8(w(i-de*i0, j-de*j0, 1))
      rhoinv = one/rho
      velnb = -(two*nynorm*velyb) - two*nxnorm*velxb
      velxb = velxb + nxnorm*velnb
      velyb = velyb + nynorm*velnb
      rhoinvb = w(i+da*i0, j+da*j0, 3)*velyb + w(i+da*i0, j+da*j0, 2)*&
&       velxb
      rhob = vely*wb(i-de*i0, j-de*j0, 3) + velx*wb(i-de*i0, j-de*j0, 2)&
&       + wb(i-de*i0, j-de*j0, 1) - one*rhoinvb/rho**2
      wb(i-de*i0, j-de*j0, 3) = 0.0_8
      wb(i-de*i0, j-de*j0, 2) = 0.0_8
      wb(i-de*i0, j-de*j0, 1) = 0.0_8
      CALL POPREAL8(vely)
      wb(i+da*i0, j+da*j0, 3) = wb(i+da*i0, j+da*j0, 3) + rhoinv*velyb
      CALL POPREAL8(velx)
      wb(i+da*i0, j+da*j0, 2) = wb(i+da*i0, j+da*j0, 2) + rhoinv*velxb
      CALL POPREAL8(rho)
      wb(i+da*i0, j+da*j0, 1) = wb(i+da*i0, j+da*j0, 1) + rhob
    END DO
  END DO
END SUBROUTINE BC_SYMMETRY_2D_B
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

