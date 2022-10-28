!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_wall_viscous_iso_profile_2d in reverse (adjoint) mode (with options with!SliceDeadControl with!SliceDead
!Instrs with!StaticTaping):
!   gradient     of useful results: w twallprof rgaz gam
!   with respect to varying inputs: w twallprof rgaz gam
!   RW status of diff variables: w:in-out twallprof:incr rgaz:incr
!                gam:incr
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
SUBROUTINE BC_WALL_VISCOUS_ISO_PROFILE_2D_B(w, wb, twallprof, twallprofb&
& , loc, gam, gamb, rgaz, rgazb, interf, gh, im, jm, lm)
  IMPLICIT NONE
!
!
! Variable for dimension ------------------------------------------
  INTEGER, INTENT(IN) :: im, jm, lm
  INTEGER, INTENT(IN) :: gh
! Input variables -------------------------------------------------
  CHARACTER(len=3), INTENT(IN) :: loc
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: interf
  REAL*8, INTENT(IN) :: gam
  REAL*8 :: gamb
  REAL*8, INTENT(IN) :: rgaz
  REAL*8 :: rgazb
  REAL*8, DIMENSION(lm), INTENT(IN) :: twallprof
  REAL*8, DIMENSION(lm) :: twallprofb
! Returned variables ----------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wb
! Local variables -------------------------------------------------
  INTEGER :: da
  REAL*8 :: pe, roe, ue, ve, we
  REAL*8 :: peb, roeb, ueb, veb, web
  REAL*8 :: pi, roi, ui, vi, wi, ei, roiei, pw
  REAL*8 :: pib, roib, uib, vib, wib, roieib, pwb
  REAL*8 :: roem1, roe1m1
  REAL*8 :: roem1b, roe1m1b
  REAL*8 :: pe1, roe1, ue1, ve1, ve21, we1
  REAL*8 :: pe1b, roe1b, ue1b, ve1b, ve21b, we1b
  REAL*8 :: ve2, gami, gam1, ct0, ct1, third, four, half, one, two
  REAL*8 :: ve2b, gam1b
! -----------------------------------------------------------------
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  REAL*8 :: tempb
  REAL*8 :: temp
  REAL*8 :: tempb0
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
  lmin = 1
  IF (loc .EQ. 'Ilo') THEN
    ad_branch = 0
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    ad_branch = 1
    i0 = -1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Jlo') THEN
    ad_branch = 2
    j0 = 1
    lmax = imax - imin + 1
  ELSE IF (loc .EQ. 'Jhi') THEN
    ad_branch = 3
    j0 = -1
    lmax = imax - imin + 1
  ELSE
    ad_branch = 3
  END IF
!bid
  gam1 = gam - 1.d0
! 9/8
  ct0 = 1.125d0
!-1/8
  ct1 = -0.125d0
  third = 1.d0/3.d0
  four = 4.d0
  half = 0.5d0
  one = 1.d0
  two = 2.d0
  gam1b = 0.0_8
!$BWD-OF II-LOOP 
  DO l=lmin,lmax
    i = imin + (l-lmin)*j0*j0
    j = jmin + (l-lmin)*i0*i0
!
    roe = w(i, j, 1)
    roem1 = one/roe
    ue = w(i, j, 2)*roem1
    ve = w(i, j, 3)*roem1
    we = w(i, j, 4)*roem1
    ve2 = ue*ue + ve*ve + we*we
    pe = gam1*(w(i, j, 5)-half*roe*ve2)
!
    roe1 = w(i+i0, j+j0, 1)
    roe1m1 = one/roe1
    ue1 = w(i+i0, j+j0, 2)*roe1m1
    ve1 = w(i+i0, j+j0, 3)*roe1m1
    we1 = w(i+i0, j+j0, 4)*roe1m1
    ve21 = ue1*ue1 + ve1*ve1 + we1*we1
    pe1 = gam1*(w(i+i0, j+j0, 5)-half*roe1*ve21)
