-- 基本のSELECT文
SELECT
    product_id AS "商品ID"
    , product_name AS "商品名"
    , purchase_price AS "仕入単価"
FROM
    product
;


-- 全てのカラムを出力
SELECT
    *
FROM
    product
;


-- 定数の出力
SELECT
    '商品' AS "文字"
    , 39 AS "数値"
    , '2009-02-24' AS "日付"
    , product_id
    , product_name
FROM
    product
;


-- 重複を省く
SELECT
    DISTINCT product_category
FROM
    product
;


-- NULLもカウントされる
SELECT
    DISTINCT purchase_price
FROM
    product
;


-- 複数の重複をさける
SELECT
    DISTINCT product_category
    , registration
FROM
    product
;


-- カテゴリが'衣服'
SELECT
    product_name AS "商品名"
    , product_category AS "商品分類"
FROM
    product
WHERE
    product_category = '衣服'
;


-- 算術演算
SELECT
    product_name
    , selling_price as "販売単価"
    , selling_price * 2 as "販売単価の2倍"
FROM
    product
;


-- 演算のサンプル
SELECT 1 + (3 * 5) AS "test";


-- 原則、NULLの演算はNULLになる
SELECT 1 / 0;
SELECT NULL / 0;
