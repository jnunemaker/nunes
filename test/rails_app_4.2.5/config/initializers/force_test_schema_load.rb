if Rails.env.test?
  load "#{Rails.root}/db/schema.rb"
end
