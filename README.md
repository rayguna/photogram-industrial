# photogram-industrial

Target: https://photogram-industrial.matchthetarget.com/

Lesson: https://learn.firstdraft.com/lessons/197-photogram-industrial-part-1

Video: https://share.descript.com/view/iJTnIgxaV0n

Grading: https://grades.firstdraft.com/resources/9af73a93-b73e-492a-809a-677db28f19fe

Cheatsheet: https://learn.firstdraft.com/

Notes:

### Part I

### A. Set up devise

1. Install devise by including `gem "devise"` into the Gemfile. Then, typing `bundle install`.
2. Next, type `rails generate devise:install`. 
3. Add the root index to routesrb to make the sign-in page the default page:

```
# config/routes.rb

Rails.application.routes.draw do
  root "photos#index"
  # ...
```

4. Type in the terminal:

```
photogram-industrial rg-create-database % git commit -m "generated users with devise"
[rg-create-database 3d0232f] generated users with devise
 1 file changed, 8 insertions(+), 1 deletion(-)
```  

(4 min)

### B. Create a github branch

1. In the terminal, type: `git checkout -b rg-create-database`. 
2. Commit changes to git. Publish the branch.

### C. Create a users table (5 min)

1. Type in the terminal: `rails g devise user username private:boolean likes_count:integer comments_count:integer`.

```
photogram-industrial rg-create-database % rails g devise user username private:boolean likes_count:integer comments_count:integer
      invoke  active_record
      create    db/migrate/20240630035258_devise_create_users.rb
      create    app/models/user.rb
      insert    app/models/user.rb
       route  devise_for :users
```

2. type: `rails db:migrate`.

```
photogram-industrial rg-create-database % rails db:migrate
== 20240630035258 DeviseCreateUsers: migrating ================================
-- create_table(:users)
   -> 0.0728s
-- add_index(:users, :email, {:unique=>true})
   -> 0.0155s
-- add_index(:users, :reset_password_token, {:unique=>true})
   -> 0.0150s
== 20240630035258 DeviseCreateUsers: migrated (0.1036s) =======================
```

Visit: https://scaling-adventure-6r9qwqx4pjv3x6rq-3000.app.github.dev/rails/db. Yes, a table called users exists.

3. Commit changes with `git add -A`.

4. Then: `git commit -m "generated users with devise`.

5. (7 min) Review db/migrate/...devise_create_user and assign default values:

```
  t.string :username
  t.boolean :private
  t.integer :likes_count, default: 0
  t.integer :comments_count, default: 0
```

Testing: navigate to .../users/sign_in. I got the error: `undefined method `session_path' for #<ActionView::Base:0x000000000189e8>`. 

Restart the server and re-run `rails bin/dev`. The users/sign_in page is now working. 

### D. Prepare the Users migration file
(10 min)

1. (10.25 min) Add a line to db/migrate/...devise_create_users file to add a foreign key for username index. Notice that email and reset_password foreign keys are added autonmatically. Also notice that the foreign key needs to be unique.

```
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
    add_index :users, :username,   unique: true

  end
```

2. (13 min) Postgres. Postgres text columns are unfortunately case insensitive. To make it case sensitive, modify the code as follows. Add the line `enable_extension("citext")`. 

```
class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension("citext")
```

(13 min) At the same time, you need to mark the fields which you wished to apply case sensitivity with the keyword `citext` as follows:

```
   create_table :users do |t|
      ## Database authenticatable
      t.citext :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ...

      t.citext :username

      ...
   end
```

3. (14 min) run `rails db:migrate`. If you get an error because you have run it once previously, drop the table with `rails db:drop`.

```
photogram-industrial rg-create-database % rails db:migrate
Model files unchanged.
```
4. (14.37 min) The rails db:drop command resulted in error:

