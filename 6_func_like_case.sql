-- 算術関数用のテーブル作成
CREATE TABLE sample_math (
    m   NUMERIC (10, 3)
    , n INTEGER
    , P INTEGER
)
;


-- 値を挿入
BEGIN TRANSACTION;
    INSERT INTO
        sample_math
    VALUES
        (500,       0,      NULL)
        , (-180,    0,      NULL)
        , (NULL,    NULL,   NULL)
        , (NULL,    7,      3)
        , (NULL,    5,      2)
        , (NULL,    4,      NULL)
        , (8,       NULL,   3)
        , (2.27,    1,      NULL)
        , (5.555,   2,      NULL)
        , (NULL,    1,      NULL)
        , (8.76,    NULL,   NULL)
    ;
COMMIT;

SELECT * FROM sample_math;


-- 絶対値
SELECT
    m
    , ABS(m) AS abs_m
FROM
    sample_math
;


-- 剰余
SELECT
    n
    , p
    , MOD(n, p) AS mode_n_p
FROM
    sample_math
;


-- 四捨五入
SELECT
    m
    , n
    , ROUND(m, n) AS round_m_n
FROM
    sample_math
;


-- 文字列関数のテーブル作成
CREATE TABLE sample_str (
    str1    VARCHAR(40)
    , str2  VARCHAR(40)
    , str3  VARCHAR(40)
)
;


-- 値挿入
BEGIN TRANSACTION;
    INSERT INTO
        sample_str
    VALUES
        ('あいう', 'えお', NULL)
        , ('abc', 'def', NULL)
        , ('山田', '太郎', 'です')
        , ('aaa', NULL, NULL)
        , (NULL	,	'あああ',	NULL)
        , ('@!#$%',	NULL	,	NULL)
        , ('ABC'	,	NULL	,	NULL)
        , ('aBC'	,	NULL	,	NULL)
        , ('abc太郎',	'abc'	,	'ABC')
        , ('abcdefabc','abc'	,	'ABC')
        , ('ミックマック',	'ッ', 'っ')
    ;
COMMIT;

SELECT * FROM sample_str;


-- 連結
SELECT
    str1
    , str2
    , str1 || str2 AS str_concat
FROM
    sample_str
;


-- ３連結
SELECT
    str1
    , str2
    , str3
    , str1 || str2 || str3 AS str_concat
FROM
    sample_str
WHERE
    str1 = '山田'
;


/*
MySQLではCONCATを使う
*/


-- 長さ
SELECT
    str1
    , LENGTH(str1) AS len_str
FROM
    sample_str
;


-- 小文字化
SELECT
    str1
    , LOWER(str1) AS low_str
FROM
    sample_str
WHERE
    str1 IN ('ABC', 'aBC', 'abc', '山田')
;


-- 大文字化
SELECT
    str1
    , UPPER(str1) AS upr_str
FROM
    sample_str
WHERE
    str1 IN ('ABC', 'aBC', 'abc', '山田')
;


-- 文字列置換
SELECT
    str1
    , str2
    , str3
    , REPLACE(str1, str2, str3) AS rep_str
FROM
    sample_str
;


-- 文字列の切り出し
SELECT
    str1
    , SUBSTRING(str1 FROM 3 FOR 2) AS sub_str
FROM
    sample_str
;


-- 現在の日付
SELECT CURRENT_DATE;


-- 現在の時間
SELECT CURRENT_TIME;


-- 現在の日時
SELECT CURRENT_TIMESTAMP;


-- 日付要素の切り出し
SELECT
    CURRENT_TIMESTAMP
    , EXTRACT(YEAR      FROM CURRENT_TIMESTAMP) AS year
    , EXTRACT(MONTH     FROM CURRENT_TIMESTAMP) AS month
    , EXTRACT(DAY       FROM CURRENT_TIMESTAMP) AS day
    , EXTRACT(HOUR      FROM CURRENT_TIMESTAMP) AS hour
    , EXTRACT(MINUTE    FROM CURRENT_TIMESTAMP) AS minute
    , EXTRACT(SECOND   FROM CURRENT_TIMESTAMP) AS secound
;


-- 型変換（キャスト）
SELECT
    CAST('0001' AS INTEGER) AS int_col
;


-- 日付の変換
SELECT
    CURRENT_DATE AS pure_date
    , CAST(REPLACE('2020/4/22', '/', '-') AS DATE) AS "str => date"
    , REPLACE(CAST(CURRENT_DATE AS VARCHAR), '-', '/') AS "date => str"
;


-- NULLを値に変換
SELECT
    COALESCE(NULL, 1)                       AS col_1
    , COALESCE(NULL, 'test', NULL)          AS col_2
    , COALESCE(NULL, NULL, '2009-11-01')    AS col_3
;


-- テーブル内のNULLを変換
SELECT
    str2
    , COALESCE(str2, 'NULLです！')
FROM
    sample_str
;


-- 平均値を代入
SELECT
    n
    , COALESCE(n, ROUND((SELECT AVG(n) FROM sample_math), 1))
FROM
    sample_math
;


-- 部分一致のテーブル作成
CREATE TABLE sample_like (
    str_col VARCHAR(6) NOT NULL
    , PRIMARY KEY (str_col)
)
;

BEGIN TRANSACTION;
    INSERT INTO
        sample_like
    VALUES
        ('abcddd')
        , ('dddabc')
        , ('abdddc')
        , ('abcdd')
        , ('ddabc')
        , ('abddc')
    ;
COMMIT;


