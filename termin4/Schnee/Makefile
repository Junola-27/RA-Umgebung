build:
	arm-eb63-elf-gcc -g aufgabe1.S -o aufgabe1.elf
	arm-eb63-elf-gcc -g aufgabe2.S -o aufgabe2.elf

aufgabe1: aufgabe1.S
	arm-eb63-elf-gcc -g aufgabe1.S -o aufgabe1.elf

aufgabe2: aufgabe2.S
	arm-eb63-elf-gcc -g aufgabe2.S -o aufgabe2.elf

debug:
	arm-eb63-elf-insight
clean:
	rm *.elf
	
