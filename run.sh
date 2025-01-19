#!/bin/bash 

set -e

install_dir="/goinfre/$USER/"
archive_file="kali-linux-2024.4-qemu-amd64.7z"
kali_qcow="/goinfre/$USER/kali-linux-2024.4-qemu-amd64.qcow2"

if [ ! -f $kali_qcow ]; then
	if [ ! -f /tmp/$archive_file ]; then
		wget https://cdimage.kali.org/current/$archive_file -O /tmp/$archive_file
	fi
	archive_file=/tmp/$archive_file

	# Check if py7zr is installed
	if ! pip show py7zr &> /dev/null; then
	  	echo "Installing"
	  	pip install py7zr
	fi
	
  	# Extract the archive using Python
  	echo "Extracting $archive_file"
  	python3 -m py7zr x $archive_file $install_dir
 	echo "Extraction complete!"
	#rm -f $archive_file
 	cp run.sh ~/ && chmod u+x ~/run.sh || true
fi

IMAGE_PATH=$kali_qcow
SSHPORT=2222

#-display gtk,zoom-to-fit=on,grab-on-hover=on,window-close=off \
export SDL_ALLOW_ALT_TAB_WHILE_GRABBED=0;

qemu-system-x86_64 \
-display sdl,gl=on \
-cpu host \
-full-screen \
-enable-kvm \
-machine q35,accel=kvm \
-nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
-device virtio-vga-gl,xres=1920,yres=1080 \
-device intel-hda -device hda-duplex -device virtio-serial-pci  \
-m 12G \
-smp 20 \
-usb -full-screen -daemonize \
${IMAGE_PATH}
