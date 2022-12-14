! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_supandsubinlet_2d_d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs w
!ith!StaticTaping):
!   variations   of useful results: wd0 w
!   with respect to varying inputs: w
!   RW status of diff variables: wd0:out w:in-out
!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_supandsubinlet_2d in forward (tangent) mode (with options with!SliceDeadControl with!SliceDeadInstrs wit
!h!StaticTaping):
!   variations   of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
SUBROUTINE BC_SUPANDSUBINLET_2D_D_D(w, wd1, wd0, wd0d, loc, interf, &
& field, nx, ny, gam, im, jm, lm, gh)
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
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wd1
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wd0
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wd0d
! Non-required arguments -------------------------------------------
  REAL*8 :: ro, uu, vv, ww, velo2, p0, sound2, mach, rom1
  REAL*8 :: rod1, uud0, vvd0, wwd0, sound2d0, rom1d0
  REAL*8 :: rod0, uud, vvd, wwd, sound2d, rom1d
  REAL*8 :: rod0d, uudd, vvdd, wwdd, sound2dd, rom1dd
  REAL*8 :: ros, us, vs, ws, ps, uts, vts, vns
  REAL*8 :: rosd0, usd0, vsd0, wsd0, psd0, utsd0, vtsd0, vnsd0
  REAL*8 :: rosd, usd, vsd, wsd, psd, utsd, vtsd, vnsd
  REAL*8 :: rosdd, usdd, vsdd, wsdd, psdd, utsdd, vtsdd, vnsdd
  REAL*8 :: rod, ud, vd, wd, pd, utd, vtd, vnd
  REAL*8 :: rodd0, udd0, vdd0, wdd0, pdd0, utdd0, vtdd0, vndd0
  REAL*8 :: rodd, udd, vdd, wdd, pdd, utdd, vtdd, vndd
  REAL*8 :: roddd, uddd, vddd, wddd, pddd, utddd, vtddd, vnddd
  REAL*8 :: p, e, ut, vt, vn, am, ap, bs, b0
  REAL*8 :: pd1, utd1, vtd1, vnd1, amd0, apd0, bsd0, b0d0
  REAL*8 :: pd0, utd0, vtd0, vnd0, amd, apd, bsd, b0d
  REAL*8 :: pd0d, utd0d, vtd0d, vnd0d, amdd, apdd, bsdd, b0dd
  REAL*8 :: ro0m1, rodm1, roc0m1, rosm1
  REAL*8 :: roc0m1d0, rosm1d0
  REAL*8 :: roc0m1d, rosm1d
  REAL*8 :: roc0m1dd, rosm1dd
  REAL*8 :: nsum, nxloc, nyloc, nxnorm, nynorm
  REAL*8 :: gam1, epsm, eps0, epsp, roc0, rovn0
  REAL*8 :: roc0d0
  REAL*8 :: roc0d
  REAL*8 :: roc0dd
  REAL*8 :: r, rr, oneonrplusone
  REAL*8 :: rd0, rrd0, oneonrplusoned0
  REAL*8 :: rd, rrd, oneonrplusoned
  REAL*8 :: rdd, rrdd, oneonrplusonedd
  REAL*8 :: wr1, wr2, wr3, wr4, wr5, pr, hr
  REAL*8 :: hrd0
  REAL*8 :: hrd
  REAL*8 :: hrdd
  REAL*8 :: wl1, wl2, wl3, wl4, wl5, pl, hl, ee, hh
  REAL*8 :: hld0, eed0, hhd0
  REAL*8 :: hld, eed, hhd
  REAL*8 :: hldd, eedd, hhdd
  REAL*8 :: rou, rov, row, roe
  REAL*8 :: roud0, rovd0, roed0
  REAL*8 :: roud, rovd, roed
  REAL*8 :: roudd, rovdd, roedd
  REAL*8 :: half, one
  INTEGER :: da
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC SQRT
  INTRINSIC SIGN
  REAL*8 :: arg1
  REAL*8 :: result1
  REAL*8 :: result1d0
  REAL*8 :: result1d
  REAL*8 :: result1dd
  REAL*8 :: temp
  REAL*8 :: tempd
  REAL*8 :: temp0
  REAL*8 :: temp1