```
photogram-industrial rg-create-database % rails db:drop
Dropped database 'photogram_industrial_development'
Dropped database 'photogram_industrial_test'
photogram-industrial rg-create-database % rails db:migrate
rails aborted!
ActiveRecord::NoDatabaseError: We could not find your database: photogram_industrial_development. Which can be found in the database configuration file located at config/database.yml.

To resolve this issue:

- Did you create the database for this app, or delete it? You may need to create your database.
- Has the database name changed? Check your database.yml config has the correct database name.

To create your database, run:

        bin/rails db:create
/workspaces/photogram-industrial/bin/rails:4:in `<main>'

Caused by:
PG::ConnectionBad: FATAL:  database "photogram_industrial_development" does not exist
```

5. Type in the terminal `rails db:create`.

```
photogram-industrial rg-create-database % rails db:create
Created database 'photogram_industrial_development'
Created database 'photogram_industrial_test'
```

Then, type: `rails db:migrate`.

```
photogram-industrial rg-create-database % rails db:migrate
== 20240630035258 DeviseCreateUsers: migrating ================================
-- enable_extension("citext")
   -> 0.0420s
-- create_table(:users)
   -> 0.0347s
-- add_index(:users, :email, {:unique=>true})
   -> 0.0299s
-- add_index(:users, :reset_password_token, {:unique=>true})
   -> 0.0199s
-- add_index(:users, :username, {:unique=>true})
   -> 0.0165s
== 20240630035258 DeviseCreateUsers: migrated (0.1435s) =======================
```

6. (15 min) The next time you have issues with your table, just rollback and don't delete with: `raisl db:rollback` -> Make the necessary changes -> type `rails db:migrate`.

7. (16 min) Commit your changes to github, Type in the terminal: 

```
git acm "Generated users"
```

Or, you can write it in full:

```
git add -A; git commit -m "Generated users"
```

This sequence of commands (git add -A followed by git commit -m "Generated users") is commonly used when you want to quickly stage and commit all changes in one go.

```
photogram-industrial rg-create-database % git acm "Generated users"
[rg-create-database 5c6324a] Generated users
 4 files changed, 125 insertions(+), 10 deletions(-)
```

8. Type in the terminal:

```
g sla

or
```
git log --oneline --decorate --graph --all -s30
``````

9. (17 min) Generate the rest of the data models. Create users first.

(18 mins) Do you want to create a scaffold (the entire RCAV) or you only want to generate a model? yes, we use scaffolds to generate the entire RCAV elements.

10. (20 min) call the scaffolds commanmd.

```
rails generate scaffold photo image commments_count:integer likes_count:integer caption:text owner:references
```

Visit the generated file: db/migrate ..._create_photos. This is what you see:

```
class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :commments_count
      t.integer :likes_count
      t.text :caption
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
```

Fix the above into:

```
class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :commments_count, default: 0
      t.integer :likes_count, default: 0
      t.text :caption
      t.references :owner, null: false, foreign_key: { to_table :users }

      t.timestamps
    end
  end
end
```

In the current seting, the foreign key is set to be required. If you want the reference column to be optional, you can change it to null: true.

In this case, we want the foreign key to be a requirement because we have to have an owner ID for every photo, so set the null to true. This will set us up with index automatically. 

11. Type `rails db:migrate`. It throws an error!

```
photogram-industrial rg-create-database % rails db:migrate
== 20240701172445 CreatePhotos: migrating =====================================
-- create_table(:photos)
rails aborted!
StandardError: An error has occurred, this and all later migrations canceled:

PG::UndefinedTable: ERROR:  relation "owners" does not exist
/workspaces/photogram-industrial/db/migrate/20240701172445_create_photos.rb:3:in `change'
/workspaces/photogram-industrial/bin/rails:4:in `<main>'

Caused by:
ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "owners" does not exist
/workspaces/photogram-industrial/db/migrate/20240701172445_create_photos.rb:3:in `change'
/workspaces/photogram-industrial/bin/rails:4:in `<main>'

Caused by:
PG::UndefinedTable: ERROR:  relation "owners" does not exist
/workspaces/photogram-industrial/db/migrate/20240701172445_create_photos.rb:3:in `change'
/workspaces/photogram-industrial/bin/rails:4:in `<main>'
Tasks: TOP => db:migrate
(See full trace by running task with --trace)
```

The main error message is that `relation "owners" does not exist.

