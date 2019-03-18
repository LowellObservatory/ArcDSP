proc fredstep {} {
	setdac dac=3 value=2650
	inst_focus pos=1360
	go etime=0.5
	for {set x 0} {$x < 5 } {incr x} {
		set nex [expr $x*100+1360]
		inst_focus pos=$nex
		go etime=0.5
#	phot
        }
}
proc setmx {m1 m2} {

        setmux clock=2 mux1=$m1 mux2=$m2
}

proc pci_xread {addr} {

	dsprdm board=pci addr=$addr type=X
}

proc pci_yread {addr} {
	dsprdm board=pci addr=$addr type=Y
}
proc tim_xread {addr} {
	dsprdm board=tim addr=$addr type=X
}
proc tim_yread {addr} {
	dsprdm board=tim addr=$addr type=Y
}
proc tim_xwrite {addr data} {
	dspwrm board=tim addr=$addr type=X data=$data
}
proc tim_ywrite {addr data} {
	dspwrm board=tim addr=$addr type=Y data=$data
}
proc util_xread {addr} {
	dsprdm board=util addr=$addr type=X
}
proc util_yread {addr} {
	dsprdm board=util addr=$addr type=Y
}
proc test_dump {} {
	dsprdm board=tim addr=1 type=Y
	dsprdm board=tim addr=2 type=Y
	dsprdm board=tim addr=5 type=Y
	dsprdm board=tim addr=6 type=Y
	dsprdm board=tim addr=16 type=Y
	dsprdm board=tim addr=22 type=Y
	dsprdm board=tim addr=23 type=Y
	dsprdm board=tim addr=24 type=Y
	dsprdm board=tim addr=25 type=Y
	dsprdm board=tim addr=26 type=Y
	dsprdm board=tim addr=27 type=Y
	dsprdm board=tim addr=28 type=Y
	dsprdm board=tim addr=29 type=Y
	dsprdm board=tim addr=30 type=Y
	dsprdm board=tim addr=31 type=Y
	dsprdm board=tim addr=32 type=Y
	dsprdm board=tim addr=33 type=Y
	dsprdm board=tim addr=34 type=Y
	dsprdm board=tim addr=35 type=Y
	dsprdm board=tim addr=36 type=Y
	dsprdm board=tim addr=37 type=Y
	dsprdm board=tim addr=56 type=Y
	dsprdm board=tim addr=57 type=Y
	dsprdm board=tim addr=58 type=Y
	dsprdm board=tim addr=59 type=Y
	dsprdm board=tim addr=60 type=Y
	dsprdm board=tim addr=61 type=Y
	dsprdm board=tim addr=62 type=Y
	dsprdm board=tim addr=63 type=Y
	dsprdm board=tim addr=0 type=X
	dsprdm board=tim addr=48 type=X
	dsprdm board=tim addr=49 type=X
	dsprdm board=tim addr=52 type=X
	dsprdm board=tim addr=53 type=X
	dsprdm board=tim addr=54 type=X
	dsprdm board=tim addr=55 type=X
}

proc loadreads {} {
	load pcitimeng.so
#	cbutton proc=pci_xread
#	cbutton proc=pci_yread
	cbutton proc=tim_xread
	cbutton proc=tim_yread
#	cbutton proc=util_xread
#	cbutton proc=util_yread
	cbutton proc=tim_xwrite
	cbutton proc=tim_ywrite
	cbutton proc=setmx
	cbutton proc=test_dump
}

proc dimread {} {
	yread 0x01
	yread 0x02
	xread 0x30
	xread 0x31
}
proc redstart {} {

	load fits.so
	load analysis.so
	load lois_misc.so
	analysis state=on
	store_config
#	load hipored.so
#	cam_getconf
#	cam_open
#	cam_init

}

proc subload1 {} {


# force single amplifier before loading to avoid errors if LR in use
amp_set L
subframe sub=1 xpix=240 ypix=70 xsize=80 ysize=80
subframe sub=2 xpix=196 ypix=664 xsize=80 ysize=80
subframe sub=3 xpix=1010 ypix=988 xsize=80 ysize=80
subframe sub=4 xpix=816 ypix=70 xsize=80 ysize=80
subframe sub=5 xpix=876 ypix=664 xsize=80 ysize=80
subframe sub=6 xpix=55 ypix=988 xsize=80 ysize=80
subframe sub=7 xpix=250 ypix=69 xsize=80 ysize=43


}

