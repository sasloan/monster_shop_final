require 'rails_helper'

describe 'As a Visitor' do
	it 'When I visit the app for the first time I see a welcome page' do

		visit root_path

		expect(page).to have_content("Welcome to Monster Shop")
	end
end
