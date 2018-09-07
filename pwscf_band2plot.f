c=======================================================================
c  pwscf_band2plot.f
c    2012. 8.12  Version 1.00  written by ***
c=======================================================================
c  process
c --------------------------------------------------------------------
      IMPLICIT NONE

      integer*4 kpoint_num_para
      parameter (kpoint_num_para = 999)
      integer*4 eigen_num_para
      parameter (eigen_num_para = 9999)
     
      character*130 READOR
     
c spin
      integer*4 spin
c do loop
      integer*4 i, j, m, n
c number of kpoint
      integer*4 num_kpoint
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
     
c up spin
c eigenvalue(eigenvalue, kpoint, spin)
      real*8 eigenvalue_up(eigen_num_para, kpoint_num_para)
c eigenvalue_ef = eigenvalue - EF
      real*8 eigenvalue_up_sub_ef(eigen_num_para, kpoint_num_para)
     
c down spin
c eigenvalue(eigenvalue, kpoint, spin)
      real*8 eigenvalue_down(eigen_num_para, kpoint_num_para)
c eigenvalue_ef = eigenvalue - EF
      real*8 eigenvalue_down_sub_ef(eigen_num_para, kpoint_num_para)
     
c read line start number
      integer*4 num_eigen_line
      integer*4 num_kpoint_line
     
      spin = 1

c f01 : read *.pw.out data
      open( 1, file = 'f01' )
     
c read basic data
      rewind(01)
      i = 0
      do
        i = i + 1
        read( 1,'( a130 )' ) READOR
        if( READOR(1:32) .eq. '     number of Kohn-Sham states=' ) then
          num_eigen_line = i
        end if
        if( READOR(1:24) .eq. '     number of k points=' ) then
          num_kpoint_line = i - 1
          goto 6100
        end if
      end do
 6100 continue

      rewind(01)
      i = 0
      do
        i = i + 1
        if( num_eigen_line .eq. i ) then
          read( 1,'( 32x,i13 )' ) num_eigen
c          write( 6,'( 32x,i13 )' ) num_eigen
        else
          read( 1,'( a130 )' ) READOR
        end if
        if( num_kpoint_line .eq. i ) then
          read( 1,'( 24x,i8 )' ) num_kpoint
c          write( 6,'( 24x,i8 )' ) num_kpoint
          goto 6200
        end if
      end do
 6200 continue

c read eigenvalue data
c      write(6,*) 'OK'
      do
       
        if( READOR(1:28) .eq. ' ------ SPIN UP ------------' ) then
          spin = 2
          j = 0
          total_kpoint_length(1) = 0.0
          read( 1,'( a130 )' ) READOR
          read( 1,'( a130 )' ) READOR
          do
            j = j + 1
            read( 1,'( 13x, 3f7.4 )' ) h(j), k(j), l(j)
            if( j .ge. 2 ) then
              temp_delta_kpoint =
     & (h(j) - h(j-1))**2 + (k(j) - k(j-1))**2 + (l(j) -l(j-1))**2
            delta_kpoint_length(j) = sqrt(temp_delta_kpoint)
            total_kpoint_length(j) = total_kpoint_length(j-1) +
     & delta_kpoint_length(j)
            end if
            read( 1,'( a130 )' ) READOR
c ----
            if( mod(num_eigen,8) .gt. 0)then
              read_eigen_line = int(num_eigen / 8) + 1
            else
              read_eigen_line = int(num_eigen / 8)
            end if
            do n = 1, read_eigen_line
              read( 1, '( 2x, 8(1x,f8.4) )' )
     & ( eigenvalue_up((m+(n-1)*8), j), m=1, 8)
c              write( 6, '( 2x, 8(1x,f8.4) )' )
c     & ( eigenvalue_up((m+(n-1)*8), j), m=1, 8)
            end do
