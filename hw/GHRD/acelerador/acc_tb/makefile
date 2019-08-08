
# requer icarus e gtkwave

CORE=../custom_acc_top.v
BENCH=core_tb.v

EXE=core-exe-sim.vvp
WAVE=core-wave-sim.vcd

all:	$(CORE) $(BENCH)
		iverilog -o $(EXE) $^
		vvp $(EXE)

wave:	$(EXE)
		gtkwave $(WAVE) &

.PHONY:	clean

clean:
		rm -rf *.vvp *.vcd
