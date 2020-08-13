-- データベース作成
CREATE DATABASE shop;

-- テーブル作成
CREATE TABLE Product (
    product_id     CHAR(4)      NOT NULL
    , product_name    VARCHAR(100) NOT NULL
    , product_category VARCHAR(32)  NOT NULL
    , selling_price  INTEGER
    , purchase_price  INTEGER
    , registration      DATE
    , PRIMARY KEY (product_id)
)
;

-- テーブル削除
DROP TABLE Product;

-- テーブル列追加
ALTER TABLE Product ADD COLUMN spell VARCHAR(100);

-- テーブル列削除
ALTER TABLE Product DROP COLUMN spell;

-- データ登録
BEGIN TRANSACTION;
    INSERT INTO Product VALUES ('0001', 'Tシャツ' ,'衣服', 1000, 500, '2009-09-20');
    INSERT INTO Product VALUES ('0002', '穴あけパンチ', '事務用品', 500, 320, '2009-09-11');
    INSERT INTO Product VALUES ('0003', 'カッターシャツ', '衣服', 4000, 2800, NULL);
    INSERT INTO Product VALUES ('0004', '包丁', 'キッチン用品', 3000, 2800, '2009-09-20');
    INSERT INTO Product VALUES ('0005', '圧力鍋', 'キッチン用品', 6800, 5000, '2009-01-15');
    INSERT INTO Product VALUES ('0006', 'フォーク', 'キッチン用品', 500, NULL, '2009-09-20');
    INSERT INTO Product VALUES ('0007', 'おろしがね', 'キッチン用品', 880, 790, '2008-04-28');
    INSERT INTO Product VALUES ('0008', 'ボールペン', '事務用品', 100, NULL, '2009-11-11');
COMMIT;

-- テーブル名を直す
ALTER TABLE Product RENAME TO product;


-- 練習問題
CREATE TABLE contact (
    register_number INTEGER NOT NULL
    , names VARCHAR(128) NOT NULL
    , addresses VARCHAR(256) NOT NULL
    , telephone CHAR(10)
    , mail_address CHAR(20)
)
;

ALTER TABLE contact ADD COLUMN post_number CHAR(8) NOT NULL;

DROP TABLE contact;