12. Modify the code:

```
class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :commments_count, default: 0
      t.integer :likes_count, default: 0
      t.text :caption
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
```

13. Re-run the command: `raisl db:migrate`.

```
photogram-industrial rg-create-database % rails db:migrate
== 20240701172445 CreatePhotos: migrating =====================================
-- create_table(:photos)
   -> 0.0565s
== 20240701172445 CreatePhotos: migrated (0.0566s) ============================

Annotated (1): app/models/photo.rb
```

Visiting models/photo.rb shows the following. Rails automatically recognize that the ActiveTable class Photo belongs to owner.

```
class Photo < ApplicationRecord
  belongs_to :owner
end
```

Further modify the file into:

```
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User"
end
```

14. (25 min) Likewise, create a relationship from the user table to the photo table by modifying the models/user.rb file:

```
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :own_photos, class_name: "Photo", foreign_key: "owner_id" 
end
```



### Start over

1. Create a new branch: 

```
photogram-industrial (HEAD detached at dceb327) %  git switch -c dceb327
Switched to a new branch 'dceb327'
```

2. Reinstall devise:
`rails generate devise:install`

Follow instructions. In particular, end with writing in the terminal the command: `rails g devise:views`.

3. Add views/shared folder to refactor partial view html files. Add if-else statement within _navbar.html.erb to differentiate between signed in and signed out navbars. 

### Part II

Video: https://share.descript.com/view/P3PGeVSVtMW

#### A. create a new table called comments

1. Let's generate the rest of the resources using the scaffolds command.

2. First, create and checkout a new branch from photogram 1. Type in the terminal `git checkout -b rg-photogram-industrial-2`.

3. While in the new branch, create a comment table using the scaffold command:
```
rails generate scaffold comment author:references photo:references body:text
```
4. look at the newly created migration file: db/migrate/...create_comments file.

5. Modify the migration file called create_comments as follows.

```
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }, index: false
      t.references :photo, null: false, foreign_key: true, index: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
```

7. we are using author_id as a foreign key, which we need to point to the users table; and we don’t want empty messages so we constrain text to not be empty with null: false.

Accordingly, update the models/comment.rb file as follows:

```
class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :photo
end
```

6. commit changes: 

`git add -A`
`git commit -m "Generated comments"`

(4 min) The instructor forgot to create a branch at the beginning.

### B. Update table relationships

1. modify the following file as well

```
# app/models/user.rb

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :own_photos, class_name: "Photo", foreign_key: "owner_id"
  has_many :comments, foreign_key: "author_id"
end
```

2. modify photo models

```
# app/models/photo.rb

class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :comments
end
```

3. commit changes to github:

```
git add -A 
git commit -m "Generated comments"
```

#### C. Create follow request table

1. (5 min) Type in the terminal: 
```
rails generate scaffold follow_request recipient:references sender:references status
```

2. Modify the models file:

app/models/follow_request.rb
```
class FollowRequest < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"
end
```

3. (5:20 min) modify the migration file:
db/migrate/..create_follow_request
```
class CreateFollowRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :follow_requests do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }, index: true
      t.references :sender, null: false, foreign_key: { to_table: :users }, index: true
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
```
(6 min)

4. Type `rails db:migrate`.

5. commit changes to github: 

  `git add -A`
  `git commit -m "Generated follow requests table."`
  `git push`
  (7 min)

### E. Generate create likes table

1. Type the command: `rails generate scaffold like fan:references photo:references`.

2. Modify the migrate file as follows:

```
class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :fan, null: false, foreign_key: { to_table: :users }
      t.references :photo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
```

3. Make changes to the models file:

```
# app/models/like.rb

class Like < ApplicationRecord
  belongs_to :fan, class_name: "User"
  belongs_to :photo
end
```

4. Type `rails db:migrate`.

```
photogram-industrial rg-photogram-industrial-2 % rails db:migrate
== 20240702192323 CreateLikes: migrating ======================================
-- create_table(:likes)
   -> 0.0526s
== 20240702192323 CreateLikes: migrated (0.0527s) =============================
```

