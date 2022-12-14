! This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of bc_no_reflexion_precis_2d in reverse (adjoint) mode (with options with!SliceDeadControl with!SliceDeadInstr
!s with!StaticTaping):
!   gradient     of useful results: w
!   with respect to varying inputs: w
!   RW status of diff variables: w:in-out
!
!==============================================================================
!     BC No-Ref_2D:  Euler & NS
!==============================================================================
!
SUBROUTINE BC_NO_REFLEXION_PRECIS_2D_B(w, wb, wbd, loc, interf, nx, ny, &
& gam, gh, im, jm, lm)
  IMPLICIT NONE
! Variables for dimension ---------------------------------------------------
  INTEGER, INTENT(IN) :: im, jm, lm
  INTEGER, INTENT(IN) :: gh
! Input variables -----------------------------------------------------------
  REAL*8, INTENT(IN) :: gam
  CHARACTER(len=3), INTENT(IN) :: loc
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: interf
  REAL*8, DIMENSION(lm, 5), INTENT(IN) :: wbd
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: nx
  REAL*8, DIMENSION(1-gh:im+gh+1, 1-gh:jm+gh+1, 2), INTENT(IN) :: ny
! Returned objects ----------------------------------------------------------
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: w
  REAL*8, DIMENSION(1-gh:im+gh, 1-gh:jm+gh, 5), INTENT(INOUT) :: wb
! Local variables -----------------------------------------------------------
  REAL*8 :: ro0, uu, vv, ww, roc0, rovn0, epsm, epsp, eps0, p0
  REAL*8 :: ro0b, uub, vvb, wwb, roc0b, p0b
  REAL*8 :: ros, us, vs, ws, ps, uts, vts, vns
  REAL*8 :: rosb, usb, vsb, wsb, psb, utsb, vtsb, vnsb
  REAL*8 :: rod, ud, vd, wd, pd, utd, vtd, vnd
  REAL*8 :: rodb, udb, vdb, wdb, pdb, utdb, vtdb, vndb
  REAL*8 :: ro, p, e, ut, vt, wt, vn, am, ap, bs, b0
  REAL*8 :: rob, pb, utb, vtb, wtb, vnb, amb, apb, bsb, b0b
  REAL*8 :: ro0m1, rodm1, roc0m1, rosm1, rom1, roe
  REAL*8 :: ro0m1b, rodm1b, roc0m1b, rosm1b, rom1b, roeb
  REAL*8 :: nxloc, nyloc, nsum, nsumi, sens
  REAL*8 :: nxnorm, nynorm, gam1, one, half, two
  REAL*8 :: rou, rov, row, roe1, roe2
  REAL*8 :: roub, rovb, rowb, roe1b, roe2b
  INTEGER :: da, i1, j1
! ---------------------------------------------------------------------------
! Local variables -----------------------------------------------------------
  INTEGER :: kdir, de, i, j, imin, imax, jmin, jmax, lmin, lmax, l, i0, &
& j0, high
  INTRINSIC FLOAT
  INTRINSIC SQRT
  INTRINSIC SIGN
  REAL*8 :: temp
  REAL*8 :: tempb
  REAL*8 :: temp0
  REAL*8 :: tempb0
  REAL*8 :: tempb1
  REAL*8 :: ad_save
  REAL*8 :: ad_save0
  REAL*8 :: ad_save1
  REAL*8 :: ad_save2
  REAL*8 :: ad_save3
  INTEGER :: ad_branch
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
  half = 0.5d0
  gam1 = gam - one
!
  sens = FLOAT(i0 + j0)
!
  i1 = i0*i0
  j1 = j0*j0
!$BWD-OF II-LOOP 
  DO l=lmin,lmax
    i = imin + (l-lmin)*j1
    j = jmin + (l-lmin)*i1
! normals------------------------------------------------------------------
    nxloc = nx(i+high*i1, j+high*j1, kdir)
    nyloc = ny(i+high*i1, j+high*j1, kdir)
! highis used to select the last normal when the face is of type *hi
    nsum = SQRT(nxloc*nxloc + nyloc*nyloc)
    nsumi = one/nsum
    nxnorm = nxloc*nsumi*sens
    nynorm = nyloc*nsumi*sens
