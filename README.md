## Parllelx.sh - Run chmod or chown command parallelly on huge amount of file

It's a simple bash script to run chown and chmod commands parallelly in background using screen command.

### Usage:

```bash
Usage: ./parallelx.sh [ -c number_of_concurrent_process ] [ -d directory_depth ] [chmod or chown] [user:group or 644] /path_to_directory

-c = number_of_concurrent_process 
-d = directory_depth

#example
./parallelx.sh -c 5 -d 3 chmod 644 /opt/jenkins
```

### Prerequisites
- directories name should not contain comma(,)
- required command `nproc find sort sed screen`

### Why? and Motivation:
After moving 650GB of jenkins data(/var/lib/jenkins) containing small small files from hard disk(AWS EBS) to NFS(AWS EFS) i had to change the ownership of files which was taking long time and after 3+ hours i just stopped the chown command. As Jenkins server had 8 CPU core i thought of using by going inside directories and running the chown command one by one. which took around about 1 hour to complete but i had to do lots of stuff manually like getting the list of directory hierarchy and monitoring the status of previous running chown command before i can run another command. I thought of writing this script to fully automate those steps.


### Limitation
- Not good with running this script on small data as it will take more time than normal chmod or chown command

### Alternatives 
Below are some alternative methods but it still has some limitations like how recursive commands will run with directory depth, and does give progress status.

- GNU Parallel - https://www.cyberciti.biz/faq/how-to-run-command-or-code-in-parallel-in-bash-shell-under-linux-or-unix/
- parallel_alternatives - https://www.gnu.org/software/parallel/parallel_alternatives.html
- https://stackoverflow.com/questions/30733158/s3fs-recursive-chown-chmod-takes-a-long-time
- https://serverfault.com/questions/796330/how-do-i-set-destination-permissions-with-rsync-chown-chmod

### Some questions
- https://www.reddit.com/r/devops/comments/13tk8rj/parllelxsh_run_chmod_or_chown_command_parallelly/