5. commit to github with:

```
photogram-industrial rg-photogram-industrial-2 % g acm "Generate likes table."
[rg-photogram-industrial-2 4bad710] Generate likes table.
 15 files changed, 255 insertions(+), 2 deletions(-)
 create mode 100644 app/controllers/likes_controller.rb
 create mode 100644 app/models/like.rb
 create mode 100644 app/views/likes/_form.html.erb
 create mode 100644 app/views/likes/_like.html.erb
 create mode 100644 app/views/likes/_like.json.jbuilder
 create mode 100644 app/views/likes/edit.html.erb
 create mode 100644 app/views/likes/index.html.erb
 create mode 100644 app/views/likes/index.json.jbuilder
 create mode 100644 app/views/likes/new.html.erb
 create mode 100644 app/views/likes/show.html.erb
 create mode 100644 app/views/likes/show.json.jbuilder
 create mode 100644 db/migrate/20240702192323_create_likes.rb
 ```

 Then, type `git push`.

```
photogram-industrial rg-photogram-industrial-2 % git push
Enumerating objects: 36, done.
Counting objects: 100% (36/36), done.
Delta compression using up to 2 threads
Compressing objects: 100% (24/24), done.
Writing objects: 100% (25/25), 3.86 KiB | 1.29 MiB/s, done.
Total 25 (delta 11), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (11/11), completed with 10 local objects.
To https://github.com/rayguna/photogram-industrial
   405e34d..4bad710  rg-photogram-industrial-2 -> rg-photogram-industrial-2
```
(8 min)

### Open up a pull request
(9 min)

1. Go to the repository and click on "Compare & pull request". Change the title to photogram (Photogram Industrial 2 (rg)). 
2. Click on Create pull request. 

You don't have to do this yet for now.

### F. Checkpoint

1. At this point, it is good to check the created tables by visiting:https://scaling-adventure-6r9qwqx4pjv3x6rq-3000.app.github.dev/rails/db. YOu should have 5 tables: comments, follow_requests, likes, photos, and users.

### III. Association accessors

1. We have our resources in place. Now it’s time to flesh out the business logic in our models.

2. Most of the associations have been done, but let's check and modify as needed.

3. the belongs_to command  automatically sets the foreign key to be true. If you want to make the foreign key blank or optional, you may set the keyword `optional: true`. Review the files in the models files.

### G. Belong_to TIPS

```
In standard Rails applications, the default is opposite: belongs_to adds an automatic validation to foreign key columns enforcing the presence of a valid value unless you explicitly add the option optional: true.

So: if you decided to remove the null: false database constraint from any of your foreign key columns in the migration file (e.g., change t.references :recipient, null: false ... to t.references :recipient, null: true ...), then you should also add the optional: true option to the corresponding belongs_to association accessor.

So remember — if you’re ever in the situation of:

you’re trying to save a record

the save is failing

you’re doing the standard debugging technique of printing out zebra.errors.full_messages

you’re seeing an inexplicable validation error message saying that a foreign key column is blank

now you know where the validation is coming from: belongs_to adds it automatically

so figure out why you’re not providing a valid foreign key (usually it is because the parent object failed to save for its own validation reasons)
```

(11 min)

Note the counter_cache option to keep track of counts.

db/migrate/schema.rb file

### H. Annotate gem for :countter_cache

1. 
(13 min)
- This file tells us the current state of the database whenever the rails db:migrate command is called.
- NEVER edit the schema.rb file. It is auto-generated whenever you run rake db:migrate.
- Use the anotate gem to decide where to add the :counter_cache.

ref.: https://github.com/ctran/annotate_models

2. Add the gem to the :development group in our Gemfile. 

```
# Gemfile

# ...
group :development do
  gem 'annotate'
# ...
```

3. After the gem is installed, you can run: `annotate --models` or `rails g annotate:install` (this alternative command is similar to how we finished installing Devise).

This command will create a rake task file lib/tasks/auto_annotate_models.rake, so that anytime we run rake db:migrate the annotation is run automatically.

