bits	16


	; stack
	; 0700:0000 ---------------	<- ss:bp
	; 0700:fffe current selection	<- ss:bp - 2
init:
	; initializes segment and stack registers
	mov	ax, 0x07c0
	mov	ds, ax
	xor	ax, ax
	mov	ss, ax
	mov	bp, 0x7000
	mov	sp, 0x6ffe

	; clears and initializes the screen
	mov	ax, 0x0003
	int	0x10
main:
	mov	word [ss:bp - 2], 0	

	mov	si, title
	call	prnt_line
	call	update_selection
main.select:
	call	read_char
	cmp	al, 0x0A
	je	main.enter
	or	al, al
	jnz	main.select
	sub	ah, 0x48
	jz	main.up
	sub	ah, 0x08
	jz	main.down
	jmp	main.select
main.up:
	and	word [ss:bp - 2], 0xffff
	jz	main.end
	dec	word [ss:bp - 2]
	jmp	main.end
main.down:
	movzx	ax, [entries.count]
	dec	ax
	cmp	word [ss:bp - 2], ax
	jz	main.end
	inc	word [ss:bp - 2]
main.end:
	call	update_selection
	jmp	main.select
main.enter:
	; "enter" handler
	jmp	$


; prints string on cursor position
; params	si - (void*) address to the null-terminated string
prnt_str:
	mov	ah, 0x0e
	or	bh, bh
prnt_str.loop:
	lodsb
	or	al, al
	jz	prnt_str.ret
	int	0x10
	jmp	prnt_str.loop
prnt_str.ret:
	ret


; similar to prnt_str, but with newline
; params	si - (void*) address to the null-terminated string
prnt_line:
	call prnt_str
	mov	ax, 0x0e0d
	int	0x10
	mov	ax, 0x0e0a
	int	0x10
	ret


; reads user input
; params	none
; return	ax
;		if al = 0, ah = extended key code
;		if al > 0, al = ascii code, ah = scan code
read_char:
	xor	ah, ah
	int	0x16
	ret


; moves cursor one char right
step_cursor:
	push	ax
	push	cx
	push	dx
	push	si
	push	di

	mov	ah, 0x03
	xor	bh, bh
	int	0x10

	inc	dl
	inc	dl
	mov	ah, 0x02
	int	0x10

	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	ax
	ret


; updates the color thingy
update_selection:
	mov	ah, 0x02
	xor	bh, bh
	mov	dx, 0x0100
	int	0x10

	mov	dx, word [ss:bp - 2]
	inc	dx
	shl	dx, 8
	xor	bh, bh
	mov	cx, 0x01
	mov	dl, 0x01
update_selection.loop:
	cmp	dh, dl
	mov	bl, 0x0e
	jne	update_selection.printnum
	mov	bl, 0xe0
update_selection.printnum:
	mov	ah, 0x09
	mov	al, dl
	add	al, 0x30
	int	0x10
	call	step_cursor

	movzx	si, dl
	dec	si
	shl	si, 3
	add	si, 0x02
	add	si, entries
	call	prnt_line

	inc	dl
	cmp	dl, [entries.count]
	jle	update_selection.loop
	ret


title	db	"Select game with arrow keys", 0

entries		db	1, 1, "SNAKE", 0
		db	2, 1, "MAZE ", 0
		db	3, 1, "TEST ", 0
		db	4, 1, "AS   ", 0
entries.count	db	($ - entries) / 8

times	510 - ($ - $$)	db	0
dw	0xAA55
