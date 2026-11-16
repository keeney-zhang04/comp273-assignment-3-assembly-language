# Name: Keeney Zhang
# Student ID: 261146308


.data
command: .asciiz "Commands (encrypt, decrypt, quit): "
encrypt_text: .asciiz "Enter text to encrypt (upper case letters only):"
decrypt_text: .asciiz "Enter text to decrypt (upper case letters only):"
key: .asciiz "Enter key (upper case letters only):"
encrypted_answer: .asciiz "Encrypted text: "
decrypted_answer: .asciiz "decrypted text: "
invalid: .asciiz "Invalid Input. Please try again.\n"

user_input: .space 10
key_input: .space 50
text_input: .space 500

.text
.globl main

main:
    li $v0, 4
    la $a0, command
    syscall

    li $v0, 8
    la $a0, user_input
    li $a1, 10
    syscall

    la $t2, user_input
    lb $t0, 0($t2)
    li $t1, 'e'
    beq $t0, $t1, encrypt

    li $t1, 'd'
    beq $t0, $t1, decrypt

    li $t1, 'q'
    beq $t0, $t1, quit

    li $v0, 4
    la $a0, invalid
    syscall
    j main

encrypt:
    li $v0, 4
    la $a0, encrypt_text
    syscall

    li $v0, 8
    la $a0, text_input
    li $a1, 500
    syscall

    li $v0, 4
    la $a0, key
    syscall

    li $v0, 8
    la $a0, key_input
    li $a1, 50
    syscall

    la $a0, text_input
    la $a1, key_input
    jal EncryptText

    li $v0, 4
    la $a0, encrypted_answer
    syscall
    li $v0, 4
    la $a0, text_input
    syscall

    j main

decrypt:
    li $v0, 4
    la $a0, decrypt_text
    syscall

    li $v0, 8
    la $a0, text_input
    li $a1, 500
    syscall

    li $v0, 4
    la $a0, key
    syscall

    li $v0, 8
    la $a0, key_input
    li $a1, 50
    syscall

    la $a0, text_input
    la $a1, key_input
    jal Decryptext

    li $v0, 4
    la $a0, decrypted_answer
    syscall
    li $v0, 4
    la $a0, text_input
    syscall

    j main

quit:
    li $v0, 10
    syscall

EncryptText:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)

    move $t0, $a0
    move $t1, $a1

Encrypt_Loop:
    lb $t2, 0($t0)
    beq $t2, $zero, Encrypt_Done

    li $t3, 'A'
    blt $t2, $t3, Skip_Shift
    li $t3, 'Z'
    bgt $t2, $t3, Skip_Shift

    lb $t4, 0($t1)

    li $t5, '\n'
    beq $t4, $zero, Reset_Key
    beq $t4, $t5, Reset_Key

    sub $t4, $t4, 'A'
    add $t2, $t2, $t4

    li $t3, 'Z'
    ble $t2, $t3, Store_Result
    sub $t2, $t2, 26

Store_Result:
    sb $t2, 0($t0)

    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j Encrypt_Loop

Reset_Key:
    move $t1, $a1
    j Encrypt_Loop

Skip_Shift:
    addi $t0, $t0, 1
    j Encrypt_Loop

Encrypt_Done:
    sb $zero, 0($t0)
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

Decryptext:
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)

    move $t0, $a0
    move $t1, $a1

Decrypt_Loop:
    lb $t2, 0($t0)
    beq $t2, $zero, Decrypt_Done

    li $t3, 'A'
    blt $t2, $t3, Skip_Shift1
    li $t3, 'Z'
    bgt $t2, $t3, Skip_Shift1

    lb $t4, 0($t1)

    li $t5, '\n'
    beq $t4, $zero, Reset_Key1
    beq $t4, $t5, Reset_Key1

    sub $t4, $t4, 'A'
    sub $t2, $t2, $t4

    li $t3, 'A'
    bge $t2, $t3, Store_Result1
    add $t2, $t2, 26

Store_Result1:
    sb $t2, 0($t0)

    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j Decrypt_Loop

Reset_Key1:
    move $t1, $a1
    j Decrypt_Loop

Skip_Shift1:
    addi $t0, $t0, 1
    j Decrypt_Loop

Decrypt_Done:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8
    jr $ra
