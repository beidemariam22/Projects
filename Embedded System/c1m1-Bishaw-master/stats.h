/******************************************************************************
 * Copyright (C) 2017 by Alex Fosdick - University of Colorado
 *
 * Redistribution, modification or use of this software in source or binary
 * forms is permitted as long as the files maintain this copyright. Users are 
 * permitted to modify this and use it to learn about the field of embedded
 * software. Alex Fosdick and the University of Colorado are not liable for any
 * misuse of this material. 
 *
 *****************************************************************************/
/**
 * @file stats.h
 * @brief Statistics
 *
 * You are to write a couple of functions that can analyze an array of unsigned
 * char data items and report analytics on the maximum, minimum, mean, and
 * median of the data set. In addition, you will need to reorder this data set
 * from large to small. All statistics should be rounded down to the nearest
 * integer. After analysis and sorting is done, you will need to print that
 * data to the screen in nicely formatted presentation. You will need to submit
 * a version controlled repository of these 3 files.
 *
 * @author Andreu Gimenez Bolinches
 * @date 21/03/2021
 *
 */
#ifndef __STATS_H__
#define __STATS_H__

/**
 * @brief A function that prints the statistics of an array including minimum,
 * maximum, mean, and median.
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 */
void print_statistics(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, prints the array to the screen.
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 */
void print_array(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, returns the median value.
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 *
 * @return A float result of the median
 */
float find_median(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, returns the mean
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 *
 * @return An unsigned char result of the mean
 */
unsigned char find_mean(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, returns the maximum.
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 *
 * @return An unsigned char result of the maximum
 */
unsigned char find_maximum(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, returns the minimum.
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 *
 * @return An unsigned char result of the minimum
 */
unsigned char find_minimum(unsigned char *array, unsigned int size);

/**
 * @brief Given an array of data and a length, sorts the array from largest to
 * smallest. (The zeroth Element should be the largest value, and the last
 * element (n-1) should be the smallest value. )
 *
 * @param array A unsigned char pointer to an n-element data array
 * @param size An unsigned integer as the size of the array
 *
 * @return The array pointer, same as the input
 */
unsigned char sort_array(unsigned char *array, unsigned int size);

#endif /* __STATS_H__ */
