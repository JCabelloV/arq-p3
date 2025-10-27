# Archivos del proyecto
VERILOG_FILES = \
    computer.v \
    alu.v \
    pc.v \
    register.v \
    instruction_memory.v \
    data_memory.v \
    control_unit.v \
    muxA.v \
	muxB.v \
	muxData.v \
	muxWB.v \
	status.v

TESTBENCH_FILE = testbench.v
YOSYS_SCRIPT = yosys.tcl

# Rutas de salida
OUT_DIR = out
OUT_FILE = computer
WAVEFORM_FILE = $(OUT_DIR)/dump.vcd

# Target por defecto
all: build run

# Target para crear el directorio de salida
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Target para construir el ejecutable de simulación
build: $(OUT_DIR)
	@echo "Construyendo ejecutable de simulación..."
	iverilog -o $(OUT_DIR)/$(OUT_FILE) $(VERILOG_FILES) $(TESTBENCH_FILE)
	@echo "Construcción exitosa. Ejecutable creado en $(OUT_DIR)/$(OUT_FILE)"

# Target para ejecutar la simulación
run:
	@echo "Ejecutando simulación..."
	vvp $(OUT_DIR)/$(OUT_FILE)

# Target para ver las formas de onda
wave:
	@echo "Abriendo formas de onda con GTKWave..."
	gtkwave $(WAVEFORM_FILE)

# Target para síntesis
synth: $(OUT_DIR)
	@echo "Iniciando síntesis lógica con Yosys..."
	yosys -c $(YOSYS_SCRIPT)
	@echo "Síntesis completa."

# Target para limpiar los archivos generados
clean:
	@echo "Limpiando archivos generados..."
	@rm -rf $(OUT_DIR)
	@rm -f yosys.log
	@echo "Limpieza completa."

.PHONY: all build run wave synth clean
