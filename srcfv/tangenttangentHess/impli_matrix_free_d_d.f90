!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of impli_matrix_free_2d_d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs w
!ith!StaticTaping):
!   variations   of useful results: dwid dwi
!   with respect to varying inputs: w
!   RW status of diff variables: dwid:out w:in dwi:out
!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of impli_matrix_free_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs wit
!h!StaticTaping):
!   variations   of useful results: dwi
!   with respect to varying inputs: w
!   RW status of diff variables: w:in dwi:out
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
! =============================================================================
! Implicit matrix free phase 2D NS
! =============================================================================
SUBROUTINE IMPLI_MATRIX_FREE_2D_D_D(dwi, dwid0, dwid, dwidd, nx, ny, w, &
& wd0, wd, dw, vol, volf, dtcoef, cfl, gam, rgaz, prandtl, lmax, gh, cv&
& , cs, muref, tref, s_suth, im, jm, em)
  IMPLICIT NONE
!
!
! variables for dimension -----------------------------------------
  INTEGER, INTENT(IN) :: em, im, jm, lmax
  INTEGER, INTENT(IN) :: gh
! required arguments ----------------------------------------------
  REAL*8, INTENT(IN) :: dtcoef, gam, rgaz, prandtl, cfl, cs, muref, tref&
& , s_suth, cv
  REAL*8, DIMENSION(1-gh:im+1+gh, 1-gh:jm+1+gh, 2), INTENT(IN) :: nx, ny
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2), INTENT(IN) :: volf
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh), INTENT(IN) :: vol
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: wd0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: wd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(IN) :: dw
! Returned objects ------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: dwi
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: dwid0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: dwid
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em), INTENT(INOUT) :: dwidd
! Local variables -------------------------------------------------
  INTEGER :: i, j, l, equa, kdir, i0, j0, ipt, le, eq2
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tloc, mu
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tlocd0, mud0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tlocd, mud
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: tlocdd, mudd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em) :: d2w, dfi, dgi, hn, f&
& , g
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em) :: d2wd0, dfid0, dgid0, &
& hnd0, fd0, gd0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em) :: d2wd, dfid, dgid, hnd&
& , fd, gd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, em) :: d2wdd, dfidd, dgidd, &
& hndd, fdd, gdd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: coefdiag
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: coefdiagd0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: coefdiagd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh) :: coefdiagdd
!specrad
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2) :: coef
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2) :: coefd0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2) :: coefd
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 2) :: coefdd
  REAL*8, DIMENSION(em) :: wi, fi, gi
  REAL*8, DIMENSION(em) :: wid0, fid0, gid0
  REAL*8, DIMENSION(em) :: wid, fid, gid
  REAL*8, DIMENSION(em) :: widd, fidd, gidd
  REAL*8 :: velxi, velyi, velzi, pint, tint, htot
  REAL*8 :: velxid0, velyid0, velzid0, pintd0, htotd0
  REAL*8 :: velxid, velyid, velzid, pintd, htotd
  REAL*8 :: velxidd, velyidd, velzidd, pintdd, htotdd
  REAL*8 :: rhom1, roki, norm, specdiff, iro, rol, ror, rom1
  REAL*8 :: rhom1d0, specdiffd0, irod0, rold0, rord0, rom1d0
  REAL*8 :: rhom1d, specdiffd, irod, rold, rord, rom1d
  REAL*8 :: rhom1dd, specdiffdd, irodd, rom1dd
  REAL*8 :: one, half, zero, two, rom1l, rom1r, gampr, gamprt
  REAL*8 :: rom1ld0, rom1rd0
  REAL*8 :: rom1ld, rom1rd
  REAL*8 :: rom1ldd, rom1rdd
  REAL*8 :: uu, vv, cc, gam1, mutot
  REAL*8 :: uud0, vvd0, ccd0, mutotd0
  REAL*8 :: uud, vvd, ccd, mutotd
  REAL*8 :: uudd, vvdd, ccdd, mutotdd
  REAL*8 :: dtm1, dist, vitc, dt_euler, dt_ns, cvm1
  REAL*8 :: dtm1d0, vitcd0, dt_eulerd0, dt_nsd0
  REAL*8 :: dtm1d, vitcd, dt_eulerd, dt_nsd
  REAL*8 :: dtm1dd, vitcdd, dt_eulerdd, dt_nsdd
  REAL*8 :: ec, eloc, betas, diagm1, cflm1, dtm1save
  REAL*8 :: ecd0, elocd0, diagm1d0
  REAL*8 :: ecd, elocd, diagm1d
  REAL*8 :: ecdd, elocdd, diagm1dd
  INTRINSIC SQRT
  INTRINSIC MIN
  INTRINSIC MAX
  INTRINSIC ABS
  REAL*8 :: x1
  REAL*8 :: x1d0
  REAL*8 :: x1d
  REAL*8 :: x1dd
  REAL*8 :: x2
  REAL*8 :: x2d0
  REAL*8 :: x2d
  REAL*8 :: x2dd
  REAL*8 :: max1
  REAL*8 :: max1d0
  REAL*8 :: max1d
  REAL*8 :: max1dd
  REAL*8 :: abs0
  REAL*8 :: abs0d0
  REAL*8 :: abs0d
  REAL*8 :: abs0dd
  REAL*8 :: result1
  REAL*8 :: result1d0
  REAL*8 :: result1d
  REAL*8 :: result1dd
  REAL*8 :: arg1
  REAL*8 :: arg1d0
  REAL*8 :: arg1d
  REAL*8 :: arg1dd
  REAL*8 :: arg2
  REAL*8 :: result2
  REAL*8 :: temp
  REAL*8 :: tempd
  REAL*8 :: temp0
  REAL*8 :: temp0d
  REAL*8 :: temp1
  REAL*8 :: temp2
