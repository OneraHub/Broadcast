! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of function_5p_dz2 in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!Sta
!ticTaping):
!   variations   of useful results: func0 func1 func2 func3
!   with respect to varying inputs: w
!   RW status of diff variables: func0:out func1:out func2:out
!                w:in func3:out
! =============================================================================
! consistent fluxes for DNC3 2D
! =============================================================================
!
SUBROUTINE FUNCTION_5P_DZ2_D(func0, func0d, func1, func1d, func2, func2d&
& , func3, func3d, w, wd, x0, y0, nx, ny, xc, yc, vol, volf, gh, cp, cv&
& , prandtl, gam, rgaz, cs, muref, tref, s_suth, im, jm)
  IMPLICIT NONE
!
! variables for dimension -----------------------------------------
  INTEGER :: im, jm, gh
! required arguments ----------------------------------------------
! thermo
  REAL*8, INTENT(IN) :: cp, cv, prandtl, gam, rgaz
! viscosity
  REAL*8, INTENT(IN) :: cs, muref, tref, s_suth
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1), INTENT(IN) :: x0
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1), INTENT(IN) :: y0
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: nx
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: ny
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh), INTENT(IN) :: xc
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh), INTENT(IN) :: yc
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh), INTENT(IN) :: vol
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2), INTENT(IN) :: volf
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(IN) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(IN) :: wd
! Returned objects ------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func0d
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func1
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func1d
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func2
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func2d
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func3
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: func3d
! Non-required arguments -------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 5, 2) :: hn
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5) :: f, g
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: velx
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: velxd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: vely
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: velyd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: velz
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: velzd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tloc
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tlocd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: p
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: mu
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2) :: gradu, gradv, gradw, &
& gradmu
  REAL*8, DIMENSION(5) :: deltar, deltal, t
  INTEGER :: i, j, h
  REAL*8 :: nx_n, nx_s, nx_e, nx_o, volm1, ux, vx, wx, tx
  REAL*8 :: ny_n, ny_s, ny_e, ny_o, uy, vy, wy, ty
  REAL*8 :: val_n, val_s, val_e, val_o
  REAL*8 :: fxro1, fxro2, fxrou1, fxrou2, fxrov1, fxrov2, fxrow1, fxrow2&
& , fxroe1, fxroe2
  REAL*8 :: dissro1, dissro2, dissrou1, dissrou2, dissrov1, dissrov2, &
& dissrow1, dissrow2, dissroe1, dissroe2
  REAL*8 :: fvro1, fvro2, fvrou1, fvrou2, fvrov1, fvrov2, fvrow1, fvrow2&
& , fvroe1, fvroe2
  REAL*8 :: gvro1, gvro2, gvrou1, gvrou2, gvrov1, gvrov2, gvrow1, gvrow2&
& , gvroe1, gvroe2
  REAL*8 :: cpprandtl, mmu, lambda, uu, vv, ww, ro, rom1, htot, eloc, ec
  REAL*8 :: rod, rom1d, elocd, ecd
  REAL*8 :: predro1, predrou1, predrov1, predrow1, predroe1, eps2, eps4
  REAL*8 :: predro2, predrou2, predrov2, predrow2, predroe2, rspec
  REAL*8 :: divu2, vort2, dx, dy, dxm1, dym1, dxm2, dym2
  REAL*8 :: gui, gvi, gwi, gmui
  REAL*8 :: guj, gvj, gwj, gmuj
  REAL*8 :: rhom, rhomr, rhoml, rhom1l, c2l, c2r, rr, r, u, ur, ul, vr, &
& vl, wr, wl, c2x, nx2, ny2
  REAL*8 :: ab, sq, ducros1, ducros2, k_sensor1, k_sensor2
  REAL*8 :: b1, b2, b3, b4, b5, c1, c2, c3, c4, c5, wiggle, denom, betas
  REAL*8 :: nxloc, nyloc, sn, invsn, sc1, sc2
  REAL*8 :: d1, d2
  REAL*8 :: c3d0, c3d1
  REAL*8 :: pw, ct0, ct1, ct2, cvm1
  REAL*8 :: coef, omrr, test, diffro, diffrou, diffrov, diffrow, diffroe&
