## systemd daemon-reload vs reload vs restart

The goal is to understand the difference between:

systemctl daemon-reload
systemctl reload "service"
systemctl restart "service"

#### systemctl daemon-reload

Realoads systemd's knowledge of all unit files on disk. It scans all unit directories; <br>
It is required after creating, deleting, or editing unit files such as:

/etc/systemd/system/reload-drill.service

It never stops, starts, or restarts a service process.


#### systemctl reload "service"
systemctl reload service - reloads its own internal configuration file without stoping the service process. It looks inside the service file and executes the exact command defined in the ExecReload=. The Main PID stays the same.

#### systemctl restart "service"

Stops and starts the service process. Cause the old process to exit and a new process to be created with a new Main PID.


### Lab Service

created a test service named reload-drill.service under:

/etc/systemd/system/reload-drill.service


The service used the following configuration:

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot1.png)

The service writes evidence to:

/tmp/reload-drill.log

ExecStart writes a START line and then runs sleep infinity so the service remains active.

ExecReload writes a RELOAD line when the service is reloaded.


###### Important shell lesson

systemd does not interpret shell syntax such as the redirection operator >> by itself. The command must explicitly run through a shell:

This would not work: echo "text" >> /tmp/file

Bash must be explicitly invoked allowing the shell expansions and operator usage: /bin/bash -c 'echo text >> /tmp/file'. 

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot11.png)


After creating the unit file, I ran:

sudo systemctl daemon-reload
sudo systemctl restart reload-drill.service
systemctl status reload-drill.service

daemon-reload made systemd aware of the new unit file.

restart stoped and started the service.

status confirmed that the service was active and showed the Main PID.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot18.png)

### Part 2: Prove that systemctl reload does not restart the service

Reload log appears:

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot9.png)

Main PID stays the same:
![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot10.png)

This proved that: <br>
"systemctl reload service" does not start, stop or restart a service, it only runs the reload behaviour defined in the unit.

### Part 3: edit the unit file without daemon-reload

I changed:

ExecReload=/bin/bash -c 'echo "RELOAD version=1 time=$(date)" >> /tmp/reload-drill.log'

to:

ExecReload=/bin/bash -c 'echo "RELOAD version=2 time=$(date)" >> /tmp/reload-drill.log'


![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot11.png)

Systemd still used the old version of the unit file:

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot12.png)

This proved that editing the file does not automatically update systemd’s loaded unit configuration.


### Part 4: running daemon-reload

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot13.png)

showed "RELOAD version=2" in the log output.

This proves: <br>
daemon-reload updates systemd’s unit-file knowledge <br>
reload runs ExecReload <br>
Neither command affects the service's status or main PID

### Part 5: restart behaviour observation

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot14.png)

The current main PID is 2887

Executing the command "systemctl restart reload-drill.service"

the service created a new START log entry.

The Main PID changed.

This proved that restart is different from reload:

restart: stops and starts the service <br>
reload: runs ExecReload without replacing the main process

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot15.png)


### Part 6: chaos engineering

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot16.png)

I commented out the ExecReload= line and ran:

s![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot17.png)


The reload failed with:

Job type reload is not applicable for unit reload-drill.service

Root cause:

The service had no reload behaviour defined.

A service can only be reloaded if systemd knows how to reload it, usually through ExecReload=.

#### The Model

Changed a unit file?: <br>
sudo systemctl daemon-reload

Want the running service to reload its own config? <br>
sudo systemctl reload "service"

Want to stop and start the service process?
sudo systemctl restart "service"

enable is separate: <br>
systemctl enable "service"

This configures boot-time startup behaviour. 
It does not start the service immediately.