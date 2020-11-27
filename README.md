# テーブル設計

## goalsテーブル

| Column |  Type   |  Options   |
|--------|---------|------------|
| goal   | text    | nul: false |
| period | integer | nul: false | 


### Association

- has_many :incheckes
- has_many :outcheckes


## incheckesテーブル

| Column |  Type      |  Options          |
|--------|------------|-------------------|
| action | text       | nul: false        |
| goal   | references | foreign_key: true | 


### Association

- belongs_to :goal
- has_one :outcheck
- has_one :score


## outcheckesテーブル

| Column     |  Type      |  Options          |
|------------|------------|-------------------|
| good       | text       | nul: false        |
| good_why   | text       | nul: false        |
| good_how   | text       | nul: false        |
| good_where | text       | nul: false        |
| bad        | text       | nul: false        |
| bad_why    | text       | nul: false        |
| bad_how    | text       | nul: false        |
| nextaction | text       | nul: false        |
| goal       | references | foreign_key: true | 
| incheck    | references | foreign_key: true |


### Association

- belongs_to :goal
- has_one :incheck
- has_one :score


## scoresテーブル

|  Column      |  Type      |  Options          |
|--------------|------------|-------------------|
| action_score | text       | nul: false        |
| today_score  | text       | nul: false        |
| incheck      | references | foreign_key: true | 
| outcheck     | references | foreign_key: true |


### Association

- belongs_to :incheck
- belongs_to :outcheck