! -----------------------------------------------------------------
  half = 0.5d0
  zero = 0.d0
  two = 2.d0
  one = 1.d0
!
  dwi = zero
  dfi = zero
  dgi = zero
!
  gampr = 2.d0*gam/prandtl
  gam1 = gam - one
!
  cflm1 = one/cfl
  cvm1 = one/cv
  result1 = SQRT(tref)
  betas = muref*(tref+cs)/(result1*tref)
  fd = 0.0_8
  gd = 0.0_8
  coefdiagd = 0.0_8
  tlocd = 0.0_8
  mud = 0.0_8
  fd0 = 0.0_8
  gd0 = 0.0_8
  tlocdd = 0.0_8
  coefdiagd0 = 0.0_8
  fdd = 0.0_8
  mudd = 0.0_8
  tlocd0 = 0.0_8
  gdd = 0.0_8
  coefdiagdd = 0.0_8
  mud0 = 0.0_8
  DO j=1-gh,jm+gh
    DO i=1-gh,im+gh
      rord = wd(i, j, 1)
      rord0 = wd0(i, j, 1)
      ror = w(i, j, 1)
      temp1 = one*rord/(ror*ror)
      rom1dd = temp1*2*rord0/ror
      rom1d = -temp1
      rom1d0 = -(one*rord0/ror**2)
      rom1 = one/ror
      velxidd = wd(i, j, 2)*rom1d0 + rom1d*wd0(i, j, 2) + w(i, j, 2)*&
&       rom1dd
      velxid = rom1*wd(i, j, 2) + w(i, j, 2)*rom1d
      velxid0 = rom1*wd0(i, j, 2) + w(i, j, 2)*rom1d0
      velxi = w(i, j, 2)*rom1
      velyidd = wd(i, j, 3)*rom1d0 + rom1d*wd0(i, j, 3) + w(i, j, 3)*&
&       rom1dd
      velyid = rom1*wd(i, j, 3) + w(i, j, 3)*rom1d
      velyid0 = rom1*wd0(i, j, 3) + w(i, j, 3)*rom1d0
      velyi = w(i, j, 3)*rom1
      velzidd = wd(i, j, 4)*rom1d0 + rom1d*wd0(i, j, 4) + w(i, j, 4)*&
&       rom1dd
      velzid = rom1*wd(i, j, 4) + w(i, j, 4)*rom1d
      velzid0 = rom1*wd0(i, j, 4) + w(i, j, 4)*rom1d0
      velzi = w(i, j, 4)*rom1
!
      ecdd = half*(velxid*2*velxid0+2*velxi*velxidd+velyid*2*velyid0+2*&
&       velyi*velyidd+velzid*2*velzid0+2*velzi*velzidd)
      ecd = half*(2*velxi*velxid+2*velyi*velyid+2*velzi*velzid)
      ecd0 = half*(2*velxi*velxid0+2*velyi*velyid0+2*velzi*velzid0)
      ec = half*(velxi*velxi+velyi*velyi+velzi*velzi)
!
      tempd = wd0(i, j, 5) - ror*ecd0 - ec*rord0
      temp = w(i, j, 5) - ec*ror
      temp1 = wd(i, j, 5) - ror*ecd - rord*ec
      elocdd = temp1*rom1d0 + rom1*(-(ecd*rord0)-ror*ecdd-rord*ecd0) + &
&       rom1d*tempd + temp*rom1dd
      elocd = rom1*temp1 + temp*rom1d
      elocd0 = rom1*tempd + temp*rom1d0
      eloc = temp*rom1
!
      tlocdd(i, j) = cvm1*elocdd
      tlocd(i, j) = cvm1*elocd
      tlocd0(i, j) = cvm1*elocd0
      tloc(i, j) = eloc*cvm1
