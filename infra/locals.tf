locals {
  // Create a range dynamically based on the length of the input list
  // Assuming you always want 5 items starting from 1
  lambda_functions_range =  range(2) 
}