! 0-State --------------------------------------------------------------
    ro0 = w(i, j, 1)
    ro0m1 = one/ro0
    uu = w(i, j, 2)*ro0m1
    vv = w(i, j, 3)*ro0m1
    ww = w(i, j, 4)*ro0m1
    roe1 = w(i, j, 5) - half*ro0*(uu*uu+vv*vv+ww*ww)
    p0 = gam1*roe1
    roc0 = ro0*SQRT(gam*p0*ro0m1)
    roc0m1 = one/roc0
    rovn0 = w(i, j, 2)*nxnorm + w(i, j, 3)*nynorm
    epsm = half + SIGN(half, roc0 - rovn0)
    eps0 = half + SIGN(half, -rovn0)
    epsp = half + SIGN(half, -roc0 - rovn0)
! d-State ------------for computational domain border: dState = state_inf ---
    rod = wbd(l, 1)
    rodm1 = one/rod
    ud = wbd(l, 2)*rodm1
    vd = wbd(l, 3)*rodm1
    wd = wbd(l, 4)*rodm1
    pd = gam1*(wbd(l, 5)-rod*half*(ud*ud+vd*vd+wd*wd))
    vnd = ud*nxnorm + vd*nynorm
    utd = ud - vnd*nxnorm
    vtd = vd - vnd*nynorm
! sch-State ---------------------------------------------------------------
    ros = w(i, j, 1)
    rosm1 = one/ros
    us = w(i, j, 2)*rosm1
    vs = w(i, j, 3)*rosm1
    ws = w(i, j, 4)*rosm1
    ps = gam1*(w(i, j, 5)-ros*half*(us*us+vs*vs+ws*ws))
    vns = us*nxnorm + vs*nynorm
    uts = us - vns*nxnorm
    vts = vs - vns*nynorm
! wts   = ws - vns * nznorm
! updated State -----------------------------------------------------------
    ut = eps0*uts + (one-eps0)*utd
    vt = eps0*vts + (one-eps0)*vtd
    wt = eps0*ws + (one-eps0)*wd
! wt = TWO *wd  - ws !extrap o2
    am = epsm*(ps-roc0*vns) + (one-epsm)*(pd-roc0*vnd)
    ap = epsp*(ps+roc0*vns) + (one-epsp)*(pd+roc0*vnd)
    vn = (ap-am)*half*roc0m1
    p = (ap+am)*half
    bs = (p-ps)*ro0*ro0*roc0m1*roc0m1 + ros
    b0 = (p-pd)*ro0*ro0*roc0m1*roc0m1 + rod
    ro = eps0*bs + (one-eps0)*b0
    rom1 = one/ro
    roe = p/gam1
! rou = ro  * (TWO*(ut + vn*nxnorm) - us)
! rov = ro  * (TWO*(vt + vn*nynorm) - vs)
    rou = ro*(ut+vn*nxnorm)
    rov = ro*(vt+vn*nynorm)
    row = ro*wt
    roe2 = roe + half*rom1*(rou*rou+rov*rov+row*row)
    ad_save = w(i-1*i0, j-1*j0, 1)
    w(i-1*i0, j-1*j0, 1) = ro
    ad_save0 = w(i-1*i0, j-1*j0, 2)
    w(i-1*i0, j-1*j0, 2) = rou
    ad_save1 = w(i-1*i0, j-1*j0, 3)
    w(i-1*i0, j-1*j0, 3) = rov
    ad_save2 = w(i-1*i0, j-1*j0, 4)
    w(i-1*i0, j-1*j0, 4) = row
! w(i-1*i0,j-1*j0,5) = roe + HALF * rom1 * (rou*rou+rov*rov+row*row)
    ad_save3 = w(i-1*i0, j-1*j0, 5)
    w(i-1*i0, j-1*j0, 5) = roe2
    DO de=2,gh
      da = de - 1
! l-State ------------for computational domain border: dState = state_inf ---
      CALL PUSHREAL8(rod)
      rod = w(i-de*i0, j-de*j0, 1)
      rodm1 = one/rod
      CALL PUSHREAL8(ud)
      ud = wbd(l, 2)*rodm1
      CALL PUSHREAL8(vd)
      vd = wbd(l, 3)*rodm1
      CALL PUSHREAL8(wd)
      wd = wbd(l, 4)*rodm1
      CALL PUSHREAL8(pd)
      pd = gam1*(wbd(l, 5)-rod*half*(ud*ud+vd*vd+wd*wd))
      CALL PUSHREAL8(vnd)
      vnd = ud*nxnorm + vd*nynorm
      utd = ud - vnd*nxnorm
      vtd = vd - vnd*nynorm
