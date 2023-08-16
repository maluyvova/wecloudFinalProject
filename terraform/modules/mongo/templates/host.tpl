all: 
  hosts:               
    mongodb: 
      ansible_ssh_user: ubuntu
      ansible_host: "${host}"
