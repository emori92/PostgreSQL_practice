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


