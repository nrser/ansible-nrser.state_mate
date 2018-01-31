require 'fileutils'
require 'yaml'

require 'cmds'

require 'nrser/refinements'

using NRSER

ROOT = NRSER.git_root __FILE__
ANSIBLE_DIR = ROOT + 'test' + 'ansible'
ROLES_DIR = ANSIBLE_DIR + 'roles'
ROLE_DIR = ROLES_DIR + 'nrser.state_mate'
TEMPLATE_PATH = ANSIBLE_DIR + 'template.yml'
PLAYBOOK_PATH = ANSIBLE_DIR + 'temp-playbook.yml'

DOMAIN = 'com.nrser.state_mate.ansible'

def playbook options = {}
  data = YAML.load TEMPLATE_PATH.read
  
  [:name, :vars, :roles, :tasks].each do |sym|
    data[0][sym.to_s] = options[sym] if options.key? sym
  end
  
  PLAYBOOK_PATH.open('w') do |f|
    f.write YAML.dump(data)
  end
  
  result = Dir.chdir ANSIBLE_DIR do
    Cmds 'ansible-playbook %{path}', path: PLAYBOOK_PATH
  end
  
  unless result.ok?
    raise binding.erb <<-END
      error executing playbook
      
      path: <%= PLAYBOOK_PATH %>
      
      out:
      
      <%= result.out.indent %>
      
      err:
      
      <%= result.err.indent %>
    END
  end
end
