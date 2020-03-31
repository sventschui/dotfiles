# Ansible DECrypt ALL vault files
function adecall {
    ansible-vault decrypt inventories/*/group_vars/all/vault.yml
}

# Ansible ENCrypt ALL vault files
function aencall {
    ansible-vault encrypt inventories/*/group_vars/all/vault.yml
}
