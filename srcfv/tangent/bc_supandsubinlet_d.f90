!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_supandsubinlet_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs wit
!h!StaticTaping):
!   variations   of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
SUBROUTINE BC_SUPANDSUBINLET_2D_D(w, wd0, loc, interf, field, nx, ny, &
& gam, im, jm, lm, gh)
  IMPLICIT NONE
! variables for dimension -----------------------------------------
  INTEGER, INTENT(IN) :: im, jm, gh, lm
! required arguments ----------------------------------------------
  CHARACTER(len=3), INTENT(IN) :: loc
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: interf
  REAL*8, INTENT(IN) :: gam
  REAL*8, DIMENSION(lm, gh, 5), INTENT(IN) :: field
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: nx
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: ny
! Returned objects ------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wd0
! Non-required arguments -------------------------------------------
  REAL*8 :: ro, uu, vv, ww, velo2, p0, sound2, mach, rom1
  REAL*8 :: rod0, uud, vvd, wwd, sound2d, rom1d
  REAL*8 :: ros, us, vs, ws, ps, uts, vts, vns
  REAL*8 :: rosd, usd, vsd, wsd, psd, utsd, vtsd, vnsd
  REAL*8 :: rod, ud, vd, wd, pd, utd, vtd, vnd
  REAL*8 :: rodd, udd, vdd, wdd, pdd, utdd, vtdd, vndd
  REAL*8 :: p, e, ut, vt, vn, am, ap, bs, b0
  REAL*8 :: pd0, utd0, vtd0, vnd0, amd, apd, bsd, b0d
  REAL*8 :: ro0m1, rodm1, roc0m1, rosm1
  REAL*8 :: roc0m1d, rosm1d
  REAL*8 :: nsum, nxloc, nyloc, nxnorm, nynorm
  REAL*8 :: gam1, epsm, eps0, epsp, roc0, rovn0
  REAL*8 :: roc0d
  REAL*8 :: r, rr, oneonrplusone
  REAL*8 :: rd, rrd, oneonrplusoned
  REAL*8 :: wr1, wr2, wr3, wr4, wr5, pr, hr
  REAL*8 :: hrd
  REAL*8 :: wl1, wl2, wl3, wl4, wl5, pl, hl, ee, hh
  REAL*8 :: hld, eed, hhd
  REAL*8 :: rou, rov, row, roe
  REAL*8 :: roud, rovd, roed
  REAL*8 :: half, one
  INTEGER :: da
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC SQRT
  INTRINSIC SIGN
  REAL*8 :: arg1
  REAL*8 :: result1
  REAL*8 :: result1d
  REAL*8 :: temp
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
    kdir = 1
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    kdir = 1
    i0 = -1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Jlo') THEN
    kdir = 2
    j0 = 1
    lmax = imax - imin + 1
  ELSE IF (loc .EQ. 'Jhi') THEN
    kdir = 2
    j0 = -1
    lmax = imax - imin + 1
  END IF
  half = 0.5d0
  one = 1.d0
  gam1 = gam - one
  DO l=lmin,lmax
    i = imin + (l-lmin)*j0*j0
    j = jmin + (l-lmin)*i0*i0
! face state is taken as Roe State
    wr1 = w(i, j, 1)
    rom1 = one/wr1
    wr2 = w(i, j, 2)*rom1
    wr3 = w(i, j, 3)*rom1
    wr4 = w(i, j, 4)*rom1
    pr = gam1*(w(i, j, 5)-wr1*(wr2*wr2+wr3*wr3+wr4*wr4))
    hr = (w(i, j, 5)+pr)*rom1
    wl1 = field(j, i, 1)
    rosm1 = one/wl1
    wl2 = field(j, i, 2)*rosm1
    wl3 = field(j, i, 3)*rosm1
    wl4 = field(j, i, 4)*rosm1
    pl = gam1*(field(j, i, 5)-wl1*(wl2*wl2+wl3*wl3+wl4*wl4))
    hl = (field(j, i, 5)+pl)*rosm1
    r = SQRT(wr1/wl1)
    rr = SQRT(wr1*wl1)
    oneonrplusone = one/(r+one)
    uu = (wr2*r+wl2)*oneonrplusone
    vv = (wr3*r+wl3)*oneonrplusone
    ww = (wr4*r+wl4)*oneonrplusone
    hh = (hr*r+hl)*oneonrplusone
    velo2 = uu*uu + vv*vv + ww
    ee = half*velo2
    sound2 = gam1*(hh-ee)
    mach = SQRT(velo2/sound2)
    IF (mach .LT. one) THEN
