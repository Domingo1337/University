# Task 4

`kill -s <signal_name or num> <pid>`
`pkill <**params>` where based on params it will grep for processes
`xkill` - kill client by its X resource

kill, pkill default: *SIGTERM*


## Stop process

kill -s SIGSTOP $(ps -a | grep xeyes | awk '{ print $1 }')
pkill --signal SIGSTOP xeyes


## Resume process

kill -s SIGCONT $(ps -a | grep xeyes | awk '{ print $1 }')

## Kill process

kill -9 $(ps -a | grep xeyes | awk '{ print $1 }')


## Queueing signals

`cat /proc/<pid>/status > xeyes_dump.txt`

pkill --signal SIGUSR1 xeyes
pkill --signal SIGUSR2 xeyes
pkill --signal SIGINT xeyes


`cat /proc/<pid>/status > xeyes_dump_after.txt`

`diff -u xeyes_dump.txt xeyes_dump_after.txt`


## Pending signals

SigPnd - pending signals for the thread
ShdPnd - shared pending signals for the process

SigBlk - blocked by the process
SigIgn - ignored -||-
SigCgt - caught -||-

ShdPnd format:

0000 0000 0000 0000


The right most 4 bytes represent standard signals
Left represents Linux real-time signals

Each signal is encoded as bit[signalVal - 1]

### Display process info about signals

`cat /proc/<pid>/status | grep 'Sig\|Shd'`


### Order of pending signals

Based on numbers, ascending (i.e the one with num 1 will be first)

