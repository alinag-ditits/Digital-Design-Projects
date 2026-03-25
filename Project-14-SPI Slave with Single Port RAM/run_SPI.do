vlib work
vlog RAM.v SPI.v Testbench.v SPI_Wrapper.v
vsim -voptargs=+acc work.Testbench
add wave *
run -all
#quit -sim