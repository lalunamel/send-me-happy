namespace :db do
	desc "Totally reset the database"
	task :totalreset => :environment do
		sh "rake db:drop"
		sh "rake db:create"
		sh "rake db:migrate"
	end	

	desc "Totally reset both the dev and test database"
	task :allreset => :environment do
		sh "rake db:totalreset"
		sh "rake db:totalreset RAILS_ENV=test"
	end
	
end