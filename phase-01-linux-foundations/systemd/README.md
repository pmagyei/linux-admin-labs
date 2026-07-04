## systemd daemon-reload vs reload vs restart

daemon-reload - forces systemd to scan all unit directories; makes systemd aware of completely new service files, deleted service files, or manual edits you made to an existing service file. It only updates systemd's internal memory. It never stops, starts, or restarts an application

systemctl reload service - ells a currently running application to reload its own internal configuration file without shutting down. looks inside the service file and executes the exact command defined in the ExecReload=.


### Part 1

create a test service called:

reload-drill.service

Changes to be tested:

1. Change the systemd unit file
2. Change the service reload behaviour
3. Restart the service

The goal is to understand systemd behaviour

reload-drill.service created in /etc/systemd/system/ directory

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot1.png)

reloaded the daemon to that systemd became aware of  the new service

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot2.png)


The service unit configuration was edited due systax errors and typos which were corrected.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot3.png)

reloaded and restarted the daemon again to apply the new service unit configuration

notice that the main PID has chnaged from 1166 to 1244

when a service unit is stopped and started or restarted the main PID changes. A new process is started by systemd

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot4.png)

the unit service should have generate two logs:
the 1st log from the 1166 process

th 2nd lof from 1244 process

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot5.png)

Notice how reloading did not generate a log
![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot6.png)


Due to systemd not using shell to execute commands the redirection operator >> does not work in unit configuration file.

so the configuration file was edited, the daemon reloaded and the and reload service was restarted.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot7.png)

I also enabled the service because even after reloading and starting the systemctl status output showed the service was still inactive once i enabled it I reloaded and started the service and it worked

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot8.png)


### Part 2: Prove that systemctl reload does not reload the unit file

Reload log appears:

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot9.png)

Main PID stays the same:
![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot10.png)


neither "systemctl daemon-reload" or "systemctl reload service"
starts, stops or restarts a service, this means the PID stays the same

when the service is started the ExexStart line will be executed
when the service is reload the ExecReload line will be executed

### Part 3: edit unit file without daemon reload

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot11.png)

The log will output will use REALOAD version=1 because configuration has been updated, systemd is still using what it has saved in its memory, a daemon reload would ensure that systemd is aware of the update in the configuration file.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot12.png)


### Part 4: run daemon-reload

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot13.png)

The daemon-reload did not affect the services status or main pid however the reload version2 was in the log output


### Part 5: restart behaviour observation

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot14.png)

The current main PID is 2887

When restaring the unit service, it stops it and starts it, this triggeres a new process being created with a new PID. The output of the log shows a new PID for the process.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot15.png)

### Part 6: chaos engineering

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot16.png)

If service file does not have an ExecReload= line defined, the command will fail with an error. Because ExecReload=, defines the reload behavioue of the service.

![ss](/phase-01-linux-foundations/systemd/lab_images/Screenshot17.png)