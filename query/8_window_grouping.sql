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


-- カテゴリの合計と小計を求める (ROLLUP)
SELECT
    product_category
    , SUM(selling_price) AS sum_selling_price
FROM
    product
GROUP BY
    ROLLUP(product_category)
;


-- カテゴリと登録日の合計と小計を求める
SELECT
    product_category
    , registration
    , SUM(selling_price) AS sum_selling_price
FROM
    product
GROUP BY
    ROLLUP(
        product_category
        , registration
    )
ORDER BY
    product_category
;


-- NULLを[0]、超集合のNULLを[1]にする (GROUPING)
SELECT
    GROUPING(product_category) AS category
    , GROUPING(registration) AS registration
    , SUM(selling_price) AS sum_selling_price
FROM
    product
GROUP BY
    ROLLUP(
        product_category
        , registration
    )
;


-- 超集合のNULLに特定の文字を割り当てる
SELECT
    CASE
        WHEN GROUPING(product_category) = 1 THEN '合計'
        WHEN GROUPING(product_category) = 0 AND GROUPING(registration) = 1 THEN '小計 (' || product_category || ')'
        WHEN GROUPING(product_category) = 0 THEN product_category
        ELSE '※ NULLです！'
    END AS category
    , CASE
        WHEN GROUPING(registration) = 1 THEN CAST('----------' AS VARCHAR(16))
        WHEN GROUPING(registration) = 0 THEN CAST(registration AS VARCHAR(16))
        ELSE '出力されない...'
    END AS registration
    , SUM(selling_price) AS sum_selling_price
FROM
    product
GROUP BY
    ROLLUP(
        product_category
        , registration
    )
ORDER BY
    product_category
;


-- カテゴリと登録日の合計に加え、登録日のみの合計も抽出 (CUBE)
SELECT
    CASE
        WHEN GROUPING(product_category) = 1 THEN '合計'
        WHEN GROUPING(product_category) = 0 AND GROUPING(registration) = 1 THEN '小計 (' || product_category || ')'
        WHEN GROUPING(product_category) = 0 THEN product_category
        ELSE '※ NULLです！'
    END AS product_category
    , CASE
        WHEN GROUPING(registration) = 1 THEN CAST('----------' AS VARCHAR(16))
        WHEN GROUPING(registration) = 0 THEN CAST(registration AS VARCHAR(16))
        ELSE '※ NULLと出力されない...'
    END AS registration
    , SUM(selling_price) AS sum_selling_price
FROM
    product
GROUP BY
    CUBE(
        product_category
        , registration
    )
ORDER BY
    product_category
;


-- 練習
-- 登録日を昇順で累計を抽出。ただしNULLは一番はじめに出力する
SELECT
    product_name
    , registration
    , selling_price
    , SUM(selling_price) OVER (
        ORDER BY
            COALESCE(registration, CAST('0001-01-01' AS DATE))
    )
FROM
    product
;
