#declare github_access_token in secrets.auto.tfvars
#assign the  "ghp_<deleted>" to github_access_token in secrets.auto.tfvars	

variable "github_access_token" {
  type        = string
  #description = "github token to connect github repo"
	#default = "${TF_VARS_github_access_token}"
}

variable "repository" {
  type        = string
  description = "github repo url"
  #default     = "git@github.com:halilagin/sculture_aws_cognito.git"
	default = "https://github.com/halilagin/sculture_aws_cognito.git"
}

variable "app_name" {
  type        = string
  description = "AWS Amplify App Name"
  default     = "hello-world2"
}

variable "branch_name" {
  type        = string
  description = "AWS Amplify App Repo Branch Name"
  default     = "main"
}

variable "domain_name" {
  type        = string
  default     = "amplify002.peralabs.co.uk" #change this to your custom domain
  description = "AWS Amplify Domain Name"
}