!
      pintdd = rgaz*(rord*tlocd0(i, j)+tlocd(i, j)*rord0+ror*tlocdd(i, j&
&       ))
      pintd = rgaz*(tloc(i, j)*rord+ror*tlocd(i, j))
      pintd0 = rgaz*(tloc(i, j)*rord0+ror*tlocd0(i, j))
      pint = ror*rgaz*tloc(i, j)
      htotdd = (wd(i, j, 5)+pintd)*rom1d0 + rom1*pintdd + rom1d*(wd0(i, &
&       j, 5)+pintd0) + (w(i, j, 5)+pint)*rom1dd
      htotd = rom1*(wd(i, j, 5)+pintd) + (w(i, j, 5)+pint)*rom1d
      htotd0 = rom1*(wd0(i, j, 5)+pintd0) + (w(i, j, 5)+pint)*rom1d0
      htot = (w(i, j, 5)+pint)*rom1
      fdd(i, j, 1) = 0.0_8
      fd(i, j, 1) = wd(i, j, 2)
      fd0(i, j, 1) = wd0(i, j, 2)
      f(i, j, 1) = w(i, j, 2)
      fdd(i, j, 2) = wd(i, j, 2)*velxid0 + velxid*wd0(i, j, 2) + w(i, j&
&       , 2)*velxidd + pintdd
      fd(i, j, 2) = velxi*wd(i, j, 2) + w(i, j, 2)*velxid + pintd
      fd0(i, j, 2) = velxi*wd0(i, j, 2) + w(i, j, 2)*velxid0 + pintd0
      f(i, j, 2) = w(i, j, 2)*velxi + pint
      fdd(i, j, 3) = wd(i, j, 2)*velyid0 + velyid*wd0(i, j, 2) + w(i, j&
&       , 2)*velyidd
      fd(i, j, 3) = velyi*wd(i, j, 2) + w(i, j, 2)*velyid
      fd0(i, j, 3) = velyi*wd0(i, j, 2) + w(i, j, 2)*velyid0
      f(i, j, 3) = w(i, j, 2)*velyi
      fdd(i, j, 4) = wd(i, j, 2)*velzid0 + velzid*wd0(i, j, 2) + w(i, j&
&       , 2)*velzidd
      fd(i, j, 4) = velzi*wd(i, j, 2) + w(i, j, 2)*velzid
      fd0(i, j, 4) = velzi*wd0(i, j, 2) + w(i, j, 2)*velzid0
      f(i, j, 4) = w(i, j, 2)*velzi
      fdd(i, j, 5) = wd(i, j, 2)*htotd0 + htotd*wd0(i, j, 2) + w(i, j, 2&
&       )*htotdd
      fd(i, j, 5) = htot*wd(i, j, 2) + w(i, j, 2)*htotd
      fd0(i, j, 5) = htot*wd0(i, j, 2) + w(i, j, 2)*htotd0
      f(i, j, 5) = w(i, j, 2)*htot
      gdd(i, j, 1) = 0.0_8
      gd(i, j, 1) = wd(i, j, 3)
      gd0(i, j, 1) = wd0(i, j, 3)
      g(i, j, 1) = w(i, j, 3)
      gdd(i, j, 2) = wd(i, j, 3)*velxid0 + velxid*wd0(i, j, 3) + w(i, j&
&       , 3)*velxidd
      gd(i, j, 2) = velxi*wd(i, j, 3) + w(i, j, 3)*velxid
      gd0(i, j, 2) = velxi*wd0(i, j, 3) + w(i, j, 3)*velxid0
      g(i, j, 2) = w(i, j, 3)*velxi
      gdd(i, j, 3) = wd(i, j, 3)*velyid0 + velyid*wd0(i, j, 3) + w(i, j&
&       , 3)*velyidd + pintdd
      gd(i, j, 3) = velyi*wd(i, j, 3) + w(i, j, 3)*velyid + pintd
      gd0(i, j, 3) = velyi*wd0(i, j, 3) + w(i, j, 3)*velyid0 + pintd0
      g(i, j, 3) = w(i, j, 3)*velyi + pint
      gdd(i, j, 4) = wd(i, j, 3)*velzid0 + velzid*wd0(i, j, 3) + w(i, j&
&       , 3)*velzidd
      gd(i, j, 4) = velzi*wd(i, j, 3) + w(i, j, 3)*velzid
      gd0(i, j, 4) = velzi*wd0(i, j, 3) + w(i, j, 3)*velzid0
      g(i, j, 4) = w(i, j, 3)*velzi
      gdd(i, j, 5) = wd(i, j, 3)*htotd0 + htotd*wd0(i, j, 3) + w(i, j, 3&
&       )*htotdd
      gd(i, j, 5) = htot*wd(i, j, 3) + w(i, j, 3)*htotd
      gd0(i, j, 5) = htot*wd0(i, j, 3) + w(i, j, 3)*htotd0
      g(i, j, 5) = w(i, j, 3)*htot
!h(i,j,1) = w(i,j,4)
!h(i,j,2) = w(i,j,4) * velx(i,j)
!h(i,j,3) = w(i,j,4) * vely(i,j)
!h(i,j,4) = w(i,j,4) * velz(i,j) + pint
!h(i,j,5) = w(i,j,4) * htot
      temp1 = SQRT(tloc(i, j))
      IF (tloc(i, j) .EQ. 0.0) THEN
        tempd = 0.0_8
      ELSE
        tempd = tlocd0(i, j)/(2.0*temp1)
      END IF
      temp = temp1
      IF (tloc(i, j) .EQ. 0.0) THEN
        result1d = 0.0_8
        result1dd = 0.0_8
      ELSE
        temp1 = tlocd(i, j)/(2.0*temp)
        result1dd = (tlocdd(i, j)-temp1*2.0*tempd)/(2.0*temp)
        result1d = temp1
      END IF
      result1d0 = tempd
      result1 = temp
      temp1 = result1*tloc(i, j)/(s_suth+tloc(i, j))
      tempd = (tloc(i, j)*result1d0+(result1-temp1)*tlocd0(i, j))/(&
&       s_suth+tloc(i, j))
      temp = temp1
      temp1 = (tloc(i, j)*result1d+(result1-temp)*tlocd(i, j))/(s_suth+&
&       tloc(i, j))
      mudd(i, j) = betas*((result1d-temp1)*tlocd0(i, j)+tloc(i, j)*&
&       result1dd+tlocd(i, j)*(result1d0-tempd)+(result1-temp)*tlocdd(i&
&       , j))/(s_suth+tloc(i, j))
      mud(i, j) = betas*temp1
      mud0(i, j) = betas*tempd
      mu(i, j) = betas*temp
      arg1 = nx(i, j, 1)*nx(i, j, 1) + ny(i, j, 1)*ny(i, j, 1)
      result1 = SQRT(arg1)
      arg2 = nx(i, j, 2)*nx(i, j, 2) + ny(i, j, 2)*ny(i, j, 2)
      result2 = SQRT(arg2)
      dist = vol(i, j)/(result1+result2)
      arg1dd = gam*(pintd*rom1d0+rom1*pintdd+rom1d*pintd0+pint*rom1dd)
      arg1d = gam*(rom1*pintd+pint*rom1d)
      arg1d0 = gam*(rom1*pintd0+pint*rom1d0)
      arg1 = gam*pint*rom1
      temp1 = SQRT(arg1)
      IF (arg1 .EQ. 0.0) THEN
        tempd = 0.0_8
      ELSE
        tempd = arg1d0/(2.0*temp1)
      END IF
      temp = temp1
      IF (arg1 .EQ. 0.0) THEN
        ccd = 0.0_8
        ccdd = 0.0_8
      ELSE
        temp1 = arg1d/(2.0*temp)
        ccdd = (arg1dd-temp1*2.0*tempd)/(2.0*temp)
        ccd = temp1
      END IF
      ccd0 = tempd
      cc = temp
      arg1dd = velxid*2*velxid0 + 2*velxi*velxidd + velyid*2*velyid0 + 2&
