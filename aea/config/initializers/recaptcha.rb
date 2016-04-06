# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.public_key  = '6LefKBsTAAAAAFZEHA-mku3o9sa-HzOsQhJPXnnv'
  config.private_key = '6LefKBsTAAAAAMAmvNrULyOy5BcS_VvQynkrnSt6'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end