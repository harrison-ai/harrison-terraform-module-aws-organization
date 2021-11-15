variable "account_id" {
  type        = string
  description = "12 digit Account Id of the designated Audit account"
}

variable "cloudtrail_name" {
  type        = string
  description = "Name of the Org CloudTrail"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket that will store CloudTrail logs"
}

variable "transition_to_ia_days" {
  type        = number
  default     = 90
  description = "Number of days before CloudTrail logs are transitioned from STANDARD to IA"
}

variable "expiration_days" {
  type        = number
  default     = 2555
  description = "Number of days before CloudTrail logs are expired (delete)"
}

variable "repo" {
  type        = string
  description = "Name of this current repository"
}

variable "project" {
  type        = string
  description = "Designated project name"
}
