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
