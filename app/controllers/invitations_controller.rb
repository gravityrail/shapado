class InvitationsController < ApplicationController
  before_filter :login_required, :except => :accept

  def index
  end

  def create
    emails = params[:invitations][:emails].split(',')
    emails.each do |email|
      invitation = current_user.invite(email, current_group)
      Jobs::Mailer.async.on_new_invitation(invitation.id).commit!
    end
  end

  def accept
    @invitation = Invitation.find(params[:id])
    @group = @invitation.group
    @inviter = @invitation.user
    if @group.is_email_only_signup?
      redirect_to new_user_path(:invitations_id => params[:id])
    elsif logged_in? && current_user.created_at < 1.day.ago
      current_user.accept_invitation(@invitation.id)
      redirect_to '/'
    end
  end

  def revoke
    invitation = Invitation.find(params[:id])
    current_user.revoke_invite(invitation)
    return_to :back
  end
end
