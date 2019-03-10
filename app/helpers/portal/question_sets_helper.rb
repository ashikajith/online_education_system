module Portal::QuestionSetsHelper
	def question_set_action(question_set)
		links = ""
    if can? :read, QuestionSet
		  links += link_to "show", portal_question_set_path(question_set)  
		  links += " | "
    end
    if can? :update, QuestionSet  
		  links += link_to "edit", edit_portal_question_set_path(question_set)
		  links += " | "
    end
    if can? :destroy, QuestionSet  
		  links += link_to "delete", portal_question_set_path(question_set),confirm:"Are youu sure", method:'delete'
    end  
		return links
	end
end