c ----
            read( 1,'( a130 )' ) READOR
            if( j .ge. (num_kpoint/spin) ) then
              goto 6300
            end if
          end do
          write(6, *) 'SPIN UP OK'
        end if
 6300 continue
       
       
        if( READOR(1:28) .eq. ' ------ SPIN DOWN ----------' ) then
          spin = 2
          j = 0
          total_kpoint_length(1) = 0.0
          read( 1,'( a130 )' ) READOR
          read( 1,'( a130 )' ) READOR
          do
            j = j + 1
            read( 1,'( 13x, 3f7.4 )' ) h(j), k(j), l(j)
            if( j .ge. 2 ) then
              temp_delta_kpoint =
     & (h(j) - h(j-1))**2 + (k(j) - k(j-1))**2 + (l(j) -l(j-1))**2
            delta_kpoint_length(j) = sqrt(temp_delta_kpoint)
            total_kpoint_length(j) = total_kpoint_length(j-1) +
     & delta_kpoint_length(j)
            end if
            read( 1,'( a130 )' ) READOR
c ----
            if( mod(num_eigen,8) .gt. 0)then
              read_eigen_line = int(num_eigen / 8) + 1
            else
              read_eigen_line = int(num_eigen / 8)
            end if
            do n = 1, read_eigen_line
              read( 1, '( 2x, 8(1x,f8.4) )' )
     & ( eigenvalue_down((m+(n-1)*8), j), m=1, 8)
c              write( 6, '( 2x, 8(1x,f8.4) )' )
c     & ( eigenvalue_down((m+(n-1)*8), j), m=1, 8)
            end do
c ----
            read( 1,'( a130 )' ) READOR
            if( j .ge. (num_kpoint/spin) ) then
              goto 6400
            end if
          end do
          write(6, *) 'SPIN DOWN OK'
        end if
 6400 continue
       
        if( (READOR(1:12) .eq. '   JOB DONE.') .and.
     & (spin .eq. 2) ) then
          goto 6500
        end if
       
        read( 1,'( a130 )' ) READOR
        if( (READOR(1:12) .eq. '   JOB DONE.') .and.
     & (spin .eq. 1)) then
          rewind(01)
          do
            if( READOR(1:38) .eq.
     & '     End of band structure calculation' ) then
              spin = 1
              j = 0
              total_kpoint_length(1) = 0.0
              read( 1,'( a130 )' ) READOR
              do
                j = j + 1
                read( 1,'( 13x, 3f7.4 )' ) h(j), k(j), l(j)
                if( j .ge. 2 ) then
                  temp_delta_kpoint =
     & (h(j) - h(j-1))**2 + (k(j) - k(j-1))**2 + (l(j) -l(j-1))**2
                  delta_kpoint_length(j) = sqrt(temp_delta_kpoint)
                  total_kpoint_length(j) = total_kpoint_length(j-1) +
     & delta_kpoint_length(j)
                end if
                read( 1,'( a130 )' ) READOR
c ----
                if( mod(num_eigen,8) .gt. 0)then
                  read_eigen_line = int(num_eigen / 8) + 1
                else
                  read_eigen_line = int(num_eigen / 8)
                end if
                do n = 1, read_eigen_line
                  read( 1, '( 2x, 8(1x,f8.4) )' )
     & ( eigenvalue_up((m+(n-1)*8), j), m=1, 8)
c                  write( 6, '( 2x, 8(1x,f8.4) )' )
c     & ( eigenvalue_up((m+(n-1)*8), j), m=1, 8)
                end do
c ----
                read( 1,'( a130 )' ) READOR
                if( j .ge. (num_kpoint/spin) ) then
                  write(6, *) 'NON SPIN OK'
                  goto 6500
                end if
              end do
            end if
            read( 1,'( a130 )' ) READOR
          end do
        end if
      end do
 6500 continue
      close(01)
     
c write output data
     
c f05 : band2igor up spin output
      open(10, file = 'f10' )
      do i = 1, num_eigen
        write( 10, '( i6 )' ) i
        do j = 1, (num_kpoint/spin)
          write( 10, '( 6(1x,f8.4) )' ) h(j),k(j),l(j),
     & delta_kpoint_length(j), total_kpoint_length(j),
     & eigenvalue_up(i, j)
        end do
      end do
      close(10)
     
c f06 : band2igor down spin output
      open(20, file = 'f20' )
      do i = 1, num_eigen
        write( 20, '( i6 )' ) i
        do j = 1, (num_kpoint/spin)
          write( 20, '( 6(1x,f8.4) )' ) h(j),k(j),l(j),
     & delta_kpoint_length(j), total_kpoint_length(j),
     & eigenvalue_down(i, j)
        end do
      end do
      close(20)
     
      stop
      end
