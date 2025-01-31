# This variable will be populated by the policies module
variable "enforce_mfa_policy_arn" {
  type = string
  description = "ARN of the IAM Policy that enforce users to add MFA device or they wont have access to any resource"
}

# This variable is to specify all the ARNs of each policy we want to give the aws admin group
variable "admin_policies_arn" {
  type = list(string)
  default = [   "arn:aws:iam::aws:policy/AdministratorAccess", 
                "arn:aws:iam::aws:policy/AWSBillingConductorFullAccess",
                "arn:aws:iam::aws:policy/AWSBudgetsActionsWithAWSResourceControlAccess",
                "arn:aws:iam::aws:policy/IAMFullAccess"
            ]
}