! ---------------------------------------------------------------------------
!
  imin = interf(1, 1)
  jmin = interf(1, 2)
  imax = interf(2, 1)
  jmax = interf(2, 2)
!   write(200,*) loc, 'imin = ', interf(1,1)
!   write(200,*) loc, 'jmin = ', interf(1,2)
!   write(200,*) loc, 'imax = ', interf(2,1)
!   write(200,*) loc, 'jmax = ', interf(2,2)
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
      wd0d(i-de*i0, j-de*j0, 1) = 0.0_8
      wd0(i-de*i0, j-de*j0, 1) = 0.0_8
      wd1(i-de*i0, j-de*j0, 1) = 0.0_8
      w(i-de*i0, j-de*j0, 1) = field(l, de, 1)
      wd0d(i-de*i0, j-de*j0, 2) = 0.0_8
      wd0(i-de*i0, j-de*j0, 2) = 0.0_8
      wd1(i-de*i0, j-de*j0, 2) = 0.0_8
      w(i-de*i0, j-de*j0, 2) = field(l, de, 2)
      wd0d(i-de*i0, j-de*j0, 3) = 0.0_8
      wd0(i-de*i0, j-de*j0, 3) = 0.0_8
      wd1(i-de*i0, j-de*j0, 3) = 0.0_8
      w(i-de*i0, j-de*j0, 3) = field(l, de, 3)
      wd0d(i-de*i0, j-de*j0, 4) = 0.0_8
      wd0(i-de*i0, j-de*j0, 4) = 0.0_8
      wd1(i-de*i0, j-de*j0, 4) = 0.0_8
      w(i-de*i0, j-de*j0, 4) = field(l, de, 4)
      wd0d(i-de*i0, j-de*j0, 5) = 0.0_8
      wd0(i-de*i0, j-de*j0, 5) = 0.0_8
      wd1(i-de*i0, j-de*j0, 5) = 0.0_8
      w(i-de*i0, j-de*j0, 5) = field(l, de, 5)
      da = de - 1
      IF (mach .LT. one) THEN
! l-state
        roddd = wd0d(i-de*i0, j-de*j0, 1)
        rodd = wd0(i-de*i0, j-de*j0, 1)
        rodd0 = wd1(i-de*i0, j-de*j0, 1)
        rod = w(i-de*i0, j-de*j0, 1)
        temp0 = rodd/(rod*rod)
        rom1dd = -(one*(roddd-temp0*2*rod*rodd0)/rod**2)
        rom1d = -(one*temp0)
        rom1d0 = -(one*rodd0/rod**2)
        rom1 = one/rod
        tempd = wd1(i-de*i0, j-de*j0, 2)
        temp = w(i-de*i0, j-de*j0, 2)
        temp0 = wd0(i-de*i0, j-de*j0, 2)
        uddd = temp0*rom1d0 + rom1*wd0d(i-de*i0, j-de*j0, 2) + rom1d*&
&         tempd + temp*rom1dd
        udd = rom1*temp0 + temp*rom1d
        udd0 = rom1*tempd + temp*rom1d0
        ud = temp*rom1
        tempd = wd1(i-de*i0, j-de*j0, 3)
        temp = w(i-de*i0, j-de*j0, 3)
        temp0 = wd0(i-de*i0, j-de*j0, 3)
        vddd = temp0*rom1d0 + rom1*wd0d(i-de*i0, j-de*j0, 3) + rom1d*&
&         tempd + temp*rom1dd
        vdd = rom1*temp0 + temp*rom1d
        vdd0 = rom1*tempd + temp*rom1d0
        vd = temp*rom1
        tempd = wd1(i-de*i0, j-de*j0, 4)
        temp = w(i-de*i0, j-de*j0, 4)
        temp0 = wd0(i-de*i0, j-de*j0, 4)
        wddd = temp0*rom1d0 + rom1*wd0d(i-de*i0, j-de*j0, 4) + rom1d*&
