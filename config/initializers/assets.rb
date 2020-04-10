# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( pias.js )

Rails.application.config.assets.precompile += %w( jquery )
Rails.application.config.assets.precompile += %w( fnr.js )
Rails.application.config.assets.precompile += %w( d3.v3.min.js )
Rails.application.config.assets.precompile += %w( jquery-ui-1.10.3.min.js )
