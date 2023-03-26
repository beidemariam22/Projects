# The Dining Philosophers

The Dining Philosophers problem is a classic multi-process synchronization
problem. The problem consists of five philosophers sitting at a table who do
nothing but think and eat. Between each philosopher, there is a single fork
In order to eat, a philosopher must have both forks. A problem can arise if
each philosopher grabs the fork on the right, then waits for the fork on the
left. In this case a deadlock has occurred, and all philosophers will starve.
Also, the philosophers should be fair. Each philosopher should be able to eat
as much as the rest.


Implement in the C language the dining philosophers program. For
synchronization implement and use the two following functions:

```c
void grab_forks( int left_fork_id );

void put_away_forks( int left_fork_id );
```

where parameters are integers identifying semaphores associated with forks.
grab_forks() and put_away_forks() should use IPC semaphores (man semget, man
semop) to make atomic changes on two semaphores at the same time. Print on the
standard output verbose messages from philosophers.

## Results with five philosophers

As it can be observed in the following code snippet. The philosphers leave and take forks in sequence. After the first two "TAKES" (Which is the maximum number of philosophers eating out of five), each following "TAKES" is preceeded by "LEAVES". Which means that the semaphores are working.

```
esdandreu@Kenobi:~/projects/the-dining-philosophers$ gcc main.c -o main; ./main
Memory attached at shmid 262152
shmat suceeed
Semaphores created at sem_set_id 262152
semctl suceed
Philosopher 0 entered the room
Philosopher 1 entered the room
Philosopher 2 entered the room
Philosopher 3 entered the room
Philosopher 4 entered the room
Philosopher 0 wants to take the forks
Test 0: CAN take forks. Phil4 is T and Phil1 is T
0 TAKES FORKS
Philosopher 2 wants to take the forks
Test 2: CAN take forks. Phil1 is T and Phil3 is T
2 TAKES FORKS
Philosopher 1 wants to take the forks
Test 1: CANNOT take forks. Phil0 is E and Phil2 is E
Philosopher 3 wants to take the forks
Test 3: CANNOT take forks. Phil2 is E and Phil4 is T
Philosopher 4 wants to take the forks
Test 4: CANNOT take forks. Phil3 is H and Phil0 is E
0 LEAVES FORKS
Test 4: CAN take forks. Phil3 is H and Phil0 is T
Test 1: CANNOT take forks. Phil0 is T and Phil2 is E
4 TAKES FORKS
2 LEAVES FORKS
Test 1: CAN take forks. Phil0 is T and Phil2 is T
Test 3: CANNOT take forks. Phil2 is T and Phil4 is E
1 TAKES FORKS
Philosopher 0 wants to take the forks
Test 0: CANNOT take forks. Phil4 is E and Phil1 is E
4 LEAVES FORKS
Test 3: CAN take forks. Phil2 is T and Phil4 is T
Test 0: CANNOT take forks. Phil4 is T and Phil1 is E
3 TAKES FORKS
Philosopher 2 wants to take the forks
Test 2: CANNOT take forks. Phil1 is E and Phil3 is E
1 LEAVES FORKS
Test 0: CAN take forks. Phil4 is T and Phil1 is T
Test 2: CANNOT take forks. Phil1 is T and Phil3 is E
0 TAKES FORKS
Philosopher 4 wants to take the forks
Test 4: CANNOT take forks. Phil3 is E and Phil0 is E
3 LEAVES FORKS
Test 2: CAN take forks. Phil1 is T and Phil3 is T
Test 4: CANNOT take forks. Phil3 is T and Phil0 is E
2 TAKES FORKS
Philosopher 1 wants to take the forks
Test 1: CANNOT take forks. Phil0 is E and Phil2 is E
0 LEAVES FORKS
Test 4: CAN take forks. Phil3 is T and Phil0 is T
Test 1: CANNOT take forks. Phil0 is T and Phil2 is E
4 TAKES FORKS
2 LEAVES FORKS
Test 1: CAN take forks. Phil0 is T and Phil2 is T
Test 3: CANNOT take forks. Phil2 is T and Phil4 is E
Philosopher 3 wants to take the forks
1 TAKES FORKS
Test 3: CANNOT take forks. Phil2 is T and Phil4 is E
Philosopher 0 wants to take the forks
Test 0: CANNOT take forks. Phil4 is E and Phil1 is E
4 LEAVES FORKS
Test 3: CAN take forks. Phil2 is T and Phil4 is T
Test 0: CANNOT take forks. Phil4 is T and Phil1 is E
3 TAKES FORKS
^C
```