&         tempd + temp*rom1dd
        wdd = rom1*temp0 + temp*rom1d
        wdd0 = rom1*tempd + temp*rom1d0
        wd = temp*rom1
        tempd = 2*ud*udd0 + 2*vd*vdd0 + 2*wd*wdd0
        temp = ud*ud + vd*vd + wd*wd
        temp0 = 2*ud*udd + 2*vd*vdd + 2*wd*wdd
        pddd = gam1*(wd0d(i-de*i0, j-de*j0, 5)-half*(rodd*tempd+temp*&
&         roddd+temp0*rodd0+rod*(udd*2*udd0+2*ud*uddd+vdd*2*vdd0+2*vd*&
&         vddd+wdd*2*wdd0+2*wd*wddd)))
        pdd = gam1*(wd0(i-de*i0, j-de*j0, 5)-half*(temp*rodd+rod*temp0))
        pdd0 = gam1*(wd1(i-de*i0, j-de*j0, 5)-half*(temp*rodd0+rod*tempd&
&         ))
        pd = gam1*(w(i-de*i0, j-de*j0, 5)-half*(rod*temp))
        vnddd = nxnorm*uddd + nynorm*vddd
        vndd = nxnorm*udd + nynorm*vdd
        vndd0 = nxnorm*udd0 + nynorm*vdd0
        vnd = ud*nxnorm + vd*nynorm
        utddd = uddd - nxnorm*vnddd
        utdd = udd - nxnorm*vndd
        utdd0 = udd0 - nxnorm*vndd0
        utd = ud - vnd*nxnorm
        vtddd = vddd - nynorm*vnddd
        vtdd = vdd - nynorm*vndd
        vtdd0 = vdd0 - nynorm*vndd0
        vtd = vd - vnd*nynorm
        tempd = wd1(i-de*i0, j-de*j0, 5) + pdd0
        temp = w(i-de*i0, j-de*j0, 5) + pd
        temp0 = wd0(i-de*i0, j-de*j0, 5) + pdd
        hldd = temp0*rom1d0 + rom1*(wd0d(i-de*i0, j-de*j0, 5)+pddd) + &
&         rom1d*tempd + temp*rom1dd
        hld = rom1*temp0 + temp*rom1d
        hld0 = rom1*tempd + temp*rom1d0
        hl = temp*rom1
! r-state
        rosdd = wd0d(i-da*i0, j-da*j0, 1)
        rosd = wd0(i-da*i0, j-da*j0, 1)
        rosd0 = wd1(i-da*i0, j-da*j0, 1)
        ros = w(i-da*i0, j-da*j0, 1)
        temp0 = rosd/(ros*ros)
        rosm1dd = -(one*(rosdd-temp0*2*ros*rosd0)/ros**2)
        rosm1d = -(one*temp0)
        rosm1d0 = -(one*rosd0/ros**2)
        rosm1 = one/ros
        tempd = wd1(i-da*i0, j-da*j0, 2)
        temp = w(i-da*i0, j-da*j0, 2)
        temp0 = wd0(i-da*i0, j-da*j0, 2)
        usdd = temp0*rosm1d0 + rosm1*wd0d(i-da*i0, j-da*j0, 2) + rosm1d*&
&         tempd + temp*rosm1dd
        usd = rosm1*temp0 + temp*rosm1d
        usd0 = rosm1*tempd + temp*rosm1d0
        us = temp*rosm1
        tempd = wd1(i-da*i0, j-da*j0, 3)
        temp = w(i-da*i0, j-da*j0, 3)
        temp0 = wd0(i-da*i0, j-da*j0, 3)
        vsdd = temp0*rosm1d0 + rosm1*wd0d(i-da*i0, j-da*j0, 3) + rosm1d*&
&         tempd + temp*rosm1dd
        vsd = rosm1*temp0 + temp*rosm1d
        vsd0 = rosm1*tempd + temp*rosm1d0
        vs = temp*rosm1
        tempd = wd1(i-da*i0, j-da*j0, 4)
        temp = w(i-da*i0, j-da*j0, 4)
        temp0 = wd0(i-da*i0, j-da*j0, 4)
        wsdd = temp0*rosm1d0 + rosm1*wd0d(i-da*i0, j-da*j0, 4) + rosm1d*&
