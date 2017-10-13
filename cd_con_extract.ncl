load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;_____________________________________________________________________________
; Function: get_matched_time_indices
; Doc:
;_____________________________________________________________________________
undef("get_matched_time_indices")
function get_matched_time_indices(from_time, to_time, from_ind)
local time, to_ind, t2_indices, t2_indices_qu, t2_indices_qu_ind, t1_vals, t2_vals

begin
  time = cd_convert(to_time, from_time@units)
  t1_vals = from_time(from_ind)

  t2_indices = get1Dindex(time, t1_vals)
  t2_indices_qu_ind = ind(.not.ismissing(t2_indices))
  t2_indices_qu = t2_indices(t2_indices_qu_ind)
  return(t2_indices_qu)
end

begin
  f1=addfile("/iitm2/cccr-res/bhupendra/test_analysis/anm_d_imd_1979_2014.nc","r")
  f2=addfile("/iitm2/cccr-res/bhupendra/test_analysis/d_olr_jun_74_dec_13.nc","r")
  of = "olr_out.nc"

  system("rm -f " + of)
  o=addfile(of,"c")

  time=f1->time
  time2=f2->time
  ttime = time2

  rf=f1->rf
  olr=f2->olr

  lat=f1->latitude
  lon=f1->longitude

  ar_avg=wgt_areaave_Wrap(rf(:,0,{15:25},{76:86}), 1., 1., 0)
  indices = ind(ar_avg.le.-10.0 .or. ar_avg.ge.10.0)

  t2_indices_qu = get_matched_time_indices(time, time2, indices)
  t2_vals = time2(t2_indices_qu)

  outvar = olr(t2_indices_qu,:,:)
  o->olr = outvar

  do it = 0, 100, 1
    print("rf: " + ut_calendar(time(indices(it)), -2) + " olr: " + ut_calendar(t2_vals(it), -2))
  end do
end
