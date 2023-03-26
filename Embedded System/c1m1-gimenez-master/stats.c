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



#include <stdio.h>
#include "stats.h"

/* Size of the Data Set */
#define SIZE (40)

void main() {

  unsigned char test[SIZE] = { 34, 201, 190, 154,   8, 194,   2,   6,
                              114, 88,   45,  76, 123,  87,  25,  23,
                              200, 122, 150, 90,   92,  87, 177, 244,
                              201,   6,  12,  60,   8,   2,   5,  67,
                                7,  87, 250, 230,  99,   3, 100,  90};

  print_array(test, SIZE);
  print_statistics(test, SIZE);
  print_array(test, SIZE);
}

void print_array(unsigned char *array, unsigned int size) {
  printf("Array:\n");
  for(int i=0 ; i<size ; i++) {
      printf("[%d] : %d\n",i,array[i]);
  }
}

unsigned char sort_array(unsigned char *array, unsigned int size){
  int i=0 , j=0 , temp=0;
  for(i=0 ; i<size ; i++)
  {
      for(j=i+1 ; j<size ; j++)
      {
          if(array[j] > array[i])
          {
              temp        = array[i];
              array[i]    = array[j];
              array[j]  = temp;
          }
      }
  }
}

float find_median(unsigned char *array, unsigned int size) {
  sort_array(array, size);
  float median = 0;
  // if number of elements are even
  if(size%2 == 0){
    median += array[(size-1)/2];
    median += array[size/2];
    median /= 2.0;
  // if number of elements are odd
  } else {
    median += array[size/2];
  }
  return median;
}

unsigned char find_mean(unsigned char *array, unsigned int size){
  unsigned int sum = array[0];
  for (int i = 1; i < size; ++i) {
      sum += array[i];
  }
  return (char) (sum / size);
}

unsigned char find_maximum(unsigned char *array, unsigned int size){
  unsigned char max = array[0];
  for (int i = 1; i < size; ++i) {
    if (array[i] > max) max = array[i];
  }
  return max;
}

unsigned char find_minimum(unsigned char *array, unsigned int size){
  unsigned char min = array[0];
  for (int i = 1; i < size; ++i) {
    if (array[i] < min) min = array[i];
  }
  return min;
}

void print_statistics(unsigned char *array, unsigned int size) {
  unsigned char mean;
  float median;
  median = find_median(array, size);
  mean = find_mean(array, size);
  printf("Statistics:\n");
  printf("mean: %d\n", mean);
  printf("median: %f\n", median);
  // The array has been already sorted, make it fast
  printf("maximum: %d\n", array[0]);
  printf("minimum: %d\n", array[size-1]);
}