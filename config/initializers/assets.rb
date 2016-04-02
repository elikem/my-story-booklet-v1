# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Precompile Bootstrap
Rails.application.config.assets.precompile += %w( bootstrap/bootstrap.min.js )

# Precompile Material Design
Rails.application.config.assets.precompile += %w(
  static.css
  static.js
  material_design/ie8-responsive-file-warning.js
  material_design/jquery.flexslider-min.js
  material_design/waypoints.min.js
  material_design/stellar.js
  material_design/owl.carousel.min.js
  material_design/jquery.localscroll.min.js
  material_design/jquery.scrollto.min.js
  material_design/validator.min.js
  material_design/jquery.form.min.js
  material_design/isotope.pkgd.min.js
  material_design/scripts.js
)

# Precompile Blueprint
Rails.application.config.assets.precompile += %w(
  blueprint/plugins.min.js
  blueprint/jvectormap.js
  blueprint/scripts.js
)

# Precompile Static controller
Rails.application.config.assets.precompile += %w( static_pages.css static_pages.js )