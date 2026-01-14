CC = arm-eb63-elf-gcc
CFLAGS = -O1 -g -c
LDFAGS = ""
ASFLAGS = -g -c
OBJS = main.o newGen.o
NAME = gameoflife

$(NAME).elf: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(NAME).elf
	
%.o: %.s
	$(CC) $(ASFLAGS) $< -o $@
	
%.o: %.S
	$(CC) $(ASFLAGS) $< -o $@
	
%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	
clean:
	rm -f $(OBJS) $(NAME).elf
