class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :zip,       :validate => true
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Inquiry from website | #{Time.now.strftime('%Y-%m-%d %l:%M %p')}",
      :to => "anne@belightfulyoga.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end