4. At the top of our Like model in app/models/like.rb, we should see the helpful annotations:

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :bigint           not null
#  photo_id   :bigint           not null

5. Now let’s get back to what we were doing before: adding the :counter_cache to any belongs_to whenever I’m trying to keep track of the number of children objects that I’ve got.

Let’s start with the Comment model

```
# app/models/comment.rb

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  photo_id   :bigint           not null
# ...

class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :photo
end
```

Anytime a comment is created, do I want to update the author with the count of the comments? We were planning to do that because we added a comments_count column in the users table:

6. modify `app/models/comment.rb` as follows:

```
class Comment < ApplicationRecord
  belongs_to :author, class_name: "User", counter_cache: true
  belongs_to :photo, counter_cache: true
end
```

7. For this to work, you have to have a column in the user table called exactly comments_count. We also want to keep count on the belongs_to :photo, so add the counter_cache: true there as well.

Now in the Like model:

```
# app/models/like.rb

# ...
class Like < ApplicationRecord
  belongs_to :fan, class_name: "User", counter_cache: true
  belongs_to :photo, counter_cache: true
end
```

Also modify the photo model:

```
# app/models/photo.rb

# ...
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User", counter_cache: true
  has_many :comments
end
```

8. Also add photo count to users:

```
photogram-industrial rg-photogram-industrial-2 % rails g migration AddPhotosCountToUsers photos_count:integer
      invoke  active_record
      create    db/migrate/20240702213802_add_photos_count_to_users.rb
```

Then, type: `rake db:migrate`.

```
photogram-industrial rg-photogram-industrial-2 % rake db:migrate
== 20240702213802 AddPhotosCountToUsers: migrating ============================
-- add_column(:users, :photos_count, :integer)
   -> 0.0288s
== 20240702213802 AddPhotosCountToUsers: migrated (0.0289s) ===================
```

### I. Direct assocations

1. Each belongs_to has an inverse, has_many.

2. In the Comment model (app/models/comment.rb), we see a belongs_to :author .... That means, for User we need:

```
# app/models/user.rb

class User < ApplicationRecord
  # ...
  has_many :comments, foreign_key: :author_id
end
```

We need to specify that the foreign key column in comments is not user_id, but rather author_id. We don’t need to say class_name: "Comment", because it matches with the method name has_many :comments.

The Comment model also contains a belongs_to :photo .... That means, for Photo we need:

```
# app/models/photo.rb

class Photo < ApplicationRecord
  # ...
  has_many :comments
end
```

3. In FollowRequest, we have belongs_to :recipient and belongs_to :sender, so we need two corresponding associations in User:

```
  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"
```

follow_requests cannot be repeated twice and they are differentiated with sent_follow_requests and received_follow_requests.

4. On to Like, we find belongs_to :fan and belongs_to :photo. So, we need corresponding has_manys in User and Photo. First for User:

```
# app/models/user.rb

class User < ApplicationRecord
  # ...
  has_many :likes, foreign_key: :fan_id
end
```

Then for Photo:

```
# app/models/photo.rb

class Photo < ApplicationRecord
  # ...
  has_many :likes
end
```

5. And, while we’re in that Photo model, we see that we need a has_many for the User model to go with the belongs_to: owner. So back in the User model:

```
# app/models/user.rb

class User < ApplicationRecord
  # ...
  has_many :own_photos, foreign_key: :owner_id, class_name: "Photo"
end
```

6. Since the User is going to have a few different associations to Photo, we gave this one a distinct method name and pointed it to the correct table.

At some point, we will check the associations.


### J. Indirect Associations

1. Watch the video (start at 23.30 min): https://share.descript.com/view/wy5mgzsL2WX on the association accessor app on adding the five models.

2. We will do N-to-N association.

