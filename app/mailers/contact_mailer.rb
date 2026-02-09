class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact

    mail(
      to: ENV.fetch("CONTACT_EMAIL"),
      subject: "【お問い合わせ】新しいお問い合わせが届きました",
      reply_to: contact.email
    )
  end
end
