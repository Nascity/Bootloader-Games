#!/bin/sh

outdir="."
main=main.asm
temp=tmp.bin
image=image.img

if [ $# -eq 1 ]; then outdir=$1; fi
if [ -e $outdir/$image ]; then rm $outdir/$image; fi

touch $outdir/$image
nasm -fbin $main -o $outdir/$temp
cat $outdir/$temp >> $outdir/$image

for game in ./games/*.asm
do
	nasm -fbin $game -o $outdir/$temp
	cat $outdir/$temp >> $outdir/$image
done

rm $outdir/$temp
exit 0
