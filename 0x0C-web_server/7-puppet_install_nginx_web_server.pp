# Install Nginx package
package { 'nginx':
  ensure => present,
}

# Ensure Nginx service is running
service { 'nginx':
  ensure => running,
  enable => true,
}

# create index.html file that contains the "Hello World!"
file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!',
}

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => 'Ceci n\'est pas une page',
}

# Configure Nginx server
$new_content = inline_template("
	location /redirect_me {
		return 301 http://google.com/:
	}
	error_page 404 /404.html;
	location /404 {
		root /var/www/html;
		internal;
	}
")

fine_line { 'append redirect block':
  path  => '/etc/nginx/sites-available/default',
  line  => $new_content,
  match => 'listen 80 default_server;',
}

# Restart Nginx service
service { 'nginx':
  require => File['/etc/nginx/sites-enabled/default'],
}
