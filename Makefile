# デフォルトのターゲット
# .DEFAULT_GOAL := help

# # ヘルプを表示
help:
	@echo "Usage:"
	@echo "make help"       # このヘルプメッセージを表示"
	@echo "make build"      # コンテナイメージをビルド"
	@echo "make up"         # コンテナを起動"
	@echo "make down"       # コンテナを停止"
	@echo "make ps"         # 起動中のコンテナを表示"

# 変数の定義
IMAGE_NAME = Inception
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# ビルド
build:
	docker compose -f $(DOCKER_COMPOSE_FILE) build

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# 実行
run:
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build -d

# コンテナの停止と削除
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

# 依存関係が変更された場合にコンテナを再構築
rebuild:
	docker compose -f $(DOCKER_COMPOSE_FILE) build

ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps

.PHONY: help build up run down rebuild ps