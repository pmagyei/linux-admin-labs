# text processing & pipes lab

## Goal

understand how stdin, stdout and stderr are processed on the shell, understand stdout redirection (overwrites and appending)
understand filtering techniques using grep to match patterns
make use of the wc to count lines, words and bytes
sort lines
uniq to remove duplicates
cut to extract fields
awk to extract and process fields and sed for editing, transformation/substitution streams

## Lab 0: Test data setup

I used `cat` + here-doc to create controlled sample files for the lab
![service.log](lab_images/Screenshot1.png)

![users.csv](lab_images/Screenshot2.png)

## Lab 1: Viewing and counting text

`cat service.log` concatenates files and prints to the standard output
![service.log](lab_images/Screenshot3.png)

`head service.log` outputs the first 10 lines of a file
![service.log](lab_images/Screenshot4.png)

`tail service.log` outputs the last 10 lines of a file
![service.log](lab_images/Screenshot5.png)

`wc service.log` shows lines count, words count , and bytes count for each file
![service.log](lab_images/Screenshot6.png)

`wc -l service.log` shows lines count
![service.log](lab_images/Screenshot7.png)


Becasue the file has 10 lines, `head` and `tail` displayed the whole document. By default `head` shows the first 10 lines, `tail` shows the last 10 lines.

### Mistake/observation

I made a quoting mistake while creating the here-doc, so the shell kept waiting for inoputs. I exited the unfinished command with `ctrl+c`, which sends SIGINT.

![service.log](lab_images/Screenshot8.png)

## Lab 2: grep filtering

`grep`  prints lines that match a pattern

the command `grep "ERROR" service.log`
tells grep to look for "ERROR" in the log file, if a line contain the pattern of "ERROR" it is sent to stdout
![service.log](lab_images/Screenshot9.png)

the command `grep "WARNING" service.log` tells grep to look for "WARNING" in the log file, if a line contain the pattern of "WARNING" it is sent to stdout
![service.log](lab_images/Screenshot10.png)


the command `grep "ssh" service.log` looks for "ssh" in the log file, if a line contain the pattern of "ssh" it is sent to stdout
![service.log](lab_images/Screenshot11.png)


`grep -i "error" service.log` ignores case sensitivity in patterns and input data, lines will be sent to stdout as long as the characters match the pattern. the `-i` flag ignores case-sensitivity in patterns and input data.

the command `grep "error" service.log` looks for lines that contain the pattern. Since none of the lines contain `error`, nothing is printed to stdout
![service.log](lab_images/Screenshot12.png)


`grep -v "info" service.log` returned every line because the file contains `INFO` in uppercase, not `info` in lowercase. Without `-i` grep is case-sensitive. 

`-v` flag selects the lines that don't contain the matching pattern.
![service.log](lab_images/Screenshot13.png)


the command `grep -vi "info" service.log` looks for lines that do not match the pattern and ignores the case differences. 
1) `-v` would print all the lines, since none of the lines matche the pattern(inverst the match)
2) `-i` would ignore the case differences, so wether it's in capital or not it is excluded before sending to stdout, this works as a restrictive filter

`grep` can be  as filter to remove noise and restrcit your searches, during troubleshooting you want specific patterns/logs.

applying broad patterns to your searches could result in more noise to get through which can lead to longer time troubleshooting. also a broad search mightt obfuscate the real issue if you are using the wrong logs to determine the problem.

#### Observation

I noticed that `grep` sometimes highlights the words when printed out.

## Lab 3: Pipes

The pipe symbol `|` sends stdout of a command on the left to stdin of the command on the right


`cat service.log | grep "ERROR"` sends contents from `service.log` into `grep`, then `grep` only prints the lines containing `ERROR`. 
![service.log](lab_images/Screenshot14.png)

This works but it's usually unnecessary becase grep can read directly from a file:

`grep "ERROR" service.log` <br>
`grep "ERROR" service.log | wc -l` looks for lines  in `service.log` that contain `ERROR`,
the matching line are then sent into the `wc -l` command which counts the lines. The output was `3` meaning there were three matching error lines.

![service.log](lab_images/Screenshot15.png)


`grep "ssh" service.log | grep "accepted"`
acts as a double filter. it first filters for "ssh" related lines then narrows the output line that also contain "accepted", this results in the printing of lines that only contain both "ssh" and "accepted". 
![service.log](lab_images/Screenshot16.png)


`grep "ssh" service.log | grep "failed"`

`grep "ssh" service.log | grep -v "failed"`
looks for "ssh" related lines, then removes lines containing `failed`.
![service.log](lab_images/Screenshot17.png)




## Lab 4: sort and uniq

## Lab 5: cut field extraction

## Lab 6: awk field extraction

## Lab 7: sed transformations

## Lab 8: Redirection

## Lab 9: journalctl pipeline

## Lab 10: grep process trap

## Final mental model

## Relevance to infrastructure engineering




### Commands used

### Evidence

### Explanation

### Mistake or trap observed