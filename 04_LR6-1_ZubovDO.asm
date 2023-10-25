use16
org 100h

mov bx, 0x0
mov di, 0x0

mov es, bx

mov cx, 0
mov dx, file_creation
mov ah, 0x3c
int 21h
jc exit

mov bx, ax

call dump

jmp exit

exit:
	mov ah, 3eh
	int 21h
	mov ax, 0
	int 0x16
	int 0x20
	
dump:
	pusha
	mov cx,16
	first_loop:
		push cx
		
		mov cx,16
		second_loop:			
			push ax
			call element_getter
			pop ax
			
			inc di
			
			pusha
    			mov byte[ds:buff], " "              
    			mov cx, 1
    			mov dx, buff
    			mov ah, 0x40
    			int 0x21
    			popa
    			
			loop second_loop
		
    		pusha

   		mov byte[ds:buff], 0xA
   		mov cx, 1
    		mov dx, buff
    		mov ah, 0x40
    		int 0x21

    		popa
		
		pop cx
		loop first_loop

	popa
	ret

element_getter:	
	pusha
	
	mov al, byte[es:di]

	mov dl, al
	shr dl,4
	call get_ascii
	
	pusha
    	mov byte[ds:buff], dl
    	mov cx, 1
    	mov dx, buff
    	mov ah, 0x40
    	int 0x21
    	popa

	mov dl, al
	and dl, 0x0f
	call get_ascii
	
	pusha
    	mov byte[ds:buff], dl
    	mov cx, 1
    	mov dx, buff
    	mov ah, 0x40
    	int 0x21
    	popa

	popa
	ret


get_ascii:
  cmp dl,0x09   
  ja word_symbol  
  jmp digit_symbol

word_symbol:
  add dl,0x37
  ret

digit_symbol:
  add dl,0x30
  ret

buff db ?
file_creation db 'ZubovDO.txt', 0
