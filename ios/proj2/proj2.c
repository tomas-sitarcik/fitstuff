#include <stdlib.h>
#include <stdio.h>
#include <semaphore.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include <sys/mman.h>
#include <stdarg.h>
#include <sys/wait.h>
#include <errno.h>
#include <time.h>

#define customer_count args[0]
#define clerk_count args[1]
#define customer_wait args[2]
#define clerk_wait args[3]
#define opening_time args[4]

#define mail_sem &services->mail
#define parcel_sem &services->parcels
#define monetary_sem &services->monetary

#define output_sem &synchro->output

typedef struct {
    sem_t mail;
    sem_t parcels;
    sem_t monetary;
} services_t;

typedef struct {
    sem_t output;
    bool open;
    int line_number;
} sync_t;

services_t * services;
sync_t * synchro;

void my_exit(char * string) {
    fprintf(stderr, string);
    munmap(services, sizeof(services_t));
    munmap(synchro, sizeof(sync_t));
    exit(1);
}

// checks if a conversion with atoi would work
int is_int(char * string) {
    if (strcmp(string, "0")) {
        return true;
    } else {
        int value = atoi(string);
        if (value == 0) {
            return false;
        } else return true;
    }
}

void msleep(int time) {
    usleep(time * 1000);
}

bool is_post_open() {
    sem_wait(output_sem);
    bool state = synchro->open;
    sem_post(output_sem);
    return state;
}

sem_t * get_sem_by_index(int index) {
    if (index == 0) {
        return mail_sem;
    } else if (index == 1) {
        return parcel_sem;
    } else if (index == 2) {
        return monetary_sem;
    }
    return NULL;
}

void my_print(const char * format, ...) {
    sem_wait(output_sem);
    va_list args;
    va_start(args, format);
    FILE * file_pt = fopen("proj2.out", "a");
    fprintf(file_pt, "%d: ", synchro->line_number);
    synchro->line_number++;
    vfprintf(file_pt, format, args);
    fflush(file_pt);
    fclose(file_pt);
    sem_post(output_sem);
}

void init_semaphores() {
    synchro = mmap(synchro, sizeof(sync_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    services = mmap(services, sizeof(services_t), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);
    //file_pt = mmap(file_pt, sizeof(FILE), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, 0);

    if (synchro == MAP_FAILED || services == MAP_FAILED) {
        my_exit("Mapping of shared memory unsuccesful, aborting");
    }

    sem_init(mail_sem, 1, 1);
    sem_init(parcel_sem, 1, 1);
    sem_init(monetary_sem, 1, 1);
    sem_init(output_sem, 1, 1);
    synchro->open=1;
    synchro->line_number=1;
}

bool is_queue_empty() {
    sem_t * sem1 = mail_sem;
    sem_t * sem2 = parcel_sem;
    sem_t * sem3 = monetary_sem;
    int val1 = 0;
    int val2 = 0;
    int val3 = 0;
    sem_getvalue(sem1, &val1);
    sem_getvalue(sem2, &val2);
    sem_getvalue(sem3, &val3);

    //fprintf(stderr, "sem values are : %d %d %d\n", val1, val2, val3);

    if (val1 == 1 && val2 == 1 && val3 == 1) {
        return true;
    }

    return false;
}

int actual_rand() {
    FILE * fp = fopen("/dev/random", "r");
    return fgetc(fp);
}

void clerk(int id, int wait) {
    my_print("U %d: started\n", id);
    while (is_post_open() || !is_queue_empty()){
        srand(time(NULL)*100000);
        int index = actual_rand() % 3;
        sem_t * choice = get_sem_by_index(index);
        int val = 0;
        sem_getvalue(choice, &val);
        if (val == 0) {
            sem_post(choice);
            my_print("U %d: serving a service of type %d\n", id, index + 1);
            msleep(actual_rand() % 10);
            my_print("U %d: service finished\n", id);
        } else {
            my_print("U %d: taking break\n", id);
            msleep(actual_rand() % wait);
            my_print("U %d: break finished\n", id);
        }
    }

    my_print("U %d: going home\n", id);
    exit(0); 
}

void customer(int id, int wait) {
    my_print("Z %d: started\n", id);
    
    msleep(actual_rand() % wait);
    srand((unsigned)time(NULL)*100000);
    int index = actual_rand() % 3;
    my_print("Z %d: entering office for a service %d\n", id, index + 1);
    sem_t * choice = get_sem_by_index(index);
    
    while (is_post_open()) {
        sem_trywait(choice);
        if(errno != EAGAIN) {
            my_print("Z %d: called by office worker\n", id);
            msleep(actual_rand() % 10);
        } else {
        }
    }
    

    my_print("Z %d: going home\n", id);
    exit(0); 
}

int main(int argc, char *argv[]) {
    
    int init = 0;
    if (init == 0) {
        init_semaphores();
        init = 1;
        FILE * file = fopen("proj2.out", "w");
        fclose(file);
    }
    
    int args[5];

    for (int i = 1; i < argc; i++) {
                if (is_int(argv[i])) {
                    args[i-1] = atoi(argv[i]);
                } else my_exit("Incorrect argument format, aborting.\n");
            }
    // value bounds checks
    if (customer_wait < 0 || customer_wait > 10000) my_exit("Incorrect argument value, aborting.\n");
    if (clerk_wait < 0 || clerk_wait > 100) my_exit("Incorrect argument value, aborting.\n");
    if (opening_time < 0 || opening_time > 10000) my_exit("Incorrect argument value, aborting.\n");

    for (int i = 0; i < customer_count; i++) {
        pid_t id = fork();
        if (id == 0) {
            if (i < customer_count) {
                customer(i+1, customer_wait);
            }
        }
    }

    for (int i = 0; i < clerk_count; i++) {
        pid_t id = fork();
        if (id == 0) {
            if (i < customer_count) {
                clerk(i+1, clerk_wait);
            }
        }
    }

    
    if (argc != 6) {
        my_exit("Incorrect amount of arguments, aborting.\n");
    } else {
        // convert arguments to int
        for (int i = 1; i < argc; i++) {
            if (is_int(argv[i])) {
                args[i-1] = atoi(argv[i]);
            } else my_exit("Incorrect argument format, aborting.\n");
        }
        // value bounds checks
        if (customer_wait < 0 || customer_wait > 10000) my_exit("Incorrect argument value, aborting.\n");
        if (clerk_wait < 0 || clerk_wait > 100) my_exit("Incorrect argument value, aborting.\n");
        if (opening_time < 0 || opening_time > 10000) my_exit("Incorrect argument value, aborting.\n");
    }
    
    msleep(actual_rand() % (opening_time / 2) + (opening_time / 2));
    my_print("closing\n");


    sem_wait(output_sem);
    synchro->open = false;
    sem_post(output_sem);


    while (wait(NULL) > 0);
    munmap(services, sizeof(services_t));
    munmap(synchro, sizeof(sync_t));
    return 0;
}

