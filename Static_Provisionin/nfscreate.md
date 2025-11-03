

 **NFS Server Setup on RHEL**
 -----------------------------
 
1- Install NFS utilities:
  ```bash
  sudo dnf install nfs-utils
  sudo systemctl enable --now nfs-server
  ```
- Create and export the shared directory:
  ```bash
  sudo mkdir -p /mnt/nfs_share
  sudo chown nobody:nobody /mnt/nfs_share
  echo "/mnt/nfs_share *(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
  sudo exportfs -rav
  ```

2. **Firewall and SELinux**
- Allow NFS ports:
  ```bash
  sudo firewall-cmd --add-service=nfs --permanent
  sudo firewall-cmd --reload
  ```
- If SELinux is enforcing:
  ```bash
  sudo setsebool -P nfs_export_all_rw 1
  ```

3. **Ubuntu Nodes as NFS Clients**
- Install NFS client tools:
  ```bash
  sudo apt update
  sudo apt install nfs-common
  ```
- Test mount:
  ```bash
  sudo mount <rhel-ip>:/mnt/nfs_share /mnt/test
  ```

---

**Kubernetes Integration**

Once verified, you can use this NFS path in your **PersistentVolume** YAML:

```yaml
nfs:
  path: /mnt/nfs_share
  server: <rhel-ip>
```


