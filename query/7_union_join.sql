-- テーブルの足し算をするためのテーブル (集合演算)
CREATE TABLE product2 (
    product_id     CHAR(4)      NOT NULL
    , product_name    VARCHAR(100) NOT NULL
    , product_category VARCHAR(32)  NOT NULL
    , selling_price  INTEGER
    , purchase_price  INTEGER
    , registration      DATE
    , PRIMARY KEY (product_id)
)
;

BEGIN TRANSACTION;
    INSERT INTO
        product2
    SELECT
        *
    FROM
        product
    WHERE
        product_id BETWEEN '0001' AND '0003'
    ;
    -- 新たな値を挿入
    INSERT INTO
        product2
    VALUES
        ('0009', '手袋', '衣服', 800, 500, NULL)
        , ('0010', 'やかん', 'キッチン用品', 2000, 1700, '2009-09-20')
    ;
COMMIT;

SELECT * FROM product2;


-- productとproduct2を足す (和集合)
SELECT
    product_id
    , product_name
FROM
    product
UNION
SELECT
    product_id
    , product_name
FROM
    product2
ORDER BY
    product_id
;

/*
 集合演算の注意点
・重複は省かれる
・カラムは同じ数にする
・カラムのデータ型が同じであること
・ORDER BYは最後に1つだけつける
*/


-- 重複を含めて足す
SELECT
    product_id
    , product_name
FROM
    product
UNION ALL
SELECT
    product_id
    , product_name
FROM
    product2
ORDER BY
    product_id
;


-- レコードの共通部分 (積集合)
SELECT
    product_id
    , product_name
FROM
    product
INTERSECT
SELECT
    product_id
    , product_name
FROM
    product2
ORDER BY
    product_id
;


-- レコードの引き算
SELECT
    product_id
    , product_name
FROM
    product
EXCEPT
SELECT
    product_id
    , product_name
FROM
    product2
ORDER BY
    product_id
;


-- 内部結合
SELECT
    shop_name
    , product_name
    , selling_price
FROM
    product AS p
INNER JOIN
    shop AS s
ON
    p.product_id = s.product_id
;


-- 東京の店舗のみ抽出
SELECT
    shop_name
    , product_name
    , selling_price
FROM
    product AS p
INNER JOIN
    shop AS s
ON
    p.product_id = s.product_id
WHERE
    shop_id = '000A'
;


-- 外部結合
SELECT
    shop_name
    , product_name
    , selling_price
FROM
    product AS p
LEFT JOIN
    shop AS s
ON
    p.product_id = s.product_id
;

/* ポイント
・外部結合は必ず片方のテーブルを全出力する
・内部結合は両方のテーブルに存在するものを出力する
*/


-- テーブル作成
CREATE TABLE stock (
    stock_id    CHAR(4) NOT NULL
    , product_id   CHAR(4) NOT NULL
    , stock_num INTEGER NOT NULL
    , PRIMARY KEY (stock_id, product_id)
)
;

BEGIN TRANSACTION;
    INSERT INTO
        stock
    VALUES
        ('S001',	'0001',	0)
        , ('S001',	'0002',	120)
        , ('S001',	'0003',	200)
        , ('S001',	'0004',	3)
        , ('S001',	'0005',	0)
        , ('S001',	'0006',	99)
        , ('S001',	'0007',	999)
        , ('S001',	'0008',	200)
        , ('S002',	'0001',	10)
        , ('S002',	'0002',	25)
        , ('S002',	'0003',	34)
        , ('S002',	'0004',	19)
        , ('S002',	'0005',	99)
        , ('S002',	'0006',	0)
        , ('S002',	'0007',	0)
        , ('S002',	'0008',	18)
    ;
COMMIT;


-- 3つのテーブル結合
SELECT
    sh.shop_name
    , pr.product_name
    , pr.selling_price
    , st.stock_num
FROM
    product AS pr
INNER JOIN
    shop AS sh
ON
    pr.product_id = sh.product_id
INNER JOIN
    stock AS st
ON
    pr.product_id = st.product_id
WHERE
    st.stock_id = 'S001'
ORDER BY
    pr.product_id
;


-- サブクエリの練習
SELECT
    t2.shop_name
    , t1.product_name
    , t1.selling_price
    , t2.stock_num
FROM
    product AS t1
LEFT JOIN
    (
    SELECT
        sh.product_id
        , sh.shop_name
        , st.stock_id
        , st.stock_num
    FROM
        shop AS sh
    INNER JOIN
        stock AS st
    ON
        sh.product_id = st.product_id
    ) AS t2
ON
    t1.product_id = t2.product_id
WHERE
    t2.stock_id = 'S001'
ORDER BY
    t1.product_id
;


-- CROSS JOIN
SELECT
    t1.shop_id
    , t1.shop_name
    , t2.product_id
    , t2.product_name
FROM
    shop AS t1
CROSS JOIN
    product AS t2
;

/*
CROSS JOINは以下の理由で使わない
・出力結果がほぼ使えない
・膨大な時間とマシンパワーが消費される
*/


-- 練習
/* 以下のような出力を求める
 coalesce |  product_name  | selling_price
----------+----------------+---------------
 東京     | Tシャツ        |          1000
 東京     | 穴あけパンチ   |           500
 東京     | カッターシャツ |          4000
 名古屋   | 穴あけパンチ   |           500
 名古屋   | カッターシャツ |          4000
 名古屋   | 包丁           |          3000
 名古屋   | フォーク       |           500
 名古屋   | おろしがね     |           880
 大阪     | カッターシャツ |          4000
 大阪     | 包丁           |          3000
 大阪     | フォーク       |           500
 大阪     | おろしがね     |           880
 福岡     | Tシャツ        |          1000
 不明     | ボールペン     |           100
 不明     | 圧力鍋         |          6800
*/

SELECT
    COALESCE(t2.shop_name, '不明')
    , t1.product_name
    , t1.selling_price
FROM
    product AS t1
LEFT JOIN
    shop AS t2
ON
    t1.product_id = t2.product_id
;
