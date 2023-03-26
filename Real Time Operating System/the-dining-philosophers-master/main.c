// Libraries
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <time.h>
// Constants
#define N 5
#define MAX_THINK_SECONDS 3
#define MAX_EAT_SECONDS 3
int shmid;
int sem_set_id;
// State options
#define THINKING 0
#define HUNGRY 1 
#define EATING 2
char state_names[3] = {'T', 'H', 'E'};
// Directions
#define LEFT ( phil_id + N - 1) % N
#define RIGHT ( phil_id + 1 ) % N 
// Shared memory
struct shm {
    int state[N]; 
} *shared_memory;
// Semaphores
union semun {
    int             val;    // Value for SETVAL
    struct semid_ds *buf;   // Buffer for IPC_STAT, IPC_SET
    unsigned short  *array; // Array for GETALL, SETALL
    struct seminfo  *__buf; // Buffer for IPC_INFO (Linux-specific)
};
int mutex = N;

// Initializations
int init_shared_memory() {
    // Create shared memory segment
    // * The name choice IPC_PRIVATE was perhaps unfortunate, IPC_NEW
    // * would more clearly show its function.
    shmid = shmget(IPC_PRIVATE, sizeof(*shared_memory), IPC_CREAT|0666);
    if (shmid < 0) {
        printf("Failed creation of shared memory\n");
        exit(1);
    }
    printf("Memory attached at shmid %d\n", shmid);

    // Attach shared memory to variable shared_memory
    shared_memory = (struct shm*) shmat(shmid, NULL, 0);
    if ( shared_memory == (void *) -1) {
        printf("Failed attachment of shared memory\n");
        exit(1);
    }
    printf("shmat suceeed\n");
    return shmid;
}

int init_semaphores(){
    // Create semaphore set
    sem_set_id = semget(IPC_PRIVATE, N+1, IPC_CREAT|0666);
    if (sem_set_id < 0) {
        printf("Failed creation of semaphores\n");
        exit(1);
    }
    printf("Semaphores created at sem_set_id %d\n", sem_set_id);

    // Initialize mutex semaphore to 1, the rest to 0
    union semun semaphores;
    unsigned short sem_values[N+1] = {0};
    sem_values[mutex] = 1;
    semaphores.array = sem_values;
    if (semctl(sem_set_id, 0/*ignored here*/, SETALL, semaphores) < 0) {
        printf("Failed initialization of semaphores\n");
        exit(1);
    }
    for (int i = 0; i<=N; i++){
        int semval = semctl(sem_set_id, i, GETVAL);
    }
    printf("semctl suceed\n");
    return sem_set_id;
}

// Functions
void think(int phil_id) { 
    // printf("Philosopher %d started thinking\n", phil_id);
    srand( time(NULL) );
    sleep(1 + (rand() % (MAX_THINK_SECONDS-1)));
    // printf("Philosopher %d finished thinking\n", phil_id);
}

void eat(int phil_id) { 
    // printf("Philosopher %d started eating\n", phil_id);
    srand( time(NULL) );
    sleep(1 + (rand() % (MAX_EAT_SECONDS-1)));
    // printf("Philosopher %d finished eating\n", phil_id);
}

void up(int sem_num){
    struct sembuf op;
    op.sem_num = sem_num;
    op.sem_op = 1; // Increase the value of the semaphore by 1, possibly waking
                   // up a process waiting on the semaphore. If several 
                   // processes are waiting on the semapthore, the first that 
                   // got blocked on it is wakened and continues its execution
    op.sem_flg = 0;
    if (semop(sem_set_id, &op, 1) < 0) {
        printf("Failed up operation on semaphore %d\n", sem_num);
    }
}

void down(int sem_num){
    struct sembuf op;
    op.sem_num = sem_num;
    op.sem_op = -1; // If value of the semaphore is greater or equal than 1, 
                    // decrease this value by one and return to the caller. 
                    // Otherwise block the calling process, until the value of 
                    // the semaphore becomes 1.
    op.sem_flg = 0;
    if (semop(sem_set_id, &op, 1) < 0) {
        printf("Failed down operation on semaphore %d\n", sem_num);
    }
}

void test(int phil_id) {
    int state_left = shared_memory->state[LEFT];
    int state_right = shared_memory->state[RIGHT];
    if (
        shared_memory->state[phil_id] == HUNGRY 
        && state_left != EATING 
        && state_right != EATING
    ) {
        printf("Test %d: CAN take forks. Phil%d is %c and Phil%d is %c\n",
            phil_id, LEFT, state_names[state_left],
            RIGHT, state_names[state_right]);
        shared_memory->state[phil_id] = EATING;
        up(phil_id);
    }
    else {
        printf("Test %d: CANNOT take forks. Phil%d is %c and Phil%d is %c\n",
            phil_id, LEFT, state_names[state_left],
            RIGHT, state_names[state_right]);
    }
} 

void take_forks(int phil_id) {
    down(mutex);
    printf("Philosopher %d wants to take the forks\n", phil_id);
    shared_memory->state[phil_id] = HUNGRY;
    test(phil_id);
    up(mutex);
    down(phil_id);
    printf("%d TAKES FORKS\n", phil_id);
}

void put_forks(int phil_id) {
    down(mutex);
    shared_memory->state[phil_id] = THINKING;
    printf("%d LEAVES FORKS\n", phil_id);
    test(LEFT);
    test(RIGHT);
    up(mutex);
}

void philosopher(int phil_id) {
    printf("Philosopher %d entered the room\n", phil_id);
    while (true){
        think(phil_id);
        take_forks(phil_id);
        eat(phil_id);
        put_forks(phil_id);
    }
    printf("Philosopher %d left the room\n", phil_id);
}

// Main
int main () {
    init_shared_memory();
    init_semaphores();
    int id, num_phil ;

    for (num_phil = 0; num_phil<N; num_phil++) {
        id = fork();
        if (id == 0) { // Child process
            philosopher(num_phil);
            exit(0);
        }
        else if (id < 0) { // fork creation error
            printf("Fork creation error!\n");
            exit(1);
        }
    }
    pid_t cpid;
    int ecode;
    while ((cpid = wait( &ecode )) > 0) {
        printf("A philosopher finished! Something is wrong\n");
    }
    return 0;
}