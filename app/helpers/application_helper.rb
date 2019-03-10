module ApplicationHelper

	def owner
		current_user.role == "owner" ? true: false 
	end
end
