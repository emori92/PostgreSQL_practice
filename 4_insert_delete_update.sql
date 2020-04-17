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
