
#defining role for each user level
class Role
	def self.role(current_user_role)
		case current_user_role
		when "owner"
			return [["Owner", "owner"], ["Institution admin", "iadmin"], ["Institution staff", "istaff"], ["School Admin", "sadmin"], ["School Staff", "sstaff"], ["Mentor", "mentor"], ["Student","student"]]
		when "iadmin"
			return [["Institution staff", "istaff"], ["School Admin", "sadmin"], ["School Staff", "sstaff"], ["Mentor", "mentor"], ["Student","student"]]
		when "istaff"
			return [["School Admin", "sadmin"], ["School Staff", "sstaff"], ["Mentor", "mentor"], ["Student","student"]]
		when "sadmin"
			return [["School Staff", "sstaff"], ["Student","student"]]
		when "sstaff"
			return [["Student","student"]]
		end
	end
end