proc subload2 {} {


# force single amplifier before loading to avoid errors if LR in use
amp_set L
subframe sub=1 xpix=120 ypix=35 xsize=40 ysize=40
subframe sub=2 xpix=98 ypix=332 xsize=40 ysize=40
subframe sub=3 xpix=505 ypix=494 xsize=40 ysize=40
subframe sub=4 xpix=408 ypix=35 xsize=40 ysize=40
subframe sub=5 xpix=438 ypix=332 xsize=40 ysize=40
subframe sub=6 xpix=27 ypix=494 xsize=40 ysize=40


}

proc subload3 {} {


# force single amplifier before loading to avoid errors if LR in use
amp_set L
subframe sub=1 xpix=80 ypix=23 xsize=30 ysize=30
subframe sub=2 xpix=65 ypix=221 xsize=30 ysize=30
subframe sub=3 xpix=336 ypix=329 xsize=30 ysize=30
subframe sub=4 xpix=272 ypix=23 xsize=30 ysize=30
subframe sub=5 xpix=292 ypix=221 xsize=30 ysize=30
subframe sub=6 xpix=18 ypix=329 xsize=30 ysize=30
subframe sub=7 xpix=60 ypix=42 xsize=80 ysize=80
subframe sub=8 xpix=150 ypix=150 xsize=80 ysize=80
subframe sub=9 xpix=313 ypix=302 xsize=80 ysize=80


}

proc fullfrm {} {
subframe sub=0
}

proc dactest {} {

   set dval 2048
   for {set x 2048} {$x < 4095} {set x [expr $x+20]} {
       setdac dac=2 value=$x
       after 500
       test frame=object etime=1.0
       phot xc=594 yc=497 output=ledlin.dat
   }

}

proc exptest {} {

	for {set x 0} {$x < 2} {incr x} {
		go -wait nexp=1 etime=15  frame=object
	}
}
proc singlego { etime_200ms nexp_1 frame_obj trig_hard sub_0 cbin_1 rbin_1 amp_L oscan_0 } {

        if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
        if { $etime_200ms == 0 } { set etime .2 } else { set etime $etime_200ms }
        if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
        set trigger      none
        if { $trig_hard == 0 } { set trigger hard }
        if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
        if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
        if { $amp_L == 0 } { set amp L } else { set amp $amp_L }
       
	single start etime=$etime nexp=$nexp frame=$frame trigger=$trigger sub=$sub_0 cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0
}
proc findgo {{etime_200ms } { nexp_1} {frame_obj}  {sub_0} {cbin_1} {rbin_1} {amp_L} {oscan_0} } {

        if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
        if { $etime_200ms == 0 } { set etime .2 } else { set etime $etime_200ms }
        if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
        if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
        if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
        if { $amp_L == 0 } { set amp L } else { set amp $amp_L }

	find start etime=$etime nexp=$nexp frame=$frame  sub=$sub_0 cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0 -nowait
}

proc stopfind { save_no } {
   if { $save_no == 0 }  { cam_stop } else { cam_stop save }
}

proc amp_set {ampval} {

	set_amplifier amp=$ampval

}
proc defsub { {sub_1} {xpix} {ypix} {xsize_y} {ysize_x} } {
        if { $sub_1 == 0 } { set sub 1 } else { set sub $sub_1 }
       if { $xsize_y == 0 } {set xsize $ysize_x } else { set xsize $xsize_y}
       if { $ysize_x == 0 } {set ysize $xsize_y } else { set ysize $ysize_x}
       subframe sub=$sub xpix=$xpix ypix=$ypix xsize=$xsize ysize=$ysize config
}

proc stripgo { ietime_10ms rows_1600 nexp_1 frame_obj trig_hard sub_0 cbin_1 rbin_1 amp_L oscan_0 } {
        if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
        if { $ietime_10ms == 0 } { set ietime .01 } else { set ietime $ietime_10ms }
        if { $rows_1600 == 0 } { set rows 1600 } else { set rows $rows_1600 }
        if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
        set trigger      none
        if { $trig_hard == 0 } { set trigger hard }
        if { $sub_0 == 0 } { set sub 0 } else { set sub $sub_0 }
        if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
        if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
        if { $amp_L == 0 } { set amp L } else { set amp $amp_L }
       
        strips start etime=$ietime itime=$ietime iframes=$rows frame=object nexp=$nexp  trigger=$trigger sub=$sub setamp=$amp cbin=$cbin rbin=$rbin oscan=$oscan_0
}

