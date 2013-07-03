namespace :reset do
	desc "Totally reset the database"
	task :really => :environment do
		sh "rake db:drop"
		sh "rake db:create"
		sh "rake db:migrate"
	end	
end