& , v
  REAL*8 :: half, one, zero, two, twothird, fourth, twelfth
  REAL*8 :: twentyfourth, ccross
  INTRINSIC SQRT
  REAL*8 :: result1
  REAL*8 :: temp
! -----------------------------------------------------------------
!
  half = 0.5d0
  one = 1.d0
  cvm1 = one/cv
! Coef for grad o4
! Primitives
! for Sutherland
  velxd = 0.0_8
  velyd = 0.0_8
  velzd = 0.0_8
  tlocd = 0.0_8
  DO j=1-gh,jm+gh
!DIR$ IVDEP
    DO i=1-gh,im+gh
      rod = wd(i, j, 1)
      ro = w(i, j, 1)
      rom1d = -(one*rod/ro**2)
      rom1 = one/ro
      velxd(i, j) = rom1*wd(i, j, 2) + w(i, j, 2)*rom1d
      velx(i, j) = w(i, j, 2)*rom1
      velyd(i, j) = rom1*wd(i, j, 3) + w(i, j, 3)*rom1d
      vely(i, j) = w(i, j, 3)*rom1
      velzd(i, j) = rom1*wd(i, j, 4) + w(i, j, 4)*rom1d
      velz(i, j) = w(i, j, 4)*rom1
!
      ecd = half*(2*velx(i, j)*velxd(i, j)+2*vely(i, j)*velyd(i, j)+2*&
&       velz(i, j)*velzd(i, j))
      ec = half*(velx(i, j)*velx(i, j)+vely(i, j)*vely(i, j)+velz(i, j)*&
&       velz(i, j))
! ec = HALF*( velx(i,j)*velx(i,j) &
! + vely(i,j)*vely(i,j))
!
      temp = w(i, j, 5) - ec*ro
      elocd = rom1*(wd(i, j, 5)-ro*ecd-ec*rod) + temp*rom1d
!
      tlocd(i, j) = cvm1*elocd
!
! p(i,j) = ro*rgaz*tloc(i,j)
!h(i,j,1) = w(i,j,4)
!h(i,j,2) = w(i,j,4) * velx(i,j)
!h(i,j,3) = w(i,j,4) * vely(i,j)
!h(i,j,4) = w(i,j,4) * velz(i,j) + p(i,j)
!h(i,j,5) = w(i,j,4) * htot
    END DO
  END DO
  func0d = 0.0_8
  func1d = 0.0_8
  func2d = 0.0_8
  func3d = 0.0_8
! Work on interior domain minus one cell
! do j = 1, jm
!DIR$ IVDEP
! do i = 1, im
! #include "rhs/gradop_5pi.F"
! #include "rhs/gradop_5pj.F"
! #include "rhs/gradient.F"
! enddo
! enddo
! trick for ducros in dissipation
! #include "rhs/gradveloingh.F"
  DO j=1,jm
!DIR$ IVDEP
    DO i=1,im
!
      func0d(i, j, 1) = 0.0_8
      func0d(i, j, 2) = velxd(i, j)
      func0d(i, j, 3) = velyd(i, j)
      func0d(i, j, 4) = velzd(i, j)
      func0d(i, j, 5) = tlocd(i, j)
      func1d(i, j, 1) = 0.0_8
      func1d(i, j, 2) = 0.0_8
      func1d(i, j, 3) = 0.0_8
      func1d(i, j, 4) = 0.0_8
      func1d(i, j, 5) = velxd(i, j)
      func2d(i, j, 1) = 0.0_8
      func2d(i, j, 2) = 0.0_8
      func2d(i, j, 3) = 0.0_8
      func2d(i, j, 4) = 0.0_8
      func2d(i, j, 5) = velyd(i, j)
      func3d(i, j, 1) = 0.0_8
      func3d(i, j, 2) = 0.0_8
      func3d(i, j, 3) = 0.0_8
      func3d(i, j, 4) = 0.0_8
      func3d(i, j, 5) = velzd(i, j)
    END DO
  END DO
END SUBROUTINE FUNCTION_5P_DZ2_D
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
