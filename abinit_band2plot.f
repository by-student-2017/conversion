c=======================================================================
c  abinit_band2plot.f
c    2012. 8.11  Version 1.00  written by ***
c=======================================================================
c  process
c --------------------------------------------------------------------
      IMPLICIT NONE

      integer*4 band_num_para
      parameter (band_num_para = 999)
      integer*4 kpoint_num_para
      parameter (kpoint_num_para = 999)
      integer*4 eigen_num_para
      parameter (eigen_num_para = 9999)
     
      character*130 READOR
      character*7 CSPIN
     
c spin
      integer*4 spin
c spin
      integer*4 nband_const
c do loop
      integer*4 i, j, m, n, p, q
c number of kpoint
      integer*4 nband(band_num_para)
c number of kpoint
      integer*4 num_kpoint
c number of kpoint
      integer*4 now_kpoint(kpoint_num_para)
c number of eigen
      integer*4 num_eigen
c read_eigen_line
      integer*4 read_eigen_line
     
c EF_eV
      real*8 EF_eV
c kpoint, h, k, l
      real*8 h(kpoint_num_para), k(kpoint_num_para), l(kpoint_num_para)
c temp_delta_kpoint
      real*8 temp_delta_kpoint
c deltal_kpoint_length = sqrt( temp_delta_kpoint)
      real*8 delta_kpoint_length(kpoint_num_para)
c total_kpoint_length
      real*8 total_kpoint_length(kpoint_num_para)
     
c up and down spin
c eigenvalue(eigenvalue, kpoint, spin)
      real*8 eigenvalue(eigen_num_para, kpoint_num_para, 2)
c eigenvalue_ef = eigenvalue - EF
      real*8 eigenvalue_sub_ef(eigen_num_para, kpoint_num_para, 2)
     
c read line start number
      integer*4 num_eigen_line
      integer*4 num_kpoint_line

c f01 : read *.out data
      open( 1, file = 'f01' )
     
c read basic data
      rewind(01)
      i = 0
      do
        i = i + 1
        read( 1,'( a130 )' ) READOR
c        write(6,*) READOR(1:32)
        if( READOR(1:32) .eq. ' Eigenvalues (   eV  ) for nkpt=' ) then
          num_eigen_line = i - 1
          goto 6100
        end if
      end do
 6100 continue

      rewind(01)
      i = 0
      do
        i = i + 1
        read( 1,'( a130 )' ) READOR
c        write(6,*) READOR(1:32)
        if( num_eigen_line .eq. i ) then
          read( 1,'( 32x,i4, 12x, a7 )' ) num_kpoint, CSPIN
c          write( 6,'(i4, a7, i4)' ) num_kpoint, CSPIN, i
           goto 6200
        end if
      end do
 6200 continue

c read eigenvalue data
c      write(6,*) 'OK'
      if( CSPIN .eq. 'SPIN UP' ) then
        spin = 2
      else
        spin = 1
      end if
c ----
      j = 0
      delta_kpoint_length(1) = 0.0
      total_kpoint_length(1) = 0.0
     
      do p=1, spin
        do j = 1, num_kpoint
          read( 1,'( 5x, i4, 8x, i3, 21x, 3f8.4 )' )
     & now_kpoint(j), nband(j), h(j), k(j), l(j)
          if( j .ge. 2 ) then
            temp_delta_kpoint =
     & (h(j) - h(j-1))**2 + (k(j) - k(j-1))**2 + (l(j) -l(j-1))**2
            delta_kpoint_length(j) = sqrt(temp_delta_kpoint)
            total_kpoint_length(j) = total_kpoint_length(j-1) +
     & delta_kpoint_length(j)
          end if
c ----
          if( mod(nband(j),8) .gt. 0 )then
            read_eigen_line = int(nband(j)/8) + 1
          else
            read_eigen_line = int(nband(j)/8)
          end if
c ----
          do n = 1, read_eigen_line
            read( 1, '( 8(f10.5) )' )
     & ( eigenvalue((m+(n-1)*8), j, p), m=1, 8)
c            write( 6, '( 8(f10.5) )' )
c     & ( eigenvalue((m+(n-1)*8), j, p), m=1, 8)
          end do
        end do
c ----
        read( 1,'( a130 )' ) READOR
      end do
      write(6, *) 'read OK'
     
      close(01)
     
c write output data
     
      nband_const = nband(1)
     
c f05 : band2igor up spin output
      open(10, file = 'f10' )
      do i = 1, nband_const
        write( 10, '( i6 )' ) i
        do j = 1, num_kpoint
          write( 10, '( 6(1x,f8.4) )' ) h(j),k(j),l(j),
     & delta_kpoint_length(j), total_kpoint_length(j),
     & eigenvalue(i, j, 1)
        end do
      end do
      close(10)
     
c f06 : band2igor down spin output
      open(20, file = 'f20' )
      do i = 1, nband_const
        write( 20, '( i6 )' ) i
        do j = 1, num_kpoint
          write( 20, '( 6(1x,f8.4) )' ) h(j),k(j),l(j),
     & delta_kpoint_length(j), total_kpoint_length(j),
     & eigenvalue(i, j, 2)
        end do
      end do
      close(20)
     
      stop
      end
