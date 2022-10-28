!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_supandsubinlet_forhessian_2d in reverse (adjoint) mode (with options with!SliceDeadControl with!SliceDea
!dInstrs with!StaticTaping):
!   gradient     of useful results: wout
!   with respect to varying inputs: w wout
!   RW status of diff variables: w:out wout:in-zero
! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed w
!ith this file, You can obtain one at https://mozilla.org/MPL/2.0/.
SUBROUTINE BC_SUPANDSUBINLET_FORHESSIAN_2D_B(wout, woutb, w, wb, loc, &
& interf, field, nx, ny, gam, im, jm, lm, gh)
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
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wb
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wout
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: woutb
! Non-required arguments -------------------------------------------
  REAL*8 :: ro, uu, vv, ww, velo2, p0, sound2, mach, rom1
  REAL*8 :: rob, uub, vvb, wwb, sound2b, rom1b
  REAL*8 :: ros, us, vs, ws, ps, uts, vts, vns
  REAL*8 :: rosb, usb, vsb, wsb, psb, utsb, vtsb, vnsb
  REAL*8 :: rod, ud, vd, wdi, pd, utd, vtd, vnd
  REAL*8 :: rodb, udb, vdb, wdib, pdb, utdb, vtdb, vndb
  REAL*8 :: p, e, ut, vt, vn, am, ap, bs, b0
  REAL*8 :: pb, utb, vtb, vnb, amb, apb, bsb, b0b
  REAL*8 :: ro0m1, rodm1, roc0m1, rosm1
  REAL*8 :: roc0m1b, rosm1b
  REAL*8 :: nsum, nxloc, nyloc, nxnorm, nynorm
  REAL*8 :: gam1, epsm, eps0, epsp, roc0, rovn0
  REAL*8 :: roc0b
  REAL*8 :: r, rr, oneonrplusone
  REAL*8 :: rb, rrb, oneonrplusoneb
  REAL*8 :: wr1, wr2, wr3, wr4, wr5, pr, hr
  REAL*8 :: hrb
  REAL*8 :: wl1, wl2, wl3, wl4, wl5, pl, hl, ee, hh
  REAL*8 :: hlb, eeb, hhb
  REAL*8 :: rou, rov, row, roe
  REAL*8 :: roub, rovb, roeb
  REAL*8 :: half, one
  INTEGER :: da
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC SQRT
  INTRINSIC SIGN
  REAL*8 :: tempb
  REAL*8 :: temp
  REAL*8 :: tempb0
  INTEGER :: branch
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
    kdir = 1
    i0 = 1
    lmax = jmax - jmin + 1
  ELSE IF (loc .EQ. 'Ihi') THEN
    ad_branch = 1
    kdir = 1
    i0 = -1
    lmax = jmax - jmin + 1
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
  ELSE
    ad_branch = 3
  END IF
  half = 0.5d0
  one = 1.d0
  gam1 = gam - one
  wout = w
!$BWD-OF II-LOOP 
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
      nsum = one/SQRT(nxloc*nxloc+nyloc*nyloc)
      nxnorm = nxloc*nsum
      nynorm = nyloc*nsum
      roc0 = rr*SQRT(sound2)
      rovn0 = rr*(uu*nxnorm+vv*nynorm)
      epsm = half + SIGN(half, roc0 - rovn0)
      eps0 = half + SIGN(half, -rovn0)
      epsp = half + SIGN(half, -roc0 - rovn0)
    END IF
    DO de=1,gh
! dirichlet
      CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 1))
      wout(i-de*i0, j-de*j0, 1) = field(l, de, 1)
      CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 2))
      wout(i-de*i0, j-de*j0, 2) = field(l, de, 2)
      CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 3))
      wout(i-de*i0, j-de*j0, 3) = field(l, de, 3)
      CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 4))
      wout(i-de*i0, j-de*j0, 4) = field(l, de, 4)
      CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 5))
      wout(i-de*i0, j-de*j0, 5) = field(l, de, 5)
      da = de - 1
      IF (mach .LT. one) THEN
! l-state
        CALL PUSHREAL8(rod)
        rod = wout(i-de*i0, j-de*j0, 1)
        CALL PUSHREAL8(rom1)
        rom1 = one/rod
        CALL PUSHREAL8(ud)
        ud = wout(i-de*i0, j-de*j0, 2)*rom1
        CALL PUSHREAL8(vd)
        vd = wout(i-de*i0, j-de*j0, 3)*rom1
        wdi = wout(i-de*i0, j-de*j0, 4)*rom1
        CALL PUSHREAL8(pd)
        pd = gam1*(wout(i-de*i0, j-de*j0, 5)-rod*half*(ud*ud+vd*vd+wdi*&
&         wdi))
        CALL PUSHREAL8(vnd)
        vnd = ud*nxnorm + vd*nynorm
        utd = ud - vnd*nxnorm
        vtd = vd - vnd*nynorm
        hl = (wout(i-de*i0, j-de*j0, 5)+pd)*rom1
