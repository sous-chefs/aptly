# frozen_string_literal: true

name 'aptly'

run_list 'recipe[test::setup]', 'recipe[test::default]'

cookbook 'aptly', path: '.'
cookbook 'gpg', git: 'https://github.com/sous-chefs/gpg.git', branch: 'main'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'
cookbook 'aptly_spec', path: './spec/fixtures/cookbooks/aptly_spec'
cookbook 'test', path: './test/cookbooks/test'

Dir.children('./spec/fixtures/cookbooks/aptly_spec/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, 'aptly_spec::' + recipe_name
end

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, 'test::' + recipe_name
end
