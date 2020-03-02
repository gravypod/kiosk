ETHERNET_INTERFACE=enp4s0

viewport/node_modules:
	cd viewport && npm install

build/viewport/srv/app: viewport/node_modules
	cd viewport && npm run linux64 && cd ..
	mkdir -p build/viewport/srv/ || true
	mv viewport/viewport-linux-x64/ build/viewport/srv/app/

build/image.raw: build/viewport/srv/app
	sudo mkosi --force --extra-tree ../build/viewport/ --extra-tree ./mkosi.extra/ --directory image
	mv image/image.raw build/image.raw

build/image.vmdk: build/image.raw
	qemu-img convert -f raw "$<" -O vmdk $@

.PHONY: all
all: build/image.vmdk
	echo "Built everything"



.PHONY: install_vbox
install_vbox: build/image.vmdk
	# Register in VirtualBox
	VBoxManage createvm --name vm-kiosk --ostype Ubuntu_64 --register
	VBoxManage modifyvm vm-kiosk --firmware efi
	VBoxManage modifyvm vm-kiosk --nic1 bridged --bridgeadapter1 "$ETHERNET_INTERFACE"
	VBoxManage modifyvm vm-kiosk --memory 2048
	VBoxManage modifyvm vm-kiosk --cpus 2
	VBoxManage storagectl vm-kiosk --name "SATA Controller" --add sata --controller IntelAhci
	VBoxManage storageattach vm-kiosk --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium build/image.vmdk

.PHONY: install
install: install_vbox
	echo "Virtual box image created"

.PHONY: clean
clean:
	rm -rf build/ || true
	rm -rf viewport/node_modules || true
	VBoxManage unregistervm --delete vm-kiosk    || true
