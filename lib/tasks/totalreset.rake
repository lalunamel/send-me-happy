namespace :db do
	desc "Totally reset the database"
	task :totalreset => :environment do
		sh "rake db:drop"
		sh "rake db:create"
		sh "rake db:migrate"
	end	
end