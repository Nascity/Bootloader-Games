# Bootloader Games
This is a small program that I am making to have a better understanding of 16-bit real mode operation.

## Usage
Run the command below to build the image file.
```
bash build.sh
or
bash build.sh ~/destination/directory
```
To test it on QEMU, use the command below.
```
qemu-system-i386 -drive file=image.img,format=raw
```
## Details
<img src="https://user-images.githubusercontent.com/97524957/235354384-5f5c764c-847d-45db-b370-0fffbf4a8067.png" width="600">

Instructions in sector 0 ([main.asm](./main.asm)) print main menu as shown above.

<img src="https://user-images.githubusercontent.com/97524957/235355063-8c7e4b5e-1c61-415e-8969-f7426da8d7c8.png" width="600">

Games are stored in other sectors of the harddrive, and their location and name are stored in sector 0 as 8 bytes data.
