load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin


  f1=addfile("/iitm2/cccr-res/bhupendra/test_analysis/anm_d_imd_1979_2014.nc","r")
  f2=addfile("/iitm2/cccr-res/bhupendra/test_analysis/d_olr_jun_74_dec_13.nc","r")

  time=f1->time
  time2=f2->time

  rf=f1->rf
  olr=f2->olr

  lat=f1->latitude
  lon=f1->longitude

  ar_avg=wgt_areaave_Wrap(rf(:,0,{15:25},{76:86}), 1., 1., 0)
  indices = ind(ar_avg.le.-10.0 .or. ar_avg.ge.10.0)

  olr&time = cd_convert(olr&time, rf&time@units)
  time2 = olr&time

  t_vals = time(indices)

  t2_indices = get1Dindex(time, t_vals)
  print(time2(t2_indices))



  ; ; print(time)
  ; do it = 0, 100, 1    ; doc
  ;   print("time: " + rf&time(it) + " time2: " + olr&time(it))
  ; end do

end
