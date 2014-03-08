require "spec_helper"

# Write unit tests with ChefSpec - https://github.com/sethvargo/chefspec#readme
describe "drupal-lamp::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "logs a sample message" do
    expect(chef_run).to write_log "replace this with a meaningful resource"
  end

  it "does something" do
    pending "Replace this with meaningful tests"
  end
end