! r-state
        CALL PUSHREAL8(ros)
        ros = wout(i-da*i0, j-da*j0, 1)
        rosm1 = one/ros
        CALL PUSHREAL8(us)
        us = wout(i-da*i0, j-da*j0, 2)*rosm1
        CALL PUSHREAL8(vs)
        vs = wout(i-da*i0, j-da*j0, 3)*rosm1
        ws = wout(i-da*i0, j-da*j0, 4)*rosm1
        CALL PUSHREAL8(ps)
        ps = gam1*(wout(i-da*i0, j-da*j0, 5)-ros*half*(us*us+vs*vs+ws*ws&
&         ))
        CALL PUSHREAL8(vns)
        vns = us*nxnorm + vs*nynorm
        uts = us - vns*nxnorm
        vts = vs - vns*nynorm
        hr = (wout(i-da*i0, j-da*j0, 5)+ps)*rosm1
        CALL PUSHREAL8(r)
        r = SQRT(ros*rom1)
        CALL PUSHREAL8(rr)
        rr = SQRT(ros*rod)
        oneonrplusone = one/(r+one)
        uu = (us*r+ud)*oneonrplusone
        vv = (vs*r+vd)*oneonrplusone
        ww = (ws*r+wdi)*oneonrplusone
        ee = half*(uu*uu+vv*vv+ww*ww)
        hh = (hr*r+hl)*oneonrplusone
        sound2 = gam1*(hh-ee)
        CALL PUSHREAL8(roc0)
        roc0 = rr*SQRT(sound2)
        roc0m1 = one/roc0
! updated State -----------------------------------------------------------
! Wave directions (eps) from Bnd are used in the ghost cells
        ut = eps0*uts + (one-eps0)*utd
        vt = eps0*vts + (one-eps0)*vtd
        CALL PUSHREAL8(am)
        am = epsm*(ps-roc0*vns) + (one-epsm)*(pd-roc0*vnd)
        CALL PUSHREAL8(ap)
        ap = epsp*(ps+roc0*vns) + (one-epsp)*(pd+roc0*vnd)
        vn = (ap-am)*half*roc0m1
        CALL PUSHREAL8(p)
        p = (ap+am)*half
        bs = (p-ps)*rr*rr*roc0m1*roc0m1 + ros
        b0 = (p-pd)*rr*rr*roc0m1*roc0m1 + rod
        ro = eps0*bs + (one-eps0)*b0
        roe = p/gam1
        rou = ro*(ut+vn*nxnorm)
        rov = ro*(vt+vn*nynorm)
        row = field(j, de, 4)
        CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 1))
        wout(i-de*i0, j-de*j0, 1) = ro
        CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 2))
        wout(i-de*i0, j-de*j0, 2) = rou
        CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 3))
        wout(i-de*i0, j-de*j0, 3) = rov
        CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 4))
        wout(i-de*i0, j-de*j0, 4) = row
        CALL PUSHREAL8(wout(i-de*i0, j-de*j0, 5))
        wout(i-de*i0, j-de*j0, 5) = roe + half*(rou*rou+rov*rov+row*row)&
&         /ro
        CALL PUSHCONTROL1B(1)
      ELSE
        CALL PUSHCONTROL1B(0)
      END IF
    END DO
    DO de=gh,1,-1
      CALL POPCONTROL1B(branch)
      IF (branch .NE. 0) THEN
        vts = vs - vns*nynorm
        roc0m1 = one/roc0
        utd = ud - vnd*nxnorm
        uts = us - vns*nxnorm
        ut = eps0*uts + (one-eps0)*utd
        bs = (p-ps)*rr*rr*roc0m1*roc0m1 + ros
        b0 = (p-pd)*rr*rr*roc0m1*roc0m1 + rod
        ro = eps0*bs + (one-eps0)*b0
        vn = (ap-am)*half*roc0m1
        rou = ro*(ut+vn*nxnorm)
        vtd = vd - vnd*nynorm
        vt = eps0*vts + (one-eps0)*vtd
        rov = ro*(vt+vn*nynorm)
        row = field(j, de, 4)
        CALL POPREAL8(wout(i-de*i0, j-de*j0, 5))
        roeb = woutb(i-de*i0, j-de*j0, 5)
        tempb0 = half*woutb(i-de*i0, j-de*j0, 5)/ro
        woutb(i-de*i0, j-de*j0, 5) = 0.0_8
        roub = 2*rou*tempb0 + woutb(i-de*i0, j-de*j0, 2)
        rovb = 2*rov*tempb0 + woutb(i-de*i0, j-de*j0, 3)
        rob = woutb(i-de*i0, j-de*j0, 1) - (row**2+rou**2+rov**2)*tempb0&
