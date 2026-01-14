@ Programmgeruest zur Aufgabe 3 vom Termin4 RASS2025
@ Name:	Manfred Pester
@ Datum:	17.10.2024
@ letzte Änderung: 13.02.2025

    .file   "wandel.S"
    .text       	
    .align  2       
	.global wandel	
	.type	wandel, function
	
@ Entrée : r0 (Source String), r1 (Dest String)
@ Sortie : r0 (Nombre de caractères écrits)

wandel:
    mov r3, #0          @ Initialiser le compteur de caractères écrits à 0

loop:
    ldrb r2, [r0]       @ 1. LIRE : Charger un octet de la Source
    cmp r2, #0          @ 2. VÉRIFIER : Est-ce la fin (0) ?
    beq end_of_func     @ 3. SORTIR : Si oui, on va à la fin

    @ --- Test 'Ae' ---
    cmp r2, #'A'        
    bne check_Oe        

    @ Test 'e'
    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'Ä' UTF-8 (C3 84)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0x84    
    strb r2, [r1], #1

    add r0, r0, #2      @ Sauter 'A' et 'e'
    add r3, r3, #1      @ +1 compteur de résultats
    b loop

check_Oe:
    cmp r2, #'O'        
    bne check_Ue        

    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'Ö' UTF-8 (C3 96)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0x96    
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

check_Ue:
    cmp r2, #'U'        
    bne check_sz        

    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'Ü' UTF-8 (C3 9C)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0x9C  
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

check_sz:
    cmp r2, #'s'        
    bne check_ae        

    ldrb r12, [r0, #1]  
    cmp r12, #'z'      
    bne default_copy    

    @ 'ß' UTF-8 (C3 9F)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0x9F
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

check_ae:
    cmp r2, #'a'        
    bne check_oe        

    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'ä' UTF-8 (C3 84)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0xA4    
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

check_oe:
    cmp r2, #'o'        
    bne check_ue        

    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'ö' UTF-8 (C3 B6)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0xB6    
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

check_ue:
    cmp r2, #'u'        
    bne default_copy    @ Dernier check, si échec -> default

    ldrb r12, [r0, #1]  
    cmp r12, #'e'      
    bne default_copy    

    @ 'ü' UTF-8 (C3 BC)
    mov r2, #0xC3   
    strb r2, [r1], #1
    mov r2, #0xBC  
    strb r2, [r1], #1

    add r0, r0, #2
    add r3, r3, #1
    b loop

@ --- Copie par défaut ---
default_copy:
    strb r2, [r1], #1   @ Copier le caractère tel quel
    add r0, r0, #1      @ Avancer de 1 seulement
    add r3, r3, #1      @ Compteur + 1
    b loop

@ --- Fin de fonction ---
end_of_func:
    strb r2, [r1]       @ Écrire le 0 terminal dans la destination
    mov r0, r3          @ Mettre le résultat (compteur) dans r0
	bx	lr	
	
.wandel_end:
	.size	wandel,.wandel_end-wandel
.end	@ End of File