3. Our first N-N is fans to photos through users. 
  - We need to go the Photo model, and add a has_many association for the fans of each photo that goes through the likes on the photo to the User model:

    ```
    # app/models/photo.rb

    class Photo < ApplicationRecord
      # ...
      has_many :likes
      has_many :fans, through: :likes
    end
    ```

  -  let’s add this inverse indirect association to User and add scopes association.

  - Continuing with the User associations accessors (there are quite a few!), we would like to build a :feed of photos for each user, which contains the photos posted by their :leaders. Finally, we want to build a :discover page, which contains the photos liked by their :leaders:

    ```
    class User < ApplicationRecord
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
      devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable

      has_many :own_photos, class_name: "Photo", foreign_key: "owner_id" 
      has_many :comments, foreign_key: "author_id"

      has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest"
      has_many :accepted_sent_follow_requests, -> { where(status: "accepted") }, foreign_key: :sender_id, class_name: "FollowRequest"
      
      has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"
      has_many :accepted_received_follow_requests, -> { where(status: "accepted") }, foreign_key: :recipient_id, class_name: "FollowRequest"

      has_many :likes, foreign_key: :fan_id

      has_many :own_photos, foreign_key: :owner_id, class_name: "Photo"

      has_many :liked_photos, through: :likes, source: :photo

      has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient

      has_many :followers, through: :accepted_received_follow_requests, source: :sender

      has_many :feed, through: :leaders, source: :own_photos

      has_many :discover, through: :leaders, source: :liked_photos

    end
    ```
- You could have used the association accessor wizard: https://association-accessors.firstdraft.com/users/sign_in

- To write some, or all of these by hand would be really difficult in correct and performant SQL. Rails does it all for us.

Definitely time to git commit and push!

Commit changes with `git add -A`.

Then: `git commit -m "generated users with devise`.

### K. Validations

1. We can go through each column in the table (thanks to our handy annotate gem) and decide if, and what the validation should be.

2. Let's begin with the Comment model: 

```
# app/models/comment.rb

class Comment < ApplicationRecord
  belongs_to :author, class_name: "User", counter_cache: true
  belongs_to :photo, counter_cache: true

  validates :body, presence: true
end
```

The only thing we need here is the presence: true for the body column.

As we discussed, having a belongs_to association will validate the author_id and photo_id columns by default – a feature we switched off previously.

For the FollowRequest model, we already added a default "pending" value to status, and all the foreign keys will again be automatically validated. Similarly, Like only has foreign keys, so that will be automatically validated.

On to Photo. Aside from foreign keys and columns with default values, only the caption and image columns need validations:

```
# app/models/photo.rb

class Photo < ApplicationRecord
  # ...
  has_many :fans, through: :likes

  validates :caption, presence: true
  validates :image, presence: true
end
```
Finally, we have User. Let’s look at the annotations:

```
# app/models/user.rb

# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer          default(0)
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer          default(0)
#  private                :boolean          
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :citext
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
```

All of the password and email things are being taken care of by Devise, so we don’t need to worry about them. And we’ve set defaults on the _count columns.

We should add one validation for the presence and uniqueness of a username:

```
# app/models/user.rb

class User < ApplicationRecord
  # ...
  has_many :discover, through: :leaders, source: :liked_photos

  validates :username, presence: true, uniqueness: true
end
```

### L. Adding a default value to user’s privacy

1. Read here: https://blog.arkency.com/how-to-add-a-default-value-to-an-existing-column-in-a-rails-migration/

2. Let’s modify our database with another migration to add a default on private in users:

```
rails g migration AddDefaultToPrivate
```

3. This won’t write everything for me, which can only be done for adding columns. So we’ll need to modify the migration file with the code shown here:

```
# db/migrate/<date-time-of-migration>_add_default_to_private.rb

class AddDefaultToPrivate < ActiveRecord::Migration[7.0]
  def change
    change_column_default(
      :users,
      :private,
      true
    )
  end
end
```

Type: 
```
rake db:migrate
```

review: app/models/user.rb

You will see private to true

### M. Scopes

1. Notes: https://guides.rubyonrails.org/active_record_querying.html#scopes

2. We can encapsulate these in scopes within our models:

To do:

```
current_user.discover.where(created_at: 1.week.ago...)

current_user.discover.order(likes_count: :desc)
```

We encapsulate with:
```
# app/models/photo.rb

class Photo < ApplicationRecord
  # ...
  scope :past_week, -> { where(created_at: 1.week.ago...) }
  scope :by_likes, -> { order(likes_count: :desc) }
end
```

