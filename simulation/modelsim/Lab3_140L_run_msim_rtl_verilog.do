transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/regrce.v}
vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/Lab3_140L.v}
vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/dispString.v}
vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/decodeKeys.v}
vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/countrce.v}
vlog -vlog01compat -work work +incdir+D:/PhotonUser/Lab/junkai/cse140l/Lab3 {D:/PhotonUser/Lab/junkai/cse140l/Lab3/bcd2segment.v}

