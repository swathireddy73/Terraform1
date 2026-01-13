output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_instance_ids" {
  value = aws_instance.sp_ec2[*].id
}

output "s3_buckets" {
  value = keys(aws_s3_bucket.sp_bucket)
}

