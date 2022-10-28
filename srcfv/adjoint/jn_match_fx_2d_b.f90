!        Generated by TAPENADE     (INRIA, Ecuador team)
!  Tapenade 3.16 (master) -  9 Oct 2020 17:47
!
!  Differentiation of jn_match_fx_2d in reverse (adjoint) mode (with options with!SliceDeadControl with!SliceDeadInstrs with!Stat
!icTaping):
!   gradient     of useful results: fd fr
!   with respect to varying inputs: fd fr
!   RW status of diff variables: fd:incr fr:in-out
!===============================================================================
! JOIN Match for Fluxes at faces
!===============================================================================
SUBROUTINE JN_MATCH_FX_2D_B(fr, frb, prr, gh1r, gh2r, gh3r, gh4r, imr, &
& jmr, fd, fdb, prd, gh1d, gh2d, gh3d, gh4d, imd, jmd, locr, locd, tr, &
& em, dimf)
  IMPLICIT NONE
!
! Variables for dimension -----------------------------------------
  INTEGER, INTENT(IN) :: imr, jmr, imd, jmd, dimf, em
  INTEGER, INTENT(IN) :: gh1r, gh2r, gh3r, gh4r
  INTEGER, INTENT(IN) :: gh1d, gh2d, gh3d, gh4d
! Input variables -------------------------------------------------
  CHARACTER(len=3), INTENT(IN) :: locr, locd
  REAL*8, DIMENSION(1-gh1d:imd+1+gh2d, 1-gh3d:jmd+1+gh4d, em, dimf), &
& INTENT(IN) :: fd
  REAL*8, DIMENSION(1-gh1d:imd+1+gh2d, 1-gh3d:jmd+1+gh4d, em, dimf) :: &
& fdb
  INTEGER, DIMENSION(2, 2), INTENT(IN) :: prr, prd
  INTEGER, DIMENSION(2), INTENT(IN) :: tr
! Output variables ------------------------------------------------
  REAL*8, DIMENSION(1-gh1r:imr+1+gh2r, 1-gh3r:jmr+1+gh4r, em, dimf), &
& INTENT(INOUT) :: fr
  REAL*8, DIMENSION(1-gh1r:imr+1+gh2r, 1-gh3r:jmr+1+gh4r, em, dimf), &
& INTENT(INOUT) :: frb
! Local variables -------------------------------------------------
  INTEGER, POINTER :: ind1, ind2
  INTEGER :: ir, jr
  INTEGER, TARGET :: id, jd
  INTEGER :: i, j, istep, jstep, idir, jdir, idd, jdd
  INTEGER :: direction, dird
  INTEGER, DIMENSION(2) :: sgnnx
  INTEGER, DIMENSION(2) :: highir, highjr
  INTEGER, DIMENSION(2) :: highid, highjd, i0, j0, i1, i2, j1, j2
  INTRINSIC SIGN
  INTRINSIC ABS
  INTEGER, DIMENSION(2) :: ad_save
  INTEGER, DIMENSION(2) :: ad_save0
  INTEGER :: ad_from
  INTEGER :: ad_to
  INTEGER :: ad_from0
  INTEGER, DIMENSION(2) :: ad_save1
  INTEGER :: ad_to0
  INTEGER, DIMENSION(2) :: ad_save2
  INTEGER :: branch
  INTEGER :: ad_branch
  INTEGER :: ad_branch0
  INTEGER, DIMENSION(2) :: ad_branch1
! -----------------------------------------------------------------
  istep = SIGN(1, tr(1))
  jstep = SIGN(1, tr(2))
  IF (tr(1) .GE. 0.) THEN
    idir = tr(1)
  ELSE
    idir = -tr(1)
  END IF
  IF (tr(2) .GE. 0.) THEN
    jdir = tr(2)
  ELSE
    jdir = -tr(2)
  END IF
  sgnnx(idir) = istep
  sgnnx(jdir) = jstep
!
  highir = 0
  highjr = 0
