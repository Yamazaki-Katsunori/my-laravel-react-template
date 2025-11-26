FROM php:8.4-cli

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ENV HOME=/home/${USERNAME}
WORKDIR /workspace

# Composer はマルチステージからコピー
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 必要パッケージ + PHP拡張 + ユーザ作成
RUN set -eux; \
    \
    # 1) 必要パッケージのインストール（jq を含む） --
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip tar gzip xz-utils bzip2 \
      jq libpq-dev build-essential procps \
      autoconf pkg-config zlib1g-dev libssl-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # 2) PHP 拡張のビルド/有効化 (pdo_pgsql + redis) --
    docker-php-ext-install pdo pdo_pgsql; \
    pecl install redis; \
    docker-php-ext-enable redis; \
    \
    # 3) ユーザ/グループ作成、workspace と home の準備 --
    groupadd --gid "${USER_GID}" "${USERNAME}" 2>/dev/null || true; \
    id -u "${USERNAME}" >/dev/null 2>&1 || useradd -m -u "${USER_UID}" -g "${USER_GID}" -s /bin/bash "${USERNAME}"; \
    mkdir -p /workspace "${HOME}"; \
    chown -R "${USER_UID}:${USER_GID}" /workspace "${HOME}"; \
    \
    # 4) クリーンアップ（イメージ縮小） --
    apt-get clean || true; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Composer の vendor/bin だけ PATH に通す
ENV PATH="${HOME}/.composer/vendor/bin:/usr/local/bin:${PATH}"

WORKDIR /workspace
USER ${USERNAME}