&       *velyi*velyidd
      arg1d = 2*velxi*velxid + 2*velyi*velyid
      arg1d0 = 2*velxi*velxid0 + 2*velyi*velyid0
      arg1 = velxi*velxi + velyi*velyi
      temp1 = SQRT(arg1)
      IF (arg1 .EQ. 0.0) THEN
        tempd = 0.0_8
      ELSE
        tempd = arg1d0/(2.0*temp1)
      END IF
      temp = temp1
      IF (arg1 .EQ. 0.0) THEN
        result1d = 0.0_8
        result1dd = 0.0_8
      ELSE
        temp1 = arg1d/(2.0*temp)
        result1dd = (arg1dd-temp1*2.0*tempd)/(2.0*temp)
        result1d = temp1
      END IF
      result1d0 = tempd
      result1 = temp
      vitcdd = result1dd + ccdd
      vitcd = result1d + ccd
      vitcd0 = result1d0 + ccd0
      vitc = result1 + cc
      temp1 = vitcd/(vitc*vitc)
      dt_eulerdd = -(dist*(vitcdd-temp1*2*vitc*vitcd0)/vitc**2)
      dt_eulerd = -(dist*temp1)
      dt_eulerd0 = -(dist*vitcd0/vitc**2)
      dt_euler = dist/vitc
      temp = half*(dist*dist)
      temp0d = gampr*mud0(i, j)
      temp0 = gampr*mu(i, j)
      temp1 = ror/temp0
      temp2 = (rord-gampr*mud(i, j)*temp1)/temp0
      dt_nsdd = temp*(-(gampr*(temp1*mudd(i, j)+mud(i, j)*(rord0-temp1*&
&       temp0d)/temp0))-temp2*temp0d)/temp0
      dt_nsd = temp*temp2
      dt_nsd0 = temp*(rord0-ror*temp0d/temp0)/temp0
      dt_ns = temp*(ror/temp0)
      IF (dt_euler .GT. dt_ns) THEN
        x1dd = dt_nsdd
        x1d = dt_nsd
        x1d0 = dt_nsd0
        x1 = dt_ns
      ELSE
        x1dd = dt_eulerdd
        x1d = dt_eulerd
        x1d0 = dt_eulerd0
        x1 = dt_euler
      END IF
      IF (x1 .LT. 1.d-15) THEN
        max1 = 1.d-15
        max1d = 0.0_8
        max1d0 = 0.0_8
        max1dd = 0.0_8
      ELSE
        max1dd = x1dd
        max1d = x1d
        max1d0 = x1d0
        max1 = x1
      END IF
! 1/dt
      temp2 = max1d/(max1*max1)
      dtm1dd = -(cflm1*(max1dd-temp2*2*max1*max1d0)/max1**2)
      dtm1d = -(cflm1*temp2)
      dtm1d0 = -(cflm1*max1d0/max1**2)
      dtm1 = cflm1/max1
!write(30101,*) "i,j    =  ", i,j
!write(30101,*) "dtm1   =  ", dtm1
!write(30101,*) "distm1 =  ", distm1
!write(30101,*) "cflm1  =  ", dtm1
!write(30101,*) "mu     =  ", mu(i,j)
! compute diagonal coefficient------------------------------------------------------
! dtcoef/tau0
      coefdiagdd(i, j) = vol(i, j)*dtcoef*dtm1dd
      coefdiagd(i, j) = vol(i, j)*dtcoef*dtm1d
      coefdiagd0(i, j) = vol(i, j)*dtcoef*dtm1d0
      coefdiag(i, j) = dtm1*dtcoef*vol(i, j)
    END DO
  END DO
  coefd = 0.0_8
  coefdd = 0.0_8
  coefd0 = 0.0_8
