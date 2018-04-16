#include<stdio.h>
#include<pthread.h>

void *answer(void *value)
{
	long number = (long ) value;
	printf("The answer is %ld.\n", number);
	pthread_exit(NULL);
}
main () {
long value = 42;
pthread_t thread;
pthread_create(&thread, NULL, answer, (void *) value);
pthread_exit(0);
}
