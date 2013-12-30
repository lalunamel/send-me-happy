require 'clockwork'
module Clockwork
  # handler receives the time when job is prepared to run in the 2nd argument
  handler do |job, time|
    require './config/boot'
    require './config/environment'

    if job == 'sendMessages.job'
      # for all active users
      for user in User.where(:active => true) 
        lastMessage = user.messages.order(created_at: :asc).last
        lastMessageTime = lastMessage != nil ? lastMessage.created_at : 30.days.ago
        secondsSinceLastMessage = Time.now - lastMessageTime
        daysSinceLastMessage = secondsSinceLastMessage*1.15741e-5 #thanks for the conversion, google!
        # if the user has not received a message in a while
        if daysSinceLastMessage > user.message_frequency
          userTemplates = Template.where(classification: "user")
          message_template = userTemplates.offset(rand(userTemplates.count)).first
          sender = MessageSenderService.new user: user, template: message_template

          logger.info "Sending message to #{user.id} at #{Time.now}"
          sender.deliver_message
        end
      end
    end
  end

  every(1.day, 'sendMessages.job', :at => '12:00')
  # every(1.minutes, 'sendMessages.job')
end