(45 min)

### N. Enum column type

1. A column that can have a list of values, in this case, the FOllowRequest table has a column called status whose valies is one of "pending", "rejected", or "accepted", it is a good candidate to be an ActiveRecord::Enum, which will give us a bunch of handy methods for free.

2. Modify the following:
(49 min)

```
# app/models/follow_request.rb

class FollowRequest < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"

  enum status: { pending: "pending", rejected: "rejected", accepted: "accepted" } 

  #the above automatically defines:
  # scope :accepted, -> {where(status: "accepted")}
  # scope :accepted, -> {where(status: "accepted")}

end
```

Now, we automatically get a bunch of handy methods for each status, or each of the keys in our hash. We get ? and ! instance methods:

```
# assume follow_request is a valid and pending
follow_request.accepted? # => false
follow_request.accepted! # sets status to "accepted" and saves
```

We also get automatic positive and negative scopes:

```
FollowRequest.accepted
current_user.received_follow_requests.not_rejected
```

we can now replace a Proc in the association accessors for our User model with these handy functions we’ve defined on Photo:

(50 min)

```
# app/models/user.rb

class User < ApplicationRecord
  # ...
  has_many :sent_follow_requests, foreign_key: :sender_id, class_name: "FollowRequest"
  has_many :accepted_sent_follow_requests, -> { accepted }, foreign_key: :sender_id, class_name: "FollowRequest"
  
  has_many :received_follow_requests, foreign_key: :recipient_id, class_name: "FollowRequest"
  has_many :accepted_received_follow_requests, -> { accepted }, foreign_key: :recipient_id, class_name: "FollowRequest"
# ...
```

And now, because enum defines the method FollowRequest.accepted to return a list of accepted follow requests, we can use that method here!

Checkpoint: Visit:
  - /photos
  - /comments

(52 min)

### O. Sample data task

(53 min)
Write sample data tasks

1. Copy and paste the following:

```
# lib/tasks/dev.rake

task sample_data: :environment do
  p "Creating sample data"
end
```

The :environment argument to task makes sure that sample_data has access to all of the gems and models in our app.

2. Test it out by typing in the terminal `rake sample_data`. 

```
photogram-industrial rg-photogram-industrial-2 % rake sample_data
"Creating sample data"
```

(55 min)
3. Let's create sample data using faker gem: https://github.com/faker-ruby/faker.

```
# lib/tasks/dev.rake

task sample_data: :environment do
  p "Creating sample data"

  12.times do
    p Faker: :Name.unique.first_name
    u = User.new
  end

  p "#{User.count} users have been created."
end
```

(57 min)

A more complicated example:

```
# lib/tasks/dev.rake

task :sample_data do
  p "Creating sample data"

  #destroy existing data
  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  12.times do
    name = Faker::Name.first_name
    User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample,
    )

    p u.errors.full_messages

  end

  p "There are now #{User.count} users."
end
```

add the prefix unique. create 

4. Type in the terminal `rails sample_data`.

5. Check: https://scaling-adventure-6r9qwqx4pjv3x6rq-3000.app.github.dev/rails/db/tables/users/data

6. Make users to follow each other:

(58 min)

(1 h) The solution

```
# lib/tasks/dev.rake

desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"
  
    #destroy existing data
    if Rails.env.development?
      FollowRequest.destroy_all
      Comment.destroy_all
      Like.destroy_all
      Photo.destroy_all
      User.destroy_all
    end
  
    12.times do
      name = Faker::Name.first_name
      User.create(
        email: "#{name}@example.com",
        password: "password",
        username: name,
        private: [true, false].sample,
      )
    end
  
    p "There are now #{User.count} users."

    #make users follow each other
    users = User.all

    users.each do |first_user|
      users.each do |second_user|
        next if first_user == second_user
        if rand < 0.75
          first_user.sent_follow_requests.create(
            recipient: second_user,
            status: FollowRequest.statuses.keys.sample
          )
        end
  
        if rand < 0.75
          second_user.sent_follow_requests.create(
            recipient: first_user,
            status: FollowRequest.statuses.keys.sample
          )
        end
      end
    end
    p "There are now #{FollowRequest.count} follow requests."

end
```

