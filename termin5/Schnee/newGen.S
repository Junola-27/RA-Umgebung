@ Team: JN
@ Datum: 2026-01-12

    .file   "newGen.S"
    .text           
    .align  2       

    .global neighbors   
    .type   neighbors,function
@-----------------------------------------------------------------------
@ Tâche 2 : neighbors(f, r, c)
@ R0=f, R1=r, R2=c -> Retourne résultat dans R0
@ Utilise l'exécution conditionnelle pour éviter les branchements.
@-----------------------------------------------------------------------
neighbors:
    push    {r4-r7}         @ Sauvegarde des registres (AAPCS)
    mov     r3, #0              @ R3 = compteur de voisins

    @ On vérifie les 8 voisins. Pour chaque voisin :
    @ 1. On compare les bords (r, c)
    @ 2. Si OK (NE), on calcule l'index et on ajoute la valeur f[index]

    @ --- Voisin 1: Haut-Gauche (r-1, c-1) ---
    cmp     r1, #0              @ r != 0 ?
    cmpne   r2, #0              @ AND c != 0 ?
    subne   r4, r1, #1          @ r_temp = r-1
    subne   r5, r2, #1          @ c_temp = c-1
    addne   r6, r5, r4, lsl #5  @ index = c + (r << 5)
    addne   r6, r6, r4, lsl #3  @ index = index + (r << 3) = r*40 + c
    ldrneb  r7, [r0, r6]        @ Charger f[index]
    addne   r3, r3, r7          @ Somme

    @ --- Voisin 2: Haut (r-1, c) ---
    cmp     r1, #0
    subne   r4, r1, #1
    addne   r6, r2, r4, lsl #5
    addne   r6, r6, r4, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 3: Haut-Droite (r-1, c+1) ---
    cmp     r1, #0
    cmpne   r2, #39             @ c != 39 ?
    subne   r4, r1, #1
    addne   r5, r2, #1
    addne   r6, r5, r4, lsl #5
    addne   r6, r6, r4, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 4: Gauche (r, c-1) ---
    cmp     r2, #0
    subne   r5, r2, #1
    addne   r6, r5, r1, lsl #5
    addne   r6, r6, r1, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 5: Droite (r, c+1) ---
    cmp     r2, #39
    addne   r5, r2, #1
    addne   r6, r5, r1, lsl #5
    addne   r6, r6, r1, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 6: Bas-Gauche (r+1, c-1) ---
    cmp     r1, #24             @ r != 24 ?
    cmpne   r2, #0
    addne   r4, r1, #1
    subne   r5, r2, #1
    addne   r6, r5, r4, lsl #5
    addne   r6, r6, r4, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 7: Bas (r+1, c) ---
    cmp     r1, #24
    addne   r4, r1, #1
    addne   r6, r2, r4, lsl #5
    addne   r6, r6, r4, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    @ --- Voisin 8: Bas-Droite (r+1, c+1) ---
    cmp     r1, #24
    cmpne   r2, #39
    addne   r4, r1, #1
    addne   r5, r2, #1
    addne   r6, r5, r4, lsl #5
    addne   r6, r6, r4, lsl #3
    ldrneb  r7, [r0, r6]
    addne   r3, r3, r7

    mov     r0, r3              @ Résultat dans R0
    pop     {r4-r7}
	bx 		lr

.neighbors_end:
    .size   neighbors,.neighbors_end-neighbors

@-----------------------------------------------------------------------
@ Tâche 3 & 4 : newGen(f, n)
@ R0=f, R1=n
@-----------------------------------------------------------------------
    .global newGen      
    .type   newGen,function
newGen:
    push    {r4-r8, lr}         @ Sauvegarde AAPCS (LR obligatoire car non-feuille)
    mov     r4, r0              @ Sauver adresse f
    mov     r5, r1              @ Sauver adresse n

    @ PHASE 1: Calculer les voisins pour chaque cellule
    mov     r6, #0              @ r6 = row loop
.loop_r1:
    mov     r7, #0              @ r7 = col loop
.loop_c1:
    mov     r0, r4              @ Argument 1: f
    mov     r1, r6              @ Argument 2: r
    mov     r2, r7              @ Argument 3: c
    
    @ Tâche 4: On appelle la fonction C "neighborsC" au lieu de "neighbors" 
    bl      neighbors          
    
    @ Calcul d'index pour stocker dans n[index]
    add     r8, r7, r6, lsl #5
    add     r8, r8, r6, lsl #3
    strb    r0, [r5, r8]        @ n[index] = nb_voisins

    add     r7, r7, #1
    cmp     r7, #40
    blt     .loop_c1
    add     r6, r6, #1
    cmp     r6, #25
    blt     .loop_r1

    @ PHASE 2: Appliquer les règles de Conway
    mov     r6, #0
.loop_r2:
    mov     r7, #0
.loop_c2:
    add     r8, r7, r6, lsl #5
    add     r8, r8, r6, lsl #3
    ldrb    r0, [r5, r8]        @ r0 = n[index] (nb voisins)
    
    @ Règles: 3=Vivant, 2=Inchangé, Autres=Mort
    cmp     r0, #3
    moveq   r1, #1
    streqb  r1, [r4, r8]        @ f[index] = 1 si 3 voisins
    
    cmp     r0, #3              @ On re-teste pour la règle du "Sinon"
    cmpne   r0, #2              @ Si != 3 ET != 2
    movne   r1, #0
    strneb  r1, [r4, r8]        @ f[index] = 0 (Mort par solitude ou surpopulation)

    add     r7, r7, #1
    cmp     r7, #40
    blt     .loop_c2
    add     r6, r6, #1
    cmp     r6, #25
    blt     .loop_r2

    pop     {r4-r8, pc}

.newGen_end:
    .size   newGen,.newGen_end-newGen
.end