&         /ro + (vt+nynorm*vn)*rovb + (ut+nxnorm*vn)*roub
        CALL POPREAL8(wout(i-de*i0, j-de*j0, 4))
        woutb(i-de*i0, j-de*j0, 4) = 0.0_8
        CALL POPREAL8(wout(i-de*i0, j-de*j0, 3))
        woutb(i-de*i0, j-de*j0, 3) = 0.0_8
        CALL POPREAL8(wout(i-de*i0, j-de*j0, 2))
        woutb(i-de*i0, j-de*j0, 2) = 0.0_8
        rosm1 = one/ros
        da = de - 1
        CALL POPREAL8(wout(i-de*i0, j-de*j0, 1))
        woutb(i-de*i0, j-de*j0, 1) = 0.0_8
        vtb = ro*rovb
        vnb = nynorm*ro*rovb + nxnorm*ro*roub
        utb = ro*roub
        bsb = eps0*rob
        b0b = (one-eps0)*rob
        tempb0 = roc0m1**2*b0b
        tempb = rr**2*tempb0
        pb = roeb/gam1 + tempb
        rrb = 2*rr*(p-pd)*tempb0
        pdb = -tempb
        tempb0 = roc0m1**2*bsb
        tempb = rr**2*tempb0
        rrb = rrb + 2*rr*(p-ps)*tempb0
        pb = pb + tempb
        tempb0 = half*vnb
        roc0m1b = 2*roc0m1*(p-pd)*rr**2*b0b + 2*roc0m1*(p-ps)*rr**2*bsb &
&         + (ap-am)*tempb0
        CALL POPREAL8(p)
        apb = half*pb + roc0m1*tempb0
        amb = half*pb - roc0m1*tempb0
        CALL POPREAL8(ap)
        tempb0 = epsp*apb
        psb = tempb0 - tempb
        tempb = (one-epsp)*apb
        pdb = pdb + tempb
        roc0b = vnd*tempb + vns*tempb0
        vndb = roc0*tempb
        vnsb = roc0*tempb0
        CALL POPREAL8(am)
        tempb0 = epsm*amb
        tempb = (one-epsm)*amb
        roc0b = roc0b - vnd*tempb - vns*tempb0 - one*roc0m1b/roc0**2
        psb = psb + tempb0
        vtsb = eps0*vtb
        vtdb = (one-eps0)*vtb
        utsb = eps0*utb
        vnsb = vnsb - roc0*tempb0 - nynorm*vtsb - nxnorm*utsb
        utdb = (one-eps0)*utb
        vndb = vndb - roc0*tempb - nynorm*vtdb - nxnorm*utdb
        ws = wout(i-da*i0, j-da*j0, 4)*rosm1
        oneonrplusone = one/(r+one)
        wdi = wout(i-de*i0, j-de*j0, 4)*rom1
        ww = (ws*r+wdi)*oneonrplusone
        hl = (wout(i-de*i0, j-de*j0, 5)+pd)*rom1
        hr = (wout(i-da*i0, j-da*j0, 5)+ps)*rosm1
        hh = (hr*r+hl)*oneonrplusone
        uu = (us*r+ud)*oneonrplusone
        vv = (vs*r+vd)*oneonrplusone
        ee = half*(uu*uu+vv*vv+ww*ww)
        sound2 = gam1*(hh-ee)
        CALL POPREAL8(roc0)
        temp = SQRT(sound2)
        rrb = rrb + temp*roc0b
        IF (sound2 .EQ. 0.0) THEN
          sound2b = 0.0_8
        ELSE
          sound2b = rr*roc0b/(2.0*temp)
        END IF
        hhb = gam1*sound2b
        eeb = -(gam1*sound2b)
        tempb0 = oneonrplusone*hhb
        hrb = r*tempb0
        rb = hr*tempb0
        hlb = tempb0
        pdb = pdb + tempb + rom1*hlb
        tempb0 = half*eeb
        uub = 2*uu*tempb0
        vvb = 2*vv*tempb0
        wwb = 2*ww*tempb0
        oneonrplusoneb = (hr*r+hl)*hhb + (ws*r+wdi)*wwb + (vs*r+vd)*vvb &
