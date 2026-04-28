# ATM-Verilog

## Project Overview

This repository contains a Verilog implementation of a simple ATM controller state machine, developed for a Digital Circuits II course. The project includes the main controller module, a testbench, and a tester module for simulation-based verification.

## Files

- `ATM_controller.v`: Main ATM controller implementing states for card waiting, PIN verification, deposit, withdrawal, and lockout.
- `testbench.v`: Top-level simulation module instantiating the ATM controller and tester.
- `tester.v`: Test stimulus module that drives inputs and validates the controller behavior.
- `resultados_ATM_ordenados.gtkw`: GTKWave waveform file for reviewing simulation results.

## ATM Controller Behavior

The controller implements a finite state machine with the following behavior:

- Waits for card insertion (`tarjeta_recibida`)
- Reads and verifies a 4-digit PIN (`4756`)
- Supports deposit and withdrawal transactions
- Updates the account balance
- Detects insufficient funds for withdrawals
- Issues warnings for repeated wrong PIN attempts
- Locks the ATM after too many incorrect PIN tries

Main output signals:

- `balance_actualizado`: balance update completed
- `entregar_dinero`: money should be dispensed
- `pin_incorrecto`: wrong PIN entered
- `advertencia`: warning for repeated PIN errors
- `bloqueo`: ATM locked after failed attempts
- `fondos_insuficientes`: insufficient funds for withdrawal

## Simulation Instructions

Use a Verilog simulator such as Icarus Verilog and GTKWave to run and inspect the design.

Example commands:

```bash
iverilog -o atm_testbench ATM_controller.v tester.v testbench.v
vvp atm_testbench
gtkwave resultados_ATM.vcd resultados_ATM_ordenados.gtkw
```

## Notes

- Initial balance is set to `4500` in `ATM_controller.v`.
- Correct PIN is hardcoded as `4756`.
- The testbench uses a single test scenario that verifies card detection, PIN entry, and a deposit transaction.