! r-State ---------------------------------------------------------------
      CALL PUSHREAL8(ros)
      ros = w(i-da*i0, j-da*j0, 1)
      rosm1 = one/ros
      CALL PUSHREAL8(us)
      us = w(i, j, 2)*rosm1
      CALL PUSHREAL8(vs)
      vs = w(i, j, 3)*rosm1
      CALL PUSHREAL8(ws)
      ws = w(i, j, 4)*rosm1
      CALL PUSHREAL8(ps)
      ps = gam1*(w(i, j, 5)-ros*half*(us*us+vs*vs+ws*ws))
      CALL PUSHREAL8(vns)
      vns = us*nxnorm + vs*nynorm
      uts = us - vns*nxnorm
      vts = vs - vns*nynorm
! wts   = ws - vns * nznorm
! updated State -----------------------------------------------------------
      CALL PUSHREAL8(ut)
      ut = eps0*uts + (one-eps0)*utd
      CALL PUSHREAL8(vt)
      vt = eps0*vts + (one-eps0)*vtd
      CALL PUSHREAL8(wt)
      wt = eps0*ws + (one-eps0)*wd
! wt = TWO *wd  - ws !extrap o2
      CALL PUSHREAL8(am)
      am = epsm*(ps-roc0*vns) + (one-epsm)*(pd-roc0*vnd)
      CALL PUSHREAL8(ap)
      ap = epsp*(ps+roc0*vns) + (one-epsp)*(pd+roc0*vnd)
      CALL PUSHREAL8(vn)
      vn = (ap-am)*half*roc0m1
      CALL PUSHREAL8(p)
      p = (ap+am)*half
      bs = (p-ps)*ro0*ro0*roc0m1*roc0m1 + ros
      b0 = (p-pd)*ro0*ro0*roc0m1*roc0m1 + rod
      CALL PUSHREAL8(ro)
      ro = eps0*bs + (one-eps0)*b0
      CALL PUSHREAL8(rom1)
      rom1 = one/ro
      roe = p/gam1
! rou = ro  * (TWO*(ut + vn*nxnorm) - us)
! rov = ro  * (TWO*(vt + vn*nynorm) - vs)
      CALL PUSHREAL8(rou)
      rou = ro*(ut+vn*nxnorm)
      CALL PUSHREAL8(rov)
      rov = ro*(vt+vn*nynorm)
      CALL PUSHREAL8(row)
      row = ro*wt
      roe2 = roe + half*rom1*(rou*rou+rov*rov+row*row)
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 1))
      w(i-de*i0, j-de*j0, 1) = ro
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 2))
      w(i-de*i0, j-de*j0, 2) = rou
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 3))
      w(i-de*i0, j-de*j0, 3) = rov
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 4))
      w(i-de*i0, j-de*j0, 4) = row
! w(i-de*i0,j-de*j0,5) = roe + HALF * rom1 * (rou*rou+rov*rov+row*row)
      CALL PUSHREAL8(w(i-de*i0, j-de*j0, 5))
      w(i-de*i0, j-de*j0, 5) = roe2
    END DO
    roc0m1b = 0.0_8
    ro0b = 0.0_8
    roc0b = 0.0_8
    DO de=gh,2,-1
      CALL POPREAL8(w(i-de*i0, j-de*j0, 5))
      roe2b = wb(i-de*i0, j-de*j0, 5)
      wb(i-de*i0, j-de*j0, 5) = 0.0_8
      CALL POPREAL8(w(i-de*i0, j-de*j0, 4))
      CALL POPREAL8(w(i-de*i0, j-de*j0, 3))
      CALL POPREAL8(w(i-de*i0, j-de*j0, 2))
      rosm1 = one/ros
      da = de - 1
      CALL POPREAL8(w(i-de*i0, j-de*j0, 1))
      roeb = roe2b
      rom1b = (rou**2+rov**2+row**2)*half*roe2b
      tempb0 = rom1*half*roe2b
      rowb = wb(i-de*i0, j-de*j0, 4) + 2*row*tempb0
      wb(i-de*i0, j-de*j0, 4) = 0.0_8
      rovb = wb(i-de*i0, j-de*j0, 3) + 2*rov*tempb0
      wb(i-de*i0, j-de*j0, 3) = 0.0_8
      roub = wb(i-de*i0, j-de*j0, 2) + 2*rou*tempb0
      wb(i-de*i0, j-de*j0, 2) = 0.0_8
      rob = wb(i-de*i0, j-de*j0, 1) + wt*rowb + (vt+nynorm*vn)*rovb + (&
&       ut+nxnorm*vn)*roub - one*rom1b/ro**2
      wb(i-de*i0, j-de*j0, 1) = 0.0_8
      CALL POPREAL8(row)
      wtb = ro*rowb
      CALL POPREAL8(rov)
      vtb = ro*rovb
      vnb = nynorm*ro*rovb + nxnorm*ro*roub
      CALL POPREAL8(rou)
      utb = ro*roub
      CALL POPREAL8(rom1)
      CALL POPREAL8(ro)
      bsb = eps0*rob
      b0b = (one-eps0)*rob
      tempb0 = roc0m1**2*b0b
      tempb1 = ro0**2*tempb0
      pb = roeb/gam1 + tempb1
      ro0b = ro0b + 2*ro0*(p-pd)*tempb0
      pdb = -tempb1
      tempb0 = roc0m1**2*bsb
      tempb1 = ro0**2*tempb0
      ro0b = ro0b + 2*ro0*(p-ps)*tempb0
      pb = pb + tempb1
      tempb0 = half*vnb
      roc0m1b = roc0m1b + 2*roc0m1*(p-pd)*ro0**2*b0b + 2*roc0m1*(p-ps)*&