&         tempd + temp*rosm1dd
        wsd = rosm1*temp0 + temp*rosm1d
        wsd0 = rosm1*tempd + temp*rosm1d0
        ws = temp*rosm1
        tempd = 2*us*usd0 + 2*vs*vsd0 + 2*ws*wsd0
        temp = us*us + vs*vs + ws*ws
        temp0 = 2*us*usd + 2*vs*vsd + 2*ws*wsd
        psdd = gam1*(wd0d(i-da*i0, j-da*j0, 5)-half*(rosd*tempd+temp*&
&         rosdd+temp0*rosd0+ros*(usd*2*usd0+2*us*usdd+vsd*2*vsd0+2*vs*&
&         vsdd+wsd*2*wsd0+2*ws*wsdd)))
        psd = gam1*(wd0(i-da*i0, j-da*j0, 5)-half*(temp*rosd+ros*temp0))
        psd0 = gam1*(wd1(i-da*i0, j-da*j0, 5)-half*(temp*rosd0+ros*tempd&
&         ))
        ps = gam1*(w(i-da*i0, j-da*j0, 5)-half*(ros*temp))
        vnsdd = nxnorm*usdd + nynorm*vsdd
        vnsd = nxnorm*usd + nynorm*vsd
        vnsd0 = nxnorm*usd0 + nynorm*vsd0
        vns = us*nxnorm + vs*nynorm
        utsdd = usdd - nxnorm*vnsdd
        utsd = usd - nxnorm*vnsd
        utsd0 = usd0 - nxnorm*vnsd0
        uts = us - vns*nxnorm
        vtsdd = vsdd - nynorm*vnsdd
        vtsd = vsd - nynorm*vnsd
        vtsd0 = vsd0 - nynorm*vnsd0
        vts = vs - vns*nynorm
        tempd = wd1(i-da*i0, j-da*j0, 5) + psd0
        temp = w(i-da*i0, j-da*j0, 5) + ps
        temp0 = wd0(i-da*i0, j-da*j0, 5) + psd
        hrdd = temp0*rosm1d0 + rosm1*(wd0d(i-da*i0, j-da*j0, 5)+psdd) + &
&         rosm1d*tempd + temp*rosm1dd
        hrd = rosm1*temp0 + temp*rosm1d
        hrd0 = rosm1*tempd + temp*rosm1d0
        hr = temp*rosm1
        temp0 = SQRT(ros*rom1)
        IF (ros*rom1 .EQ. 0.0) THEN
          tempd = 0.0_8
        ELSE
          tempd = (rom1*rosd0+ros*rom1d0)/(2.0*temp0)
        END IF
        temp = temp0
        IF (ros*rom1 .EQ. 0.0) THEN
          rd = 0.0_8
          rdd = 0.0_8
        ELSE
          temp0 = (rom1*rosd+ros*rom1d)/(2.0*temp)
          rdd = (rosd*rom1d0+rom1*rosdd+rom1d*rosd0+ros*rom1dd-temp0*2.0&
&           *tempd)/(2.0*temp)
          rd = temp0
        END IF
        rd0 = tempd
        r = temp
        temp0 = SQRT(ros*rod)
        IF (ros*rod .EQ. 0.0) THEN
          tempd = 0.0_8
        ELSE
          tempd = (rod*rosd0+ros*rodd0)/(2.0*temp0)
        END IF
        temp = temp0
        IF (ros*rod .EQ. 0.0) THEN
          rrd = 0.0_8
          rrdd = 0.0_8
        ELSE
          temp0 = (rod*rosd+ros*rodd)/(2.0*temp)
          rrdd = (rosd*rodd0+rod*rosdd+rodd*rosd0+ros*roddd-temp0*2.0*&
&           tempd)/(2.0*temp)
          rrd = temp0
        END IF
        rrd0 = tempd
        rr = temp
        temp0 = one/(one+r)
        tempd = -(temp0*rd0/(one+r))
        temp = temp0
        temp0 = temp*rd/(one+r)
        oneonrplusonedd = -((rd*tempd+temp*rdd-temp0*rd0)/(one+r))
        oneonrplusoned = -temp0
        oneonrplusoned0 = tempd
        oneonrplusone = temp
        temp0 = r*usd + us*rd + udd
        uudd = temp0*oneonrplusoned0 + oneonrplusone*(usd*rd0+r*usdd+rd*&
&         usd0+us*rdd+uddd) + oneonrplusoned*(r*usd0+us*rd0+udd0) + (us*&
&         r+ud)*oneonrplusonedd
        uud = oneonrplusone*temp0 + (us*r+ud)*oneonrplusoned
        uud0 = oneonrplusone*(r*usd0+us*rd0+udd0) + (us*r+ud)*&
