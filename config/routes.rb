Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "photos#index"
end

### B. Create a github branch

1. In the terminal, type: `git checkout -b rg-create-database`. 
2. Commit changes to git. Publish the branch.

### C. Create a users table

1. Type in the terminal: `rails g devise user username private:boolean likes_count:integer comments_count:integer`.
2. Commit changes with `git add -A`.

3. Then: `git commit -m "generated users with devise`. 
