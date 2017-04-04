class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end      