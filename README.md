# RedisMirroring

単一キーをもとにDatabaseのデータをリストとしてredisに保存します。  
取得時にはRedisに値が格納されていればRedisから取得し、なければDatabaseを検索します。  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_mirroring', git: "https://github.com/YoshitsuguFujii/redis_mirroring.git"
```

And then execute:

    $ bundle

## Usage

### model

```ruby
class Timeline < ActiveRecord::Base
  mirroring key: :user_id, order: { updated_at: :desc }, worker: TimelineWorker
end
```

keyは必須。  
orderとworkerは任意。  
worker指定時は別途sidekiqのworkerを作成。  


### Worker 

```ruby
class TimelineWorker
  include Sidekiq::Worker

  def perform(user_id)
    Timeline.save_to_redis(user_id)
  end
end

```

### 取得

```ruby
# paging時
@timeline = Timeline.mirroring_paginate(current_user.id, page: params[:page], per_page: params[:per_page])

# kaminariと同様のページングの情報へのアクセスメソッド(redis or db取得時に透過的に扱えるように)
@timeline.total_pages
@timeline.total_count
@timeline.offset_value
@timeline.limit_value
@timeline.current_page
@timeline.is_first_page
@timeline.is_last_page

# 件数指定取得
start_index = 1
end_index = 20
@timeline = Timeline.range(current_user.id, start_index, end_index)

# 全件取得時 
@timeline = Timeline.values(current_user.id)
```
