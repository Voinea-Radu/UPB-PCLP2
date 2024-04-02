cmake_minimum_required(VERSION 3.27.8)
project(tema1 C)

set(CMAKE_C_STANDARD 11)

add_executable(tema1
        src/functional.c
        src/functional.h
        src/main.c
        src/tasks.c
        src/tasks.h
        src/tests.c
        src/tests.h
)
