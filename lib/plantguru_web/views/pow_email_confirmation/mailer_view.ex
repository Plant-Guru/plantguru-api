defmodule PlantGuruWeb.PowEmailConfirmation.MailerView do
  use PlantGuruWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end