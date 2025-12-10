resource "aws_instance" "frontend" {
  ami           = "ami-0c02fb55956c7d316"   # Amazon Linux
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name     = "Frontend-Server"
    Hostname = "c8.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname c8.local
              EOF
}

resource "aws_instance" "backend" {
  ami           = "ami-0557a15b87f6559cf"   # Ubuntu 21.04
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name     = "Backend-Server"
    Hostname = "u21.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname u21.local
              EOF
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    frontend_ip = aws_instance.frontend.public_ip
    backend_ip  = aws_instance.backend.public_ip
  })
}
