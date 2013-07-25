# defaults
# could also use (in application.rb)  config.paperclip = {hash of options}

Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = "#{::Rails.root.to_s}/config/s3.yml"
# Paperclip::Attachment.default_options[:styles] = { :large => "640x640>", 
#                                                   :medium => "240x240>", 
#                                                   :thumb => "56x56>", 
#                                                   :tiny => "28x28>"  }
