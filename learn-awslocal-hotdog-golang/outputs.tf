# Create the Lambda function
output "dogCatcher" {
  description = "Name of the Lambda function in dogCatcher"

  value = aws_lambda_function.dog_catcher_lambda.function_name
}

output "dogProcessor" {
  description = "Name of the Lambda function in dogProcessor"

  value = aws_lambda_function.dog_processor_lambda.function_name
}

output "hotDogDespatcher" {
  description = "Name of the Lambda function in hotDogDespatcher"

  value = aws_lambda_function.hot_dog_despatcher_lambda.function_name
}
