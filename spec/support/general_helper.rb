module GeneralHelper
	def expect_validation_error_on(target, attribute, expected_error_message) 
		expect(target.save).to be_false
		expect(target.errors.count).to eq 1
		expect(target.errors[attribute].count).to eq 1
		expect(target.errors[attribute].first).to eq expected_error_message
	end

	def expect_save_and_validate(target)
		expect(target.save).to be_true
		expect(target.errors.count).to eq 0
		expect(target.class.order("created_at").last).to eq target
	end

	def stub_time
		now = Time.now
		Time.stub(:now) { now }
	end
end