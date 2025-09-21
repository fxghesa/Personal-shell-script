#!/bin/bash
cd Program/debian_container/
export PIPEWIRE_RUNTIME_DIR=/run/user/1000
qemu-system-x86_64 -M q35,usb=on,acpi=on,hpet=off -m 16G -cpu host,hv_relaxed,hv_frequencies,hv_vpindex,hv_ipi,hv_tlbflush,hv_spinlocks=0x1fff,hv_synic,hv_runtime,hv_time,hv_stimer,hv_vapic -smp cores=12 -accel kvm -drive file=debian.qcow2 -device usb-tablet -device VGA,vgamem_mb=256 -nic user,model=e1000 -monitor stdio \
    -audiodev pipewire,id=audiodev1 \
    -device AC97,audiodev=audiodev1


