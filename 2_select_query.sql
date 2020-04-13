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


-- 比較演算
SELECT
    product_name
    , product_category
FROM
    product
WHERE
    selling_price = 500
;


-- 販売単価が500円でないもの
SELECT
    product_name AS "商品名"
    , product_category AS "商品分類"
    , selling_price AS "販売単価"
FROM
    product
WHERE
    selling_price <> 500
;


-- 販売単価が1000円以上
SELECT
    product_name
    , product_category
    , selling_price
FROM
    product
WHERE
    selling_price >= 1000
;


-- 登録日が2009-9-27より前
SELECT
    product_name AS "商品名"
    , product_category AS "カテゴリ"
    , purchase_price AS "仕入単価"
    , registration AS "登録日"
FROM
    product
WHERE
    registration < '2009-09-27'
;


-- 販売単価から仕入単価を引いた数が500以上
SELECT
    product_name AS "商品名"
    , selling_price - purchase_price AS "利益"
FROM
    product
WHERE
    selling_price - purchase_price >= 500
;


-- テーブル作成
CREATE TABLE chars
(
    chr CHAR(3) NOT NULL
    , PRIMARY KEY(chr)
);

-- 値挿入
BEGIN TRANSACTION;
    INSERT INTO chars VALUES ('1');
    INSERT INTO chars VALUES ('2');
    INSERT INTO chars VALUES ('3');
    INSERT INTO chars VALUES ('10');
    INSERT INTO chars VALUES ('11');
    INSERT INTO chars VALUES ('222');
COMMIT;

-- 文字列の比較演算
SELECT
    chr
FROM
    chars
WHERE
    chr > '2'
;


-- NULLの扱い
SELECT
    product_name
    , purchase_price
FROM
    product
WHERE
    purchase_price IS NULL
;


-- NOTの使い方
SELECT
    product_name
    , product_category
    , selling_price
FROM
    product
WHERE
    NOT selling_price >= 1000
;


-- カテゴリがキッチン用品、販売単価が3000円以上のもの
SELECT
    product_name
    , product_category
    , selling_price
FROM
    product
WHERE
    product_category = 'キッチン用品'
AND
    selling_price >= 3000
;


-- 「カテゴリが事務用品」かつ「登録日が2009-9-22または2009-9-20」
SELECT
    product_name
    , product_category
    , registration
FROM
    product
WHERE
    product_category = '事務用品'
AND
    (
        registration = '2009-09-11'
    OR
        registration = '2009-09-20'
    )
;


-- 練習
-- 登録日が2009年4月28日以降のもの
SELECT
    product_name
    , registration
FROM
    product
WHERE
    registration >= '2009-04-28'
;

-- 販売単価が仕入単価より500円以上高いもの、2つ書く
SELECT
    product_name
    , selling_price
    , purchase_price
FROM
    product
WHERE
    NOT selling_price - purchase_price < 500
;

SELECT
    product_name
    , selling_price
    , purchase_price
FROM
    product
WHERE
    selling_price - purchase_price > 499
;

-- 販売単価を10%引きしても利益が100円より高い事務用品とキッチン用品
SELECT
    product_name AS "商品名"
    , product_category AS "カテゴリ"
    , selling_price * .9 - purchase_price AS "利益"
FROM
    product
WHERE
    selling_price * .9 - purchase_price > 100
AND
    (
        product_category = '事務用品'
    OR
        product_category = 'キッチン用品'
    )
;