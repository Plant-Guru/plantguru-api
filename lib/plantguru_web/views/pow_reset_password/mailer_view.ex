defmodule PlantGuruWeb.PowResetPassword.MailerView do
  use PlantGuruWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