!
      nxloc = nx(i, j, kdir)
      nyloc = ny(i, j, kdir)
      arg1 = nxloc*nxloc + nyloc*nyloc
      result1 = SQRT(arg1)
      nsum = one/result1
      nxnorm = nxloc*nsum
      nynorm = nyloc*nsum
      result1 = SQRT(sound2)
      roc0 = rr*result1
      rovn0 = rr*(uu*nxnorm+vv*nynorm)
      epsm = half + SIGN(half, roc0 - rovn0)
      eps0 = half + SIGN(half, -rovn0)
      epsp = half + SIGN(half, -roc0 - rovn0)
    END IF
    DO de=1,gh
! dirichlet
      wd0(i-de*i0, j-de*j0, 1) = 0.0_8
      w(i-de*i0, j-de*j0, 1) = field(l, de, 1)
      wd0(i-de*i0, j-de*j0, 2) = 0.0_8
      w(i-de*i0, j-de*j0, 2) = field(l, de, 2)
      wd0(i-de*i0, j-de*j0, 3) = 0.0_8
      w(i-de*i0, j-de*j0, 3) = field(l, de, 3)
      wd0(i-de*i0, j-de*j0, 4) = 0.0_8
      w(i-de*i0, j-de*j0, 4) = field(l, de, 4)
      wd0(i-de*i0, j-de*j0, 5) = 0.0_8
      w(i-de*i0, j-de*j0, 5) = field(l, de, 5)
      da = de - 1
      IF (mach .LT. one) THEN
! l-state
        rodd = wd0(i-de*i0, j-de*j0, 1)
        rod = w(i-de*i0, j-de*j0, 1)
        rom1d = -(one*rodd/rod**2)
        rom1 = one/rod
        temp = w(i-de*i0, j-de*j0, 2)
        udd = rom1*wd0(i-de*i0, j-de*j0, 2) + temp*rom1d
        ud = temp*rom1
        temp = w(i-de*i0, j-de*j0, 3)
        vdd = rom1*wd0(i-de*i0, j-de*j0, 3) + temp*rom1d
        vd = temp*rom1
        temp = w(i-de*i0, j-de*j0, 4)
        wdd = rom1*wd0(i-de*i0, j-de*j0, 4) + temp*rom1d
        wd = temp*rom1
        temp = ud*ud + vd*vd + wd*wd
        pdd = gam1*(wd0(i-de*i0, j-de*j0, 5)-half*(temp*rodd+rod*(2*ud*&
&         udd+2*vd*vdd+2*wd*wdd)))
        pd = gam1*(w(i-de*i0, j-de*j0, 5)-half*(rod*temp))
        vndd = nxnorm*udd + nynorm*vdd
        vnd = ud*nxnorm + vd*nynorm
        utdd = udd - nxnorm*vndd
        utd = ud - vnd*nxnorm
        vtdd = vdd - nynorm*vndd
        vtd = vd - vnd*nynorm
        temp = w(i-de*i0, j-de*j0, 5) + pd
        hld = rom1*(wd0(i-de*i0, j-de*j0, 5)+pdd) + temp*rom1d
        hl = temp*rom1
! r-state
        rosd = wd0(i-da*i0, j-da*j0, 1)
        ros = w(i-da*i0, j-da*j0, 1)
        rosm1d = -(one*rosd/ros**2)
        rosm1 = one/ros
        temp = w(i-da*i0, j-da*j0, 2)
        usd = rosm1*wd0(i-da*i0, j-da*j0, 2) + temp*rosm1d
        us = temp*rosm1
        temp = w(i-da*i0, j-da*j0, 3)
        vsd = rosm1*wd0(i-da*i0, j-da*j0, 3) + temp*rosm1d
        vs = temp*rosm1
        temp = w(i-da*i0, j-da*j0, 4)
        wsd = rosm1*wd0(i-da*i0, j-da*j0, 4) + temp*rosm1d
        ws = temp*rosm1
        temp = us*us + vs*vs + ws*ws
        psd = gam1*(wd0(i-da*i0, j-da*j0, 5)-half*(temp*rosd+ros*(2*us*&
&         usd+2*vs*vsd+2*ws*wsd)))
        ps = gam1*(w(i-da*i0, j-da*j0, 5)-half*(ros*temp))
        vnsd = nxnorm*usd + nynorm*vsd
        vns = us*nxnorm + vs*nynorm
        utsd = usd - nxnorm*vnsd
        uts = us - vns*nxnorm
        vtsd = vsd - nynorm*vnsd
        vts = vs - vns*nynorm
        temp = w(i-da*i0, j-da*j0, 5) + ps
        hrd = rosm1*(wd0(i-da*i0, j-da*j0, 5)+psd) + temp*rosm1d
        hr = temp*rosm1
        temp = SQRT(ros*rom1)
        IF (ros*rom1 .EQ. 0.0) THEN
          rd = 0.0_8
        ELSE
          rd = (rom1*rosd+ros*rom1d)/(2.0*temp)
        END IF
        r = temp
        temp = SQRT(ros*rod)
        IF (ros*rod .EQ. 0.0) THEN
          rrd = 0.0_8
        ELSE
          rrd = (rod*rosd+ros*rodd)/(2.0*temp)
        END IF
        rr = temp
        temp = one/(one+r)
        oneonrplusoned = -(temp*rd/(one+r))
        oneonrplusone = temp
        uud = oneonrplusone*(r*usd+us*rd+udd) + (us*r+ud)*oneonrplusoned
        uu = (us*r+ud)*oneonrplusone
        vvd = oneonrplusone*(r*vsd+vs*rd+vdd) + (vs*r+vd)*oneonrplusoned
        vv = (vs*r+vd)*oneonrplusone
        wwd = oneonrplusone*(r*wsd+ws*rd+wdd) + (ws*r+wd)*oneonrplusoned
        ww = (ws*r+wd)*oneonrplusone
        eed = half*(2*uu*uud+2*vv*vvd+2*ww*wwd)
        ee = half*(uu*uu+vv*vv+ww*ww)
        hhd = oneonrplusone*(r*hrd+hr*rd+hld) + (hr*r+hl)*oneonrplusoned
        hh = (hr*r+hl)*oneonrplusone
        sound2d = gam1*(hhd-eed)
        sound2 = gam1*(hh-ee)
        temp = SQRT(sound2)
        IF (sound2 .EQ. 0.0) THEN
          result1d = 0.0_8
        ELSE
          result1d = sound2d/(2.0*temp)
        END IF
        result1 = temp
        roc0d = result1*rrd + rr*result1d
        roc0 = rr*result1
        roc0m1d = -(one*roc0d/roc0**2)
        roc0m1 = one/roc0