&         oneonrplusoned0
        uu = (us*r+ud)*oneonrplusone
        temp0 = r*vsd + vs*rd + vdd
        vvdd = temp0*oneonrplusoned0 + oneonrplusone*(vsd*rd0+r*vsdd+rd*&
&         vsd0+vs*rdd+vddd) + oneonrplusoned*(r*vsd0+vs*rd0+vdd0) + (vs*&
&         r+vd)*oneonrplusonedd
        vvd = oneonrplusone*temp0 + (vs*r+vd)*oneonrplusoned
        vvd0 = oneonrplusone*(r*vsd0+vs*rd0+vdd0) + (vs*r+vd)*&
&         oneonrplusoned0
        vv = (vs*r+vd)*oneonrplusone
        temp0 = r*wsd + ws*rd + wdd
        wwdd = temp0*oneonrplusoned0 + oneonrplusone*(wsd*rd0+r*wsdd+rd*&
&         wsd0+ws*rdd+wddd) + oneonrplusoned*(r*wsd0+ws*rd0+wdd0) + (ws*&
&         r+wd)*oneonrplusonedd
        wwd = oneonrplusone*temp0 + (ws*r+wd)*oneonrplusoned
        wwd0 = oneonrplusone*(r*wsd0+ws*rd0+wdd0) + (ws*r+wd)*&
&         oneonrplusoned0
        ww = (ws*r+wd)*oneonrplusone
        eedd = half*(uud*2*uud0+2*uu*uudd+vvd*2*vvd0+2*vv*vvdd+wwd*2*&
&         wwd0+2*ww*wwdd)
        eed = half*(2*uu*uud+2*vv*vvd+2*ww*wwd)
        eed0 = half*(2*uu*uud0+2*vv*vvd0+2*ww*wwd0)
        ee = half*(uu*uu+vv*vv+ww*ww)
        temp0 = r*hrd + hr*rd + hld
        hhdd = temp0*oneonrplusoned0 + oneonrplusone*(hrd*rd0+r*hrdd+rd*&
&         hrd0+hr*rdd+hldd) + oneonrplusoned*(r*hrd0+hr*rd0+hld0) + (hr*&
&         r+hl)*oneonrplusonedd
        hhd = oneonrplusone*temp0 + (hr*r+hl)*oneonrplusoned
        hhd0 = oneonrplusone*(r*hrd0+hr*rd0+hld0) + (hr*r+hl)*&
&         oneonrplusoned0
        hh = (hr*r+hl)*oneonrplusone
        sound2dd = gam1*(hhdd-eedd)
        sound2d = gam1*(hhd-eed)
        sound2d0 = gam1*(hhd0-eed0)
        sound2 = gam1*(hh-ee)
        temp0 = SQRT(sound2)
        IF (sound2 .EQ. 0.0) THEN
          tempd = 0.0_8
        ELSE
          tempd = sound2d0/(2.0*temp0)
        END IF
        temp = temp0
        IF (sound2 .EQ. 0.0) THEN
          result1d = 0.0_8
          result1dd = 0.0_8
        ELSE
          temp0 = sound2d/(2.0*temp)
          result1dd = (sound2dd-temp0*2.0*tempd)/(2.0*temp)
          result1d = temp0
        END IF
        result1d0 = tempd
        result1 = temp
        roc0dd = rrd*result1d0 + result1*rrdd + result1d*rrd0 + rr*&
&         result1dd
        roc0d = result1*rrd + rr*result1d
        roc0d0 = result1*rrd0 + rr*result1d0
        roc0 = rr*result1
        temp0 = roc0d/(roc0*roc0)
        roc0m1dd = -(one*(roc0dd-temp0*2*roc0*roc0d0)/roc0**2)
        roc0m1d = -(one*temp0)
        roc0m1d0 = -(one*roc0d0/roc0**2)
        roc0m1 = one/roc0
