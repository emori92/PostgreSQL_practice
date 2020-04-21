/*
ビューは、テーブルとほぼ全く同じ。
ただ「実データを保存しない」という特徴がある

ビューには以下2点のメリットがある
・ハードディスクの節約(SELECT文を保存している)
・SELECT文を再度書き込む必要がない(最新のテーブルデータが反映される)

ビューを重ねることは可能だが、パフォーマンスが下がるので、基本的に1回のみの使用が推奨

ビューの制限事項が2点ある。
・ORDER BYは利用できない(PostgreSQLなど一部RDBはできてしまう)
・ビューに対するフィールド値の更新
*/


-- ビューの作成
CREATE VIEW category_sum
AS
    SELECT
        product_category
        , COUNT(*) AS cnt_category
    FROM
        product
    GROUP BY
        product_category
;


-- ビューの抽出
SELECT
    *
FROM
    category_sum
;


-- ビューの削除
DROP VIEW category_sum;


-- サブクエリ
SELECT
    *
FROM
    (
    SELECT
        product_category
        , COUNT(*) AS cnt_category
    FROM
        product
    GROUP BY
        product_category
    ) AS category_sum
;


-- 販売単価が平均より高い値(スカラサブクエリ:必ず1行1列の値を返す)
SELECT
    product_name
    , selling_price
FROM
    product
WHERE
    selling_price > (
    SELECT
        AVG(selling_price)
    FROM
        product
    )
;


-- カテゴリ毎の平均を出し、その平均より高いカテゴリ内商品を抽出(相関サブクエリ：小分けしたグループ内での比較)
SELECT
    product_category
    , product_name
    , selling_price
FROM
    product AS p1
WHERE
    selling_price > (
    SELECT
        AVG(selling_price)
    FROM
        product AS p2
    WHERE
        p1.product_category = p2.product_category
    GROUP BY
        product_category
    )
;


-- 練習
-- practice1というビューを作成する。条件は、販売単価が1000円以上で、登録日が2009年9月20日の商品名、販売単価、登録日を抽出
CREATE VIEW
    practice1
AS
    SELECT
        product_name
        , selling_price
        , registration
    FROM
        product
    WHERE
        selling_price >= 1000
    AND
        registration = '2009-09-20'
;

SELECT * FROM practice1;


/* 以下のような出力する
 product_id |  product_name  | product_category | selling_price |   avg_selling_price
------------+----------------+------------------+---------------+-----------------------
 0001       | Tシャツ        | 衣服             |          1000 | 2097.5000000000000000
 0002       | 穴あけパンチ   | 事務用品         |           500 | 2097.5000000000000000
 0003       | カッターシャツ | 衣服             |          4000 | 2097.5000000000000000
 0004       | 包丁           | キッチン用品     |          3000 | 2097.5000000000000000
 0005       | 圧力鍋         | キッチン用品     |          6800 | 2097.5000000000000000
 0006       | フォーク       | キッチン用品     |           500 | 2097.5000000000000000
 0007       | おろしがね     | キッチン用品     |           880 | 2097.5000000000000000
 0008       | ボールペン     | 事務用品         |           100 | 2097.5000000000000000
*/

SELECT
    product_id
    , product_name
    , product_category
    , selling_price
    , (
        SELECT
            AVG(selling_price)
        FROM
            product
    ) AS avg_selling_price
FROM
    product
;


/* 以下のような結果のビューを作成する
 product_id |  product_name  | product_category | selling_price |          avg
------------+----------------+------------------+---------------+-----------------------
 0001       | Tシャツ        | 衣服             |          1000 | 2500.0000000000000000
 0002       | 穴あけパンチ   | 事務用品         |           500 |  300.0000000000000000
 0003       | カッターシャツ | 衣服             |          4000 | 2500.0000000000000000
 0004       | 包丁           | キッチン用品     |          3000 | 2795.0000000000000000
 0005       | 圧力鍋         | キッチン用品     |          6800 | 2795.0000000000000000
 0006       | フォーク       | キッチン用品     |           500 | 2795.0000000000000000
 0007       | おろしがね     | キッチン用品     |           880 | 2795.0000000000000000
 0008       | ボールペン     | 事務用品         |           100 |  300.0000000000000000
*/

CREATE VIEW
    avg_category
AS
    SELECT
        product_id
        , product_name
        , product_category
        , selling_price
        , (
            SELECT
                AVG(selling_price)
            FROM
                product AS p2
            WHERE
                p1.product_category = p2.product_category
        )
    FROM
        product AS p1
;

SELECT * FROM avg_category;
