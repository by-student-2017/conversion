#!/usr/bin/python
import sys,math
from numpy import *

if len(sys.argv) == 1:
 print 'No file name provided!'
 print 'For example, >./grd2xplor.py test (it need test.grd and teste.grd)'
 print 'also see comment part of this code.'
 exit()
try:
 base = sys.argv[1]
 f1 = base + '.grd'
 f2 = base + 'e.grd'
 file1 = open(f1,'r')
 file2 = open(f2,'r')
except IOError, (errno, msg):
 print 'grd file open error!'
 exit()

f4 = base + '.dos'
file4 = open(f4,'w')
#f5 = base + '.spc'
#file5 = open(f5,'w')

###############################################################
# read charge density grd
for line in file1:
 #file4.write('\n')
 #file4.write('      1' + '\n')
 #file4.write(line)
 break

for line in file1:
 LCA = float( line[ 1: 8].replace(' ','') )
 LCB = float( line[ 9:17].replace(' ','') )
 LCC = float( line[18:26].replace(' ','') )
 ANA = float( line[27:35].replace(' ','') )
 ANB = float( line[36:44].replace(' ','') )
 ANG = float( line[45:53].replace(' ','') )
 #print LCA, LCB, LCC, ANA, ANB, ANG
 break

for line in file1:
 PX = int( line[ 1: 5].replace(' ','') )
 PY = int( line[ 6:11].replace(' ','') )
 PZ = int( line[12:17].replace(' ','') )
 #print PX, PY, PZ
 break

#file4.write("{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}".format(PX, 0, (PX-1), PY, 0, (PY-1), PZ, 0, (PZ-1)) )
#file4.write('\n')
#file4.write("{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}".format(LCA, LCB, LCC, ANA, ANB, ANG) )
#file4.write('\n')
#file4.write('ZYX')

D3 = zeros([PX+10, PY+10, PZ+10])
D1 = zeros([(PX+1)*(PY+1)*(PZ+1)])
#sum = 0
#var = 0
#esd = 0
DI4sum = 0

I1 = 0
I2 = 0
I3 = 0
for line in file1:
 for I0 in range(6):
  den = line[ (1+15*I0):(15+15*I0)].replace(' ','')
  if den <> '':
   D3[I1][I2][I3+I0] = float(den)
   #D3[I1][I2][I3+0] = float( line[ 1:15].replace(' ','') )
   #D3[I1][I2][I3+1] = float( line[16:30].replace(' ','') )
   #D3[I1][I2][I3+2] = float( line[31:45].replace(' ','') )
   #D3[I1][I2][I3+3] = float( line[46:60].replace(' ','') )
   #D3[I1][I2][I3+4] = float( line[61:75].replace(' ','') )
   #D3[I1][I2][I3+5] = float( line[76:90].replace(' ','') )
   #print D3[I1][I2][I3+I0]
   #file4.write("{: >12.5e}".format( D3[I1][I2][I3+I0]) )
   #file4.write('\n')
   #sum += float(den)
 I3 += 6
 if I3 >= PZ :
  I3 = 0
  I2 += 1
  if I2 >= PY :
   I2 = 0
   I1 += 1
   if I1 >= PX :
    break

#sum /= (PX * PY * PZ)

I4 = 0
for I1 in range(PZ):
 #file4.write( '\n' )
 #file4.write("{: >7d}".format( I1 ) )
 for I2 in range(PY):
  for I3 in range(PZ):
   #if ( I4 % 6 ) == 0 :
    #file4.write( '\n')
   #file4.write("{: >12.5e}".format( D3[I1][I2][I3] ) )
   #var += ( D3[I1][I2][I3] - sum )**2
   D1[I4] = D3[I1][I2][I3]
   I4 += 1

DI4sum = I4 - 1
#print DI4sum, ((PX * PY * PZ) -1)
#file4.write( '\n' + '-9999' + '\n')
#var /= ((PX * PY * PZ) -1)
#esd = sqrt(var)
#file4.write( "{: >12.5e}{: >12.5e}".format(sum, esd) )
#file4.write('\n')

#test
#print I4
#print ((PX-1) * (PY-1) * (PZ-1))
file1.close()
###############################################################
# read charge density e.grd
for line in file2:
 #file4.write('\n')
 #file4.write('      1' + '\n')
 #file4.write(line)
 break

for line in file2:
 LCA = float( line[ 1: 8].replace(' ','') )
 LCB = float( line[ 9:17].replace(' ','') )
 LCC = float( line[18:26].replace(' ','') )
 ANA = float( line[27:35].replace(' ','') )
 ANB = float( line[36:44].replace(' ','') )
 ANG = float( line[45:53].replace(' ','') )
 #print LCA, LCB, LCC, ANA, ANB, ANG
 break

for line in file2:
 PX = int( line[ 1: 5].replace(' ','') )
 PY = int( line[ 6:11].replace(' ','') )
 PZ = int( line[12:17].replace(' ','') )
 #print PX, PY, PZ
 break

