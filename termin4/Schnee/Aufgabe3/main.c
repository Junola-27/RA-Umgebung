// Programmrahmen zur Kontrolle der Loesung von Aufgabe 3 vom Termin4 "wandel.S"
// von: Manfred Pester
// vom: 17.10.2024
// letzte Änderung: 13.02.2055

#include <stdio.h>

// Funktionsprototyp fuer die zu entwickelnde Assemblerroutine
unsigned int wandel(char*, char*);

// Variablen
unsigned int AdgZ = 0; // Anzahl der gewandelten Zeichen

// String ohne Umlaute nur Zeichen aus dem 7-bit ASCII-Zeichensatz
char ascii_string[] = "AeOeUeszaeoeue\n";

// String mit Umlauten nach UTF-8 Zeichensatz
char utf8_string[sizeof(ascii_string)];

int main()
{
    printf("String ohne Umlaute vor der Wandlung\n");
    printf(ascii_string);
    AdgZ = wandel(ascii_string,utf8_string);                                                                                                                                                           
    printf("String mit Umlauten nach UTF-8 nach der Wandlung\n");                                                                                                                                      
    printf("%s", utf8_string);
    printf("\n");
    printf("Anzahlt: ");
    printf("%u", AdgZ);
    printf("\n");

    return 0;
}                  
