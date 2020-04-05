SELECT
    shohin_bunrui as 商品分類
    , AVG(shiire_tanka) as 仕入平均
    , AVG(hanbai_tanka) as 販売平均
FROM
    Shohin
WHERE
    shiire_tanka IS NOT NULL
GROUP BY
    shohin_bunrui
;