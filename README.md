# Joe's Blue Server
Universal Blue-based server OS

## First-Time Setup
Boot into the Anaconda installer using `joes-blue-server.iso` and proceed through the installation steps.

Once booted into the system, use a privileged (i.e. sudoer) user to rebase to the signed container image:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/joe-damore/joes-blue-server:latest
```

Reboot, and your system will be up-to-date and ready to use. You can manually configure users, services, containers, etc. using the [Cockpit](https://cockpit-project.org/) interface at `localhost:9090`. Alternatively, you can use tools like Ansible to configure the server.
