# Template: Rails, Tailwind, Devise & Simple Form
# Instructions:
# rails new myapp -d postgresql -m ../templates/rails/tailwind-devise/template.rb
# OR rails new myapp -d postgresql -m template.rb
########################################

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  inject_into_file 'Gemfile', before: 'group :development, :test do' do
    <<~RUBY
      gem 'devise'
      gem 'name_of_person', '~> 1.1', '>= 1.1.1'
      gem 'font-awesome-sass'
      gem 'simple_form'
    RUBY
  end

  inject_into_file 'Gemfile', after: 'group :development, :test do' do
    <<-RUBY
    gem 'pry-byebug'
    gem 'pry-rails'
    gem 'dotenv-rails'
    RUBY
  end
end

def add_devise_users
  generate "devise:install"
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")
end

def add_simple_form
  generate "simple_form:install"
end

def copy_templates
  directory "app", force: true
end

def add_tailwind
  run "yarn add tailwindcss"
  run "yarn add @fullhuman/postcss-purgecss"

  run "mkdir -p app/javascript/stylesheets"

  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js",
  "let tailwindcss = require('tailwindcss');\n",  before: "module.exports")
  inject_into_file("./postcss.config.js", "\n    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")

  run "mkdir -p app/javascript/stylesheets/components"
end

def copy_postcss_config
  run "rm postcss.config.js"
  copy_file "postcss.config.js"
end

# Remove Application CSS
def remove_app_css
  remove_file "app/assets/stylesheets/application.css"
end

def generate_pages_controller
  generate(:controller, 'pages', '--skip-routes', '--no-test-framework')
  run 'rm app/controllers/pages_controller.rb'
  file 'app/controllers/pages_controller.rb', <<~RUBY
    class PagesController < ApplicationController
      # skip_before_action :authenticate_user!, only: [ :home ]
      def home
      end
    end
  RUBY
end

def git_ignore
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
  TXT
end

# Main setup
########################################
source_paths

add_gems

after_bundle do
  add_devise_users
  add_simple_form
  remove_app_css
  copy_templates
  add_tailwind
  copy_postcss_config
  generate_pages_controller
  git_ignore

  # Migrate
  ########################################
  rails_command 'db:drop db:create db:migrate'

  # Routes
  ########################################
  route "root to: 'pages#home'"

  # Create ENV file
  ########################################
  run 'touch .env'

  # First commit
  ########################################

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit with tailwind & devise" }

  # Fix puma config
  ########################################
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')

  # Complete!
  ########################################
  say
  say "Rails app with Tailwind & Devise successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
end
