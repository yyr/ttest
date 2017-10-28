load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


  f1=addfile("/iitm2/cccr-res/bhupendra/test_analysis/anm_d_imd_1979_2014.nc","r")
  f2=addfile("/iitm2/cccr-res/bhupendra/test_analysis/d_olr_jun_74_dec_13.nc","r")

;; f1 -->> longitude, latitude, z, time, rf(time, z, latitude, longitude) ;
;; f2 -->> lon, lat, z, time, olr(time, lat, lon) ;

  rf=f1->rf
  ; printVarSummary(rf)

  olr=f2->olr
; printVarSummary(olr)

  lat=f1->latitude
; printVarSummary(lat)

  lon=f1->longitude
; printVarSummary(lon)

  time=f1->time
  time2=f2->time
  ; print(time2)
  ; exit
  ; printVarSummary(time)
  ; printVarSummary(time2)

; printVarSummary(time)

; mo = ut_calendar(time, 0)
; printVarSummary(mo)
; month  = mo(:,1)


  ; printMinMax(rf, True)
  ar_avg=wgt_areaave_Wrap(rf(:,0,{15:25},{76:86}), 1., 1., 0)
  ; printMinMax(ar_avg, True)

  indices = ind(ar_avg.le.-10.0 .or. ar_avg.ge.10.0)
  ; print(ar_avg(indices))
  ; print(ut_calendar(time(indices),2))

  t1_extm = ut_calendar(time(indices),-2)
  t2 = ut_calendar(time2,-2)

  t2_ind = new(dimsizes(t1_extm), integer)

  ; do ii = 0, dimsizes(t1_extm) - 1, 1    ; doc
  ;   t2_ind(ii) = ind(t2.eq.t1_extm(ii))
  ; end do

  ; do it = 0, dimsizes(t1_extm) - 10, 1
  ;   print("t1_extm: " + t1_extm + " t2: " + ut_calendar(time2(t2_ind(it)), -2))
  ; end do
  ; exit

  do j = 0, dimsizes(t1_extm)-1, 1
    if
  olr2 = olr({where t2.eq.t1_extm},:,:)
printVarSummary(olr2)
end
