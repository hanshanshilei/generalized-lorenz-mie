;+
;NAME:
;    BESSELCOEFFICIENTS
;
; PURPOSE:
;    Calculate the coefficients for the vector spherical harmonics of
;    a Bessel beam as a function of position in the field
;
;CATEGORY:
;    Mathematics
;
;CALLING SEQUENCE:
;    {p_mn,q_mn} = besselcoefficients(pos,theta0,maxn)
;
;INPUTS:
;    pos:    array of positions where you want the coefficients
;
;    theta0: Convergence angle of Bessel beam
;
;    maxn:   maximum value of n in the sum
;
;    k: The wavenumber of the light
;
;KEYWORDS:
;    pol: a two element vector of the polarization ([xpol,ypol])
;
;OUTPUTS:
;    {p_mn,q_mn}: Complex coefficients for the vector spherical
;    harmonics
;
;REFERENCE:
;    Taylor, J. M. and G. D. Love. "Multipole expansion of
;    bessel and gaussian beams for mie scattering calculations"
;    J. Opt. Soc. Am. A. 26, 278(2009)
;
;MODIFICATION HISTORY:
; 03/06/2014 Written by David B. Ruffner, New York University
; 03/21/2014 Updated to match notation of sphericalfield.pro
; 04/17/14  Added verbose keyword. David Ruffner
; 09/12/2014 DBR: added a pol keyword for determining polarization of
;                 the bessel beam

function besselcoefficients,pos,theta0,nmax,k,verbose=verbose,pol=pol
tol = 0.0001d
if n_elements(verbose) eq 0 then verbose = 0

am_mn = fltarr(nmax+1,2*nmax+1)*complex(1,0)
ae_mn = fltarr(nmax+1,2*nmax+1)*complex(1,0)

for n=1,nmax do begin
   for m = -n,n do begin
      ;first find the bessel coefficient at required points
      am_ae = besselcoefficient(n,m,pos,theta0,k,pol=pol)
      am_mn[n,m] = am_ae[0]
      ae_mn[n,m] = am_ae[1]
      if abs(am_ae[0]) gt tol and verbose then begin
         print,"m,n",m,n
         print,am_ae
      endif
   endfor
endfor

b1 = where(finite([[[am_mn]],[[ae_mn]]],/nan),/null)
if b1 ne !NULL then begin $
      print, "We have infinities"
      stop
endif & $

return,[[[am_mn]],[[ae_mn]]]
end
















;Author: David Ruffner
