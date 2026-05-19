.data
	msg_ent: .asciiz "Digite um numero octal (1 < n < 10000): "
	msg_erro: .asciiz "Numero invalido! Tente novamente.\n"
	msg_result: .asciiz "O Numero em decimal é: "
	pl: .asciiz "\n"
	buffer: .space 10
	
.text
main:

loop:
	la $t0, buffer
	li $t1, 0
	
	li $v0, 4
	la $a0, msg_ent
	syscall
	
	li $v0, 8
	la $a0, buffer
	li $a1, 10 #Defini limite que pode ser lido (10 bytes)
	syscall
	
	la $t0, buffer
	li $t1, 0
	
loop_conv:
	lb $t2, 0($t0)
	beq $t2,10, fim_conv
	beq $t2, 0, fim_conv
	
	sub $t2, $t2, 48	#Verificar Tabela ASCII
	
	bltz $t2, invalidado
	bgt $t2, 7, invalidado #Não existe 8 e 9 em octal, portanto, se o numero digitado for maior que 7 é invalido

	mul $t1, $t1, 8
	add $t1, $t1, $t2
	
	addiu $t0, $t0, 1
	j   loop_conv
	
fim_conv:
	blt $t1, 2, invalidado
	bgt $t1, 4095, invalidado
	
	li $v0, 4
	la $a0, msg_result
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 4
	la $a0, pl
	syscall
	
	li $v0, 10
	syscall
	
invalidado:
	li $v0, 4
	la $a0, msg_erro
	syscall
	j loop
	