1h 5 min - test.

1h 10 min: solution continued

```
# lib/tasks/dev.rake

desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"
  
    #destroy existing data
    if Rails.env.development?
      FollowRequest.destroy_all
      Comment.destroy_all
      Like.destroy_all
      Photo.destroy_all
      User.destroy_all
    end
  
    12.times do
      name = Faker::Name.first_name
      User.create(
        email: "#{name}@example.com",
        password: "password",
        username: name,
        private: [true, false].sample,
      )

      # p u.errors.full_messages #catch errors
    end
  
    p "There are now #{User.count} users."

    #make users follow each other
    users = User.all

    users.each do |first_user|
      users.each do |second_user|
        next if first_user == second_user #a user can't folow themselves
        if rand < 0.75
          first_user.sent_follow_requests.create(
            recipient: second_user,
            status: FollowRequest.statuses.keys.sample
          )
        end
  
        if rand < 0.75
          second_user.sent_follow_requests.create(
            recipient: first_user,
            status: FollowRequest.statuses.keys.sample
          )
        end
      end
    end
    p "There are now #{FollowRequest.count} follow requests."

    # generate Photos, Likes, and Comments.
    users.each do |user|
      rand(15).times do
        photo = user.own_photos.create(
          caption: Faker::Quote.jack_handey,
          image: "https://robohash.org/#{rand(9999)}"
        )
  
        user.followers.each do |follower|
          if rand < 0.5 && !photo.fans.include?(follower)
            photo.fans << follower
          end
  
          if rand < 0.25
            photo.comments.create(
              body: Faker::Quote.jack_handey,
              author: follower
            )
          end
        end
      end
    end
    p "There are now #{User.count} users."
    p "There are now #{FollowRequest.count} follow requests."
    p "There are now #{Photo.count} photos."
    p "There are now #{Like.count} likes."
    p "There are now #{Comment.count} comments."
end
```
7. Run the command `rake sample_data`.


TIPS (1h 8 min) -     

The destroy all must be kept in the if-else block.

ForeignKey violation error occurs because you must destroy the parents object first and then the child object!

Foreign key object is there to prevent deleting the parent object and orphan child object. You must first destroy the pchildren objects, and only then you can destroy the parent objects. In this case, destroy everything else and destroy the User parent table last.


```
#destroy existing data
if Rails.env.development?
  FollowRequest.destroy_all
  User.destroy_all
```


Error:
```
rake aborted!
ActiveModel::MissingAttributeError: can't write unknown attribute `comments_count`
/home/student/.rvm/ruby-3.2.1/gems/activemodel-7.0.8/lib/active_model/attribute.rb:211:in `with_value_from_database'
```

Look at db/schema.rb:

- The error message ActiveModel::MissingAttributeError: can't write unknown attribute 'comments_count' suggests that ActiveRecord is trying to increment or update a comments_count attribute on a model instance but cannot find it.
- This error commonly occurs when you have specified counter_cache: true in your association definition (belongs_to, has_many, has_one). This feature relies on a database column (comments_count in this case) to store and manage counts of associated records (comments in this case). If this column is missing from your database schema or if the attribute is not properly defined in your model, ActiveRecord will raise this error.
- Database Migration: Ensure you have a migration that adds the comments_count column to the table corresponding to the associated model. For example, if you have comments associated with posts, you would need a migration like:

```
class AddCommentsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :comments_count, :integer, default: 0
  end
end
```

The issue may have to do with:
db/migrate/..add_photos_count..
```
class AddPhotosCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :photos_count, :integer, default: 0
  end
end
```

Note to add , default: 0.

Also, go to models

- I may be missing the command default: 0

```
# db/migrate/<date-time-of-migration>_create_follow_requests.rb

class AddPhotosCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :photos_count, :integer, default: 0
  end
end
```

Need to know how top update the migrate file. Typing rails db:migrate after modifying the file didn't help.

***