!
! extrap dp/dn = 0 o2
    pw = ct0*pe + ct1*pe1
!! pw = pe
!!
!! ???
    roi = two*pw/(rgaz*twallprof(l)) - roe
! pi = pw
    pi = third*(four*pw-pe)
! roi = (pi/pe*roe**gam )**gami
!
    roiei = pi/gam1
!
    ui = -ue
    vi = -ve
    wi = -we
!
! roi = roe
! pi = pe
! roiei = pi/gam1 + HALF*roi*(ui*ui+vi*vi+wi*wi)
    DO de=1,gh
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 1))
      w(i-de*i0, j-de*j0, 1) = roi
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 2))
      w(i-de*i0, j-de*j0, 2) = roi*ui
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 3))
      w(i-de*i0, j-de*j0, 3) = roi*vi
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 4))
      w(i-de*i0, j-de*j0, 4) = roi*wi
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 5))
      w(i-de*i0, j-de*j0, 5) = roiei + half*roi*(ui*ui+vi*vi+wi*wi)
!
! roi = w(i+de*i0,j+de*j0,1)
! roem1 = ONE/roi
      da = de - 1
      CALL PUSHREAL8(roi)
      roi = two*w(i-de*i0, j-de*j0, 1) - w(i-da*i0, j-da*j0, 1)
      CALL PUSHREAL8(roem1)
      roem1 = one/w(i+de*i0, j+de*j0, 1)
      CALL PUSHREAL8(ue1)
      ue1 = w(i+de*i0, j+de*j0, 2)*roem1
      CALL PUSHREAL8(ve1)
      ve1 = w(i+de*i0, j+de*j0, 3)*roem1
      CALL PUSHREAL8(we1)
      we1 = w(i+de*i0, j+de*j0, 4)*roem1
! ve21 = ue1*ue1 + ve1*ve1 + we1*we1
! roiei = w(i+de*i0,j+de*j0,5)
      CALL PUSHREAL8(ui)
      ui = -ue1
      CALL PUSHREAL8(vi)
      vi = -ve1
      CALL PUSHREAL8(wi)
      wi = -we1
    END DO
    roib = 0.0_8
    uib = 0.0_8
    roieib = 0.0_8
    vib = 0.0_8
    wib = 0.0_8
    DO de=gh,1,-1
      CALL POPREAL8(wi)
      we1b = -wib
      CALL POPREAL8(vi)
      ve1b = -vib
      CALL POPREAL8(ui)
      ue1b = -uib
      CALL POPREAL8(we1)
      wb(i+de*i0, j+de*j0, 4) = wb(i+de*i0, j+de*j0, 4) + roem1*we1b
      roem1b = w(i+de*i0, j+de*j0, 4)*we1b + w(i+de*i0, j+de*j0, 3)*ve1b&
&       + w(i+de*i0, j+de*j0, 2)*ue1b
      CALL POPREAL8(ve1)
      wb(i+de*i0, j+de*j0, 3) = wb(i+de*i0, j+de*j0, 3) + roem1*ve1b
      CALL POPREAL8(ue1)
      wb(i+de*i0, j+de*j0, 2) = wb(i+de*i0, j+de*j0, 2) + roem1*ue1b
      CALL POPREAL8(roem1)
      temp = w(i+de*i0, j+de*j0, 1)
      wb(i+de*i0, j+de*j0, 1) = wb(i+de*i0, j+de*j0, 1) - one*roem1b/&
