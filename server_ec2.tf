# ec2用ami
module "server_ami" {
  source = "./modules"
}
resource "aws_instance" "web" {
  ami             = module.server_ami.ami_id
  instance_type   = "t3.nano"
  subnet_id       = aws_subnet.private_subnet.id
  key_name        = aws_key_pair.basation_key_pair.id
  security_groups = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
  user_data       = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y nginx
  sudo sh -c 'cat << EOS > /etc/nginx/sites-available/default
server {
    listen 8080;
    location /app {
        # APPリクエストをAPPサーバーへリダイレクト
        proxy_pass http://10.10.64.159:3031;
    }
}
'
  sudo ufw allow 'Nginx HTTP'
  sudo systemctl reload nginx
  EOF
  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "app" {
  ami = module.server_ami.ami_id

  instance_type   = "t3.nano"
  subnet_id       = aws_subnet.private_subnet.id
  key_name        = aws_key_pair.basation_key_pair.id
  security_groups = [aws_security_group.ssh_sg.id, aws_security_group.app_sg.id]
  user_data       = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y python3-pip python3-venv build-essential python-dev
  sudo apt install uwsgi-core
  pip3 install uwsgi
  sudo mkdir -p /var/www/uwsgi
  sudo sh -c 'cat << EOS > /var/www/uwsgi/index.py
def application(env, start_response):
    start_response("200 OK", [("Content-Type","text/html")])
    return [b"Hello World"]
'
  uwsgi --http-socket :3031 --wsgi-file /var/www/uwsgi/index.py &
  EOF

  tags = {
    Name = "appserver"
  }
}