!
  i0 = 0
  j0 = 0
  i0(idir) = 1
  j0(jdir) = 1
!
  IF (locr .EQ. 'Ihi') THEN
    ad_branch = 0
    highir(1) = 1
  ELSE IF (locr .EQ. 'Jhi') THEN
    ad_branch = 1
    highjr(2) = 1
  ELSE
    ad_branch = 1
  END IF
!
  IF (locd .EQ. 'Ilo') THEN
    i0(1) = 0
    j0(1) = 0
    ad_branch0 = 0
  ELSE IF (locd .EQ. 'Ihi') THEN
    ad_branch0 = 1
    i0(1) = 0
    j0(1) = 0
  ELSE IF (locd .EQ. 'Jlo') THEN
    i0(2) = 0
    j0(2) = 0
    ad_branch0 = 2
  ELSE IF (locd .EQ. 'Jhi') THEN
    ad_branch0 = 3
    i0(2) = 0
    j0(2) = 0
  ELSE
    ad_branch0 = 3
  END IF
!
  IF (istep .EQ. 1) THEN
    i1(:) = 1
    i2(:) = prd(2, idir) - prd(1, idir) + 1 + i0(:)
  ELSE
    i1(:) = prd(2, idir) - prd(1, idir) + 1 + i0(:)
    i2(:) = 1
  END IF
!
  IF (jstep .EQ. 1) THEN
    j1(:) = 1
    j2(:) = prd(2, jdir) - prd(1, jdir) + 1 + j0(:)
  ELSE
    j1(:) = prd(2, jdir) - prd(1, jdir) + 1 + j0(:)
    j2(:) = 1
  END IF
!
  IF (idir .EQ. 1) THEN
    ad_branch1(direction) = 1
    ind1 => id
    ind2 => jd
  ELSE IF (idir .EQ. 2) THEN
    ad_branch1(direction) = 0
    ind1 => jd
    ind2 => id
  ELSE
    ad_branch1(direction) = 0
  END IF
!
  DO direction=1,2
!
    idd = 1
    jdd = 1
    IF (tr(direction) .GE. 0.) THEN
      ad_save(direction) = dird
      dird = tr(direction)
      CALL PUSHCONTROL1B(0)
    ELSE
      ad_save0(direction) = dird
      dird = -tr(direction)
      CALL PUSHCONTROL1B(1)
    END IF
    ad_from0 = j1(dird)
    DO j=ad_from0,j2(dird),jstep
      ad_from = i1(dird)
      DO i=ad_from,i2(dird),istep
        CALL PUSHINTEGER4(ir)
        ir = prr(1, 1) + idd - 1 + highir(direction)
!
        idd = idd + 1
      END DO
      CALL PUSHINTEGER4(i - istep)
      CALL PUSHINTEGER4(ad_from)
      idd = 1
      CALL PUSHINTEGER4(jdd)
      jdd = jdd + 1
    END DO
    ad_save2(direction) = j - jstep
    ad_save1(direction) = ad_from0
  END DO
  DO direction=2,1,-1
    ad_from0 = ad_save1(direction)
    ad_to0 = ad_save2(direction)
    DO j=ad_to0,ad_from0,-jstep
      CALL POPINTEGER4(jdd)
      CALL POPINTEGER4(ad_from)
      CALL POPINTEGER4(ad_to)
      DO i=ad_to,ad_from,-istep
        jr = prr(1, 2) + jdd - 1 + highjr(direction)
        fdb(:, ind1, ind2, dird) = fdb(:, ind1, ind2, dird) + sgnnx(dird&
&         )*frb(:, ir, jr, direction)
        frb(:, ir, jr, direction) = 0.0_8
        CALL POPINTEGER4(ir)
      END DO
    END DO
    CALL POPCONTROL1B(branch)
    IF (branch .EQ. 0) THEN
      dird = ad_save(direction)
    ELSE
      dird = ad_save0(direction)
    END IF
  END DO
END SUBROUTINE JN_MATCH_FX_2D_B
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

