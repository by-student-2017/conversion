mem2dos.py

電子エネルギー密度 （Electronic energy density *.ted）： he(r) = g(r) + v(r)

※ ( 2* g(r) + v(r) = (ℏ2 / 4m) * ▽2*ρ(r) )

※ *.grd: density (e/Ang^3) = ρ(r)

※ *e.grd: energy (E/Ang^3) = he(r) (*.ted > File > Export Data *.grd > mv *e.grd)

----------
pwscf_band2plot.f

gfortran pwscf_band2plot.f  -o pwscf_band2plot

1. cp case.pw.out f01

2. pwscf_band2plot
  f10: up spin
  f20: down spin

----------
abinit_band2plot.f

gfortran abinit_band2plot.f  -o abinit_band2plot

1. cp case.out f01

2. abinit_band2plot
  f10: up spin
  f20: down spin

----------