! !for global timeStep
! dtm1save = 1.d-15
! do j = 1 , jm
! do i = 1 , im
! #include "lhs/PrimitivesLhs.F"
! #include "phys/viscosity.F"
! #include "lhs/time_step.F"
! IF (dtm1.gt.dtm1save) THEN
! dtm1save = dtm1
! ENDIF
! dtm1 = dtm1save
! enddo
! enddo
! !
! coefdiag(1:im,1:jm) = dtm1 * dtcoef * vol(1:im,1:jm) ! dtcoef/tau0
!
loop_kdir:DO kdir=1,2
    i0 = -kdir + 2
    j0 = kdir - 1
!
    DO j=1,jm+j0
      DO i=1,im+i0
        rold = wd(i-i0, j-j0, 1)
        rold0 = wd0(i-i0, j-j0, 1)
        rol = w(i-i0, j-j0, 1)
        rord = wd(i, j, 1)
        rord0 = wd0(i, j, 1)
        ror = w(i, j, 1)
        temp2 = one*rold/(rol*rol)
        rom1ldd = temp2*2*rold0/rol
        rom1ld = -temp2
        rom1ld0 = -(one*rold0/rol**2)
        rom1l = one/rol
        temp2 = one*rord/(ror*ror)
        rom1rdd = temp2*2*rord0/ror
        rom1rd = -temp2
        rom1rd0 = -(one*rord0/ror**2)
        rom1r = one/ror
        temp2 = 2.d0/(rol+ror)
        temp0d = -(temp2*(rold0+rord0)/(rol+ror))
        temp0 = temp2
        temp2 = temp0/(rol+ror)
        irodd = -((rold+rord)*(temp0d-temp2*(rold0+rord0))/(rol+ror))
        irod = -((rold+rord)*temp2)
        irod0 = temp0d
        iro = temp0
        temp0d = wd0(i-i0, j-j0, 2)
        temp0 = w(i-i0, j-j0, 2)
        temp2 = wd(i-i0, j-j0, 2)
        uudd = half*(temp2*rom1ld0+rom1ld*temp0d+temp0*rom1ldd+wd(i, j, &
&         2)*rom1rd0+rom1rd*wd0(i, j, 2)+w(i, j, 2)*rom1rdd)
        uud = half*(temp2*rom1l+temp0*rom1ld+wd(i, j, 2)*rom1r+w(i, j, 2&
&         )*rom1rd)
        uud0 = half*(rom1l*temp0d+temp0*rom1ld0+rom1r*wd0(i, j, 2)+w(i, &
&         j, 2)*rom1rd0)
        uu = half*(temp0*rom1l+w(i, j, 2)*rom1r)
        temp0d = wd0(i-i0, j-j0, 3)
        temp0 = w(i-i0, j-j0, 3)
        temp2 = wd(i-i0, j-j0, 3)
        vvdd = half*(temp2*rom1ld0+rom1ld*temp0d+temp0*rom1ldd+wd(i, j, &
&         3)*rom1rd0+rom1rd*wd0(i, j, 3)+w(i, j, 3)*rom1rdd)
        vvd = half*(temp2*rom1l+temp0*rom1ld+wd(i, j, 3)*rom1r+w(i, j, 3&
&         )*rom1rd)
        vvd0 = half*(rom1l*temp0d+temp0*rom1ld0+rom1r*wd0(i, j, 3)+w(i, &
&         j, 3)*rom1rd0)
        vv = half*(temp0*rom1l+w(i, j, 3)*rom1r)
        temp0 = gam*rgaz*half
        ccdd = temp0*(tlocdd(i-i0, j-j0)+tlocdd(i, j))
        ccd = temp0*(tlocd(i-i0, j-j0)+tlocd(i, j))
        ccd0 = temp0*(tlocd0(i-i0, j-j0)+tlocd0(i, j))
        cc = temp0*(tloc(i-i0, j-j0)+tloc(i, j))
        norm = nx(i, j, kdir)*nx(i, j, kdir) + ny(i, j, kdir)*ny(i, j, &
&         kdir)
        mutotdd = half*gampr*(mudd(i-i0, j-j0)+mudd(i, j))
        mutotd = half*gampr*(mud(i-i0, j-j0)+mud(i, j))
        mutotd0 = half*gampr*(mud0(i-i0, j-j0)+mud0(i, j))
        mutot = half*gampr*(mu(i-i0, j-j0)+mu(i, j))
        temp2 = volf(i, j, kdir)*norm
        specdiffdd = temp2*(mutotd*irod0+iro*mutotdd+irod*mutotd0+mutot*&
&         irodd)
        specdiffd = temp2*(iro*mutotd+mutot*irod)
        specdiffd0 = volf(i, j, kdir)*norm*(iro*mutotd0+mutot*irod0)
        specdiff = mutot*norm*volf(i, j, kdir)*iro
        x2dd = nx(i, j, kdir)*uudd + ny(i, j, kdir)*vvdd
        x2d = nx(i, j, kdir)*uud + ny(i, j, kdir)*vvd
        x2d0 = nx(i, j, kdir)*uud0 + ny(i, j, kdir)*vvd0
        x2 = uu*nx(i, j, kdir) + vv*ny(i, j, kdir)
        IF (x2 .GE. 0.) THEN
          abs0dd = x2dd
          abs0d = x2d
          abs0d0 = x2d0
          abs0 = x2
        ELSE
          abs0dd = -x2dd
          abs0d = -x2d
          abs0d0 = -x2d0
          abs0 = -x2
        END IF
        arg1dd = norm*ccdd
        arg1d = norm*ccd
        arg1d0 = norm*ccd0
        arg1 = cc*norm
        temp2 = SQRT(arg1)
        IF (arg1 .EQ. 0.0) THEN
          temp0d = 0.0_8
        ELSE
          temp0d = arg1d0/(2.0*temp2)
        END IF
        temp0 = temp2
        IF (arg1 .EQ. 0.0) THEN
          result1d = 0.0_8
          result1dd = 0.0_8
        ELSE
          temp2 = arg1d/(2.0*temp0)
          result1dd = (arg1dd-temp2*2.0*temp0d)/(2.0*temp0)
          result1d = temp2
        END IF
        result1d0 = temp0d
        result1 = temp0
        coefdd(i, j, kdir) = one*(abs0dd+result1dd+two*specdiffdd)
        coefd(i, j, kdir) = one*(abs0d+result1d+two*specdiffd)
        coefd0(i, j, kdir) = one*(abs0d0+result1d0+two*specdiffd0)
        coef(i, j, kdir) = one*(abs0+result1+two*specdiff)
      END DO
    END DO
    DO j=1,jm
      DO i=1,im
        coefdiagdd(i, j) = coefdiagdd(i, j) + coefdd(i, j, kdir) + &