&       ro0**2*bsb + (ap-am)*tempb0
      CALL POPREAL8(p)
      apb = half*pb + roc0m1*tempb0
      amb = half*pb - roc0m1*tempb0
      CALL POPREAL8(vn)
      CALL POPREAL8(ap)
      tempb0 = epsp*apb
      psb = tempb0 - tempb1
      tempb1 = (one-epsp)*apb
      pdb = pdb + tempb1
      roc0b = roc0b + vnd*tempb1 + vns*tempb0
      vndb = roc0*tempb1
      vnsb = roc0*tempb0
      CALL POPREAL8(am)
      tempb0 = epsm*amb
      tempb1 = (one-epsm)*amb
      pdb = pdb + tempb1
      roc0b = roc0b - vnd*tempb1 - vns*tempb0
      psb = psb + tempb0
      CALL POPREAL8(wt)
      CALL POPREAL8(vt)
      vtsb = eps0*vtb
      vtdb = (one-eps0)*vtb
      CALL POPREAL8(ut)
      utsb = eps0*utb
      vnsb = vnsb - roc0*tempb0 - nynorm*vtsb - nxnorm*utsb
      utdb = (one-eps0)*utb
      vndb = vndb - roc0*tempb1 - nynorm*vtdb - nxnorm*utdb
      CALL POPREAL8(vns)
      CALL POPREAL8(ps)
      wb(i, j, 5) = wb(i, j, 5) + gam1*psb
      tempb0 = -(half*gam1*psb)
      tempb1 = ros*tempb0
      wsb = eps0*wtb + 2*ws*tempb1
      vsb = vtsb + nynorm*vnsb + 2*vs*tempb1
      usb = utsb + nxnorm*vnsb + 2*us*tempb1
      wb(i, j, 4) = wb(i, j, 4) + rosm1*wsb
      rosm1b = w(i, j, 4)*wsb + w(i, j, 3)*vsb + w(i, j, 2)*usb
      rosb = bsb + (us**2+vs**2+ws**2)*tempb0 - one*rosm1b/ros**2
      CALL POPREAL8(ws)
      CALL POPREAL8(vs)
      wb(i, j, 3) = wb(i, j, 3) + rosm1*vsb
      CALL POPREAL8(us)
      wb(i, j, 2) = wb(i, j, 2) + rosm1*usb
      CALL POPREAL8(ros)
      wb(i-da*i0, j-da*j0, 1) = wb(i-da*i0, j-da*j0, 1) + rosb
      CALL POPREAL8(vnd)
      CALL POPREAL8(pd)
      tempb0 = -(half*gam1*pdb)
      tempb1 = rod*tempb0
      wdb = (one-eps0)*wtb + 2*wd*tempb1
      vdb = vtdb + nynorm*vndb + 2*vd*tempb1
      udb = utdb + nxnorm*vndb + 2*ud*tempb1
      rodm1b = wbd(l, 4)*wdb + wbd(l, 3)*vdb + wbd(l, 2)*udb
      rodb = b0b + (ud**2+vd**2+wd**2)*tempb0 - one*rodm1b/rod**2
      CALL POPREAL8(wd)
      CALL POPREAL8(vd)
      CALL POPREAL8(ud)
      CALL POPREAL8(rod)
      wb(i-de*i0, j-de*j0, 1) = wb(i-de*i0, j-de*j0, 1) + rodb
    END DO
    w(i-1*i0, j-1*j0, 5) = ad_save3
    roe2b = wb(i-1*i0, j-1*j0, 5)
    wb(i-1*i0, j-1*j0, 5) = 0.0_8
    w(i-1*i0, j-1*j0, 4) = ad_save2
    w(i-1*i0, j-1*j0, 3) = ad_save1
    w(i-1*i0, j-1*j0, 2) = ad_save0
    rosm1 = one/ros
    w(i-1*i0, j-1*j0, 1) = ad_save
    roeb = roe2b
    rom1b = (rou**2+rov**2+row**2)*half*roe2b
    tempb0 = rom1*half*roe2b
    rowb = wb(i-1*i0, j-1*j0, 4) + 2*row*tempb0
    wb(i-1*i0, j-1*j0, 4) = 0.0_8
    rovb = wb(i-1*i0, j-1*j0, 3) + 2*rov*tempb0
    wb(i-1*i0, j-1*j0, 3) = 0.0_8
    roub = wb(i-1*i0, j-1*j0, 2) + 2*rou*tempb0
    wb(i-1*i0, j-1*j0, 2) = 0.0_8
    rob = wb(i-1*i0, j-1*j0, 1) + wt*rowb + (vt+nynorm*vn)*rovb + (ut+&
&     nxnorm*vn)*roub - one*rom1b/ro**2
    wb(i-1*i0, j-1*j0, 1) = 0.0_8
    wtb = ro*rowb
    vtb = ro*rovb
    vnb = nynorm*ro*rovb + nxnorm*ro*roub
    utb = ro*roub
    bsb = eps0*rob
    b0b = (one-eps0)*rob
    tempb0 = roc0m1**2*b0b
    pb = roeb/gam1 + ro0**2*tempb0
    ro0b = ro0b + 2*ro0*(p-pd)*tempb0
    tempb0 = roc0m1**2*bsb
    tempb1 = ro0**2*tempb0
    ro0b = ro0b + 2*ro0*(p-ps)*tempb0
    pb = pb + tempb1
    tempb0 = half*vnb
    roc0m1b = roc0m1b + 2*roc0m1*(p-pd)*ro0**2*b0b + 2*roc0m1*(p-ps)*ro0&
