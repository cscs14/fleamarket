# README

## 開発環境

- Ruby 2.5.1p57
- Rails 5.2.3

## Free market DB 設計

- id, created_at, updated_at 等、必須カラムは省略。

### users table

| Column              | Type   | Options                                |
| ------------------- | ------ | -------------------------------------- |
| nickname            | string | null: true                             |
| email               | string | null: true                             |
| last_name           | string | null: true                             |
| first_name          | string | null: true                             |
| last_name_kana      | string | null: true                             |
| first_name_kana     | string | null: true                             |
| birthday            | date   | null: true                             |
| user_postal_code    | string | null: true                             |
| user_prefecture     | string | null: true                             |
| user_city           | string | null: true                             |
| user_street_address | string | null: true                             |
| user_building_name  | string | null: true                             |
| user_phone          | string | null: true                             |
| profile_content     | text   | null: true                             |

#### Association

- has_one :deliver_address ,dependent: :destroy
- accepts_nested_attributes_for :deliver_address, allow_destroy: true
- has_many :cards
- has_many :orders
- has_many :freemarkets
- has_many :sns_credentials ,dependent: :destroy

### sns_credential table

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| provider | string     |                                |
| uid      | string     |                                |
| user_id  | references |                                |

#### Association

- belongs_to :user


### deliver_addresses table

| Column          | Type       | Options                        |
| --------------- | ---------- | ------------------------------ |
| postal_code     | string     | null: false                    |
| prefecture_id   | string     | null: false                    |
| city            | string     | null: false                    |
| street_address  | string     | null: false                    |
| building_name   | string     | null: true                     |
| phone           | string     | null: true                     |

#### Association

- belongs_to :user
- has_many :orders
- belongs_to_active_hash :prefecture

#### Description

- 都道府県データは"active_hash"という gem 利用前提の設計。id を格納。

### orders table

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user_id            | references | null: false, foreign_key: true |
| freemarket_id      | references | null: false, foreign_key: true |
| deliver_address_id | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
- belongs_to :freemarket
- belongs_to :deliver_address

### freemarkets table

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| item        | string     | null: false                    |
| price       | integer    | null: false                    |
| condition   | string     | null: false                    |
| ship_charge | string     | null: false                    |
| ship_from   | string     | null: false,                   |
| ship_day    | string     | null: false                    |
| description | text       | null: false                    |
| status      | integer    | null: false, default: 1        |
| user_id     | references | null: false, foreign_key: true |
| category_id | references | null: false, foreign_key: true |
| size_id     | references | null: false, foreign_key: true |
| brand_id    | references | null: false, foreign_key: true |

#### Association

- belongs_to :user
- has_many :orders
- has_many :item_images, dependent: :destroy
- accepts_nested_attributes_for :item_images, allow_destroy: true

#### Description

- statusは取引状況。出品中は「1」、売却済みは「2」

### item_images table

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| image_url     | string     | null: false                    |
| freemarket_id | references | null: false, foreign_key: true |

#### Association

- belongs_to :freemarket

### categories table

| Column        | Type   | Options                        |
| ------------- | ------ | ------------------------------ |
| category_name | string | null: false, unique: true      |
| ancestry      | string | null: true, multiple_key: true |

#### Association

- has_ancestry

#### Description

- カテゴリを多階層に分けて管理する"ancestry"という gem 利用前提の設計。（経路列挙モデル）
- 階層化したいカテゴリは db/seed.rb に記述する。

### cards table

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| customer_id | string     | null: false                    |
| card_id     | string     | null: false                    |
| user_id     | references | null: false, foreign_key: true |

#### Association

- belongs_to :user