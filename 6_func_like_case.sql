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
    , str3  varchar(40)
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
