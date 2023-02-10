data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_acl" "main" {
  bucket = var.s3_bucket_id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = var.grantee_type
      }

      permission = var.grant_permission
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
