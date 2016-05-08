#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void print_num(uint64_t n) {
	printf("%llu\n", n);
}

void print_rand() {
	printf("%d\n", rand());
}

int main() {
	pthread_t t1, t2, t3, t4;
	// pthread_create(&t1, NULL, &print_num, (uint64_t) 1);
	// pthread_create(&t2, NULL, &print_num, (uint64_t) 2);
	// pthread_create(&t3, NULL, &print_num, (uint64_t) 3);
	// pthread_create(&t4, NULL, &print_num, (uint64_t) 4);
	// pthread_create(&t1, NULL, &print_rand, NULL);
	// pthread_create(&t2, NULL, &print_rand, NULL);
	// pthread_create(&t3, NULL, &print_rand, NULL);
	// pthread_create(&t4, NULL, &print_rand, NULL);
	pthread_create(&t1, NULL, &rand, NULL);
	pthread_create(&t2, NULL, &rand, NULL);
	pthread_create(&t3, NULL, &rand, NULL);
	pthread_create(&t4, NULL, &rand, NULL);

	int r1, r2, r3, r4;
	// pthread_join(t1, NULL);
	// pthread_join(t2, NULL);
	// pthread_join(t3, NULL);
	// pthread_join(t4, NULL);
	pthread_join(t1, &r1);
	pthread_join(t2, &r2);
	pthread_join(t3, &r3);
	pthread_join(t4, &r4);

	printf("%d %d %d %d\n", r1, r2, r3, r4);

	return 0;
}
