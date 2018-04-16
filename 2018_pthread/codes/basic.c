#include <stdio.h>
#include <pthread.h>
void *hello()
{
	printf("Hello World.\n");
	pthread_exit(NULL);
}
main () {
	pthread_t thread;
	pthread_create(&thread, NULL, hello, NULL);
	pthread_exit(0);
}
