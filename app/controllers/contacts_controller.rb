class ContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create thanks]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.contact_mail(@contact).deliver_now
      redirect_to thanks_contact_path
    else
      flash.now[:alert] = "お問い合わせの送信に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def thanks
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
