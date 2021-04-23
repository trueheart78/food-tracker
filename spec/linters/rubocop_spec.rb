# frozen_string_literal: true

RSpec.describe 'RuboCop Analysis', type: :feature do
  subject(:report) { `rubocop` }

  it 'has no offenses' do
    expect(report).to match(/no\ offenses\ detected/)
  end
end
