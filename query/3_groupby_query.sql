-- テーブル全体の行数を数える
SELECT COUNT(*) FROM product;


-- NULLのカウントは除外される
SELECT
    COUNT(*) AS "全体の行数"
    , COUNT(purchase_price) AS "仕入単価の行数"
FROM
    product
;


-- 合計値を抽出
SELECT SUM(selling_price) FROM product;


-- NULLの計算は除外される
SELECT
    SUM(selling_price) AS "販売単価"
    , SUM(purchase_price) AS "仕入単価"
FROM
    product
;


-- 平均
SELECT AVG(selling_price) FROM product;


-- NULLの平均
SELECT
    AVG(selling_price) AS "販売単価"
    , AVG(purchase_price) AS "仕入単価"
FROM
    product
;


-- 最大・最小
SELECT
    MAX(selling_price)
    , MIN(purchase_price)
FROM
    product
;


-- MAX/MINは、どの型でも引数にに取れる
SELECT
    MAX(registration)
    , MIN(registration)
FROM
    product
;


-- 値の重複を除外して数える
SELECT
    COUNT(DISTINCT product_category)
FROM
    product
;


-- DISTINCTの使用例
SELECT
    COUNT(DISTINCT selling_price)
    , AVG(DISTINCT selling_price)
    , STDDEV(DISTINCT selling_price)
FROM
    product
;


-- 分類毎の行数
SELECT
    product_category
    , COUNT(*)
FROM
    product
GROUP BY
    product_category
;


-- NULLもカウントされる
SELECT
    purchase_price
    , COUNT(*)
FROM
    product
GROUP BY
    purchase_price
;


-- WHERE句を用いる
SELECT
    purchase_price
    , COUNT(*)
FROM
    product
WHERE
    product_category = '衣服'
GROUP BY
    purchase_price
;


/*
GROUP BYは以下のことに注意する必要がある

・SELECT句には定数、集計関数、集約キー以外不可
・SELECT句でASで設定した名前は、GROUP BYに使えない
・GROUP BYで出力されたソート順は無作為
・WHERE句に集計関数は使えない

*/


-- カテゴリ内に2つであるもの
SELECT
    product_category
    , COUNT(*)
FROM
    product
GROUP BY
    product_category
HAVING
    COUNT(product_category) = 2
;


-- 販売単価の平均が2500以上
SELECT
    product_category
    , AVG(selling_price) AS "平均"
FROM
    product
GROUP BY
    product_category
HAVING
    AVG(selling_price) >= 2500
;


-- 順番を整理する
SELECT
    *
FROM
    product
ORDER BY
    selling_price
;


-- 降順
SELECT
    *
FROM
    product
ORDER BY
    selling_price DESC
;


-- 2回昇順する
SELECT
    *
FROM
    product
ORDER BY
    selling_price
    , product_id
;


-- NULLは先頭か末尾にくる
SELECT
    *
FROM
    product
ORDER BY
    purchase_price
;


-- ORDER BYは略称が使える
SELECT
    product_name AS "商品名"
    , purchase_price AS "仕入単価"
FROM
    product
ORDER BY
    "仕入単価"
;


-- ORDER BYはテーブルにある列ならSELECT文になくても可能
SELECT
    product_id
    , product_name
FROM
    product
ORDER BY
    selling_price DESC
;


-- 集約関数も可能
SELECT
    product_category
    , COUNT(*)
FROM
    product
GROUP BY
    product_category
ORDER BY
    COUNT(*)
;


-- ORDER BYは列番号を使える
/*
    列番号の指定は以下の理由で利用は避けるべき
    ・可読性が下がる
    ・1992年の標準SQL企画で「将来削除されるべき機能」とされている
*/

SELECT
    *
FROM
    product
ORDER BY
    3 DESC
    , 1
;


-- 練習
-- [販売単価の合計]が[仕入単価の合計 * 1.5] より大きい商品分類を抽出

/*  実行結果例
カテゴリ | 販売単価の合計 | 仕入単価の合計
----------+----------------+----------------
 衣服     |           5000 |           3300
 事務用品 |            600 |            320
*/

SELECT
    product_category AS "カテゴリ"
    , SUM(selling_price) AS "販売単価の合計"
    , SUM(purchase_price) AS "仕入単価の合計"
FROM
    product
GROUP BY
    product_category
HAVING
    SUM(selling_price) > SUM(purchase_price) * 1.5
;
