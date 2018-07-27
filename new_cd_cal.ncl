load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"

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

  f1=addfile("/iitm2/cccr-res/bhupendra/MLS_DATA/converted_nc_files/2005_2016_nc/mjjas_MLS_H2Ov4_d_2005_2016.nc","r")
  f2=addfile("/iitm2/cccr-res/bhupendra/ECMWF/Daily/era_daily_pres_le/dly_u_plev_79_16.nc","r")

  t=f1->TIME
  t_tmp=calendar_decode2(t, 0)
  time = ut_inv_calendar(t_tmp(:,0), t_tmp(:,1), t_tmp(:,2), t_tmp(:,3), \
                         t_tmp(:,4), t_tmp(:,5), "days since 1900-01-01 00:00:00", 0)

  level     = f1->ZAX
  latitude  = f1->YAX
  longitude = f1->XAX
  level@units = "hPa"
  latitude@units = "degrees_north"
  longitude@units = "degrees_east"

  time2=f2->time
  time2 = time2-12
  ; print(ut_calendar(time2,0))
  ; printVarSummary(time2)

  h2o = 1000000*dble2flt(f1->H2O)

  h2o!0="time"                ; name dimensions
  h2o!1="level"
  h2o!2="latitude"
  h2o!3="longitude"

  h2o&level     =  level
  h2o&latitude  =  latitude
  h2o&longitude =  longitude

  h2o_100 = h2o(:,{100},:,:)
  delete(h2o)

  ar_avg=wgt_areaave_Wrap(h2o_100(:,{15:40},{40:160}), 1., 1., 0)

  begTime = get_cpu_time()
  indices = ind(ar_avg.le.4.2 .and. ar_avg.ge.4.0)
  print("Plot generation time: " + (get_cpu_time() - begTime))

  ; print(indices)
  ; print(time(indices))
  ; print(ut_calendar(time(indices), -2))

  begTime = get_cpu_time()
  t2_indices_qu = get_matched_time_indices(time, time2, indices)
  print("Plot generation time: " + (get_cpu_time() - begTime))

  do it = 0, 100, 1
    print("h2o: " + ut_calendar(time(indices(it)), -2) + " u: " + ut_calendar(time2(t2_indices_qu(it)), -2))
  end do
end