&         + (us*r+ud)*uub
        tempb0 = oneonrplusone*wwb
        wsb = r*tempb0
        rb = rb + ws*tempb0
        wdib = tempb0
        tempb0 = oneonrplusone*vvb
        vsb = r*tempb0
        rb = rb + vs*tempb0
        vdb = tempb0
        tempb0 = oneonrplusone*uub
        usb = r*tempb0
        rb = rb + us*tempb0 - one*oneonrplusoneb/(one+r)**2
        udb = tempb0
        CALL POPREAL8(rr)
        IF (ros*rod .EQ. 0.0) THEN
          tempb0 = 0.0_8
        ELSE
          tempb0 = rrb/(2.0*SQRT(ros*rod))
        END IF
        rodb = b0b + ros*tempb0
        rosb = bsb + rod*tempb0
        CALL POPREAL8(r)
        IF (ros*rom1 .EQ. 0.0) THEN
          tempb0 = 0.0_8
        ELSE
          tempb0 = rb/(2.0*SQRT(ros*rom1))
        END IF
        rosb = rosb + rom1*tempb0
        rom1b = ros*tempb0
        psb = psb + rosm1*hrb
        woutb(i-da*i0, j-da*j0, 5) = woutb(i-da*i0, j-da*j0, 5) + rosm1*&
&         hrb + gam1*psb
        CALL POPREAL8(vns)
        tempb0 = -(half*gam1*psb)
        tempb = ros*tempb0
        vsb = vsb + vtsb + nynorm*vnsb + 2*vs*tempb
        usb = usb + utsb + nxnorm*vnsb + 2*us*tempb
        wsb = wsb + 2*ws*tempb
        rosm1b = (wout(i-da*i0, j-da*j0, 5)+ps)*hrb + wout(i-da*i0, j-da&
&         *j0, 4)*wsb + wout(i-da*i0, j-da*j0, 3)*vsb + wout(i-da*i0, j-&
&         da*j0, 2)*usb
        CALL POPREAL8(ps)
        rosb = rosb + (us**2+vs**2+ws**2)*tempb0 - one*rosm1b/ros**2
        woutb(i-da*i0, j-da*j0, 4) = woutb(i-da*i0, j-da*j0, 4) + rosm1*&
&         wsb
        CALL POPREAL8(vs)
        woutb(i-da*i0, j-da*j0, 3) = woutb(i-da*i0, j-da*j0, 3) + rosm1*&
&         vsb
        CALL POPREAL8(us)
        woutb(i-da*i0, j-da*j0, 2) = woutb(i-da*i0, j-da*j0, 2) + rosm1*&
&         usb
        CALL POPREAL8(ros)
        woutb(i-da*i0, j-da*j0, 1) = woutb(i-da*i0, j-da*j0, 1) + rosb
        woutb(i-de*i0, j-de*j0, 5) = woutb(i-de*i0, j-de*j0, 5) + rom1*&
&         hlb + gam1*pdb
        CALL POPREAL8(vnd)
        tempb = -(half*gam1*pdb)
        tempb0 = rod*tempb
        vdb = vdb + vtdb + nynorm*vndb + 2*vd*tempb0
        udb = udb + utdb + nxnorm*vndb + 2*ud*tempb0
        wdib = wdib + 2*wdi*tempb0
        rom1b = rom1b + (wout(i-de*i0, j-de*j0, 5)+pd)*hlb + wout(i-de*&
&         i0, j-de*j0, 4)*wdib + wout(i-de*i0, j-de*j0, 3)*vdb + wout(i-&
&         de*i0, j-de*j0, 2)*udb
        CALL POPREAL8(pd)
        rodb = rodb + (ud**2+vd**2+wdi**2)*tempb - one*rom1b/rod**2
        woutb(i-de*i0, j-de*j0, 4) = woutb(i-de*i0, j-de*j0, 4) + rom1*&
&         wdib
        CALL POPREAL8(vd)
        woutb(i-de*i0, j-de*j0, 3) = woutb(i-de*i0, j-de*j0, 3) + rom1*&
&         vdb
        CALL POPREAL8(ud)
        woutb(i-de*i0, j-de*j0, 2) = woutb(i-de*i0, j-de*j0, 2) + rom1*&
&         udb
        CALL POPREAL8(rom1)
        CALL POPREAL8(rod)
        woutb(i-de*i0, j-de*j0, 1) = woutb(i-de*i0, j-de*j0, 1) + rodb
      END IF
      CALL POPREAL8(wout(i-de*i0, j-de*j0, 5))
      woutb(i-de*i0, j-de*j0, 5) = 0.0_8
      CALL POPREAL8(wout(i-de*i0, j-de*j0, 4))
      woutb(i-de*i0, j-de*j0, 4) = 0.0_8
      CALL POPREAL8(wout(i-de*i0, j-de*j0, 3))
      woutb(i-de*i0, j-de*j0, 3) = 0.0_8
      CALL POPREAL8(wout(i-de*i0, j-de*j0, 2))
      woutb(i-de*i0, j-de*j0, 2) = 0.0_8
      CALL POPREAL8(wout(i-de*i0, j-de*j0, 1))
      woutb(i-de*i0, j-de*j0, 1) = 0.0_8
    END DO
  END DO
  wb = 0.0_8
  wb = woutb
  woutb = 0.0_8
END SUBROUTINE BC_SUPANDSUBINLET_FORHESSIAN_2D_B

