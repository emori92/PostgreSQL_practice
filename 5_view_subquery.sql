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
