# Rails 6 Template - Tailwind & Devise w. Simple Form

A Rails 6 application template for rapid application development utilising Tailwind CSS, Devise, and Simple Form.

Based on https://github.com/justalever/kickoff_tailwind, tweaked for simple_form.

### Included gems

- [devise](https://github.com/plataformatec/devise)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [font-awesome-sass](https://github.com/FortAwesome/font-awesome-sass)
- [simple_form](https://github.com/heartcombo/simple_form)
- [byebug](https://github.com/deivid-rodriguez/pry-byebug)
- [dot-env](https://github.com/bkeepers/dotenv)

### Creating a new app

```bash
$ rails new sample_app -d postgresql -m template.rb
```

### Once installed what do I get?

- Webpack support + Tailwind CSS configured in the `app/javascript` directory.
- Devise with a new `username` and `name` field already migrated in. Enhanced views using Tailwind CSS.
- Custom defaults for button and form elements from https://github.com/justalever/kickoff_tailwind
- Gitignore file comes configured, ready for your first push!

### Boot it up

`$ rails server`