! updated State -----------------------------------------------------------
! Wave directions (eps) from Bnd are used in the ghost cells
        utd0d = eps0*utsdd + (one-eps0)*utddd
        utd0 = eps0*utsd + (one-eps0)*utdd
        utd1 = eps0*utsd0 + (one-eps0)*utdd0
        ut = eps0*uts + (one-eps0)*utd
        vtd0d = eps0*vtsdd + (one-eps0)*vtddd
        vtd0 = eps0*vtsd + (one-eps0)*vtdd
        vtd1 = eps0*vtsd0 + (one-eps0)*vtdd0
        vt = eps0*vts + (one-eps0)*vtd
        amdd = epsm*(psdd-roc0d*vnsd0-vns*roc0dd-vnsd*roc0d0-roc0*vnsdd)&
&         + (one-epsm)*(pddd-roc0d*vndd0-vnd*roc0dd-vndd*roc0d0-roc0*&
&         vnddd)
        amd = epsm*(psd-vns*roc0d-roc0*vnsd) + (one-epsm)*(pdd-vnd*roc0d&
&         -roc0*vndd)
        amd0 = epsm*(psd0-vns*roc0d0-roc0*vnsd0) + (one-epsm)*(pdd0-vnd*&
&         roc0d0-roc0*vndd0)
        am = epsm*(ps-roc0*vns) + (one-epsm)*(pd-roc0*vnd)
        apdd = epsp*(psdd+roc0d*vnsd0+vns*roc0dd+vnsd*roc0d0+roc0*vnsdd)&
