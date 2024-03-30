#include "functional.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void for_each(void (*func)(void *), array_t list)
{
	(void)func;
	(void)list;
}

array_t map(void (*func)(void *, void *),
			int new_list_elem_size,
			void (*new_list_destructor)(void *),
			array_t list)
{	(void)func;
	(void)new_list_elem_size;
	(void)new_list_destructor;
	(void)list;
	return (array_t){0};
}

array_t filter(boolean(*func)(void *), array_t list)
{
	(void)func;
	(void)list;
	return (array_t){0};
}

void *reduce(void (*func)(void *, void *), void *acc, array_t list)
{
	(void)func;
	(void)acc;
	(void)list;
	return NULL;
}

void for_each_multiple(void(*func)(void **), int varg_c, ...)
{
	(void)func;
	(void)varg_c;
}

array_t map_multiple(void (*func)(void *, void **),
					 int new_list_elem_size,
					 void (*new_list_destructor)(void *),
					 int varg_c, ...)
{
	(void)func;
	(void)new_list_elem_size;
	(void)new_list_destructor;
	(void)varg_c;
	return (array_t){0};
}

void *reduce_multiple(void(*func)(void *, void **), void *acc, int varg_c, ...)
{
	(void)func;
	(void)acc;
	(void)varg_c;
	return NULL;
}