&         coefdd(i+i0, j+j0, kdir)
        coefdiagd(i, j) = coefdiagd(i, j) + coefd(i, j, kdir) + coefd(i+&
&         i0, j+j0, kdir)
        coefdiagd0(i, j) = coefdiagd0(i, j) + coefd0(i, j, kdir) + &
&         coefd0(i+i0, j+j0, kdir)
        coefdiag(i, j) = coefdiag(i, j) + coef(i, j, kdir) + coef(i+i0, &
&         j+j0, kdir)
      END DO
    END DO
  END DO loop_kdir
  dwid = 0.0_8
  hnd = 0.0_8
  fid = 0.0_8
  dfid = 0.0_8
  gid = 0.0_8
  dgid = 0.0_8
  dwidd = 0.0_8
  dwid0 = 0.0_8
  hnd0 = 0.0_8
  gidd = 0.0_8
  dgidd = 0.0_8
  hndd = 0.0_8
  fid0 = 0.0_8
  dfid0 = 0.0_8
  fidd = 0.0_8
  dfidd = 0.0_8
  gid0 = 0.0_8
  dgid0 = 0.0_8
loop_subite:DO l=1,lmax
    d2w = dw
    d2wd = 0.0_8
    d2wdd = 0.0_8
    d2wd0 = 0.0_8
!
! Computation of the left hand side
!
loop_kdir_inner:DO kdir=1,2
      i0 = -kdir + 2
      j0 = kdir - 1
!
      DO j=1,jm+j0
        DO i=1,im+i0
!norm = dsqrt( nx(i,j,kdir)**2 + ny(i,j,kdir)**2)
          temp0 = half*nx(i, j, kdir)
          temp = half*ny(i, j, kdir)
          hndd(i, j, :) = temp0*(dfidd(i-i0, j-j0, :)+dfidd(i, j, :)) + &
&           temp*(dgidd(i-i0, j-j0, :)+dgidd(i, j, :))
          hnd(i, j, :) = temp0*(dfid(i-i0, j-j0, :)+dfid(i, j, :)) + &
&           temp*(dgid(i-i0, j-j0, :)+dgid(i, j, :))
          hnd0(i, j, :) = temp0*(dfid0(i-i0, j-j0, :)+dfid0(i, j, :)) + &
&           temp*(dgid0(i-i0, j-j0, :)+dgid0(i, j, :))
          hn(i, j, :) = temp0*(dfi(i-i0, j-j0, :)+dfi(i, j, :)) + temp*(&
&           dgi(i-i0, j-j0, :)+dgi(i, j, :))
        END DO
      END DO
!
      DO j=1,jm
        DO i=1,im
          temp0d = coefd0(i+i0, j+j0, kdir)
          temp0 = coef(i+i0, j+j0, kdir)
          temp2 = coefd(i+i0, j+j0, kdir)
          d2wdd(i, j, :) = d2wdd(i, j, :) + hndd(i, j, :) + coefd(i, j, &
&           kdir)*dwid0(i-i0, j-j0, :) + dwi(i-i0, j-j0, :)*coefdd(i, j&
&           , kdir) - hndd(i+i0, j+j0, :) + dwid(i-i0, j-j0, :)*coefd0(i&
&           , j, kdir) + coef(i, j, kdir)*dwidd(i-i0, j-j0, :) + temp2*&
&           dwid0(i+i0, j+j0, :) + dwi(i+i0, j+j0, :)*coefdd(i+i0, j+j0&
&           , kdir) + dwid(i+i0, j+j0, :)*temp0d + temp0*dwidd(i+i0, j+&
&           j0, :)
          d2wd(i, j, :) = d2wd(i, j, :) + hnd(i, j, :) + dwi(i-i0, j-j0&
&           , :)*coefd(i, j, kdir) - hnd(i+i0, j+j0, :) + coef(i, j, &
&           kdir)*dwid(i-i0, j-j0, :) + dwi(i+i0, j+j0, :)*temp2 + temp0&
&           *dwid(i+i0, j+j0, :)
          d2wd0(i, j, :) = d2wd0(i, j, :) + hnd0(i, j, :) - hnd0(i+i0, j&
&           +j0, :) + dwi(i-i0, j-j0, :)*coefd0(i, j, kdir) + coef(i, j&
&           , kdir)*dwid0(i-i0, j-j0, :) + dwi(i+i0, j+j0, :)*temp0d + &
&           temp0*dwid0(i+i0, j+j0, :)
          d2w(i, j, :) = d2w(i, j, :) + hn(i, j, :) - hn(i+i0, j+j0, :) &
