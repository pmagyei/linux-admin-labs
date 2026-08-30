# Install, Verify, and Inspect Package Contents

## Package Inspection (before installation)

![](./lab_images/s1.png)

`command -v glances`, is the current shell able to resolve the command? No, the shell cannot resolve `glances`, command lookup fails.

`dpkg -s glances`, does the Debian Package manager recognise it as installed on the system? No, the package is not installed, and dpkg has no information available

`apt-cache policy glances`, is the package installed? If so which Version? Are there any candidates? Which repository is it present in?

`glances` is not installed, the candidate is ` 3.4.0.3+dfsg-1`, the version is `3.4.0.3+dfsg-1` with apt priority 500. From the `noble/universe` repository 

## If I install the package, what will happen(prediction)?

`glances`state should change installed, both `dpkg` nd `apt-cache policy` should report this change.

The filesystem should include a pathname that is owned by the installed package, in this case `glances`. 

Installing `glances` can lead to dependency package installation however, packages do not form dependencies as a consequence of an installation. Dependency relationships are declared in the package's metadata.

An install is successful once `command`, is able to resolve, `dpkg` confirms the system recognise the installed package, `apt-cache policy`'s output confirms the installation, the version, the candidate and from which repository.

## Package installation & State

![](./lab_images/s2.png)


`apt install glances` threw a permission error because I ran the command without `root` privilege. 

`sudo apt install glances`, outputs the additional packages needed for `glances` to work. `100 newly installed` means it will install 100 packages.

Installing one monitoring utility pulled 100 additional packages and 462mb of disk usage. Before pressing `Y` always inspect.


## Packages state verification (after installation)

`command -v glances`, is the current shell able to resolve the command? Yes, the shell can resolve `glances`, command lookup is successful.

`dpkg -s glances`, does the Debian Package manager recognise it as installed on the system? Yes, the package status is: `install ok installed`, and dpkg is able to provide metadata information such as: dependencies, version, description.

`apt-cache policy glances`, is the package installed? If so which Version? Are there any candidates? Which repository is it present in?

yes, the version installed is `3.4.0.3+dfsg-1`, the candidate is ` 3.4.0.3+dfsg-1`. From the `noble/universe` repository 

![](./lab_images/s3.png)


`dpkg -L glances` lists the filesystems pathnames recorded for the installed package `glances`
![](./lab_images/s4.png)
![](./lab_images/s4.1.png)


`dpkg -S /usr/bin/glances` answers:
which installed package owns `/usr/bin/glances`?<br>

![](./lab_images/s4.2.png)

## Does the installed package function?

I tested if the package installed would run as expected:
`glances --version `
![](./lab_images/s5.2.png)

`glances --help `

![](./lab_images/s5.png)

`glances`

![](./lab_images/s5.1.png)


## What dependencies did the package form?

`apt-cache depends glances` answers:
What packages does `glances` depend on? 

`apt-cache rdepends glances` answers:
what packages depend on `glances`?

Both output package metadata that also appears in the output of `dpkg -s glances` .
![](./lab_images/s6.png)

### apt-cache depends glances vs apt install glances 

`apt-cache depends` shows the direct dependencies including Depends, Pre-Depends, Recommends and Suggests.

`apt install` recursively resolves those dependencies; determines what is already installed on the system and finalises the additional installations required. 