class Portal::NotificationController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def marked
    @notification.update(status:!@notification.status)
    render nothing:true
  end
end
