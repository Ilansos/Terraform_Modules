resource "aws_iam_account_password_policy" "global_password_policy" {
  minimum_password_length           = 14
  require_uppercase_characters      = true
  require_lowercase_characters      = true
  require_numbers                   = true
  require_symbols                   = true
  allow_users_to_change_password    = true
  hard_expiry                       = false
  max_password_age                  = 90
  password_reuse_prevention         = 24
}

# This policy deny access to every resource unless an user sets an MFA device
# It will also allow each user to manage their own credentials.
resource "aws_iam_policy" "enforce_mfa_policy" {
  name        = "EnforceMFA"
  path        = "/"
  description = "Policy to enforce MFA"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowViewAccountInfo"
        Effect   = "Allow"
        Action   = [
          "iam:GetAccountPasswordPolicy",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowManageOwnPasswords"
        Effect   = "Allow"
        Action   = [
          "iam:ChangePassword",
          "iam:GetUser"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "AllowManageOwnAccessKeys"
        Effect   = "Allow"
        Action   = [
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey",
          "iam:GetAccessKeyLastUsed"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "AllowManageOwnSigningCertificates"
        Effect   = "Allow"
        Action   = [
          "iam:DeleteSigningCertificate",
          "iam:ListSigningCertificates",
          "iam:UpdateSigningCertificate",
          "iam:UploadSigningCertificate"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "AllowManageOwnSSHPublicKeys"
        Effect   = "Allow"
        Action   = [
          "iam:DeleteSSHPublicKey",
          "iam:GetSSHPublicKey",
          "iam:ListSSHPublicKeys",
          "iam:UpdateSSHPublicKey",
          "iam:UploadSSHPublicKey"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "AllowManageOwnGitCredentials"
        Effect   = "Allow"
        Action   = [
          "iam:CreateServiceSpecificCredential",
          "iam:DeleteServiceSpecificCredential",
          "iam:ListServiceSpecificCredentials",
          "iam:ResetServiceSpecificCredential",
          "iam:UpdateServiceSpecificCredential"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "AllowManageOwnVirtualMFADevice"
        Effect   = "Allow"
        Action   = [
          "iam:CreateVirtualMFADevice"
        ]
        Resource = "arn:aws:iam::*:mfa/*"
      },
      {
        Sid      = "AllowManageOwnUserMFA"
        Effect   = "Allow"
        Action   = [
          "iam:DeactivateMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid      = "DenyAllExceptListedIfNoMFA"
        Effect   = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:GetMFADevice",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}