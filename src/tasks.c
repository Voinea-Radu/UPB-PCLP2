#include "functional.h"
#include "tasks.h"
#include "tests.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void reverse_helper(array_t *accumulator, void *element)
{
	memmove((char *)accumulator->data + accumulator->elem_size,
			accumulator->data,
			accumulator->len * accumulator->elem_size);
	memcpy(accumulator->data, element, accumulator->elem_size);
	accumulator->len++;
}

array_t reverse(array_t list)
{
	array_t output;

	output.elem_size = list.elem_size;
	output.len = 0;
	output.destructor = list.destructor;
	output.data = malloc(list.len * list.elem_size);

	reduce((void (*)(void *, void *))reverse_helper, &output, list);

	return output;
}

void create_number(number_t *number, int **parts)
{
	number->integer_part = *parts[0];
	number->fractional_part = *parts[1];
	number->string = malloc(100);
	sprintf(number->string, "%d.%d", number->integer_part,
			number->fractional_part);
}

void number_destructor(number_t *number)
{
	free(number->string);
}

array_t create_number_array(array_t integer_part, array_t fractional_part)
{
	array_t output = map_multiple((void (*)(void *, void **))create_number,
								  sizeof(number_t),
								  (void (*)(void *))number_destructor, 2,
								  integer_part, fractional_part);

	return output;
}

boolean is_passing_student(student_t *student)
{
	return student->grade >= 5.0;
}

array_t get_passing_students_names(array_t list)
{
	return filter((boolean (*)(void *))is_passing_student, list);
}

void sum_helper(int *accumulator, const int *element)
{
	*accumulator += *element;
}

void sum_array(array_t *accumulator, array_t *element)
{
	int sum = 0;
	reduce((void (*)(void *, void *))sum_helper, &sum, *element);

	((int *)accumulator->data)[accumulator->len++] = sum;
}

void compare_ints(boolean *output, int **elements)
{
	int a = *elements[0];
	int b = *elements[1];

	*output = a >= b;
}

array_t check_bigger_sum(array_t list_list, array_t int_list)
{
	array_t accumulator_array;

	accumulator_array.elem_size = sizeof(int);
	accumulator_array.len = 0;
	accumulator_array.data = malloc(list_list.len *
									accumulator_array.elem_size);

	reduce((void (*)(void *, void *))sum_array, &accumulator_array, list_list);

	array_t output = map_multiple((void (*)(void *, void **))compare_ints,
								  sizeof(boolean), NULL, 2, accumulator_array,
								  int_list);

	return output;
}

void set_null(void *element)
{
	*(void **)element = NULL;
}

void even_helper_1(array_t *accumulator, void *element)
{
	if (accumulator->len % 2 == 0) {
		memcpy((char *)accumulator->data + accumulator->len *
										   accumulator->elem_size, element,
										   accumulator->elem_size);
	}

	accumulator->len++;
}

void even_helper_2(array_t *accumulator, void *element)
{
	if (*(void **)element) {
		memcpy((char *)accumulator->data + accumulator->len *
										   accumulator->elem_size, element,
										   accumulator->elem_size);
		accumulator->len++;
	}
}

array_t get_even_indexed_strings(array_t list)
{
	array_t tmp;
	array_t output;

	tmp.elem_size = list.elem_size;
	tmp.len = 0;
	tmp.destructor = list.destructor;
	tmp.data = calloc(list.len, list.elem_size);

	output.elem_size = list.elem_size;
	output.len = 0;
	output.destructor = list.destructor;
	output.data = calloc(list.len, list.elem_size);

	for_each(set_null, tmp);
	for_each(set_null, output);

	reduce((void (*)(void *, void *))even_helper_1, &tmp, list);
	reduce((void (*)(void *, void *))even_helper_2, &output, tmp);

	return output;
}

void set_line(void *pair, __attribute__((unused)) array_t *element)
{
	array_t *line = ((array_t **)pair)[0];
	array_t *column = ((array_t **)pair)[1];

	((int *)line->data)[line->len] = line->len + column->len;
	line->len++;
}

void free_line(array_t *line)
{
	free(line->data);
}

void set_column(array_t *column, array_t *element)
{
	// Prepare for next iteration
	array_t *_temp = element + 1;
	_temp->len = element->len;

	array_t line;
	line.elem_size = sizeof(int);
	line.data = malloc(_temp->len * sizeof(int));
	line.len = 0;
	line.destructor = (void (*)(void *))free_line;

	array_t **arg = malloc(2 * sizeof(array_t));
	arg[0] = &line;
	arg[1] = column;

	reduce((void (*)(void *, void *))set_line, arg, *element);

	((array_t *)column->data)[column->len] = line;
	column->len++;
}

void add_one_array(int *element)
{
	(*element)++;
}

void add_one_matrix(array_t *matrix)
{
	for_each((void (*)(void *))add_one_array, *matrix);
}

array_t generate_square_matrix(int n)
{
	array_t _temp_array;

	_temp_array.elem_size = sizeof(array_t);
	_temp_array.len = n;
	_temp_array.data = malloc((n + 1) * sizeof(array_t));

	array_t *_temp = ((array_t *)_temp_array.data);
	_temp->len = n;

	array_t output;
	output.elem_size = sizeof(array_t);
	output.len = 0;
	output.data = malloc(n * sizeof(array_t));
	output.destructor = (void (*)(void *))free_line;

	reduce((void (*)(void *, void *))set_column, &output, _temp_array);

	for_each((void (*)(void *))add_one_matrix, output);

	return output;
}
