# k8s-cronjob-embulk-blueprint
Embulkのバッチ処理をGoogle Cloud PlatformのKubernetes Engineに構築する為の雛形です。  
Kubernetesの[CronJob](https://cloud.google.com/kubernetes-engine/docs/how-to/cronjobs)を使って定期的に実行する事を想定しています。

## 事前準備
### gcloud、kubectl コマンドラインツールのインストール

1. [Google Cloud SDK(gcloud)をインストール](https://cloud.google.com/sdk/docs/quickstarts?hl=ja)
2. [Kubernetes コマンドラインツール(kubectl)](https://kubernetes.io/) をインストール  
```
$ gcloud components install kubectl
```
3. gcloud コマンドライン ツールのデフォルトプロジェクト、ゾーンをセット  
```
$ gcloud config set project [PROJECT_ID]
$ gcloud config set compute/zone asia-northeast1-a
```

### [Kubernetes Engine](https://cloud.google.com/kubernetes-engine/?hl=ja) に[コンテナクラスタ](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture?hl=ja)を作成
1. クラスタを作成
```
# 数分かかる場合がある
$ gcloud container clusters create [クラスタ名] --num-nodes=3
```
```
# 作成したクラスタを確認
$ gcloud compute instances list
NAME           ZONE               MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
instance-1     asia-southeast1-b  n1-highcpu-16               X.X.X.X      X.X.X.X       RUNNING
```
2. クラスタの認証情報を取得
```
gcloud container clusters get-credentials [クラスタ名]
```

## コンテナイメージの作成・変更

1. このリポジトリをダウンロード  
```
$ git clone https://github.com/kosukekurimoto/k8s-cronjob-embulk-blueprint.git
$ cd k8s-cronjob-embulk-blueprint
```
2. cronjob-embulk-example.yamlの修正
```
image: gcr.io/[PROJECT_ID]/k8s-cronjob-embulk:v1 # PROJECT_IDを修正
```

3. コンテナイメージの作成  
```
$ docker build -t gcr.io/[PROJECT_ID]/k8s-cronjob-embulk:v1 .
```
```
# 作成したイメージを確認
$ docker images
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
gcr.io/my-project/hello-app    v1                  25cfadb1bf28        10 seconds ago      54 MB
```
4. [Container Registry](https://cloud.google.com/container-registry/?hl=ja) にコンテナイメージをプッシュ
```
$ gcloud docker -- push gcr.io/[PROJECT_ID]/k8s-cronjob-embulk:v1
```

## Deploy

- CronJobの登録(更新)
```
$ kubectl apply -f cronjob-embulk-example.yaml
```

## TIPS
- gcloud コマンドラインツールのアップデート
```
$ gcloud components update
```
- CronJobの確認
```
$ kubectl get cronjobs
```
- CronJobの削除
```
$ kubectl delete cronjobs [CronJob名]
```
