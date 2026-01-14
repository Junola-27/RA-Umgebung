# Linux-ARM (Dockerfile)
CC = arm-linux-gnueabi-gcc

# Flags de compilation : 
# -g : debug info
# -O0 : pas d'optimisation (plus facile à débugger)
# -static : IMPORTANT pour que qemu puisse exécuter sans bibliothèques externes
CFLAGS = -O0 -g -static
ASFLAGS = -g

# Pas besoin de LDFLAGS complexes pour Linux/Qemu
LDFLAGS = -static

OBJS = main.o wandel.o
NAME = wandel

# Règle principale
all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(NAME)

# Compilation des fichiers .s (minuscule)
%.o: %.s
	$(CC) $(ASFLAGS) -c $< -o $@

# Compilation des fichiers .S (majuscule - assembleur avec préprocesseur)
%.o: %.S
	$(CC) $(ASFLAGS) -c $< -o $@

# Compilation du C
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(NAME)

# Règle pour tester directement (optionnel)
run: $(NAME)
	qemu-arm ./$(NAME)