#file4.write("{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}{: >8d}".format(PX, 0, (PX-1), PY, 0, (PY-1), PZ, 0, (PZ-1)) )
#file4.write('\n')
#file4.write("{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}{: >12.4f}".format(LCA, LCB, LCC, ANA, ANB, ANG) )
#file4.write('\n')
#file4.write('ZYX')

Vpixel = (LCA * LCB * LCC) / (PX * PY * PZ)

E3 = zeros([PX+10, PY+10, PZ+10])
E1 = zeros([(PX+1)*(PY+1)*(PZ+1)])
#sum = 0
#var = 0
#esd = 0
EI4sum = 0

I1 = 0
I2 = 0
I3 = 0
Sign = -1.0
for line in file2:
 for I0 in range(6):
  #print line[0+15*I0:1+15*I0]
  ene = line[ (1+15*I0):(15+15*I0)].replace(' ','')
  if line[0+15*I0:1+15*I0] == '-':
   Sign = -1.0
  else :
   Sign = 1.0
  if ene <> '':
   E3[I1][I2][I3+I0] = float(ene) * Sign
   #print float(ene) * Sign
   #E3[I1][I2][I3+0] = float( line[ 0:15].replace(' ','') )
   #E3[I1][I2][I3+1] = float( line[16:30].replace(' ','') )
   #E3[I1][I2][I3+2] = float( line[31:45].replace(' ','') )
   #E3[I1][I2][I3+3] = float( line[46:60].replace(' ','') )
   #E3[I1][I2][I3+4] = float( line[61:75].replace(' ','') )
   #E3[I1][I2][I3+5] = float( line[76:90].replace(' ','') )
   #print E3[I1][I2][I3+I0]
   #file4.write("{: >12.5e}".format( E3[I1][I2][I3+I0]) )
   #file4.write('\n')
   #sum += float(ene)
 I3 += 6
 if I3 >= PZ :
  I3 = 0
  I2 += 1
  if I2 >= PY :
   I2 = 0
   I1 += 1
   if I1 >= PX :
    break

#sum /= (PX * PY * PZ)

I4 = 0
for I1 in range(PZ):
 #file4.write( '\n' )
 #file4.write("{: >7d}".format( I1 ) )
 for I2 in range(PY):
  for I3 in range(PZ):
   #if ( I4 % 6 ) == 0 :
    #file4.write( '\n')
   #file4.write("{: >12.5e}".format( E3[I1][I2][I3] ) )
   #var += ( E3[I1][I2][I3] - sum )**2
   E1[I4] = E3[I1][I2][I3]
   I4 += 1

EI4sum = I4 - 1
#print EI4sum, ((PX * PY * PZ) -1)
#file4.write( '\n' + '-9999' + '\n')
#var /= ((PX * PY * PZ) -1)
#esd = sqrt(var)
#file4.write( "{: >12.5e}{: >12.5e}".format(sum, esd) )
#file4.write('\n')

#test
#print I4
#print ((PX-1) * (PY-1) * (PZ-1))
file2.close()
###############################################################
#Write DOS
# convert
#file4.write( ' eV, dens' + '\n' )
I1 = 0
for I1 in range(DI4sum):
 # convert [hartree / bohr^3] -> [hartree / ang^3]
 #E1[I1] = E1[I1] * 6.748333
 # convert [eV / e]
 #E1[I1] = ( E1[I1] * 27.2116 ) / D1[I1]
 # convert [eV]
 E1[I1] = ( E1[I1] * 27.2116 ) * Vpixel
 D1[I1] = D1[I1] * Vpixel
 # print eV, density
 #file4.write("{: >12.5e}".format( E1[I1]) )
 #file4.write(',')
 #file4.write("{: >12.5e}".format( D1[I1] ) )
 #file4.write('\n')

# gaussian broadening
sigma = 0.02
delta = 0.02
step  = 1200
EDOS = zeros([step])
IDOS = zeros([step])
I1 = 0
for I1 in range(step):
 EDOS[I1] = delta * ( I1 - step * 0.5)

I1 = 0
I2 = 0
for I1 in range(DI4sum):
 if E1[I1] < (delta*(step+10)) :
  #print I1
  for I2 in range(step):
   #print D1[I1], (1/(sqrt(2.0*pi)*sigma))*exp(-(1.0/2.0)*((EDOS[I2]-E1[I1])/sigma)**2.0), I2
   IDOS[I2] = IDOS[I2] + D1[I1] * (1/(sqrt(2.0*pi)*sigma))*exp(-(1.0/2.0)*((EDOS[I2]-E1[I1])/sigma)**2.0)

file4.write( ' eV, dos' + '\n' )
I1 = 0
for I1 in range(step):
 file4.write("{: >12.5e}".format( EDOS[I1]) )
 file4.write(',')
 file4.write("{: >12.5e}".format( IDOS[I1] ) )
 file4.write('\n')

file4.close()
#file5.close()
