output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.tp2_bucket.bucket
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.tp2_instance.id
}