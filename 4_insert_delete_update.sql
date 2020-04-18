-- productテーブルのコピーを作成
CREATE TABLE dummy_product (
    product_id          CHAR(4)         NOT NULL
    , product_name      VARCHAR(100)    NOT NULL
    , product_category  CHAR(32)        NOT NULL
    , selling_price     INTEGER         DEFAULT 0
    , purchase_price    INTEGER
    , registration      DATE
    , PRIMARY KEY (product_id)
)
;

/*
複数INSERTは以下2点に気を付ける
・エラー箇所が分かりにくい
・Oracleでは使えない
*/


-- INSERTの構文
INSERT INTO dummy_product
    (product_id, product_name, product_category, selling_price, purchase_price, registration)
VALUES
    ('0001', 'Tシャツ', '衣服', 1000, 500, '2009-09-20')
;


-- 複数行INSERT
INSERT INTO dummy_product
    (product_id, product_name, product_category, selling_price, purchase_price, registration)
VALUES
    ('0002', '穴あけパンチ', '事務用品', 500, 320, '2009-09-11')
    , ('0003', 'カッターシャツ', '衣服', 4000, 2800, NULL)
    , ('0004', '包丁', 'キッチン用', 3000, 2800, '2009-09-20')
;


-- 列リストは省略可能
INSERT INTO dummy_product
VALUES
    ('0005', '圧力鍋', 'キッチン用品', 6800, 5000, '2009-01-15')
;


-- NULLのINSERT
INSERT INTO dummy_product
VALUES
    ('0006', 'フォーク', 'キッチン用品', 500, NULL, '2009-09-20')
;


-- デフォルト値の挿入
INSERT INTO dummy_product
VALUES
    ('0007', 'おろしがね', 'キッチン用品', DEFAULT, 790, '2009-04-28')
;


-- 暗黙的に挿入
INSERT INTO dummy_product
    (product_id, product_name, product_category, purchase_price, registration)
VALUES
    ('0007', 'おろしがね', 'キッチン用品', 790, '2009-04-28')
;

/* 削除クエリ
DELETE
FROM
    dummy_product
WHERE
    product_id = '0007'
;
*/


-- 他のテーブルから値を挿入
CREATE TABLE copy_product (
    product_id          CHAR(4)         NOT NULL
    , product_name      VARCHAR(100)    NOT NULL
    , product_category  CHAR(32)        NOT NULL
    , selling_price     INTEGER
    , purchase_price    INTEGER
    , registration      DATE
    , PRIMARY KEY (product_id)
)
;

INSERT INTO copy_product
SELECT
    *
FROM
    product
;


-- GROUP BYで挿入
CREATE TABLE category (
    product_category VARCHAR(32) NOT NULL
    , totall_selling_price INTEGER
    , totall_purchase_price INTEGER
    , PRIMARY KEY (product_category)
)
;

INSERT INTO category
SELECT
    product_category
    , SUM(selling_price)
    , SUM(purchase_price)
FROM
    product
GROUP BY
    product_category
;


-- テーブルを全行削除する
DELETE
FROM
    product
;


-- 販売単価が4000円以上のレコードを削除
DELETE
FROM
    product
WHERE
    selling_price >= 4000
;

/*
削除すると、原則的に元に戻せない。
DELETEは実行する前にSELECTで間違ってないか確認する
*/


-- テーブルを全行削除する（高速）
TRUNCATE copy_product;


-- レコードを更新する
UPDATE
    product
SET
    registration = '2009-10-10'
;

-- 「キッチン用品」の販売単価を10倍する
UPDATE
    product
SET
    selling_price = selling_price * 10
WHERE
    product_category = 'キッチン用品'
;


-- idが8の登録日をNULLにする(NULLクリア)
UPDATE
    product
SET
    registration = NULL
WHERE
    product_id = '0008'
;


-- 「キッチン用品」の販売単価を10倍、仕入単価を0.5倍する(複数列の更新)
UPDATE
    product
SET
    selling_price = selling_price * 10
    , purchase_price = purchase_price / 2
WHERE
    product_category = 'キッチン用品'
;


-- 別の方法(Posgreなど一部のRDBしか利用できない)
UPDATE
    product
SET
    (
        selling_price
        , purchase_price
    ) = (
        selling_price * 10
        , purchase_price / 2
    )
WHERE
    product_category = 'キッチン用品'
;


-- TRANSACTION(挿入/削除/更新のひとまとまり)
BEGIN TRANSACTION;
    UPDATE
        product
    SET
        selling_price = selling_price - 1000
    WHERE
        product_name = 'カッターシャツ'
    ;

    UPDATE
        product
    SET
        selling_price = selling_price + 1000
    WHERE
        product_name = 'Tシャツ'
    ;
COMMIT;

/*
COMMITするとTRANSACTION開始前に戻せない
ROLLBACKはTRANSACTIONの処理を全て取り消す
*/

BEGIN TRANSACTION;
    UPDATE
        product
    SET
        selling_price = selling_price - 1000
    WHERE
        product_name = 'カッターシャツ'
    ;

    UPDATE
        product
    SET
        selling_price = selling_price + 1000
    WHERE
        product_name = 'Tシャツ'
    ;
    SELECT * FROM product;
ROLLBACK;

SELECT * FROM product;


-- 練習
-- レコードを全て削除
BEGIN TRANSACTION;
    TRUNCATE product;
COMMIT;


-- 3つのレコードを挿入
BEGIN TRANSACTION;
    INSERT INTO
        product
    VALUES
        ('0001', 'Tシャツ', '衣服', 1000, 500, '2008-09-20')
        , ('0002', '穴あけパンチ', '事務用品', 500, 320, '2008-09-11')
        , ('0003', 'カッターシャツ', '衣服', 4000, 2800, NULL)
    ;
COMMIT;


-- 全抽出
SELECT * FROM product;


-- テーブルのレコードをコピーし挿入(エラーになる)
BEGIN TRANSACTION;
    INSERT INTO
        product
    SELECT
        *
    FROM
        product
    ;
    SELECT * FROM product;
COMMIT;


-- 差益カラムを追加したテーブルを作成
CREATE TABLE benefit (
    product_id          CHAR(4)         NOT NULL
    , product_name      VARCHAR(100)    NOT NULL
    , selling_price     INTEGER         DEFAULT 0
    , purchase_price    INTEGER
    , benefit           INTEGER
    , PRIMARY KEY (product_id)
)
;


-- データ登録
BEGIN TRANSACTION;
    INSERT INTO
        benefit
    SELECT
        product_id
        , product_name
        , selling_price
        , purchase_price
        , selling_price - purchase_price
    FROM
        product
    WHERE
        product_name = 'Tシャツ'
    OR
        product_name = '穴あけパンチ'
    OR
        product_name = 'カッターシャツ'
    ;
COMMIT;


-- 全抽出
SELECT * FROM benefit;


-- カッターシャツの販売単価を1000円下げ、差益も反映させる
BEGIN TRANSACTION;
    UPDATE
        benefit
    SET
        selling_price = selling_price - 1000
    WHERE
        product_name = 'カッターシャツ'
    ;

    UPDATE
        benefit
    SET
        benefit = selling_price - purchase_price
    ;
    SELECT * FROM benefit;
COMMIT;


-- 全抽出
SELECT * FROM benefit;
