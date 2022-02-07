# Dnsmasq

This is inserted between the LAN and the upstream DNS servers. For the 
purposes of this exercise it allows us to:

- Create DNS records local devices on the LAN
- Provide PXE boot. This lets machines on the LAN to boot from the network
  and install an OS
  
## Install on the NAS
- Use App Centre to install ContainerStation
- Create a shared folder called config with manual path /config
- potentially DHCP server (I don't use this)

  - add a subfolder dnsmasq
  - copy in the file dnsmasq.conf to the subfolder
  - edit the conf file to match your DNS config
- In Container Station pull the image 4km3/dnsmasq (pick a new stable tag
  don't use 'latest')
- Create a new container with:
    
    - image: 4km3/dnsmasq
    - entrypoint: /usr/sbin/dnsmasq -k --conf-file=/config/dnsmasq.conf
    - Advanced Settings

      - network: choose a fixed address outside of your DHCP
      - shared folder: /config -> /config/dnsmasq read/write
- Start the container and set it to auto start
- Verify it is working 

  - launch a console (with /bin/sh) with the '>_' button
  - cat /config/dnsmasq.conf
  - from the workstation try to telnet to port 53 on the IP you chose.
