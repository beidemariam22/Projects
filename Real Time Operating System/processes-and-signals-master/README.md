# Processes and Signals

## 1. `[X]` Write a program in C with the name tsig
which tests synchronization mechanisms and signals. Use the following system functions: fork(), wait(), signal() or sigaction() and kill(). The program should run the algorithm from the section 2 with additional modifications from
the section 3.


## 2. `[X]` Processes' algorithms without signal handlers

### `[X]` The main (parent) process algorithm

1. `[X]` Create NUM_CHILD child processes, where NUM_CHILD is defined in the
program, use the fork() function. Insert one second delays between
consecutive fork() calls.

2. `[X]` Check whether each of the child processes has been correctly created. If
not, print an appropriate message, send to all already created child
processes SIGTERM signal and finish with the exit code 1.

3. `[X]` Print a message about creation of all child processes.

4. `[X]` Call in a loop the wait() function, until receiving from the system
information that there are no more processes to be synchronized with the
parent one. Print a message that there are no more child processes. In this
loop do count child processes terminations and, at the very end of the
parent process, print a message with the number of just received child
processes exit codes.

### `[X]` The child process algorithm

1. `[X]` Print process identifier of the parent process

2. `[X]` Sleep for 10 seconds

3. `[X]` Print a message about execution completion

At this stage check whether your program works correctly. Only if it works
correctly, continue with the tasks from the next section.

*Child processes should not create more child processes*


## 3. `[X]` Some modifications related to signal handlers

### `[X]` In the parent process

1. `[X]` Force ignoring of all signals with the signal() (or sigaction()) but
after that at once restore the default handler for SIGCHLD signal

2. `[X]` Set your own keyboard interrupt signal handler (symbol of this interrupt:
SIGINT)

3. `[X]` The handler should print out info about receiving the keyboard interrupt
and set some mark (global variable) which will notify about the fact of
keyboard interrupt occurrence

4. `[X]` Modify the main program in the following way: between the two consecutive
creations of new processes check the mark which may be set by the keyboard
interrupt handler. If the mark is set the parent process should signal all
just created processes with the SIGTERM and, instead of printing the message
about creation, print out a message about interrupt of the creation process.
After that, the process should continue with wait()'s loop as before.

5. `[X]` At the very end of the main process, the old service handlers of all
signals should be restored.

### `[X]` In the child process

1. `[X]` Set to ignore handling of the keyboard interrupt signal

2. `[X]` Set your own handler of the SIGTERM signal, which will only print a
message of the termination of this process.


## `[X]` Additional remarks

1. `[X]` Two versions of the program are expected to be implemented, without and
with signals (without changes from the section 3 and with them). The code
should be in one source file and the version of compilation should be driven
by the definition or by the lack of definition of the WITH_SIGNALS
pre-processor symbol.

2. `[X]` Each printed message should start with the process identifier in the form
```
child[PID] and in case of the parent process, parent[PID], e.g.:

parent[123]: sending SIGTERM signal 

child[125]:  received SIGTERM signal, terminating
```

## Hints

1. look at the following manual pages: fork(), wait(), signal(),
sigaction(), kill(), getpid(), getppid(), sleep()

2. look at the content of the <signal.h> file

3. use for complex signal handling settings the symbol NSIG defined in 
standard include files

4. use stty command to get to know which keypress generates an interrupt
from the keyboard (SIGINT) under your current shell configuration
