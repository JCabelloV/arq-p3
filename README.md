# Arquitectura de Computadores: Proyecto 2

Este repositorio contiene el flujo completo del core de 8 bits utilizado en el curso: simulación en Verilog, síntesis con Yosys, generación de GDS con OpenLane y despliegue en la FPGA Go Board utilizando APIO.

## Estructura principal

| Archivo | Descripción |
| --- | --- |
| `computer.v` | Integración del PC, memoria de instrucciones/datos, ALU y control. Exporte los registros `A` y `B` para uso en la FPGA. |
| `fpga_top.v` | Top para la Go Board. Divide el reloj, multiplexa el display de 7 segmentos, mapea botones a LEDs y muestra el conteo decimal. |
| `im.dat` | Programa binario que realiza la cuenta regresiva de 15 a 0 sobre el registro `B`. |
| `mem.dat` | Imagen inicial de la memoria de datos (se rellena con ceros si está vacía). |
| `goboard.pcf` | Archivo de constraints para la FPGA con el mapeo de LEDs, botones y display. |
| `yosys.tcl` | Script de síntesis lógica. |
| `Makefile` | Automatiza construcción, simulación y síntesis local. |

## Flujo RTL: simulación y síntesis

```bash
make build   # Compila el banco de pruebas con Icarus Verilog
make run     # Ejecuta la simulación (usa testbench.v)
make synth   # Ejecuta la síntesis lógica con Yosys
make clean   # Limpia artefactos en out/
```

El banco de pruebas carga `im_memory.dat` para las pruebas unitarias, mientras que `im.dat` contiene el programa final para la FPGA.

## Generación de GDS con OpenLane

1. Descarga la máquina virtual del curso [Zero to ASIC](https://zerotoasiccourse.com) o prepara un entorno local con OpenLane 2022.2 o superior.
2. Copia este repositorio dentro de la VM (por ejemplo en `~/projects/arq-p3`).
3. Desde la VM, ubícate en `openlane/` y crea un nuevo diseño:
   ```bash
   ./flow.tcl -design ~/projects/arq-p3 -overwrite
   ```
4. El flujo generará artefactos en `~/projects/arq-p3/runs/`. Los archivos relevantes son:
   - `runs/<tag>/results/final/gds/<design>.gds`
   - `runs/<tag>/reports/placement/placement_density.rpt`
   - `runs/<tag>/reports/signoff/<design>.timing.rpt`
5. Para repetir el flujo con nuevos parámetros, edita `config.tcl` dentro del run o crea un directorio `openlane/` con tus archivos de configuración personalizados.

Durante la entrega parcial se te pedirá localizar métricas (área, potencia, número de celdas, etc.). Cada reporte anterior contiene la información solicitada.

## Flujo FPGA con APIO

1. Instala APIO y la toolchain IceStorm según la [documentación de Nandland](https://nandland.com/goboard/). En Linux/macOS basta con:
   ```bash
   pip install apio
   apio install system scons icestorm iverilog
   ```
2. Inicializa el proyecto una vez:
   ```bash
   apio init --board goboard
   ```
3. Construye el bitstream:
   ```bash
   apio build
   ```
4. Carga el diseño en la FPGA (Go Board conectada por USB):
   ```bash
   apio upload
   ```

### Demostraciones requeridas

- **Entrega parcial:** `fpga_top` detecta los botones (`btn[3:0]`) y, mientras alguno esté presionado, refleja directamente el patrón en los LEDs. Puedes comprobarlo con `apio upload` mostrando que cada botón enciende su LED correspondiente.
- **Entrega final:** sin presionar botones, el registro `B` del core realiza una cuenta regresiva automática desde 15 hasta 0 (ver `im.dat`). El valor se muestra:
  - En binario en los LEDs.
  - En decimal en el display de 7 segmentos (tens/ones). Los números de dos dígitos utilizan ambos dígitos; el dígito de las decenas se apaga para valores menores a 10.

La asignación de pines utilizada se encuentra en `goboard.pcf` (clock, LEDs, botones y segmentos). Revísala con la hoja de datos de la Go Board y ajusta si tu versión del tablero utiliza numeraciones distintas.

## Programa cargado en `im.dat`

El archivo `im.dat` contiene palabras de 15 bits (7 bits de opcode + 8 bits de operando). El programa actual realiza el siguiente ciclo:

1. `MOV B, 15`
2. `CMP B, 0`
3. `JZ 5`
4. `SUB B, 1`
5. `JMP 1`
6. `JMP 5` *(bucle de espera en cero)*

Con el divisor de reloj configurado en `fpga_top`, cada instrucción dura aproximadamente 0,5 s, por lo que cada valor del conteo se mantiene visible cerca de un segundo completo. Al llegar a cero el programa permanece detenido en ese valor. Puedes modificar la constante `CPU_DIVIDER` para acelerar o desacelerar la presentación en la FPGA.

## Consideraciones adicionales

- Tanto la memoria de instrucciones como la de datos cuentan con 256 posiciones (`0-255`). `mem.dat` puede pre-cargar valores para interactuar con periféricos mapeados en memoria.
- Si necesitas depurar en la FPGA, puedes exponer señales adicionales del módulo `computer` y mapearlas en `goboard.pcf`.
- El flujo de OpenLane genera un diseño sin pads. Para la fabricación real deberás integrar un padrón o recurrir a Caravel, según lo indicado en el curso.
