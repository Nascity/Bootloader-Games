bits	16

snake_main:
	mov	si, msg
	call	prnt_str
	jmp	$


prnt_str:
	lodsb
	or	al, al
	jz	prnt_str.return
	mov	ah, 0x0e
	int	0x10
	jmp	prnt_str
prnt_str.return:
	ret


msg	db	"Hello, world!", 0

times	512 - ($ - $$)	db	0
