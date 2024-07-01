# photogram-industrial

Target: https://photogram-industrial.matchthetarget.com/

Lesson: https://learn.firstdraft.com/lessons/197-photogram-industrial-part-1

Video: https://share.descript.com/view/iJTnIgxaV0n

Grading: https://grades.firstdraft.com/resources/9af73a93-b73e-492a-809a-677db28f19fe

Cheatsheet: https://learn.firstdraft.com/

Notes:

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