&     **2*bsb + (ap-am)*tempb0
    apb = half*pb + roc0m1*tempb0
    amb = half*pb - roc0m1*tempb0
    tempb0 = epsp*apb
    psb = tempb0 - tempb1
    roc0b = roc0b + vnd*(one-epsp)*apb + vns*tempb0
    vnsb = roc0*tempb0
    tempb0 = epsm*amb
    roc0b = roc0b - vnd*(one-epsm)*amb - vns*tempb0 - one*roc0m1b/roc0**&
&     2
    psb = psb + tempb0
    vtsb = eps0*vtb
    utsb = eps0*utb
    vnsb = vnsb - roc0*tempb0 - nynorm*vtsb - nxnorm*utsb
    tempb0 = -(half*gam1*psb)
    tempb1 = ros*tempb0
    wsb = eps0*wtb + 2*ws*tempb1
    vsb = vtsb + nynorm*vnsb + 2*vs*tempb1
    usb = utsb + nxnorm*vnsb + 2*us*tempb1
    rosm1b = w(i, j, 4)*wsb + w(i, j, 3)*vsb + w(i, j, 2)*usb
    rosb = bsb + (us**2+vs**2+ws**2)*tempb0 - one*rosm1b/ros**2
    temp = gam*p0*ro0m1
    temp0 = SQRT(temp)
    IF (temp .EQ. 0.0) THEN
      tempb0 = 0.0_8
    ELSE
      tempb0 = gam*ro0*roc0b/(2.0*temp0)
    END IF
    p0b = ro0m1*tempb0
    roe1b = gam1*p0b
    wb(i, j, 5) = wb(i, j, 5) + gam1*psb + roe1b
    tempb = -(ro0*half*roe1b)
    uub = 2*uu*tempb
    wb(i, j, 2) = wb(i, j, 2) + rosm1*usb + ro0m1*uub
    vvb = 2*vv*tempb
    wb(i, j, 3) = wb(i, j, 3) + rosm1*vsb + ro0m1*vvb
    wwb = 2*ww*tempb
    wb(i, j, 4) = wb(i, j, 4) + rosm1*wsb + ro0m1*wwb
    ro0m1b = p0*tempb0 + w(i, j, 4)*wwb + w(i, j, 3)*vvb + w(i, j, 2)*&
&     uub
    ro0b = ro0b + temp0*roc0b - (uu**2+vv**2+ww**2)*half*roe1b - one*&
&     ro0m1b/ro0**2
    wb(i, j, 1) = wb(i, j, 1) + rosb + ro0b
  END DO
END SUBROUTINE BC_NO_REFLEXION_PRECIS_2D_B
!

