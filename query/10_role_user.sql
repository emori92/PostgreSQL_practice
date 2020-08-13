-- Roleの作成
CREATE ROLE emori WITH LOGIN PASSWORD 'kbug5quM';
CREATE ROLE falcon WITH LOGIN PASSWORD 'wnRu6yux';

-- 権限の付与
GRANT ALL PRIVILEGES ON DATABASE "note_app" to emori;

-- roleの確認
\du

-- スーパーユーザー権限を設定
ALTER ROLE emori SUPERUSER;

-- データベース作成の権限
ALTER ROLE emori
    CREATEDB
    , PASSWORD 'wnRu6yux'
;