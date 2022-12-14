  !dist   = abs(yc - yaxe)
  ! x = axe
  ! y = radial
  ! z = theta
  
  distm1    = ONE/(yc(i,j) - ym) 
  !if (distm1.gt.1.d-15) then
  !   distm1    = ONE/abs( distm1 ) ! + 1.d-15
  !endif
  
  voldistm1 = vol(i,j)* distm1 
  lambda    = mu(i,j) * cpprandtl
  
  ur     = w(i,j,3)/w(i,j,1)
  utheta = w(i,j,4)/w(i,j,1)
  htot   = w(i,j,5) + p(i,j) ! htot = htot*ro
  
  !src1_r / (vol/r)   =   ro * ur
  !src2_r / (vol/r)   =   ro * ux * ur 
  !src3_r / (vol/r)   =   ro * ur**2  
  !src4_r / (vol/r)   =   ro * ur * utheta
  !src5_r / (vol/r)   =   ro * ur * htot
  
  !src1_t / (vol/r)   =   0
  !src2_t / (vol/r)   =   0
  !src3_t / (vol/r)   = - ro * utheta**2
  !src4_t / (vol/r)   =   ro * ur * utheta 
  !src5_t / (vol/r)   =   0
  
  srce1  =  w(i,j,3) ! ro*ur 
  srce2  =  ur * w(i,j,2) 
  srce3  =  ur * w(i,j,3) - w(i,j,4)*utheta 
  srce4  =  ur * w(i,j,4) * TWO  
  srce5  =  ur * htot  
  
  divu   = gradu(i,j,1) + gradv(i,j,2) + vely(i,j)*distm1
     
  !t_xx   = TWO * mu(i,j) *  gradu(i,j,1) - TWOTHIRD * mu(i,j) * divu
  t_xy   =       mu(i,j) * (gradv(i,j,1) + gradu(i,j,2))
  t_yy   = TWO * mu(i,j) *  gradv(i,j,2) - TWOTHIRD * mu(i,j) * divu
  t_yz   =       mu(i,j) * (gradw(i,j,2) - utheta*distm1)! +gradv(i,j,3)
  t_zz   = TWO * mu(i,j) * ur * distm1   - TWOTHIRD * mu(i,j) * divu
  
  srcv2  =       t_xy
  srcv3  =       t_yy - t_zz
  srcv4  = TWO * t_yz
  srcv5  = velx(i,j)*t_xy + vely(i,j)*srcv3 + velz(i,j)*srcv4 &
          + lambda * grad_temp(i,j,2) 
          
  ! with irreversible viscous dissipation 
  !srcv5  = velx(i,j)*t_xy + vely(i,j)*srcv3 + velz(i,j)*srcv4 &
  !        + lambda * grad_temp(i,j,2) &
  !        + (yc(i,j) - ym) * ( gradu(i,j,1) * (t_xx+t_xy)  &
  !                           + gradv(i,j,2) * (t_xy+t_yy)) &
  !        +  ur * t_zz
   
  src1   = - voldistm1 *  srce1 
  src2   = - voldistm1 * (srce2 - srcv2)
  src3   = - voldistm1 * (srce3 - srcv3)
  src4   = - voldistm1 * (srce4 - srcv4)
  src5   = - voldistm1 * (srce5 - srcv5)
  