&           + coef(i, j, kdir)*dwi(i-i0, j-j0, :) + temp0*dwi(i+i0, j+j0&
&           , :)
        END DO
      END DO
    END DO loop_kdir_inner
!
! Computation of the intermediate increment
!
    DO j=1,jm
      DO i=1,im
        temp2 = one/coefdiag(i, j)
        temp0d = -(temp2*coefdiagd0(i, j)/coefdiag(i, j))
        temp0 = temp2
        temp2 = temp0*coefdiagd(i, j)/coefdiag(i, j)
        diagm1dd = -((coefdiagd(i, j)*temp0d+temp0*coefdiagdd(i, j)-&
&         temp2*coefdiagd0(i, j))/coefdiag(i, j))
        diagm1d = -temp2
        diagm1d0 = temp0d
        diagm1 = temp0
        dwidd(i, j, 1) = d2wd(i, j, 1)*diagm1d0 + diagm1*d2wdd(i, j, 1) &
&         + diagm1d*d2wd0(i, j, 1) + d2w(i, j, 1)*diagm1dd
        dwid(i, j, 1) = diagm1*d2wd(i, j, 1) + d2w(i, j, 1)*diagm1d
        dwid0(i, j, 1) = diagm1*d2wd0(i, j, 1) + d2w(i, j, 1)*diagm1d0
        dwi(i, j, 1) = d2w(i, j, 1)*diagm1
        dwidd(i, j, 2) = d2wd(i, j, 2)*diagm1d0 + diagm1*d2wdd(i, j, 2) &
&         + diagm1d*d2wd0(i, j, 2) + d2w(i, j, 2)*diagm1dd
        dwid(i, j, 2) = diagm1*d2wd(i, j, 2) + d2w(i, j, 2)*diagm1d
        dwid0(i, j, 2) = diagm1*d2wd0(i, j, 2) + d2w(i, j, 2)*diagm1d0
        dwi(i, j, 2) = d2w(i, j, 2)*diagm1
        dwidd(i, j, 3) = d2wd(i, j, 3)*diagm1d0 + diagm1*d2wdd(i, j, 3) &
&         + diagm1d*d2wd0(i, j, 3) + d2w(i, j, 3)*diagm1dd
        dwid(i, j, 3) = diagm1*d2wd(i, j, 3) + d2w(i, j, 3)*diagm1d
        dwid0(i, j, 3) = diagm1*d2wd0(i, j, 3) + d2w(i, j, 3)*diagm1d0
        dwi(i, j, 3) = d2w(i, j, 3)*diagm1
        dwidd(i, j, 4) = d2wd(i, j, 4)*diagm1d0 + diagm1*d2wdd(i, j, 4) &
&         + diagm1d*d2wd0(i, j, 4) + d2w(i, j, 4)*diagm1dd
        dwid(i, j, 4) = diagm1*d2wd(i, j, 4) + d2w(i, j, 4)*diagm1d
        dwid0(i, j, 4) = diagm1*d2wd0(i, j, 4) + d2w(i, j, 4)*diagm1d0
        dwi(i, j, 4) = d2w(i, j, 4)*diagm1
        dwidd(i, j, 5) = d2wd(i, j, 5)*diagm1d0 + diagm1*d2wdd(i, j, 5) &
&         + diagm1d*d2wd0(i, j, 5) + d2w(i, j, 5)*diagm1dd
        dwid(i, j, 5) = diagm1*d2wd(i, j, 5) + d2w(i, j, 5)*diagm1d
        dwid0(i, j, 5) = diagm1*d2wd0(i, j, 5) + d2w(i, j, 5)*diagm1d0
        dwi(i, j, 5) = d2w(i, j, 5)*diagm1
      END DO
    END DO
