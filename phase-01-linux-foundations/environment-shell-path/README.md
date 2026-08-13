# Environment, Shell, Script and PATH lab

## Goal

### LAB 0 Environment build

This lab will focus on the shell environemt I created a directory with subfolders and files, the structure and contents can be found [here](./fixtures/environment-shell-path-lab/)


I used `mkdir -p ~/environment-shell-path-lab/{bin,logs,tmp,baseline}` to create the skeleton of the directory

`mkdir` creates directories
`-p` does not report an error when a directory already exists and creates missing parent directories as needed.

![mkdir-directory-tree](./lab_images/lab_environment/S1.png)

The `{}` is the shell's brace expansion which allows creation of subfolders.

`$` allows expansion for special parameters

`$SHELL` describes the current shell program being used

`$0` tells me the shell being used by the current session

`$$` represents the PID of the current shell

in the `ps` output the PID represents the sub/child shell whereas PPID is the parent shell

`$SHELL`, `$0`, `/proc/$$/shell`, they could still describe the shell being used in this case `bash`, however they could be referring to the parent shell or a chilf shell started by the parent shell

![pwd-shell-ps](./lab_images/lab_environment/S2.png)

![env-sort-printf](./lab_images/lab_environment/S3.png)

![printf-path](./lab_images/lab_environment/S4.png)


### Lab 1 Shell variable & Environment inheritance

`LAB_MODE=export` saves this variable temporarily, the next shell session login, this variable will dissapear from the shell variables, the 1st child shell could not see it because it was not saved globally in the environment.

`export` causes the shell variables to be save globally in the shell environment, it saves the variables in the export does not creat a global system variables, it exports the current shell variables to the systems environment

A child process inherits the parent's shell enviroment, how it cannot modify it

`unset` removes the the shell variables that were manually exported

![shell-variables+environment-inheritance](./lab_images/shell-environment-variables/S1.png)


### Lab. 2 Quoting and Expansion


single quotes preserves the literal value of each character  within the quotes.

double quotes preserves the literal value of all characters within the quotes, with the exception of `$`. if a string is precedeed by the `$` will cause the string to be translated

the unquoted `$LAB_NAME` produced multiple arguements becsuse the the shell interpreted each word as an individual string

`"$LAB_NAME"'` printed the saved variable because it was enclosed in `""` with a leading `$` causing the shell to expand and print the variable

`'$LAB_NAME'` printed literally because the shell preserves the literal value of each character in the quotes. single qutoes prevent shell expansion

[lab_name](./lab_images/quoting-expansions/S1.png)

the shell expands carries out the expanding if a `$` is infront of a string within double quotes

when running the command `printf '<%s>\n' tmp/*.conf`, this did not prevent glob expansion hence all files ending with `conf` were displayed

when running the command `printf '<%s>\n' "tmp/*.conf"` and `printf '<%s>\n' 'tmp/*.conf'` both prevented the glob expansion because single and double quotes both preserve the literal value of each character within the quotes. 

`printf 'working directory: %s\n' "$(pwd)"`, `"$(pwd)"` is expanded by shell before the outer command executes. 

[globbing](./lab_images/quoting-expansions/S2.png)

[commandsubstitution](./lab_images/quoting-expansions/S2.png)