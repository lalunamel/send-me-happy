namespace :db do
	desc "Totally reset the database"
	task :totalreset => :environment do
		sh "rake db:drop"
		sh "rake db:create"
		sh "rake db:migrate"
		sh "rake db:seed"
	end	

	desc "Totally reset both the dev and test database"
	task :resetall => :environment do
		sh "rake db:totalreset"
		sh "rake db:totalreset RAILS_ENV=test"
	end
	
end