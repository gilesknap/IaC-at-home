# What remains to do for IaC

- Get ClusterAPI to bootstrap entire cluster from a Git Repo
  - may need to build our own image or get spectro cloud to support user scripts (and min kernel)
- watch this video https://vimeo.com/678697127
- do a cli based script
- check what voltage based throttling is happening with the 5amp supply
  - probably want to sort out a 10AM supply wired to the 5v rail
- fork uefi and make it default to the settings we want (look into network only device descovery option too)
- investigate why newer ubuntu images fail to deploy 
  - I believe they are reconfiguring the sdcard and making it un-bootable
- HOLD: finish off my user scripts for workers and control plane.
  - but hold this until a decision on the final cluster api solution is found
- switch to etcd or other separate cluster db so it can reside on the nas
  and the control plane can become cattle :-) 
- in a similar vein, currently nuc1 holds a extra backup ssd. I quite like this
  but need to make it so that deployment won't overwrite it
- use kubeseal or similar to put my secrets in github! https://learnk8s.io/kubernetes-secrets-in-git
  It would be nice if this also worked for passwords in configmaps e.g. noip ddclient passwords
  but I think we'll need something else for that.

# What remains for my cluster in general

- Fix daily backup 'latest' link creation - it should use relative path not /backup
- Use Thanos and qnap s3 support to fix Prometheus not liking nfs 
  (make prometheus properly persistent - this also requires fixed IPS for machines in the cluster)
- switch to fixed IPs so as not to confuse known_hosts and prometheus
- make gknuc mount bigdisk_archive on startup
- in general - switch to helm charts for all k3s-minecraft YAML
- also in general - make PVs for all apps persistence 
- Make prometheus send notifications to slack when e.g. backups are failing
- reduce node selection as much as possible (see if noah-james minecraft would run on p4 for example)
- Put photos sync to NAS in cluster
- Put Google drive sync onto NAS. Either directly or by rsync.
- Look at recommendations for NFS security - not sure we are that secure currently

# Done

- Fix unable to resolve local DNS names when on VPN
- Fix reboot lockup issue on gknuc
- Fix PXE booted Pi fails 'wating for network to be configured by CommMan'
- setup overnight rsync to bigdisk_archive
- use native minecraft helm chart backups NO NEED
- See if NAS can do containers (yes - running maaspower in a container!)
- Set up NAS security as per notice board (Not Sure - do I need online presence?)
  DONE. TODO review the NFS security side
- Set up a PXE sever and install a PI using. then install gknuc using it