&         + (one-epsp)*(pddd+roc0d*vndd0+vnd*roc0dd+vndd*roc0d0+roc0*&
&         vnddd)
        apd = epsp*(psd+vns*roc0d+roc0*vnsd) + (one-epsp)*(pdd+vnd*roc0d&
&         +roc0*vndd)
        apd0 = epsp*(psd0+vns*roc0d0+roc0*vnsd0) + (one-epsp)*(pdd0+vnd*&
&         roc0d0+roc0*vndd0)
        ap = epsp*(ps+roc0*vns) + (one-epsp)*(pd+roc0*vnd)
        vnd0d = half*((apd-amd)*roc0m1d0+roc0m1*(apdd-amdd)+roc0m1d*(&
&         apd0-amd0)+(ap-am)*roc0m1dd)
        vnd0 = half*(roc0m1*(apd-amd)+(ap-am)*roc0m1d)
        vnd1 = half*(roc0m1*(apd0-amd0)+(ap-am)*roc0m1d0)
        vn = (ap-am)*half*roc0m1
        pd0d = half*(apdd+amdd)
        pd0 = half*(apd+amd)
        pd1 = half*(apd0+amd0)
        p = (ap+am)*half
        tempd = rr**2*(pd1-psd0) + (p-ps)*2*rr*rrd0
        temp = (p-ps)*(rr*rr)
        temp0 = rr*rr*(pd0-psd) + 2*(p-ps)*rr*rrd
        temp1 = 2*temp*roc0m1
        bsdd = temp0*2*roc0m1*roc0m1d0 + roc0m1**2*((pd0-psd)*2*rr*rrd0+&
&         rr**2*(pd0d-psdd)+rr*rrd*2*(pd1-psd0)+2*(p-ps)*(rrd*rrd0+rr*&
&         rrdd)) + roc0m1d*(roc0m1*2*tempd+2*temp*roc0m1d0) + temp1*&
&         roc0m1dd + rosdd
        bsd = roc0m1*roc0m1*temp0 + temp1*roc0m1d + rosd
        bsd0 = roc0m1**2*tempd + temp*2*roc0m1*roc0m1d0 + rosd0
        bs = temp*(roc0m1*roc0m1) + ros
        tempd = rr**2*(pd1-pdd0) + (p-pd)*2*rr*rrd0
        temp = (p-pd)*(rr*rr)
        temp1 = rr*rr*(pd0-pdd) + 2*(p-pd)*rr*rrd
        temp0 = 2*temp*roc0m1
        b0dd = temp1*2*roc0m1*roc0m1d0 + roc0m1**2*((pd0-pdd)*2*rr*rrd0+&
&         rr**2*(pd0d-pddd)+rr*rrd*2*(pd1-pdd0)+2*(p-pd)*(rrd*rrd0+rr*&
&         rrdd)) + roc0m1d*(roc0m1*2*tempd+2*temp*roc0m1d0) + temp0*&
&         roc0m1dd + roddd
        b0d = roc0m1*roc0m1*temp1 + temp0*roc0m1d + rodd
        b0d0 = roc0m1**2*tempd + temp*2*roc0m1*roc0m1d0 + rodd0
        b0 = temp*(roc0m1*roc0m1) + rod
        rod0d = eps0*bsdd + (one-eps0)*b0dd
        rod0 = eps0*bsd + (one-eps0)*b0d
        rod1 = eps0*bsd0 + (one-eps0)*b0d0
        ro = eps0*bs + (one-eps0)*b0
        roedd = pd0d/gam1
        roed = pd0/gam1
        roed0 = pd1/gam1
        roe = p/gam1
        roudd = rod0*(utd1+nxnorm*vnd1) + (ut+nxnorm*vn)*rod0d + (utd0+&
&         nxnorm*vnd0)*rod1 + ro*(utd0d+nxnorm*vnd0d)
        roud = (ut+nxnorm*vn)*rod0 + ro*(utd0+nxnorm*vnd0)
        roud0 = (ut+nxnorm*vn)*rod1 + ro*(utd1+nxnorm*vnd1)
        rou = ro*(ut+vn*nxnorm)
        rovdd = rod0*(vtd1+nynorm*vnd1) + (vt+nynorm*vn)*rod0d + (vtd0+&
&         nynorm*vnd0)*rod1 + ro*(vtd0d+nynorm*vnd0d)
        rovd = (vt+nynorm*vn)*rod0 + ro*(vtd0+nynorm*vnd0)
        rovd0 = (vt+nynorm*vn)*rod1 + ro*(vtd1+nynorm*vnd1)
        rov = ro*(vt+vn*nynorm)
        row = field(j, de, 4)
        wd0d(i-de*i0, j-de*j0, 1) = rod0d
        wd0(i-de*i0, j-de*j0, 1) = rod0
        wd1(i-de*i0, j-de*j0, 1) = rod1
        w(i-de*i0, j-de*j0, 1) = ro
        wd0d(i-de*i0, j-de*j0, 2) = roudd
        wd0(i-de*i0, j-de*j0, 2) = roud
        wd1(i-de*i0, j-de*j0, 2) = roud0
        w(i-de*i0, j-de*j0, 2) = rou
        wd0d(i-de*i0, j-de*j0, 3) = rovdd
        wd0(i-de*i0, j-de*j0, 3) = rovd
        wd1(i-de*i0, j-de*j0, 3) = rovd0
        w(i-de*i0, j-de*j0, 3) = rov
        wd0d(i-de*i0, j-de*j0, 4) = 0.0_8
        wd0(i-de*i0, j-de*j0, 4) = 0.0_8
        wd1(i-de*i0, j-de*j0, 4) = 0.0_8
        w(i-de*i0, j-de*j0, 4) = row
        temp1 = (row*row+rou*rou+rov*rov)/ro
        tempd = (2*rou*roud0+2*rov*rovd0-temp1*rod1)/ro
        temp = temp1
        temp1 = (2*rou*roud+2*rov*rovd-temp*rod0)/ro
        wd0d(i-de*i0, j-de*j0, 5) = roedd + half*(roud*2*roud0+2*rou*&
&         roudd+rovd*2*rovd0+2*rov*rovdd-rod0*tempd-temp*rod0d-temp1*&
&         rod1)/ro
        wd0(i-de*i0, j-de*j0, 5) = roed + half*temp1
        wd1(i-de*i0, j-de*j0, 5) = roed0 + half*tempd
        w(i-de*i0, j-de*j0, 5) = roe + half*temp
      END IF
    END DO
  END DO
END SUBROUTINE BC_SUPANDSUBINLET_2D_D_D