&       temp**2
      da = de - 1
      CALL POPREAL8(roi)
      wb(i-de*i0, j-de*j0, 1) = wb(i-de*i0, j-de*j0, 1) + two*roib
      wb(i-da*i0, j-da*j0, 1) = wb(i-da*i0, j-da*j0, 1) - roib
      CALL POPREAL8(w(i-de*i0, j-de*j0, 5))
      roieib = roieib + wb(i-de*i0, j-de*j0, 5)
      roib = (ui**2+vi**2+wi**2)*half*wb(i-de*i0, j-de*j0, 5) + wi*wb(i-&
&       de*i0, j-de*j0, 4) + vi*wb(i-de*i0, j-de*j0, 3) + ui*wb(i-de*i0&
&       , j-de*j0, 2) + wb(i-de*i0, j-de*j0, 1)
      tempb0 = roi*half*wb(i-de*i0, j-de*j0, 5)
      wb(i-de*i0, j-de*j0, 5) = 0.0_8
      uib = 2*ui*tempb0 + roi*wb(i-de*i0, j-de*j0, 2)
      vib = 2*vi*tempb0 + roi*wb(i-de*i0, j-de*j0, 3)
      wib = 2*wi*tempb0 + roi*wb(i-de*i0, j-de*j0, 4)
      CALL POPREAL8(w(i-de*i0, j-de*j0, 4))
      wb(i-de*i0, j-de*j0, 4) = 0.0_8
      CALL POPREAL8(w(i-de*i0, j-de*j0, 3))
      wb(i-de*i0, j-de*j0, 3) = 0.0_8
      CALL POPREAL8(w(i-de*i0, j-de*j0, 2))
      wb(i-de*i0, j-de*j0, 2) = 0.0_8
      CALL POPREAL8(w(i-de*i0, j-de*j0, 1))
      wb(i-de*i0, j-de*j0, 1) = 0.0_8
    END DO
    tempb = two*roib/(rgaz*twallprof(l))
    pib = roieib/gam1
    pwb = four*third*pib + tempb
    peb = ct0*pwb - third*pib
    tempb0 = -(pw*tempb/(rgaz*twallprof(l)))
    pe1b = ct1*pwb
    tempb = gam1*pe1b
    wb(i+i0, j+j0, 5) = wb(i+i0, j+j0, 5) + tempb
    ve21b = -(roe1*half*tempb)
    ue1b = 2*ue1*ve21b
    ve1b = 2*ve1*ve21b
    we1b = 2*we1*ve21b
    roe1m1b = w(i+i0, j+j0, 4)*we1b + w(i+i0, j+j0, 3)*ve1b + w(i+i0, j+&
&     j0, 2)*ue1b
    roe1b = -(ve21*half*tempb) - one*roe1m1b/roe1**2
    tempb = gam1*peb
    ve2b = -(roe*half*tempb)
    web = 2*we*ve2b - wib
    veb = 2*ve*ve2b - vib
    ueb = 2*ue*ve2b - uib
    gam1b = gam1b + (w(i+i0, j+j0, 5)-half*(roe1*ve21))*pe1b - pi*roieib&
&     /gam1**2 + (w(i, j, 5)-half*(roe*ve2))*peb
    rgazb = rgazb + twallprof(l)*tempb0
    twallprofb(l) = twallprofb(l) + rgaz*tempb0
    wb(i+i0, j+j0, 4) = wb(i+i0, j+j0, 4) + roe1m1*we1b
    wb(i+i0, j+j0, 3) = wb(i+i0, j+j0, 3) + roe1m1*ve1b
    wb(i+i0, j+j0, 2) = wb(i+i0, j+j0, 2) + roe1m1*ue1b
    wb(i+i0, j+j0, 1) = wb(i+i0, j+j0, 1) + roe1b
    wb(i, j, 5) = wb(i, j, 5) + tempb
    wb(i, j, 4) = wb(i, j, 4) + roem1*web
    roem1b = w(i, j, 4)*web + w(i, j, 3)*veb + w(i, j, 2)*ueb
    roeb = -roib - ve2*half*tempb - one*roem1b/roe**2
    wb(i, j, 3) = wb(i, j, 3) + roem1*veb
    wb(i, j, 2) = wb(i, j, 2) + roem1*ueb
    wb(i, j, 1) = wb(i, j, 1) + roeb
  END DO
  gamb = gamb + gam1b
END SUBROUTINE BC_WALL_VISCOUS_ISO_PROFILE_2D_B
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

