# 作業記録

## 初期化

[チュートリアル](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)を参考にしつつ。

まずはmain.tfを作成

次にtfstateの保存場所としてS3つくった。

CLIコマンドで<https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-services-s3-commands.html>

```bash
> aws s3 ls dev.ksanchu/terraform/backend
                           PRE backend/
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform >1 ?5
>
```

terraform initをする

```bash
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform >1 ?5
> terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 4.16"...
- Installing hashicorp/aws v4.50.0...
- Installed hashicorp/aws v4.50.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform >1 ?7
>
```

### EC2サーバーを立ててみる

```terraform
resource "aws_instance" "sample" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

```

```bash
terraform apply

...

aws_instance.sample: Creation complete after 45s [id=i-0130ef426f34a0a09]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

```

aws ec2コマンドで確認

```bash
> aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId"
[
    "i-0130ef426f34a0a09"
]
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform >1 ?7
>
```

確かに作られている

```bash
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform ?4
> terraform destroy

...

aws_instance.sample: Destruction complete after 31s

Destroy complete! Resources: 1 destroyed.
 ~/gh/g/1/tf-simple-wsgi-on-aws | 1-setup-elb-..by-terraform ?4
>

```

## つまづきメモ

awsの1リージョンあたりの VPC の数の上限値ってデフォルトだと5なんですね。会社アカウントだと何十個もあってそれに見慣れていたから5つしかないのに上限いってますよってエラーが出て困惑した。<https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/amazon-vpc-limits.html>
