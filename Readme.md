## 作成するAWSリソース
![EC2アーキテクチャ](architecture/ecs.png)

参考文献
- [AWS ソリューション構成例 - コンテナを利用した Web サービス](https://aws.amazon.com/jp/cdp/ec-container/)


## ディレクトリ構成
```console
.
├── architecture ＃ アーキテクチャ図を管理するディレクトリ
│   └── ecs.png　# 今回作成するアーキテクチャ図
└── readme.md # ディレクトリ内の説明
```

## 実装方法
- state管理は、ベストプラクティスよりDynamoDBとS3で管理 StateLockをかけるため
- CIツールには、tfcmt・tfsec・tflint・Plan・Applyを作成
  - tfcmt : Planでの差分をプルリク内から確認できるようにするツール
  - tfsec : terraformで作成したAWSのリソースをAWSのベストプラクティスの観点からセキュリティ面を診断するツール
  - tflint : terraformのLinter
  - Plan : pushされたコードに対して、作成したリソースがPlanにより、作成できるか検証する
  - Apply : 手動で実行する。リソースを作成するときはローカルで実行せず、ActionsのCIを回して作成する
  - OIDC : AWSの認証をするときはOIDCを使う
- moduleは公式のregistryを採用する
- 公式のregistryを参照しても実装ができない場合、resourceブロックから作成する
- terraformはterraformのベストプラクティスに沿ったコードを記述していく
- AWSのリソースもまた、AWSのベストプラクティスに沿ったリソース作成をする
- terraformのmoduleは「[standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)」に従う
  - main.tf, variables.tf, outputs.tf, locals.tfは空でも作成する
  - readmeで各のmodule内で作成されるリソースとリソースの用途を明記
  - variable, outputにはdescriptionとtypeを追加する

## tfsec
terraformで作成したリソースを、AWSのベストプラクティスの観点からセキュリティを分析するツール https://github.com/aquasecurity/tfsec
- .github/workflows/tfsec.ymlの「Show Result tfsec」でtfsecの内容を確認できる。

## 参考ベストプラクティス
[20 Terraform Best Practices to Improve your TF workflow](https://spacelift.io/blog/terraform-best-practices)