-- 前方一致
SELECT
    str_col
FROM
    sample_like
WHERE
    str_col LIKE 'ddd%'
;


-- 中間一致
SELECT
    str_col
FROM
    sample_like
WHERE
    str_col LIKE '%ddd%'
;


-- 後方一致
SELECT
    str_col
FROM
    sample_like
WHERE
    str_col LIKE '%ddd'
;


-- 先方一致で、任意の２文字
SELECT
    str_col
FROM
    sample_like
WHERE
    str_col LIKE 'abc__'
;


-- 販売単価が100~1000円を抽出 (範囲検索)
SELECT
    product_name
    , selling_price
FROM
    product
WHERE
    selling_price BETWEEN 100 AND 1000
;


-- NULLの検索
SELECT
    product_name
    , purchase_price
FROM
    product
WHERE
    purchase_price IS NULL
;


-- NULL以外を抽出
SELECT
    product_name
    , purchase_price
FROM
    product
WHERE
    purchase_price IS NOT NULL
;


-- 仕入単価が320, 500, 5000円の物を抽出
SELECT
    product_name
    , purchase_price
FROM
    product
WHERE
    purchase_price IN (320, 500, 5000)
;


-- 仕入単価が上記以外を抽出
SELECT
    product_name
    , purchase_price
FROM
    product
WHERE
    purchase_price NOT IN (320, 500, 5000)
;


-- 店舗毎の在庫を示すテーブルを作成
CREATE TABLE shop (
    shop_id        CHAR(4)         NOT NULL
    , shop_name     VARCHAR(200)    NOT NULL
    , product_id    CHAR(4)         NOT NULL    
    , stock_num     INTEGER         NOT NULL
    , PRIMARY KEY (shop_id, product_id)
)
;

BEGIN TRANSACTION;
    INSERT INTO
        shop
    VALUES
        ('000A',	'東京',		'0001',	30)
        , ('000A',	'東京',		'0002',	50)
        , ('000A',	'東京',		'0003',	15)
        , ('000B',	'名古屋',	'0002',	30)
        , ('000B',	'名古屋',	'0003',	120)
        , ('000B',	'名古屋',	'0004',	20)
        , ('000B',	'名古屋',	'0006',	10)
        , ('000B',	'名古屋',	'0007',	40)
        , ('000C',	'大阪',		'0003',	20)
        , ('000C',	'大阪',		'0004',	50)
        , ('000C',	'大阪',		'0006',	90)
        , ('000C',	'大阪',		'0007',	70)
        , ('000D',	'福岡',		'0001',	100)
        ;
COMMIT;

SELECT * FROM shop;


-- 大阪点の商品で販売単価を求める
SELECT
    product_name
    , selling_price
FROM
    product
WHERE
    product_id IN (
        SELECT
            product_id
        FROM
            shop
        WHERE
            shop_id = '000C'
    )   
;


-- ビューでも可能
CREATE VIEW osaka
AS
    SELECT
        product_id
    FROM
        shop
    WHERE
        shop_id = '000C'
;

SELECT
    product_name
    , selling_price
FROM
    product
WHERE
    product_id IN (
        SELECT
            *
        FROM
            osaka
    )
;


-- 「東京においてある商品」以外を抽出
SELECT
    product_name
    , selling_price
FROM
    product
WHERE
    product_id NOT IN (
        SELECT
            product_id
        FROM
            shop
        WHERE
            shop_id = '000A'
    )
;


-- 大阪店舗で大阪店と商品テーブルのidが同じ
SELECT
    product_name
    , selling_price
FROM
    product AS p
WHERE
    EXISTS (
        SELECT
            *
        FROM
            shop AS s
        WHERE
            shop_id = '000C'
        AND
            p.product_id = s.product_id
    )
;


/*
相関サブクエリ内の[*]は、慣習的に書いている。
[1]などの定数でも実行可能
*/


-- 東京に置いてある商品以外の販売単価 (NOT EXISTS)
SELECT
    product_name
    , selling_price
FROM
    product AS p
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            shop AS s
        WHERE
            shop_id = '000A'
        AND
            p.product_id = s.product_id
    )
;


-- 「A: キッチン」のように文字を組み合わせてカテゴリを出力する (case式)
SELECT
    product_name
    , CASE
        WHEN product_category = '衣服' THEN 'A:' || product_category
        WHEN product_category = '事務用品' THEN 'B:' || product_category
        WHEN product_category = 'キッチン用品' THEN 'C:' || product_category
        ELSE NULL
    END AS category
FROM
    product
;


-- カテゴリの合計を抽出
SELECT
    SUM(CASE WHEN product_category = '衣服' THEN selling_price ELSE 0 END) AS "衣服"
    , SUM(CASE WHEN product_category = 'キッチン用品' THEN selling_price ELSE 0 END) AS "キッチン用品"
    , SUM(CASE WHEN product_category = '事務用品' THEN selling_price ELSE 0 END) AS "事務用品"
FROM
    product
;


/*  以下のような出力をする
 low_price | mid_price | high_price
-----------+-----------+------------
         5 |         1 |          2
*/

SELECT
    SUM(CASE WHEN selling_price <= 1000 THEN 1 ELSE 0 END) AS low_price
    , SUM(CASE WHEN selling_price > 1000 AND selling_price <= 3000 THEN 1 ELSE 0 END) AS mid_price
    , SUM(CASE WHEN selling_price > 3000 THEN 1 ELSE 0 END) AS high_price
FROM
    product
;
