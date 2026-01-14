#!/bin/bash

# --- Willkommensnachricht ---
echo ""
echo "====================================================="
echo "  Willkommen in der RA-Docker Umgebung (2025) 🎉"
echo "====================================================="
echo "  Nutzen Sie 'ra_run <Name>' zum Debuggen."
echo "        z. B. ra_run wandel"             
echo "  Nutzen Sie 'ra_h' für die Hilfeübersicht."
echo "-----------------------------------------------------"
echo "  Tipp: Drücken Sie die [ENTER]-Taste, um den"
echo "  letzten Befehl (z.B. 'si', 'n') zu wiederholen"
echo "-----------------------------------------------------"
echo "  Viel Spaß beim Coding und Debugging 🥳"
echo "====================================================="
echo ""

# --- Hauptfunktion: Kompilieren und Debuggen ---
ra_run() {
    local TARGET=$1
    local OPTION=$2
    
    if [ -z "$TARGET" ]; then
        echo "Fehler: Kein Dateiname angegeben!"
        echo "Nutzung: ra_run <name> [-nv]"
        return 1
    fi

    if [ -f "main.c" ]; then
        arm-linux-gnueabi-gcc -static -g *.c *.S -o "${TARGET}.elf"
    else
        arm-linux-gnueabi-gcc -static -g "${TARGET}.S" -o "${TARGET}.elf"
    fi

    if [ "$OPTION" = "-nv" ]; then
        echo "Starte Ausführung ohne Debugger..."
        qemu-arm "./${TARGET}.elf"
    else
        cat << GDB > /tmp/debug.gdb
set architecture arm
target remote :1234
dashboard registers -style list "r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 sp lr pc cpsr"
define hook-stop
    set \$N = (\$cpsr >> 31) & 1
    set \$Z = (\$cpsr >> 30) & 1
    set \$C = (\$cpsr >> 29) & 1
    set \$V = (\$cpsr >> 28) & 1
end
dashboard expressions watch \$N
dashboard expressions watch \$Z
dashboard expressions watch \$C
dashboard expressions watch \$V
break $TARGET
continue
GDB
        
        echo "Starte GDB-Sitzung für: $TARGET"
        qemu-arm -g 1234 "./${TARGET}.elf" &
        gdb-multiarch -q -x /tmp/debug.gdb "./${TARGET}.elf"
        pkill qemu-arm
    fi
}

# --- Hilfefunktion ---
ra_h() {
    echo ""
    echo "================================================================"
    echo "       RA-DOCKER HILFE & BEFEHLSÜBERSICHT"
    echo "================================================================"
    echo "  ra_run <name>      -> Kompilieren & Debuggen (GDB)"
    echo "  ra_run <name> -nv  -> Nur Ausführen (Schnell-Modus)"
    echo "  ra_h               -> Diese Hilfe anzeigen"
    echo "----------------------------------------------------------------"
    echo "  Befehle in GDB:"
    echo "  si (stepi)         -> Assembler-Schritt (in .S Datei)"
    echo "  ni (nexti)         -> Assembler-Befehl (keine Unterfunktionen)"
    echo "  n  (next)          -> Ganze C-Zeile ausführen (z. B. printf)"
    echo "  [ENTER]            -> Letzten Befehl wiederholen"
    echo "  c  (continue)      -> Bis zum nächsten Breakpoint laufen"
    echo "  finish             -> Aktuelle Funktion beenden (z. B. puts)"
    echo "  q  (quit)          -> Debugger beenden"
    echo "================================================================"
    echo ""
}

export -f ra_run
export -f ra_h