#include <stdio.h> 
#include <stdlib.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <unistd.h> // Linux!
#include <time.h>
#include <assert.h>

const int NUM_CHILD = 5;
const int CHILD_CREATION_DELAY = 1; // seconds
const int CHILD_PROCESS_DURATION = 10; // seconds
const int CHILD_MAX_RESULT = 20; // seconds

// #define WITH_SIGNALS 1

#ifdef WITH_SIGNALS
    int is_key_int = false;

    // Handler of the parent keyboard interrupt. Sets the flag "is_key_int"
    void parent_keyint_handler(int signum){
        printf("parent[%d]: Keyboard interrupt!\n", getpid());
        is_key_int = true;
    }

    void child_term_handler(int signum){
        printf("child[%d]: Received termination signal\n", getpid());
        // exit(1); // ? Should exit
    }

    struct sigaction act_ignore;
    struct sigaction act_default;
    struct sigaction act_key_int;
    struct sigaction child_act_term;

    // Force ignoring of all signals except SIGINT and SIGCHLD
    int modify_signal_handlers(){
        act_ignore.sa_handler = SIG_IGN;
        act_default.sa_handler = SIG_DFL;
        act_key_int.sa_handler = parent_keyint_handler;
        child_act_term.sa_handler = child_term_handler;
        // Ignore all signals
        for (int i = 1; i < NSIG; i++) {
            if (i == SIGINT) { // In the case of SIGINT use the custom handler
                assert(sigaction(i, &act_key_int, NULL) == 0);
            }
            else if (i == SIGCHLD) { // Default handler of SIGCHLD
                assert(sigaction(SIGCHLD, &act_default, NULL) == 0);
            }
            else { // Force ignore (SIGSTOP won't be modified but we try)
                sigaction(i, &act_ignore, NULL);
            }
        }
        
    }

    // The old service handlers of all signals should be restored
    int restore_signal_handlers(){
        // Force restore all signals
        for (int i = 1; i < NSIG; i++) {
            sigaction(i, &act_default, NULL);
        }
    }
#endif

// The child process algorithm
int child_process(){
    // Print the process identifier of the parent process
    printf("child[%d]: "
        "My parent process has id=%d.\n",
        getpid(), getppid()
        );
    // Sleep for 10 seconds
    sleep(CHILD_PROCESS_DURATION); 
    srand ( time(NULL) );
    // Print a message about executuion completion
    int execution_result = rand() % CHILD_MAX_RESULT;
    printf("child[%d]: "
        "Execution completed with result %d\n",
        getpid(), execution_result
        );
    return execution_result;
}

// Parent process
int parent_process_wait(const int pid){
    pid_t cpid;
    int ecode;
    int num_children = 0;
    // Wait until there are no more processes to be synchronized with the 
    // parent one
    while ((cpid = wait( &ecode )) > 0 ) { // Wait until a children finishes
                                           // or there are no more children  
        num_children++;
        printf("parent[%d]: "
            "Child process %d finished with exit code %d.\n",
            pid, cpid, ecode % 0xFF
            );
    }
    // Print a message that there are no more child processes.
    printf("parent[%d]: "
        "All children (%d) have completed their execution\n",
        pid, num_children
        );
    // At the very end of the main process, restore signal handlers
    #ifdef WITH_SIGNALS
        restore_signal_handlers();
    #endif
    return 0;
}

#ifdef WITH_SIGNALS
    int sigterm_children(const pid_t pid, int children[], int num_children){
        num_children--;
        // Signal all just created process with SIGTERM
        for (int child=0; child<num_children; child++) {
            kill(children[child], SIGTERM);
        }
        // Print a message about interrupt of the creation process
        printf("parent[%d]: "
            "Child creation process interrupted. All created children "
            "(%d) have been signaled for termination\n",
            pid, num_children
            );
        // Continue with wait loop
        return parent_process_wait(pid);
    }
#endif

// The main (parent) process algorithm
int main() {
    pid_t pid;
    pid = getpid();
    int num_children, id, wait_output;
    int children[NUM_CHILD];

    // Signals management
    #ifdef WITH_SIGNALS
        modify_signal_handlers();
    #endif

    for (num_children=1; num_children <= NUM_CHILD; num_children++) {
        #ifdef WITH_SIGNALS
            if (is_key_int) {
                return sigterm_children(pid, children, num_children);
            }
        #endif
        id = fork();
        if( id>0 ) { // parent process
            printf("parent[%d]: "
                "Created child process number %d of %d with id=%d.\n",
                pid, num_children, NUM_CHILD, id
                );
            // One second delays between consecutive fork calls
            sleep(CHILD_CREATION_DELAY);
        }
        else if( id==0 ) { // child process
            #ifdef WITH_SIGNALS
                // Ignore handling of the keyboard interrupt signal
                assert(sigaction(SIGINT, &act_ignore, NULL) == 0);
                // Set own handler of SIGTERM signal
                assert(sigaction(SIGTERM, &child_act_term, NULL) == 0);
            #endif
            children[num_children-1] = id; // Save the children created
            exit( child_process() ); // exit kills the process
        }
        else { // fork creation error
            fprintf( stderr, "parent[%d] Error: fork() failed.\n", pid );
            // Send SIGTERM signal to children
            for (int child=0; child<num_children; child++) {
                kill(children[child], SIGTERM);
            }
            exit(1);
        }
    }
    // Print a message about creation of all child process
    printf("parent[%d]: "
        "All children (%d) have been created\n",
        pid, NUM_CHILD
        );
    return parent_process_wait(pid);
}