proc fdotsgo { ietime_100ms srows_206 nexp_1 frame_obj trig_hard sub_0 cbin_1 rbin_1 amp_L oscan_0 } {
   if { $srows_206 == 0 } { set srows 206 } else { set srows $srows_206 }
   if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
   if { $ietime_100ms == 0 } { set ietime .1 } else { set ietime $ietime_100ms }
   if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
   set trigger      none
   if { $trig_hard == 0 } { set trigger hard }
   if { $sub_0 == 0 } { set sub 0 } else { set sub $sub_0 }
   if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
   if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
   if { $amp_L == 0 } { set amp L } else { set amp $amp_L }
       
   fdots start srows=$srows etime=$ietime itime=$ietime  nexp=$nexp frame=$frame  trigger=$trigger sub=$sub setamp=$amp cbin=$cbin rbin=$rbin oscan=$oscan_0
}
proc sdotsgo { ietime_100ms srows_206 dots_30 nexp_1 frame_obj trig_hard sub_0 cbin_1 rbin_1 amp_L oscan_0 } {
   if { $srows_206 == 0 } { set srows 206 } else { set srows $srows_206 }
   if { $dots_30 == 0 } { set dots 30 } else { set dots $dots_30 }
   if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
   if { $ietime_100ms == 0 } { set ietime .1 } else { set ietime $ietime_100ms }
   if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
   set trigger      none
   if { $trig_hard == 0 } { set trigger hard }
   if { $sub_0 == 0 } { set sub 0 } else { set sub $sub_0 }
   if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
   if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
   if { $amp_L == 0 } { set amp L } else { set amp $amp_L }
       
   sdots start srows=$srows iframes=$dots etime=$ietime itime=$ietime  nexp=$nexp frame=$frame  trigger=$trigger sub=$sub setamp=$amp cbin=$cbin rbin=$rbin oscan=$oscan_0
}

proc occgo { ietime_100ms  ifrms_30 nexp_1 frame_obj trig_hard sub_0 cbin_1 rbin_1 amp_L oscan_0 submode_basic } {
   if { $ifrms_30 == 0  } { set ifrms 30 } else { set ifrms $ifrms_30 }
   if { $nexp_1 == 0 } { set nexp 1 } else { set nexp $nexp_1 }
   if { $ietime_100ms == 0 } { set ietime .1 } else { set ietime $ietime_100ms }
   if { $frame_obj == 0 } { set frame object } else { set frame $frame_obj }
   set trigger      none
   if { $trig_hard == 0 } { set trigger hard }
   if { $sub_0 == 0 } { set sub 0 } else { set sub $sub_0 }
   if { $cbin_1 == 0 } { set cbin 1 } else { set cbin $cbin_1 }
   if { $rbin_1 == 0 } { set rbin 1 } else { set rbin $rbin_1 }
   if { $amp_L == 0 } { set amp L } else { set amp $amp_L }

   if { $submode_basic == 0 } { set submode basic } else {
      set submode $submode_basic
   }

   if { $submode == "pipeline" } {
    occul start iframes=$ifrms frame=object sub=$sub etime=$ietime  itime=$ietime nexp=$nexp dlog=on -pipeline trigger=$trigger cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0
      } else {
        if { $submode == "basic" } {
        occul start iframes=$ifrms frame=object sub=$sub  etime=$ietime itime=$ietime nexp=$nexp dlog=on  trigger=$trigger cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0
           } else {
              if { $submode == "fast" } {
                 occul start iframes=$ifrms frame=object sub=$sub etime=$ietime itime=$ietime nexp=$nexp dlog=on -fast trigger=$trigger cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0

              } else {
                 occul start iframes=$ifrms frame=object sub=$sub etime=$ietime itime=$ietime nexp=$nexp dlog=on trigger=$trigger cbin=$cbin rbin=$rbin setamp=$amp oscan=$oscan_0
              }
         }
      }
}

set itime .100

cbutton proc=singlego
cbutton proc=findgo
cbutton proc=stopfind
cbutton proc=defsub
cbutton proc=fullfrm
cbutton proc=fdotsgo
cbutton proc=sdotsgo
cbutton proc=stripgo
cbutton proc=occgo
#cbutton proc=trig_occgo
cbutton proc=amp_set

loadreads
