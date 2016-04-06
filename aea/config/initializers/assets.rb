# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
 Rails.application.config.assets.precompile += [
   'owl.carousel.min.js', 'mousescroll.js', 'smoothscroll.js',  'jquery.prettyPhoto.js', 'user.js', 'admin.js',
   'bootstrap-datepicker', 'bootstrap-timepicker',
   'jquery.isotope.min.js', 'jquery.inview.min.js', 'wow.min.js', "font-awesome.css", 'bootstrap-datepicker.css',
   "animate.min.css", "owl.carousel.css", "owl.transitions.css", "prettyPhoto.css", "responsive.css"
 ]