!
! Actualisation de wi
!
    DO j=1,jm
      DO i=1,im
        widd(:) = dwidd(i, j, :)
        wid(:) = wd(i, j, :) + dwid(i, j, :)
        wid0(:) = wd0(i, j, :) + dwid0(i, j, :)
        wi(:) = w(i, j, :) + dwi(i, j, :)
        temp2 = one/wi(1)
        temp0d = -(temp2*wid0(1)/wi(1))
        temp0 = temp2
        temp2 = temp0*wid(1)/wi(1)
        rhom1dd = -((wid(1)*temp0d+temp0*widd(1)-temp2*wid0(1))/wi(1))
        rhom1d = -temp2
        rhom1d0 = temp0d
        rhom1 = temp0
        velxidd = wid(2)*rhom1d0 + rhom1*widd(2) + rhom1d*wid0(2) + wi(2&
&         )*rhom1dd
        velxid = rhom1*wid(2) + wi(2)*rhom1d
        velxid0 = rhom1*wid0(2) + wi(2)*rhom1d0
        velxi = wi(2)*rhom1
        velyidd = wid(3)*rhom1d0 + rhom1*widd(3) + rhom1d*wid0(3) + wi(3&
&         )*rhom1dd
        velyid = rhom1*wid(3) + wi(3)*rhom1d
        velyid0 = rhom1*wid0(3) + wi(3)*rhom1d0
        velyi = wi(3)*rhom1
        velzidd = wid(4)*rhom1d0 + rhom1*widd(4) + rhom1d*wid0(4) + wi(4&
&         )*rhom1dd
        velzid = rhom1*wid(4) + wi(4)*rhom1d
        velzid0 = rhom1*wid0(4) + wi(4)*rhom1d0
        velzi = wi(4)*rhom1
        temp0d = 2*velxi*velxid0 + 2*velyi*velyid0 + 2*velzi*velzid0
        temp0 = velxi*velxi + velyi*velyi + velzi*velzi
        temp2 = 2*velxi*velxid + 2*velyi*velyid + 2*velzi*velzid
        pintdd = gam1*(widd(5)-half*(wid(1)*temp0d+temp0*widd(1)+temp2*&
&         wid0(1)+wi(1)*(velxid*2*velxid0+2*velxi*velxidd+velyid*2*&
&         velyid0+2*velyi*velyidd+velzid*2*velzid0+2*velzi*velzidd)))
        pintd = gam1*(wid(5)-half*(temp0*wid(1)+wi(1)*temp2))
        pintd0 = gam1*(wid0(5)-half*(temp0*wid0(1)+wi(1)*temp0d))
        pint = gam1*(wi(5)-half*(wi(1)*temp0))
!
! Actualisation des flux intermediaires
!
        fidd(1) = widd(2)
        fid(1) = wid(2)
        fid0(1) = wid0(2)
        fi(1) = wi(2)
        fidd(2) = wid(2)*velxid0 + velxi*widd(2) + velxid*wid0(2) + wi(2&
&         )*velxidd + pintdd
        fid(2) = velxi*wid(2) + wi(2)*velxid + pintd
        fid0(2) = velxi*wid0(2) + wi(2)*velxid0 + pintd0
        fi(2) = wi(2)*velxi + pint
        fidd(3) = wid(2)*velyid0 + velyi*widd(2) + velyid*wid0(2) + wi(2&
&         )*velyidd
        fid(3) = velyi*wid(2) + wi(2)*velyid
        fid0(3) = velyi*wid0(2) + wi(2)*velyid0
        fi(3) = wi(2)*velyi
        fidd(4) = wid(2)*velzid0 + velzi*widd(2) + velzid*wid0(2) + wi(2&
&         )*velzidd
        fid(4) = velzi*wid(2) + wi(2)*velzid
        fid0(4) = velzi*wid0(2) + wi(2)*velzid0
        fi(4) = wi(2)*velzi
        fidd(5) = velxid*(wid0(5)+pintd0) + (wi(5)+pint)*velxidd + (wid(&
&         5)+pintd)*velxid0 + velxi*(widd(5)+pintdd)
        fid(5) = (wi(5)+pint)*velxid + velxi*(wid(5)+pintd)
        fid0(5) = (wi(5)+pint)*velxid0 + velxi*(wid0(5)+pintd0)
        fi(5) = velxi*(wi(5)+pint)
        gidd(1) = widd(3)
        gid(1) = wid(3)
        gid0(1) = wid0(3)
        gi(1) = wi(3)
        gidd(2) = wid(3)*velxid0 + velxi*widd(3) + velxid*wid0(3) + wi(3&
&         )*velxidd
        gid(2) = velxi*wid(3) + wi(3)*velxid
        gid0(2) = velxi*wid0(3) + wi(3)*velxid0
        gi(2) = wi(3)*velxi
        gidd(3) = wid(3)*velyid0 + velyi*widd(3) + velyid*wid0(3) + wi(3&
&         )*velyidd + pintdd
        gid(3) = velyi*wid(3) + wi(3)*velyid + pintd
        gid0(3) = velyi*wid0(3) + wi(3)*velyid0 + pintd0
        gi(3) = wi(3)*velyi + pint
        gidd(4) = wid(3)*velzid0 + velzi*widd(3) + velzid*wid0(3) + wi(3&
&         )*velzidd
        gid(4) = velzi*wid(3) + wi(3)*velzid
        gid0(4) = velzi*wid0(3) + wi(3)*velzid0
        gi(4) = wi(3)*velzi
        gidd(5) = velyid*(wid0(5)+pintd0) + (wi(5)+pint)*velyidd + (wid(&
&         5)+pintd)*velyid0 + velyi*(widd(5)+pintdd)
        gid(5) = (wi(5)+pint)*velyid + velyi*(wid(5)+pintd)
        gid0(5) = (wi(5)+pint)*velyid0 + velyi*(wid0(5)+pintd0)
        gi(5) = velyi*(wi(5)+pint)
!
! Calcul des increments des flux
!
        dfidd(i, j, :) = fidd(:) - fdd(i, j, :)
        dfid(i, j, :) = fid(:) - fd(i, j, :)
        dfid0(i, j, :) = fid0(:) - fd0(i, j, :)
        dfi(i, j, :) = fi(:) - f(i, j, :)
        dgidd(i, j, :) = gidd(:) - gdd(i, j, :)
        dgid(i, j, :) = gid(:) - gd(i, j, :)
        dgid0(i, j, :) = gid0(:) - gd0(i, j, :)
        dgi(i, j, :) = gi(:) - g(i, j, :)
      END DO
    END DO
  END DO loop_subite
END SUBROUTINE IMPLI_MATRIX_FREE_2D_D_D
!

