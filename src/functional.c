#include "functional.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void for_each(void (*function)(void *), array_t list)
{
	if(function==NULL)
		return;

	for (int i = 0; i < list.len; ++i)
		function(list.data + i * list.elem_size);
}

array_t map(void (*function)(void *, void *),
			int new_list_element_size,
			void (*new_list_destructor)(void *),
			array_t list)
{
	array_t new_list;

	new_list.elem_size = new_list_element_size;
	new_list.len = list.len;
	new_list.destructor = new_list_destructor;
	new_list.data = malloc(new_list.len * new_list.elem_size);


	for (int i = 0; i < list.len; ++i) {
		function(new_list.data + i * new_list.elem_size, list.data +
														 i * list.elem_size);
	}

	for_each(list.destructor, list);
	free(list.data);

	return new_list;
}

array_t filter(boolean(*function)(void *), array_t list)
{
	array_t new_list;

	new_list.elem_size = list.elem_size;
	new_list.len = 0;
	new_list.destructor = list.destructor;
	new_list.data = malloc(list.len * list.elem_size);

	for (int i = 0; i < list.len; ++i)
		if (function(list.data + i * list.elem_size)) {
			memcpy(new_list.data + new_list.len * new_list.elem_size,
				   list.data + i * list.elem_size, new_list.elem_size);
			++new_list.len;
		}

	free(list.data);

	return new_list;
}

void *reduce(void (*function)(void *, void *), void *accumulator, array_t list)
{
	for (int i = 0; i < list.len; ++i)
		function(accumulator, list.data + i * list.elem_size);

	return accumulator;
}

void for_each_multiple(void(*function)(void **), int varg_count, ...)
{
	va_list args;
	va_start(args, varg_count);

	array_t *arrays = malloc(varg_count * sizeof(array_t));

	for (int i = 0; i < varg_count; ++i)
		arrays[i] = va_arg(args, array_t);

	int min_len = arrays[0].len;

	for (int i = 1; i < varg_count; ++i)
		if (arrays[i].len < min_len)
			min_len = arrays[i].len;

	for (int i = 0; i < min_len; ++i) {
		void *function_arguments[varg_count];

		for (int j = 0; j < varg_count; ++j)
			function_arguments[j] = arrays[j].data + i * arrays[j].elem_size;

		function(function_arguments);
	}

	free(arrays);

	va_end(args);
}

array_t map_multiple(void (*function)(void *, void **),
					 int new_list_elem_size,
					 void (*new_list_destructor)(void *),
					 int varg_count, ...)
{
	va_list args;
	va_start(args, varg_count);

	array_t *arrays = malloc(varg_count * sizeof(array_t));

	for (int i = 0; i < varg_count; ++i)
		arrays[i] = va_arg(args, array_t);

	int min_len = arrays[0].len;

	for (int i = 1; i < varg_count; ++i)
		if (arrays[i].len < min_len)
			min_len = arrays[i].len;

	array_t output;

	output.elem_size = new_list_elem_size;
	output.len = min_len;
	output.destructor = new_list_destructor;
	output.data = malloc(output.len * output.elem_size);

	for (int i = 0; i < min_len; ++i) {
		void *function_arguments[varg_count];

		for (int j = 0; j < varg_count; ++j)
			function_arguments[j] = arrays[j].data + i * arrays[j].elem_size;

		function(output.data + i * output.elem_size, function_arguments);
	}

	for (int i = 0; i < varg_count; ++i) {
		array_t array = arrays[i];
		for_each(array.destructor, array);
		free(array.data);
	}
	free(arrays);

	va_end(args);

	return output;
}

void *reduce_multiple(void(*function)(void *, void **), void *accumulator,
					  int varg_count, ...)
{
	va_list args;
	va_start(args, varg_count);

	array_t *arrays = malloc(varg_count * sizeof(array_t));

	for (int i = 0; i < varg_count; ++i)
		arrays[i] = va_arg(args, array_t);

	int min_len = arrays[0].len;

	for (int i = 1; i < varg_count; ++i)
		if (arrays[i].len < min_len)
			min_len = arrays[i].len;

	for (int i = 0; i < min_len; ++i) {
		void *function_arguments[varg_count];

		for (int j = 0; j < varg_count; ++j)
			function_arguments[j] = arrays[j].data + i * arrays[j].elem_size;

		function(accumulator, function_arguments);
	}

	va_end(args);

	return accumulator;
}
