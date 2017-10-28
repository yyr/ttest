; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, October 27 2017

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;_____________________________________________________________________________
; Function: dim0
; Doc:
;_____________________________________________________________________________
undef("dim0")
function dim0(dat:numeric)

begin
  dims = dimsizes(dat)
  return(dims(0))
end

begin
  f1=addfile("olr_out.nc","r")
  f2=addfile("/iitm2/cccr-res/bhupendra/test_analysis/d_olr_jun_74_dec_13.nc","r")

  olr_in = short2flt(f1->olr)
  olr_ori=short2flt(f2->olr)

  nofsamples = 10000
  rans = floattoint(random_uniform(0,dim0(olr_ori),nofsamples))
  olr = olr_ori(rans,:,:)

  xAve = dim_avg_n_Wrap(olr_in, 0)              ; calculate means at each grid point
  yAve = dim_avg_n_Wrap(olr, 0)

  xAve = dim_avg_n_Wrap(olr_in, 0)              ; calculate means at each grid point
  yAve = dim_avg_n_Wrap(olr, 0)
  xVar = dim_variance_n_Wrap(olr_in, 0)         ; calculate variances
  yVar = dim_variance_n_Wrap(olr, 0)

  sigr = 0.05                        ; critical sig lvl for r
  xEqv = equiv_sample_size (olr_in, sigr,0)
  yEqv = equiv_sample_size (olr, sigr,0)

  xN =   wgt_areaave (xEqv, 1., 1., 0)    ; wgty could be gaussian weights
  yN   = wgt_areaave (yEqv, 1., 1., 0)

  iflag= True                        ; population variance similar
  prob = ttest(xAve,xVar,dim0(olr_in), yAve,yVar,dim0(olr), iflag, False)

  probt = 100.*(1. - prob)
  xAve = where(probt.lt.95.,xAve@_FillValue, xAve)

  res = True
  res@cnFillOn = True
  res@gsnSpreadColors=True
  res@mpDataBaseVersion           = "Ncarg4_1"
  res@cnLinesOn = False
  res@cnLineLabelsOn = False

  wks = gsn_open_wks("pdf", "ttest")
  gsn_define_colormap(wks,"MPL_RdPu") ;

  printMinMax(xAve, True)
  plot = gsn_csm_contour_map(wks,xAve,res)
end
