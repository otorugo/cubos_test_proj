
resource "aws_instance" "app_machine" {
  ami                         = var.ami_ubuntu_id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [var.ec2_security_group_id]
  subnet_id                   = var.public_subnet_id
  iam_instance_profile        = var.instance_profile_name
  key_name                    = var.key_name
  user_data_replace_on_change = true
  user_data                   = <<-EOF
          #!/bin/bash
          cd /home/ubuntu
          sudo apt update
          sudo apt install apt-transport-https ca-certificates curl software-properties-common -y &&
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
          sudo apt update
          apt-cache policy docker-ce
          sudo apt install docker-ce -y
          sudo usermod -aG docker ubuntu
          sudo systemctl enable docker.service
          sudo apt install docker-compose -y
          sudo apt install unzip -y
          sudo apt install git -y
          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -q awscliv2.zip
          sudo ./aws/install
          git clone https://github.com/otorugo/cubos_test.git
          cd cubos_test
          aws s3api --region us-east-1 get-object --bucket cubos-test --key .env_backend ./backend/.env
          aws s3api --region us-east-1 get-object --bucket cubos-test --key .env_compose .env
          bash compile_init_containers.sh
          EOF

  tags = {
    Name = "ec2_test_cubos"
  }


}

resource "aws_eip" "ec2_eip" {
  tags = {
    Name = "ec2_test_cubos"
  }
  instance = aws_instance.app_machine.id
}