! updated State -----------------------------------------------------------
! Wave directions (eps) from Bnd are used in the ghost cells
        utd0 = eps0*utsd + (one-eps0)*utdd
        ut = eps0*uts + (one-eps0)*utd
        vtd0 = eps0*vtsd + (one-eps0)*vtdd
        vt = eps0*vts + (one-eps0)*vtd
        amd = epsm*(psd-vns*roc0d-roc0*vnsd) + (one-epsm)*(pdd-vnd*roc0d&
&         -roc0*vndd)
        am = epsm*(ps-roc0*vns) + (one-epsm)*(pd-roc0*vnd)
        apd = epsp*(psd+vns*roc0d+roc0*vnsd) + (one-epsp)*(pdd+vnd*roc0d&
&         +roc0*vndd)
        ap = epsp*(ps+roc0*vns) + (one-epsp)*(pd+roc0*vnd)
        vnd0 = half*(roc0m1*(apd-amd)+(ap-am)*roc0m1d)
        vn = (ap-am)*half*roc0m1
        pd0 = half*(apd+amd)
        p = (ap+am)*half
        temp = (p-ps)*(rr*rr)
        bsd = roc0m1**2*(rr**2*(pd0-psd)+(p-ps)*2*rr*rrd) + temp*2*&
&         roc0m1*roc0m1d + rosd
        bs = temp*(roc0m1*roc0m1) + ros
        temp = (p-pd)*(rr*rr)
        b0d = roc0m1**2*(rr**2*(pd0-pdd)+(p-pd)*2*rr*rrd) + temp*2*&
&         roc0m1*roc0m1d + rodd
        b0 = temp*(roc0m1*roc0m1) + rod
        rod0 = eps0*bsd + (one-eps0)*b0d
        ro = eps0*bs + (one-eps0)*b0
        roed = pd0/gam1
        roe = p/gam1
        roud = (ut+nxnorm*vn)*rod0 + ro*(utd0+nxnorm*vnd0)
        rou = ro*(ut+vn*nxnorm)
        rovd = (vt+nynorm*vn)*rod0 + ro*(vtd0+nynorm*vnd0)
        rov = ro*(vt+vn*nynorm)
        row = field(j, de, 4)
        wd0(i-de*i0, j-de*j0, 1) = rod0
        w(i-de*i0, j-de*j0, 1) = ro
        wd0(i-de*i0, j-de*j0, 2) = roud
        w(i-de*i0, j-de*j0, 2) = rou
        wd0(i-de*i0, j-de*j0, 3) = rovd
        w(i-de*i0, j-de*j0, 3) = rov
        wd0(i-de*i0, j-de*j0, 4) = 0.0_8
        w(i-de*i0, j-de*j0, 4) = row
        temp = (row*row+rou*rou+rov*rov)/ro
        wd0(i-de*i0, j-de*j0, 5) = roed + half*(2*rou*roud+2*rov*rovd-&
&         temp*rod0)/ro
        w(i-de*i0, j-de*j0, 5) = roe + half*temp
      END IF
    END DO
  END DO
END SUBROUTINE BC_SUPANDSUBINLET_2D_D

