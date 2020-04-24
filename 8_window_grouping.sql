-- カテゴリでランク付けする (ウィンドウ関数)
SELECT
    product_name
    , product_category
    , selling_price
    , RANK () OVER (
        PARTITION BY
            product_category
        ORDER BY
            selling_price
    ) AS ranking
FROM
    product
;


/*
・PARTITION BYは順位付けする対象の範囲(ウィンドウ)を設定
・ORDER BYはどのカラムをどの順序で順位付けするかを設定

また、ウィンドウ関数は原則SELECT句でしか使えない
*/


-- PARTITION BYは必須ではない
SELECT
    product_name
    , product_category
    , selling_price
    , RANK () OVER (
        ORDER BY
            selling_price
    ) AS ranking
FROM
    product
;


-- 同列位の後を飛ばさずランク付け & 同列位をなくしてランキングする
SELECT
    product_name
    , product_category
    , selling_price
    , RANK () OVER (
        ORDER BY
            selling_price
    ) AS ranking
    , DENSE_RANK () OVER (
        ORDER BY
            selling_price
    ) AS dense_ranking
    , ROW_NUMBER () OVER (
        ORDER BY
            selling_price
    ) AS row_num
FROM
    product
;


-- 累計 (SUMをウィンドウ関数として扱う)
SELECT
    product_id
    , product_name
    , selling_price
    , SUM (selling_price) OVER (
        ORDER BY
            product_id
    ) AS current_sum
FROM
    product
;


-- AVG
SELECT
    product_id
    , product_name
    , selling_price
    , AVG (selling_price) OVER (
        ORDER BY
            product_id
    ) AS current_avg
FROM
    product
;

/*
集約関数をウィンドウ関数として使う場合、カレントレコードを対象に合計や平均などの計算を行う
*/


-- 移動平均 (フレーム:ウィンドウをさらに細かくした範囲)
SELECT
    product_id
    , product_name
    , selling_price
    , AVG (selling_price) OVER (
        ORDER BY
            product_id
        ROWS
            1 PRECEDING
    ) AS moving_avg
FROM
    product
;


-- FOLLOWING
SELECT
    product_id
    , product_name
    , selling_price
    , AVG (selling_price) OVER (
        ORDER BY
            product_id
        ROWS
            BETWEEN 1 PRECEDING
        AND
            1 FOLLOWING
    ) AS moving_avg
FROM
    product
;


-- ウィンドウ関数のORDER BYは、昇順/降順を行う訳ではないので、並び順を整理する場合はSELECT句にORDER BYを入れる
SELECT
    product_name
    , product_category
    , selling_price
    , RANK () OVER (
        ORDER BY
            selling_price
    ) AS ranking
FROM
    product
ORDER BY
    ranking
;
