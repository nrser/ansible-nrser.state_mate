require 'nrser/refinements'

require 'spec_helper'
require 'state_mate/adapters/defaults'

using NRSER

describe "nrser.state_mate:defaults" do
  let(:defaults) {
    StateMate::Adapters::Defaults
  }

  before(:all) {
    # copy the role stuff
    FileUtils.rm_r ROLE_DIR if ROLE_DIR.exist?
    FileUtils.mkdir_p ROLE_DIR
    ['defaults', 'handlers', 'library', 'meta', 'tasks', 'vars'].each do |dir|
      dest = ROLE_DIR + dir
      FileUtils.rm_r dest if dest.exist?
      FileUtils.cp_r (ROOT + dir), dest
    end
  }

  before(:each) {
    # this will error if the domain is missing
    Cmds 'defaults delete %{domain}', domain: DOMAIN
  }

  VALUES = {
    boolean: [true, false],
    float: [24.0],
    string: ["yes"],
    # hash: [{'x' => true, 'y' => 'why'}],
  }

  VALUES.each do |type_name, values|
    context type_name do
      values.each do |value|
        it "sets the #{ type_name } literal value #{ value.inspect }" do |ex|
          playbook tasks: [
            'name' => ex.description,
            'state' => {
              'defaults' => {
                'key' => "#{ DOMAIN }:#{ type_name }",
                'set' => value
              }
            }
          ]

          expect( defaults.read [DOMAIN, type_name.to_s] ).to eq value
        end

        it "sets the #{ type_name } variable value #{ value.inspect }" do |ex|
          playbook vars: {
              'value' => value,
            },
            tasks: [
              'name' => ex.description,
              'state' => {
                'defaults' => {
                  'key' => "#{ DOMAIN }:#{ type_name }",
                  'set' => '{{ value }}',
                  'type' => type_name.to_s,
                }
              }
            ]

          expect( defaults.read [DOMAIN, type_name.to_s] ).to eq value
        end
      end
    end
  end

  # it "sets a float using a literal" do
  #   value = 24
  #
  #   playbook(
  #     tasks: [
  #       'name' => 'set float with literal',
  #       'state' => {
  #         'defaults' => {
  #           'key' => "#{ DOMAIN }:float",
  #           'set' => value,
  #         }
  #       }
  #     ]
  #   )
  #
  #   expect( defaults.read [DOMAIN, 'float'] ).to eq value
  # end
  #
  # it "sets a float using a variable" do
  #   value = 24
  #
  #   playbook(
  #     vars: {
  #       'value' => value,
  #     },
  #     tasks: [
  #       'name' => 'set float with literal',
  #       'state' => {
  #         'defaults' => {
  #           'key' => "#{ DOMAIN }:float",
  #           'set' => "{{ value }}",
  #         }
  #       }
  #     ]
  #   )
  #
  #   expect( defaults.read [DOMAIN, 'float'] ).to eq value
  # end
end
