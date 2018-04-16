#include <stdio.h>
#include <pthread.h>
int answer=42;
void *hello()
{
	printf("The answer is again %d\n",answer);
	pthread_exit(NULL);
}
int main () {
	pthread_t thread;
	pthread_create(&thread, NULL, hello, NULL);
	pthread_create(&thread, NULL, hello, NULL);
	pthread_exit(0);
}
